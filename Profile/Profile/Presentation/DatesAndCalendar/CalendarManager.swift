//
//  CalendarManager.swift
//  Profile
//
//  Created by  Stepanok Ivan on 12.06.2024.
//

import SwiftUI
@preconcurrency import Combine
@preconcurrency import EventKit
import Theme
import BranchSDK
import CryptoKit
import Core
import OEXFoundation

// MARK: - CalendarManager
public final class CalendarManager: CalendarManagerProtocol {

    let eventStore = EKEventStore()
    private let alertOffset = -1
    private let persistence: ProfilePersistenceProtocol
    private let interactor: ProfileInteractorProtocol
    private nonisolated(unsafe) var profileStorage: ProfileStorage
    
    public init(
        persistence: ProfilePersistenceProtocol,
        interactor: ProfileInteractorProtocol,
        profileStorage: ProfileStorage
    ) {
        self.persistence = persistence
        self.interactor = interactor
        self.profileStorage = profileStorage
    }
    
    var authorizationStatus: EKAuthorizationStatus {
        return EKEventStore.authorizationStatus(for: .event)
    }
    
    var calendarName: String {
        profileStorage.calendarSettings?.calendarName
        ?? ProfileLocalization.Calendar.courseDates((Bundle.main.applicationName ?? ""))
    }
    
    var colorSelection: DropDownPicker.DownPickerOption? {
        .init(
            color: DropDownColor(
                rawValue: profileStorage.calendarSettings?.colorSelection ?? ""
            ) ?? .accent
        )
    }
    
    var calendarSource: EKSource? {
        eventStore.refreshSourcesIfNecessary()
        
        let iCloud = eventStore.sources.first(
            where: { $0.sourceType == .calDAV && $0.title.localizedCaseInsensitiveContains("icloud") })
        let local = eventStore.sources.first(where: { $0.sourceType == .local })
        let fallback = eventStore.defaultCalendarForNewEvents?.source
        guard let accountSelection = profileStorage.calendarSettings?.accountSelection else {
            return iCloud ?? local ?? fallback
        }
        switch accountSelection {
        case ProfileLocalization.Calendar.Dropdown.icloud:
            return iCloud ?? local ?? fallback
        case ProfileLocalization.Calendar.Dropdown.local:
            return fallback ?? local
        default:
            return iCloud ?? local ?? fallback
        }
    }
    
    var calendar: EKCalendar? {
        eventStore.calendars(for: .event).first(where: { $0.title == calendarName })
    }
    
    public func courseStatus(courseID: String) async -> SyncStatus {
        let states = await persistence.getAllCourseStates()
        if states.contains(where: { $0.courseID == courseID }) {
            return .synced
        } else {
            return .offline
        }
    }
 
    public func createCalendarIfNeeded() {
        if eventStore.calendars(for: .event).first(where: { $0.title == calendarName }) == nil {
            let calendar = EKCalendar(for: .event, eventStore: eventStore)
            calendar.title = calendarName
            
            if let swiftUIColor = colorSelection?.color {
                let uiColor = UIColor(swiftUIColor)
                calendar.cgColor = uiColor.cgColor
            } else {
                calendar.cgColor = Theme.Colors.accentColor.cgColor
            }
            
            calendar.source = calendarSource
            do {
                try eventStore.saveCalendar(calendar, commit: true)
            } catch {
                print(">>>> 🥷", error)
            }
        }
    }
    
    public func isDatesChanged(courseID: String, checksum: String) async -> Bool {
        guard let oldState = await persistence.getCourseState(courseID: courseID) else { return false }
        return checksum != oldState.checksum
    }
    
    public func syncCourse(courseID: String, courseName: String, dates: CourseDates) async {
        createCalendarIfNeeded()
        guard let calendar else { return }
        if saveEvents(for: dates.dateBlocks, courseID: courseID, courseName: courseName, calendar: calendar) {
            await saveCourseDatesChecksum(courseID: courseID, checksum: dates.checksum)
        } else {
            debugLog("Failed to sync calendar for courseID: \(courseID)")
        }
    }
    
    public func removeOutdatedEvents(courseID: String) async {
        let events = await persistence.getCourseCalendarEvents(for: courseID)
        for event in events {
            deleteEventFromCalendar(eventIdentifier: event.eventIdentifier)
        }
        if let state = await persistence.getCourseState(courseID: courseID) {
           await persistence.saveCourseState(state: CourseCalendarState(courseID: state.courseID, checksum: ""))
        }
        await persistence.removeCourseCalendarEvents(for: courseID)
    }
    
    func deleteEventFromCalendar(eventIdentifier: String) {
        if let event = self.eventStore.event(withIdentifier: eventIdentifier) {
            do {
                try self.eventStore.remove(event, span: .thisEvent)
            } catch let error {
                debugLog("Failed to remove event: \(error)")
            }
        }
    }
    
    public func requestAccess() async -> Bool {
        if #available(iOS 17.0, *) {
            do {
                return try await eventStore.requestFullAccessToEvents()
            } catch {
                debugLog(error)
                return false
            }
        } else {
            return await withCheckedContinuation { continuation in
                eventStore.requestAccess(to: .event) { granted, _ in
                    if granted {
                        continuation.resume(returning: true)
                    } else {
                        continuation.resume(returning: false)
                    }
                }
            }
        }
    }
    
    public func clearAllData(removeCalendar: Bool) async {
        await persistence.deleteAllCourseStatesAndEvents()
        if removeCalendar {
            removeOldCalendar()
        }
        profileStorage.firstCalendarUpdate = false
        profileStorage.hideInactiveCourses = nil
        profileStorage.lastCalendarName = nil
        profileStorage.calendarSettings = nil
        profileStorage.lastCalendarUpdateDate = nil
    }
    
    private func saveCourseDatesChecksum(courseID: String, checksum: String) async {
        var states = await persistence.getAllCourseStates()
        states.append(CourseCalendarState(courseID: courseID, checksum: checksum))
        for state in states {
            await persistence.saveCourseState(state: state)
        }
    }
    
    private func saveEvents(
        for dateBlocks: [Date: [CourseDateBlock]],
        courseID: String,
        courseName: String,
        calendar: EKCalendar
    ) -> Bool {
        let events = generateEvents(for: dateBlocks, courseName: courseName, calendar: calendar)
        var saveSuccessful = true
        events.forEach { event in
            if !eventExists(event, in: calendar) {
                do {
                    try eventStore.save(event, span: .thisEvent)
                    Task {
                        await persistence.saveCourseCalendarEvent(
                            CourseCalendarEvent(courseID: courseID, eventIdentifier: event.eventIdentifier)
                        )
                    }
                } catch {
                    saveSuccessful = false
                }
            }
        }
        return saveSuccessful
    }
    
    private func eventExists(_ event: EKEvent, in calendar: EKCalendar) -> Bool {
        let predicate = eventStore.predicateForEvents(
            withStart: event.startDate,
            end: event.endDate,
            calendars: [calendar]
        )
        let existingEvents = eventStore.events(matching: predicate)
        
        return existingEvents.contains { existingEvent in
            existingEvent.title == event.title &&
            existingEvent.startDate == event.startDate &&
            existingEvent.endDate == event.endDate &&
            existingEvent.notes == event.notes
        }
    }
    
    public func filterCoursesBySelected(fetchedCourses: [CourseForSync]) async -> [CourseForSync] {
        let courseCalendarStates = await persistence.getAllCourseStates()
        if !courseCalendarStates.isEmpty {
            let coursesToDelete = courseCalendarStates.filter { course in
                !fetchedCourses.contains { $0.courseID == course.courseID }
            }
            let inactiveCourses = fetchedCourses.filter { course in
                courseCalendarStates.contains { $0.courseID == course.courseID } && !course.recentlyActive
            }
            
            for course in coursesToDelete {
                await removeOutdatedEvents(courseID: course.courseID)
            }
            
            for course in inactiveCourses {
                await removeOutdatedEvents(courseID: course.courseID)
            }
            
            return fetchedCourses.filter { course in
                courseCalendarStates.contains { $0.courseID == course.courseID }  && course.recentlyActive
            }
        } else {
            return fetchedCourses
        }
    }
    
    private func generateEvents(
        for dateBlocks: [Date: [CourseDateBlock]],
        courseName: String,
        calendar: EKCalendar
    ) -> [EKEvent] {
        var events: [EKEvent] = []
        dateBlocks.forEach { item in
            let blocks = item.value
            if blocks.count > 1 {
                if let generatedEvent = calendarEvent(for: blocks, courseName: courseName, calendar: calendar) {
                    events.append(generatedEvent)
                }
            } else {
                if let block = blocks.first {
                    if let generatedEvent = calendarEvent(for: block, courseName: courseName, calendar: calendar) {
                        events.append(generatedEvent)
                    }
                }
            }
        }
        return events
    }
    
    private func calendarEvent(for block: CourseDateBlock, courseName: String, calendar: EKCalendar) -> EKEvent? {
        guard !block.title.isEmpty else { return nil }
        
        let title = block.title
        let startDate = block.date.addingTimeInterval(Double(alertOffset) * 3600)
        let secondAlert = startDate.addingTimeInterval(Double(alertOffset) * 86400)
        let endDate = block.date
        var notes = "\(calendar.title)\n\n\(block.title)"
        
        if let link = generateDeeplink(componentBlockID: block.firstComponentBlockID) {
            notes += "\n\(link)"
        }
        
        return generateEvent(
            title: title,
            startDate: startDate,
            endDate: endDate,
            secondAlert: secondAlert,
            notes: notes,
            location: courseName,
            calendar: calendar
        )
    }

    private func calendarEvent(for blocks: [CourseDateBlock], courseName: String, calendar: EKCalendar) -> EKEvent? {
        guard let block = blocks.first, !block.title.isEmpty else { return nil }
        
        let title = block.title
        let startDate = block.date.addingTimeInterval(Double(alertOffset) * 3600)
        let secondAlert = startDate.addingTimeInterval(Double(alertOffset) * 86400)
        let endDate = block.date
        let notes = "\(calendar.title)\n\n" + blocks.compactMap { block -> String in
            if let link = generateDeeplink(componentBlockID: block.firstComponentBlockID) {
                return "\(block.title)\n\(link)"
            } else {
                return block.title
            }
        }.joined(separator: "\n\n")
        
        return generateEvent(
            title: title,
            startDate: startDate,
            endDate: endDate,
            secondAlert: secondAlert,
            notes: notes,
            location: courseName,
            calendar: calendar
        )
    }

    private func removeCalendar(for courseID: String, calendarName: String, completion: ((Bool) -> Void)? = nil) {
        guard let calendar = localCalendar(for: courseID, calendarName: calendarName) else { completion?(true); return }
        do {
            try eventStore.removeCalendar(calendar, commit: true)
            Task {
                await persistence.removeCourseCalendarEvents(for: courseID)
            }
            completion?(true)
        } catch {
            completion?(false)
        }
    }
    
    private func localCalendar(for courseID: String, calendarName: String) -> EKCalendar? {
        if authorizationStatus != .authorized { return nil }
        let calendarName = "\(calendarName) - \(courseID)"
        var calendars = eventStore.calendars(for: .event).filter { $0.title == calendarName }
        if calendars.isEmpty {
            return nil
        } else {
            let calendar = calendars.removeLast()
            calendars.forEach { try? eventStore.removeCalendar($0, commit: true) }
            return calendar
        }
    }
    
    private func generateDeeplink(componentBlockID: String) -> String? {
        guard !componentBlockID.isEmpty else {
            return nil
        }
        let branchUniversalObject = BranchUniversalObject(
            canonicalIdentifier: "\(CalendarDeepLinkType.courseComponent.rawValue)/\(componentBlockID)"
        )
        let dictionary: NSMutableDictionary = [
            CalendarDeepLinkKeys.screenName.rawValue: CalendarDeepLinkType.courseComponent.rawValue,
            CalendarDeepLinkKeys.courseID.rawValue: profileStorage.calendarSettings?.calendarName ?? "",
            CalendarDeepLinkKeys.componentID.rawValue: componentBlockID
        ]
        let metadata = BranchContentMetadata()
        metadata.customMetadata = dictionary
        branchUniversalObject.contentMetadata = metadata
        let properties = BranchLinkProperties()
        let shortUrl = branchUniversalObject.getShortUrl(with: properties)
        return shortUrl
    }

    private func generateEvent(
        title: String,
        startDate: Date,
        endDate: Date,
        secondAlert: Date,
        notes: String,
        location: String,
        calendar: EKCalendar
    ) -> EKEvent {
        let event = EKEvent(eventStore: eventStore)
        event.title = title
        event.location = location
        event.startDate = startDate
        event.endDate = endDate
        event.calendar = calendar
        event.notes = notes
        
        if startDate > Date() {
            let alarm = EKAlarm(absoluteDate: startDate)
            event.addAlarm(alarm)
        }
        
        if secondAlert > Date() {
            let alarm = EKAlarm(absoluteDate: secondAlert)
            event.addAlarm(alarm)
        }
        return event
    }

    public func removeOldCalendar() {
        guard let lastCalendarName = profileStorage.lastCalendarName else { return }
        if let oldCalendar = eventStore.calendars(for: .event).first(where: { $0.title == lastCalendarName }) {
            do {
                try eventStore.removeCalendar(oldCalendar, commit: true)
                debugLog("Old calendar '\(lastCalendarName)' removed successfully")
            } catch {
                debugLog("Failed to remove old calendar '\(lastCalendarName)': \(error.localizedDescription)")
            }
        } else {
            debugLog("Old calendar '\(lastCalendarName)' not found")
        }
        profileStorage.lastCalendarName = nil
    }
}

// MARK: - Enums and Constants

enum CalendarDeepLinkType: String {
    case courseComponent = "course_component"
}

private enum CalendarDeepLinkKeys: String, RawStringExtractable {
    case courseID = "course_id"
    case screenName = "screen_name"
    case componentID = "component_id"
}

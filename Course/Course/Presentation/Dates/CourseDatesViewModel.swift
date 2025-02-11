//
//  CourseDatesViewModel.swift
//  Course
//
//  Created by Muhammad Umer on 10/18/23.
//

import Foundation
import Core
import SwiftUI
import OEXFoundation

@MainActor
public class CourseDatesViewModel: ObservableObject {
    
    enum EventState: Sendable {
        case addedCalendar
        case removedCalendar
        case updatedCalendar
        case shiftedDueDates
        case none
    }
    
    @Published var isShowProgress = true
    @Published var showError: Bool = false
    @Published var courseDates: CourseDates?
    @Published var isOn: Bool = false
    @Published var eventState: EventState?

    var errorMessage: String? {
        didSet {
            withAnimation {
                showError = errorMessage != nil
            }
        }
    }
    
    private let interactor: CourseInteractorProtocol
    let cssInjector: CSSInjector
    let router: CourseRouter
    let connectivity: ConnectivityProtocol
    let config: ConfigProtocol
    let courseID: String
    let courseName: String
    var courseStructure: CourseStructure?
    let analytics: CourseAnalytics
    let calendarManager: CalendarManagerProtocol
    
    public init(
        interactor: CourseInteractorProtocol,
        router: CourseRouter,
        cssInjector: CSSInjector,
        connectivity: ConnectivityProtocol,
        config: ConfigProtocol,
        courseID: String,
        courseName: String,
        analytics: CourseAnalytics,
        calendarManager: CalendarManagerProtocol
    ) {
        self.interactor = interactor
        self.router = router
        self.cssInjector = cssInjector
        self.connectivity = connectivity
        self.config = config
        self.courseID = courseID
        self.courseName = courseName
        self.analytics = analytics
        self.calendarManager = calendarManager
        addObservers()
    }
        
    var sortedStatuses: [CompletionStatus] {
        let desiredSequence = [
            CompletionStatus.completed,
            CompletionStatus.pastDue,
            CompletionStatus.today,
            CompletionStatus.thisWeek,
            CompletionStatus.nextWeek,
            CompletionStatus.upcoming
        ]
        
        // Filter out keys that don't exist in the dictionary
        let filteredKeys = desiredSequence.filter {
            courseDates?.statusDatesBlocks.keys.contains($0) ?? false }
        return filteredKeys
    }
    
    @MainActor
    func getCourseDates(courseID: String) async {
        isShowProgress = true
        do {
            courseDates = try await interactor.getCourseDates(courseID: courseID)
            await getCourseStructure(courseID: courseID)
            if courseDates?.courseDateBlocks == nil {
                isShowProgress = false
                courseDates = nil
                return
            }
            isShowProgress = false
        } catch {
            isShowProgress = false
            courseDates = nil
        }
    }
    
    func showCourseDetails(componentID: String, blockLink: String) async {
        do {
            let courseStructure = try await interactor.getLoadedCourseBlocks(courseID: courseID)
            router.showCourseComponent(
                componentID: componentID,
                courseStructure: courseStructure,
                blockLink: blockLink
            )
        } catch _ {
            errorMessage = CourseLocalization.Error.componentNotFount
        }
    }
    
    @MainActor
    func getCourseStructure(courseID: String) async {
        do {
            courseStructure = try await interactor.getLoadedCourseBlocks(courseID: courseID)
        } catch _ {
            errorMessage = CourseLocalization.Error.componentNotFount
        }
    }
    
    func syncStatus() async -> SyncStatus {
       return await calendarManager.courseStatus(courseID: courseID)
    }
    
    @MainActor
    func shiftDueDates(courseID: String, withProgress: Bool = true, screen: DatesStatusInfoScreen, type: String) async {
        isShowProgress = withProgress
        do {
            try await interactor.shiftDueDates(courseID: courseID)
            NotificationCenter.default.post(name: .shiftCourseDates, object: (courseID, courseName))
            isShowProgress = false
            trackPLSuccessEvent(
                .plsShiftDatesSuccess,
                bivalue: .plsShiftDatesSuccess,
                courseID: courseID,
                screenName: screen.rawValue,
                type: type,
                success: true
            )
        } catch let error {
            trackPLSuccessEvent(
                .plsShiftDatesSuccess,
                bivalue: .plsShiftDatesSuccess,
                courseID: courseID,
                screenName: screen.rawValue,
                type: type,
                success: false
            )
            isShowProgress = false
            if error.isInternetError || error is NoCachedDataError {
                errorMessage = CoreLocalization.Error.slowOrNoInternetConnection
            } else {
                errorMessage = CoreLocalization.Error.unknownError
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension CourseDatesViewModel {
    private func addObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleShiftDueDates),
            name: .shiftCourseDates, object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(getCourseDates),
            name: .getCourseDates, object: nil
        )
    }
    
    @objc private func getCourseDates(_ notification: Notification) {
        Task {
            await getCourseDates(courseID: courseID)
        }
    }
    
    @objc private func handleShiftDueDates(_ notification: Notification) {
        if let courseID = notification.object as? String {
            Task {
                await getCourseDates(courseID: courseID)
                await MainActor.run { [weak self] in
                    self?.eventState = .shiftedDueDates
                }
            }
        }
    }
    
    func resetEventState() {
        eventState = EventState.none
    }
}

extension CourseDatesViewModel {
    
    func logdateComponentTapped(block: CourseDateBlock, supported: Bool) {
        analytics.datesComponentTapped(
            courseId: courseID,
            blockId: block.firstComponentBlockID,
            link: block.link,
            supported: supported
        )
    }
    
    func trackPLSEvent(
        _ event: AnalyticsEvent,
        bivalue: EventBIValue,
        courseID: String,
        screenName: String,
        type: String
    ) {
        analytics.plsEvent(
            event,
            bivalue: bivalue,
            courseID: courseID,
            screenName: screenName,
            type: type
        )
    }
    
    private func trackPLSuccessEvent(
        _ event: AnalyticsEvent,
        bivalue: EventBIValue,
        courseID: String,
        screenName: String,
        type: String,
        success: Bool
    ) {
        analytics.plsSuccessEvent(
            event,
            bivalue: bivalue,
            courseID: courseID,
            screenName: screenName,
            type: type,
            success: success
        )
    }
}

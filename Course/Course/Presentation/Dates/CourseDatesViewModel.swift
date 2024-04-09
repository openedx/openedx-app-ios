//
//  CourseDatesViewModel.swift
//  Course
//
//  Created by Muhammad Umer on 10/18/23.
//

import Foundation
import Core
import SwiftUI

public class CourseDatesViewModel: ObservableObject {
    
    enum EventState {
        case addedCalendar
        case removedCalendar
        case updatedCalendar
        case shiftedDueDates
        case none
    }
    
    @Published private(set) var isShowProgress = false
    @Published var showError: Bool = false
    @Published var courseDates: CourseDates?
    @Published var isOn: Bool = false
    @Published var eventState: EventState?
    
    lazy var calendar: CalendarManager = {
        return CalendarManager(
            courseID: courseID,
            courseName: courseStructure?.displayName ?? config.platformName,
            courseStructure: courseStructure,
            config: config
        )
    }()

    var errorMessage: String? {
        didSet {
            withAnimation {
                showError = errorMessage != nil
            }
        }
    }
    
    var calendarState: Bool {
        get {
            return calendar.syncOn
        }
        set {
            if newValue {
                trackCalendarSyncToggle(action: .on)
                handleCalendar()
            } else {
                trackCalendarSyncToggle(action: .off)
                showRemoveCalendarAlert()
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
    
    public init(
        interactor: CourseInteractorProtocol,
        router: CourseRouter,
        cssInjector: CSSInjector,
        connectivity: ConnectivityProtocol,
        config: ConfigProtocol,
        courseID: String,
        courseName: String,
        analytics: CourseAnalytics
    ) {
        self.interactor = interactor
        self.router = router
        self.cssInjector = cssInjector
        self.connectivity = connectivity
        self.config = config
        self.courseID = courseID
        self.courseName = courseName
        self.analytics = analytics
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
                errorMessage = CoreLocalization.Error.unknownError
                return
            }
            isShowProgress = false
            addCourseEventsIfNecessary()
        } catch let error {
            isShowProgress = false
            if error.isInternetError || error is NoCachedDataError {
                errorMessage = CoreLocalization.Error.slowOrNoInternetConnection
            } else {
                errorMessage = CoreLocalization.Error.unknownError
            }
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
            isOn = calendarState
        } catch _ {
            errorMessage = CourseLocalization.Error.componentNotFount
        }
    }
    
    @MainActor
    func shiftDueDates(courseID: String, withProgress: Bool = true, screen: DatesStatusInfoScreen, type: String) async {
        isShowProgress = withProgress
        do {
            try await interactor.shiftDueDates(courseID: courseID)
            NotificationCenter.default.post(name: .shiftCourseDates, object: courseID)
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
    private func handleCalendar() {
        calendar.requestAccess { [weak self] _, previousStatus, status in
            guard let self else { return }
            switch status {
            case .authorized:
                if previousStatus == .notDetermined {
                    trackCalendarSyncDialogAction(dialog: .devicePermission, action: .allow)
                }
                showAddCalendarAlert()
            default:
                if previousStatus == .notDetermined {
                    trackCalendarSyncDialogAction(dialog: .devicePermission, action: .doNotAllow)
                }
                isOn = false
                if previousStatus == status {
                    self.showCalendarSettingsAlert()
                }
            }
        }
    }
    
    @MainActor
    func addCourseEvents(trackAnalytics: Bool = true, completion: ((Bool) -> Void)? = nil) {
        guard let dateBlocks = courseDates?.dateBlocks else { return }
        showCalendarSyncProgressView { [weak self] in
            self?.calendar.addEventsToCalendar(for: dateBlocks) { [weak self] calendarEventsAdded in
                self?.isOn = calendarEventsAdded
                if calendarEventsAdded {
                    self?.calendar.syncOn = calendarEventsAdded
                    self?.router.dismiss(animated: false)
                    self?.showEventsAddedSuccessAlert()
                }
                completion?(calendarEventsAdded)
            }
        }
    }
    
    func removeCourseCalendar(trackAnalytics: Bool = true, completion: ((Bool) -> Void)? = nil) {
        calendar.removeCalendar { [weak self] success in
            guard let self else { return }
            self.isOn = !success
            completion?(success)
        }
    }
    
    private func showAddCalendarAlert() {
        router.presentAlert(
            alertTitle: CourseLocalization.CourseDates.addCalendarTitle,
            alertMessage: CourseLocalization.CourseDates.addCalendarPrompt(
                config.platformName,
                courseName
            ),
            positiveAction: CoreLocalization.Alert.accept,
            onCloseTapped: { [weak self] in
                self?.trackCalendarSyncDialogAction(dialog: .addCalendar, action: .cancel)
                self?.router.dismiss(animated: true)
                self?.isOn = false
                self?.calendar.syncOn = false
            },
            okTapped: { [weak self] in
                self?.trackCalendarSyncDialogAction(dialog: .addCalendar, action: .add)
                self?.router.dismiss(animated: true)
                Task { [weak self] in
                    await self?.addCourseEvents()
                }
            },
            type: .addCalendar
        )
    }
    
    private func showRemoveCalendarAlert() {
        router.presentAlert(
            alertTitle: CourseLocalization.CourseDates.removeCalendarTitle,
            alertMessage: CourseLocalization.CourseDates.removeCalendarPrompt(
                config.platformName,
                courseName
            ),
            positiveAction: CoreLocalization.Alert.accept,
            onCloseTapped: { [weak self] in
                self?.trackCalendarSyncDialogAction(dialog: .removeCalendar, action: .cancel)
                self?.router.dismiss(animated: true)
            },
            okTapped: { [weak self] in
                self?.trackCalendarSyncDialogAction(dialog: .removeCalendar, action: .remove)
                self?.router.dismiss(animated: true)
                self?.removeCourseCalendar { [weak self] _ in
                    self?.trackCalendarSyncSnackbar(snackbar: .removed)
                    self?.eventState = .removedCalendar
                }
                
            },
            type: .removeCalendar
        )
    }
    
    private func showEventsAddedSuccessAlert() {
        if calendar.isModalPresented {
            trackCalendarSyncSnackbar(snackbar: .added)
            eventState = .addedCalendar
            return
        }
        calendar.isModalPresented = true
        router.presentAlert(
            alertTitle: "",
            alertMessage: CourseLocalization.CourseDates.datesAddedAlertMessage(
                calendar.calendarName
            ),
            positiveAction: CourseLocalization.CourseDates.calendarViewEvents,
            onCloseTapped: { [weak self] in
                self?.trackCalendarSyncDialogAction(dialog: .eventsAdded, action: .done)
                self?.router.dismiss(animated: true)
                self?.isOn = true
                self?.calendar.syncOn = true
            },
            okTapped: { [weak self] in
                self?.trackCalendarSyncDialogAction(dialog: .eventsAdded, action: .viewEvent)
                self?.router.dismiss(animated: true)
                if let url = URL(string: "calshow://"), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            },
            type: .calendarAdded
        )
    }
    
    func showCalendarSyncProgressView(completion: @escaping (() -> Void)) {
        router.presentView(
            transitionStyle: .crossDissolve,
            view: CalendarSyncProgressView(
                title: CourseLocalization.CourseDates.calendarSyncMessage
            ),
            completion: completion
        )
    }
    
    @MainActor
    private func addCourseEventsIfNecessary() {
        Task {
            if calendar.syncOn && calendar.checkIfEventsShouldBeShifted(for: courseDates?.dateBlocks ?? [:]) {
                showCalendarEventShiftAlert()
            }
        }
    }
    
    @MainActor
    private func showCalendarEventShiftAlert() {
        router.presentAlert(
            alertTitle: CourseLocalization.CourseDates.calendarOutOfDate,
            alertMessage: CourseLocalization.CourseDates.calendarShiftMessage,
            positiveAction: CourseLocalization.CourseDates.calendarShiftPromptUpdateNow,
            onCloseTapped: { [weak self] in
                // Remove course calendar
                self?.trackCalendarSyncDialogAction(dialog: .updateCalendar, action: .remove)
                self?.router.dismiss(animated: true)
                self?.removeCourseCalendar { [weak self] _ in
                    self?.trackCalendarSyncSnackbar(snackbar: .removed)
                    self?.eventState = .removedCalendar
                }
            },
            okTapped: { [weak self] in
                // Update Calendar Now
                self?.trackCalendarSyncDialogAction(dialog: .updateCalendar, action: .update)
                self?.router.dismiss(animated: true)
                self?.removeCourseCalendar(trackAnalytics: false) { success in
                    self?.isOn = !success
                    self?.calendar.syncOn = false
                    self?.addCourseEvents(trackAnalytics: false) { [weak self] calendarEventsAdded in
                        self?.isOn = calendarEventsAdded
                        if calendarEventsAdded {
                            self?.trackCalendarSyncSnackbar(snackbar: .updated)
                            self?.calendar.syncOn = calendarEventsAdded
                            self?.eventState = .updatedCalendar
                        }
                    }
                }
            },
            type: .updateCalendar
        )
    }
    
    private func showCalendarSettingsAlert() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        router.presentAlert(
            alertTitle: CourseLocalization.CourseDates.settings,
            alertMessage: CourseLocalization.CourseDates.calendarPermissionNotDetermined(config.platformName),
            positiveAction: CourseLocalization.CourseDates.openSettings,
            onCloseTapped: { [weak self] in
                self?.isOn = false
                self?.router.dismiss(animated: true)
            },
            okTapped: { [weak self] in
                self?.isOn = false
                if UIApplication.shared.canOpenURL(settingsURL) {
                    UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                }
                self?.router.dismiss(animated: true)
            },
            type: .default(
                positiveAction: CourseLocalization.CourseDates.openSettings,
                image: CoreAssets.syncToCalendar.swiftUIImage
            )
        )
    }
    
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

extension CourseDatesViewModel {
    private func trackCalendarSyncToggle(action: CalendarDialogueAction) {
        analytics.calendarSyncToggle(
            enrollmentMode: .none,
            pacing: courseStructure?.isSelfPaced ?? true ? .`self` : .instructor,
            courseId: courseID,
            action: action
        )
    }
    
    private func trackCalendarSyncDialogAction(dialog: CalendarDialogueType, action: CalendarDialogueAction) {
        analytics.calendarSyncDialogAction(
            enrollmentMode: .none,
            pacing: courseStructure?.isSelfPaced ?? true ? .`self` : .instructor,
            courseId: courseID,
            dialog: dialog,
            action: action
        )
    }
    
    private func trackCalendarSyncSnackbar(snackbar: SnackbarType) {
        analytics.calendarSyncSnackbar(
            enrollmentMode: .none,
            pacing: courseStructure?.isSelfPaced ?? true ? .`self` : .instructor,
            courseId: courseID,
            snackbar: snackbar
        )
    }
}

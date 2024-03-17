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
    
    @Published private(set) var isShowProgress = false
    @Published var showError: Bool = false
    @Published var courseDates: CourseDates?
    @Published var dueDatesShifted: Bool = false
    @Published var isOn: Bool = false
    @Published var calendarEventsAdded: Bool = false
    @Published var calendarEventsRemoved: Bool = false
    @Published var calendarEventsUpdated: Bool = false
    
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
                handleCalendar()
            } else {
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
    
    public init(
        interactor: CourseInteractorProtocol,
        router: CourseRouter,
        cssInjector: CSSInjector,
        connectivity: ConnectivityProtocol,
        config: ConfigProtocol,
        courseID: String,
        courseName: String
    ) {
        self.interactor = interactor
        self.router = router
        self.cssInjector = cssInjector
        self.connectivity = connectivity
        self.config = config
        self.courseID = courseID
        self.courseName = courseName
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
    
    func showCourseDetails(componentID: String) async {
        do {
            let courseStructure = try await interactor.getLoadedCourseBlocks(courseID: courseID)
            router.showCourseComponent(
                componentID: componentID,
                courseStructure: courseStructure
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
    func shiftDueDates(courseID: String, withProgress: Bool = true) async {
        isShowProgress = withProgress
        do {
            try await interactor.shiftDueDates(courseID: courseID)
            NotificationCenter.default.post(name: .shiftCourseDates, object: courseID)
            isShowProgress = false
        } catch let error {
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
                    self?.dueDatesShifted = true
                }
            }
        }
    }
    
    func resetDueDatesShiftedFlag() {
        dueDatesShifted = false
    }
}

extension CourseDatesViewModel {
    private func handleCalendar() {
        calendar.requestAccess { [weak self] _, previousStatus, status in
            guard let self else { return }
            switch status {
            case .authorized:
                showAddCalendarAlert()
            default:
                isOn = false
                if previousStatus == status {
                    self.showCalendarSettingsAlert()
                }
            }
        }
    }
    
    @MainActor
    func addCourseEvents(trackAnalytics: Bool = true, completion: ((Bool) -> ())? = nil) {
        guard let dateBlocks = courseDates?.dateBlocks else { return }
        showCalendarSyncProgressView()
        calendar.addEventsToCalendar(for: dateBlocks) { [weak self] calendarEventsAdded in
            guard let self else { return }
            self.isOn = calendarEventsAdded
            if calendarEventsAdded {
                self.calendar.syncOn = calendarEventsAdded
                self.router.dismiss(animated: false)
                self.showEventsAddedSuccessAlert()
            }
            completion?(calendarEventsAdded)
        }
    }
    
    func removeCourseCalendar(trackAnalytics: Bool = true, completion: ((Bool) -> ())? = nil) {
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
            onCloseTapped: {
                self.router.dismiss(animated: true)
                self.isOn = false
                self.calendar.syncOn = false
            },
            okTapped: {
                self.router.dismiss(animated: true)
                Task {
                    await self.addCourseEvents()
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
            onCloseTapped: {
                self.router.dismiss(animated: true)
            },
            okTapped: {
                self.router.dismiss(animated: true)
                self.removeCourseCalendar { [weak self] success in
                    guard let self else { return }
                    calendarEventsRemoved = true
                }
                
            },
            type: .removeCalendar
        )
    }
    
    private func showEventsAddedSuccessAlert() {
        if calendar.isModalPresented {
            calendarEventsAdded = true
            return
        }
        calendar.isModalPresented = true
        router.presentAlert(
            alertTitle: "",
            alertMessage: CourseLocalization.CourseDates.datesAddedAlertMessage(
                calendar.calendarName
            ),
            positiveAction: CourseLocalization.CourseDates.calendarViewEvents,
            onCloseTapped: {
                self.router.dismiss(animated: true)
                self.isOn = true
                self.calendar.syncOn = true
            },
            okTapped: {
                self.router.dismiss(animated: true)
                if let url = URL(string: "calshow://"), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            },
            type: .calendarAdded
        )
    }
    
    func showCalendarSyncProgressView() {
        router.presentView(
            transitionStyle: .crossDissolve,
            view: CalendarSyncProgressView(title: CourseLocalization.CourseDates.calendarSyncMessage)
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
            onCloseTapped: {
                // Remove course calendar
                self.router.dismiss(animated: true)
                self.removeCourseCalendar { [weak self] _ in
                    guard let self else { return }
                    calendarEventsRemoved = true
                }
            },
            okTapped: {
                // Update Calendar Now
                self.router.dismiss(animated: true)
                self.showCalendarSyncProgressView()
                self.removeCourseCalendar(trackAnalytics: false) { success in
                    self.isOn = !success
                    self.calendar.syncOn = false
                    self.addCourseEvents(trackAnalytics: false) { [weak self] calendarEventsAdded in
                        guard let self else { return }
                        self.isOn = calendarEventsAdded
                        if calendarEventsAdded {
                            self.calendar.syncOn = calendarEventsAdded
                            self.calendarEventsUpdated = true
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
            onCloseTapped: {
                self.isOn = false
                self.router.dismiss(animated: true)
            },
            okTapped: {
                self.isOn = false
                if UIApplication.shared.canOpenURL(settingsURL) {
                    UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                }
                self.router.dismiss(animated: true)
            },
            type: .default(
                positiveAction: CourseLocalization.CourseDates.openSettings,
                image: CoreAssets.syncToCalendar.swiftUIImage
            )
        )
    }
}

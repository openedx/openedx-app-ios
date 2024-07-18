//
//  DatesAndCalendarViewModel.swift
//  Profile
//
//  Created by  Stepanok Ivan on 12.04.2024.
//

import SwiftUI
import Combine
import EventKit
import Theme
import BranchSDK
import CryptoKit
import Core

// MARK: - DatesAndCalendarViewModel

public class DatesAndCalendarViewModel: ObservableObject {
    @Published var showCalendaAccessDenied: Bool = false
    @Published var showDisableCalendarSync: Bool = false
    @Published var showError: Bool = false
    @Published var openNewCalendarView: Bool = false
    
    @Published var accountSelection: DropDownPicker.DownPickerOption? = .init(
        title: ProfileLocalization.Calendar.Dropdown.icloud
    )
    @Published var calendarName: String = ""
    @Published var oldCalendarName: String = ""
    @Published var colorSelection: DropDownPicker.DownPickerOption? = .init(color: .accent)
    @Published var oldColorSelection: DropDownPicker.DownPickerOption? = .init(color: .accent)
    
    @Published var assignmentStatus: AssignmentStatus = .synced
    @Published var courseCalendarSync: Bool = true
    @Published var reconnectRequired: Bool = false
    @Published var openChangeSyncView: Bool = false
    @Published var syncingCoursesCount: Int = 0
    
    @Published var coursesForSync = [CourseForSync]()
    
    private var coursesForSyncBeforeChanges = [CourseForSync]()
    
    private var coursesForDeleting = [CourseForSync]()
    private var coursesForAdding = [CourseForSync]()
    
    @Published var synced: Bool = true
    @Published var hideInactiveCourses: Bool = false
    
    var errorMessage: String? {
        didSet {
            DispatchQueue.main.async {
                withAnimation {
                    self.showError = self.errorMessage != nil
                }
            }
        }
    }
    
    private let accounts: [DropDownPicker.DownPickerOption] = [
        .init(title: ProfileLocalization.Calendar.Dropdown.icloud),
        .init(title: ProfileLocalization.Calendar.Dropdown.local)
    ]
    let colors: [DropDownPicker.DownPickerOption] = [
        .init(color: .accent),
        .init(color: .red),
        .init(color: .orange),
        .init(color: .yellow),
        .init(color: .green),
        .init(color: .blue),
        .init(color: .purple),
        .init(color: .brown)
    ]
    
    var router: ProfileRouter
    private var interactor: ProfileInteractorProtocol
    private var profileStorage: ProfileStorage
    private var persistence: ProfilePersistenceProtocol
    private var calendarManager: CalendarManagerProtocol
    private var connectivity: ConnectivityProtocol
    
    private var cancellables = Set<AnyCancellable>()
    var calendarNameHint: String
    
    public init(
        router: ProfileRouter,
        interactor: ProfileInteractorProtocol,
        profileStorage: ProfileStorage,
        persistence: ProfilePersistenceProtocol,
        calendarManager: CalendarManagerProtocol,
        connectivity: ConnectivityProtocol
    ) {
        self.router = router
        self.interactor = interactor
        self.profileStorage = profileStorage
        self.persistence = persistence
        self.calendarManager = calendarManager
        self.connectivity = connectivity
        self.calendarNameHint = ProfileLocalization.Calendar.courseDates((Bundle.main.applicationName ?? ""))
    }
    
    @MainActor
    var isInternetAvaliable: Bool {
        let avaliable = connectivity.isInternetAvaliable
        if !avaliable {
            errorMessage = CoreLocalization.Error.slowOrNoInternetConnection
        }
        return avaliable
    }
    
    private var useRelativeDatesBinding: Binding<Bool> {
        Binding(
            get: { self.profileStorage.useRelativeDates },
            set: { self.profileStorage.useRelativeDates = $0 }
        )
    }
    
    // MARK: - Options Toggle
    var relativeDatesToggle: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(ProfileLocalization.Options.title)
                .font(Theme.Fonts.labelLarge)
                .foregroundColor(Theme.Colors.textPrimary)
            HStack(spacing: 16) {
                Toggle("", isOn: useRelativeDatesBinding)
                    .frame(width: 50)
                    .tint(Theme.Colors.accentColor)
                Text(ProfileLocalization.Options.useRelativeDates)
                    .font(Theme.Fonts.bodyLarge)
                    .foregroundColor(Theme.Colors.textPrimary)
            }
            Text(ProfileLocalization.Options.showRelativeDates)
                .font(Theme.Fonts.labelMedium)
                .foregroundColor(Theme.Colors.textPrimary)
        }
        .padding(.top, 14)
        .padding(.horizontal, 24)
        .frame(minWidth: 0,
               maxWidth: .infinity,
               alignment: .leading)
        .accessibilityIdentifier("relative_dates_toggle")
    }
    
    // MARK: - Lifecycle Functions
    
    func loadCalendarOptions() {
        guard let calendarSettings = profileStorage.calendarSettings else { return }
        self.colorSelection = colors.first(where: { $0.colorString == calendarSettings.colorSelection })
        self.accountSelection = accounts.first(where: { $0.title == calendarSettings.accountSelection })
        self.oldCalendarName = profileStorage.lastCalendarName ?? calendarName
        self.oldColorSelection = colorSelection
        if let calendarName = calendarSettings.calendarName {
            self.calendarName = calendarName
        }
        self.courseCalendarSync = calendarSettings.courseCalendarSync
        self.hideInactiveCourses = profileStorage.hideInactiveCourses ?? false
        
        $hideInactiveCourses
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] hide in
            guard let self = self else { return }
            self.profileStorage.hideInactiveCourses = hide
        })
        .store(in: &cancellables)
        
        $courseCalendarSync
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] sync in
                guard let self = self else { return }
                if !sync {
                    Task {
                        await self.showDisableCalendarSync()
                    }
                }
            })
            .store(in: &cancellables)
        
        updateCoursesCount()
    }
    
    func clearAllData() {
        calendarManager.clearAllData(removeCalendar: true)
        router.back(animated: false)
        courseCalendarSync = true
        showDisableCalendarSync = false
        openNewCalendarView = false
        router.showDatesAndCalendar()
    }
    
    func deleteOrAddNewDatesIfNeeded() async {
        if !coursesForDeleting.isEmpty {
            await removeDeselectedCoursesFromCalendar()
        }
        if !coursesForAdding.isEmpty {
            await fetchCourses()
        }
    }
    
    func saveCalendarOptions() {
        if var calendarSettings = profileStorage.calendarSettings {
            oldCalendarName = calendarName
            oldColorSelection = colorSelection
            calendarSettings.calendarName = calendarName
            profileStorage.lastCalendarName = calendarName
            
            if let colorSelection, let colorString = colorSelection.colorString {
                calendarSettings.colorSelection = colorString
            }
            
            if let accountSelection = accountSelection?.title {
                calendarSettings.accountSelection = accountSelection
            }
            
            calendarSettings.courseCalendarSync = self.courseCalendarSync
            profileStorage.calendarSettings = calendarSettings
        } else {
            if let colorSelection,
               let colorString = colorSelection.colorString,
               let accountSelection = accountSelection?.title {
                profileStorage.calendarSettings = CalendarSettings(
                    colorSelection: colorString,
                    calendarName: calendarName,
                    accountSelection: accountSelection,
                    courseCalendarSync: self.courseCalendarSync
                )
                profileStorage.lastCalendarName = calendarName
            }
        }
    }

    // MARK: - Fetch Courses and Sync
    @MainActor
    func fetchCourses() async {
        guard connectivity.isInternetAvaliable else { return }
        assignmentStatus = .loading
        guard await calendarManager.requestAccess() else {
            await showCalendarAccessDenied()
            return
        }
        calendarManager.createCalendarIfNeeded()
        do {
            let fetchedCourses = try await interactor.enrollmentsStatus()
            self.coursesForSync = fetchedCourses
            let courseCalendarStates = persistence.getAllCourseStates()
            if profileStorage.firstCalendarUpdate == false && courseCalendarStates.isEmpty {
                await syncAllActiveCourses()
            } else {
                coursesForSync = coursesForSync.map { course in
                    var updatedCourse = course
                    updatedCourse.synced = courseCalendarStates.contains {
                        $0.courseID == course.courseID
                    } && course.active
                    return updatedCourse
                }
               
                let addingIDs = Set(coursesForAdding.map { $0.courseID })

                coursesForSync = coursesForSync.map { course in
                    var updatedCourse = course
                    if addingIDs.contains(course.courseID) {
                        updatedCourse.synced = true
                    }
                    return updatedCourse
                }
                
                for course in coursesForSync.filter { $0.synced } {
                    do {
                        let courseDates = try await interactor.getCourseDates(courseID: course.courseID)
                        await syncSelectedCourse(
                            courseID: course.courseID,
                            courseName: course.name,
                            courseDates: courseDates,
                            active: course.active
                        )
                    } catch {
                        assignmentStatus = .failed
                    }
                }
                coursesForAdding = []
                profileStorage.firstCalendarUpdate = true
                updateCoursesCount()
            }
            assignmentStatus = .synced
        } catch {
            self.assignmentStatus = .failed
            debugLog("Error fetching courses: \(error)")
        }
    }
    
    private func updateCoursesCount() {
        syncingCoursesCount = coursesForSync.filter { $0.active && $0.synced }.count
    }
    
    @MainActor
    private func syncAllActiveCourses() async {
        guard profileStorage.firstCalendarUpdate == false else {
            coursesForAdding = []
            coursesForSyncBeforeChanges = []
            assignmentStatus = .synced
            updateCoursesCount()
            return
        }
        let selectedCourses = await calendarManager.filterCoursesBySelected(fetchedCourses: coursesForSync)
        let activeSelectedCourses = selectedCourses.filter { $0.active }
        assignmentStatus = .loading
        for course in activeSelectedCourses {
            do {
                let courseDates = try await interactor.getCourseDates(courseID: course.courseID)
                await syncSelectedCourse(
                    courseID: course.courseID,
                    courseName: course.name,
                    courseDates: courseDates,
                    active: course.active
                )
            } catch {
                assignmentStatus = .failed
            }
        }
        profileStorage.firstCalendarUpdate = true
        coursesForAdding = []
        coursesForSyncBeforeChanges = []
        assignmentStatus = .synced
        updateCoursesCount()
    }
    
    private func filterCoursesBySynced() -> [CourseForSync] {
        let syncedCourses = coursesForSync.filter { $0.synced && $0.active }
        return syncedCourses
    }
    
    func deleteOldCalendarIfNeeded() async {
        guard let calSettings = profileStorage.calendarSettings else { return }
        let courseCalendarStates = persistence.getAllCourseStates()
        let courseCountChanges = courseCalendarStates.count != coursesForSync.count
        let nameChanged = oldCalendarName != calendarName
        let colorChanged = colorSelection != colors.first(where: { $0.colorString == calSettings.colorSelection })
        let accountChanged = accountSelection != accounts.first(where: { $0.title == calSettings.accountSelection })
        
        guard nameChanged || colorChanged || accountChanged || courseCountChanges else { return }
        
        calendarManager.removeOldCalendar()
        saveCalendarOptions()
        persistence.removeAllCourseCalendarEvents()
        await fetchCourses()
    }
    
    private func syncSelectedCourse(
        courseID: String,
        courseName: String,
        courseDates: CourseDates,
        active: Bool
    ) async {
        await MainActor.run {
            self.assignmentStatus = .loading
        }
        
        await calendarManager.removeOutdatedEvents(courseID: courseID)
        guard active else {
            await MainActor.run {
                self.assignmentStatus = .synced
            }
            return
        }

        await calendarManager.syncCourse(courseID: courseID, courseName: courseName, dates: courseDates)
        if let index = self.coursesForSync.firstIndex(where: { $0.courseID == courseID && $0.active }) {
            await MainActor.run {
                self.coursesForSync[index].synced = true
            }
        }
        await MainActor.run {
            self.assignmentStatus = .synced
        }
    }

    @MainActor
    func removeDeselectedCoursesFromCalendar() async {
        for course in coursesForDeleting {
            await calendarManager.removeOutdatedEvents(courseID: course.courseID)
            persistence.removeCourseState(courseID: course.courseID)
            persistence.removeCourseCalendarEvents(for: course.courseID)
            if let index = self.coursesForSync.firstIndex(where: { $0.courseID == course.courseID }) {
                self.coursesForSync[index].synced = false
            }
        }
        updateCoursesCount()
        coursesForDeleting = []
        coursesForSyncBeforeChanges = []
    }
    
    func toggleSync(for course: CourseForSync) {
        guard course.active else { return }
        if coursesForSyncBeforeChanges.isEmpty {
            coursesForSyncBeforeChanges = coursesForSync
        }
        if let index = coursesForSync.firstIndex(where: { $0.courseID == course.courseID }) {
            coursesForSync[index].synced.toggle()
            updateCoursesForSyncAndDeletion(course: coursesForSync[index])
        }
    }

    private func updateCoursesForSyncAndDeletion(course: CourseForSync) {
        guard let initialCourse = coursesForSyncBeforeChanges.first(where: {
            $0.courseID == course.courseID
        }) else { return }
        
        if course.synced != initialCourse.synced {
            if course.synced {
                if !coursesForAdding.contains(where: { $0.courseID == course.courseID }) {
                    coursesForAdding.append(course)
                }
                if let index = coursesForDeleting.firstIndex(where: { $0.courseID == course.courseID }) {
                    coursesForDeleting.remove(at: index)
                }
            } else {
                if !coursesForDeleting.contains(where: { $0.courseID == course.courseID }) {
                    coursesForDeleting.append(course)
                }
                if let index = coursesForAdding.firstIndex(where: { $0.courseID == course.courseID }) {
                    coursesForAdding.remove(at: index)
                }
            }
        } else {
            if let index = coursesForAdding.firstIndex(where: { $0.courseID == course.courseID }) {
                coursesForAdding.remove(at: index)
            }
            if let index = coursesForDeleting.firstIndex(where: { $0.courseID == course.courseID }) {
                coursesForDeleting.remove(at: index)
            }
        }
    }
    
    // MARK: - Request Calendar Permission
    @MainActor
    func requestCalendarPermission() async {
        if await calendarManager.requestAccess() {
            await showNewCalendarSetup()
        } else {
            await showCalendarAccessDenied()
        }
    }
    
    @MainActor
    private func showCalendarAccessDenied() async {
            withAnimation(.bouncy(duration: 0.3)) {
                self.showCalendaAccessDenied = true
            }
    }
    
    @MainActor
    private func showDisableCalendarSync() async {
        withAnimation(.bouncy(duration: 0.3)) {
            self.showDisableCalendarSync = true
        }
    }
    
    @MainActor
    private func showNewCalendarSetup() async {
            withAnimation(.bouncy(duration: 0.3)) {
                self.openNewCalendarView = true
            }
    }
    
    func openAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

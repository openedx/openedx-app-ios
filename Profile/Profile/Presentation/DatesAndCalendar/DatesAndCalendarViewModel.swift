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
import OEXFoundation

// MARK: - DatesAndCalendarViewModel

@MainActor
public final class DatesAndCalendarViewModel: ObservableObject {
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
    
    private(set) var coursesForDeleting = [CourseForSync]()
    private(set) var coursesForAdding = [CourseForSync]()
    
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
    @Published var profileStorage: ProfileStorage
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
    
    var isInternetAvaliable: Bool {
        let avaliable = connectivity.isInternetAvaliable
        if !avaliable {
            errorMessage = CoreLocalization.Error.slowOrNoInternetConnection
        }
        return avaliable
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
    
    func clearAllData() async {
        await calendarManager.clearAllData(removeCalendar: true)
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
            let courseCalendarStates = await persistence.getAllCourseStates()
            if profileStorage.firstCalendarUpdate == false && courseCalendarStates.isEmpty {
                await syncAllActiveCourses()
            } else {
                coursesForSync = coursesForSync.map { course in
                    var updatedCourse = course
                    updatedCourse.synced = courseCalendarStates.contains {
                        $0.courseID == course.courseID
                    } && course.recentlyActive
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
                
                for course in coursesForSync.filter({ $0.synced }) {
                    do {
                        let courseDates = try await interactor.getCourseDates(courseID: course.courseID)
                        await syncSelectedCourse(
                            courseID: course.courseID,
                            courseName: course.name,
                            courseDates: courseDates,
                            active: course.recentlyActive
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
        syncingCoursesCount = coursesForSync.filter { $0.recentlyActive && $0.synced }.count
    }
    
    private func syncAllActiveCourses() async {
        guard profileStorage.firstCalendarUpdate == false else {
            coursesForAdding = []
            coursesForSyncBeforeChanges = []
            assignmentStatus = .synced
            updateCoursesCount()
            return
        }
        let selectedCourses = await calendarManager.filterCoursesBySelected(fetchedCourses: coursesForSync)
        let activeSelectedCourses = selectedCourses.filter { $0.recentlyActive }
        assignmentStatus = .loading
        for course in activeSelectedCourses {
            do {
                let courseDates = try await interactor.getCourseDates(courseID: course.courseID)
                await syncSelectedCourse(
                    courseID: course.courseID,
                    courseName: course.name,
                    courseDates: courseDates,
                    active: course.recentlyActive
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
        let syncedCourses = coursesForSync.filter { $0.synced && $0.recentlyActive }
        return syncedCourses
    }
    
    func deleteOldCalendarIfNeeded() async {
        guard let calSettings = profileStorage.calendarSettings else { return }
        let courseCalendarStates = await persistence.getAllCourseStates()
        let courseCountChanges = courseCalendarStates.count != coursesForSync.count
        let nameChanged = oldCalendarName != calendarName
        let colorChanged = colorSelection != colors.first(where: { $0.colorString == calSettings.colorSelection })
        let accountChanged = accountSelection != accounts.first(where: { $0.title == calSettings.accountSelection })
        
        guard nameChanged || colorChanged || accountChanged || courseCountChanges else { return }
        
        calendarManager.removeOldCalendar()
        saveCalendarOptions()
        await persistence.removeAllCourseCalendarEvents()
        await fetchCourses()
    }
    
    private func syncSelectedCourse(
        courseID: String,
        courseName: String,
        courseDates: CourseDates,
        active: Bool
    ) async {
        assignmentStatus = .loading
        
        await calendarManager.removeOutdatedEvents(courseID: courseID)
        guard active else {
            await MainActor.run {
                self.assignmentStatus = .synced
            }
            return
        }
        
        await calendarManager.syncCourse(courseID: courseID, courseName: courseName, dates: courseDates)
        Task {
            if let index = self.coursesForSync.firstIndex(where: { $0.courseID == courseID && $0.recentlyActive }) {
                self.coursesForSync[index].synced = true
            }
            self.assignmentStatus = .synced
        }
    }
    
    func removeDeselectedCoursesFromCalendar() async {
        for course in coursesForDeleting {
            await calendarManager.removeOutdatedEvents(courseID: course.courseID)
            await persistence.removeCourseState(courseID: course.courseID)
            await persistence.removeCourseCalendarEvents(for: course.courseID)
            if let index = self.coursesForSync.firstIndex(where: { $0.courseID == course.courseID }) {
                self.coursesForSync[index].synced = false
            }
        }
        updateCoursesCount()
        coursesForDeleting = []
        coursesForSyncBeforeChanges = []
    }
    
    func toggleSync(for course: CourseForSync) {
        guard course.recentlyActive else { return }
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
    func requestCalendarPermission() async {
        if await calendarManager.requestAccess() {
            await showNewCalendarSetup()
        } else {
            await showCalendarAccessDenied()
        }
    }
    
    private func showCalendarAccessDenied() async {
        withAnimation(.bouncy(duration: 0.3)) {
            self.showCalendaAccessDenied = true
        }
    }
    
    private func showDisableCalendarSync() async {
        withAnimation(.bouncy(duration: 0.3)) {
            self.showDisableCalendarSync = true
        }
    }
    
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

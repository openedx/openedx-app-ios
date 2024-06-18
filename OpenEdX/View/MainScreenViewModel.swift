//
//  MainScreenViewModel.swift
//  OpenEdX
//
//  Created by  Stepanok Ivan on 30.10.2023.
//

import Foundation
import Core
import Profile
import Swinject
import Combine

public enum MainTab {
    case discovery
    case dashboard
    case programs
    case profile
}

final class MainScreenViewModel: ObservableObject {
    
    private let analytics: MainScreenAnalytics
    let config: ConfigProtocol
    private let profileInteractor: ProfileInteractorProtocol
    var sourceScreen: LogistrationSourceScreen
    private var appStorage: CoreStorage & ProfileStorage
    private let calendarManager: CalendarManager
    private var cancellables = Set<AnyCancellable>()
    
    @Published var selection: MainTab = .dashboard
    
    init(analytics: MainScreenAnalytics,
         config: ConfigProtocol,
         profileInteractor: ProfileInteractorProtocol,
         appStorage: CoreStorage & ProfileStorage,
         calendarManager: CalendarManager,
         sourceScreen: LogistrationSourceScreen = .default
    ) {
        self.analytics = analytics
        self.config = config
        self.profileInteractor = profileInteractor
        self.appStorage = appStorage
        self.calendarManager = calendarManager
        self.sourceScreen = sourceScreen
    }
    
    public func select(tab: MainTab) {
        selection = tab
    }
    
    func trackMainDiscoveryTabClicked() {
        analytics.mainDiscoveryTabClicked()
    }
    func trackMainDashboardTabClicked() {
        analytics.mainDashboardTabClicked()
    }
    func trackMainProgramsTabClicked() {
        analytics.mainProgramsTabClicked()
    }
    func trackMainProfileTabClicked() {
        analytics.mainProfileTabClicked()
    }
    
    @MainActor
    func prefetchDataForOffline() async {
        if profileInteractor.getMyProfileOffline() == nil {
            _ = try? await profileInteractor.getMyProfile()
        }
    }
    
    func loadCalendar() async {
        if let username = appStorage.user?.username {
            await updateCalendarIfNeeded(for: username)
        }
    }
    
    func addShiftCourseDatesObserver() {
        NotificationCenter.default.publisher(for: .shiftCourseDates, object: nil)
            .sink { notification in
                guard let (courseID, courseName) = notification.object as? (String, String) else { return }
                Task {
                    await self.updateCourseDates(courseID: courseID, courseName: courseName)
                }
            }
            .store(in: &cancellables)
    }
}

extension MainScreenViewModel {
    
    // MARK: Update calendar on startup
    private func updateCalendarIfNeeded(for username: String) async {
        
        if username == appStorage.lastLoginUsername {
            let today = Date()
            let calendar = Calendar.current
            
            if let lastUpdate = appStorage.lastCalendarUpdateDate {
                if calendar.isDateInToday(lastUpdate) {
                    return
                }
            }
            appStorage.lastCalendarUpdateDate = today
            
            guard appStorage.calendarSettings?.calendarName != "",
                  appStorage.calendarSettings?.courseCalendarSync ?? true
            else {
                debugLog("No calendar for user: \(username)")
                return
            }
            
            do {
                var coursesForSync = try await profileInteractor.enrollmentsStatus().filter { $0.active }
                
                let selectedCourses = await calendarManager.filterCoursesBySelected(fetchedCourses: coursesForSync)
                
                for course in selectedCourses {
                    if let courseDates = try? await profileInteractor.getCourseDates(courseID: course.courseID),
                       calendarManager.isDatesChanged(courseID: course.courseID, checksum: courseDates.checksum) {
                        debugLog("Calendar needs update for courseID: \(course.courseID)")
                        await calendarManager.removeOutdatedEvents(courseID: course.courseID)
                        await calendarManager.syncCourse(
                            courseID: course.courseID,
                            courseName: course.name,
                            dates: courseDates
                        )
                    }
                }
                debugLog("No calendar update needed for username: \(username)")
            } catch {
                debugLog("Error updating calendar: \(error.localizedDescription)")
            }
        } else {
            appStorage.lastLoginUsername = username
            calendarManager.clearAllData(removeCalendar: false)
        }
    }
    
    private func updateCourseDates(courseID: String, courseName: String) async {
        if let courseDates = try? await profileInteractor.getCourseDates(courseID: courseID),
           calendarManager.isDatesChanged(courseID: courseID, checksum: courseDates.checksum) {
            debugLog("Calendar update needed for courseID: \(courseID)")
            await calendarManager.removeOutdatedEvents(courseID: courseID)
            await calendarManager.syncCourse(courseID: courseID, courseName: courseName, dates: courseDates)
        }
    }
}

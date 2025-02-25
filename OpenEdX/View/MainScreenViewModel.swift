//
//  MainScreenViewModel.swift
//  OpenEdX
//
//  Created by  Stepanok Ivan on 30.10.2023.
//

import Foundation
import Core
import OEXFoundation
import Profile
import Course
import Swinject
import Combine
import Authorization
import UserNotifications

public enum MainTab {
    case discovery
    case dashboard
    case programs
    case downloads
    case profile
}

@MainActor
final class MainScreenViewModel: ObservableObject {
    
    private let analytics: MainScreenAnalytics
    let config: ConfigProtocol
    let router: BaseRouter
    let syncManager: OfflineSyncManagerProtocol
    let profileInteractor: ProfileInteractorProtocol
    let courseInteractor: CourseInteractorProtocol
    var sourceScreen: LogistrationSourceScreen
    private var appStorage: CoreStorage & ProfileStorage
    private let calendarManager: CalendarManagerProtocol
    private var cancellables = Set<AnyCancellable>()
    private var postLoginData: PostLoginData?
    
    @Published var selection: MainTab = .dashboard
    @Published var showRegisterBanner: Bool = false

    init(analytics: MainScreenAnalytics,
         config: ConfigProtocol,
         router: BaseRouter,
         syncManager: OfflineSyncManagerProtocol,
         profileInteractor: ProfileInteractorProtocol,
         courseInteractor: CourseInteractorProtocol,
         appStorage: CoreStorage & ProfileStorage,
         calendarManager: CalendarManagerProtocol,
         sourceScreen: LogistrationSourceScreen = .default,
         postLoginData: PostLoginData? = nil
    ) {
        self.analytics = analytics
        self.config = config
        self.router = router
        self.syncManager = syncManager
        self.profileInteractor = profileInteractor
        self.courseInteractor = courseInteractor
        self.appStorage = appStorage
        self.calendarManager = calendarManager
        self.sourceScreen = sourceScreen
        self.postLoginData = postLoginData
        
        NotificationCenter.default.publisher(for: .shiftCourseDates, object: nil)
            .sink { notification in
                guard let (courseID, courseName) = notification.object as? (String, String) else { return }
                Task {
                    await self.updateCourseDates(courseID: courseID, courseName: courseName)
                }
            }
            .store(in: &cancellables)
        trackSettingPermissionStatus()
    }
    
    private func trackSettingPermissionStatus() {
        DispatchQueue.global(qos: .userInteractive).async {
            UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { [weak self] (settings) in
                if settings.authorizationStatus == .notDetermined {
                    self?.analytics.notificationPermissionStatus(status: "not_determined")
                } else if settings.authorizationStatus == .denied {
                    self?.analytics.notificationPermissionStatus(status: "denied")
                } else if settings.authorizationStatus == .authorized {
                    self?.analytics.notificationPermissionStatus(status: "authorized")
                }
            })
        }
    }
    
    public func select(tab: MainTab) {
        selection = tab
    }
    
    func trackMainDiscoveryTabClicked() {
        analytics.mainDiscoveryTabClicked()
    }
    
    func trackMainDashboardLearnTabClicked() {
        analytics.mainLearnTabClicked()
    }
    
    func trackMainProgramsTabClicked() {
        analytics.mainProgramsTabClicked()
    }
    
    func trackMainDownloadsTabClicked() {
        analytics.mainDownloadsTabClicked()
    }
    
    func trackMainProfileTabClicked() {
        analytics.mainProfileTabClicked()
    }
    
    @MainActor
    func showDownloadFailed(downloads: [DownloadDataTask]) async {
        if let sequentials = try? await courseInteractor.getSequentialsContainsBlocks(
            blockIds: downloads.map {
                $0.blockId
            },
            courseID: downloads.first?.courseId ?? ""
        ) {
            router.presentView(
                transitionStyle: .coverVertical,
                view: DownloadErrorAlertView(
                    errorType: .downloadFailed,
                    sequentials: sequentials,
                    tryAgain: { [weak self] in
                        guard let self else { return }
                        NotificationCenter.default.post(
                            name: .tryDownloadAgain,
                            object: downloads
                        )
                        self.router.dismiss(animated: true)
                    },
                    close: { [weak self] in
                        guard let self else { return }
                        self.router.dismiss(animated: true)
                    }
                ),
                completion: {}
            )
        }
    }

    func trackMainDashboardMyCoursesClicked() {
        analytics.mainCoursesClicked()
    }

    public func checkIfNeedToShowRegisterBanner() {
        if postLoginData?.showSocialRegisterBanner == true && !registerBannerText.isEmpty {
            showRegisterBanner = true
        }
    }
    public func registerBannerWasShowed() {
        postLoginData?.showSocialRegisterBanner = false
        showRegisterBanner = false
    }
    public var registerBannerText: String {
        guard let socialAuthMethodName = postLoginData?.authMethod,
              !socialAuthMethodName.isEmpty
        else { return "" }
        return CoreLocalization.Mainscreen.socialRegisterBanner(config.platformName, socialAuthMethodName.capitalized)
    }

    @MainActor
    func prefetchDataForOffline() async {
        if await profileInteractor.getMyProfileOffline() == nil {
            _ = try? await profileInteractor.getMyProfile()
        }
    }
    
    func loadCalendar() async {
        if let username = appStorage.user?.username {
            await updateCalendarIfNeeded(for: username)
        }
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
                let coursesForSync = try await profileInteractor.enrollmentsStatus().filter { $0.recentlyActive }
                
                let selectedCourses = await calendarManager.filterCoursesBySelected(fetchedCourses: coursesForSync)
                
                for course in selectedCourses {
                    if let courseDates = try? await profileInteractor.getCourseDates(courseID: course.courseID),
                       await calendarManager.isDatesChanged(courseID: course.courseID, checksum: courseDates.checksum) {
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
            await calendarManager.clearAllData(removeCalendar: false)
        }
    }
    
    private func updateCourseDates(courseID: String, courseName: String) async {
        if let courseDates = try? await profileInteractor.getCourseDates(courseID: courseID),
           await calendarManager.isDatesChanged(courseID: courseID, checksum: courseDates.checksum) {
            debugLog("Calendar update needed for courseID: \(courseID)")
            await calendarManager.removeOutdatedEvents(courseID: courseID)
            await calendarManager.syncCourse(courseID: courseID, courseName: courseName, dates: courseDates)
        }
    }
}

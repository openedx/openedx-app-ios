//
//  MainScreenViewModel.swift
//  OpenEdX
//
//  Created by  Stepanok Ivan on 30.10.2023.
//

import Foundation
import Core
import Profile
import Course

public enum MainTab {
    case discovery
    case dashboard
    case programs
    case profile
}

final class MainScreenViewModel: ObservableObject {

    private let analytics: MainScreenAnalytics
    let config: ConfigProtocol
    let router: BaseRouter
    let syncManager: OfflineSyncManagerProtocol
    let profileInteractor: ProfileInteractorProtocol
    let courseInteractor: CourseInteractorProtocol
    var sourceScreen: LogistrationSourceScreen

    @Published var selection: MainTab = .dashboard

    init(analytics: MainScreenAnalytics,
         config: ConfigProtocol,
         router: BaseRouter,
         syncManager: OfflineSyncManagerProtocol,
         profileInteractor: ProfileInteractorProtocol,
         courseInteractor: CourseInteractorProtocol,
         sourceScreen: LogistrationSourceScreen = .default
    ) {
        self.analytics = analytics
        self.config = config
        self.router = router
        self.syncManager = syncManager
        self.profileInteractor = profileInteractor
        self.courseInteractor = courseInteractor
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

    @MainActor
    func prefetchDataForOffline() async {
        if profileInteractor.getMyProfileOffline() == nil {
            _ = try? await profileInteractor.getMyProfile()
        }
    }
    
}

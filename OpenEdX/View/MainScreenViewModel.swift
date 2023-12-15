//
//  MainScreenViewModel.swift
//  OpenEdX
//
//  Created by  Stepanok Ivan on 30.10.2023.
//

import Foundation
import Core
import Profile

class MainScreenViewModel: ObservableObject {
    
    private let analytics: MainScreenAnalytics
    let config: ConfigProtocol
    let profileInteractor: ProfileInteractorProtocol
    var sourceScreen: LogistrationSourceScreen
    
    init(analytics: MainScreenAnalytics,
         config: ConfigProtocol,
         profileInteractor: ProfileInteractorProtocol,
         sourceScreen: LogistrationSourceScreen = .default
    ) {
        self.analytics = analytics
        self.config = config
        self.profileInteractor = profileInteractor
        self.sourceScreen = sourceScreen
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
    
}

//
//  SettingsViewModelTests.swift
//  ProfileTests
//
//  Created by  Stepanok Ivan on 10.04.2024.
//

import SwiftyMocky
import XCTest
@testable import Core
@testable import Profile
import Alamofire
import SwiftUI

@MainActor
final class SettingsViewModelTests: XCTestCase {

    func testLogOutSuccess() async throws {
        let interactor = ProfileInteractorProtocolMock()
        let router = ProfileRouterMock()
        let analytics = ProfileAnalyticsMock()
        let coreAnalytics = CoreAnalyticsMock()
        
        Given(
            interactor,
            .getSettings(
                willReturn: UserSettings(
                    wifiOnly: true,
                    streamingQuality: .auto,
                    downloadQuality: .auto,
                    playbackSpeed: 1.0
                )
            )
        )
        
        let viewModel = SettingsViewModel(
            interactor: interactor,
            downloadManager: DownloadManagerMock(),
            router: router,
            analytics: analytics,
            coreAnalytics: coreAnalytics,
            config:  ConfigMock(),
            corePersistence: CorePersistenceMock(),
            connectivity: Connectivity()
        )
        
        await viewModel.logOut()
        
        Verify(router, .showStartupScreen())
        XCTAssertFalse(viewModel.showError)
    }
    
    func testTrackProfileVideoSettingsClicked() {
        let interactor = ProfileInteractorProtocolMock()
        let router = ProfileRouterMock()
        let analytics = ProfileAnalyticsMock()
        let coreAnalytics = CoreAnalyticsMock()
        
        Given(
            interactor,
            .getSettings(
                willReturn: UserSettings(
                    wifiOnly: true,
                    streamingQuality: .auto,
                    downloadQuality: .auto,
                    playbackSpeed: 1.0
                )
            )
        )
        
        let viewModel = SettingsViewModel(
            interactor: interactor,
            downloadManager: DownloadManagerMock(),
            router: router,
            analytics: analytics,
            coreAnalytics: coreAnalytics,
            config:  ConfigMock(),
            corePersistence: CorePersistenceMock(),
            connectivity: Connectivity()
        )
        
        viewModel.trackProfileVideoSettingsClicked()
        
        Verify(analytics, 1, .profileVideoSettingsClicked())
    }
    
    func testTrackEmailSupportClicked() {
        let interactor = ProfileInteractorProtocolMock()
        let router = ProfileRouterMock()
        let analytics = ProfileAnalyticsMock()
        let coreAnalytics = CoreAnalyticsMock()
        
        Given(
            interactor,
            .getSettings(
                willReturn: UserSettings(
                    wifiOnly: true,
                    streamingQuality: .auto,
                    downloadQuality: .auto,
                    playbackSpeed: 1.0
                )
            )
        )
        
        let viewModel = SettingsViewModel(
            interactor: interactor,
            downloadManager: DownloadManagerMock(),
            router: router,
            analytics: analytics,
            coreAnalytics: coreAnalytics,
            config:  ConfigMock(),
            corePersistence: CorePersistenceMock(),
            connectivity: Connectivity()
        )
        
        viewModel.trackEmailSupportClicked()
        
        Verify(analytics, 1, .emailSupportClicked())
    }
    
    func testTrackCookiePolicyClicked() {
        let interactor = ProfileInteractorProtocolMock()
        let router = ProfileRouterMock()
        let analytics = ProfileAnalyticsMock()
        let coreAnalytics = CoreAnalyticsMock()
        
        Given(
            interactor,
            .getSettings(
                willReturn: UserSettings(
                    wifiOnly: true,
                    streamingQuality: .auto,
                    downloadQuality: .auto,
                    playbackSpeed: 1.0
                )
            )
        )
        
        let viewModel = SettingsViewModel(
            interactor: interactor,
            downloadManager: DownloadManagerMock(),
            router: router,
            analytics: analytics,
            coreAnalytics: coreAnalytics,
            config:  ConfigMock(),
            corePersistence: CorePersistenceMock(),
            connectivity: Connectivity()
        )
        
        viewModel.trackCookiePolicyClicked()
        
        Verify(analytics, 1, .cookiePolicyClicked())
    }
    
    func testTrackPrivacyPolicyClicked() {
        let interactor = ProfileInteractorProtocolMock()
        let router = ProfileRouterMock()
        let analytics = ProfileAnalyticsMock()
        let coreAnalytics = CoreAnalyticsMock()
        
        Given(
            interactor,
            .getSettings(
                willReturn: UserSettings(
                    wifiOnly: true,
                    streamingQuality: .auto,
                    downloadQuality: .auto,
                    playbackSpeed: 1.0
                )
            )
        )
        
        let viewModel = SettingsViewModel(
            interactor: interactor,
            downloadManager: DownloadManagerMock(),
            router: router,
            analytics: analytics,
            coreAnalytics: coreAnalytics,
            config:  ConfigMock(),
            corePersistence: CorePersistenceMock(),
            connectivity: Connectivity()
        )
        
        viewModel.trackPrivacyPolicyClicked()
        
        Verify(analytics, 1, .privacyPolicyClicked())
    }
    
    func testTrackProfileEditClicked() {
        let interactor = ProfileInteractorProtocolMock()
        let router = ProfileRouterMock()
        let analytics = ProfileAnalyticsMock()
        let coreAnalytics = CoreAnalyticsMock()
        
        Given(
            interactor,
            .getSettings(
                willReturn: UserSettings(
                    wifiOnly: true,
                    streamingQuality: .auto,
                    downloadQuality: .auto,
                    playbackSpeed: 1.0
                )
            )
        )
        
        let viewModel = SettingsViewModel(
            interactor: interactor,
            downloadManager: DownloadManagerMock(),
            router: router,
            analytics: analytics,
            coreAnalytics: coreAnalytics,
            config:  ConfigMock(),
            corePersistence: CorePersistenceMock(),
            connectivity: Connectivity()
        )
        
        viewModel.trackProfileEditClicked()
        
        Verify(analytics, 1, .profileEditClicked())
    }
}

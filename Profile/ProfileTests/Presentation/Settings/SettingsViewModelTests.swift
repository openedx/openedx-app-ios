//
//  SettingsViewModelTests.swift
//  ProfileTests
//
//  Created by  Stepanok Ivan on 10.04.2024.
//

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
        let storage = CoreStorageMock()
        let downloadManager = DownloadManagerProtocolMock()
        let corePersistence = CorePersistenceProtocolMock()
        let connectivity = ConnectivityProtocolMock()
        let config = ConfigProtocolMock()

        storage.updateAppRequired = false
        interactor.getSettingsHandler = {
            UserSettings(
                wifiOnly: true,
                streamingQuality: .auto,
                downloadQuality: .auto,
                playbackSpeed: 1.0
            )
        }
        router.showStartupScreenHandler = { }
        interactor.logOutHandler = { }

        let viewModel = SettingsViewModel(
            interactor: interactor,
            downloadManager: downloadManager,
            router: router,
            analytics: analytics,
            coreAnalytics: coreAnalytics,
            config: config,
            corePersistence: corePersistence,
            connectivity: connectivity,
            coreStorage: storage
        )

        await viewModel.logOut()

        XCTAssertEqual(router.showStartupScreenCallCount, 1)
        XCTAssertFalse(viewModel.showError)
    }

    func testTrackProfileVideoSettingsClicked() {
        let interactor = ProfileInteractorProtocolMock()
        let router = ProfileRouterMock()
        let analytics = ProfileAnalyticsMock()
        let coreAnalytics = CoreAnalyticsMock()
        let storage = CoreStorageMock()
        let downloadManager = DownloadManagerProtocolMock()
        let corePersistence = CorePersistenceProtocolMock()
        let connectivity = ConnectivityProtocolMock()
        let config = ConfigProtocolMock()

        storage.updateAppRequired = false
        interactor.getSettingsHandler = {
            UserSettings(
                wifiOnly: true,
                streamingQuality: .auto,
                downloadQuality: .auto,
                playbackSpeed: 1.0
            )
        }

        let viewModel = SettingsViewModel(
            interactor: interactor,
            downloadManager: downloadManager,
            router: router,
            analytics: analytics,
            coreAnalytics: coreAnalytics,
            config: config,
            corePersistence: corePersistence,
            connectivity: connectivity,
            coreStorage: storage
        )

        viewModel.trackProfileVideoSettingsClicked()

        XCTAssertEqual(analytics.profileVideoSettingsClickedCallCount, 1)
    }

    func testTrackEmailSupportClicked() {
        let interactor = ProfileInteractorProtocolMock()
        let router = ProfileRouterMock()
        let analytics = ProfileAnalyticsMock()
        let coreAnalytics = CoreAnalyticsMock()
        let storage = CoreStorageMock()
        let downloadManager = DownloadManagerProtocolMock()
        let corePersistence = CorePersistenceProtocolMock()
        let connectivity = ConnectivityProtocolMock()
        let config = ConfigProtocolMock()

        storage.updateAppRequired = false
        interactor.getSettingsHandler = {
            UserSettings(
                wifiOnly: true,
                streamingQuality: .auto,
                downloadQuality: .auto,
                playbackSpeed: 1.0
            )
        }

        let viewModel = SettingsViewModel(
            interactor: interactor,
            downloadManager: downloadManager,
            router: router,
            analytics: analytics,
            coreAnalytics: coreAnalytics,
            config: config,
            corePersistence: corePersistence,
            connectivity: connectivity,
            coreStorage: storage
        )

        viewModel.trackEmailSupportClicked()

        XCTAssertEqual(analytics.emailSupportClickedCallCount, 1)
    }

    func testTrackCookiePolicyClicked() {
        let interactor = ProfileInteractorProtocolMock()
        let router = ProfileRouterMock()
        let analytics = ProfileAnalyticsMock()
        let coreAnalytics = CoreAnalyticsMock()
        let storage = CoreStorageMock()
        let downloadManager = DownloadManagerProtocolMock()
        let corePersistence = CorePersistenceProtocolMock()
        let connectivity = ConnectivityProtocolMock()
        let config = ConfigProtocolMock()

        storage.updateAppRequired = false
        interactor.getSettingsHandler = {
            UserSettings(
                wifiOnly: true,
                streamingQuality: .auto,
                downloadQuality: .auto,
                playbackSpeed: 1.0
            )
        }

        let viewModel = SettingsViewModel(
            interactor: interactor,
            downloadManager: downloadManager,
            router: router,
            analytics: analytics,
            coreAnalytics: coreAnalytics,
            config: config,
            corePersistence: corePersistence,
            connectivity: connectivity,
            coreStorage: storage
        )

        viewModel.trackCookiePolicyClicked()

        XCTAssertEqual(analytics.cookiePolicyClickedCallCount, 1)
    }

    func testTrackPrivacyPolicyClicked() {
        let interactor = ProfileInteractorProtocolMock()
        let router = ProfileRouterMock()
        let analytics = ProfileAnalyticsMock()
        let coreAnalytics = CoreAnalyticsMock()
        let storage = CoreStorageMock()
        let downloadManager = DownloadManagerProtocolMock()
        let corePersistence = CorePersistenceProtocolMock()
        let connectivity = ConnectivityProtocolMock()
        let config = ConfigProtocolMock()

        storage.updateAppRequired = false
        interactor.getSettingsHandler = {
            UserSettings(
                wifiOnly: true,
                streamingQuality: .auto,
                downloadQuality: .auto,
                playbackSpeed: 1.0
            )
        }

        let viewModel = SettingsViewModel(
            interactor: interactor,
            downloadManager: downloadManager,
            router: router,
            analytics: analytics,
            coreAnalytics: coreAnalytics,
            config: config,
            corePersistence: corePersistence,
            connectivity: connectivity,
            coreStorage: storage
        )

        viewModel.trackPrivacyPolicyClicked()

        XCTAssertEqual(analytics.privacyPolicyClickedCallCount, 1)
    }

    func testTrackProfileEditClicked() {
        let interactor = ProfileInteractorProtocolMock()
        let router = ProfileRouterMock()
        let analytics = ProfileAnalyticsMock()
        let coreAnalytics = CoreAnalyticsMock()
        let storage = CoreStorageMock()
        let downloadManager = DownloadManagerProtocolMock()
        let corePersistence = CorePersistenceProtocolMock()
        let connectivity = ConnectivityProtocolMock()
        let config = ConfigProtocolMock()

        storage.updateAppRequired = false
        interactor.getSettingsHandler = {
            UserSettings(
                wifiOnly: true,
                streamingQuality: .auto,
                downloadQuality: .auto,
                playbackSpeed: 1.0
            )
        }

        let viewModel = SettingsViewModel(
            interactor: interactor,
            downloadManager: downloadManager,
            router: router,
            analytics: analytics,
            coreAnalytics: coreAnalytics,
            config: config,
            corePersistence: corePersistence,
            connectivity: connectivity,
            coreStorage: storage
        )

        viewModel.trackProfileEditClicked()

        XCTAssertEqual(analytics.profileEditClickedCallCount, 1)
    }
}

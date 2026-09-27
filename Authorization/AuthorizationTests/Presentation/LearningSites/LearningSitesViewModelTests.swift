//
//  LearningSitesViewModelTests.swift
//  AuthorizationTests
//
//  Created by Rawan Matar on 22/09/2026.
//

import XCTest
@testable import Core
@testable import Authorization

@MainActor
final class LearningSitesViewModelTests: XCTestCase {

    private func freshUserDefaults(_ name: String) -> UserDefaults {
        let defaults = UserDefaults(suiteName: name)!
        defaults.removePersistentDomain(forName: name)
        return defaults
    }

    private func makeStore(_ name: String) -> InstanceStore {
        let catalog = InstancesConfig(array: [
            ["KEY": "acme", "NAME": "Acme", "OAUTH_CLIENT_ID": "acme-id", "API_HOST_URL": "https://acme.example.com"],
            ["KEY": "beta", "NAME": "Beta", "OAUTH_CLIENT_ID": "beta-id", "API_HOST_URL": "https://beta.example.com"]
        ])
        return InstanceStore(userDefaults: freshUserDefaults(name), instancesConfig: { catalog })
    }

    func test_currentLearningSites_reflectsHasSession() {
        let storage = CoreStorageMock()
        storage.sessionInstanceKeys = ["acme"]
        let viewModel = LearningSitesViewModel(
            instanceStore: makeStore(#function),
            storage: storage,
            sessionManager: InstanceSessionManagerProtocolMock(),
            router: AuthorizationRouterMock(),
            isSwitching: true
        )

        XCTAssertEqual(viewModel.currentLearningSites.map(\.key), ["acme"])
        XCTAssertEqual(viewModel.addableSites.map(\.key), ["beta"])
    }

    func test_searchText_filtersAddableSitesByName() {
        let viewModel = LearningSitesViewModel(
            instanceStore: makeStore(#function),
            storage: CoreStorageMock(),
            sessionManager: InstanceSessionManagerProtocolMock(),
            router: AuthorizationRouterMock(),
            isSwitching: false
        )

        viewModel.searchText = "bet"

        XCTAssertEqual(viewModel.addableSites.map(\.key), ["beta"])
    }

    func test_select_withoutSession_switchesThenShowsLoginScreen() async {
        let router = AuthorizationRouterMock()
        let sessionManager = InstanceSessionManagerProtocolMock()
        let store = makeStore(#function)
        let viewModel = LearningSitesViewModel(
            instanceStore: store,
            storage: CoreStorageMock(),
            sessionManager: sessionManager,
            router: router,
            isSwitching: false
        )

        await viewModel.select(store.instancesConfig.instances[0])

        XCTAssertEqual(sessionManager.switchActiveInstanceCallCount, 1)
        XCTAssertEqual(router.showLoginScreenCallCount, 1)
        XCTAssertEqual(router.showMainOrWhatsNewScreenCallCount, 0)
    }

    func test_select_withExistingSession_switchesThenShowsMain() async {
        let router = AuthorizationRouterMock()
        let sessionManager = InstanceSessionManagerProtocolMock()
        let storage = CoreStorageMock()
        storage.sessionInstanceKeys = ["acme"]
        let store = makeStore(#function)
        let viewModel = LearningSitesViewModel(
            instanceStore: store,
            storage: storage,
            sessionManager: sessionManager,
            router: router,
            isSwitching: true
        )

        await viewModel.select(store.instance(withKey: "acme")!)

        XCTAssertEqual(sessionManager.switchActiveInstanceCallCount, 1)
        XCTAssertEqual(router.showMainOrWhatsNewScreenCallCount, 1)
        XCTAssertEqual(router.showLoginScreenCallCount, 0)
    }

    func test_logOut_callsSessionManagerAndRefreshesTheList() async {
        let sessionManager = InstanceSessionManagerProtocolMock()
        let storage = CoreStorageMock()
        storage.sessionInstanceKeys = ["acme"]
        let store = makeStore(#function)
        let viewModel = LearningSitesViewModel(
            instanceStore: store,
            storage: storage,
            sessionManager: sessionManager,
            router: AuthorizationRouterMock(),
            isSwitching: true
        )
        let acme = store.instance(withKey: "acme")!
        XCTAssertEqual(viewModel.currentLearningSites.map(\.key), ["acme"])

        // The mock session manager doesn't touch `storage` itself -- mirror what the real
        // InstanceSessionManager does so `refresh()` sees the logout reflected.
        sessionManager.logoutHandler = { _ in storage.sessionInstanceKeys.remove("acme") }
        await viewModel.logOut(acme)

        XCTAssertEqual(sessionManager.logoutCallCount, 1)
        XCTAssertTrue(viewModel.currentLearningSites.isEmpty)
    }
}

//
//  InstanceSessionManagerTests.swift
//  Core
//
//  Created by Rawan Matar on 20/09/2026.
//

import XCTest
import Foundation
import Theme
@testable import Core

private final class PushTokenUnregisteringSpy: PushTokenUnregistering, @unchecked Sendable {
    private(set) var unregisterCallCount = 0
    func unregisterCurrentPushToken() async { unregisterCallCount += 1 }
}

@MainActor
final class InstanceSessionManagerTests: XCTestCase {

    private let instanceA = Instance.mock(key: "instanceA", name: "Instance A")
    private let instanceB = Instance.mock(key: "instanceB", name: "Instance B")

    private var instanceStore: InstanceStore!
    private var storage: CoreStorageMock!
    private var downloadManager: DownloadManagerProtocolMock!
    private var pushTokenUnregistrar: PushTokenUnregisteringSpy!
    private var sut: InstanceSessionManager!

    override func setUp() {
        super.setUp()
        let suiteName = "InstanceSessionManagerTests.\(UUID().uuidString)"
        instanceStore = InstanceStore(userDefaults: UserDefaults(suiteName: suiteName)!) {
            InstancesConfig(array: [])
        }
        storage = CoreStorageMock()
        downloadManager = DownloadManagerProtocolMock()
        pushTokenUnregistrar = PushTokenUnregisteringSpy()
        sut = InstanceSessionManager(
            instanceStore: instanceStore,
            storage: storage,
            downloadManager: downloadManager,
            pushTokenUnregistrar: pushTokenUnregistrar
        )
    }

    // Switching never tears anything down.
    func testSwitchActiveInstance_DoesNotTearDownOutgoingInstance() async {
        instanceStore.select(instanceA)

        await sut.switchActiveInstance(to: instanceB)

        XCTAssertEqual(downloadManager.cancelAllDownloadingCallCount, 0)
        XCTAssertEqual(storage.clearCallCount, 0)
        XCTAssertEqual(pushTokenUnregistrar.unregisterCallCount, 0)
        XCTAssertEqual(instanceStore.currentInstance, instanceB)
    }

    // Logout clears session state but keeps downloaded files.
    func testLogoutCurrentInstance_TearsDownSessionButKeepsCachedContent() async {
        instanceStore.select(instanceA)

        await sut.logoutCurrentInstance()

        XCTAssertEqual(downloadManager.cancelAllDownloadingCallCount, 1)
        XCTAssertEqual(downloadManager.deleteAllCallCount, 0)
        XCTAssertEqual(pushTokenUnregistrar.unregisterCallCount, 1)
        XCTAssertEqual(storage.clearCallCount, 1)
        XCTAssertNil(instanceStore.currentInstance)
    }

    // Logout still works with no push conformance wired.
    func testLogoutCurrentInstance_WithoutPushConformance_StillCompletesTeardown() async {
        let sutWithoutPush = InstanceSessionManager(
            instanceStore: instanceStore,
            storage: storage,
            downloadManager: downloadManager
        )
        instanceStore.select(instanceA)

        await sutWithoutPush.logoutCurrentInstance()

        XCTAssertEqual(downloadManager.cancelAllDownloadingCallCount, 1)
        XCTAssertEqual(storage.clearCallCount, 1)
        XCTAssertNil(instanceStore.currentInstance)
    }

    // Switching to an instance with its own accent_color applies it app-wide via the
    // existing Theme.Colors/UIColors.update() mechanism; logging out resets to the default.
    func testSwitchActiveInstance_WithAccentColor_UpdatesThemeThenLogoutResets() async {
        let branded = Instance(dictionary: [
            "NAME": "Branded", "OAUTH_CLIENT_ID": "branded-id", "API_HOST_URL": "https://branded.example.com",
            "THEME": ["LIGHT": ["accent_color": "#112233"]]
        ])!

        await sut.switchActiveInstance(to: branded)

        XCTAssertEqual(Theme.UIColors.accentColor.cgColor, UIColor(hex: "#112233")!.cgColor)

        await sut.logoutCurrentInstance()

        XCTAssertEqual(Theme.UIColors.accentColor.cgColor, ThemeAssets.accentColor.color.cgColor)
    }

    // A plain COLOR field (no nested THEME.LIGHT/DARK) still applies -- most instances don't
    // configure the full light/dark palette.
    func testSwitchActiveInstance_WithOnlyFlatColor_StillAppliesAccentColor() async {
        let branded = Instance(dictionary: [
            "NAME": "Branded", "OAUTH_CLIENT_ID": "branded-id", "API_HOST_URL": "https://branded.example.com",
            "COLOR": "#445566"
        ])!

        await sut.switchActiveInstance(to: branded)

        XCTAssertEqual(Theme.UIColors.accentColor.cgColor, UIColor(hex: "#445566")!.cgColor)
    }

    // AppDelegate refreshes window.tintColor (a one-time snapshot, not live-bound to
    // Theme.UIColors.accentColor) off this notification -- it has to actually fire.
    func testApplyThemeForCurrentInstance_PostsAccentColorDidChange() async {
        let expectation = expectation(forNotification: .accentColorDidChange, object: nil)
        await sut.switchActiveInstance(to: instanceA)
        await fulfillment(of: [expectation], timeout: 1)
    }
}

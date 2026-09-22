//
//  InstanceSessionManagerTests.swift
//  Core
//
//  Created by Rawan Matar on 20/09/2026.
//

import XCTest
import Foundation
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
}

//
//  InstanceStoreTests.swift
//  CoreTests
//
//  Created by Rawan Matar on 31/08/2026.
//

import XCTest
@testable import Core

final class InstanceStoreTests: XCTestCase {

    private func freshUserDefaults(_ name: String) -> UserDefaults {
        let defaults = UserDefaults(suiteName: name)!
        defaults.removePersistentDomain(forName: name)
        return defaults
    }

    func test_singleInstanceCatalog_noPriorSelection_autoSelectsTheOnlyInstance() {
        let onlyInstance = Instance.mock(key: "acme")
        let catalog = InstancesConfig(array: [
            ["KEY": "acme", "NAME": "Acme", "OAUTH_CLIENT_ID": "acme-id", "API_HOST_URL": "https://acme.example.com"]
        ])
        let defaults = freshUserDefaults(#function)

        let store = InstanceStore(userDefaults: defaults, instancesConfig: { catalog })

        XCTAssertEqual(store.currentInstance?.key, onlyInstance.key)
        // Persisted, so it survives relaunch and .instanceDidChange observers see it.
        XCTAssertEqual(defaults.string(forKey: "selectedInstanceKey"), "acme")
    }

    func test_multiInstanceCatalog_noPriorSelection_doesNotAutoSelect() {
        let catalog = InstancesConfig(array: [
            ["NAME": "Acme", "OAUTH_CLIENT_ID": "acme-id", "API_HOST_URL": "https://acme.example.com"],
            ["NAME": "Beta", "OAUTH_CLIENT_ID": "beta-id", "API_HOST_URL": "https://beta.example.com"]
        ])
        let defaults = freshUserDefaults(#function)

        let store = InstanceStore(userDefaults: defaults, instancesConfig: { catalog })

        XCTAssertNil(store.currentInstance)
    }

    func test_singleInstanceCatalog_staleSavedKey_reselectsTheOnlyInstance() {
        let catalog = InstancesConfig(array: [
            ["KEY": "acme", "NAME": "Acme", "OAUTH_CLIENT_ID": "acme-id", "API_HOST_URL": "https://acme.example.com"]
        ])
        let defaults = freshUserDefaults(#function)
        defaults.set("some-other-instance", forKey: "selectedInstanceKey")

        let store = InstanceStore(userDefaults: defaults, instancesConfig: { catalog })

        XCTAssertEqual(store.currentInstance?.key, "acme")
    }

    func test_singleInstanceCatalog_matchingSavedKey_resolvesWithoutReselecting() {
        let catalog = InstancesConfig(array: [
            ["KEY": "acme", "NAME": "Acme", "OAUTH_CLIENT_ID": "acme-id", "API_HOST_URL": "https://acme.example.com"]
        ])
        let defaults = freshUserDefaults(#function)
        defaults.set("acme", forKey: "selectedInstanceKey")

        let store = InstanceStore(userDefaults: defaults, instancesConfig: { catalog })

        XCTAssertEqual(store.currentInstance?.key, "acme")
    }

    func test_emptyCatalog_noPriorSelection_leavesCurrentInstanceNil() {
        let defaults = freshUserDefaults(#function)

        let store = InstanceStore(userDefaults: defaults, instancesConfig: { InstancesConfig() })

        XCTAssertNil(store.currentInstance)
    }

    func test_singleInstanceCatalog_deselecting_reselectsTheOnlyInstance() {
        let catalog = InstancesConfig(array: [
            ["KEY": "acme", "NAME": "Acme", "OAUTH_CLIENT_ID": "acme-id", "API_HOST_URL": "https://acme.example.com"]
        ])
        let defaults = freshUserDefaults(#function)
        let store = InstanceStore(userDefaults: defaults, instancesConfig: { catalog })
        XCTAssertEqual(store.currentInstance?.key, "acme")

        store.select(nil)

        XCTAssertEqual(store.currentInstance?.key, "acme")
    }

    func test_multiInstanceCatalog_deselecting_staysDeselected() {
        let catalog = InstancesConfig(array: [
            ["KEY": "acme", "NAME": "Acme", "OAUTH_CLIENT_ID": "acme-id", "API_HOST_URL": "https://acme.example.com"],
            ["KEY": "beta", "NAME": "Beta", "OAUTH_CLIENT_ID": "beta-id", "API_HOST_URL": "https://beta.example.com"]
        ])
        let defaults = freshUserDefaults(#function)
        let store = InstanceStore(userDefaults: defaults, instancesConfig: { catalog })
        store.select(catalog.instances[0])

        store.select(nil)

        XCTAssertNil(store.currentInstance)
    }
}

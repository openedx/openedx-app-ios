//
//  TenantStoreTests.swift
//  CoreTests
//
//  Created by Rawan Matar on 31/08/2026.
//

import XCTest
@testable import Core

final class TenantStoreTests: XCTestCase {

    private func freshUserDefaults(_ name: String) -> UserDefaults {
        let defaults = UserDefaults(suiteName: name)!
        defaults.removePersistentDomain(forName: name)
        return defaults
    }

    func test_singleTenantCatalog_noPriorSelection_autoSelectsTheOnlyTenant() {
        let onlyTenant = Tenant.mock(key: "acme")
        let catalog = TenantsConfig(array: [
            ["KEY": "acme", "name": "Acme", "OAUTH_CLIENT_ID": "acme-id", "API_HOST_URL": "https://acme.example.com"]
        ])
        let defaults = freshUserDefaults(#function)

        let store = TenantStore(userDefaults: defaults, tenantsConfig: { catalog })

        XCTAssertEqual(store.currentTenant?.key, onlyTenant.key)
        // Persisted, so it survives relaunch and .tenantDidChange observers see it.
        XCTAssertEqual(defaults.string(forKey: "selectedTenantKey"), "acme")
    }

    func test_multiTenantCatalog_noPriorSelection_doesNotAutoSelect() {
        let catalog = TenantsConfig(array: [
            ["name": "Acme", "OAUTH_CLIENT_ID": "acme-id", "API_HOST_URL": "https://acme.example.com"],
            ["name": "Beta", "OAUTH_CLIENT_ID": "beta-id", "API_HOST_URL": "https://beta.example.com"]
        ])
        let defaults = freshUserDefaults(#function)

        let store = TenantStore(userDefaults: defaults, tenantsConfig: { catalog })

        XCTAssertNil(store.currentTenant)
    }

    func test_singleTenantCatalog_staleSavedKey_reselectsTheOnlyTenant() {
        let catalog = TenantsConfig(array: [
            ["KEY": "acme", "name": "Acme", "OAUTH_CLIENT_ID": "acme-id", "API_HOST_URL": "https://acme.example.com"]
        ])
        let defaults = freshUserDefaults(#function)
        defaults.set("some-other-tenant", forKey: "selectedTenantKey")

        let store = TenantStore(userDefaults: defaults, tenantsConfig: { catalog })

        XCTAssertEqual(store.currentTenant?.key, "acme")
    }

    func test_singleTenantCatalog_matchingSavedKey_resolvesWithoutReselecting() {
        let catalog = TenantsConfig(array: [
            ["KEY": "acme", "name": "Acme", "OAUTH_CLIENT_ID": "acme-id", "API_HOST_URL": "https://acme.example.com"]
        ])
        let defaults = freshUserDefaults(#function)
        defaults.set("acme", forKey: "selectedTenantKey")

        let store = TenantStore(userDefaults: defaults, tenantsConfig: { catalog })

        XCTAssertEqual(store.currentTenant?.key, "acme")
    }

    func test_emptyCatalog_noPriorSelection_leavesCurrentTenantNil() {
        let defaults = freshUserDefaults(#function)

        let store = TenantStore(userDefaults: defaults, tenantsConfig: { TenantsConfig() })

        XCTAssertNil(store.currentTenant)
    }

    func test_singleTenantCatalog_deselecting_reselectsTheOnlyTenant() {
        let catalog = TenantsConfig(array: [
            ["KEY": "acme", "name": "Acme", "OAUTH_CLIENT_ID": "acme-id", "API_HOST_URL": "https://acme.example.com"]
        ])
        let defaults = freshUserDefaults(#function)
        let store = TenantStore(userDefaults: defaults, tenantsConfig: { catalog })
        XCTAssertEqual(store.currentTenant?.key, "acme")

        store.select(nil)

        XCTAssertEqual(store.currentTenant?.key, "acme")
    }

    func test_multiTenantCatalog_deselecting_staysDeselected() {
        let catalog = TenantsConfig(array: [
            ["KEY": "acme", "name": "Acme", "OAUTH_CLIENT_ID": "acme-id", "API_HOST_URL": "https://acme.example.com"],
            ["KEY": "beta", "name": "Beta", "OAUTH_CLIENT_ID": "beta-id", "API_HOST_URL": "https://beta.example.com"]
        ])
        let defaults = freshUserDefaults(#function)
        let store = TenantStore(userDefaults: defaults, tenantsConfig: { catalog })
        store.select(catalog.tenants[0])

        store.select(nil)

        XCTAssertNil(store.currentTenant)
    }
}

//
//  TenantStore.swift
//  Core
//
//  Created by Rawan Matar on 31/08/2026.
//

import Foundation

extension Notification.Name {
    public static let tenantDidChange = Notification.Name("org.openedx.core.tenantDidChange")
}

/// Single source of truth for the selected tenant and the tenant catalog.
public final class TenantStore: TenantProvider, @unchecked Sendable {

    private static let userDefaultsKey = "selectedTenantKey"

    private let lock = NSLock()
    private let userDefaults: UserDefaults
    private let localTenantsConfig: () -> TenantsConfig
    private var _remoteTenantsConfig: TenantsConfig?
    private var _currentTenant: Tenant?

    public var currentTenant: Tenant? {
        lock.lock(); defer { lock.unlock() }
        return _currentTenant
    }

    /// The catalog currently in effect: the remote one once set, else `localTenantsConfig`.
    public var tenantsConfig: TenantsConfig {
        lock.lock(); defer { lock.unlock() }
        return _remoteTenantsConfig ?? localTenantsConfig()
    }

    public init(
        userDefaults: UserDefaults = .standard,
        tenantsConfig: @escaping () -> TenantsConfig = { TenantsConfig() }
    ) {
        self.userDefaults = userDefaults
        self.localTenantsConfig = tenantsConfig
        restoreSelection()
    }

    /// Replaces the effective catalog and re-resolves the persisted selection against it.
    public func updateTenantsConfig(_ tenantsConfig: TenantsConfig) {
        lock.lock()
        _remoteTenantsConfig = tenantsConfig
        lock.unlock()
        restoreSelection()
    }

    /// Selects a tenant (or clears it with `nil`) and persists the choice.
    public func select(_ tenant: Tenant?) {
        lock.lock()
        _currentTenant = tenant
        lock.unlock()

        if let tenant {
            userDefaults.set(tenant.key, forKey: Self.userDefaultsKey)
        } else {
            userDefaults.removeObject(forKey: Self.userDefaultsKey)
        }

        NotificationCenter.default.post(name: .tenantDidChange, object: tenant)

        // Re-run auto-select so a deselect on a single-tenant catalog doesn't strand
        // `currentTenant` at nil until the next launch.
        if tenant == nil {
            restoreSelection()
        }
    }

    public func reset() {
        select(nil)
    }

    private func restoreSelection() {
        let catalog = tenantsConfig
        let savedKey = userDefaults.string(forKey: Self.userDefaultsKey)
        let resolved = savedKey.flatMap { catalog.tenant(withKey: $0) }

        // Auto-select the sole tenant in a single-tenant catalog — there's no picker
        // to choose it through otherwise.
        if resolved == nil, catalog.tenants.count == 1, let onlyTenant = catalog.tenants.first {
            select(onlyTenant)
            return
        }

        lock.lock()
        _currentTenant = resolved
        lock.unlock()
    }
}

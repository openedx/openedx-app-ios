//
//  InstanceStore.swift
//  Core
//
//  Created by Rawan Matar on 31/08/2026.
//

import Foundation

extension Notification.Name {
    public static let instanceDidChange = Notification.Name("org.openedx.core.instanceDidChange")
}

/// Single source of truth for the selected instance and the instance catalog.
public final class InstanceStore: InstanceProvider, @unchecked Sendable {

    private static let userDefaultsKey = "selectedInstanceKey"

    private let lock = NSLock()
    private let userDefaults: UserDefaults
    private let localInstancesConfig: () -> InstancesConfig
    private var _remoteInstancesConfig: InstancesConfig?
    private var _currentInstance: Instance?

    public var currentInstance: Instance? {
        lock.lock(); defer { lock.unlock() }
        return _currentInstance
    }

    /// The catalog currently in effect: the remote one once set, else `localInstancesConfig`.
    public var instancesConfig: InstancesConfig {
        lock.lock(); defer { lock.unlock() }
        return _remoteInstancesConfig ?? localInstancesConfig()
    }

    public init(
        userDefaults: UserDefaults = .standard,
        instancesConfig: @escaping () -> InstancesConfig = { InstancesConfig() }
    ) {
        self.userDefaults = userDefaults
        self.localInstancesConfig = instancesConfig
        restoreSelection()
    }

    /// Replaces the effective catalog and re-resolves the persisted selection against it.
    public func updateInstancesConfig(_ instancesConfig: InstancesConfig) {
        lock.lock()
        _remoteInstancesConfig = instancesConfig
        lock.unlock()
        restoreSelection()
    }

    /// Selects an instance (or clears it with `nil`) and persists the choice.
    public func select(_ instance: Instance?) {
        lock.lock()
        _currentInstance = instance
        lock.unlock()

        if let instance {
            userDefaults.set(instance.key, forKey: Self.userDefaultsKey)
        } else {
            userDefaults.removeObject(forKey: Self.userDefaultsKey)
        }

        NotificationCenter.default.post(name: .instanceDidChange, object: instance)

        // Re-run auto-select so a deselect on a single-instance catalog doesn't strand
        // `currentInstance` at nil until the next launch.
        if instance == nil {
            restoreSelection()
        }
    }

    public func reset() {
        select(nil)
    }

    private func restoreSelection() {
        let catalog = instancesConfig
        let savedKey = userDefaults.string(forKey: Self.userDefaultsKey)
        let resolved = savedKey.flatMap { catalog.instance(withKey: $0) }

        // Auto-select the sole instance in a single-instance catalog — there's no picker
        // to choose it through otherwise.
        if resolved == nil, catalog.instances.count == 1, let onlyInstance = catalog.instances.first {
            select(onlyInstance)
            return
        }

        lock.lock()
        _currentInstance = resolved
        lock.unlock()
    }
}

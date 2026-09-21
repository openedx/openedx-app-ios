//
//  InstanceNamespacedDefaults.swift
//  Core
//
//  Created by Rawan Matar on 17/09/2026.
//

import Foundation

/// Scopes a storage key to the currently selected instance.
public struct InstanceNamespacedKey: Sendable {
    private let instanceStore: InstanceProvider

    public init(instanceStore: InstanceProvider) {
        self.instanceStore = instanceStore
    }

    /// e.g. "acme.accessToken", "default.accessToken".
    public func scoped(_ rawKey: String) -> String {
        "\(instanceStore.currentInstanceKey).\(rawKey)"
    }
}

//
//  InstanceConfigLoader.swift
//  Core
//
//  Created by Rawan Matar on 31/08/2026.
//

import Foundation

/// Decides where the instance catalog comes from at app launch.
///
/// The baseline is the last-known-good catalog: the last successfully fetched remote
/// response if one was ever cached, otherwise the catalog bundled with the binary. Every
/// launch awaits a live fetch and, if it returns at least one instance, that response
/// wholesale-replaces the baseline and becomes the new cache -- so a later offline launch
/// sees the same catalog the user had last time, not a reset back to the bundled default.
/// A fetch that fails, or succeeds with zero instances, leaves the baseline untouched.
///
/// Callers `await load()` and hand the result to `InstanceStore.updateInstancesConfig(_:)`
/// before showing the instance picker or sign-in screen -- see `RouteController.swift`.
public final class InstanceConfigLoader: Sendable {
    private static let cacheKey = "org.openedx.core.cachedInstancesJSON"

    private let apiService: InstanceApiServiceProtocol
    // UserDefaults is documented as thread-safe, but its Sendable conformance isn't
    // visible to the compiler at this SDK target.
    nonisolated(unsafe) private let userDefaults: UserDefaults

    public init(
        apiService: InstanceApiServiceProtocol = InstanceApiService(),
        userDefaults: UserDefaults = .standard
    ) {
        self.apiService = apiService
        self.userDefaults = userDefaults
    }

    public func load() async -> InstancesConfig {
        let baseline = Self.loadCached(userDefaults) ?? Self.loadBundled() ?? InstancesConfig()

        do {
            let data = try await apiService.fetchRawData()
            let fetched = try InstancesConfig(jsonData: data)
            guard !fetched.instances.isEmpty else {
                // Remote is reachable but has nothing -- keep whatever the baseline already is.
                return baseline
            }
            userDefaults.set(data, forKey: Self.cacheKey)
            return fetched
        } catch {
            #if DEBUG
            print("⚠️ InstanceConfigLoader: live fetch failed (\(error)) — using baseline")
            #endif
            return baseline
        }
    }

    /// The last remote response that actually replaced the baseline -- `nil` if none was
    /// ever cached, or if the cached bytes no longer parse.
    private static func loadCached(_ userDefaults: UserDefaults) -> InstancesConfig? {
        guard let data = userDefaults.data(forKey: cacheKey) else {
            return nil
        }
        return try? InstancesConfig(jsonData: data)
    }

    /// Ships with the binary -- the baseline before any remote fetch has ever succeeded.
    private static func loadBundled() -> InstancesConfig? {
        guard let url = Bundle.main.url(forResource: "config", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            return nil
        }
        return try? InstancesConfig(jsonData: data)
    }
}

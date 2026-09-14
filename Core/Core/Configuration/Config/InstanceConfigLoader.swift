//
//  InstanceConfigLoader.swift
//  Core
//
//  Created by Rawan Matar on 31/08/2026.
//

import Foundation

/// Decides where the instance catalog comes from at app launch. Live-fetch-first --
/// always awaits the API so a freshly published catalog wins over a stale cache -- then
/// falls back through the last cached copy, the catalog bundled with the binary, and
/// finally an empty catalog, in that order, if the live fetch fails for any reason
/// (including no `INSTANCES_CATALOG_URL` being configured at all).
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
        do {
            let data = try await apiService.fetchRawData()
            let fetched = try InstancesConfig(jsonData: data)
            userDefaults.set(data, forKey: Self.cacheKey)
            return fetched
        } catch {
            #if DEBUG
            print("⚠️ InstanceConfigLoader: live fetch failed (\(error)) — falling back to cache")
            #endif
            if let cachedData = userDefaults.data(forKey: Self.cacheKey),
               let cached = try? InstancesConfig(jsonData: cachedData) {
                return cached
            }
            if let bundled = Self.loadBundled() {
                return bundled
            }
            return InstancesConfig()
        }
    }

    /// Ships with the binary -- last resort before an empty catalog.
    private static func loadBundled() -> InstancesConfig? {
        guard let url = Bundle.main.url(forResource: "config", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            return nil
        }
        return try? InstancesConfig(jsonData: data)
    }
}

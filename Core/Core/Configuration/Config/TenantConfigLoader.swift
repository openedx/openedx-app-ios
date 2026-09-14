//
//  TenantConfigLoader.swift
//  Core
//
//  Created by Rawan Matar on 31/08/2026.
//

import Foundation

/// Decides where the tenant catalog comes from at app launch. Live-fetch-first with
/// cache fallback -- always awaits the API so a freshly published catalog wins over a
/// stale cache; falls back to the last cached copy (then an empty catalog) if the
/// live fetch fails for any reason.
///
/// Callers `await load()` and hand the result to `TenantStore.updateTenantsConfig(_:)`
/// before showing the tenant picker or sign-in screen -- see `RouteController.swift`.
public final class TenantConfigLoader: Sendable {
    private static let cacheKey = "org.openedx.core.cachedTenantsJSON"

    private let apiService: TenantApiServiceProtocol
    // UserDefaults is documented as thread-safe, but its Sendable conformance isn't
    // visible to the compiler at this SDK target.
    nonisolated(unsafe) private let userDefaults: UserDefaults

    public init(
        apiService: TenantApiServiceProtocol = TenantApiService(),
        userDefaults: UserDefaults = .standard
    ) {
        self.apiService = apiService
        self.userDefaults = userDefaults
    }

    public func load() async -> TenantsConfig {
        do {
            let data = try await apiService.fetchRawData()
            let fetched = try TenantsConfig(jsonData: data)
            userDefaults.set(data, forKey: Self.cacheKey)
            return fetched
        } catch {
            #if DEBUG
            print("⚠️ TenantConfigLoader: live fetch failed (\(error)) — falling back to cache")
            #endif
            if let cachedData = userDefaults.data(forKey: Self.cacheKey),
               let cached = try? TenantsConfig(jsonData: cachedData) {
                return cached
            }
            return TenantsConfig()
        }
    }
}

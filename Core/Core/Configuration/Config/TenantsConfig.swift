//
//  TenantsConfig.swift
//  Core
//
//  Created by Rawan Matar on 31/08/2026.
//

import Foundation
import OEXFoundation

// MARK: - TenantProvider

/// Read-only, thread-safe access to the currently selected tenant.
public protocol TenantProvider: Sendable {
    /// `nil` when no tenant is selected (e.g. single-tenant deployment).
    var currentTenant: Tenant? { get }
}

// MARK: - Tenant

private enum TenantKeys: String, RawStringExtractable {
    case key = "KEY"
    case name
    case tenantName = "TENANT_NAME"
    case color
    case oAuthClientId = "OAUTH_CLIENT_ID"
    case baseURL = "API_HOST_URL"
    case baseURLHiddenLogin = "API_HOST_URL_HIDDEN_LOGIN"
    case baseSSOURL = "SSO_URL"
    case successfulSSOLoginURL = "SSO_URL_SUCCESSFUL_LOGIN"
    case environmentDisplayName = "ENVIRONMENT_DISPLAY_NAME"
    case isSwitchTenantLoginEnabled = "IS_SWITCH_TENANT_LOGIN_ENABLED"
    case uiComponents = "UI_COMPONENTS"
    case logoURL = "LOGO_URL"
    case headerBackgroundURL = "HEADER_BACKGROUND_URL"
    case theme = "THEME"
}

/// Per-mode (`light`/`dark`) color overrides parsed from the tenant's `THEME` block.
/// Missing keys fall back to `ThemeColorSet.derived(fromHex:light:dark:)`.
public struct TenantThemeColors: Codable, Sendable, Equatable {
    public let light: [String: String]
    public let dark: [String: String]

    public init(light: [String: String], dark: [String: String]) {
        self.light = light
        self.dark = dark
    }
}

public struct Tenant: Codable, Identifiable, Sendable, Equatable, Hashable {
    /// Same as `key`.
    public var id: String { key }

    /// Machine-readable identifier, e.g. "niepd". Falls back to a slugified `name`.
    public let key: String
    public let name: String
    public let tenantName: String
    public let color: String
    public let oAuthClientId: String
    public let baseURL: URL
    /// Falls back to `baseURL` if not set.
    public let baseURLHiddenLogin: URL
    public let baseSSOURL: URL?
    public let successfulSSOLoginURL: URL?
    public let environmentDisplayName: String?
    public let isSwitchTenantLoginEnabled: Bool
    public let uiComponents: UIComponentsConfig
    /// Remote URL, or a bundled asset name. `nil` keeps the default logo.
    public let logoURLString: String?
    /// Remote URL only. `nil` keeps the default header background.
    public let headerBackgroundURLString: String?
    /// `nil` derives the palette from `color` instead.
    public let themeColors: TenantThemeColors?

    public static func == (lhs: Tenant, rhs: Tenant) -> Bool {
        lhs.key == rhs.key
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(key)
    }

    /// Fails if required fields (`name`, `API_HOST_URL`, `OAUTH_CLIENT_ID`) are missing.
    public init?(dictionary: [String: Any]) {
        guard let name = dictionary[TenantKeys.name] as? String, !name.isEmpty,
              let urlString = dictionary[TenantKeys.baseURL] as? String,
              let baseURL = URL(string: urlString),
              let oAuthClientId = dictionary[TenantKeys.oAuthClientId] as? String, !oAuthClientId.isEmpty
        else { return nil }

        self.name = name
        self.baseURL = baseURL
        self.oAuthClientId = oAuthClientId

        if let explicitKey = dictionary[TenantKeys.key] as? String, !explicitKey.isEmpty {
            self.key = explicitKey
        } else {
            self.key = Tenant.slugify(name)
        }

        var languageCode = "en"
        if let langCode = Locale.preferredLanguages.first?.prefix(2) {
            languageCode = String(langCode)
        }
        if let tenantNameDict = dictionary[TenantKeys.tenantName] as? [String: Any] {
            self.tenantName = (tenantNameDict[languageCode] as? String)
                ?? (tenantNameDict["en"] as? String)
                ?? name
        } else {
            self.tenantName = name
        }

        self.color = dictionary[TenantKeys.color] as? String ?? "#007AFF"
        self.isSwitchTenantLoginEnabled = dictionary[TenantKeys.isSwitchTenantLoginEnabled] as? Bool ?? false

        if let hiddenLoginString = dictionary[TenantKeys.baseURLHiddenLogin] as? String,
           let hiddenLoginURL = URL(string: hiddenLoginString) {
            self.baseURLHiddenLogin = hiddenLoginURL
        } else {
            self.baseURLHiddenLogin = baseURL
        }

        if let ssoString = dictionary[TenantKeys.baseSSOURL] as? String {
            self.baseSSOURL = URL(string: ssoString)
        } else {
            self.baseSSOURL = nil
        }

        if let successString = dictionary[TenantKeys.successfulSSOLoginURL] as? String {
            self.successfulSSOLoginURL = URL(string: successString)
        } else {
            self.successfulSSOLoginURL = nil
        }

        self.environmentDisplayName = dictionary[TenantKeys.environmentDisplayName] as? String

        if let uiDict = dictionary[TenantKeys.uiComponents] as? [String: Any] {
            self.uiComponents = UIComponentsConfig(dictionary: uiDict)
        } else {
            self.uiComponents = UIComponentsConfig(dictionary: [:])
        }

        self.logoURLString = dictionary[TenantKeys.logoURL] as? String
        self.headerBackgroundURLString = dictionary[TenantKeys.headerBackgroundURL] as? String

        if let themeDict = dictionary[TenantKeys.theme] as? [String: Any] {
            self.themeColors = TenantThemeColors(
                light: themeDict["light"] as? [String: String] ?? [:],
                dark: themeDict["dark"] as? [String: String] ?? [:]
            )
        } else {
            self.themeColors = nil
        }
    }

    private static func slugify(_ name: String) -> String {
        name.lowercased()
            .folding(options: .diacriticInsensitive, locale: .current)
            .replacingOccurrences(of: "[^a-z0-9]+", with: "-", options: .regularExpression)
            .trimmingCharacters(in: CharacterSet(charactersIn: "-"))
    }

    // MARK: Codable
    // `uiComponents` and remote-media fields aren't persisted; re-populated from
    // `TenantStore.tenantsConfig` right after decode.
    private enum CodingKeys: String, CodingKey {
        case key, name, tenantName, color, oAuthClientId
        case baseURL, baseURLHiddenLogin, baseSSOURL, successfulSSOLoginURL
        case environmentDisplayName, isSwitchTenantLoginEnabled
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        key = try container.decode(String.self, forKey: .key)
        name = try container.decode(String.self, forKey: .name)
        tenantName = try container.decode(String.self, forKey: .tenantName)
        color = try container.decode(String.self, forKey: .color)
        oAuthClientId = try container.decode(String.self, forKey: .oAuthClientId)
        baseURL = try container.decode(URL.self, forKey: .baseURL)
        baseURLHiddenLogin = try container.decode(URL.self, forKey: .baseURLHiddenLogin)
        baseSSOURL = try container.decodeIfPresent(URL.self, forKey: .baseSSOURL)
        successfulSSOLoginURL = try container.decodeIfPresent(URL.self, forKey: .successfulSSOLoginURL)
        environmentDisplayName = try container.decodeIfPresent(String.self, forKey: .environmentDisplayName)
        isSwitchTenantLoginEnabled = try container.decode(Bool.self, forKey: .isSwitchTenantLoginEnabled)
        uiComponents = UIComponentsConfig(dictionary: [:])
        logoURLString = nil
        headerBackgroundURLString = nil
        themeColors = nil
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(key, forKey: .key)
        try container.encode(name, forKey: .name)
        try container.encode(tenantName, forKey: .tenantName)
        try container.encode(color, forKey: .color)
        try container.encode(oAuthClientId, forKey: .oAuthClientId)
        try container.encode(baseURL, forKey: .baseURL)
        try container.encode(baseURLHiddenLogin, forKey: .baseURLHiddenLogin)
        try container.encodeIfPresent(baseSSOURL, forKey: .baseSSOURL)
        try container.encodeIfPresent(successfulSSOLoginURL, forKey: .successfulSSOLoginURL)
        try container.encodeIfPresent(environmentDisplayName, forKey: .environmentDisplayName)
        try container.encode(isSwitchTenantLoginEnabled, forKey: .isSwitchTenantLoginEnabled)
    }
}

// MARK: - TenantsConfig

public struct TenantsConfig: Sendable {
    public let tenants: [Tenant]

    public init() {
        self.tenants = []
    }

    /// - Parameter fallback: base `config.yaml` values used to fill fields a
    ///   `TENANTS` entry omits (tenant-level wins).
    public init(array: [[String: Any]], fallback: [String: Any] = [:]) {
        // Drop invalid entries instead of producing a half-populated Tenant.
        self.tenants = array.compactMap { dict in
            let merged = fallback.merging(dict) { _, tenantValue in tenantValue }
            guard let tenant = Tenant(dictionary: merged) else {
                #if DEBUG
                print("⚠️ TenantsConfig: skipping malformed TENANTS entry: \(dict["name"] ?? "<unknown>")")
                #endif
                return nil
            }
            return tenant
        }
    }

    public func tenant(withKey key: String) -> Tenant? {
        tenants.first { $0.key == key }
    }
}

#if DEBUG
public extension Tenant {
    static func mock(
        key: String = "mock",
        name: String = "Test",
        tenantName: String = "Test",
        color: String = "#fff",
        oAuthClientId: String = "mockClientId",
        baseURL: URL = URL(string: "https://mock.base.url")!
    ) -> Tenant {
        Tenant(dictionary: [
            "KEY": key,
            "name": name,
            "TENANT_NAME": ["en": tenantName],
            "color": color,
            "OAUTH_CLIENT_ID": oAuthClientId,
            "API_HOST_URL": baseURL.absoluteString
        ])!
    }
}

public final class TenantProviderMock: TenantProvider, @unchecked Sendable {
    public var currentTenant: Tenant?
    public init(currentTenant: Tenant? = .mock()) {
        self.currentTenant = currentTenant
    }
}
#endif

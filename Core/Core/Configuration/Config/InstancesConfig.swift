//
//  InstancesConfig.swift
//  Core
//
//  Created by Rawan Matar on 31/08/2026.
//

import Foundation
import OEXFoundation

// MARK: - InstanceProvider

/// Read-only, thread-safe access to the currently selected instance.
public protocol InstanceProvider: Sendable {
    /// `nil` when no instance is selected (e.g. single-instance deployment).
    var currentInstance: Instance? { get }
}

// MARK: - Instance

private enum InstanceKeys: String, RawStringExtractable {
    case key = "KEY"
    case name = "NAME"
    case instanceName = "INSTANCE_NAME"
    case color = "COLOR"
    case oAuthClientId = "OAUTH_CLIENT_ID"
    case baseURL = "API_HOST_URL"
    case baseSSOURL = "SSO_URL"
    case successfulSSOLoginURL = "SSO_URL_SUCCESSFUL_LOGIN"
    case environmentDisplayName = "ENVIRONMENT_DISPLAY_NAME"
    case isSwitchInstanceLoginEnabled = "IS_SWITCH_INSTANCE_LOGIN_ENABLED"
    case uiComponents = "UI_COMPONENTS"
    case theme = "THEME"
}

/// Per-mode (`light`/`dark`) color overrides parsed from the instance's `THEME` block.
/// Missing keys fall back to `ThemeColorSet.derived(fromHex:light:dark:)`.
public struct InstanceThemeColors: Codable, Sendable, Equatable {
    public let light: [String: String]
    public let dark: [String: String]

    public init(light: [String: String], dark: [String: String]) {
        self.light = light
        self.dark = dark
    }
}

public struct Instance: Codable, Identifiable, Sendable, Equatable, Hashable {
    /// Same as `key`.
    public var id: String { key }

    /// Machine-readable identifier, e.g. "niepd". Falls back to a slugified `name`.
    public let key: String
    public let name: String
    public let instanceName: String
    public let color: String
    public let oAuthClientId: String
    public let baseURL: URL
    public let baseSSOURL: URL?
    public let successfulSSOLoginURL: URL?
    public let environmentDisplayName: String?
    public let isSwitchInstanceLoginEnabled: Bool
    public let uiComponents: UIComponentsConfig
    /// Remote URL, or a bundled asset name. `nil` keeps the default logo.
    public let logoURLString: String?
    /// Remote URL only. `nil` keeps the default header background.
    public let headerBackgroundURLString: String?
    /// `nil` derives the palette from `color` instead.
    public let themeColors: InstanceThemeColors?

    public static func == (lhs: Instance, rhs: Instance) -> Bool {
        lhs.key == rhs.key
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(key)
    }

    /// Fails if required fields (`name`, `API_HOST_URL`, `OAUTH_CLIENT_ID`) are missing.
    public init?(dictionary: [String: Any]) {
        guard let name = dictionary[InstanceKeys.name] as? String, !name.isEmpty,
              let urlString = dictionary[InstanceKeys.baseURL] as? String,
              let baseURL = URL(string: urlString),
              let oAuthClientId = dictionary[InstanceKeys.oAuthClientId] as? String, !oAuthClientId.isEmpty
        else { return nil }

        self.name = name
        self.baseURL = baseURL
        self.oAuthClientId = oAuthClientId

        if let explicitKey = dictionary[InstanceKeys.key] as? String, !explicitKey.isEmpty {
            self.key = explicitKey
        } else {
            self.key = Instance.slugify(name)
        }

        var languageCode = "en"
        if let langCode = Locale.preferredLanguages.first?.prefix(2) {
            languageCode = String(langCode)
        }
        if let instanceNameDict = dictionary[InstanceKeys.instanceName] as? [String: Any] {
            self.instanceName = (instanceNameDict[languageCode] as? String)
                ?? (instanceNameDict["en"] as? String)
                ?? name
        } else {
            self.instanceName = name
        }

        self.color = dictionary[InstanceKeys.color] as? String ?? "#007AFF"
        self.isSwitchInstanceLoginEnabled = dictionary[InstanceKeys.isSwitchInstanceLoginEnabled] as? Bool ?? false

        if let ssoString = dictionary[InstanceKeys.baseSSOURL] as? String {
            self.baseSSOURL = URL(string: ssoString)
        } else {
            self.baseSSOURL = nil
        }

        if let successString = dictionary[InstanceKeys.successfulSSOLoginURL] as? String {
            self.successfulSSOLoginURL = URL(string: successString)
        } else {
            self.successfulSSOLoginURL = nil
        }

        self.environmentDisplayName = dictionary[InstanceKeys.environmentDisplayName] as? String

        if let uiDict = dictionary[InstanceKeys.uiComponents] as? [String: Any] {
            self.uiComponents = UIComponentsConfig(dictionary: uiDict)
        } else {
            self.uiComponents = UIComponentsConfig(dictionary: [:])
        }

        // Logo/header live inside THEME (siblings of LIGHT/DARK) rather than as their
        // own top-level instance fields. Keys here are uppercase like the rest of the
        // schema -- only the light/dark palette dicts' own internal field names (e.g.
        // accent_color) stay lowercase, since those belong to Theme's already-shipped
        // ThemeColorSet.derived(fromHex:light:dark:) contract, not this file.
        let themeDict = dictionary[InstanceKeys.theme] as? [String: Any]
        self.logoURLString = themeDict?["LOGO_URL"] as? String
        self.headerBackgroundURLString = themeDict?["HEADER_BACKGROUND_URL"] as? String

        if let themeDict {
            self.themeColors = InstanceThemeColors(
                light: themeDict["LIGHT"] as? [String: String] ?? [:],
                dark: themeDict["DARK"] as? [String: String] ?? [:]
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
    // `InstanceStore.instancesConfig` right after decode.
    private enum CodingKeys: String, CodingKey {
        case key, name, instanceName, color, oAuthClientId
        case baseURL, baseSSOURL, successfulSSOLoginURL
        case environmentDisplayName, isSwitchInstanceLoginEnabled
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        key = try container.decode(String.self, forKey: .key)
        name = try container.decode(String.self, forKey: .name)
        instanceName = try container.decode(String.self, forKey: .instanceName)
        color = try container.decode(String.self, forKey: .color)
        oAuthClientId = try container.decode(String.self, forKey: .oAuthClientId)
        baseURL = try container.decode(URL.self, forKey: .baseURL)
        baseSSOURL = try container.decodeIfPresent(URL.self, forKey: .baseSSOURL)
        successfulSSOLoginURL = try container.decodeIfPresent(URL.self, forKey: .successfulSSOLoginURL)
        environmentDisplayName = try container.decodeIfPresent(String.self, forKey: .environmentDisplayName)
        isSwitchInstanceLoginEnabled = try container.decode(Bool.self, forKey: .isSwitchInstanceLoginEnabled)
        uiComponents = UIComponentsConfig(dictionary: [:])
        logoURLString = nil
        headerBackgroundURLString = nil
        themeColors = nil
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(key, forKey: .key)
        try container.encode(name, forKey: .name)
        try container.encode(instanceName, forKey: .instanceName)
        try container.encode(color, forKey: .color)
        try container.encode(oAuthClientId, forKey: .oAuthClientId)
        try container.encode(baseURL, forKey: .baseURL)
        try container.encodeIfPresent(baseSSOURL, forKey: .baseSSOURL)
        try container.encodeIfPresent(successfulSSOLoginURL, forKey: .successfulSSOLoginURL)
        try container.encodeIfPresent(environmentDisplayName, forKey: .environmentDisplayName)
        try container.encode(isSwitchInstanceLoginEnabled, forKey: .isSwitchInstanceLoginEnabled)
    }
}

// MARK: - InstancesConfig

public struct InstancesConfig: Sendable {
    public let instances: [Instance]

    public init() {
        self.instances = []
    }

    /// - Parameter fallback: base `config.yaml` values used to fill fields a
    ///   `INSTANCES` entry omits (instance-level wins).
    public init(array: [[String: Any]], fallback: [String: Any] = [:]) {
        // Drop invalid entries instead of producing a half-populated Instance.
        self.instances = array.compactMap { dict in
            let merged = fallback.merging(dict) { _, instanceValue in instanceValue }
            guard let instance = Instance(dictionary: merged) else {
                #if DEBUG
                print("⚠️ InstancesConfig: skipping malformed INSTANCES entry: \(dict["NAME"] ?? "<unknown>")")
                #endif
                return nil
            }
            return instance
        }
    }

    public func instance(withKey key: String) -> Instance? {
        instances.first { $0.key == key }
    }
}

// MARK: - Remote (JSON) parsing

/// Thrown when a JSON payload isn't a bare instance array or an INSTANCES/instances-keyed object.
public enum InstanceJSONError: Error, Equatable {
    case unrecognizedShape
}

/// Maps the live API's snake_case field names to the upper-snake-case keys
/// `Instance.init?(dictionary:)` expects (shared with the YAML parser).
private let remoteToYAMLKeyMap: [String: String] = [
    "key": "KEY",
    "name": "NAME",
    "color": "COLOR",
    "instance_name": "INSTANCE_NAME",
    "oauth_client_id": "OAUTH_CLIENT_ID",
    "api_host_url": "API_HOST_URL",
    "sso_url": "SSO_URL",
    "sso_url_successful_login": "SSO_URL_SUCCESSFUL_LOGIN",
    "environment_display_name": "ENVIRONMENT_DISPLAY_NAME",
    "is_switch_instance_login_enabled": "IS_SWITCH_INSTANCE_LOGIN_ENABLED",
    "ui_components": "UI_COMPONENTS",
    "course_dropdown_navigation_enabled": "COURSE_DROPDOWN_NAVIGATION_ENABLED",
    "course_unit_progress_enabled": "COURSE_UNIT_PROGRESS_ENABLED",
    "login_registration_enabled": "LOGIN_REGISTRATION_ENABLED",
    "saml_sso_login_enabled": "SAML_SSO_LOGIN_ENABLED",
    "saml_sso_default_login_button": "SAML_SSO_DEFAULT_LOGIN_BUTTON",
    "theme": "THEME",
    "light": "LIGHT",
    "dark": "DARK",
    "logo_url": "LOGO_URL",
    "header_background_url": "HEADER_BACKGROUND_URL"
]

/// Recursively remaps snake_case keys to their YAML equivalents; unmapped keys pass through.
private func normalizeRemoteKeys(_ dict: [String: Any]) -> [String: Any] {
    var result: [String: Any] = [:]
    for (key, value) in dict {
        let mappedKey = remoteToYAMLKeyMap[key.lowercased()] ?? key
        result[mappedKey] = (value as? [String: Any]).map(normalizeRemoteKeys) ?? value
    }
    return result
}

public extension InstancesConfig {
    /// Parses the same INSTANCES shape as `config.yaml`, sourced from JSON -- normalizes
    /// field names then hands off to the existing `init(array:fallback:)`. Accepts a
    /// bare array or a "instances"/"INSTANCES"-keyed object.
    init(jsonData: Data, fallback: [String: Any] = [:]) throws {
        let json = try JSONSerialization.jsonObject(with: jsonData)
        let rawArray: [[String: Any]]
        if let array = json as? [[String: Any]] {
            rawArray = array
        } else if let object = json as? [String: Any],
                  let wrapped = (object["INSTANCES"] ?? object["instances"]) as? [[String: Any]] {
            rawArray = wrapped
        } else {
            throw InstanceJSONError.unrecognizedShape
        }
        self.init(array: rawArray.map(normalizeRemoteKeys), fallback: fallback)
    }
}

#if DEBUG
public extension Instance {
    static func mock(
        key: String = "mock",
        name: String = "Test",
        instanceName: String = "Test",
        color: String = "#fff",
        oAuthClientId: String = "mockClientId",
        baseURL: URL = URL(string: "https://mock.base.url")!
    ) -> Instance {
        Instance(dictionary: [
            "KEY": key,
            "NAME": name,
            "INSTANCE_NAME": ["en": instanceName],
            "COLOR": color,
            "OAUTH_CLIENT_ID": oAuthClientId,
            "API_HOST_URL": baseURL.absoluteString
        ])!
    }
}

public final class InstanceProviderMock: InstanceProvider, @unchecked Sendable {
    public var currentInstance: Instance?
    public init(currentInstance: Instance? = .mock()) {
        self.currentInstance = currentInstance
    }
}
#endif

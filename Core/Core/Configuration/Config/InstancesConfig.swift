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
    case name
    case instanceName = "INSTANCE_NAME"
    case color
    case oAuthClientId = "OAUTH_CLIENT_ID"
    case baseURL = "API_HOST_URL"
    case baseURLHiddenLogin = "API_HOST_URL_HIDDEN_LOGIN"
    case baseSSOURL = "SSO_URL"
    case ssoFinishedURL = "SSO_FINISHED_URL"
    case environmentDisplayName = "ENVIRONMENT_DISPLAY_NAME"
    case isSwitchInstanceLoginEnabled = "IS_SWITCH_INSTANCE_LOGIN_ENABLED"
    case uiComponents = "UI_COMPONENTS"
    case logoURL = "LOGO_URL"
    case headerBackgroundURL = "HEADER_BACKGROUND_URL"
    case theme = "THEME"
    case feedbackEmail = "FEEDBACK_EMAIL_ADDRESS"
    case ssoButtonTitle = "SSO_BUTTON_TITLE"
    case experimentalFeatures = "EXPERIMENTAL_FEATURES"
    case agreementURLs = "AGREEMENT_URLS"
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
    /// Falls back to `baseURL` if not set.
    public let baseURLHiddenLogin: URL
    public let baseSSOURL: URL?
    public let ssoFinishedURL: URL?
    public let environmentDisplayName: String?
    public let isSwitchInstanceLoginEnabled: Bool
    public let uiComponents: UIComponentsConfig
    /// Remote URL, or a bundled asset name. `nil` keeps the default logo.
    public let logoURLString: String?
    /// Remote URL only. `nil` keeps the default header background.
    public let headerBackgroundURLString: String?
    /// `nil` derives the palette from `color` instead.
    public let themeColors: InstanceThemeColors?
    public let feedbackEmail: String?
    /// Locale code -> button label, e.g. `["en": "Sign in with SSO"]`. `nil` falls back to the app-wide default.
    public let ssoButtonTitle: [String: String]?
    public let appLevelDownloadsEnabled: Bool?
    public let agreement: AgreementConfig?

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

        if let hiddenLoginString = dictionary[InstanceKeys.baseURLHiddenLogin] as? String,
           let hiddenLoginURL = URL(string: hiddenLoginString) {
            self.baseURLHiddenLogin = hiddenLoginURL
        } else {
            self.baseURLHiddenLogin = baseURL
        }

        if let ssoString = dictionary[InstanceKeys.baseSSOURL] as? String {
            self.baseSSOURL = URL(string: ssoString)
        } else {
            self.baseSSOURL = nil
        }

        if let ssoFinishedString = dictionary[InstanceKeys.ssoFinishedURL] as? String {
            self.ssoFinishedURL = URL(string: ssoFinishedString)
        } else {
            self.ssoFinishedURL = nil
        }

        self.environmentDisplayName = dictionary[InstanceKeys.environmentDisplayName] as? String

        if let uiDict = dictionary[InstanceKeys.uiComponents] as? [String: Any] {
            self.uiComponents = UIComponentsConfig(dictionary: uiDict)
        } else {
            self.uiComponents = UIComponentsConfig(dictionary: [:])
        }

        self.logoURLString = dictionary[InstanceKeys.logoURL] as? String
        self.headerBackgroundURLString = dictionary[InstanceKeys.headerBackgroundURL] as? String

        if let themeDict = dictionary[InstanceKeys.theme] as? [String: Any] {
            self.themeColors = InstanceThemeColors(
                light: themeDict["light"] as? [String: String] ?? [:],
                dark: themeDict["dark"] as? [String: String] ?? [:]
            )
        } else {
            self.themeColors = nil
        }

        self.feedbackEmail = dictionary[InstanceKeys.feedbackEmail] as? String
        self.ssoButtonTitle = dictionary[InstanceKeys.ssoButtonTitle] as? [String: String]

        if let experimentalDict = dictionary[InstanceKeys.experimentalFeatures] as? [String: AnyObject] {
            let experimental = ExperimentalFeaturesConfig(dictionary: experimentalDict)
            self.appLevelDownloadsEnabled = experimental.appLevelDownloadsEnabled
        } else {
            self.appLevelDownloadsEnabled = nil
        }

        if let agreementDict = dictionary[InstanceKeys.agreementURLs] as? [String: AnyObject] {
            self.agreement = AgreementConfig(dictionary: agreementDict)
        } else {
            self.agreement = nil
        }
    }

    private static func slugify(_ name: String) -> String {
        name.lowercased()
            .folding(options: .diacriticInsensitive, locale: .current)
            .replacingOccurrences(of: "[^a-z0-9]+", with: "-", options: .regularExpression)
            .trimmingCharacters(in: CharacterSet(charactersIn: "-"))
    }

    // MARK: Codable
    // `uiComponents`, remote-media fields, and the feedback/SSO-button/experimental-
    // features/agreement overrides aren't persisted; re-populated from
    // `InstanceStore.instancesConfig` right after decode.
    private enum CodingKeys: String, CodingKey {
        case key, name, instanceName, color, oAuthClientId
        case baseURL, baseURLHiddenLogin, baseSSOURL, ssoFinishedURL
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
        baseURLHiddenLogin = try container.decode(URL.self, forKey: .baseURLHiddenLogin)
        baseSSOURL = try container.decodeIfPresent(URL.self, forKey: .baseSSOURL)
        ssoFinishedURL = try container.decodeIfPresent(URL.self, forKey: .ssoFinishedURL)
        environmentDisplayName = try container.decodeIfPresent(String.self, forKey: .environmentDisplayName)
        isSwitchInstanceLoginEnabled = try container.decode(Bool.self, forKey: .isSwitchInstanceLoginEnabled)
        uiComponents = UIComponentsConfig(dictionary: [:])
        logoURLString = nil
        headerBackgroundURLString = nil
        themeColors = nil
        feedbackEmail = nil
        ssoButtonTitle = nil
        appLevelDownloadsEnabled = nil
        agreement = nil
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(key, forKey: .key)
        try container.encode(name, forKey: .name)
        try container.encode(instanceName, forKey: .instanceName)
        try container.encode(color, forKey: .color)
        try container.encode(oAuthClientId, forKey: .oAuthClientId)
        try container.encode(baseURL, forKey: .baseURL)
        try container.encode(baseURLHiddenLogin, forKey: .baseURLHiddenLogin)
        try container.encodeIfPresent(baseSSOURL, forKey: .baseSSOURL)
        try container.encodeIfPresent(ssoFinishedURL, forKey: .ssoFinishedURL)
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
                print("⚠️ InstancesConfig: skipping malformed INSTANCES entry: \(dict["name"] ?? "<unknown>")")
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
            "name": name,
            "INSTANCE_NAME": ["en": instanceName],
            "color": color,
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

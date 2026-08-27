//
//  LMSModels.swift
//  Authorization
//
//  Created by Ivan Stepanok on 20.08.2026.
//

import Foundation

struct LMSSummary: Identifiable, Hashable, Sendable {
    let id: String
    let title: String
    let shortDescription: String
    let baseURL: URL
    let logoURL: URL?
    let accentColorHex: String?
}

struct LMSDetail: Identifiable, Hashable, Sendable {
    struct API: Hashable, Sendable {
        let hostURL: URL
        let feedbackEmail: String
        let oauthClientId: String
    }

    struct FeatureFlags: Hashable, Sendable, Codable {
        let preLoginDiscovery: Bool
        let unknownUnitsMode: String?

        /// What a platform gets when it says nothing: every flag off.
        /// A directory can be written by hand, and a hand-written entry should
        /// not have to spell out flags it does not use.
        static let none = FeatureFlags(preLoginDiscovery: false, unknownUnitsMode: nil)

        init(preLoginDiscovery: Bool, unknownUnitsMode: String?) {
            self.preLoginDiscovery = preLoginDiscovery
            self.unknownUnitsMode = unknownUnitsMode
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            preLoginDiscovery = try container.decodeIfPresent(Bool.self, forKey: .preLoginDiscovery) ?? false
            unknownUnitsMode = try container.decodeIfPresent(String.self, forKey: .unknownUnitsMode)
        }

        enum CodingKeys: String, CodingKey {
            case preLoginDiscovery = "pre_login_discovery"
            case unknownUnitsMode = "unknown_units_mode"
        }
    }

    struct Theme: Hashable, Sendable, Codable {
        let accentColorDark: String?
        let loginBackgroundURL: URL?

        enum CodingKeys: String, CodingKey {
            case accentColorDark = "accent_color_dark"
            case loginBackgroundURL = "login_background"
        }
    }

    struct UIComponents: Hashable, Sendable, Codable {
        let courseUnitProgressEnabled: Bool
        let courseDropdownNavigationEnabled: Bool
        let preLoginExperienceEnabled: Bool

        enum CodingKeys: String, CodingKey {
            case courseUnitProgressEnabled = "course_unit_progress_enabled"
            case courseDropdownNavigationEnabled = "course_dropdown_navigation_enabled"
            case preLoginExperienceEnabled = "pre_login_experience_enabled"
        }
    }

    struct Dashboard: Hashable, Sendable, Codable {
        let type: String

        enum CodingKeys: String, CodingKey {
            case type
        }
    }

    let id: String
    let title: String
    let description: String
    let api: API
    let featureFlags: FeatureFlags
    let theme: Theme?
    let uiComponents: UIComponents?
    let dashboard: Dashboard?
    let accentColorHex: String?
    let shortDescription: String
    let baseURL: URL
    let logoURL: URL?

    var accentColor: LMSColor? {
        guard let hex = accentColorHex else { return nil }
        return LMSColor(hex: hex)
    }

    var accentColorDark: LMSColor? {
        guard let hex = theme?.accentColorDark else { return nil }
        return LMSColor(hex: hex)
    }

    /// Returns the best logo URL: uploaded logo takes priority over external URL
    /// Whether unknown units should be shown in webview instead of blocked
    var showUnknownUnitsInWebview: Bool {
        featureFlags.unknownUnitsMode == "webview"
    }
}

struct LMSColor: Sendable, Hashable {
    let red: Double
    let green: Double
    let blue: Double

    init?(hex: String) {
        let trimmed = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        var value = trimmed
        if trimmed.hasPrefix("#") {
            value = String(trimmed.dropFirst())
        }
        guard value.count == 6, let intValue = Int(value, radix: 16) else {
            return nil
        }
        red = Double((intValue >> 16) & 0xFF) / 255.0
        green = Double((intValue >> 8) & 0xFF) / 255.0
        blue = Double(intValue & 0xFF) / 255.0
    }
}

// MARK: - Wire format

struct LMSDetailDTO: Codable {
    /// Every field here is optional on purpose.
    ///
    /// A multi-instance app carries one OAuth client id of its own, which each
    /// backend registers; the directory is not where per-platform credentials
    /// live. A file that says nothing about any of this is the normal case, and
    /// the app falls back to its own configuration.
    struct APIDTO: Codable {
        let hostURL: URL?
        let feedbackEmail: String?
        let oauthClientId: String?

        enum CodingKeys: String, CodingKey {
            case hostURL = "host_url"
            case feedbackEmail = "feedback_email"
            case oauthClientId = "oauth_client_id"
        }
    }

    let name: String
    let description: String?
    let api: APIDTO?
    let featureFlags: LMSDetail.FeatureFlags?
    let theme: LMSDetail.Theme?
    let uiComponents: LMSDetail.UIComponents?
    let dashboard: LMSDetail.Dashboard?
    let accentColor: String?
    let url: URL
    let logo: URL?

    enum CodingKeys: String, CodingKey {
        case name
        case description
        case api
        case featureFlags = "feature_flags"
        case theme
        case uiComponents = "ui_components"
        case dashboard
        case accentColor = "accent_color"
        case url
        case logo
    }

    /**
     The platform, identified by where it sits in the document.

     Position is the only thing guaranteed unique. Two entries may legitimately
     share an address — the same LMS listed twice under different branding — and
     identifying them by URL silently merges them: the list draws one of the two
     and tapping it opens the other one's settings.
     */
    func domainModel(id: String) -> LMSDetail {
        LMSDetail(
            id: id,
            title: name,
            description: description ?? "",
            api: .init(
                // A platform that names no separate API host is served from the
                // same address the learner picked.
                hostURL: api?.hostURL ?? url,
                feedbackEmail: api?.feedbackEmail ?? "",
                // Empty means "the app's own", which is what Config falls back to.
                oauthClientId: api?.oauthClientId ?? ""
            ),
            featureFlags: featureFlags ?? .none,
            theme: theme,
            uiComponents: uiComponents,
            dashboard: dashboard,
            accentColorHex: accentColor,
            shortDescription: description ?? "",
            baseURL: url,
            logoURL: logo
        )
    }
}

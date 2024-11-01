//
//  Config.swift
//  Core
//
//  Created by Muhammad Umer on 11/11/2023.
//

import Foundation

//sourcery: AutoMockable
public protocol ConfigProtocol {
    var baseURL: URL { get }
    var baseSSOURL: URL { get }
    var ssoFinishedURL: URL { get }
    var ssoButtonTitle: [String: Any] { get }
    var oAuthClientId: String { get }
    var tokenType: TokenType { get }
    var feedbackEmail: String { get }
    var appStoreLink: String { get }
    var faq: URL? { get }
    var platformName: String { get }
    var agreement: AgreementConfig { get }
    var firebase: FirebaseConfig { get }
    var facebook: FacebookConfig { get }
    var microsoft: MicrosoftConfig { get }
    var google: GoogleConfig { get }
    var appleSignIn: AppleSignInConfig { get }
    var features: FeaturesConfig { get }
    var theme: ThemeConfig { get }
    var uiComponents: UIComponentsConfig { get }
    var discovery: DiscoveryConfig { get }
    var dashboard: DashboardConfig { get }
    var braze: BrazeConfig { get }
    var branch: BranchConfig { get }
    var segment: SegmentConfig { get }
    var program: DiscoveryConfig { get }
    var URIScheme: String { get }
    var fullStory: FullStoryConfig { get }
}

public enum TokenType: String {
    case jwt = "JWT"
    case bearer = "BEARER"
}

private enum ConfigKeys: String {
    case baseURL = "API_HOST_URL"
    case ssoBaseURL = "SSO_URL"
    case ssoFinishedURL = "SSO_FINISHED_URL"
    case ssoButtonTitle = "SSO_BUTTON_TITLE"
    case oAuthClientID = "OAUTH_CLIENT_ID"
    case tokenType = "TOKEN_TYPE"
    case feedbackEmailAddress = "FEEDBACK_EMAIL_ADDRESS"
    case environmentDisplayName = "ENVIRONMENT_DISPLAY_NAME"
    case platformName = "PLATFORM_NAME"
    case organizationCode = "ORGANIZATION_CODE"
    case appstoreID = "APP_STORE_ID"
    case faq = "FAQ_URL"
    case URIScheme = "URI_SCHEME"
}

public class Config {
    let configFileName = "config"
    
    internal var properties: [String: Any] = [:]
    
    internal init(properties: [String: Any]) {
        self.properties = properties
    }
    
    public convenience init() {
        self.init(properties: [:])
        loadAndParseConfig()
    }
    
    private func loadAndParseConfig() {
        guard let path = Bundle.main.path(forResource: configFileName, ofType: "plist"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
              let dict = try? PropertyListSerialization.propertyList(
                from: data,
                options: [],
                format: nil) as? [String: Any]
        else { return }
        
        properties = dict
    }
    
    internal subscript(key: String) -> Any? {
        return properties[key]
    }
    
    func dict(for key: String) -> [String: Any]? {
        return properties[key] as? [String: Any]
    }
    
    func value<T>(for key: String) -> T? {
        return properties[key] as? T
    }
    
    func value(for key: String) -> Any? {
        return properties[key]
    }
    
    func value(for key: String, dict: [String: Any]) -> String? {
        return dict[key] as? String ?? nil
    }
    
    func string(for key: String) -> String? {
        return value(for: key) as? String ?? nil
    }
    
    func string(for key: String, dict: [String: Any]) -> String? {
        return value(for: key, dict: dict)
    }
    
    func bool(for key: String) -> Bool {
        return value(for: key) as? Bool ?? false
    }
}

extension Config: ConfigProtocol {
    public var baseURL: URL {
        guard let urlString = string(for: ConfigKeys.baseURL.rawValue),
              let url = URL(string: urlString) else {
            fatalError("Unable to find base url in config.")
        }
        return url
    }
    
    public var baseSSOURL: URL {
        guard let urlString = string(for: ConfigKeys.ssoBaseURL.rawValue),
              let url = URL(string: urlString) else {
            fatalError("Unable to find SSO base url in config.")
        }
        return url
    }
    
    public var ssoFinishedURL: URL {
        guard let urlString = string(for: ConfigKeys.ssoFinishedURL.rawValue),
              let url = URL(string: urlString) else {
            fatalError("Unable to find SSO successful login url in config.")
        }
        return url
    }
    
    public var ssoButtonTitle: [String: Any] {
        guard let ssoButtonTitle = dict(for: ConfigKeys.ssoButtonTitle.rawValue) else {
            return ["en": CoreLocalization.SignIn.logInWithSsoBtn]
        }
        return ssoButtonTitle
    }
    
    public var oAuthClientId: String {
        guard let clientID = string(for: ConfigKeys.oAuthClientID.rawValue) else {
            fatalError("Unable to find OAuth ClientID in config.")
        }
        return clientID
    }
    
    public var tokenType: TokenType {
        guard let tokenTypeValue = string(for: ConfigKeys.tokenType.rawValue),
              let tokenType = TokenType(rawValue: tokenTypeValue)
        else { return .jwt }
        return tokenType
    }
    
    public var feedbackEmail: String {
        return string(for: ConfigKeys.feedbackEmailAddress.rawValue) ?? ""
    }

    public var platformName: String {
        return string(for: ConfigKeys.platformName.rawValue) ?? ""
    }

    private var appStoreId: String {
        return string(for: ConfigKeys.appstoreID.rawValue) ?? "0000000000"
    }
    
    public var appStoreLink: String {
        "itms-apps://itunes.apple.com/app/id\(appStoreId)?mt=8"
    }

    public var faq: URL? {
        guard let urlString = string(for: ConfigKeys.faq.rawValue),
              let url = URL(string: urlString) else {
            return nil
        }
        return url
    }
    
    public var URIScheme: String {
        return string(for: ConfigKeys.URIScheme.rawValue) ?? ""
    }
}

// Mark - For testing and SwiftUI preview
#if DEBUG
public class ConfigMock: Config {
    private let config: [String: Any] = [
        "API_HOST_URL": "https://www.example.com",
        "SSO_URL" : "https://www.example.com",
        "OAUTH_CLIENT_ID": "oauth_client_id",
        "FEEDBACK_EMAIL_ADDRESS": "example@mail.com",
        "PLATFORM_NAME": "OpenEdx",
        "TOKEN_TYPE": "JWT",
        "WHATS_NEW_ENABLED": false,
        "AGREEMENT_URLS": [
            "PRIVACY_POLICY_URL": "https://www.example.com/privacy",
            "TOS_URL": "https://www.example.com/tos",
            "DATA_SELL_CONSENT_URL": "https://www.example.com/sell",
            "COOKIE_POLICY_URL": "https://www.example.com/cookie",
            "SUPPORTED_LANGUAGES": ["es"]
        ],
        "GOOGLE": [
            "ENABLED": true,
            "CLIENT_ID": "clientId"
        ],
        "FACEBOOK": [
            "ENABLED": true,
            "FACEBOOK_APP_ID": "facebookAppId",
            "CLIENT_TOKEN": "client_token"
        ],
        "MICROSOFT": [
            "ENABLED": true,
            "APP_ID": "appId"
        ],
        "APPLE_SIGNIN": [
            "ENABLED": true
        ]
    ]
    
    public init() {
        super.init(properties: config)
    }
}
#endif

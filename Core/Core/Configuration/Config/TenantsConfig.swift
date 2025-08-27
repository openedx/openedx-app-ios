//
//  TenantConfig.swift
//  Core
//
//  Created by Rawan Matar on 15/04/2025.
//

import Foundation

public protocol TenantProvider {
    var name: String { get }
    var tenantName: String { get }
    var color: String { get }
    var oAuthClientId: String { get }
    var baseURL: URL { get }
    var baseURLHiddenLogin: URL { get }
    var baseSSOURL: URL { get }
    var successfulSSOLoginURL: URL { get }
    var environmentDisplayName: String { get }
    var uiComponents: UIComponentsConfig { get }
}

private enum TenantKeys: String, RawStringExtractable {
    case name
    case tenantName = "TENANT_NAME"
    case color
    case oAuthClientId = "OAUTH_CLIENT_ID"
    case baseURL = "API_HOST_URL"
    case baseURLHiddenLogin = "API_HOST_URL_HIDDEN_LOGIN"
    case baseSSOURL = "SSO_URL"
    case SuccessfulSSOLoginURL = "SSO_URL_SUCCESSFUL_LOGIN"
    case environmentDisplayName = "ENVIRONMENT_DISPLAY_NAME"
    case isSwitchTenantLoginEnabled = "IS_SWITCH_TENANT_LOGIN_ENABLED"
    case uiComponents = "UI_COMPONENTS"
}

public class Tenant: Codable, Identifiable {
    public var id = UUID()
    public let name: String
    public var tenantName: String
    public let color: String
    public var oAuthClientId: String
    public var baseURL: URL?
    public var baseURLHiddenLogin: URL?
    public var baseSSOURL: URL?
    public var successfulSSOLoginURL: URL?
    public var environmentDisplayName: String?
    public var isSwitchTenantLoginEnabled: Bool
    public var uiComponents: UIComponentsConfig?

    init(dictionary: [String: Any]) {
        self.name = dictionary[TenantKeys.name] as? String ?? ""
        var languageCode: String = "en"
        if let langCode = Locale.preferredLanguages.first?.prefix(2) {
            languageCode = String(langCode)
        }
        if let tenantNameDict = dictionary[TenantKeys.tenantName] as? [String: Any]{
            self.tenantName = tenantNameDict[languageCode] as? String ?? ""
        } else {
            self.tenantName = "unknown"
        }
        self.isSwitchTenantLoginEnabled = dictionary[TenantKeys.isSwitchTenantLoginEnabled] as? Bool ?? false
        self.color = dictionary[TenantKeys.color] as? String ?? ""
        self.oAuthClientId = dictionary[TenantKeys.oAuthClientId] as? String ?? ""
        
        if let urlString = dictionary[TenantKeys.baseURL] as? String
            , let url = URL(string: urlString) {
            self.baseURL = url
        }
        
        if let urlString = dictionary[TenantKeys.baseURLHiddenLogin] as? String
        , let url = URL(string: urlString) {
            self.baseURLHiddenLogin = url
        }
        if let urlString = dictionary[TenantKeys.baseSSOURL] as? String
            , let url = URL(string: urlString) {
                self.baseSSOURL = url
            }
        if let urlString = dictionary[TenantKeys.SuccessfulSSOLoginURL] as? String
        , let url = URL(string: urlString) {
            self.successfulSSOLoginURL = url
        }
        self.environmentDisplayName = dictionary[TenantKeys.environmentDisplayName] as? String
        if let uiDict = dictionary[TenantKeys.uiComponents] as? [String: Any] {
            self.uiComponents = UIComponentsConfig(dictionary: uiDict)
        } else {
            self.uiComponents = nil
        }
    }
}

public class TenantsConfig {
    public let tenants: [Tenant]

    public convenience init() {
        self.init(array: [[:]])
    }
    
    init(array: [[String: Any]]) {
        self.tenants = array.map { Tenant(dictionary: $0) }
    }
}
#if DEBUG
public class TenantProviderMock: TenantProvider {
    public var name: String
    
    public var tenantName: String
    
    public var color: String
    
    public var oAuthClientId: String
    
    public var baseURL: URL
    
    public var baseURLHiddenLogin: URL
    
    public var baseSSOURL: URL
    
    public var successfulSSOLoginURL: URL
    
    public var environmentDisplayName: String
    
    public var uiComponents: UIComponentsConfig

    public init( oAuthClientId: String = "mockClientId",
        baseURL: URL = URL(string: "https://mock.base.url")!,
                name: String = "Test",
                 tenantName: String = "Test",
                color: String = "#fff",
                baseSSOURL: URL = URL(string: "https://mock.base.url")!,
                successfulSSOLoginURL: URL = URL(string: "https://mock.base.url")!,
                environmentDisplayName: String = "Test",
                uiComponents: UIComponentsConfig) {
        self.oAuthClientId = oAuthClientId
        self.baseURL = baseURL
        self.name = name
        self.tenantName = tenantName
        self.color = color
        self.baseSSOURL = baseSSOURL
        self.successfulSSOLoginURL = successfulSSOLoginURL
        self.environmentDisplayName = environmentDisplayName
        self.uiComponents = UIComponentsConfig(dictionary: [:])
        self.baseURLHiddenLogin = baseURL
        
    }
}
#endif

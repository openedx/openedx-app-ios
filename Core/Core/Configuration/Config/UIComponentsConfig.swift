//
//  UIComponentsConfig.swift
//  Core
//
//  Created by Vadim Kuznetsov on 5.12.23.
//

import Foundation

private enum Keys: String, RawStringExtractable {
    case courseDropDownNavigationEnabled = "COURSE_DROPDOWN_NAVIGATION_ENABLED"
    case courseUnitProgressEnabled = "COURSE_UNIT_PROGRESS_ENABLED"
    case loginRegistrationEnabled = "LOGIN_REGISTRATION_ENABLED"
    case SAMLSSOLoginEnabled = "SAML_SSO_LOGIN_ENABLED"
    case SAMLSSODefaultLoginButton = "SAML_SSO_DEFAULT_LOGIN_BUTTON"
}

public class UIComponentsConfig: NSObject {
    public var courseDropDownNavigationEnabled: Bool
    public var courseUnitProgressEnabled: Bool
    public var loginRegistrationEnabled: Bool
    public var SAMLSSOLoginEnabled: Bool
    public var SAMLSSODefaultLoginButton: Bool

    init(dictionary: [String: Any]) {
        courseDropDownNavigationEnabled = dictionary[Keys.courseDropDownNavigationEnabled] as? Bool ?? false
        courseUnitProgressEnabled = dictionary[Keys.courseUnitProgressEnabled] as? Bool ?? false
        loginRegistrationEnabled = dictionary[Keys.loginRegistrationEnabled] as? Bool ?? true
        SAMLSSOLoginEnabled = dictionary[Keys.SAMLSSOLoginEnabled] as? Bool ?? false
        SAMLSSODefaultLoginButton = dictionary[Keys.SAMLSSODefaultLoginButton] as? Bool ?? false
        super.init()
    }
}

private let key = "UI_COMPONENTS"
extension Config {
    public var uiComponents: UIComponentsConfig {
        return UIComponentsConfig(dictionary: properties[key] as? [String: AnyObject] ?? [:])
    }
}

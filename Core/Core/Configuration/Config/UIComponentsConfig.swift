//
//  UIComponentsConfig.swift
//  Core
//
//  Created by Vadim Kuznetsov on 5.12.23.
//

import Foundation
import OEXFoundation

private enum Keys: String, RawStringExtractable {
    case courseDropDownNavigationEnabled = "COURSE_DROPDOWN_NAVIGATION_ENABLED"
    case courseUnitProgressEnabled = "COURSE_UNIT_PROGRESS_ENABLED"
    case loginRegistrationEnabled = "LOGIN_REGISTRATION_ENABLED"
    case samlSSOLoginEnabled = "SAML_SSO_LOGIN_ENABLED"
    case samlSSODefaultLoginButton = "SAML_SSO_DEFAULT_LOGIN_BUTTON"
}

public class UIComponentsConfig: NSObject {
    public var courseDropDownNavigationEnabled: Bool
    public var courseUnitProgressEnabled: Bool
    public var loginRegistrationEnabled: Bool
    public var samlSSOLoginEnabled: Bool
    public var samlSSODefaultLoginButton: Bool

    init(dictionary: [String: Any]) {
        courseDropDownNavigationEnabled = dictionary[Keys.courseDropDownNavigationEnabled] as? Bool ?? false
        courseUnitProgressEnabled = dictionary[Keys.courseUnitProgressEnabled] as? Bool ?? false
        loginRegistrationEnabled = dictionary[Keys.loginRegistrationEnabled] as? Bool ?? true
        samlSSOLoginEnabled = dictionary[Keys.samlSSOLoginEnabled] as? Bool ?? false
        samlSSODefaultLoginButton = dictionary[Keys.samlSSODefaultLoginButton] as? Bool ?? false
        super.init()
    }
}

private let key = "UI_COMPONENTS"
extension Config {
    public var uiComponents: UIComponentsConfig {
        return UIComponentsConfig(dictionary: properties[key] as? [String: AnyObject] ?? [:])
    }
}

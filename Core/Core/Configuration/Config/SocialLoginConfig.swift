//
//  SocialLoginConfig.swift
//  Core
//
//  Created by Eugene Yatsenko on 27.11.2023.
//

import Foundation

private enum SocialLoginKeys: String {
    case enable = "ENABLED"
    case appleSigninEnabled = "APPLE_SIGNIN_ENABLED"

}

public class SocialLoginConfig: NSObject {
    public var enable: Bool
    public var appleSigninEnabled: Bool

    init(dictionary: [String: Any]) {
        enable = dictionary[SocialLoginKeys.enable.rawValue] as? Bool ?? false
        appleSigninEnabled = dictionary[SocialLoginKeys.appleSigninEnabled.rawValue] as? Bool ?? false
        super.init()
    }
}

private let socialLoginKey = "SOCIAL_LOGINS"
extension Config {
    public var socialLogin: SocialLoginConfig {
        SocialLoginConfig(dictionary: self[socialLoginKey] as? [String: AnyObject] ?? [:])
    }
}

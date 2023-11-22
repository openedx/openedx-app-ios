//
//  FeaturesConfig.swift
//  Core
//
//  Created by Muhammad Umer on 11/14/23.
//

import Foundation

private enum FeaturesKeys: String {
    case whatNewEnabled = "WHATS_NEW_ENABLED"
    case socialLoginEnabled = "SOCIAL_LOGIN_ENABLED"
    case isAppleSigninEnabled = "APPLE_SIGNIN_ENABLED"
}

public class FeaturesConfig: NSObject {
    public var whatNewEnabled: Bool
    public var socialLoginEnabled: Bool
    public var isAppleSigninEnabled: Bool

    init(dictionary: [String: Any]) {
        whatNewEnabled = dictionary[FeaturesKeys.whatNewEnabled.rawValue] as? Bool ?? false
        socialLoginEnabled = dictionary[FeaturesKeys.socialLoginEnabled.rawValue] as? Bool ?? false
        isAppleSigninEnabled = dictionary[FeaturesKeys.isAppleSigninEnabled.rawValue] as? Bool ?? false
        super.init()
    }
}

extension Config {
    public var features: FeaturesConfig {
        return FeaturesConfig(dictionary: properties)
    }
}

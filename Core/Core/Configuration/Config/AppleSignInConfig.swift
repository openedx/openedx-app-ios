//
//  SocialLoginConfig.swift
//  Core
//
//  Created by Eugene Yatsenko on 27.11.2023.
//

import Foundation

private enum AppleSignInKeys: String {
    case enabled = "ENABLED"
}

public class AppleSignInConfig: NSObject {
    public var enabled: Bool

    init(dictionary: [String: Any]) {
        enabled = dictionary[AppleSignInKeys.enabled.rawValue] as? Bool ?? false
        super.init()
    }
}

private let key = "APPLE_SIGNIN"
extension Config {
    public var appleSignIn: AppleSignInConfig {
        AppleSignInConfig(dictionary: self[key] as? [String: AnyObject] ?? [:])
    }
}

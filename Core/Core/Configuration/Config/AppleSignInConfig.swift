//
//  SocialLoginConfig.swift
//  Core
//
//  Created by Eugene Yatsenko on 27.11.2023.
//

import Foundation

private enum AppleSignInKeys: String {
    case enable = "ENABLED"
}

public class AppleSignInConfig: NSObject {
    public var enable: Bool

    init(dictionary: [String: Any]) {
        enable = dictionary[AppleSignInKeys.enable.rawValue] as? Bool ?? false
        super.init()
    }
}

private let appleSignInKey = "APPLE_SIGNIN"
extension Config {
    public var appleSignIn: AppleSignInConfig {
        AppleSignInConfig(dictionary: self[appleSignInKey] as? [String: AnyObject] ?? [:])
    }
}

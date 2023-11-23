//
//  FacebookConfig.swift
//  Core
//
//  Created by Eugene Yatsenko on 22.11.2023.
//

import Foundation

private enum FacebookKeys: String {
    case enabled = "ENABLED"
    case appID = "FACEBOOK_APP_ID"
    case clientToken = "CLIENT_TOKEN"
    case facebooSignInEnable = "FACEBOOK_SIGNIN_ENABLED"
}

public final class FacebookConfig: NSObject {
    public var enabled: Bool = false
    public var appID: String?
    public var clientToken: String?
    public var facebooSignInEnable: Bool = false

    public var requiredKeysAvailable: Bool {
        return appID != nil && clientToken != nil
    }

    init(dictionary: [String: AnyObject]) {
        appID = dictionary[FacebookKeys.appID.rawValue] as? String
        clientToken = dictionary[FacebookKeys.clientToken.rawValue] as? String
        super.init()
        enabled = requiredKeysAvailable && dictionary[FacebookKeys.enabled.rawValue] as? Bool == true
        facebooSignInEnable = enabled && dictionary[FacebookKeys.facebooSignInEnable.rawValue] as? Bool == true
    }
}

private let facebookKey = "FACEBOOK"
extension Config {
    public var facebook: FacebookConfig {
        FacebookConfig(dictionary: self[facebookKey] as? [String: AnyObject] ?? [:])
    }
}

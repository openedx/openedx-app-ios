//
//  GoogleConfig.swift
//  Core
//
//  Created by Eugene Yatsenko on 27.11.2023.
//

import Foundation

private enum GoogleKeys: String {
    case enabled = "ENABLED"
    case googlePlusKey = "GOOGLE_PLUS_KEY"
    case clientID = "CLIENT_ID"
}

public final class GoogleConfig: NSObject {
    public var enabled: Bool = false
    public var googlePlusKey: String?
    public var clientID: String?


    public var requiredKeysAvailable: Bool {
        return clientID != nil
    }

    init(dictionary: [String: AnyObject]) {
        clientID = dictionary[GoogleKeys.clientID.rawValue] as? String
        super.init()
        enabled = requiredKeysAvailable && dictionary[GoogleKeys.enabled.rawValue] as? Bool == true
    }
}

private let googleKey = "GOOGLE"
extension Config {
    public var google: GoogleConfig {
        GoogleConfig(dictionary: self[googleKey] as? [String: AnyObject] ?? [:])
    }
}

//
//  BrazeConfig.swift
//  Core
//
//  Created by Anton Yarmolenka on 24/01/2024.
//

import Foundation

private enum BrazeKeys: String {
    case enabled = "ENABLED"
    case pushNotificationsEnabled = "PUSH_NOTIFICATIONS_ENABLED"
}

public final class BrazeConfig: NSObject {
    public var enabled: Bool = false
    public var pushNotificationsEnabled: Bool = false
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        enabled = dictionary[BrazeKeys.enabled.rawValue] as? Bool == true
        let pushNotificationsEnabled = dictionary[BrazeKeys.pushNotificationsEnabled.rawValue] as? Bool ?? false
        self.pushNotificationsEnabled = enabled && pushNotificationsEnabled
    }
}

private let brazeKey = "BRAZE"
extension Config {
    public var braze: BrazeConfig {
        BrazeConfig(dictionary: self[brazeKey] as? [String: AnyObject] ?? [:])
    }
}

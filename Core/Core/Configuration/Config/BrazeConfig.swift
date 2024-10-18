//
//  BrazeConfig.swift
//  Core
//
//  Created by Anton Yarmolenka on 24/01/2024.
//

import Foundation
import OEXFoundation

private enum BrazeKeys: String, RawStringExtractable {
    case enabled = "ENABLED"
    case pushNotificationsEnabled = "PUSH_NOTIFICATIONS_ENABLED"
}

public final class BrazeConfig: NSObject {
    public var enabled: Bool = false
    public var pushNotificationsEnabled: Bool = false
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        enabled = dictionary[BrazeKeys.enabled] as? Bool == true
        let pushNotificationsEnabled = dictionary[BrazeKeys.pushNotificationsEnabled] as? Bool ?? false
        self.pushNotificationsEnabled = enabled && pushNotificationsEnabled
    }
}

private let brazeKey = "BRAZE"
extension Config {
    public var braze: BrazeConfig {
        BrazeConfig(dictionary: self[brazeKey] as? [String: AnyObject] ?? [:])
    }
}

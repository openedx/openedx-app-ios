//
//  FeaturesConfig.swift
//  Core
//
//  Created by Muhammad Umer on 11/14/23.
//

import Foundation

private enum FeaturesKeys: String {
    case whatNewEnabled = "WHATS_NEW_ENABLED"
    case startupScreenEnabled = "PRE_LOGIN_EXPERIENCE_ENABLED"
    case datesEnabled = "APP_LEVEL_DATES_ENABLED"
}

public class FeaturesConfig: NSObject {
    public var whatNewEnabled: Bool
    public var startupScreenEnabled: Bool
    public var datesEnabled: Bool

    init(dictionary: [String: Any]) {
        whatNewEnabled = dictionary[FeaturesKeys.whatNewEnabled.rawValue] as? Bool ?? false
        startupScreenEnabled = dictionary[FeaturesKeys.startupScreenEnabled.rawValue] as? Bool ?? false
        datesEnabled = dictionary[FeaturesKeys.datesEnabled.rawValue] as? Bool ?? true
        super.init()
    }
}

extension Config {
    public var features: FeaturesConfig {
        return FeaturesConfig(dictionary: properties)
    }
}

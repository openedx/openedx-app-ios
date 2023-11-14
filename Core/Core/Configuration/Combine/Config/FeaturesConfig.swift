//
//  FeaturesConfig.swift
//  Core
//
//  Created by Muhammad Umer on 11/14/23.
//

import Foundation

private enum FeaturesKeys: String {
    case whatNewEnabled = "WHATS_NEW_ENABLED"
}

public class FeaturesConfig: NSObject {
    public var whatNewEnabled: Bool
    
    init(dictionary: [String: AnyObject]) {
        whatNewEnabled = dictionary[FeaturesKeys.whatNewEnabled.rawValue] as? Bool ?? false
        super.init()
    }
}

private let key = "FEATURES"
extension Config {
    public var features: FeaturesConfig {
        return FeaturesConfig(dictionary: self[key] as? [String: AnyObject] ?? [:])
    }
}

//
//  ExperimentalFeaturesConfig.swift
//  Core
//
//  Created by Ivan Stepanok on 7-03-2025.
//

import Foundation

private enum ExperimentalFeaturesKeys: String {
    case appLevelDownloads = "APP_LEVEL_DOWNLOADS"
}

private enum FeatureKeys: String {
    case enabled = "ENABLED"
}

public final class ExperimentalFeaturesConfig: NSObject {
    public var appLevelDownloadsEnabled: Bool = false

    init(dictionary: [String: AnyObject]) {
        super.init()
        if let downloadsDict = dictionary[ExperimentalFeaturesKeys.appLevelDownloads.rawValue] as? [String: AnyObject],
           let isEnabled = downloadsDict[FeatureKeys.enabled.rawValue] as? Bool {
            appLevelDownloadsEnabled = isEnabled
        }
    }
}

private let key = "EXPERIMENTAL_FEATURES"
extension Config {
    public var experimentalFeatures: ExperimentalFeaturesConfig {
        ExperimentalFeaturesConfig(dictionary: self[key] as? [String: AnyObject] ?? [:])
    }
}

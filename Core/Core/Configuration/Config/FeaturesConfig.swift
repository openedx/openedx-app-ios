//
//  FeaturesConfig.swift
//  Core
//
//  Created by Muhammad Umer on 11/14/23.
//

import Foundation

private enum FeaturesKeys: String {
    case whatNewEnabled = "WHATS_NEW_ENABLED"
    case courseExpandableSectionsEnabled = "COURSE_EXPANDABLE_SECTIONS_ENABLED"
    case courseBannerEnabled = "COURSE_BANNER_ENABLED"
}

public class FeaturesConfig: NSObject {
    public var whatNewEnabled: Bool
    public var courseExpandableSectionsEnabled: Bool
    public var courseBannerEnabled: Bool

    init(dictionary: [String: Any]) {
        whatNewEnabled = dictionary[FeaturesKeys.whatNewEnabled.rawValue] as? Bool ?? false
        courseExpandableSectionsEnabled = dictionary[FeaturesKeys.courseExpandableSectionsEnabled.rawValue] as? Bool ?? false
        courseBannerEnabled = dictionary[FeaturesKeys.courseBannerEnabled.rawValue] as? Bool ?? false
        super.init()
    }
}

extension Config {
    public var features: FeaturesConfig {
        return FeaturesConfig(dictionary: properties)
    }
}

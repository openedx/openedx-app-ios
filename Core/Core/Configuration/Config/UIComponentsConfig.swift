//
//  UIComponentsConfig.swift
//  Core
//
//  Created by Vadim Kuznetsov on 5.12.23.
//

import Foundation

private enum Keys: String, RawStringExtractable {
    case courseNestedListEnabled = "COURSE_NESTED_LIST_ENABLED"
    case courseTopTabBarEnabled = "COURSE_TOP_TAB_BAR_ENABLED"
    case courseBannerEnabled = "COURSE_BANNER_ENABLED"
    case whatsNewImageOrTitlePageSkip = "WHATS_NEW_IMAGE_OR_TITLE_TO_SKIP_PAGE"
}

public class UIComponentsConfig: NSObject {
    public var courseNestedListEnabled: Bool = false
    public var courseBannerEnabled: Bool
    public var courseTopTabBarEnabled: Bool
    public let whatsNewImageOrTitlePageSkip: String?

    init(dictionary: [String: Any]) {
        courseNestedListEnabled = dictionary[Keys.courseNestedListEnabled.rawValue] as? Bool ?? false
        courseBannerEnabled = dictionary[Keys.courseBannerEnabled.rawValue] as? Bool ?? false
        courseTopTabBarEnabled = dictionary[Keys.courseTopTabBarEnabled.rawValue] as? Bool ?? false
        whatsNewImageOrTitlePageSkip = dictionary[Keys.whatsNewImageOrTitlePageSkip] as? String
        super.init()
    }
}

private let key = "UI_COMPONENTS"
extension Config {
    public var uiComponents: UIComponentsConfig {
        return UIComponentsConfig(dictionary: properties[key] as? [String: AnyObject] ?? [:])
    }
}

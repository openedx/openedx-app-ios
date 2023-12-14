//
//  UIComponentsConfig.swift
//  Core
//
//  Created by Vadim Kuznetsov on 5.12.23.
//

import Foundation

private enum Keys: String {
    case courseNestedListEnabled = "COURSE_NESTED_LIST_ENABLED"
    case courseTopTabBarEnabled = "COURSE_TOP_TAB_BAR_ENABLED"
    case courseBannerEnabled = "COURSE_BANNER_ENABLED"
}

public class UIComponentsConfig: NSObject {
    public var courseNestedListEnabled: Bool = false
    public var courseBannerEnabled: Bool
    public var courseTopTabBarEnabled: Bool

    init(dictionary: [String: Any]) {
        courseNestedListEnabled = dictionary[Keys.courseNestedListEnabled.rawValue] as? Bool ?? false
        courseBannerEnabled = dictionary[Keys.courseBannerEnabled.rawValue] as? Bool ?? false
        courseTopTabBarEnabled = dictionary[Keys.courseTopTabBarEnabled.rawValue] as? Bool ?? false
        super.init()
    }
}

private let key = "UI_COMPONENTS"
extension Config {
    public var uiComponents: UIComponentsConfig {
        return UIComponentsConfig(dictionary: properties[key] as? [String: AnyObject] ?? [:])
    }
}

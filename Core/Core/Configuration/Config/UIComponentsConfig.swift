//
//  UIComponentsConfig.swift
//  Core
//
//  Created by Vadim Kuznetsov on 5.12.23.
//

import Foundation

private enum Keys: String {
    case isVerticalsMenuEnabled = "VERTICALS_MENU_ENABLED"
    case courseExpandableSectionsEnabled = "COURSE_EXPANDABLE_SECTIONS_ENABLED"
    case courseBannerEnabled = "COURSE_BANNER_ENABLED"
}

public class UIComponentsConfig: NSObject {
    public var isVerticalsMenuEnabled: Bool = false
    public var courseExpandableSectionsEnabled: Bool
    public var courseBannerEnabled: Bool

    init(dictionary: [String: Any]) {
        isVerticalsMenuEnabled = dictionary[Keys.isVerticalsMenuEnabled.rawValue] as? Bool ?? false
        courseExpandableSectionsEnabled = dictionary[Keys.courseExpandableSectionsEnabled.rawValue] as? Bool ?? false
        courseBannerEnabled = dictionary[Keys.courseBannerEnabled.rawValue] as? Bool ?? false
        super.init()
    }
}

private let key = "UI_COMPONENTS"
extension Config {
    public var uiComponents: UIComponentsConfig {
        return UIComponentsConfig(dictionary: properties[key] as? [String: AnyObject] ?? [:])
    }
}

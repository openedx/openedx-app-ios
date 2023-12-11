//
//  UIComponentsConfig.swift
//  Core
//
//  Created by Vadim Kuznetsov on 5.12.23.
//

import Foundation

private enum Keys: String {
    case isVerticalsMenuEnabled = "VERTICALS_MENU_ENABLED"
    case courseTopTabBarEnabled = "COURSE_TOP_TAB_BAR_ENABLED"
}

public class UIComponentsConfig: NSObject {
    public var isVerticalsMenuEnabled: Bool
    public var courseTopTabBarEnabled: Bool

    init(dictionary: [String: Any]) {
        isVerticalsMenuEnabled = dictionary[Keys.isVerticalsMenuEnabled.rawValue] as? Bool ?? false
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

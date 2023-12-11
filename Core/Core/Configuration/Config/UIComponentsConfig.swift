//
//  UIComponentsConfig.swift
//  Core
//
//  Created by Vadim Kuznetsov on 5.12.23.
//

import Foundation

private enum Keys: String {
    case isVerticalsMenuEnabled = "VERTICALS_MENU_ENABLED"
    case courseUnitProgressEnabled = "COURSE_UNIT_PROGRESS_ENABLED"
}

public class UIComponentsConfig: NSObject {
    public var isVerticalsMenuEnabled: Bool = false
    public var courseUnitProgressEnabled: Bool = false

    init(dictionary: [String: Any]) {
        isVerticalsMenuEnabled = dictionary[Keys.isVerticalsMenuEnabled.rawValue] as? Bool ?? false
        courseUnitProgressEnabled = dictionary[Keys.courseUnitProgressEnabled.rawValue] as? Bool ?? false
        super.init()
    }
}

private let key = "UI_COMPONENTS"
extension Config {
    public var uiComponents: UIComponentsConfig {
        return UIComponentsConfig(dictionary: properties[key] as? [String: AnyObject] ?? [:])
    }
}

//
//  UIComponentsConfig.swift
//  Core
//
//  Created by Vadim Kuznetsov on 5.12.23.
//

import Foundation

private enum Keys: String {
    case courseNestedListEnable = "COURSE_NESTED_LIST_ENABLE"
    case courseBannerEnabled = "COURSE_BANNER_ENABLED"
}

public class UIComponentsConfig: NSObject {
    public var courseNestedListEnable: Bool = false
    public var courseBannerEnabled: Bool

    init(dictionary: [String: Any]) {
        courseNestedListEnable = dictionary[Keys.courseNestedListEnable.rawValue] as? Bool ?? false
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

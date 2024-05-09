//
//  UIComponentsConfig.swift
//  Core
//
//  Created by Vadim Kuznetsov on 5.12.23.
//

import Foundation

private enum Keys: String, RawStringExtractable {
    case courseNestedListEnabled = "COURSE_NESTED_LIST_ENABLED"
    case courseUnitProgressEnabled = "COURSE_UNIT_PROGRESS_ENABLED"
}

public class UIComponentsConfig: NSObject {
    public var courseNestedListEnabled: Bool
    public var courseUnitProgressEnabled: Bool

    init(dictionary: [String: Any]) {
        courseNestedListEnabled = dictionary[Keys.courseNestedListEnabled] as? Bool ?? false
        courseUnitProgressEnabled = dictionary[Keys.courseUnitProgressEnabled] as? Bool ?? false
        super.init()
    }
}

private let key = "UI_COMPONENTS"
extension Config {
    public var uiComponents: UIComponentsConfig {
        return UIComponentsConfig(dictionary: properties[key] as? [String: AnyObject] ?? [:])
    }
}

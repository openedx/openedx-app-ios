//
//  ThemeConfig.swift
//  Core
//
//  Created by Anton Yarmolenka on 01/12/2023.
//

import Foundation

private enum ThemeKeys: String, RawStringExtractable {
    case isRoundedCorners = "ROUNDED_CORNERS_STYLE"
    case buttonCornersRadius = "BUTTON_CORNERS_RADIUS"
}

public final class ThemeConfig: NSObject {
    public var isRoundedCorners: Bool
    public var buttonCornersRadius: Double
    
    init(dictionary: [String: AnyObject]) {
        isRoundedCorners = dictionary[ThemeKeys.isRoundedCorners] as? Bool != false
        buttonCornersRadius = dictionary[ThemeKeys.buttonCornersRadius] as? Double ?? 8.0
        super.init()
    }
}

private let ThemeKey = "THEME"
extension Config {
    public var theme: ThemeConfig {
        ThemeConfig(dictionary: self[ThemeKey] as? [String: AnyObject] ?? [:])
    }
}

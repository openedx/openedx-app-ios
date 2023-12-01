//
//  ThemeConfig.swift
//  Core
//
//  Created by Anton Yarmolenka on 01/12/2023.
//

import Foundation

private enum ThemeKeys: String {
    case isRoundedCorners = "ROUNDED_CORNERS_STYLE"
}

public final class ThemeConfig: NSObject {
    public var isRoundedCorners: Bool = true

    init(dictionary: [String: AnyObject]) {
        super.init()
        isRoundedCorners = dictionary[ThemeKeys.isRoundedCorners.rawValue] as? Bool == true
    }
}

private let ThemeKey = "THEME"
extension Config {
    public var theme: ThemeConfig {
        ThemeConfig(dictionary: self[ThemeKey] as? [String: AnyObject] ?? [:])
    }
}

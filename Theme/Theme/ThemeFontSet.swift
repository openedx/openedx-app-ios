//
//  ThemeFontSet.swift
//  Theme
//
//  Created by Rawan Matar on 31/08/2026.
//

import SwiftUI

/// Per-tenant font size/weight overrides on top of whatever font family is compiled in.
public struct ThemeFontSet: Sendable {
    public var titleMedium: Font
    public var bodyLarge: Font
    public var labelSmall: Font

    public init(
        titleMedium: Font = Theme.Fonts.titleMedium,
        bodyLarge: Font = Theme.Fonts.bodyLarge,
        labelSmall: Font = Theme.Fonts.labelSmall
    ) {
        self.titleMedium = titleMedium
        self.bodyLarge = bodyLarge
        self.labelSmall = labelSmall
    }

    public static let `default` = ThemeFontSet()
}

//
//  ThemeFontSet.swift
//  Theme
//
//  Created by Rawan Matar on 12/05/2025.
//


import SwiftUI

public struct ThemeFontSet {
    public var titleMedium: Font
    public var bodyLarge: Font
    public var labelSmall: Font
    // Add more font variants as needed

    public static let `default` = ThemeFontSet(
        titleMedium: Theme.Fonts.titleMedium,
        bodyLarge: Theme.Fonts.bodyLarge,
        labelSmall: Theme.Fonts.labelSmall
    )

    public static let tenantB = ThemeFontSet(
        titleMedium: .custom("Georgia-Bold", size: 18),
        bodyLarge: .custom("Georgia", size: 16),
        labelSmall: .custom("Georgia-Italic", size: 10)
    )
}

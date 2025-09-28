//
//  ThemeDefinition.swift
//  Theme
//
//  Created by Rawan Matar on 12/05/2025.
//

import SwiftUI

public struct ThemeDefinition: Sendable {
    public var name: String
    public var appLogo: Image
    public var bgColor: Image
    public var colors: ThemeColorSet
    public var fonts: ThemeFontSet

    public init(colors: ThemeColorSet, fonts: ThemeFontSet, appLogo: Image, bgColor: Image, name: String) {
        self.colors = colors
        self.fonts = fonts
        self.appLogo = appLogo
        self.bgColor = bgColor
        self.name = name
    }

    public static let `default` = ThemeDefinition(
        colors: .default,
        fonts: .default,
        appLogo: ThemeAssets.appLogo.swiftUIImage,
        bgColor: ThemeAssets.headerBackground.swiftUIImage,
        name: "default"
    )

    public static let tenantA = ThemeDefinition(
        colors: .tenantA,
        fonts: .tenantA,
        appLogo: ThemeAssets.appLogo.swiftUIImage,
        bgColor: ThemeAssets.headerBackground.swiftUIImage,
        name: "TenantA"
    )

    public static let tenantB = ThemeDefinition(
        colors: .tenantB,
        fonts: .tenantB,
        appLogo: ThemeAssets.appLogo.swiftUIImage,
        bgColor: ThemeAssets.headerBackground.swiftUIImage,
        name: "TenantB"
    )
}

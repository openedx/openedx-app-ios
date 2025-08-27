//
//  ThemeDefinition.swift
//  Theme
//
//  Created by Rawan Matar on 12/05/2025.
//


import SwiftUI

public struct ThemeDefinition {
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
        bgColor: ThemeAssets.mtAuthBackground.swiftUIImage,
        name: "default"
    )

    public static let saudiRealEstateInstitute = ThemeDefinition(
        colors: .saudiRealEstateInstitute,
        fonts: .default,
        appLogo: ThemeAssets.sreiloginLogoWhite.swiftUIImage,
        bgColor: ThemeAssets.riyadahAuthBackground.swiftUIImage,
        name: "Saudi Real Estate Institute"
    )

    public static let NIEPD = ThemeDefinition(
        colors: .NIEPD,
        fonts: .tenantB,
        appLogo: ThemeAssets.niepdAppLogo.swiftUIImage,
        bgColor: ThemeAssets.niepdAuthBackground.swiftUIImage,
        name: "NIEPD"
    )
    
    public static let mt = ThemeDefinition(
        colors: .mt,
        fonts: .default,
        appLogo: ThemeAssets.mtAppLogo.swiftUIImage,
        bgColor: ThemeAssets.mtAuthBackground.swiftUIImage,
        name: "Ministry Of Tourism"
    )
}

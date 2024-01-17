//
//  Theme.swift
//  Theme
//
//  Created by Saeed Bashir on 28.11.2023.
//

import Foundation
import SwiftUI

private var fontsParser = FontParser()

public struct Theme {
    
    public struct Colors {
        public private(set) static var accentColor = ThemeAssets.accentColor.swiftUIColor
        public private(set) static var accentButtonColor = ThemeAssets.accentButtonColor.swiftUIColor
        public private(set) static var alert = ThemeAssets.alert.swiftUIColor
        public private(set) static var avatarStroke = ThemeAssets.avatarStroke.swiftUIColor
        public private(set) static var background = ThemeAssets.background.swiftUIColor
        public private(set) static var loginBackground = ThemeAssets.loginBackground.swiftUIColor
        public private(set) static var backgroundStroke = ThemeAssets.backgroundStroke.swiftUIColor
        public private(set) static var cardViewBackground = ThemeAssets.cardViewBackground.swiftUIColor
        public private(set) static var cardViewStroke = ThemeAssets.cardViewStroke.swiftUIColor
        public private(set) static var certificateForeground = ThemeAssets.certificateForeground.swiftUIColor
        public private(set) static var commentCellBackground = ThemeAssets.commentCellBackground.swiftUIColor
        public private(set) static var shadowColor = ThemeAssets.shadowColor.swiftUIColor
        public private(set) static var snackbarErrorColor = ThemeAssets.snackbarErrorColor.swiftUIColor
        public private(set) static var snackbarErrorTextColor = ThemeAssets.snackbarErrorTextColor.swiftUIColor
        public private(set) static var snackbarInfoAlert = ThemeAssets.snackbarInfoAlert.swiftUIColor
        public private(set) static var styledButtonBackground = ThemeAssets.styledButtonBackground.swiftUIColor
        public private(set) static var styledButtonText = ThemeAssets.styledButtonText.swiftUIColor
        public private(set) static var textPrimary = ThemeAssets.textPrimary.swiftUIColor
        public private(set) static var textSecondary = ThemeAssets.textSecondary.swiftUIColor
        public private(set) static var textInputBackground = ThemeAssets.textInputBackground.swiftUIColor
        public private(set) static var textInputStroke = ThemeAssets.textInputStroke.swiftUIColor
        public private(set) static var textInputUnfocusedBackground = ThemeAssets.textInputUnfocusedBackground.swiftUIColor
        public private(set) static var textInputUnfocusedStroke = ThemeAssets.textInputUnfocusedStroke.swiftUIColor
        public private(set) static var warning = ThemeAssets.warning.swiftUIColor
        public private(set) static var white = ThemeAssets.white.swiftUIColor
        public private(set) static var loginNavigationText = ThemeAssets.loginNavigationText.swiftUIColor

        public static func update(
            accentColor: Color = ThemeAssets.accentColor.swiftUIColor,
            alert: Color = ThemeAssets.alert.swiftUIColor,
            avatarStroke: Color = ThemeAssets.avatarStroke.swiftUIColor,
            background: Color = ThemeAssets.background.swiftUIColor,
            backgroundStroke: Color = ThemeAssets.backgroundStroke.swiftUIColor,
            cardViewBackground: Color = ThemeAssets.cardViewBackground.swiftUIColor,
            cardViewStroke: Color = ThemeAssets.cardViewStroke.swiftUIColor,
            certificateForeground: Color = ThemeAssets.certificateForeground.swiftUIColor,
            commentCellBackground: Color = ThemeAssets.commentCellBackground.swiftUIColor,
            shadowColor: Color = ThemeAssets.shadowColor.swiftUIColor,
            snackbarErrorColor: Color = ThemeAssets.snackbarErrorColor.swiftUIColor,
            snackbarErrorTextColor: Color = ThemeAssets.snackbarErrorTextColor.swiftUIColor,
            snackbarInfoAlert: Color = ThemeAssets.snackbarInfoAlert.swiftUIColor,
            styledButtonBackground: Color = ThemeAssets.styledButtonBackground.swiftUIColor,
            styledButtonText: Color = ThemeAssets.styledButtonText.swiftUIColor,
            textPrimary: Color = ThemeAssets.textPrimary.swiftUIColor,
            textSecondary: Color = ThemeAssets.textSecondary.swiftUIColor,
            textInputBackground: Color = ThemeAssets.textInputBackground.swiftUIColor,
            textInputStroke: Color = ThemeAssets.textInputStroke.swiftUIColor,
            textInputUnfocusedBackground: Color = ThemeAssets.textInputUnfocusedBackground.swiftUIColor,
            textInputUnfocusedStroke: Color = ThemeAssets.textInputUnfocusedStroke.swiftUIColor,
            warning: Color = ThemeAssets.warning.swiftUIColor,
            white: Color = ThemeAssets.white.swiftUIColor
        ) {
            self.accentColor = accentColor
            self.alert = alert
            self.avatarStroke = avatarStroke
            self.background = background
            self.backgroundStroke = backgroundStroke
            self.cardViewBackground = cardViewBackground
            self.cardViewStroke = cardViewStroke
            self.certificateForeground = certificateForeground
            self.commentCellBackground = commentCellBackground
            self.shadowColor = shadowColor
            self.snackbarErrorColor = snackbarErrorColor
            self.snackbarErrorTextColor = snackbarErrorTextColor
            self.snackbarInfoAlert = snackbarInfoAlert
            self.styledButtonBackground = styledButtonBackground
            self.styledButtonText = styledButtonText
            self.textPrimary = textPrimary
            self.textSecondary = textSecondary
            self.textInputBackground = textInputBackground
            self.textInputStroke = textInputStroke
            self.textInputUnfocusedBackground = textInputUnfocusedBackground
            self.textInputUnfocusedStroke = textInputUnfocusedStroke
            self.warning = warning
            self.white = white
        }
    }
    
    // Use this structure where the computed Color.uiColor() extension is not appropriate.
    public struct UIColors {
        public private(set) static var textPrimary = ThemeAssets.textPrimary.color
        public private(set) static var accentColor = ThemeAssets.accentColor.color

        public static func update(
            textPrimary: UIColor = ThemeAssets.textPrimary.color,
            accentColor: UIColor = ThemeAssets.accentColor.color
        ) {
            self.textPrimary = textPrimary
            self.accentColor = accentColor
        }
    }

    public struct Fonts {
        
        public static let displayLarge: Font = .custom(fontsParser.fontName(for: .regular), size: 57)
        public static let displayMedium: Font = .custom(fontsParser.fontName(for: .regular), size: 45)
        public static let displaySmall: Font = .custom(fontsParser.fontName(for: .bold), size: 36)
        
        public static let headlineLarge: Font = .custom(fontsParser.fontName(for: .regular), size: 32)
        public static let headlineMedium: Font = .custom(fontsParser.fontName(for: .regular), size: 28)
        public static let headlineSmall: Font = .custom(fontsParser.fontName(for: .regular), size: 24)
        
        public static let titleLarge: Font = .custom(fontsParser.fontName(for: .bold), size: 22)
        public static let titleMedium: Font = .custom(fontsParser.fontName(for: .semiBold), size: 18)
        public static let titleSmall: Font = .custom(fontsParser.fontName(for: .medium), size: 14)
        
        public static let bodyLarge: Font = .custom(fontsParser.fontName(for: .regular), size: 16)
        public static let bodyMedium: Font = .custom(fontsParser.fontName(for: .regular), size: 14)
        public static let bodySmall: Font = .custom(fontsParser.fontName(for: .regular), size: 12)
        
        public static let labelLarge: Font = .custom(fontsParser.fontName(for: .medium), size: 14)
        public static let labelMedium: Font = .custom(fontsParser.fontName(for: .regular), size: 12)
        public static let labelSmall: Font = .custom(fontsParser.fontName(for: .regular), size: 10)
    }
    
    public struct Shapes {
        public static var isRoundedCorners: Bool = true
        public static let screenBackgroundRadius = 24.0
        public static let cardImageRadius = 10.0
        public static let textInputShape =  {
            let radius: CGFloat = isRoundedCorners ? 8 : 0
            return RoundedRectangle(cornerRadius: radius)
        }()
        public static let buttonShape = {
            let radius: CGFloat = isRoundedCorners ? 8 : 0
            return RoundedCorners(tl: radius, tr: radius, bl: radius, br: radius)
        }()
        public static let unitButtonShape = RoundedCorners(tl: 21, tr: 21, bl: 21, br: 21)
        public static let roundedScreenBackgroundShape = RoundedCorners(
            tl: Theme.Shapes.screenBackgroundRadius,
            tr: Theme.Shapes.screenBackgroundRadius,
            bl: Theme.Shapes.screenBackgroundRadius,
            br: Theme.Shapes.screenBackgroundRadius
        )
        public static let roundedScreenBackgroundShapeCroppedBottom = RoundedCorners(
            tl: Theme.Shapes.screenBackgroundRadius,
            tr: Theme.Shapes.screenBackgroundRadius
        )
        public static let cardShape = RoundedCorners(tl: 12, tr: 12, bl: 12, br: 12)
    }
    
    public struct Timeout {
        public static let snackbarMessageShortTimeout: TimeInterval = 3
        public static let snackbarMessageLongTimeout: TimeInterval = 5
    }
    
}

public extension Theme.Fonts {
    // swiftlint:disable type_name
    class __ {}
    static func registerFonts() {
        guard let url = Bundle(for: __.self).url(forResource: "fonts_file", withExtension: "ttf") else { return }
        CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
    }
    // swiftlint:enable type_name
}

extension View {
    public func loadFonts() -> some View {
        Theme.Fonts.registerFonts()
        return self
    }
}

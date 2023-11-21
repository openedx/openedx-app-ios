//
//  Theme.swift
//  Core
//
//  Created by Vladimir Chekyrta on 13.09.2022.
//

import Foundation
import SwiftUI

private var fontsParser = FontParser()

public struct Theme {
    
    public struct Colors {
        public private(set) static var accentColor = CoreAssets.Configurable.accentColor.swiftUIColor
        public private(set) static var alert = CoreAssets.Configurable.alert.swiftUIColor
        public private(set) static var avatarStroke = CoreAssets.Configurable.avatarStroke.swiftUIColor
        public private(set) static var background = CoreAssets.Configurable.background.swiftUIColor
        public private(set) static var backgroundStroke = CoreAssets.Configurable.backgroundStroke.swiftUIColor
        public private(set) static var cardViewBackground = CoreAssets.Configurable.cardViewBackground.swiftUIColor
        public private(set) static var cardViewStroke = CoreAssets.Configurable.cardViewStroke.swiftUIColor
        public private(set) static var certificateForeground = CoreAssets.Configurable.certificateForeground.swiftUIColor
        public private(set) static var commentCellBackground = CoreAssets.Configurable.commentCellBackground.swiftUIColor
        public private(set) static var shadowColor = CoreAssets.Configurable.shadowColor.swiftUIColor
        public private(set) static var snackbarErrorColor = CoreAssets.Configurable.snackbarErrorColor.swiftUIColor
        public private(set) static var snackbarErrorTextColor = CoreAssets.Configurable.snackbarErrorTextColor.swiftUIColor
        public private(set) static var snackbarInfoAlert = CoreAssets.Configurable.snackbarInfoAlert.swiftUIColor
        public private(set) static var styledButtonBackground = CoreAssets.Configurable.styledButtonBackground.swiftUIColor
        public private(set) static var styledButtonText = CoreAssets.Configurable.styledButtonText.swiftUIColor
        public private(set) static var textPrimary = CoreAssets.Configurable.textPrimary.swiftUIColor
        public private(set) static var textSecondary = CoreAssets.Configurable.textSecondary.swiftUIColor
        public private(set) static var textInputBackground = CoreAssets.Configurable.textInputBackground.swiftUIColor
        public private(set) static var textInputStroke = CoreAssets.Configurable.textInputStroke.swiftUIColor
        public private(set) static var textInputUnfocusedBackground = CoreAssets.Configurable.textInputUnfocusedBackground.swiftUIColor
        public private(set) static var textInputUnfocusedStroke = CoreAssets.Configurable.textInputUnfocusedStroke.swiftUIColor
        public private(set) static var warning = CoreAssets.Configurable.warning.swiftUIColor
        public private(set) static var white = CoreAssets.Configurable.white.swiftUIColor

        public static func update(
            accentColor: Color = CoreAssets.Configurable.accentColor.swiftUIColor,
            alert: Color = CoreAssets.Configurable.alert.swiftUIColor,
            avatarStroke: Color = CoreAssets.Configurable.avatarStroke.swiftUIColor,
            background: Color = CoreAssets.Configurable.background.swiftUIColor,
            backgroundStroke: Color = CoreAssets.Configurable.backgroundStroke.swiftUIColor,
            cardViewBackground: Color = CoreAssets.Configurable.cardViewBackground.swiftUIColor,
            cardViewStroke: Color = CoreAssets.Configurable.cardViewStroke.swiftUIColor,
            certificateForeground: Color = CoreAssets.Configurable.certificateForeground.swiftUIColor,
            commentCellBackground: Color = CoreAssets.Configurable.commentCellBackground.swiftUIColor,
            shadowColor: Color = CoreAssets.Configurable.shadowColor.swiftUIColor,
            snackbarErrorColor: Color = CoreAssets.Configurable.snackbarErrorColor.swiftUIColor,
            snackbarErrorTextColor: Color = CoreAssets.Configurable.snackbarErrorTextColor.swiftUIColor,
            snackbarInfoAlert: Color = CoreAssets.Configurable.snackbarInfoAlert.swiftUIColor,
            styledButtonBackground: Color = CoreAssets.Configurable.styledButtonBackground.swiftUIColor,
            styledButtonText: Color = CoreAssets.Configurable.styledButtonText.swiftUIColor,
            textPrimary: Color = CoreAssets.Configurable.textPrimary.swiftUIColor,
            textSecondary: Color = CoreAssets.Configurable.textSecondary.swiftUIColor,
            textInputBackground: Color = CoreAssets.Configurable.textInputBackground.swiftUIColor,
            textInputStroke: Color = CoreAssets.Configurable.textInputStroke.swiftUIColor,
            textInputUnfocusedBackground: Color = CoreAssets.Configurable.textInputUnfocusedBackground.swiftUIColor,
            textInputUnfocusedStroke: Color = CoreAssets.Configurable.textInputUnfocusedStroke.swiftUIColor,
            warning: Color = CoreAssets.Configurable.warning.swiftUIColor,
            white: Color = CoreAssets.Configurable.white.swiftUIColor
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
        public static let screenBackgroundRadius = 24.0
        public static let cardImageRadius = 10.0
        public static let textInputShape = RoundedRectangle(cornerRadius: 8)
        public static let buttonShape = RoundedCorners(tl: 8, tr: 8, bl: 8, br: 8)
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

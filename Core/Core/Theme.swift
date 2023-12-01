//
//  Theme.swift
//  Core
//
//  Created by Vladimir Chekyrta on 13.09.2022.
//

import Foundation
import SwiftUI
import Swinject

public struct Theme {
    
    public struct Colors {
        public private(set) static var accentColor = CoreAssets.accentColor.swiftUIColor
        public private(set) static var accentButtonColor = CoreAssets.accentButtonColor.swiftUIColor
        public private(set) static var alert = CoreAssets.alert.swiftUIColor
        public private(set) static var avatarStroke = CoreAssets.avatarStroke.swiftUIColor
        public private(set) static var background = CoreAssets.background.swiftUIColor
        public private(set) static var loginBackground = CoreAssets.loginBackground.swiftUIColor
        public private(set) static var backgroundStroke = CoreAssets.backgroundStroke.swiftUIColor
        public private(set) static var cardViewBackground = CoreAssets.cardViewBackground.swiftUIColor
        public private(set) static var cardViewStroke = CoreAssets.cardViewStroke.swiftUIColor
        public private(set) static var certificateForeground = CoreAssets.certificateForeground.swiftUIColor
        public private(set) static var commentCellBackground = CoreAssets.commentCellBackground.swiftUIColor
        public private(set) static var shadowColor = CoreAssets.shadowColor.swiftUIColor
        public private(set) static var snackbarErrorColor = CoreAssets.snackbarErrorColor.swiftUIColor
        public private(set) static var snackbarErrorTextColor = CoreAssets.snackbarErrorTextColor.swiftUIColor
        public private(set) static var snackbarInfoAlert = CoreAssets.snackbarInfoAlert.swiftUIColor
        public private(set) static var styledButtonBackground = CoreAssets.styledButtonBackground.swiftUIColor
        public private(set) static var styledButtonText = CoreAssets.styledButtonText.swiftUIColor
        public private(set) static var textPrimary = CoreAssets.textPrimary.swiftUIColor
        public private(set) static var textSecondary = CoreAssets.textSecondary.swiftUIColor
        public private(set) static var textInputBackground = CoreAssets.textInputBackground.swiftUIColor
        public private(set) static var textInputStroke = CoreAssets.textInputStroke.swiftUIColor
        public private(set) static var textInputUnfocusedBackground = CoreAssets.textInputUnfocusedBackground.swiftUIColor
        public private(set) static var textInputUnfocusedStroke = CoreAssets.textInputUnfocusedStroke.swiftUIColor
        public private(set) static var warning = CoreAssets.warning.swiftUIColor

        public static func update(
            accentColor: Color = CoreAssets.accentColor.swiftUIColor,
            alert: Color = CoreAssets.alert.swiftUIColor,
            avatarStroke: Color = CoreAssets.avatarStroke.swiftUIColor,
            background: Color = CoreAssets.background.swiftUIColor,
            backgroundStroke: Color = CoreAssets.backgroundStroke.swiftUIColor,
            cardViewBackground: Color = CoreAssets.cardViewBackground.swiftUIColor,
            cardViewStroke: Color = CoreAssets.cardViewStroke.swiftUIColor,
            certificateForeground: Color = CoreAssets.certificateForeground.swiftUIColor,
            commentCellBackground: Color = CoreAssets.commentCellBackground.swiftUIColor,
            shadowColor: Color = CoreAssets.shadowColor.swiftUIColor,
            snackbarErrorColor: Color = CoreAssets.snackbarErrorColor.swiftUIColor,
            snackbarErrorTextColor: Color = CoreAssets.snackbarErrorTextColor.swiftUIColor,
            snackbarInfoAlert: Color = CoreAssets.snackbarInfoAlert.swiftUIColor,
            styledButtonBackground: Color = CoreAssets.styledButtonBackground.swiftUIColor,
            styledButtonText: Color = CoreAssets.styledButtonText.swiftUIColor,
            textPrimary: Color = CoreAssets.textPrimary.swiftUIColor,
            textSecondary: Color = CoreAssets.textSecondary.swiftUIColor,
            textInputBackground: Color = CoreAssets.textInputBackground.swiftUIColor,
            textInputStroke: Color = CoreAssets.textInputStroke.swiftUIColor,
            textInputUnfocusedBackground: Color = CoreAssets.textInputUnfocusedBackground.swiftUIColor,
            textInputUnfocusedStroke: Color = CoreAssets.textInputUnfocusedStroke.swiftUIColor,
            warning: Color = CoreAssets.warning.swiftUIColor
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
        }
    }
    
    public struct Fonts {
        
        public static let displayLarge: Font = .custom("SFPro-Regular", size: 57)
        public static let displayMedium: Font = .custom("SFPro-Regular", size: 45)
        public static let displaySmall: Font = .custom("SFPro-Bold", size: 36)
        
        public static let headlineLarge: Font = .custom("SFPro-Regular", size: 32)
        public static let headlineMedium: Font = .custom("SFPro-Regular", size: 28)
        public static let headlineSmall: Font = .custom("SFPro-Regular", size: 24)
        
        public static let titleLarge: Font = .custom("SFPro-Bold", size: 22)
        public static let titleMedium: Font = .custom("SFPro-Semibold", size: 18)
        public static let titleSmall: Font = .custom("SFPro-Medium", size: 14)
        
        public static let bodyLarge: Font = .custom("SFPro-Regular", size: 16)
        public static let bodyMedium: Font = .custom("SFPro-Regular", size: 14)
        public static let bodySmall: Font = .custom("SFPro-Regular", size: 12)
        
        public static let labelLarge: Font = .custom("SFPro-Medium", size: 14)
        public static let labelMedium: Font = .custom("SFPro-Regular", size: 12)
        public static let labelSmall: Font = .custom("SFPro-Regular", size: 10)
    }
    
    public struct Shapes {
        public static let screenBackgroundRadius = 24.0
        public static let cardImageRadius = 10.0
        public static let textInputShape =  {
            let config = Container.shared.resolve(ConfigProtocol.self)!
            let radius: CGFloat = config.theme.isRoundedCorners ? 8 : 0
            return RoundedRectangle(cornerRadius: radius)
        }()
        public static let buttonShape = {
            let config = Container.shared.resolve(ConfigProtocol.self)!
            let radius: CGFloat = config.theme.isRoundedCorners ? 8 : 0
            return RoundedCorners(tl: radius, tr: radius, bl: radius, br: radius)
        }()
        public static let squareButtonShape = Rectangle()
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
        guard let url = Bundle(for: __.self).url(forResource: "SF-Pro", withExtension: "ttf") else { return }
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

//
//  Theme.swift
//  Theme
//
//  Created by Saeed Bashir on 28.11.2023.
//

import Foundation
import SwiftUI

private let fontsParser = FontParser()

public struct Theme: Sendable {
    
    // swiftlint:disable line_length
    public struct Colors: Sendable {
        nonisolated(unsafe) public private(set) static var accentColor = ThemeAssets.accentColor.swiftUIColor
        nonisolated(unsafe) public private(set) static var accentXColor = ThemeAssets.accentXColor.swiftUIColor
        nonisolated(unsafe) public private(set) static var accentButtonColor = ThemeAssets.accentButtonColor.swiftUIColor
        nonisolated(unsafe) public private(set) static var alert = ThemeAssets.alert.swiftUIColor
        nonisolated(unsafe) public private(set) static var avatarStroke = ThemeAssets.avatarStroke.swiftUIColor
        nonisolated(unsafe) public private(set) static var background = ThemeAssets.background.swiftUIColor
        nonisolated(unsafe) public private(set) static var loginBackground = ThemeAssets.loginBackground.swiftUIColor
        nonisolated(unsafe) public private(set) static var backgroundStroke = ThemeAssets.backgroundStroke.swiftUIColor
        nonisolated(unsafe) public private(set) static var cardViewBackground = ThemeAssets.cardViewBackground.swiftUIColor
        nonisolated(unsafe) public private(set) static var cardViewStroke = ThemeAssets.cardViewStroke.swiftUIColor
        nonisolated(unsafe) public private(set) static var certificateForeground = ThemeAssets.certificateForeground.swiftUIColor
        nonisolated(unsafe) public private(set) static var commentCellBackground = ThemeAssets.commentCellBackground.swiftUIColor
        nonisolated(unsafe) public private(set) static var nextWeekTimelineColor = ThemeAssets.nextWeekTimelineColor.swiftUIColor
        nonisolated(unsafe) public private(set) static var pastDueTimelineColor = ThemeAssets.pastDueTimelineColor.swiftUIColor
        nonisolated(unsafe) public private(set) static var thisWeekTimelineColor = ThemeAssets.thisWeekTimelineColor.swiftUIColor
        nonisolated(unsafe) public private(set) static var todayTimelineColor = ThemeAssets.todayTimelineColor.swiftUIColor
        nonisolated(unsafe) public private(set) static var upcomingTimelineColor = ThemeAssets.upcomingTimelineColor.swiftUIColor
        nonisolated(unsafe) public private(set) static var shadowColor = ThemeAssets.shadowColor.swiftUIColor
        nonisolated(unsafe) public private(set) static var snackbarErrorColor = ThemeAssets.snackbarErrorColor.swiftUIColor
        nonisolated(unsafe) public private(set) static var snackbarWarningColor = ThemeAssets.snackbarWarningColor.swiftUIColor
        nonisolated(unsafe) public private(set) static var snackbarInfoColor = ThemeAssets.snackbarInfoColor.swiftUIColor
        nonisolated(unsafe) public private(set) static var snackbarTextColor = ThemeAssets.snackbarTextColor.swiftUIColor
        nonisolated(unsafe) public private(set) static var styledButtonText = ThemeAssets.styledButtonText.swiftUIColor
        nonisolated(unsafe) public private(set) static var disabledButton = ThemeAssets.disabledButton.swiftUIColor
        nonisolated(unsafe) public private(set) static var disabledButtonText = ThemeAssets.disabledButtonText.swiftUIColor
        nonisolated(unsafe) public private(set) static var textPrimary = ThemeAssets.textPrimary.swiftUIColor
        nonisolated(unsafe) public private(set) static var textSecondary = ThemeAssets.textSecondary.swiftUIColor
        nonisolated(unsafe) public private(set) static var textSecondaryLight = ThemeAssets.textSecondaryLight.swiftUIColor
        nonisolated(unsafe) public private(set) static var textInputBackground = ThemeAssets.textInputBackground.swiftUIColor
        nonisolated(unsafe) public private(set) static var textInputStroke = ThemeAssets.textInputStroke.swiftUIColor
        nonisolated(unsafe) public private(set) static var textInputUnfocusedBackground = ThemeAssets.textInputUnfocusedBackground.swiftUIColor
        nonisolated(unsafe) public private(set) static var textInputUnfocusedStroke = ThemeAssets.textInputUnfocusedStroke.swiftUIColor
        nonisolated(unsafe) public private(set) static var warning = ThemeAssets.warning.swiftUIColor
        nonisolated(unsafe) public private(set) static var warningText = ThemeAssets.warningText.swiftUIColor
        nonisolated(unsafe) public private(set) static var white = ThemeAssets.white.swiftUIColor
        nonisolated(unsafe) public private(set) static var onProgress = ThemeAssets.onProgress.swiftUIColor
        nonisolated(unsafe) public private(set) static var progressDone = ThemeAssets.progressDone.swiftUIColor
        nonisolated(unsafe) public private(set) static var progressSkip = ThemeAssets.progressSkip.swiftUIColor
        nonisolated(unsafe) public private(set) static var progressSelectedAndDone = ThemeAssets.selectedAndDone.swiftUIColor
        nonisolated(unsafe) public private(set) static var loginNavigationText = ThemeAssets.loginNavigationText.swiftUIColor
        nonisolated(unsafe) public private(set) static var datesSectionBackground = ThemeAssets.datesSectionBackground.swiftUIColor
        nonisolated(unsafe) public private(set) static var datesSectionStroke = ThemeAssets.datesSectionStroke.swiftUIColor
        nonisolated(unsafe) public private(set) static var navigationBarTintColor = ThemeAssets.navigationBarTintColor.swiftUIColor
        nonisolated(unsafe) public private(set) static var secondaryButtonBorderColor = ThemeAssets.secondaryButtonBorderColor.swiftUIColor
        nonisolated(unsafe) public private(set) static var secondaryButtonTextColor = ThemeAssets.secondaryButtonTextColor.swiftUIColor
        nonisolated(unsafe) public private(set) static var secondaryButtonBGColor = ThemeAssets.secondaryButtonBGColor.swiftUIColor
        nonisolated(unsafe) public private(set) static var success = ThemeAssets.success.swiftUIColor
        nonisolated(unsafe) public private(set) static var primaryButtonTextColor = ThemeAssets.primaryButtonTextColor.swiftUIColor
        nonisolated(unsafe) public private(set) static var toggleSwitchColor = ThemeAssets.toggleSwitchColor.swiftUIColor
        nonisolated(unsafe) public private(set) static var textInputTextColor = ThemeAssets.textInputTextColor.swiftUIColor
        nonisolated(unsafe) public private(set) static var textInputPlaceholderColor = ThemeAssets.textInputPlaceholderColor.swiftUIColor
        nonisolated(unsafe) public private(set) static var infoColor = ThemeAssets.infoColor.swiftUIColor
        nonisolated(unsafe) public private(set) static var irreversibleAlert = ThemeAssets.irreversibleAlert.swiftUIColor
        nonisolated(unsafe) public private(set) static var slidingTextColor = ThemeAssets.slidingTextColor.swiftUIColor
        nonisolated(unsafe) public private(set) static var slidingSelectedTextColor = ThemeAssets.slidingSelectedTextColor.swiftUIColor
        nonisolated(unsafe) public private(set) static var slidingStrokeColor = ThemeAssets.slidingStrokeColor.swiftUIColor
        nonisolated(unsafe) public private(set) static var primaryHeaderColor = ThemeAssets.primaryHeaderColor.swiftUIColor
        nonisolated(unsafe) public private(set) static var secondaryHeaderColor = ThemeAssets.secondaryHeaderColor.swiftUIColor
        nonisolated(unsafe) public private(set) static var courseCardShadow = ThemeAssets.courseCardShadow.swiftUIColor
        nonisolated(unsafe) public private(set) static var shade = ThemeAssets.shade.swiftUIColor
        nonisolated(unsafe) public private(set) static var courseCardBackground = ThemeAssets.courseCardBackground.swiftUIColor
        nonisolated(unsafe) public private(set) static var deleteAccountBG = ThemeAssets.deleteAccountBG.swiftUIColor
        nonisolated(unsafe) public private(set) static var primaryCardCautionBG = ThemeAssets.primaryCardCautionBG.swiftUIColor
        nonisolated(unsafe) public private(set) static var primaryCardUpgradeBG = ThemeAssets.primaryCardCourseUpgradeBG.swiftUIColor
        nonisolated(unsafe) public private(set) static var primaryCardProgressBG = ThemeAssets.primaryCardProgressBG.swiftUIColor
        nonisolated(unsafe) public private(set) static var courseProgressBG = ThemeAssets.courseProgressBG.swiftUIColor
        nonisolated(unsafe) public private(set) static var resumeButtonBG = ThemeAssets.resumeButtonBG.swiftUIColor
        nonisolated(unsafe) public private(set) static var resumeButtonText = ThemeAssets.resumeButtonText.swiftUIColor

        public static func update(
            accentColor: Color = ThemeAssets.accentColor.swiftUIColor,
            accentXColor: Color = ThemeAssets.accentXColor.swiftUIColor,
            alert: Color = ThemeAssets.alert.swiftUIColor,
            avatarStroke: Color = ThemeAssets.avatarStroke.swiftUIColor,
            background: Color = ThemeAssets.background.swiftUIColor,
            backgroundStroke: Color = ThemeAssets.backgroundStroke.swiftUIColor,
            cardViewBackground: Color = ThemeAssets.cardViewBackground.swiftUIColor,
            cardViewStroke: Color = ThemeAssets.cardViewStroke.swiftUIColor,
            certificateForeground: Color = ThemeAssets.certificateForeground.swiftUIColor,
            commentCellBackground: Color = ThemeAssets.commentCellBackground.swiftUIColor,
            nextWeekTimelineColor: Color = ThemeAssets.nextWeekTimelineColor.swiftUIColor,
            pastDueTimelineColor: Color = ThemeAssets.pastDueTimelineColor.swiftUIColor,
            thisWeekTimelineColor: Color = ThemeAssets.thisWeekTimelineColor.swiftUIColor,
            todayTimelineColor: Color = ThemeAssets.todayTimelineColor.swiftUIColor,
            upcomingTimelineColor: Color = ThemeAssets.upcomingTimelineColor.swiftUIColor,
            shadowColor: Color = ThemeAssets.shadowColor.swiftUIColor,
            snackbarErrorColor: Color = ThemeAssets.snackbarErrorColor.swiftUIColor,
            snackbarInfoColor: Color = ThemeAssets.snackbarInfoColor.swiftUIColor,
            snackbarTextColor: Color = ThemeAssets.snackbarTextColor.swiftUIColor,
            styledButtonText: Color = ThemeAssets.styledButtonText.swiftUIColor,
            textPrimary: Color = ThemeAssets.textPrimary.swiftUIColor,
            textSecondary: Color = ThemeAssets.textSecondary.swiftUIColor,
            textSecondaryLight: Color = ThemeAssets.textSecondaryLight.swiftUIColor,
            textInputBackground: Color = ThemeAssets.textInputBackground.swiftUIColor,
            textInputStroke: Color = ThemeAssets.textInputStroke.swiftUIColor,
            textInputUnfocusedBackground: Color = ThemeAssets.textInputUnfocusedBackground.swiftUIColor,
            textInputUnfocusedStroke: Color = ThemeAssets.textInputUnfocusedStroke.swiftUIColor,
            warning: Color = ThemeAssets.warning.swiftUIColor,
            white: Color = ThemeAssets.white.swiftUIColor,
            onProgress: Color = ThemeAssets.onProgress.swiftUIColor,
            progressDone: Color = ThemeAssets.progressDone.swiftUIColor,
            progressSkip: Color = ThemeAssets.progressSkip.swiftUIColor,
            datesSectionBackground: Color = ThemeAssets.datesSectionBackground.swiftUIColor,
            datesSectionStroke: Color = ThemeAssets.datesSectionStroke.swiftUIColor,
            navigationBarTintColor: Color = ThemeAssets.navigationBarTintColor.swiftUIColor,
            secondaryButtonBorderColor: Color = ThemeAssets.secondaryButtonBorderColor.swiftUIColor,
            secondaryButtonTextColor: Color = ThemeAssets.secondaryButtonTextColor.swiftUIColor,
            success: Color = ThemeAssets.success.swiftUIColor,
            primaryButtonTextColor: Color = ThemeAssets.primaryButtonTextColor.swiftUIColor,
            toggleSwitchColor: Color = ThemeAssets.toggleSwitchColor.swiftUIColor,
            textInputTextColor: Color = ThemeAssets.textInputTextColor.swiftUIColor,
            textInputPlaceholderColor: Color = ThemeAssets.textInputPlaceholderColor.swiftUIColor,
            infoColor: Color = ThemeAssets.infoColor.swiftUIColor,
            irreversibleAlert: Color = ThemeAssets.irreversibleAlert.swiftUIColor
        ) {
            self.accentColor = accentColor
            self.accentXColor = accentXColor
            self.alert = alert
            self.avatarStroke = avatarStroke
            self.background = background
            self.backgroundStroke = backgroundStroke
            self.cardViewBackground = cardViewBackground
            self.cardViewStroke = cardViewStroke
            self.certificateForeground = certificateForeground
            self.commentCellBackground = commentCellBackground
            self.nextWeekTimelineColor = nextWeekTimelineColor
            self.pastDueTimelineColor = pastDueTimelineColor
            self.thisWeekTimelineColor = thisWeekTimelineColor
            self.todayTimelineColor = todayTimelineColor
            self.upcomingTimelineColor = upcomingTimelineColor
            self.shadowColor = shadowColor
            self.snackbarErrorColor = snackbarErrorColor
            self.snackbarInfoColor = snackbarInfoColor
            self.snackbarTextColor = snackbarTextColor
            self.styledButtonText = styledButtonText
            self.textPrimary = textPrimary
            self.textSecondary = textSecondary
            self.textSecondaryLight = textSecondaryLight
            self.textInputBackground = textInputBackground
            self.textInputStroke = textInputStroke
            self.textInputUnfocusedBackground = textInputUnfocusedBackground
            self.textInputUnfocusedStroke = textInputUnfocusedStroke
            self.warning = warning
            self.white = white
            self.onProgress = onProgress
            self.progressDone = progressDone
            self.progressSkip = progressSkip
            self.datesSectionBackground = datesSectionBackground
            self.datesSectionStroke = datesSectionStroke
            self.navigationBarTintColor = navigationBarTintColor
            self.secondaryButtonBorderColor = secondaryButtonBorderColor
            self.secondaryButtonTextColor = secondaryButtonTextColor
            self.success = success
            self.primaryButtonTextColor = primaryButtonTextColor
            self.toggleSwitchColor = toggleSwitchColor
            self.textInputTextColor = textInputTextColor
            self.textInputPlaceholderColor = textInputPlaceholderColor
            self.infoColor = infoColor
            self.irreversibleAlert = irreversibleAlert
        }
    }
    // swiftlint:enable line_length
    
    // Use this structure where the computed Color.uiColor() extension is not appropriate.
    public struct UIColors {
        nonisolated(unsafe) public private(set) static var textPrimary = ThemeAssets.textPrimary.color
        nonisolated(unsafe) public private(set) static var accentColor = ThemeAssets.accentColor.color
        nonisolated(unsafe) public private(set) static var accentXColor = ThemeAssets.accentXColor.color
        nonisolated(unsafe) public private(set) static var navigationBarTintColor =
        ThemeAssets.navigationBarTintColor.color
        nonisolated(unsafe) public private(set) static var tabbarActiveColor = ThemeAssets.tabbarActiveColor.color
        nonisolated(unsafe) public private(set) static var tabbarBGColor = ThemeAssets.tabbarBGColor.color
        nonisolated(unsafe) public private(set) static var tabbarInactiveColor = ThemeAssets.tabbarInactiveColor.color

        public static func update(
            textPrimary: UIColor = ThemeAssets.textPrimary.color,
            accentColor: UIColor = ThemeAssets.accentColor.color,
            accentXColor: UIColor = ThemeAssets.accentXColor.color,
            navigationBarTintColor: UIColor = ThemeAssets.navigationBarTintColor.color
        ) {
            self.textPrimary = textPrimary
            self.accentColor = accentColor
            self.accentXColor = accentXColor
            self.navigationBarTintColor = navigationBarTintColor
        }
    }

    public struct Fonts: Sendable {
        
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
        public static let bodyMicro: Font = .custom(fontsParser.fontName(for: .light), size: 11)
        
        public static let labelLarge: Font = .custom(fontsParser.fontName(for: .medium), size: 14)
        public static let labelMedium: Font = .custom(fontsParser.fontName(for: .regular), size: 12)
        public static let labelSmall: Font = .custom(fontsParser.fontName(for: .regular), size: 10)
    }
    
    public struct UIFonts: Sendable {
        public static func labelSmall() -> UIFont {
            guard let font = UIFont(name: fontsParser.fontName(for: .regular), size: 10) else {
                assert(false, "Could not find the required font")
                return UIFont.systemFont(ofSize: 10)
            }
            
            return font
        }
        
        public static func labelLarge() -> UIFont {
            guard let font = UIFont(name: fontsParser.fontName(for: .regular), size: 14) else {
                assert(false, "Could not find the required font")
                return UIFont.systemFont(ofSize: 14)
            }
            
            return font
        }
        
        public static func titleMedium() -> UIFont {
            guard let font = UIFont(name: fontsParser.fontName(for: .semiBold), size: 18) else {
                assert(false, "Could not find the required font")
                return UIFont.systemFont(ofSize: 18)
            }
            
            return font
        }
    }
    
    public struct Shapes: Sendable {
        nonisolated(unsafe) public static var isRoundedCorners: Bool = true
        nonisolated(unsafe) public static var buttonCornersRadius: Double = 8.0
        public static let screenBackgroundRadius = 24.0
        public static let cardImageRadius = 10.0
        public static let textInputShape =  {
            let radius: CGFloat = isRoundedCorners ? 8 : 0
            return RoundedRectangle(cornerRadius: radius)
        }()
        public static let buttonShape = {
            let radius: CGFloat = isRoundedCorners ? buttonCornersRadius : 0
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
    
    public struct InputFieldBackground: View {
        public let placeHolder: String
        public let text: String
        public let color: Color
        public let padding: CGFloat
        public let font: Font
        
        public init(
            placeHolder: String,
            text: String,
            color: Color = Theme.Colors.textInputPlaceholderColor,
            font: Font = Theme.Fonts.bodyLarge,
            padding: CGFloat = 8
        ) {
            self.placeHolder = placeHolder
            self.color = color
            self.text = text
            self.padding = padding
            self.font = font
        }
        
        public var body: some View {
            ZStack(alignment: .leading) {
                Theme.Shapes.textInputShape
                    .fill(Theme.Colors.textInputBackground)
                if text.count == 0 {
                    Text(placeHolder)
                        .foregroundColor(color)
                        .padding(.leading, padding)
                        .font(font)
                }
            }
        }
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

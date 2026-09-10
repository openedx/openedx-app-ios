//
//  ThemeManager.swift
//  Theme
//
//  Created by Rawan Matar on 31/08/2026.
//

import Foundation
import SwiftUI

@MainActor
public final class ThemeManager: ObservableObject {
    public static let shared = ThemeManager()

    @Published public private(set) var theme: ThemeDefinition

    private init() {
        self.theme = .default
    }

    /// Applies the theme for the given tenant (or the default when `key` is `nil`).
    /// Safe to call at launch or any time the selected tenant changes. Palette/logo
    /// params are the tenant's `THEME.light`/`THEME.dark`/`LOGO_URL`/
    /// `HEADER_BACKGROUND_URL` JSON fields — all optional.
    public func applyTheme(
        key: String?,
        tenantName: String? = nil,
        colorHex: String? = nil,
        themeColorsLight: [String: String] = [:],
        themeColorsDark: [String: String] = [:],
        logoURLString: String? = nil,
        headerBackgroundURLString: String? = nil
    ) {
        let selectedTheme = ThemeDefinition.resolve(
            key: key,
            tenantName: tenantName,
            colorHex: colorHex,
            themeColorsLight: themeColorsLight,
            themeColorsDark: themeColorsDark,
            logoURLString: logoURLString,
            headerBackgroundURLString: headerBackgroundURLString
        )
        self.theme = selectedTheme

        Theme.Colors.update(
            accentColor: selectedTheme.colors.accentColor,
            accentXColor: selectedTheme.colors.accentXColor,
            alert: selectedTheme.colors.alert,
            avatarStroke: selectedTheme.colors.avatarStroke,
            background: selectedTheme.colors.background,
            backgroundStroke: selectedTheme.colors.backgroundStroke,
            cardViewBackground: selectedTheme.colors.cardViewBackground,
            cardViewStroke: selectedTheme.colors.cardViewStroke,
            certificateForeground: selectedTheme.colors.certificateForeground,
            commentCellBackground: selectedTheme.colors.commentCellBackground,
            nextWeekTimelineColor: selectedTheme.colors.nextWeekTimelineColor,
            pastDueTimelineColor: selectedTheme.colors.pastDueTimelineColor,
            thisWeekTimelineColor: selectedTheme.colors.thisWeekTimelineColor,
            todayTimelineColor: selectedTheme.colors.todayTimelineColor,
            upcomingTimelineColor: selectedTheme.colors.upcomingTimelineColor,
            shadowColor: selectedTheme.colors.shadowColor,
            snackbarErrorColor: selectedTheme.colors.snackbarErrorColor,
            snackbarInfoColor: selectedTheme.colors.snackbarInfoColor,
            snackbarTextColor: selectedTheme.colors.snackbarTextColor,
            styledButtonText: selectedTheme.colors.styledButtonText,
            textPrimary: selectedTheme.colors.textPrimary,
            textSecondary: selectedTheme.colors.textSecondary,
            textSecondaryLight: selectedTheme.colors.textSecondaryLight,
            textTertiary: selectedTheme.colors.textTertiary,
            textInputBackground: selectedTheme.colors.textInputBackground,
            textInputStroke: selectedTheme.colors.textInputStroke,
            textInputUnfocusedBackground: selectedTheme.colors.textInputUnfocusedBackground,
            textInputUnfocusedStroke: selectedTheme.colors.textInputUnfocusedStroke,
            warning: selectedTheme.colors.warning,
            white: selectedTheme.colors.white,
            onProgress: selectedTheme.colors.onProgress,
            progressDone: selectedTheme.colors.progressDone,
            progressSkip: selectedTheme.colors.progressSkip,
            datesSectionBackground: selectedTheme.colors.datesSectionBackground,
            datesSectionStroke: selectedTheme.colors.datesSectionStroke,
            navigationBarTintColor: selectedTheme.colors.navigationBarTintColor,
            secondaryButtonBorderColor: selectedTheme.colors.secondaryButtonBorderColor,
            secondaryButtonTextColor: selectedTheme.colors.secondaryButtonTextColor,
            success: selectedTheme.colors.success,
            primaryButtonTextColor: selectedTheme.colors.primaryButtonTextColor,
            toggleSwitchColor: selectedTheme.colors.toggleSwitchColor,
            textInputTextColor: selectedTheme.colors.textInputTextColor,
            textInputPlaceholderColor: selectedTheme.colors.textInputPlaceholderColor,
            infoColor: selectedTheme.colors.infoColor,
            irreversibleAlert: selectedTheme.colors.irreversibleAlert,
            emptyStateIconColor: selectedTheme.colors.emptyStateIconColor,
            secondaryContentColor: selectedTheme.colors.secondaryContentColor
        )

        Theme.UIColors.update(
            textPrimary: UIColor(selectedTheme.colors.textPrimary),
            accentColor: UIColor(selectedTheme.colors.accentColor),
            accentXColor: UIColor(selectedTheme.colors.accentXColor),
            navigationBarTintColor: UIColor(selectedTheme.colors.navigationBarTintColor)
        )
    }
}

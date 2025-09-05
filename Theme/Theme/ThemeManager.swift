//
//  ThemeManager.swift
//  Theme
//
//  Created by Rawan Matar on 12/05/2025.
//
import Foundation
import Combine
import SwiftUI

@MainActor
public final class ThemeManager: ObservableObject {
    public static let shared = ThemeManager()

    @Published public private(set) var theme: ThemeDefinition

    private init() {
        self.theme = .default // Initial theme
    }

    public func applyTheme(for tenantName: String, localizedName: String) {
        let selectedTheme: ThemeDefinition
        switch tenantName.lowercased() {
        case "tenanta":
            selectedTheme = .tenantA
        case "tenantb":
            selectedTheme = .tenantB
        default:
            selectedTheme = .default
        }

        DispatchQueue.main.async { [self] in
            self.theme = selectedTheme
            self.theme.name = localizedName
            // Optional: update static Theme values here
            Theme.Colors.update(
                accentColor: theme.colors.accentColor,
                accentXColor: theme.colors.accentXColor,
                accentButtonColor: theme.colors.accentButtonColor,
                alert: theme.colors.alert,
                avatarStroke: theme.colors.avatarStroke,
                background: theme.colors.background,
                backgroundStroke: theme.colors.backgroundStroke,
                cardViewBackground: theme.colors.cardViewBackground,
                cardViewStroke: theme.colors.cardViewStroke,
                certificateForeground: theme.colors.certificateForeground,
                commentCellBackground: theme.colors.commentCellBackground,
                nextWeekTimelineColor: theme.colors.nextWeekTimelineColor,
                pastDueTimelineColor: theme.colors.pastDueTimelineColor,
                thisWeekTimelineColor: theme.colors.thisWeekTimelineColor,
                todayTimelineColor: theme.colors.todayTimelineColor,
                upcomingTimelineColor: theme.colors.upcomingTimelineColor,
                shadowColor: theme.colors.shadowColor,
                snackbarErrorColor: theme.colors.snackbarErrorColor,
                snackbarInfoColor: theme.colors.snackbarInfoColor,
                snackbarTextColor: theme.colors.snackbarTextColor,
                styledButtonText: theme.colors.styledButtonText,
                textPrimary: theme.colors.textPrimary,
                textSecondary: theme.colors.textSecondary,
                textSecondaryLight: theme.colors.textSecondaryLight,
                textInputBackground: theme.colors.textInputBackground,
                textInputStroke: theme.colors.textInputStroke,
                textInputUnfocusedBackground: theme.colors.textInputUnfocusedBackground,
                textInputUnfocusedStroke: theme.colors.textInputUnfocusedStroke,
                warning: theme.colors.warning,
                white: theme.colors.white,
                onProgress: theme.colors.onProgress,
                progressDone: theme.colors.progressDone,
                progressSkip: theme.colors.progressSkip,
                datesSectionBackground: theme.colors.datesSectionBackground,
                datesSectionStroke: theme.colors.datesSectionStroke,
                navigationBarTintColor: theme.colors.navigationBarTintColor,
                navigationBarColor: theme.colors.navigationBarColor,
                navigationBarColorDark: theme.colors.navigationBarColorDark,
                loginNavigationText: theme.colors.loginNavigationText,
                secondaryButtonBorderColor: theme.colors.secondaryButtonBorderColor,
                secondaryButtonTextColor: theme.colors.secondaryButtonTextColor,
                success: theme.colors.success,
                tabbarColor: theme.colors.tabbarColor,
                tabbarTintColor: theme.colors.tabbarTintColor,
                primaryButtonTextColor: theme.colors.primaryButtonTextColor,
                toggleSwitchColor: theme.colors.toggleSwitchColor,
                textInputTextColor: theme.colors.textInputTextColor,
                textInputPlaceholderColor: theme.colors.textInputPlaceholderColor,
                infoColor: theme.colors.infoColor,
                irreversibleAlert: theme.colors.irreversibleAlert,
                resumeButtonBG: theme.colors.resumeButtonBG,
                resumeButtonText: theme.colors.resumeButtonText
            )
            
            Theme.UIColors.update(
                textPrimary: UIColor(theme.colors.textPrimary),
                accentColor: UIColor(theme.colors.accentColor),
                accentXColor: UIColor(theme.colors.accentXColor),
                navigationBarTintColor: UIColor(theme.colors.navigationBarTintColor),
                navigationBarColor: UIColor(theme.colors.navigationBarColor),
                navigationBarColorDark: UIColor(theme.colors.navigationBarColorDark),
                loginNavigationText: UIColor(theme.colors.loginNavigationText),
            )
        }
    }
}

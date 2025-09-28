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
            Theme.updateConfig(.init(
                name: localizedName,
                appLogo: Image("tenantA_logo"),
                bgColor: Image("tenantA_background")
            ))
            self.theme = selectedTheme
            self.theme.name = localizedName
            // Optional: update static Theme values here
            Theme.Colors.update(
                accentColor: selectedTheme.colors.accentColor,
                accentXColor: selectedTheme.colors.accentXColor,
                accentButtonColor: selectedTheme.colors.accentButtonColor,
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
                navigationBarColor: selectedTheme.colors.navigationBarColor,
                navigationBarColorDark: selectedTheme.colors.navigationBarColorDark,
                loginNavigationText: selectedTheme.colors.loginNavigationText,
                secondaryButtonBorderColor: selectedTheme.colors.secondaryButtonBorderColor,
                secondaryButtonTextColor: selectedTheme.colors.secondaryButtonTextColor,
                success: selectedTheme.colors.success,
                tabbarColor: selectedTheme.colors.tabbarColor,
                tabbarTintColor: selectedTheme.colors.tabbarTintColor,
                primaryButtonTextColor: selectedTheme.colors.primaryButtonTextColor,
                toggleSwitchColor: selectedTheme.colors.toggleSwitchColor,
                textInputTextColor: selectedTheme.colors.textInputTextColor,
                textInputPlaceholderColor: selectedTheme.colors.textInputPlaceholderColor,
                infoColor: selectedTheme.colors.infoColor,
                irreversibleAlert: selectedTheme.colors.irreversibleAlert,
                resumeButtonBG: selectedTheme.colors.resumeButtonBG,
                resumeButtonText: selectedTheme.colors.resumeButtonText
            )
            
            Theme.UIColors.update(
                textPrimary: UIColor(selectedTheme.colors.textPrimary),
                accentColor: UIColor(selectedTheme.colors.accentColor),
                accentXColor: UIColor(selectedTheme.colors.accentXColor),
                navigationBarTintColor: UIColor(selectedTheme.colors.navigationBarTintColor),
                navigationBarColor: UIColor(selectedTheme.colors.navigationBarColor),
                navigationBarColorDark: UIColor(selectedTheme.colors.navigationBarColorDark),
                loginNavigationText: UIColor(selectedTheme.colors.loginNavigationText),
            )
        }
    }
}

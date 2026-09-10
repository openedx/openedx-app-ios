//
//  ThemeColorSet.swift
//  Theme
//
//  Created by Rawan Matar on 31/08/2026.
//

import SwiftUI

/// Per-tenant color palette. Only the colors `ThemeManager.applyTheme` can override
/// live here; everything else stays on the compiled default asset catalog.
public struct ThemeColorSet: Sendable {
    public var accentColor: Color
    public var accentXColor: Color
    public var alert: Color
    public var avatarStroke: Color
    public var background: Color
    public var backgroundStroke: Color
    public var cardViewBackground: Color
    public var cardViewStroke: Color
    public var certificateForeground: Color
    public var commentCellBackground: Color
    public var nextWeekTimelineColor: Color
    public var pastDueTimelineColor: Color
    public var thisWeekTimelineColor: Color
    public var todayTimelineColor: Color
    public var upcomingTimelineColor: Color
    public var shadowColor: Color
    public var snackbarErrorColor: Color
    public var snackbarInfoColor: Color
    public var snackbarTextColor: Color
    public var styledButtonText: Color
    public var textPrimary: Color
    public var textSecondary: Color
    public var textSecondaryLight: Color
    public var textTertiary: Color
    public var textInputBackground: Color
    public var textInputStroke: Color
    public var textInputUnfocusedBackground: Color
    public var textInputUnfocusedStroke: Color
    public var warning: Color
    public var white: Color
    public var onProgress: Color
    public var progressDone: Color
    public var progressSkip: Color
    public var datesSectionBackground: Color
    public var datesSectionStroke: Color
    public var navigationBarTintColor: Color
    public var secondaryButtonBorderColor: Color
    public var secondaryButtonTextColor: Color
    public var success: Color
    public var primaryButtonTextColor: Color
    public var toggleSwitchColor: Color
    public var textInputTextColor: Color
    public var textInputPlaceholderColor: Color
    public var infoColor: Color
    public var irreversibleAlert: Color
    public var emptyStateIconColor: Color
    public var secondaryContentColor: Color

    public init(
        accentColor: Color = Theme.Colors.accentColor,
        accentXColor: Color = Theme.Colors.accentXColor,
        alert: Color = Theme.Colors.alert,
        avatarStroke: Color = Theme.Colors.avatarStroke,
        background: Color = Theme.Colors.background,
        backgroundStroke: Color = Theme.Colors.backgroundStroke,
        cardViewBackground: Color = Theme.Colors.cardViewBackground,
        cardViewStroke: Color = Theme.Colors.cardViewStroke,
        certificateForeground: Color = Theme.Colors.certificateForeground,
        commentCellBackground: Color = Theme.Colors.commentCellBackground,
        nextWeekTimelineColor: Color = Theme.Colors.nextWeekTimelineColor,
        pastDueTimelineColor: Color = Theme.Colors.pastDueTimelineColor,
        thisWeekTimelineColor: Color = Theme.Colors.thisWeekTimelineColor,
        todayTimelineColor: Color = Theme.Colors.todayTimelineColor,
        upcomingTimelineColor: Color = Theme.Colors.upcomingTimelineColor,
        shadowColor: Color = Theme.Colors.shadowColor,
        snackbarErrorColor: Color = Theme.Colors.snackbarErrorColor,
        snackbarInfoColor: Color = Theme.Colors.snackbarInfoColor,
        snackbarTextColor: Color = Theme.Colors.snackbarTextColor,
        styledButtonText: Color = Theme.Colors.styledButtonText,
        textPrimary: Color = Theme.Colors.textPrimary,
        textSecondary: Color = Theme.Colors.textSecondary,
        textSecondaryLight: Color = Theme.Colors.textSecondaryLight,
        textTertiary: Color = Theme.Colors.textTertiary,
        textInputBackground: Color = Theme.Colors.textInputBackground,
        textInputStroke: Color = Theme.Colors.textInputStroke,
        textInputUnfocusedBackground: Color = Theme.Colors.textInputUnfocusedBackground,
        textInputUnfocusedStroke: Color = Theme.Colors.textInputUnfocusedStroke,
        warning: Color = Theme.Colors.warning,
        white: Color = Theme.Colors.white,
        onProgress: Color = Theme.Colors.onProgress,
        progressDone: Color = Theme.Colors.progressDone,
        progressSkip: Color = Theme.Colors.progressSkip,
        datesSectionBackground: Color = Theme.Colors.datesSectionBackground,
        datesSectionStroke: Color = Theme.Colors.datesSectionStroke,
        navigationBarTintColor: Color = Theme.Colors.navigationBarTintColor,
        secondaryButtonBorderColor: Color = Theme.Colors.secondaryButtonBorderColor,
        secondaryButtonTextColor: Color = Theme.Colors.secondaryButtonTextColor,
        success: Color = Theme.Colors.success,
        primaryButtonTextColor: Color = Theme.Colors.primaryButtonTextColor,
        toggleSwitchColor: Color = Theme.Colors.toggleSwitchColor,
        textInputTextColor: Color = Theme.Colors.textInputTextColor,
        textInputPlaceholderColor: Color = Theme.Colors.textInputPlaceholderColor,
        infoColor: Color = Theme.Colors.infoColor,
        irreversibleAlert: Color = Theme.Colors.irreversibleAlert,
        emptyStateIconColor: Color = Theme.Colors.emptyStateIconColor,
        secondaryContentColor: Color = Theme.Colors.secondaryContentColor
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
        self.textTertiary = textTertiary
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
        self.emptyStateIconColor = emptyStateIconColor
        self.secondaryContentColor = secondaryContentColor
    }

    /// Colors compiled into the base asset catalog (no tenant selected).
    public static let `default` = ThemeColorSet()

    /// Derives a tenant palette from its accent hex, then layers any per-field
    /// `THEME` overrides on top. Bespoke, fully hand-authored palettes can still be
    /// supplied directly via `ThemeDefinition`.
    public static func derived(
        fromHex hex: String,
        light: [String: String] = [:],
        dark: [String: String] = [:]
    ) -> ThemeColorSet {
        // Falls back to the compiled default accent if `hex` is invalid.
        let accent = Color(hex: hex) ?? ThemeColorSet.default.accentColor
        var set = ThemeColorSet.default
        set.accentColor = accent
        set.accentXColor = accent
        set.navigationBarTintColor = accent
        set.toggleSwitchColor = accent
        set.secondaryButtonBorderColor = accent
        set.secondaryButtonTextColor = accent
        set.infoColor = accent

        // Only fields the tenant actually set are overridden.
        for (jsonKey, keyPath) in ThemeColorSet.paletteKeyPaths {
            guard let lightHex = light[jsonKey] else { continue }
            let darkHex = dark[jsonKey] ?? lightHex
            if let dynamic = Color(lightHex: lightHex, darkHex: darkHex) {
                set[keyPath: keyPath] = dynamic
            }
        }
        return set
    }

    /// Maps a tenant JSON `THEME` field name to the `ThemeColorSet` property it overrides.
    private nonisolated(unsafe) static let paletteKeyPaths: [String: WritableKeyPath<ThemeColorSet, Color>] = [
        "accent_color": \.accentColor,
        "accent_x_color": \.accentXColor,
        "alert": \.alert,
        "avatar_stroke": \.avatarStroke,
        "background": \.background,
        "background_stroke": \.backgroundStroke,
        "card_view_background": \.cardViewBackground,
        "card_view_stroke": \.cardViewStroke,
        "certificate_foreground": \.certificateForeground,
        "comment_cell_background": \.commentCellBackground,
        "next_week_timeline_color": \.nextWeekTimelineColor,
        "past_due_timeline_color": \.pastDueTimelineColor,
        "this_week_timeline_color": \.thisWeekTimelineColor,
        "today_timeline_color": \.todayTimelineColor,
        "upcoming_timeline_color": \.upcomingTimelineColor,
        "shadow_color": \.shadowColor,
        "snackbar_error_color": \.snackbarErrorColor,
        "snackbar_info_color": \.snackbarInfoColor,
        "snackbar_text_color": \.snackbarTextColor,
        "styled_button_text": \.styledButtonText,
        "text_primary": \.textPrimary,
        "text_secondary": \.textSecondary,
        "text_secondary_light": \.textSecondaryLight,
        "text_tertiary": \.textTertiary,
        "text_input_background": \.textInputBackground,
        "text_input_stroke": \.textInputStroke,
        "text_input_unfocused_background": \.textInputUnfocusedBackground,
        "text_input_unfocused_stroke": \.textInputUnfocusedStroke,
        "warning": \.warning,
        "white": \.white,
        "on_progress": \.onProgress,
        "progress_done": \.progressDone,
        "progress_skip": \.progressSkip,
        "dates_section_background": \.datesSectionBackground,
        "dates_section_stroke": \.datesSectionStroke,
        "navigation_bar_tint_color": \.navigationBarTintColor,
        "secondary_button_border_color": \.secondaryButtonBorderColor,
        "secondary_button_text_color": \.secondaryButtonTextColor,
        "success": \.success,
        "primary_button_text_color": \.primaryButtonTextColor,
        "toggle_switch_color": \.toggleSwitchColor,
        "text_input_text_color": \.textInputTextColor,
        "text_input_placeholder_color": \.textInputPlaceholderColor,
        "info_color": \.infoColor,
        "irreversible_alert": \.irreversibleAlert,
        "empty_state_icon_color": \.emptyStateIconColor,
        "secondary_content_color": \.secondaryContentColor
    ]
}

extension Color {
    /// Parses "#RRGGBB" / "#RGB" hex strings.
    init?(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexString = hexString.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        guard Scanner(string: hexString).scanHexInt64(&rgb) else { return nil }

        let r, g, b: Double
        switch hexString.count {
        case 6:
            r = Double((rgb & 0xFF0000) >> 16) / 255
            g = Double((rgb & 0x00FF00) >> 8) / 255
            b = Double(rgb & 0x0000FF) / 255
        case 3:
            r = Double((rgb & 0xF00) >> 8) / 15
            g = Double((rgb & 0x0F0) >> 4) / 15
            b = Double(rgb & 0x00F) / 15
        default:
            return nil
        }
        self = Color(red: r, green: g, blue: b)
    }

    /// A `Color` that resolves to a different hex value in light vs. dark mode.
    init?(lightHex: String, darkHex: String) {
        guard let light = Color(hex: lightHex), let dark = Color(hex: darkHex) else { return nil }
        let lightUIColor = UIColor(light)
        let darkUIColor = UIColor(dark)
        self = Color(UIColor { $0.userInterfaceStyle == .dark ? darkUIColor : lightUIColor })
    }
}

//
//  ThemeColorSet.swift
//  Theme
//
//  Created by Rawan Matar on 12/05/2025.
//

import SwiftUI

public struct ThemeColorSet: Sendable {
    public  var accentColor = ThemeAssets.accentColor.swiftUIColor
    public  var accentXColor = ThemeAssets.accentXColor.swiftUIColor
    public  var accentButtonColor = ThemeAssets.accentButtonColor.swiftUIColor
    public  var alert = ThemeAssets.alert.swiftUIColor
    public  var avatarStroke = ThemeAssets.avatarStroke.swiftUIColor
    public  var background = ThemeAssets.background.swiftUIColor
    public  var loginBackground = ThemeAssets.loginBackground.swiftUIColor
    public  var backgroundStroke = ThemeAssets.backgroundStroke.swiftUIColor
    public  var cardViewBackground = ThemeAssets.cardViewBackground.swiftUIColor
    public  var cardViewStroke = ThemeAssets.cardViewStroke.swiftUIColor
    public  var certificateForeground = ThemeAssets.certificateForeground.swiftUIColor
    public  var commentCellBackground = ThemeAssets.commentCellBackground.swiftUIColor
    public  var nextWeekTimelineColor = ThemeAssets.nextWeekTimelineColor.swiftUIColor
    public  var pastDueTimelineColor = ThemeAssets.pastDueTimelineColor.swiftUIColor
    public  var thisWeekTimelineColor = ThemeAssets.thisWeekTimelineColor.swiftUIColor
    public  var todayTimelineColor = ThemeAssets.todayTimelineColor.swiftUIColor
    public  var upcomingTimelineColor = ThemeAssets.upcomingTimelineColor.swiftUIColor
    public  var shadowColor = ThemeAssets.shadowColor.swiftUIColor
    public  var snackbarErrorColor = ThemeAssets.snackbarErrorColor.swiftUIColor
    public  var snackbarWarningColor = ThemeAssets.snackbarWarningColor.swiftUIColor
    public  var snackbarInfoColor = ThemeAssets.snackbarInfoColor.swiftUIColor
    public  var snackbarTextColor = ThemeAssets.snackbarTextColor.swiftUIColor
    public  var styledButtonText = ThemeAssets.styledButtonText.swiftUIColor
    public  var textPrimary = ThemeAssets.textPrimary.swiftUIColor
    public  var textSecondary = ThemeAssets.textSecondary.swiftUIColor
    public  var textSecondaryLight = ThemeAssets.textSecondaryLight.swiftUIColor
    public  var textInputBackground = ThemeAssets.textInputBackground.swiftUIColor
    public  var textInputStroke = ThemeAssets.textInputStroke.swiftUIColor
    public  var textInputUnfocusedBackground = ThemeAssets.textInputUnfocusedBackground.swiftUIColor
    public  var textInputUnfocusedStroke = ThemeAssets.textInputUnfocusedStroke.swiftUIColor
    public  var warning = ThemeAssets.warning.swiftUIColor
    public  var warningText = ThemeAssets.warningText.swiftUIColor
    public  var white = ThemeAssets.white.swiftUIColor
    public  var onProgress = ThemeAssets.onProgress.swiftUIColor
    public  var progressDone = ThemeAssets.progressDone.swiftUIColor
    public  var progressSkip = ThemeAssets.progressSkip.swiftUIColor
    public  var progressSelectedAndDone = ThemeAssets.selectedAndDone.swiftUIColor
    public  var loginNavigationText = ThemeAssets.loginNavigationText.swiftUIColor
    public  var datesSectionBackground = ThemeAssets.datesSectionBackground.swiftUIColor
    public  var datesSectionStroke = ThemeAssets.datesSectionStroke.swiftUIColor
    public  var navigationBarTintColor = ThemeAssets.navigationBarTintColor.swiftUIColor
    public  var navigationBarColor = ThemeAssets.navigationBarColor.swiftUIColor
    public  var navigationBarColorDark = ThemeAssets.navigationBarColorDark.swiftUIColor
    public  var secondaryButtonBorderColor = ThemeAssets.secondaryButtonBorderColor.swiftUIColor
    public  var secondaryButtonTextColor = ThemeAssets.secondaryButtonTextColor.swiftUIColor
    public  var secondaryButtonBGColor = ThemeAssets.secondaryButtonBGColor.swiftUIColor
    public  var success = ThemeAssets.success.swiftUIColor
    public  var tabbarColor = ThemeAssets.tabbarColor.swiftUIColor
    public  var tabbarTintColor = ThemeAssets.tabbarTintColor.swiftUIColor
    public  var primaryButtonTextColor = ThemeAssets.primaryButtonTextColor.swiftUIColor
    public  var toggleSwitchColor = ThemeAssets.toggleSwitchColor.swiftUIColor
    public  var textInputTextColor = ThemeAssets.textInputTextColor.swiftUIColor
    public  var textInputPlaceholderColor = ThemeAssets.textInputPlaceholderColor.swiftUIColor
    public  var infoColor = ThemeAssets.infoColor.swiftUIColor
    public  var irreversibleAlert = ThemeAssets.irreversibleAlert.swiftUIColor
    public  var slidingTextColor = ThemeAssets.slidingTextColor.swiftUIColor
    public  var slidingSelectedTextColor = ThemeAssets.slidingSelectedTextColor.swiftUIColor
    public  var slidingStrokeColor = ThemeAssets.slidingStrokeColor.swiftUIColor
    public  var primaryHeaderColor = ThemeAssets.primaryHeaderColor.swiftUIColor
    public  var secondaryHeaderColor = ThemeAssets.secondaryHeaderColor.swiftUIColor
    public  var courseCardShadow = ThemeAssets.courseCardShadow.swiftUIColor
    public  var courseCardBackground = ThemeAssets.courseCardBackground.swiftUIColor
    public  var resumeButtonBG = ThemeAssets.resumeButtonBG.swiftUIColor
    public  var resumeButtonText = ThemeAssets.resumeButtonText.swiftUIColor
    public  var primaryCardCautionBG = ThemeAssets.primaryCardCautionBG.swiftUIColor
    public  var primaryCardProgressBG = ThemeAssets.primaryCardProgressBG.swiftUIColor
    public  var courseProgressBG = ThemeAssets.courseProgressBG.swiftUIColor
    public  var deleteAccountBG = ThemeAssets.deleteAccountBG.swiftUIColor
    
    public static let `default` = ThemeColorSet(
        accentColor: ThemeAssets.accentColor.swiftUIColor,
        accentXColor: ThemeAssets.accentXColor.swiftUIColor,
        accentButtonColor: ThemeAssets.accentButtonColor.swiftUIColor,
        alert: ThemeAssets.alert.swiftUIColor,
        avatarStroke: ThemeAssets.avatarStroke.swiftUIColor,
        background: ThemeAssets.background.swiftUIColor,
        backgroundStroke: ThemeAssets.backgroundStroke.swiftUIColor,
        cardViewBackground: ThemeAssets.cardViewStroke.swiftUIColor,
        cardViewStroke: ThemeAssets.cardViewStroke.swiftUIColor,
        certificateForeground: ThemeAssets.certificateForeground.swiftUIColor,
        commentCellBackground: ThemeAssets.commentCellBackground.swiftUIColor,
        nextWeekTimelineColor: ThemeAssets.nextWeekTimelineColor.swiftUIColor,
        pastDueTimelineColor: ThemeAssets.pastDueTimelineColor.swiftUIColor,
        thisWeekTimelineColor: ThemeAssets.thisWeekTimelineColor.swiftUIColor,
        todayTimelineColor: ThemeAssets.todayTimelineColor.swiftUIColor,
        upcomingTimelineColor: ThemeAssets.upcomingTimelineColor.swiftUIColor,
        shadowColor: ThemeAssets.shadowColor.swiftUIColor,
        snackbarErrorColor: ThemeAssets.snackbarErrorColor.swiftUIColor,
        snackbarInfoColor: ThemeAssets.snackbarInfoColor.swiftUIColor,
        snackbarTextColor: ThemeAssets.snackbarTextColor.swiftUIColor,
        styledButtonText: ThemeAssets.styledButtonText.swiftUIColor,
        textPrimary: ThemeAssets.textPrimary.swiftUIColor,
        textSecondary: ThemeAssets.textSecondary.swiftUIColor,
        textSecondaryLight: ThemeAssets.textSecondaryLight.swiftUIColor,
        textInputBackground: ThemeAssets.textInputBackground.swiftUIColor,
        textInputStroke: ThemeAssets.textInputStroke.swiftUIColor,
        textInputUnfocusedBackground: ThemeAssets.textInputUnfocusedBackground.swiftUIColor,
        textInputUnfocusedStroke: ThemeAssets.textInputUnfocusedStroke.swiftUIColor,
        warning: ThemeAssets.warning.swiftUIColor,
        white: ThemeAssets.white.swiftUIColor,
        onProgress: ThemeAssets.onProgress.swiftUIColor,
        progressDone: ThemeAssets.progressDone.swiftUIColor,
        progressSkip: ThemeAssets.progressSkip.swiftUIColor,
        datesSectionBackground: ThemeAssets.datesSectionBackground.swiftUIColor,
        datesSectionStroke: ThemeAssets.datesSectionStroke.swiftUIColor,
        navigationBarTintColor: ThemeAssets.navigationBarTintColor.swiftUIColor,
        navigationBarColor: ThemeAssets.navigationBarColor.swiftUIColor,
        navigationBarColorDark: ThemeAssets.navigationBarColorDark.swiftUIColor,
        
        secondaryButtonBorderColor: ThemeAssets.secondaryButtonBorderColor.swiftUIColor,
        secondaryButtonTextColor: ThemeAssets.secondaryButtonTextColor.swiftUIColor,
        success: ThemeAssets.success.swiftUIColor,
        tabbarColor: ThemeAssets.tabbarColor.swiftUIColor,
        tabbarTintColor: ThemeAssets.tenantATabBarTintColor.swiftUIColor,
        primaryButtonTextColor: ThemeAssets.primaryButtonTextColor.swiftUIColor,
        toggleSwitchColor: ThemeAssets.toggleSwitchColor.swiftUIColor,
        textInputTextColor: ThemeAssets.textInputTextColor.swiftUIColor,
        textInputPlaceholderColor: ThemeAssets.textInputPlaceholderColor.swiftUIColor,
        infoColor: ThemeAssets.infoColor.swiftUIColor,
        irreversibleAlert: ThemeAssets.irreversibleAlert.swiftUIColor,
        resumeButtonBG: ThemeAssets.resumeButtonBG.swiftUIColor,
        resumeButtonText: ThemeAssets.resumeButtonText.swiftUIColor,
        primaryCardCautionBG: ThemeAssets.primaryCardCautionBG.swiftUIColor,
        primaryCardProgressBG: ThemeAssets.primaryCardProgressBG.swiftUIColor,
        courseProgressBG: ThemeAssets.courseProgressBG.swiftUIColor,
        deleteAccountBG: ThemeAssets.deleteAccountBG.swiftUIColor
    )
    
    public static let tenantA = ThemeColorSet(
        accentColor: ThemeAssets.tenantAAccentColor.swiftUIColor,
        accentXColor: ThemeAssets.tenantAAccentXColor.swiftUIColor,
        accentButtonColor: ThemeAssets.tenantAAccentButtonColor.swiftUIColor,
        alert: ThemeAssets.tenantAAlert.swiftUIColor,
        avatarStroke: ThemeAssets.tenantAAvatarStroke.swiftUIColor,
        background: ThemeAssets.tenantABackground.swiftUIColor,
        backgroundStroke: ThemeAssets.tenantABackgroundStroke.swiftUIColor,
        cardViewBackground: ThemeAssets.tenantACardViewStroke.swiftUIColor,
        cardViewStroke: ThemeAssets.tenantACardViewStroke.swiftUIColor,
        certificateForeground: ThemeAssets.tenantACertificateForeground.swiftUIColor,
        commentCellBackground: ThemeAssets.tenantACommentCellBackground.swiftUIColor,
        nextWeekTimelineColor: ThemeAssets.tenantANextWeekTimelineColor.swiftUIColor,
        pastDueTimelineColor: ThemeAssets.tenantApastDueTimelineColor.swiftUIColor,
        thisWeekTimelineColor: ThemeAssets.tenantAThisWeekTimelineColor.swiftUIColor,
        todayTimelineColor: ThemeAssets.tenantATodayTimelineColor.swiftUIColor,
        upcomingTimelineColor: ThemeAssets.tenantAUpcomingTimelineColor.swiftUIColor,
        shadowColor: ThemeAssets.tenantAShadowColor.swiftUIColor,
        snackbarErrorColor: ThemeAssets.tenantASnackbarErrorColor.swiftUIColor,
        snackbarInfoColor: ThemeAssets.tenantASnackbarInfoColor.swiftUIColor,
        snackbarTextColor: ThemeAssets.tenantASnackbarTextColor.swiftUIColor,
        styledButtonText: ThemeAssets.tenantAStyledButtonText.swiftUIColor,
        textPrimary: ThemeAssets.tenantATextPrimary.swiftUIColor,
        textSecondary: ThemeAssets.tenantATextSecondary.swiftUIColor,
        textSecondaryLight: ThemeAssets.tenantATextSecondaryLight.swiftUIColor,
        textInputBackground: ThemeAssets.tenantATextInputBackground.swiftUIColor,
        textInputStroke: ThemeAssets.tenantATextInputStroke.swiftUIColor,
        textInputUnfocusedBackground: ThemeAssets.tenantATextInputUnfocusedBackground.swiftUIColor,
        textInputUnfocusedStroke: ThemeAssets.tenantATextInputUnfocusedStroke.swiftUIColor,
        warning: ThemeAssets.tenantAWarning.swiftUIColor,
        white: ThemeAssets.tenantAWhite.swiftUIColor,
        onProgress: ThemeAssets.tenantAOnProgress.swiftUIColor,
        progressDone: ThemeAssets.tenantAProgressDone.swiftUIColor,
        progressSkip: ThemeAssets.tenantAProgressSkip.swiftUIColor,
        loginNavigationText: ThemeAssets.tenantALoginNavigationText.swiftUIColor,
        datesSectionBackground: ThemeAssets.tenantADatesSectionBackground.swiftUIColor,
        datesSectionStroke: ThemeAssets.tenantADatesSectionStroke.swiftUIColor,
        navigationBarTintColor: ThemeAssets.tenantAnavigationBarTintColor.swiftUIColor,
        navigationBarColor: ThemeAssets.tenantAnavigationBarColor.swiftUIColor,
        navigationBarColorDark: ThemeAssets.tenantAnavigationBarColorDark.swiftUIColor,
        secondaryButtonBorderColor: ThemeAssets.tenantASecondaryButtonBorderColor.swiftUIColor,
        secondaryButtonTextColor: ThemeAssets.tenantASecondaryButtonTextColor.swiftUIColor,
        success: ThemeAssets.tenantASuccess.swiftUIColor,
        tabbarColor: ThemeAssets.tenantATabbarColor.swiftUIColor,
        tabbarTintColor: ThemeAssets.tenantATabBarTintColor.swiftUIColor,
        primaryButtonTextColor: ThemeAssets.tenantAPrimaryButtonTextColor.swiftUIColor,
        toggleSwitchColor: ThemeAssets.tenantAToggleSwitchColor.swiftUIColor,
        textInputTextColor: ThemeAssets.tenantATextInputTextColor.swiftUIColor,
        textInputPlaceholderColor: ThemeAssets.tenantATextInputPlaceholderColor.swiftUIColor,
        infoColor: ThemeAssets.tenantAInfoColor.swiftUIColor,
        irreversibleAlert: ThemeAssets.tenantAIrreversibleAlert.swiftUIColor,
        resumeButtonBG: ThemeAssets.resumeButtonBG.swiftUIColor,
        resumeButtonText: ThemeAssets.resumeButtonText.swiftUIColor,
        primaryCardCautionBG: ThemeAssets.tenantAPrimaryCardCautionBG.swiftUIColor,
        primaryCardProgressBG: ThemeAssets.primaryCardProgressBG.swiftUIColor,
        courseProgressBG: ThemeAssets.courseProgressBG.swiftUIColor,
        deleteAccountBG: ThemeAssets.deleteAccountBG.swiftUIColor
    )
    
    public static let tenantB = ThemeColorSet(
        accentColor: ThemeAssets.tenantBAccentColor.swiftUIColor,
        accentXColor: ThemeAssets.tenantBAccentXColor.swiftUIColor,
        accentButtonColor: ThemeAssets.tenantBAccentButtonColor.swiftUIColor,
        alert: ThemeAssets.tenantBAlert.swiftUIColor,
        avatarStroke: ThemeAssets.tenantBAvatarStroke.swiftUIColor,
        background: ThemeAssets.tenantBBackground.swiftUIColor,
        backgroundStroke: ThemeAssets.tenantBBackgroundStroke.swiftUIColor,
        cardViewBackground: ThemeAssets.tenantBCardViewStroke.swiftUIColor,
        cardViewStroke: ThemeAssets.tenantBCardViewStroke.swiftUIColor,
        certificateForeground: ThemeAssets.tenantBCertificateForeground.swiftUIColor,
        commentCellBackground: ThemeAssets.tenantBCommentCellBackground.swiftUIColor,
        nextWeekTimelineColor: ThemeAssets.tenantBNextWeekTimelineColor.swiftUIColor,
        pastDueTimelineColor: ThemeAssets.tenantBpastDueTimelineColor.swiftUIColor,
        thisWeekTimelineColor: ThemeAssets.tenantBThisWeekTimelineColor.swiftUIColor,
        todayTimelineColor: ThemeAssets.tenantBTodayTimelineColor.swiftUIColor,
        upcomingTimelineColor: ThemeAssets.tenantBUpcomingTimelineColor.swiftUIColor,
        shadowColor: ThemeAssets.tenantBShadowColor.swiftUIColor,
        snackbarErrorColor: ThemeAssets.tenantBSnackbarErrorColor.swiftUIColor,
        snackbarInfoColor: ThemeAssets.tenantBSnackbarInfoColor.swiftUIColor,
        snackbarTextColor: ThemeAssets.tenantBSnackbarTextColor.swiftUIColor,
        styledButtonText: ThemeAssets.tenantBStyledButtonText.swiftUIColor,
        textPrimary: ThemeAssets.tenantBTextPrimary.swiftUIColor,
        textSecondary: ThemeAssets.tenantBTextSecondary.swiftUIColor,
        textSecondaryLight: ThemeAssets.tenantBTextSecondaryLight.swiftUIColor,
        textInputBackground: ThemeAssets.tenantBTextInputBackground.swiftUIColor,
        textInputStroke: ThemeAssets.tenantBTextInputStroke.swiftUIColor,
        textInputUnfocusedBackground: ThemeAssets.tenantBTextInputUnfocusedBackground.swiftUIColor,
        textInputUnfocusedStroke: ThemeAssets.tenantBTextInputUnfocusedStroke.swiftUIColor,
        warning: ThemeAssets.tenantBWarning.swiftUIColor,
        white: ThemeAssets.tenantBWhite.swiftUIColor,
        onProgress: ThemeAssets.tenantBOnProgress.swiftUIColor,
        progressDone: ThemeAssets.tenantBProgressDone.swiftUIColor,
        progressSkip: ThemeAssets.tenantBProgressSkip.swiftUIColor,
        loginNavigationText: ThemeAssets.tenantBLoginNavigationText.swiftUIColor,
        datesSectionBackground: ThemeAssets.tenantBDatesSectionBackground.swiftUIColor,
        datesSectionStroke: ThemeAssets.tenantBDatesSectionStroke.swiftUIColor,
        navigationBarTintColor: ThemeAssets.tenantBnavigationBarTintColor.swiftUIColor,
        navigationBarColor: ThemeAssets.tenantBnavigationBarColor.swiftUIColor,
        navigationBarColorDark: ThemeAssets.tenantBnavigationBarColorDark.swiftUIColor,
        secondaryButtonBorderColor: ThemeAssets.tenantBSecondaryButtonBorderColor.swiftUIColor,
        secondaryButtonTextColor: ThemeAssets.tenantBSecondaryButtonTextColor.swiftUIColor,
        success: ThemeAssets.tenantBSuccess.swiftUIColor,
        tabbarColor: ThemeAssets.tenantBTabbarColor.swiftUIColor,
        tabbarTintColor: ThemeAssets.tenantBTabBarTintColor.swiftUIColor,
        primaryButtonTextColor: ThemeAssets.tenantBPrimaryButtonTextColor.swiftUIColor,
        toggleSwitchColor: ThemeAssets.tenantBToggleSwitchColor.swiftUIColor,
        textInputTextColor: ThemeAssets.tenantBTextInputTextColor.swiftUIColor,
        textInputPlaceholderColor: ThemeAssets.tenantBTextInputPlaceholderColor.swiftUIColor,
        infoColor: ThemeAssets.tenantBInfoColor.swiftUIColor,
        irreversibleAlert: ThemeAssets.tenantBIrreversibleAlert.swiftUIColor,
        resumeButtonBG: ThemeAssets.resumeButtonBG.swiftUIColor,
        resumeButtonText: ThemeAssets.resumeButtonText.swiftUIColor,
        primaryCardCautionBG: ThemeAssets.tenantBPrimaryCardCautionBG.swiftUIColor,
        primaryCardProgressBG: ThemeAssets.primaryCardProgressBG.swiftUIColor,
        courseProgressBG: ThemeAssets.courseProgressBG.swiftUIColor,
        deleteAccountBG: ThemeAssets.deleteAccountBG.swiftUIColor
    )
}

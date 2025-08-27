//
//  ThemeColorSet.swift
//  Theme
//
//  Created by Rawan Matar on 12/05/2025.
//


import SwiftUI

public struct ThemeColorSet {
    
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
    public  var tabbarTintColor = ThemeAssets.tabBarTintColor.swiftUIColor
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
        tabbarTintColor: ThemeAssets.tabBarTintColor.swiftUIColor,
        primaryButtonTextColor: ThemeAssets.primaryButtonTextColor.swiftUIColor,
        toggleSwitchColor: ThemeAssets.toggleSwitchColor.swiftUIColor,
        textInputTextColor: ThemeAssets.textInputTextColor.swiftUIColor,
        textInputPlaceholderColor: ThemeAssets.textInputPlaceholderColor.swiftUIColor,
        infoColor: ThemeAssets.infoColor.swiftUIColor,
        irreversibleAlert: ThemeAssets.irreversibleAlert.swiftUIColor,
    )
    
    public static let saudiRealEstateInstitute = ThemeColorSet(
        accentColor: ThemeAssets.saudiRealEstateInstituteAccentColor.swiftUIColor,
        accentXColor: ThemeAssets.saudiRealEstateInstituteAccentXColor.swiftUIColor,
        accentButtonColor: ThemeAssets.saudiRealEstateInstituteAccentButtonColor.swiftUIColor,
        alert: ThemeAssets.saudiRealEstateInstituteAlert.swiftUIColor,
        avatarStroke: ThemeAssets.saudiRealEstateInstituteAvatarStroke.swiftUIColor,
        background: ThemeAssets.saudiRealEstateInstituteBackground.swiftUIColor,
        backgroundStroke: ThemeAssets.saudiRealEstateInstituteBackgroundStroke.swiftUIColor,
        cardViewBackground: ThemeAssets.saudiRealEstateInstituteCardViewStroke.swiftUIColor,
        cardViewStroke: ThemeAssets.saudiRealEstateInstituteCardViewStroke.swiftUIColor,
        certificateForeground: ThemeAssets.saudiRealEstateInstituteCertificateForeground.swiftUIColor,
        commentCellBackground: ThemeAssets.saudiRealEstateInstituteCommentCellBackground.swiftUIColor,
        nextWeekTimelineColor: ThemeAssets.saudiRealEstateInstituteNextWeekTimelineColor.swiftUIColor,
        pastDueTimelineColor: ThemeAssets.saudiRealEstateInstitutepastDueTimelineColor.swiftUIColor,
        thisWeekTimelineColor: ThemeAssets.saudiRealEstateInstituteThisWeekTimelineColor.swiftUIColor,
        todayTimelineColor: ThemeAssets.saudiRealEstateInstituteTodayTimelineColor.swiftUIColor,
        upcomingTimelineColor: ThemeAssets.saudiRealEstateInstituteUpcomingTimelineColor.swiftUIColor,
        shadowColor: ThemeAssets.saudiRealEstateInstituteShadowColor.swiftUIColor,
        snackbarErrorColor: ThemeAssets.saudiRealEstateInstituteSnackbarErrorColor.swiftUIColor,
        snackbarInfoColor: ThemeAssets.saudiRealEstateInstituteSnackbarInfoColor.swiftUIColor,
        snackbarTextColor: ThemeAssets.saudiRealEstateInstituteSnackbarTextColor.swiftUIColor,
        styledButtonText: ThemeAssets.saudiRealEstateInstituteStyledButtonText.swiftUIColor,
        textPrimary: ThemeAssets.saudiRealEstateInstituteTextPrimary.swiftUIColor,
        textSecondary: ThemeAssets.saudiRealEstateInstituteTextSecondary.swiftUIColor,
        textSecondaryLight: ThemeAssets.saudiRealEstateInstituteTextSecondaryLight.swiftUIColor,
        textInputBackground: ThemeAssets.saudiRealEstateInstituteTextInputBackground.swiftUIColor,
        textInputStroke: ThemeAssets.saudiRealEstateInstituteTextInputStroke.swiftUIColor,
        textInputUnfocusedBackground: ThemeAssets.saudiRealEstateInstituteTextInputUnfocusedBackground.swiftUIColor,
        textInputUnfocusedStroke: ThemeAssets.saudiRealEstateInstituteTextInputUnfocusedStroke.swiftUIColor,
        warning: ThemeAssets.saudiRealEstateInstituteWarning.swiftUIColor,
        white: ThemeAssets.saudiRealEstateInstituteWhite.swiftUIColor,
        onProgress: ThemeAssets.saudiRealEstateInstituteOnProgress.swiftUIColor,
        progressDone: ThemeAssets.saudiRealEstateInstituteProgressDone.swiftUIColor,
        progressSkip: ThemeAssets.saudiRealEstateInstituteProgressSkip.swiftUIColor,
        loginNavigationText: ThemeAssets.saudiRealEstateInstituteLoginNavigationText.swiftUIColor,
        datesSectionBackground: ThemeAssets.saudiRealEstateInstituteDatesSectionBackground.swiftUIColor,
        datesSectionStroke: ThemeAssets.saudiRealEstateInstituteDatesSectionStroke.swiftUIColor,
        navigationBarTintColor: ThemeAssets.saudiRealEstateInstitutenavigationBarTintColor.swiftUIColor,
        navigationBarColor: ThemeAssets.saudiRealEstateInstitutenavigationBarColor.swiftUIColor,
        navigationBarColorDark: ThemeAssets.saudiRealEstateInstitutenavigationBarColorDark.swiftUIColor,
        secondaryButtonBorderColor: ThemeAssets.saudiRealEstateInstituteSecondaryButtonBorderColor.swiftUIColor,
        secondaryButtonTextColor: ThemeAssets.saudiRealEstateInstituteSecondaryButtonTextColor.swiftUIColor,
        success: ThemeAssets.saudiRealEstateInstituteSuccess.swiftUIColor,
        tabbarColor: ThemeAssets.saudiRealEstateInstituteTabbarColor.swiftUIColor,
        tabbarTintColor: ThemeAssets.saudiRealEstateInstituteTabBarTintColor.swiftUIColor,
        primaryButtonTextColor: ThemeAssets.saudiRealEstateInstitutePrimaryButtonTextColor.swiftUIColor,
        toggleSwitchColor: ThemeAssets.saudiRealEstateInstituteToggleSwitchColor.swiftUIColor,
        textInputTextColor: ThemeAssets.saudiRealEstateInstituteTextInputTextColor.swiftUIColor,
        textInputPlaceholderColor: ThemeAssets.saudiRealEstateInstituteTextInputPlaceholderColor.swiftUIColor,
        infoColor: ThemeAssets.saudiRealEstateInstituteInfoColor.swiftUIColor,
        irreversibleAlert: ThemeAssets.saudiRealEstateInstituteIrreversibleAlert.swiftUIColor,
    )
    
    public static let NIEPD = ThemeColorSet(
        accentColor: ThemeAssets.niepdAccentColor.swiftUIColor,
        accentXColor: ThemeAssets.niepdAccentXColor.swiftUIColor,
        accentButtonColor: ThemeAssets.niepdAccentButtonColor.swiftUIColor,
        alert: ThemeAssets.niepdAlert.swiftUIColor,
        avatarStroke: ThemeAssets.niepdAvatarStroke.swiftUIColor,
        background: ThemeAssets.niepdBackground.swiftUIColor,
        backgroundStroke: ThemeAssets.niepdBackgroundStroke.swiftUIColor,
        cardViewBackground: ThemeAssets.niepdCardViewStroke.swiftUIColor,
        cardViewStroke: ThemeAssets.niepdCardViewStroke.swiftUIColor,
        certificateForeground: ThemeAssets.niepdCertificateForeground.swiftUIColor,
        commentCellBackground: ThemeAssets.niepdCommentCellBackground.swiftUIColor,
        nextWeekTimelineColor: ThemeAssets.niepdNextWeekTimelineColor.swiftUIColor,
        pastDueTimelineColor: ThemeAssets.niepDpastDueTimelineColor.swiftUIColor,
        thisWeekTimelineColor: ThemeAssets.niepdThisWeekTimelineColor.swiftUIColor,
        todayTimelineColor: ThemeAssets.niepdTodayTimelineColor.swiftUIColor,
        upcomingTimelineColor: ThemeAssets.niepdUpcomingTimelineColor.swiftUIColor,
        shadowColor: ThemeAssets.niepdShadowColor.swiftUIColor,
        snackbarErrorColor: ThemeAssets.niepdSnackbarErrorColor.swiftUIColor,
        snackbarInfoColor: ThemeAssets.niepdSnackbarInfoColor.swiftUIColor,
        snackbarTextColor: ThemeAssets.niepdSnackbarTextColor.swiftUIColor,
        styledButtonText: ThemeAssets.niepdStyledButtonText.swiftUIColor,
        textPrimary: ThemeAssets.niepdTextPrimary.swiftUIColor,
        textSecondary: ThemeAssets.niepdTextSecondary.swiftUIColor,
        textSecondaryLight: ThemeAssets.niepdTextSecondaryLight.swiftUIColor,
        textInputBackground: ThemeAssets.niepdTextInputBackground.swiftUIColor,
        textInputStroke: ThemeAssets.niepdTextInputStroke.swiftUIColor,
        textInputUnfocusedBackground: ThemeAssets.niepdTextInputUnfocusedBackground.swiftUIColor,
        textInputUnfocusedStroke: ThemeAssets.niepdTextInputUnfocusedStroke.swiftUIColor,
        warning: ThemeAssets.niepdWarning.swiftUIColor,
        white: ThemeAssets.niepdWhite.swiftUIColor,
        onProgress: ThemeAssets.niepdOnProgress.swiftUIColor,
        progressDone: ThemeAssets.niepdProgressDone.swiftUIColor,
        progressSkip: ThemeAssets.niepdProgressSkip.swiftUIColor,
        loginNavigationText: ThemeAssets.niepdLoginNavigationText.swiftUIColor,
        datesSectionBackground: ThemeAssets.niepdDatesSectionBackground.swiftUIColor,
        datesSectionStroke: ThemeAssets.niepdDatesSectionStroke.swiftUIColor,
        navigationBarTintColor: ThemeAssets.niepdNavigationBarTintColor.swiftUIColor,
        navigationBarColor: ThemeAssets.niepdNavigationBarColor.swiftUIColor,
        navigationBarColorDark: ThemeAssets.niepdNavigationBarColorDark.swiftUIColor,
        secondaryButtonBorderColor: ThemeAssets.niepdSecondaryButtonBorderColor.swiftUIColor,
        secondaryButtonTextColor: ThemeAssets.niepdSecondaryButtonTextColor.swiftUIColor,
        success: ThemeAssets.niepdSuccess.swiftUIColor,
        tabbarColor: ThemeAssets.niepdTabbarColor.swiftUIColor,
        tabbarTintColor: ThemeAssets.niepdTabBarTintColor.swiftUIColor,
        primaryButtonTextColor: ThemeAssets.niepdPrimaryButtonTextColor.swiftUIColor,
        toggleSwitchColor: ThemeAssets.niepdToggleSwitchColor.swiftUIColor,
        textInputTextColor: ThemeAssets.niepdTextInputTextColor.swiftUIColor,
        textInputPlaceholderColor: ThemeAssets.niepdTextInputPlaceholderColor.swiftUIColor,
        infoColor: ThemeAssets.niepdInfoColor.swiftUIColor,
        irreversibleAlert: ThemeAssets.niepdIrreversibleAlert.swiftUIColor,
    )
    
    public static let mt = ThemeColorSet(
        accentColor: ThemeAssets.mtAccentColor.swiftUIColor,
        accentXColor: ThemeAssets.mtAccentXColor.swiftUIColor,
        accentButtonColor: ThemeAssets.mtAccentButtonColor.swiftUIColor,
        alert: ThemeAssets.mtAlert.swiftUIColor,
        avatarStroke: ThemeAssets.mtAvatarStroke.swiftUIColor,
        background: ThemeAssets.mtBackground.swiftUIColor,
        backgroundStroke: ThemeAssets.mtBackgroundStroke.swiftUIColor,
        cardViewBackground: ThemeAssets.mtCardViewStroke.swiftUIColor,
        cardViewStroke: ThemeAssets.mtCardViewStroke.swiftUIColor,
        certificateForeground: ThemeAssets.mtCertificateForeground.swiftUIColor,
        commentCellBackground: ThemeAssets.mtCommentCellBackground.swiftUIColor,
        nextWeekTimelineColor: ThemeAssets.mtNextWeekTimelineColor.swiftUIColor,
        pastDueTimelineColor: ThemeAssets.mTpastDueTimelineColor.swiftUIColor,
        thisWeekTimelineColor: ThemeAssets.mtThisWeekTimelineColor.swiftUIColor,
        todayTimelineColor: ThemeAssets.mtTodayTimelineColor.swiftUIColor,
        upcomingTimelineColor: ThemeAssets.mtUpcomingTimelineColor.swiftUIColor,
        shadowColor: ThemeAssets.mtShadowColor.swiftUIColor,
        snackbarErrorColor: ThemeAssets.mtSnackbarErrorColor.swiftUIColor,
        snackbarInfoColor: ThemeAssets.mtSnackbarInfoColor.swiftUIColor,
        snackbarTextColor: ThemeAssets.mtSnackbarTextColor.swiftUIColor,
        styledButtonText: ThemeAssets.mtStyledButtonText.swiftUIColor,
        textPrimary: ThemeAssets.mtTextPrimary.swiftUIColor,
        textSecondary: ThemeAssets.mtTextSecondary.swiftUIColor,
        textSecondaryLight: ThemeAssets.mtTextSecondaryLight.swiftUIColor,
        textInputBackground: ThemeAssets.mtTextInputBackground.swiftUIColor,
        textInputStroke: ThemeAssets.mtTextInputStroke.swiftUIColor,
        textInputUnfocusedBackground: ThemeAssets.mtTextInputUnfocusedBackground.swiftUIColor,
        textInputUnfocusedStroke: ThemeAssets.mtTextInputUnfocusedStroke.swiftUIColor,
        warning: ThemeAssets.mtWarning.swiftUIColor,
        white: ThemeAssets.mtWhite.swiftUIColor,
        onProgress: ThemeAssets.mtOnProgress.swiftUIColor,
        progressDone: ThemeAssets.mtProgressDone.swiftUIColor,
        progressSkip: ThemeAssets.mtProgressSkip.swiftUIColor,
        loginNavigationText: ThemeAssets.mtLoginNavigationText.swiftUIColor,
        datesSectionBackground: ThemeAssets.mtDatesSectionBackground.swiftUIColor,
        datesSectionStroke: ThemeAssets.mtDatesSectionStroke.swiftUIColor,
        navigationBarTintColor: ThemeAssets.mTnavigationBarTintColor.swiftUIColor,
        navigationBarColor: ThemeAssets.mTnavigationBarColor.swiftUIColor,
        navigationBarColorDark: ThemeAssets.mTnavigationBarColorDark.swiftUIColor,
        secondaryButtonBorderColor: ThemeAssets.mtSecondaryButtonBorderColor.swiftUIColor,
        secondaryButtonTextColor: ThemeAssets.mtSecondaryButtonTextColor.swiftUIColor,
        success: ThemeAssets.mtSuccess.swiftUIColor,
        tabbarColor: ThemeAssets.mtTabbarColor.swiftUIColor,
        tabbarTintColor: ThemeAssets.mtTabBarTintColor.swiftUIColor,
        primaryButtonTextColor: ThemeAssets.mtPrimaryButtonTextColor.swiftUIColor,
        toggleSwitchColor: ThemeAssets.mtToggleSwitchColor.swiftUIColor,
        textInputTextColor: ThemeAssets.mtTextInputTextColor.swiftUIColor,
        textInputPlaceholderColor: ThemeAssets.mtTextInputPlaceholderColor.swiftUIColor,
        infoColor: ThemeAssets.mtInfoColor.swiftUIColor,
        irreversibleAlert: ThemeAssets.mtIrreversibleAlert.swiftUIColor,
    )
}

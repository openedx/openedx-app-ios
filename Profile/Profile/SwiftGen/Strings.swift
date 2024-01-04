// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum ProfileLocalization {
  /// Bio:
  public static let bio = ProfileLocalization.tr("Localizable", "BIO", fallback: "Bio:")
  /// Contact support
  public static let contact = ProfileLocalization.tr("Localizable", "CONTACT", fallback: "Contact support")
  /// Edit profile
  public static let editProfile = ProfileLocalization.tr("Localizable", "EDIT_PROFILE", fallback: "Edit profile")
  /// full profile
  public static let fullProfile = ProfileLocalization.tr("Localizable", "FULL_PROFILE", fallback: "full profile")
  /// Profile info
  public static let info = ProfileLocalization.tr("Localizable", "INFO", fallback: "Profile info")
  /// limited profile
  public static let limitedProfile = ProfileLocalization.tr("Localizable", "LIMITED_PROFILE", fallback: "limited profile")
  /// Log out
  public static let logout = ProfileLocalization.tr("Localizable", "LOGOUT", fallback: "Log out")
  /// Privacy and policy
  public static let privacy = ProfileLocalization.tr("Localizable", "PRIVACY", fallback: "Privacy and policy")
  /// Settings
  public static let settings = ProfileLocalization.tr("Localizable", "SETTINGS", fallback: "Settings")
  /// Video settings
  public static let settingsVideo = ProfileLocalization.tr("Localizable", "SETTINGS_VIDEO", fallback: "Video settings")
  /// Support info
  public static let supportInfo = ProfileLocalization.tr("Localizable", "SUPPORT_INFO", fallback: "Support info")
  /// Switch to
  public static let switchTo = ProfileLocalization.tr("Localizable", "SWITCH_TO", fallback: "Switch to")
  /// Terms of use
  public static let terms = ProfileLocalization.tr("Localizable", "TERMS", fallback: "Terms of use")
  /// Localizable.strings
  ///   Profile
  /// 
  ///   Created by  Stepanok Ivan on 23.09.2022.
  public static let title = ProfileLocalization.tr("Localizable", "TITLE", fallback: "Profile")
  /// Year of birth:
  public static let yearOfBirth = ProfileLocalization.tr("Localizable", "YEAR_OF_BIRTH", fallback: "Year of birth:")
  public enum DeleteAccount {
    /// Are you sure you want to 
    public static let areYouSure = ProfileLocalization.tr("Localizable", "DELETE_ACCOUNT.ARE_YOU_SURE", fallback: "Are you sure you want to ")
    /// Back to profile
    public static let backToProfile = ProfileLocalization.tr("Localizable", "DELETE_ACCOUNT.BACK_TO_PROFILE", fallback: "Back to profile")
    /// Yes, delete account
    public static let comfirm = ProfileLocalization.tr("Localizable", "DELETE_ACCOUNT.COMFIRM", fallback: "Yes, delete account")
    /// To confirm this action you need to enter your account password.
    public static let description = ProfileLocalization.tr("Localizable", "DELETE_ACCOUNT.DESCRIPTION", fallback: "To confirm this action you need to enter your account password.")
    /// The password is incorrect. Please try again.
    public static let incorrectPassword = ProfileLocalization.tr("Localizable", "DELETE_ACCOUNT.INCORRECT_PASSWORD", fallback: "The password is incorrect. Please try again.")
    /// Password
    public static let password = ProfileLocalization.tr("Localizable", "DELETE_ACCOUNT.PASSWORD", fallback: "Password")
    /// Enter password
    public static let passwordDescription = ProfileLocalization.tr("Localizable", "DELETE_ACCOUNT.PASSWORD_DESCRIPTION", fallback: "Enter password")
    /// Delete account
    public static let title = ProfileLocalization.tr("Localizable", "DELETE_ACCOUNT.TITLE", fallback: "Delete account")
    /// delete your account?
    public static let wantToDelete = ProfileLocalization.tr("Localizable", "DELETE_ACCOUNT.WANT_TO_DELETE", fallback: "delete your account?")
  }
  public enum DeleteAlert {
    /// Do you really want to delete your account?
    public static let text = ProfileLocalization.tr("Localizable", "DELETE_ALERT.TEXT", fallback: "Do you really want to delete your account?")
    /// Warning!
    public static let title = ProfileLocalization.tr("Localizable", "DELETE_ALERT.TITLE", fallback: "Warning!")
  }
  public enum Edit {
    /// Delete account
    public static let deleteAccount = ProfileLocalization.tr("Localizable", "EDIT.DELETE_ACCOUNT", fallback: "Delete account")
    /// A limited profile only shares your username and profile photo.
    public static let limitedProfileDescription = ProfileLocalization.tr("Localizable", "EDIT.LIMITED_PROFILE_DESCRIPTION", fallback: "A limited profile only shares your username and profile photo.")
    /// You must be over 13 years old to have a profile with full access to information.
    public static let tooYongUser = ProfileLocalization.tr("Localizable", "EDIT.TOO_YONG_USER", fallback: "You must be over 13 years old to have a profile with full access to information.")
    public enum BottomSheet {
      /// Cancel
      public static let cancel = ProfileLocalization.tr("Localizable", "EDIT.BOTTOM_SHEET.CANCEL", fallback: "Cancel")
      /// Remove photo
      public static let remove = ProfileLocalization.tr("Localizable", "EDIT.BOTTOM_SHEET.REMOVE", fallback: "Remove photo")
      /// Select from gallery
      public static let select = ProfileLocalization.tr("Localizable", "EDIT.BOTTOM_SHEET.SELECT", fallback: "Select from gallery")
      /// Change profile image
      public static let title = ProfileLocalization.tr("Localizable", "EDIT.BOTTOM_SHEET.TITLE", fallback: "Change profile image")
    }
    public enum Fields {
      /// About me:
      public static let aboutMe = ProfileLocalization.tr("Localizable", "EDIT.FIELDS.ABOUT_ME", fallback: "About me:")
      /// Location
      public static let location = ProfileLocalization.tr("Localizable", "EDIT.FIELDS.LOCATION", fallback: "Location")
      /// Spoken language
      public static let spokenLangugae = ProfileLocalization.tr("Localizable", "EDIT.FIELDS.SPOKEN_LANGUGAE", fallback: "Spoken language")
      /// Year of birth
      public static let yearOfBirth = ProfileLocalization.tr("Localizable", "EDIT.FIELDS.YEAR_OF_BIRTH", fallback: "Year of birth")
    }
  }
  public enum LogoutAlert {
    /// Are you sure you want to log out?
    public static let text = ProfileLocalization.tr("Localizable", "LOGOUT_ALERT.TEXT", fallback: "Are you sure you want to log out?")
    /// Comfirm log out
    public static let title = ProfileLocalization.tr("Localizable", "LOGOUT_ALERT.TITLE", fallback: "Comfirm log out")
  }
  public enum Settings {
    /// Lower data usage
    public static let downloadQuality360Description = ProfileLocalization.tr("Localizable", "SETTINGS.DOWNLOAD_QUALITY_360_DESCRIPTION", fallback: "Lower data usage")
    /// 360p
    public static let downloadQuality360Title = ProfileLocalization.tr("Localizable", "SETTINGS.DOWNLOAD_QUALITY_360_TITLE", fallback: "360p")
    /// 540p
    public static let downloadQuality540Title = ProfileLocalization.tr("Localizable", "SETTINGS.DOWNLOAD_QUALITY_540_TITLE", fallback: "540p")
    /// Best quality
    public static let downloadQuality720Description = ProfileLocalization.tr("Localizable", "SETTINGS.DOWNLOAD_QUALITY_720_DESCRIPTION", fallback: "Best quality")
    /// 720p
    public static let downloadQuality720Title = ProfileLocalization.tr("Localizable", "SETTINGS.DOWNLOAD_QUALITY_720_TITLE", fallback: "720p")
    /// Recommended
    public static let downloadQualityAutoDescription = ProfileLocalization.tr("Localizable", "SETTINGS.DOWNLOAD_QUALITY_AUTO_DESCRIPTION", fallback: "Recommended")
    /// Auto
    public static let downloadQualityAutoTitle = ProfileLocalization.tr("Localizable", "SETTINGS.DOWNLOAD_QUALITY_AUTO_TITLE", fallback: "Auto")
    /// Lower data usage
    public static let quality360Description = ProfileLocalization.tr("Localizable", "SETTINGS.QUALITY_360_DESCRIPTION", fallback: "Lower data usage")
    /// 360p
    public static let quality360Title = ProfileLocalization.tr("Localizable", "SETTINGS.QUALITY_360_TITLE", fallback: "360p")
    /// 540p
    public static let quality540Title = ProfileLocalization.tr("Localizable", "SETTINGS.QUALITY_540_TITLE", fallback: "540p")
    /// Best quality
    public static let quality720Description = ProfileLocalization.tr("Localizable", "SETTINGS.QUALITY_720_DESCRIPTION", fallback: "Best quality")
    /// 720p
    public static let quality720Title = ProfileLocalization.tr("Localizable", "SETTINGS.QUALITY_720_TITLE", fallback: "720p")
    /// Recommended
    public static let qualityAutoDescription = ProfileLocalization.tr("Localizable", "SETTINGS.QUALITY_AUTO_DESCRIPTION", fallback: "Recommended")
    /// Auto
    public static let qualityAutoTitle = ProfileLocalization.tr("Localizable", "SETTINGS.QUALITY_AUTO_TITLE", fallback: "Auto")
    /// Tap to install required app update
    public static let tapToInstall = ProfileLocalization.tr("Localizable", "SETTINGS.TAP_TO_INSTALL", fallback: "Tap to install required app update")
    /// Tap to update to version
    public static let tapToUpdate = ProfileLocalization.tr("Localizable", "SETTINGS.TAP_TO_UPDATE", fallback: "Tap to update to version")
    /// Up-to-date
    public static let upToDate = ProfileLocalization.tr("Localizable", "SETTINGS.UP_TO_DATE", fallback: "Up-to-date")
    /// Version:
    public static let version = ProfileLocalization.tr("Localizable", "SETTINGS.VERSION", fallback: "Version:")
    /// Video download quality
    public static let videoDownloadQualityTitle = ProfileLocalization.tr("Localizable", "SETTINGS.VIDEO_DOWNLOAD_QUALITY_TITLE", fallback: "Video download quality")
    /// Auto (Recommended)
    public static let videoQualityDescription = ProfileLocalization.tr("Localizable", "SETTINGS.VIDEO_QUALITY_DESCRIPTION", fallback: "Auto (Recommended)")
    /// Video streaming quality
    public static let videoQualityTitle = ProfileLocalization.tr("Localizable", "SETTINGS.VIDEO_QUALITY_TITLE", fallback: "Video streaming quality")
    /// Video settings
    public static let videoSettingsTitle = ProfileLocalization.tr("Localizable", "SETTINGS.VIDEO_SETTINGS_TITLE", fallback: "Video settings")
    /// Only download content when wi-fi is turned on
    public static let wifiDescription = ProfileLocalization.tr("Localizable", "SETTINGS.WIFI_DESCRIPTION", fallback: "Only download content when wi-fi is turned on")
    /// Wi-fi only download
    public static let wifiTitle = ProfileLocalization.tr("Localizable", "SETTINGS.WIFI_TITLE", fallback: "Wi-fi only download")
  }
  public enum UnsavedDataAlert {
    /// Changes you have made may not be saved.
    public static let text = ProfileLocalization.tr("Localizable", "UNSAVED_DATA_ALERT.TEXT", fallback: "Changes you have made may not be saved.")
    /// Leave profile?
    public static let title = ProfileLocalization.tr("Localizable", "UNSAVED_DATA_ALERT.TITLE", fallback: "Leave profile?")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension ProfileLocalization {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type

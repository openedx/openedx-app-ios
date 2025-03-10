// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum DiscoveryLocalization {
  /// Search
  public static let search = DiscoveryLocalization.tr("Localizable", "SEARCH", fallback: "Search")
  /// Plural format key: "%#@courses@"
  public static func searchResultsDescription(_ p1: Int) -> String {
    return DiscoveryLocalization.tr("Localizable", "searchResultsDescription", p1, fallback: "Plural format key: \"%#@courses@\"")
  }
  /// Localizable.strings
  ///   Discovery
  /// 
  ///   Created by  Stepanok Ivan on 19.09.2022.
  public static let title = DiscoveryLocalization.tr("Localizable", "TITLE", fallback: "Discover")
  /// Account Settings
  public static let updateAccountSettings = DiscoveryLocalization.tr("Localizable", "UPDATE_ACCOUNT_SETTINGS", fallback: "Account Settings")
  /// Update
  public static let updateButton = DiscoveryLocalization.tr("Localizable", "UPDATE_BUTTON", fallback: "Update")
  /// Deprecated App Version
  public static let updateDeprecatedApp = DiscoveryLocalization.tr("Localizable", "UPDATE_DEPRECATED_APP", fallback: "Deprecated App Version")
  /// We recommend that you update to the latest version. Upgrade now to receive the latest features and fixes.
  public static let updateNeededDescription = DiscoveryLocalization.tr("Localizable", "UPDATE_NEEDED_DESCRIPTION", fallback: "We recommend that you update to the latest version. Upgrade now to receive the latest features and fixes.")
  /// Not Now
  public static let updateNeededNotNow = DiscoveryLocalization.tr("Localizable", "UPDATE_NEEDED_NOT_NOW", fallback: "Not Now")
  /// App Update
  public static let updateNeededTitle = DiscoveryLocalization.tr("Localizable", "UPDATE_NEEDED_TITLE", fallback: "App Update")
  /// New update available! Upgrade now to receive the latest features and fixes
  public static let updateNewAvaliable = DiscoveryLocalization.tr("Localizable", "UPDATE_NEW_AVALIABLE", fallback: "New update available! Upgrade now to receive the latest features and fixes")
  /// This version of the OpenEdX app is out-of-date. To continue learning and get the latest features and fixes, please upgrade to the latest version.
  public static let updateRequiredDescription = DiscoveryLocalization.tr("Localizable", "UPDATE_REQUIRED_DESCRIPTION", fallback: "This version of the OpenEdX app is out-of-date. To continue learning and get the latest features and fixes, please upgrade to the latest version.")
  /// App Update Required
  public static let updateRequiredTitle = DiscoveryLocalization.tr("Localizable", "UPDATE_REQUIRED_TITLE", fallback: "App Update Required")
  /// Why do I need to update?
  public static let updateWhyNeed = DiscoveryLocalization.tr("Localizable", "UPDATE_WHY_NEED", fallback: "Why do I need to update?")
  public enum Alert {
    /// Authorization
    public static let authorization = DiscoveryLocalization.tr("Localizable", "ALERT.AUTHORIZATION", fallback: "Authorization")
    /// You are now leaving the app and opening a browser
    public static let leavingAppMessage = DiscoveryLocalization.tr("Localizable", "ALERT.LEAVING_APP_MESSAGE", fallback: "You are now leaving the app and opening a browser")
    /// Leaving the app
    public static let leavingAppTitle = DiscoveryLocalization.tr("Localizable", "ALERT.LEAVING_APP_TITLE", fallback: "Leaving the app")
    /// Please enter the system to continue with course enrollment.
    public static let pleaseEnterTheSystem = DiscoveryLocalization.tr("Localizable", "ALERT.PLEASE_ENTER_THE_SYSTEM", fallback: "Please enter the system to continue with course enrollment.")
  }
  public enum Details {
    /// Enroll now
    public static let enrollNow = DiscoveryLocalization.tr("Localizable", "DETAILS.ENROLL_NOW", fallback: "Enroll now")
    /// You cannot enroll in this course because the enrollment date is over.
    public static let enrollmentDateIsOver = DiscoveryLocalization.tr("Localizable", "DETAILS.ENROLLMENT_DATE_IS_OVER", fallback: "You cannot enroll in this course because the enrollment date is over.")
    /// To enroll in this course, please make sure you are connected to the internet.
    public static let enrollmentNoInternet = DiscoveryLocalization.tr("Localizable", "DETAILS.ENROLLMENT_NO_INTERNET", fallback: "To enroll in this course, please make sure you are connected to the internet.")
    /// Course details
    public static let title = DiscoveryLocalization.tr("Localizable", "DETAILS.TITLE", fallback: "Course details")
    /// View course
    public static let viewCourse = DiscoveryLocalization.tr("Localizable", "DETAILS.VIEW_COURSE", fallback: "View course")
  }
  public enum Header {
    /// Discover new
    public static let title1 = DiscoveryLocalization.tr("Localizable", "HEADER.TITLE_1", fallback: "Discover new")
    /// Let's find new course for you.
    public static let title2 = DiscoveryLocalization.tr("Localizable", "HEADER.TITLE_2", fallback: "Let's find new course for you.")
  }
  public enum Search {
    /// Start typing to find the course
    public static let emptyDescription = DiscoveryLocalization.tr("Localizable", "SEARCH.EMPTY_DESCRIPTION", fallback: "Start typing to find the course")
    /// Search results
    public static let title = DiscoveryLocalization.tr("Localizable", "SEARCH.TITLE", fallback: "Search results")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension DiscoveryLocalization {
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

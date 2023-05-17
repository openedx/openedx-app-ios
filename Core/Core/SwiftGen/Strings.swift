// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum CoreLocalization {
  /// Done
  public static let done = CoreLocalization.tr("Localizable", "DONE", fallback: "Done")
  public enum Alert {
    /// ACCEPT
    public static let accept = CoreLocalization.tr("Localizable", "ALERT.ACCEPT", fallback: "ACCEPT")
    /// CANCEL
    public static let cancel = CoreLocalization.tr("Localizable", "ALERT.CANCEL", fallback: "CANCEL")
    /// Keep editing
    public static let keepEditing = CoreLocalization.tr("Localizable", "ALERT.KEEP_EDITING", fallback: "Keep editing")
    /// Leave
    public static let leave = CoreLocalization.tr("Localizable", "ALERT.LEAVE", fallback: "Leave")
    /// Log out
    public static let logout = CoreLocalization.tr("Localizable", "ALERT.LOGOUT", fallback: "Log out")
  }
  public enum Courseware {
    /// Back to outline
    public static let backToOutline = CoreLocalization.tr("Localizable", "COURSEWARE.BACK_TO_OUTLINE", fallback: "Back to outline")
    /// Continue
    public static let `continue` = CoreLocalization.tr("Localizable", "COURSEWARE.CONTINUE", fallback: "Continue")
    /// Continue with:
    public static let continueWith = CoreLocalization.tr("Localizable", "COURSEWARE.CONTINUE_WITH", fallback: "Continue with:")
    /// Course content
    public static let courseContent = CoreLocalization.tr("Localizable", "COURSEWARE.COURSE_CONTENT", fallback: "Course content")
    /// Course units
    public static let courseUnits = CoreLocalization.tr("Localizable", "COURSEWARE.COURSE_UNITS", fallback: "Course units")
    /// Finish
    public static let finish = CoreLocalization.tr("Localizable", "COURSEWARE.FINISH", fallback: "Finish")
    /// Good Work!
    public static let goodWork = CoreLocalization.tr("Localizable", "COURSEWARE.GOOD_WORK", fallback: "Good Work!")
    /// is finished.
    public static let isFinished = CoreLocalization.tr("Localizable", "COURSEWARE.IS_FINISHED", fallback: "is finished.")
    /// Next
    public static let next = CoreLocalization.tr("Localizable", "COURSEWARE.NEXT", fallback: "Next")
    /// Next section
    public static let nextSection = CoreLocalization.tr("Localizable", "COURSEWARE.NEXT_SECTION", fallback: "Next section")
    /// To proceed with “
    public static let nextSectionDescriptionFirst = CoreLocalization.tr("Localizable", "COURSEWARE.NEXT_SECTION_DESCRIPTION_FIRST", fallback: "To proceed with “")
    /// ” press “Next section”.
    public static let nextSectionDescriptionLast = CoreLocalization.tr("Localizable", "COURSEWARE.NEXT_SECTION_DESCRIPTION_LAST", fallback: "” press “Next section”.")
    /// Previous
    public static let previous = CoreLocalization.tr("Localizable", "COURSEWARE.PREVIOUS", fallback: "Previous")
    /// Section
    public static let section = CoreLocalization.tr("Localizable", "COURSEWARE.SECTION", fallback: "Section")
  }
  public enum Date {
    /// Ended
    public static let ended = CoreLocalization.tr("Localizable", "DATE.ENDED", fallback: "Ended")
    /// Just now
    public static let justNow = CoreLocalization.tr("Localizable", "DATE.JUST_NOW", fallback: "Just now")
    /// Start
    public static let start = CoreLocalization.tr("Localizable", "DATE.START", fallback: "Start")
    /// Started
    public static let started = CoreLocalization.tr("Localizable", "DATE.STARTED", fallback: "Started")
  }
  public enum DateFormat {
    /// MMM dd, yyyy
    public static let mmmDdYyyy = CoreLocalization.tr("Localizable", "DATE_FORMAT.MMM_DD_YYYY", fallback: "MMM dd, yyyy")
    /// MMMM dd
    public static let mmmmDd = CoreLocalization.tr("Localizable", "DATE_FORMAT.MMMM_DD", fallback: "MMMM dd")
  }
  public enum DownloadManager {
    /// Completed
    public static let completed = CoreLocalization.tr("Localizable", "DOWNLOAD_MANAGER.COMPLETED", fallback: "Completed")
    /// Download
    public static let download = CoreLocalization.tr("Localizable", "DOWNLOAD_MANAGER.DOWNLOAD", fallback: "Download")
    /// Downloaded
    public static let downloaded = CoreLocalization.tr("Localizable", "DOWNLOAD_MANAGER.DOWNLOADED", fallback: "Downloaded")
  }
  public enum Error {
    /// Invalid credentials
    public static let invalidCredentials = CoreLocalization.tr("Localizable", "ERROR.INVALID_CREDENTIALS", fallback: "Invalid credentials")
    /// No cached data for offline mode
    public static let noCachedData = CoreLocalization.tr("Localizable", "ERROR.NO_CACHED_DATA", fallback: "No cached data for offline mode")
    /// Reload
    public static let reload = CoreLocalization.tr("Localizable", "ERROR.RELOAD", fallback: "Reload")
    /// Slow or no internet connection
    public static let slowOrNoInternetConnection = CoreLocalization.tr("Localizable", "ERROR.SLOW_OR_NO_INTERNET_CONNECTION", fallback: "Slow or no internet connection")
    /// Something went wrong
    public static let unknownError = CoreLocalization.tr("Localizable", "ERROR.UNKNOWN_ERROR", fallback: "Something went wrong")
    /// User account is not activated. Please activate your account first.
    public static let userNotActive = CoreLocalization.tr("Localizable", "ERROR.USER_NOT_ACTIVE", fallback: "User account is not activated. Please activate your account first.")
    /// You can only download files over Wi-Fi. You can change this in the settings.
    public static let wifi = CoreLocalization.tr("Localizable", "ERROR.WIFI", fallback: "You can only download files over Wi-Fi. You can change this in the settings.")
  }
  public enum Mainscreen {
    /// Dashboard
    public static let dashboard = CoreLocalization.tr("Localizable", "MAINSCREEN.DASHBOARD", fallback: "Dashboard")
    /// Localizable.strings
    ///   Core
    /// 
    ///   Created by Vladimir Chekyrta on 13.09.2022.
    public static let discovery = CoreLocalization.tr("Localizable", "MAINSCREEN.DISCOVERY", fallback: "Discover")
    /// In developing
    public static let inDeveloping = CoreLocalization.tr("Localizable", "MAINSCREEN.IN_DEVELOPING", fallback: "In developing")
    /// Profile
    public static let profile = CoreLocalization.tr("Localizable", "MAINSCREEN.PROFILE", fallback: "Profile")
    /// Programs
    public static let programs = CoreLocalization.tr("Localizable", "MAINSCREEN.PROGRAMS", fallback: "Programs")
  }
  public enum NoInternet {
    /// Dismiss
    public static let dismiss = CoreLocalization.tr("Localizable", "NO_INTERNET.DISMISS", fallback: "Dismiss")
    /// Offline
    public static let offline = CoreLocalization.tr("Localizable", "NO_INTERNET.OFFLINE", fallback: "Offline")
    /// Reload
    public static let reload = CoreLocalization.tr("Localizable", "NO_INTERNET.RELOAD", fallback: "Reload")
  }
  public enum Picker {
    /// Accept
    public static let accept = CoreLocalization.tr("Localizable", "PICKER.ACCEPT", fallback: "Accept")
    /// Search
    public static let search = CoreLocalization.tr("Localizable", "PICKER.SEARCH", fallback: "Search")
  }
  public enum View {
    public enum Snackbar {
      /// Try Again
      public static let tryAgainBtn = CoreLocalization.tr("Localizable", "VIEW.SNACKBAR.TRY_AGAIN_BTN", fallback: "Try Again")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension CoreLocalization {
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

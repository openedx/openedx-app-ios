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
  /// View in Safari
  public static let openInBrowser = CoreLocalization.tr("Localizable", "OPEN_IN_BROWSER", fallback: "View in Safari")
  /// Register
  public static let register = CoreLocalization.tr("Localizable", "REGISTER", fallback: "Register")
  /// The user canceled the sign-in flow.
  public static let socialSignCanceled = CoreLocalization.tr("Localizable", "SOCIAL_SIGN_CANCELED", fallback: "The user canceled the sign-in flow.")
  /// Tomorrow
  public static let tomorrow = CoreLocalization.tr("Localizable", "TOMORROW", fallback: "Tomorrow")
  /// View
  public static let view = CoreLocalization.tr("Localizable", "VIEW ", fallback: "View")
  /// Yesterday
  public static let yesterday = CoreLocalization.tr("Localizable", "YESTERDAY", fallback: "Yesterday")
  public enum Alert {
    /// ACCEPT
    public static let accept = CoreLocalization.tr("Localizable", "ALERT.ACCEPT", fallback: "ACCEPT")
    /// Add
    public static let add = CoreLocalization.tr("Localizable", "ALERT.ADD", fallback: "Add")
    /// Remove course calendar
    public static let calendarShiftPromptRemoveCourseCalendar = CoreLocalization.tr("Localizable", "ALERT.CALENDAR_SHIFT_PROMPT_REMOVE_COURSE_CALENDAR", fallback: "Remove course calendar")
    /// CANCEL
    public static let cancel = CoreLocalization.tr("Localizable", "ALERT.CANCEL", fallback: "CANCEL")
    /// DELETE
    public static let delete = CoreLocalization.tr("Localizable", "ALERT.DELETE", fallback: "DELETE")
    /// Keep editing
    public static let keepEditing = CoreLocalization.tr("Localizable", "ALERT.KEEP_EDITING", fallback: "Keep editing")
    /// Leave
    public static let leave = CoreLocalization.tr("Localizable", "ALERT.LEAVE", fallback: "Leave")
    /// Log out
    public static let logout = CoreLocalization.tr("Localizable", "ALERT.LOGOUT", fallback: "Log out")
    /// Remove
    public static let remove = CoreLocalization.tr("Localizable", "ALERT.REMOVE", fallback: "Remove")
  }
  public enum Courseware {
    /// Back to outline
    public static let backToOutline = CoreLocalization.tr("Localizable", "COURSEWARE.BACK_TO_OUTLINE", fallback: "Back to outline")
    /// Continue
    public static let `continue` = CoreLocalization.tr("Localizable", "COURSEWARE.CONTINUE", fallback: "Continue")
    /// Course content
    public static let courseContent = CoreLocalization.tr("Localizable", "COURSEWARE.COURSE_CONTENT", fallback: "Course content")
    /// This interactive component isn't yet available on mobile.
    public static let courseContentNotAvailable = CoreLocalization.tr("Localizable", "COURSEWARE.COURSE_CONTENT_NOT_AVAILABLE", fallback: "This interactive component isn't yet available on mobile.")
    /// Course units
    public static let courseUnits = CoreLocalization.tr("Localizable", "COURSEWARE.COURSE_UNITS", fallback: "Course units")
    /// Finish
    public static let finish = CoreLocalization.tr("Localizable", "COURSEWARE.FINISH", fallback: "Finish")
    /// Good Work!
    public static let goodWork = CoreLocalization.tr("Localizable", "COURSEWARE.GOOD_WORK", fallback: "Good Work!")
    /// “ is finished.
    public static let isFinished = CoreLocalization.tr("Localizable", "COURSEWARE.IS_FINISHED", fallback: "“ is finished.")
    /// Next
    public static let next = CoreLocalization.tr("Localizable", "COURSEWARE.NEXT", fallback: "Next")
    /// Next section
    public static let nextSection = CoreLocalization.tr("Localizable", "COURSEWARE.NEXT_SECTION", fallback: "Next section")
    /// To proceed with “
    public static let nextSectionDescriptionFirst = CoreLocalization.tr("Localizable", "COURSEWARE.NEXT_SECTION_DESCRIPTION_FIRST", fallback: "To proceed with “")
    /// ” press “Next section”.
    public static let nextSectionDescriptionLast = CoreLocalization.tr("Localizable", "COURSEWARE.NEXT_SECTION_DESCRIPTION_LAST", fallback: "” press “Next section”.")
    /// Prev
    public static let previous = CoreLocalization.tr("Localizable", "COURSEWARE.PREVIOUS", fallback: "Prev")
    /// Resume
    public static let resume = CoreLocalization.tr("Localizable", "COURSEWARE.RESUME", fallback: "Resume")
    /// Resume with:
    public static let resumeWith = CoreLocalization.tr("Localizable", "COURSEWARE.RESUME_WITH", fallback: "Resume with:")
    /// Section “
    public static let section = CoreLocalization.tr("Localizable", "COURSEWARE.SECTION", fallback: "Section “")
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
    /// Authorization failed.
    public static let authorizationFailed = CoreLocalization.tr("Localizable", "ERROR.AUTHORIZATION_FAILED", fallback: "Authorization failed.")
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
  public enum Review {
    /// What could have been better?
    public static let better = CoreLocalization.tr("Localizable", "REVIEW.BETTER", fallback: "What could have been better?")
    /// We’re sorry to hear your learning experience has had some issues. We appreciate all feedback.
    public static let feedbackDescription = CoreLocalization.tr("Localizable", "REVIEW.FEEDBACK_DESCRIPTION", fallback: "We’re sorry to hear your learning experience has had some issues. We appreciate all feedback.")
    /// Leave Us Feedback
    public static let feedbackTitle = CoreLocalization.tr("Localizable", "REVIEW.FEEDBACK_TITLE", fallback: "Leave Us Feedback")
    /// Not now
    public static let notNow = CoreLocalization.tr("Localizable", "REVIEW.NOT_NOW", fallback: "Not now")
    /// We received your feedback and will use it to help improve your learning experience going forward. Thank you for sharing!
    public static let thanksForFeedbackDescription = CoreLocalization.tr("Localizable", "REVIEW.THANKS_FOR_FEEDBACK_DESCRIPTION", fallback: "We received your feedback and will use it to help improve your learning experience going forward. Thank you for sharing!")
    /// Thank You
    public static let thanksForFeedbackTitle = CoreLocalization.tr("Localizable", "REVIEW.THANKS_FOR_FEEDBACK_TITLE", fallback: "Thank You")
    /// Thank you for sharing your feedback with us. Would you like to share your review of this app with other users on the app store?
    public static let thanksForVoteDescription = CoreLocalization.tr("Localizable", "REVIEW.THANKS_FOR_VOTE_DESCRIPTION", fallback: "Thank you for sharing your feedback with us. Would you like to share your review of this app with other users on the app store?")
    /// Thank You
    public static let thanksForVoteTitle = CoreLocalization.tr("Localizable", "REVIEW.THANKS_FOR_VOTE_TITLE", fallback: "Thank You")
    /// Your feedback matters to us. Would you take a moment to rate the app by tapping a star below? Thanks for your support!
    public static let voteDescription = CoreLocalization.tr("Localizable", "REVIEW.VOTE_DESCRIPTION", fallback: "Your feedback matters to us. Would you take a moment to rate the app by tapping a star below? Thanks for your support!")
    /// Enjoying Open edX?
    public static let voteTitle = CoreLocalization.tr("Localizable", "REVIEW.VOTE_TITLE", fallback: "Enjoying Open edX?")
    public enum Button {
      /// Rate Us
      public static let rateUs = CoreLocalization.tr("Localizable", "REVIEW.BUTTON.RATE_US", fallback: "Rate Us")
      /// Share Feedback
      public static let shareFeedback = CoreLocalization.tr("Localizable", "REVIEW.BUTTON.SHARE_FEEDBACK", fallback: "Share Feedback")
      /// Submit
      public static let submit = CoreLocalization.tr("Localizable", "REVIEW.BUTTON.SUBMIT", fallback: "Submit")
    }
    public enum Email {
      /// Select email client:
      public static let title = CoreLocalization.tr("Localizable", "REVIEW.EMAIL.TITLE", fallback: "Select email client:")
    }
  }
  public enum Settings {
    /// Lower data usage
    public static let downloadQuality360Description = CoreLocalization.tr("Localizable", "SETTINGS.DOWNLOAD_QUALITY_360_DESCRIPTION", fallback: "Lower data usage")
    /// 360p
    public static let downloadQuality360Title = CoreLocalization.tr("Localizable", "SETTINGS.DOWNLOAD_QUALITY_360_TITLE", fallback: "360p")
    /// 540p
    public static let downloadQuality540Title = CoreLocalization.tr("Localizable", "SETTINGS.DOWNLOAD_QUALITY_540_TITLE", fallback: "540p")
    /// Best quality
    public static let downloadQuality720Description = CoreLocalization.tr("Localizable", "SETTINGS.DOWNLOAD_QUALITY_720_DESCRIPTION", fallback: "Best quality")
    /// 720p
    public static let downloadQuality720Title = CoreLocalization.tr("Localizable", "SETTINGS.DOWNLOAD_QUALITY_720_TITLE", fallback: "720p")
    /// Recommended
    public static let downloadQualityAutoDescription = CoreLocalization.tr("Localizable", "SETTINGS.DOWNLOAD_QUALITY_AUTO_DESCRIPTION", fallback: "Recommended")
    /// Auto
    public static let downloadQualityAutoTitle = CoreLocalization.tr("Localizable", "SETTINGS.DOWNLOAD_QUALITY_AUTO_TITLE", fallback: "Auto")
    /// Video download quality
    public static let videoDownloadQualityTitle = CoreLocalization.tr("Localizable", "SETTINGS.VIDEO_DOWNLOAD_QUALITY_TITLE", fallback: "Video download quality")
  }
  public enum SignIn {
    /// Sign in
    public static let logInBtn = CoreLocalization.tr("Localizable", "SIGN_IN.LOG_IN_BTN", fallback: "Sign in")
  }
  public enum View {
    public enum Snackbar {
      /// Try Again
      public static let tryAgainBtn = CoreLocalization.tr("Localizable", "VIEW.SNACKBAR.TRY_AGAIN_BTN", fallback: "Try Again")
    }
  }
  public enum Webview {
    public enum Alert {
      /// Cancel
      public static let cancel = CoreLocalization.tr("Localizable", "WEBVIEW.ALERT.CANCEL", fallback: "Cancel")
      /// Continue
      public static let `continue` = CoreLocalization.tr("Localizable", "WEBVIEW.ALERT.CONTINUE", fallback: "Continue")
      /// Ok
      public static let ok = CoreLocalization.tr("Localizable", "WEBVIEW.ALERT.OK", fallback: "Ok")
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

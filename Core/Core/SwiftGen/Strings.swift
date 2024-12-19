// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum CoreLocalization {
  /// Back
  public static let back = CoreLocalization.tr("Localizable", "BACK", fallback: "Back")
  /// Close
  public static let close = CoreLocalization.tr("Localizable", "CLOSE", fallback: "Close")
  /// Done
  public static let done = CoreLocalization.tr("Localizable", "DONE", fallback: "Done")
  /// Ok
  public static let ok = CoreLocalization.tr("Localizable", "OK", fallback: "Ok")
  /// View in Safari
  public static let openInBrowser = CoreLocalization.tr("Localizable", "OPEN_IN_BROWSER", fallback: "View in Safari")
  /// The user canceled the sign-in flow.
  public static let socialSignCanceled = CoreLocalization.tr("Localizable", "SOCIAL_SIGN_CANCELED", fallback: "The user canceled the sign-in flow.")
  /// Tomorrow
  public static let tomorrow = CoreLocalization.tr("Localizable", "TOMORROW", fallback: "Tomorrow")
  /// View
  public static let view = CoreLocalization.tr("Localizable", "VIEW", fallback: "View")
  /// Yesterday
  public static let yesterday = CoreLocalization.tr("Localizable", "YESTERDAY", fallback: "Yesterday")
  public enum Alert {
    /// Accept
    public static let accept = CoreLocalization.tr("Localizable", "ALERT.ACCEPT", fallback: "Accept")
    /// Add
    public static let add = CoreLocalization.tr("Localizable", "ALERT.ADD", fallback: "Add")
    /// Remove course calendar
    public static let calendarShiftPromptRemoveCourseCalendar = CoreLocalization.tr("Localizable", "ALERT.CALENDAR_SHIFT_PROMPT_REMOVE_COURSE_CALENDAR", fallback: "Remove course calendar")
    /// Cancel
    public static let cancel = CoreLocalization.tr("Localizable", "ALERT.CANCEL", fallback: "Cancel")
    /// Delete
    public static let delete = CoreLocalization.tr("Localizable", "ALERT.DELETE", fallback: "Delete")
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
    /// Good job!
    public static let goodWork = CoreLocalization.tr("Localizable", "COURSEWARE.GOOD_WORK", fallback: "Good job!")
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
    /// You've completed “%@”.
    public static func sectionCompleted(_ p1: Any) -> String {
      return CoreLocalization.tr("Localizable", "COURSEWARE.SECTION_COMPLETED", String(describing: p1), fallback: "You've completed “%@”.")
    }
  }
  public enum CourseDates {
    /// Completed
    public static let completed = CoreLocalization.tr("Localizable", "COURSE_DATES.COMPLETED", fallback: "Completed")
    /// Next week
    public static let nextWeek = CoreLocalization.tr("Localizable", "COURSE_DATES.NEXT_WEEK", fallback: "Next week")
    /// Past due
    public static let pastDue = CoreLocalization.tr("Localizable", "COURSE_DATES.PAST_DUE", fallback: "Past due")
    /// This week
    public static let thisWeek = CoreLocalization.tr("Localizable", "COURSE_DATES.THIS_WEEK", fallback: "This week")
    /// Today
    public static let today = CoreLocalization.tr("Localizable", "COURSE_DATES.TODAY", fallback: "Today")
    /// Upcoming
    public static let upcoming = CoreLocalization.tr("Localizable", "COURSE_DATES.UPCOMING", fallback: "Upcoming")
    public enum ResetDate {
      /// Your dates could not be shifted. Please try again.
      public static let errorMessage = CoreLocalization.tr("Localizable", "COURSE_DATES.RESET_DATE.ERROR_MESSAGE", fallback: "Your dates could not be shifted. Please try again.")
      /// Your dates have been successfully shifted.
      public static let successMessage = CoreLocalization.tr("Localizable", "COURSE_DATES.RESET_DATE.SUCCESS_MESSAGE", fallback: "Your dates have been successfully shifted.")
      /// Course Dates
      public static let title = CoreLocalization.tr("Localizable", "COURSE_DATES.RESET_DATE.TITLE", fallback: "Course Dates")
      public enum ResetDateBanner {
        /// Don't worry - shift our suggested schedule to complete past due assignments without losing any progress.
        public static let body = CoreLocalization.tr("Localizable", "COURSE_DATES.RESET_DATE.RESET_DATE_BANNER.BODY", fallback: "Don't worry - shift our suggested schedule to complete past due assignments without losing any progress.")
        /// Shift due dates
        public static let button = CoreLocalization.tr("Localizable", "COURSE_DATES.RESET_DATE.RESET_DATE_BANNER.BUTTON", fallback: "Shift due dates")
        /// Missed some deadlines?
        public static let header = CoreLocalization.tr("Localizable", "COURSE_DATES.RESET_DATE.RESET_DATE_BANNER.HEADER", fallback: "Missed some deadlines?")
      }
      public enum TabInfoBanner {
        /// We built a suggested schedule to help you stay on track. But don’t worry – it’s flexible so you can learn at your own pace. If you happen to fall behind, you’ll be able to adjust the dates to keep yourself on track.
        public static let body = CoreLocalization.tr("Localizable", "COURSE_DATES.RESET_DATE.TAB_INFO_BANNER.BODY", fallback: "We built a suggested schedule to help you stay on track. But don’t worry – it’s flexible so you can learn at your own pace. If you happen to fall behind, you’ll be able to adjust the dates to keep yourself on track.")
        /// 
        public static let header = CoreLocalization.tr("Localizable", "COURSE_DATES.RESET_DATE.TAB_INFO_BANNER.HEADER", fallback: "")
      }
      public enum UpgradeToCompleteGradedBanner {
        /// To complete graded assignments as part of this course, you can upgrade today.
        public static let body = CoreLocalization.tr("Localizable", "COURSE_DATES.RESET_DATE.UPGRADE_TO_COMPLETE_GRADED_BANNER.BODY", fallback: "To complete graded assignments as part of this course, you can upgrade today.")
        /// 
        public static let button = CoreLocalization.tr("Localizable", "COURSE_DATES.RESET_DATE.UPGRADE_TO_COMPLETE_GRADED_BANNER.BUTTON", fallback: "")
        /// 
        public static let header = CoreLocalization.tr("Localizable", "COURSE_DATES.RESET_DATE.UPGRADE_TO_COMPLETE_GRADED_BANNER.HEADER", fallback: "")
      }
      public enum UpgradeToResetBanner {
        /// You are auditing this course, which means that you are unable to participate in graded assignments. It looks like you missed some important deadlines based on our suggested schedule. To complete graded assignments as part of this course and shift the past due assignments into the future, you can upgrade today.
        public static let body = CoreLocalization.tr("Localizable", "COURSE_DATES.RESET_DATE.UPGRADE_TO_RESET_BANNER.BODY", fallback: "You are auditing this course, which means that you are unable to participate in graded assignments. It looks like you missed some important deadlines based on our suggested schedule. To complete graded assignments as part of this course and shift the past due assignments into the future, you can upgrade today.")
        /// 
        public static let button = CoreLocalization.tr("Localizable", "COURSE_DATES.RESET_DATE.UPGRADE_TO_RESET_BANNER.BUTTON", fallback: "")
        /// 
        public static let header = CoreLocalization.tr("Localizable", "COURSE_DATES.RESET_DATE.UPGRADE_TO_RESET_BANNER.HEADER", fallback: "")
      }
    }
  }
  public enum Date {
    /// Course Ended
    public static let courseEnded = CoreLocalization.tr("Localizable", "DATE.COURSE_ENDED", fallback: "Course Ended")
    /// Course Ends
    public static let courseEnds = CoreLocalization.tr("Localizable", "DATE.COURSE_ENDS", fallback: "Course Ends")
    /// Course Starts
    public static let courseStarts = CoreLocalization.tr("Localizable", "DATE.COURSE_STARTS", fallback: "Course Starts")
    /// %@ Days Ago
    public static func daysAgo(_ p1: Any) -> String {
      return CoreLocalization.tr("Localizable", "DATE.DAYS_AGO", String(describing: p1), fallback: "%@ Days Ago")
    }
    /// Due 
    public static let due = CoreLocalization.tr("Localizable", "DATE.DUE", fallback: "Due ")
    /// Due in 
    public static let dueIn = CoreLocalization.tr("Localizable", "DATE.DUE_IN", fallback: "Due in ")
    /// Due in %@ Days
    public static func dueInDays(_ p1: Any) -> String {
      return CoreLocalization.tr("Localizable", "DATE.DUE_IN_DAYS", String(describing: p1), fallback: "Due in %@ Days")
    }
    /// Ended
    public static let ended = CoreLocalization.tr("Localizable", "DATE.ENDED", fallback: "Ended")
    /// Just now
    public static let justNow = CoreLocalization.tr("Localizable", "DATE.JUST_NOW", fallback: "Just now")
    /// Next %@
    public static func next(_ p1: Any) -> String {
      return CoreLocalization.tr("Localizable", "DATE.NEXT", String(describing: p1), fallback: "Next %@")
    }
    /// Start
    public static let start = CoreLocalization.tr("Localizable", "DATE.START", fallback: "Start")
    /// Started
    public static let started = CoreLocalization.tr("Localizable", "DATE.STARTED", fallback: "Started")
    /// Today
    public static let today = CoreLocalization.tr("Localizable", "DATE.TODAY", fallback: "Today")
  }
  public enum DateFormat {
    /// MMM dd, yyyy
    public static let mmmDdYyyy = CoreLocalization.tr("Localizable", "DATE_FORMAT.MMM_DD_YYYY", fallback: "MMM dd, yyyy")
    /// MMMM dd
    public static let mmmmDd = CoreLocalization.tr("Localizable", "DATE_FORMAT.MMMM_DD", fallback: "MMMM dd")
    /// MMMM dd, yyyy
    public static let mmmmDdYyyy = CoreLocalization.tr("Localizable", "DATE_FORMAT.MMMM_DD_YYYY", fallback: "MMMM dd, yyyy")
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
    public enum Internet {
      /// Please connect to the internet to view this content.
      public static let noInternetDescription = CoreLocalization.tr("Localizable", "ERROR.INTERNET.NO_INTERNET_DESCRIPTION", fallback: "Please connect to the internet to view this content.")
      /// No internet connection
      public static let noInternetTitle = CoreLocalization.tr("Localizable", "ERROR.INTERNET.NO_INTERNET_TITLE", fallback: "No internet connection")
    }
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
    /// Learn
    public static let learn = CoreLocalization.tr("Localizable", "MAINSCREEN.LEARN", fallback: "Learn")
    /// Profile
    public static let profile = CoreLocalization.tr("Localizable", "MAINSCREEN.PROFILE", fallback: "Profile")
    /// Programs
    public static let programs = CoreLocalization.tr("Localizable", "MAINSCREEN.PROGRAMS", fallback: "Programs")
    /// You already set up an %@ account with your %@ account. You have been logged in with that account.
    public static func socialRegisterBanner(_ p1: Any, _ p2: Any) -> String {
      return CoreLocalization.tr("Localizable", "MAINSCREEN.SOCIAL_REGISTER_BANNER", String(describing: p1), String(describing: p2), fallback: "You already set up an %@ account with your %@ account. You have been logged in with that account.")
    }
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
    /// Sign in with SSO
    public static let logInWithSsoBtn = CoreLocalization.tr("Localizable", "SIGN_IN.LOG_IN_WITH_SSO_BTN", fallback: "Sign in with SSO")
    /// Register
    public static let registerBtn = CoreLocalization.tr("Localizable", "SIGN_IN.REGISTER_BTN", fallback: "Register")
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

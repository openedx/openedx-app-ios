// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum ProfileLocalization {
  /// About Me
  public static let about = ProfileLocalization.tr("Localizable", "ABOUT", fallback: "About Me")
  /// Bio:
  public static let bio = ProfileLocalization.tr("Localizable", "BIO", fallback: "Bio:")
  /// Contact support
  public static let contact = ProfileLocalization.tr("Localizable", "CONTACT", fallback: "Contact support")
  /// Cookie policy
  public static let cookiePolicy = ProfileLocalization.tr("Localizable", "COOKIE_POLICY", fallback: "Cookie policy")
  /// Do not sell my personal information
  public static let doNotSellInformation = ProfileLocalization.tr("Localizable", "DO_NOT_SELL_INFORMATION", fallback: "Do not sell my personal information")
  /// Edit Profile
  public static let editProfile = ProfileLocalization.tr("Localizable", "EDIT_PROFILE", fallback: "Edit Profile")
  /// View FAQ
  public static let faqTitle = ProfileLocalization.tr("Localizable", "FAQ_TITLE", fallback: "View FAQ")
  /// full profile
  public static let fullProfile = ProfileLocalization.tr("Localizable", "FULL_PROFILE", fallback: "full profile")
  /// Profile info
  public static let info = ProfileLocalization.tr("Localizable", "INFO", fallback: "Profile info")
  /// limited profile
  public static let limitedProfile = ProfileLocalization.tr("Localizable", "LIMITED_PROFILE", fallback: "limited profile")
  /// Log out
  public static let logout = ProfileLocalization.tr("Localizable", "LOGOUT", fallback: "Log out")
  /// Manage Account
  public static let manageAccount = ProfileLocalization.tr("Localizable", "MANAGE_ACCOUNT", fallback: "Manage Account")
  /// Privacy policy
  public static let privacy = ProfileLocalization.tr("Localizable", "PRIVACY", fallback: "Privacy policy")
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
  public enum AssignmentStatus {
    /// Sync Failed
    public static let failed = ProfileLocalization.tr("Localizable", "ASSIGNMENT_STATUS.FAILED", fallback: "Sync Failed")
    /// Offline
    public static let offline = ProfileLocalization.tr("Localizable", "ASSIGNMENT_STATUS.OFFLINE", fallback: "Offline")
    /// Synced
    public static let synced = ProfileLocalization.tr("Localizable", "ASSIGNMENT_STATUS.SYNCED", fallback: "Synced")
  }
  public enum Calendar {
    /// Account
    public static let account = ProfileLocalization.tr("Localizable", "CALENDAR.ACCOUNT", fallback: "Account")
    /// Begin Syncing
    public static let beginSyncing = ProfileLocalization.tr("Localizable", "CALENDAR.BEGIN_SYNCING", fallback: "Begin Syncing")
    /// Calendar Name
    public static let calendarName = ProfileLocalization.tr("Localizable", "CALENDAR.CALENDAR_NAME", fallback: "Calendar Name")
    /// Cancel
    public static let cancel = ProfileLocalization.tr("Localizable", "CALENDAR.CANCEL", fallback: "Cancel")
    /// Change Sync Options
    public static let changeSyncOptions = ProfileLocalization.tr("Localizable", "CALENDAR.CHANGE_SYNC_OPTIONS", fallback: "Change Sync Options")
    /// Color
    public static let color = ProfileLocalization.tr("Localizable", "CALENDAR.COLOR", fallback: "Color")
    /// New Calendar
    public static let newCalendar = ProfileLocalization.tr("Localizable", "CALENDAR.NEW_CALENDAR", fallback: "New Calendar")
    /// Upcoming assignments for active courses will appear on this calendar
    public static let upcomingAssignments = ProfileLocalization.tr("Localizable", "CALENDAR.UPCOMING_ASSIGNMENTS", fallback: "Upcoming assignments for active courses will appear on this calendar")
    public enum Dropdown {
      /// iCloud
      public static let icloud = ProfileLocalization.tr("Localizable", "CALENDAR.DROPDOWN.ICLOUD", fallback: "iCloud")
      /// Local
      public static let local = ProfileLocalization.tr("Localizable", "CALENDAR.DROPDOWN.LOCAL", fallback: "Local")
    }
    public enum DropdownColor {
      /// Accent
      public static let accent = ProfileLocalization.tr("Localizable", "CALENDAR.DROPDOWN_COLOR.ACCENT", fallback: "Accent")
      /// Blue
      public static let blue = ProfileLocalization.tr("Localizable", "CALENDAR.DROPDOWN_COLOR.BLUE", fallback: "Blue")
      /// Brown
      public static let brown = ProfileLocalization.tr("Localizable", "CALENDAR.DROPDOWN_COLOR.BROWN", fallback: "Brown")
      /// Green
      public static let green = ProfileLocalization.tr("Localizable", "CALENDAR.DROPDOWN_COLOR.GREEN", fallback: "Green")
      /// Orange
      public static let orange = ProfileLocalization.tr("Localizable", "CALENDAR.DROPDOWN_COLOR.ORANGE", fallback: "Orange")
      /// Purple
      public static let purple = ProfileLocalization.tr("Localizable", "CALENDAR.DROPDOWN_COLOR.PURPLE", fallback: "Purple")
      /// Red
      public static let red = ProfileLocalization.tr("Localizable", "CALENDAR.DROPDOWN_COLOR.RED", fallback: "Red")
      /// Yellow
      public static let yellow = ProfileLocalization.tr("Localizable", "CALENDAR.DROPDOWN_COLOR.YELLOW", fallback: "Yellow")
    }
  }
  public enum CalendarDialog {
    /// Calendar Access
    public static let calendarAccess = ProfileLocalization.tr("Localizable", "CALENDAR_DIALOG.CALENDAR_ACCESS", fallback: "Calendar Access")
    /// To show upcoming assignments and course milestones on your calendar, we need permission to access your calendar.
    public static let calendarAccessDescription = ProfileLocalization.tr("Localizable", "CALENDAR_DIALOG.CALENDAR_ACCESS_DESCRIPTION", fallback: "To show upcoming assignments and course milestones on your calendar, we need permission to access your calendar.")
    /// Cancel
    public static let cancel = ProfileLocalization.tr("Localizable", "CALENDAR_DIALOG.CANCEL", fallback: "Cancel")
    /// Change Sync Options
    public static let disableCalendarSync = ProfileLocalization.tr("Localizable", "CALENDAR_DIALOG.DISABLE_CALENDAR_SYNC", fallback: "Change Sync Options")
    /// Disabling calendar sync will delete the calendar “My Assignments.” You can turn calendar sync back on at any time.
    public static let disableCalendarSyncDescription = ProfileLocalization.tr("Localizable", "CALENDAR_DIALOG.DISABLE_CALENDAR_SYNC_DESCRIPTION", fallback: "Disabling calendar sync will delete the calendar “My Assignments.” You can turn calendar sync back on at any time.")
    /// Disable Syncing
    public static let disableSyncing = ProfileLocalization.tr("Localizable", "CALENDAR_DIALOG.DISABLE_SYNCING", fallback: "Disable Syncing")
    /// Grant Calendar Access
    public static let grantCalendarAccess = ProfileLocalization.tr("Localizable", "CALENDAR_DIALOG.GRANT_CALENDAR_ACCESS", fallback: "Grant Calendar Access")
  }
  public enum CalendarSync {
    /// Set Up Calendar Sync
    public static let button = ProfileLocalization.tr("Localizable", "CALENDAR_SYNC.BUTTON", fallback: "Set Up Calendar Sync")
    /// Set up calendar sync to show your upcoming assignments and course milestones on your calendar. New assignments and shifted course dates will sync automatically
    public static let description = ProfileLocalization.tr("Localizable", "CALENDAR_SYNC.DESCRIPTION", fallback: "Set up calendar sync to show your upcoming assignments and course milestones on your calendar. New assignments and shifted course dates will sync automatically")
    /// Calendar Sync
    public static let title = ProfileLocalization.tr("Localizable", "CALENDAR_SYNC.TITLE", fallback: "Calendar Sync")
  }
  public enum CoursesToSync {
    /// Disabling sync for a course will remove all events connected to the course from your synced calendar.
    public static let description = ProfileLocalization.tr("Localizable", "COURSES_TO_SYNC.DESCRIPTION", fallback: "Disabling sync for a course will remove all events connected to the course from your synced calendar.")
    /// Hide Inactive Courses
    public static let hideInactiveCourses = ProfileLocalization.tr("Localizable", "COURSES_TO_SYNC.HIDE_INACTIVE_COURSES", fallback: "Hide Inactive Courses")
    /// Automatically remove events from courses you haven’t viewed in the last month
    public static let hideInactiveCoursesDescription = ProfileLocalization.tr("Localizable", "COURSES_TO_SYNC.HIDE_INACTIVE_COURSES_DESCRIPTION", fallback: "Automatically remove events from courses you haven’t viewed in the last month")
    /// Inactive
    public static let inactive = ProfileLocalization.tr("Localizable", "COURSES_TO_SYNC.INACTIVE", fallback: "Inactive")
    /// Syncing %d Courses
    public static func syncingCourses(_ p1: Int) -> String {
      return ProfileLocalization.tr("Localizable", "COURSES_TO_SYNC.SYNCING_COURSES", p1, fallback: "Syncing %d Courses")
    }
    /// Courses to Sync
    public static let title = ProfileLocalization.tr("Localizable", "COURSES_TO_SYNC.TITLE", fallback: "Courses to Sync")
  }
  public enum CourseCalendarSync {
    /// Course Calendar Sync
    public static let title = ProfileLocalization.tr("Localizable", "COURSE_CALENDAR_SYNC.TITLE", fallback: "Course Calendar Sync")
    public enum Button {
      /// Change Sync Options
      public static let changeSyncOptions = ProfileLocalization.tr("Localizable", "COURSE_CALENDAR_SYNC.BUTTON.CHANGE_SYNC_OPTIONS", fallback: "Change Sync Options")
      /// Reconnect Calendar
      public static let reconnect = ProfileLocalization.tr("Localizable", "COURSE_CALENDAR_SYNC.BUTTON.RECONNECT", fallback: "Reconnect Calendar")
    }
    public enum Description {
      /// Please reconnect your calendar to resume syncing
      public static let reconnectRequired = ProfileLocalization.tr("Localizable", "COURSE_CALENDAR_SYNC.DESCRIPTION.RECONNECT_REQUIRED", fallback: "Please reconnect your calendar to resume syncing")
      /// Currently syncing events to your calendar
      public static let syncing = ProfileLocalization.tr("Localizable", "COURSE_CALENDAR_SYNC.DESCRIPTION.SYNCING", fallback: "Currently syncing events to your calendar")
    }
  }
  public enum DatesAndCalendar {
    /// Dates & Calendar
    public static let title = ProfileLocalization.tr("Localizable", "DATES_AND_CALENDAR.TITLE", fallback: "Dates & Calendar")
  }
  public enum DeleteAccount {
    /// Are you sure you want to 
    public static let areYouSure = ProfileLocalization.tr("Localizable", "DELETE_ACCOUNT.ARE_YOU_SURE", fallback: "Are you sure you want to ")
    /// Back to profile
    public static let backToProfile = ProfileLocalization.tr("Localizable", "DELETE_ACCOUNT.BACK_TO_PROFILE", fallback: "Back to profile")
    /// Yes, delete account
    public static let comfirm = ProfileLocalization.tr("Localizable", "DELETE_ACCOUNT.COMFIRM", fallback: "Yes, delete account")
    /// To confirm this action, please enter your account password.
    public static let description = ProfileLocalization.tr("Localizable", "DELETE_ACCOUNT.DESCRIPTION", fallback: "To confirm this action, please enter your account password.")
    /// The password is incorrect. Please try again.
    public static let incorrectPassword = ProfileLocalization.tr("Localizable", "DELETE_ACCOUNT.INCORRECT_PASSWORD", fallback: "The password is incorrect. Please try again.")
    /// Password
    public static let password = ProfileLocalization.tr("Localizable", "DELETE_ACCOUNT.PASSWORD", fallback: "Password")
    /// Enter password
    public static let passwordDescription = ProfileLocalization.tr("Localizable", "DELETE_ACCOUNT.PASSWORD_DESCRIPTION", fallback: "Enter password")
    /// Delete Account
    public static let title = ProfileLocalization.tr("Localizable", "DELETE_ACCOUNT.TITLE", fallback: "Delete Account")
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
    /// Delete Account
    public static let deleteAccount = ProfileLocalization.tr("Localizable", "EDIT.DELETE_ACCOUNT", fallback: "Delete Account")
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
  public enum Error {
    /// Cannot send email. It seems your email client is not set up.
    public static let cannotSendEmail = ProfileLocalization.tr("Localizable", "ERROR.CANNOT_SEND_EMAIL", fallback: "Cannot send email. It seems your email client is not set up.")
  }
  public enum LogoutAlert {
    /// Are you sure you want to log out?
    public static let text = ProfileLocalization.tr("Localizable", "LOGOUT_ALERT.TEXT", fallback: "Are you sure you want to log out?")
    /// Comfirm log out
    public static let title = ProfileLocalization.tr("Localizable", "LOGOUT_ALERT.TITLE", fallback: "Comfirm log out")
  }
  public enum Options {
    /// Show relative dates like “Tomorrow” and “Yesterday”
    public static let showRelativeDates = ProfileLocalization.tr("Localizable", "OPTIONS.SHOW_RELATIVE_DATES", fallback: "Show relative dates like “Tomorrow” and “Yesterday”")
    /// Options
    public static let title = ProfileLocalization.tr("Localizable", "OPTIONS.TITLE", fallback: "Options")
    /// Use relative dates
    public static let useRelativeDates = ProfileLocalization.tr("Localizable", "OPTIONS.USE_RELATIVE_DATES", fallback: "Use relative dates")
  }
  public enum Settings {
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
    /// Changes you have made will be discarded.
    public static let text = ProfileLocalization.tr("Localizable", "UNSAVED_DATA_ALERT.TEXT", fallback: "Changes you have made will be discarded.")
    /// Leave without saving?
    public static let title = ProfileLocalization.tr("Localizable", "UNSAVED_DATA_ALERT.TITLE", fallback: "Leave without saving?")
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

// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum AppDatesLocalization {
  public enum Dates {
    /// Next Week
    public static let nextWeek = AppDatesLocalization.tr("Localizable", "DATES.NEXT_WEEK", fallback: "Next Week")
    /// Past Due
    public static let pastDue = AppDatesLocalization.tr("Localizable", "DATES.PAST_DUE", fallback: "Past Due")
    /// This Week
    public static let thisWeek = AppDatesLocalization.tr("Localizable", "DATES.THIS_WEEK", fallback: "This Week")
    /// Localizable.strings
    ///   AppDates
    /// 
    ///   Created by Ivan Stepanok on 15.02.2025.
    public static let title = AppDatesLocalization.tr("Localizable", "DATES.TITLE", fallback: "Dates")
    /// Today
    public static let today = AppDatesLocalization.tr("Localizable", "DATES.TODAY", fallback: "Today")
    /// Upcoming
    public static let upcoming = AppDatesLocalization.tr("Localizable", "DATES.UPCOMING", fallback: "Upcoming")
  }
  public enum Empty {
    /// You currently have no active courses with scheduled events. Enroll in a course to view important dates and deadlines.
    public static let subtitle = AppDatesLocalization.tr("Localizable", "EMPTY.SUBTITLE", fallback: "You currently have no active courses with scheduled events. Enroll in a course to view important dates and deadlines.")
    /// No Dates
    public static let title = AppDatesLocalization.tr("Localizable", "EMPTY.TITLE", fallback: "No Dates")
  }
  public enum ShiftDueDates {
    /// Shift Due Dates
    public static let button = AppDatesLocalization.tr("Localizable", "SHIFT_DUE_DATES.BUTTON", fallback: "Shift Due Dates")
    /// Don't worry - shift our suggested schedule to complete past due assignments without losing any progress.
    public static let description = AppDatesLocalization.tr("Localizable", "SHIFT_DUE_DATES.DESCRIPTION", fallback: "Don't worry - shift our suggested schedule to complete past due assignments without losing any progress.")
    /// Missed Some Deadlines?
    public static let title = AppDatesLocalization.tr("Localizable", "SHIFT_DUE_DATES.TITLE", fallback: "Missed Some Deadlines?")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension AppDatesLocalization {
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

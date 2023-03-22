// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum DashboardLocalization {
  /// Localizable.strings
  ///   Dashboard
  /// 
  ///   Created by  Stepanok Ivan on 20.09.2022.
  public static let title = DashboardLocalization.tr("Localizable", "TITLE", fallback: "Dashboard")
  public enum Empty {
    /// You are not enrolled in any courses yet.
    public static let subtitle = DashboardLocalization.tr("Localizable", "EMPTY.SUBTITLE", fallback: "You are not enrolled in any courses yet.")
    /// It's empty
    public static let title = DashboardLocalization.tr("Localizable", "EMPTY.TITLE", fallback: "It's empty")
  }
  public enum Header {
    /// Courses
    public static let courses = DashboardLocalization.tr("Localizable", "HEADER.COURSES", fallback: "Courses")
    /// Welcome back. Let's keep learning.
    public static let welcomeBack = DashboardLocalization.tr("Localizable", "HEADER.WELCOME_BACK", fallback: "Welcome back. Let's keep learning.")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension DashboardLocalization {
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

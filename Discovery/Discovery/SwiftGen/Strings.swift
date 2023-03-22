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

// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum WhatsNewLocalization {
  /// Done
  public static let buttonDone = WhatsNewLocalization.tr("Localizable", "BUTTON_DONE", fallback: "Done")
  /// Next
  public static let buttonNext = WhatsNewLocalization.tr("Localizable", "BUTTON_NEXT", fallback: "Next")
  /// Previous
  public static let buttonPrevious = WhatsNewLocalization.tr("Localizable", "BUTTON_PREVIOUS", fallback: "Previous")
  /// Localizable.strings
  ///   WhatsNew
  /// 
  ///   Created by  Stepanok Ivan on 18.10.2023.
  public static let title = WhatsNewLocalization.tr("Localizable", "TITLE", fallback: "What's New")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension WhatsNewLocalization {
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

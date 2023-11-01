// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum AuthLocalization {
  public enum Error {
    /// Invalid email
    public static let invalidEmailAddress = AuthLocalization.tr("Localizable", "ERROR.INVALID_EMAIL_ADDRESS", fallback: "Invalid email")
    /// Invalid email or username
    public static let invalidEmailAddressOrUsername = AuthLocalization.tr("Localizable", "ERROR.INVALID_EMAIL_ADDRESS_OR_USERNAME", fallback: "Invalid email or username")
    /// Invalid password length
    public static let invalidPasswordLength = AuthLocalization.tr("Localizable", "ERROR.INVALID_PASSWORD_LENGTH", fallback: "Invalid password length")
  }
  public enum Forgot {
    /// We have sent a password recover instructions to your email 
    public static let checkDescription = AuthLocalization.tr("Localizable", "FORGOT.CHECK_Description", fallback: "We have sent a password recover instructions to your email ")
    /// Check your email
    public static let checkTitle = AuthLocalization.tr("Localizable", "FORGOT.CHECK_TITLE", fallback: "Check your email")
    /// Please enter your log-in or recovery email address below and we will send you an email with instructions.
    public static let description = AuthLocalization.tr("Localizable", "FORGOT.DESCRIPTION", fallback: "Please enter your log-in or recovery email address below and we will send you an email with instructions.")
    /// Reset password
    public static let request = AuthLocalization.tr("Localizable", "FORGOT.REQUEST", fallback: "Reset password")
    /// Forgot password
    public static let title = AuthLocalization.tr("Localizable", "FORGOT.TITLE", fallback: "Forgot password")
  }
  public enum SignIn {
    /// Email
    public static let email = AuthLocalization.tr("Localizable", "SIGN_IN.EMAIL", fallback: "Email")
    /// Email or username
    public static let emailOrUsername = AuthLocalization.tr("Localizable", "SIGN_IN.EMAIL_OR_USERNAME", fallback: "Email or username")
    /// Forgot password?
    public static let forgotPassBtn = AuthLocalization.tr("Localizable", "SIGN_IN.FORGOT_PASS_BTN", fallback: "Forgot password?")
    /// Sign in
    public static let logInBtn = AuthLocalization.tr("Localizable", "SIGN_IN.LOG_IN_BTN", fallback: "Sign in")
    /// Localizable.strings
    ///   Authorization
    /// 
    ///   Created by Vladimir Chekyrta on 13.09.2022.
    public static let logInTitle = AuthLocalization.tr("Localizable", "SIGN_IN.LOG_IN_TITLE", fallback: "Sign in")
    /// Password
    public static let password = AuthLocalization.tr("Localizable", "SIGN_IN.PASSWORD", fallback: "Password")
    /// Register
    public static let registerBtn = AuthLocalization.tr("Localizable", "SIGN_IN.REGISTER_BTN", fallback: "Register")
    /// Welcome back! Please authorize to continue.
    public static let welcomeBack = AuthLocalization.tr("Localizable", "SIGN_IN.WELCOME_BACK", fallback: "Welcome back! Please authorize to continue.")
  }
  public enum SignUp {
    /// Create account
    public static let createAccountBtn = AuthLocalization.tr("Localizable", "SIGN_UP.CREATE_ACCOUNT_BTN", fallback: "Create account")
    /// Hide optional Fields
    public static let hideFields = AuthLocalization.tr("Localizable", "SIGN_UP.HIDE_FIELDS", fallback: "Hide optional Fields")
    /// Show optional Fields
    public static let showFields = AuthLocalization.tr("Localizable", "SIGN_UP.SHOW_FIELDS", fallback: "Show optional Fields")
    /// Create new account.
    public static let subtitle = AuthLocalization.tr("Localizable", "SIGN_UP.SUBTITLE", fallback: "Create new account.")
    /// Sign up
    public static let title = AuthLocalization.tr("Localizable", "SIGN_UP.TITLE", fallback: "Sign up")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension AuthLocalization {
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

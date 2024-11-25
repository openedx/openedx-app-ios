// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum AuthLocalization {
  /// Apple
  public static let apple = AuthLocalization.tr("Localizable", "APPLE", fallback: "Apple")
  /// Continue with:
  public static let continueWith = AuthLocalization.tr("Localizable", "CONTINUE_WITH", fallback: "Continue with:")
  /// Facebook
  public static let facebook = AuthLocalization.tr("Localizable", "FACEBOOK", fallback: "Facebook")
  /// Google
  public static let google = AuthLocalization.tr("Localizable", "GOOGLE", fallback: "Google")
  /// Last sign in
  public static let lastSignIn = AuthLocalization.tr("Localizable", "LAST_SIGN_IN", fallback: "Last sign in")
  /// Microsoft
  public static let microsoft = AuthLocalization.tr("Localizable", "MICROSOFT", fallback: "Microsoft")
  /// Or
  public static let or = AuthLocalization.tr("Localizable", "OR", fallback: "Or")
  /// Or register below:
  public static let orRegisterWith = AuthLocalization.tr("Localizable", "OR_REGISTER_WITH", fallback: "Or register below:")
  /// Or sign in with email:
  public static let orSignInWith = AuthLocalization.tr("Localizable", "OR_SIGN_IN_WITH", fallback: "Or sign in with email:")
  public enum Error {
    /// This %@ account is not linked with any %@ account. Please register.
    public static func accountNotRegistered(_ p1: Any, _ p2: Any) -> String {
      return AuthLocalization.tr("Localizable", "ERROR.ACCOUNT_NOT_REGISTERED", String(describing: p1), String(describing: p2), fallback: "This %@ account is not linked with any %@ account. Please register.")
    }
    /// Your account is disabled. Please contact customer support for assistance.
    public static let disabledAccount = AuthLocalization.tr("Localizable", "ERROR.DISABLED_ACCOUNT", fallback: "Your account is disabled. Please contact customer support for assistance.")
    /// Invalid email address
    public static let invalidEmailAddress = AuthLocalization.tr("Localizable", "ERROR.INVALID_EMAIL_ADDRESS", fallback: "Invalid email address")
    /// Invalid email or username
    public static let invalidEmailAddressOrUsername = AuthLocalization.tr("Localizable", "ERROR.INVALID_EMAIL_ADDRESS_OR_USERNAME", fallback: "Invalid email or username")
    /// Invalid password lenght
    public static let invalidPasswordLenght = AuthLocalization.tr("Localizable", "ERROR.INVALID_PASSWORD_LENGHT", fallback: "Invalid password lenght")
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
    /// By signing in to this app, you agree to the [%@ End User License Agreement](%@) and [%@ Terms of Service and Honor Code](%@) and you acknowledge that %@ and each Member process your personal data in
    /// accordance with the [Privacy Policy.](%@)
    public static func agreement(_ p1: Any, _ p2: Any, _ p3: Any, _ p4: Any, _ p5: Any, _ p6: Any) -> String {
      return AuthLocalization.tr("Localizable", "SIGN_IN.AGREEMENT", String(describing: p1), String(describing: p2), String(describing: p3), String(describing: p4), String(describing: p5), String(describing: p6), fallback: "By signing in to this app, you agree to the [%@ End User License Agreement](%@) and [%@ Terms of Service and Honor Code](%@) and you acknowledge that %@ and each Member process your personal data in\naccordance with the [Privacy Policy.](%@)")
    }
    /// Email
    public static let email = AuthLocalization.tr("Localizable", "SIGN_IN.EMAIL", fallback: "Email")
    /// Email or username
    public static let emailOrUsername = AuthLocalization.tr("Localizable", "SIGN_IN.EMAIL_OR_USERNAME", fallback: "Email or username")
    /// Forgot password?
    public static let forgotPassBtn = AuthLocalization.tr("Localizable", "SIGN_IN.FORGOT_PASS_BTN", fallback: "Forgot password?")
    /// Localizable.strings
    ///   Authorization
    /// 
    ///   Created by Vladimir Chekyrta on 13.09.2022.
    public static let logInTitle = AuthLocalization.tr("Localizable", "SIGN_IN.LOG_IN_TITLE", fallback: "Sign in")
    /// Password
    public static let password = AuthLocalization.tr("Localizable", "SIGN_IN.PASSWORD", fallback: "Password")
    /// Start today to build your career with confidence
    public static let ssoHeading = AuthLocalization.tr("Localizable", "SIGN_IN.SSO_HEADING", fallback: "Start today to build your career with confidence")
    /// Log in through the national unified sign-on service
    public static let ssoLogInSubtitle = AuthLocalization.tr("Localizable", "SIGN_IN.SSO_LOG_IN_SUBTITLE", fallback: "Log in through the national unified sign-on service")
    /// Sign in
    public static let ssoLogInTitle = AuthLocalization.tr("Localizable", "SIGN_IN.SSO_LOG_IN_TITLE", fallback: "Sign in")
    /// An integrated set of knowledge and empowerment programs to develop the components of the endowment sector and its workers
    public static let ssoSupportingText = AuthLocalization.tr("Localizable", "SIGN_IN.SSO_SUPPORTING_TEXT", fallback: "An integrated set of knowledge and empowerment programs to develop the components of the endowment sector and its workers")
    /// Welcome back! Sign in to access your courses.
    public static let welcomeBack = AuthLocalization.tr("Localizable", "SIGN_IN.WELCOME_BACK", fallback: "Welcome back! Sign in to access your courses.")
  }
  public enum SignUp {
    /// By creating an account, you agree to the [%@ End User License Agreement](%@) and [%@ Terms of Service and Honor Code](%@) and you acknowledge that %@ and each Member process your personal data inaccordance with the [Privacy Policy.](%@)
    public static func agreement(_ p1: Any, _ p2: Any, _ p3: Any, _ p4: Any, _ p5: Any, _ p6: Any) -> String {
      return AuthLocalization.tr("Localizable", "SIGN_UP.AGREEMENT", String(describing: p1), String(describing: p2), String(describing: p3), String(describing: p4), String(describing: p5), String(describing: p6), fallback: "By creating an account, you agree to the [%@ End User License Agreement](%@) and [%@ Terms of Service and Honor Code](%@) and you acknowledge that %@ and each Member process your personal data inaccordance with the [Privacy Policy.](%@)")
    }
    /// Create account
    public static let createAccountBtn = AuthLocalization.tr("Localizable", "SIGN_UP.CREATE_ACCOUNT_BTN", fallback: "Create account")
    /// Hide optional Fields
    public static let hideFields = AuthLocalization.tr("Localizable", "SIGN_UP.HIDE_FIELDS", fallback: "Hide optional Fields")
    /// I agree that %@ may send me marketing messages.
    public static func marketingEmailTitle(_ p1: Any) -> String {
      return AuthLocalization.tr("Localizable", "SIGN_UP.MARKETING_EMAIL_TITLE", String(describing: p1), fallback: "I agree that %@ may send me marketing messages.")
    }
    /// Show optional Fields
    public static let showFields = AuthLocalization.tr("Localizable", "SIGN_UP.SHOW_FIELDS", fallback: "Show optional Fields")
    /// Create an account to start learning today!
    public static let subtitle = AuthLocalization.tr("Localizable", "SIGN_UP.SUBTITLE", fallback: "Create an account to start learning today!")
    /// You've successfully signed in.
    public static let successSigninLabel = AuthLocalization.tr("Localizable", "SIGN_UP.SUCCESS_SIGNIN_LABEL", fallback: "You've successfully signed in.")
    /// We just need a little more information before you start learning.
    public static let successSigninSublabel = AuthLocalization.tr("Localizable", "SIGN_UP.SUCCESS_SIGNIN_SUBLABEL", fallback: "We just need a little more information before you start learning.")
  }
  public enum Startup {
    /// Explore all courses
    public static let exploreAllCourses = AuthLocalization.tr("Localizable", "STARTUP.EXPLORE_ALL_COURSES", fallback: "Explore all courses")
    /// Courses and programs from the world's best universities in your pocket.
    public static let infoMessage = AuthLocalization.tr("Localizable", "STARTUP.INFO_MESSAGE", fallback: "Courses and programs from the world's best universities in your pocket.")
    /// Search our 3000+ courses
    public static let searchPlaceholder = AuthLocalization.tr("Localizable", "STARTUP.SEARCH_PLACEHOLDER", fallback: "Search our 3000+ courses")
    /// What do you want to learn?
    public static let searchTitle = AuthLocalization.tr("Localizable", "STARTUP.SEARCH_TITLE", fallback: "What do you want to learn?")
    /// Start
    public static let title = AuthLocalization.tr("Localizable", "STARTUP.TITLE", fallback: "Start")
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

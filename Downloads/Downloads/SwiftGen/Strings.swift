// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum DownloadsLocalization {
  public enum Downloads {
    /// Manage Download Settings
    public static let manageDownloadSettings = DownloadsLocalization.tr("Localizable", "DOWNLOADS.MANAGE_DOWNLOAD_SETTINGS", fallback: "Manage Download Settings")
    /// Localizable.strings
    ///   Downloads
    /// 
    ///   Created by Ivan Stepanok on 22.02.2025.
    public static let title = DownloadsLocalization.tr("Localizable", "DOWNLOADS.TITLE", fallback: "Downloads")
    public enum Cell {
      /// All %@ downloaded
      public static func allDownloaded(_ p1: Any) -> String {
        return DownloadsLocalization.tr("Localizable", "DOWNLOADS.CELL.ALL_DOWNLOADED", String(describing: p1), fallback: "All %@ downloaded")
      }
      /// %@ available
      public static func available(_ p1: Any) -> String {
        return DownloadsLocalization.tr("Localizable", "DOWNLOADS.CELL.AVAILABLE", String(describing: p1), fallback: "%@ available")
      }
      /// Download course
      public static let downloadCourse = DownloadsLocalization.tr("Localizable", "DOWNLOADS.CELL.DOWNLOAD_COURSE", fallback: "Download course")
      /// Download %@
      public static func downloadSize(_ p1: Any) -> String {
        return DownloadsLocalization.tr("Localizable", "DOWNLOADS.CELL.DOWNLOAD_SIZE", String(describing: p1), fallback: "Download %@")
      }
      /// %@ downloaded
      public static func downloaded(_ p1: Any) -> String {
        return DownloadsLocalization.tr("Localizable", "DOWNLOADS.CELL.DOWNLOADED", String(describing: p1), fallback: "%@ downloaded")
      }
      /// Downloading
      public static let downloading = DownloadsLocalization.tr("Localizable", "DOWNLOADS.CELL.DOWNLOADING", fallback: "Downloading")
    }
    public enum NoCoursesToDownload {
      /// You currently have no courses with downloadable content.
      public static let description = DownloadsLocalization.tr("Localizable", "DOWNLOADS.NO_COURSES_TO_DOWNLOAD.DESCRIPTION", fallback: "You currently have no courses with downloadable content.")
      /// No Courses with Downloadable Content
      public static let title = DownloadsLocalization.tr("Localizable", "DOWNLOADS.NO_COURSES_TO_DOWNLOAD.TITLE", fallback: "No Courses with Downloadable Content")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension DownloadsLocalization {
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

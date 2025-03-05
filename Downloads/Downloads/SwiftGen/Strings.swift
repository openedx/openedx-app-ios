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
    public enum Alert {
      /// Accept
      public static let accept = DownloadsLocalization.tr("Localizable", "DOWNLOADS.ALERT.ACCEPT", fallback: "Accept")
      /// Cancel
      public static let cancel = DownloadsLocalization.tr("Localizable", "DOWNLOADS.ALERT.CANCEL", fallback: "Cancel")
      /// This content requires %@ of storage space and you're using cellular data. Additional charges may apply.
      public static func confirmDownloadCellularDescription(_ p1: Any) -> String {
        return DownloadsLocalization.tr("Localizable", "DOWNLOADS.ALERT.CONFIRM_DOWNLOAD_CELLULAR_DESCRIPTION", String(describing: p1), fallback: "This content requires %@ of storage space and you're using cellular data. Additional charges may apply.")
      }
      /// Download Using Cellular Data?
      public static let confirmDownloadCellularTitle = DownloadsLocalization.tr("Localizable", "DOWNLOADS.ALERT.CONFIRM_DOWNLOAD_CELLULAR_TITLE", fallback: "Download Using Cellular Data?")
      /// This content requires %@ of storage space. Do you want to download it?
      public static func confirmDownloadDescription(_ p1: Any) -> String {
        return DownloadsLocalization.tr("Localizable", "DOWNLOADS.ALERT.CONFIRM_DOWNLOAD_DESCRIPTION", String(describing: p1), fallback: "This content requires %@ of storage space. Do you want to download it?")
      }
      /// Download Content?
      public static let confirmDownloadTitle = DownloadsLocalization.tr("Localizable", "DOWNLOADS.ALERT.CONFIRM_DOWNLOAD_TITLE", fallback: "Download Content?")
      /// Download
      public static let download = DownloadsLocalization.tr("Localizable", "DOWNLOADS.ALERT.DOWNLOAD", fallback: "Download")
      /// This download contains large video files. Are you sure you want to download them?
      public static let downloadLargeFileMessage = DownloadsLocalization.tr("Localizable", "DOWNLOADS.ALERT.DOWNLOAD_LARGE_FILE_MESSAGE", fallback: "This download contains large video files. Are you sure you want to download them?")
      /// OK
      public static let ok = DownloadsLocalization.tr("Localizable", "DOWNLOADS.ALERT.OK", fallback: "OK")
      /// Remove
      public static let remove = DownloadsLocalization.tr("Localizable", "DOWNLOADS.ALERT.REMOVE", fallback: "Remove")
      /// Removing this content will free up %@.
      public static func removeDescription(_ p1: Any) -> String {
        return DownloadsLocalization.tr("Localizable", "DOWNLOADS.ALERT.REMOVE_DESCRIPTION", String(describing: p1), fallback: "Removing this content will free up %@.")
      }
      /// Remove Offline Content?
      public static let removeTitle = DownloadsLocalization.tr("Localizable", "DOWNLOADS.ALERT.REMOVE_TITLE", fallback: "Remove Offline Content?")
      /// Your device does not have enough free space to download this content. Please free up some space and try again.
      public static let storageAlertDescription = DownloadsLocalization.tr("Localizable", "DOWNLOADS.ALERT.STORAGE_ALERT_DESCRIPTION", fallback: "Your device does not have enough free space to download this content. Please free up some space and try again.")
      /// Device Storage Full
      public static let storageAlertTitle = DownloadsLocalization.tr("Localizable", "DOWNLOADS.ALERT.STORAGE_ALERT_TITLE", fallback: "Device Storage Full")
      /// %@ used, %@ free
      public static func storageAlertUsedAndFree(_ p1: Any, _ p2: Any) -> String {
        return DownloadsLocalization.tr("Localizable", "DOWNLOADS.ALERT.STORAGE_ALERT_USED_AND_FREE", String(describing: p1), String(describing: p2), fallback: "%@ used, %@ free")
      }
      /// Warning
      public static let warning = DownloadsLocalization.tr("Localizable", "DOWNLOADS.ALERT.WARNING", fallback: "Warning")
    }
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
    public enum Error {
      /// Unfortunately, this content failed to download. Please try again later or report this issue.
      public static let downloadFailedDescription = DownloadsLocalization.tr("Localizable", "DOWNLOADS.ERROR.DOWNLOAD_FAILED_DESCRIPTION", fallback: "Unfortunately, this content failed to download. Please try again later or report this issue.")
      /// Download Failed
      public static let downloadFailedTitle = DownloadsLocalization.tr("Localizable", "DOWNLOADS.ERROR.DOWNLOAD_FAILED_TITLE", fallback: "Download Failed")
      /// Downloading this content requires an active internet connection. Please connect to the internet and try again.
      public static let noInternetConnectionDescription = DownloadsLocalization.tr("Localizable", "DOWNLOADS.ERROR.NO_INTERNET_CONNECTION_DESCRIPTION", fallback: "Downloading this content requires an active internet connection. Please connect to the internet and try again.")
      /// No Internet Connection
      public static let noInternetConnectionTitle = DownloadsLocalization.tr("Localizable", "DOWNLOADS.ERROR.NO_INTERNET_CONNECTION_TITLE", fallback: "No Internet Connection")
      /// You appear to have a slow or no internet connection. Please check your connection and try again.
      public static let slowOrNoInternetConnection = DownloadsLocalization.tr("Localizable", "DOWNLOADS.ERROR.SLOW_OR_NO_INTERNET_CONNECTION", fallback: "You appear to have a slow or no internet connection. Please check your connection and try again.")
      /// An unknown error occurred. Please try again later.
      public static let unknownError = DownloadsLocalization.tr("Localizable", "DOWNLOADS.ERROR.UNKNOWN_ERROR", fallback: "An unknown error occurred. Please try again later.")
      /// WiFi connection is required to download this content.
      public static let wifi = DownloadsLocalization.tr("Localizable", "DOWNLOADS.ERROR.WIFI", fallback: "WiFi connection is required to download this content.")
      /// Downloading this content requires an active WiFi connection. Please connect to a WiFi network and try again.
      public static let wifiRequiredDescription = DownloadsLocalization.tr("Localizable", "DOWNLOADS.ERROR.WIFI_REQUIRED_DESCRIPTION", fallback: "Downloading this content requires an active WiFi connection. Please connect to a WiFi network and try again.")
      /// Wi-Fi Required
      public static let wifiRequiredTitle = DownloadsLocalization.tr("Localizable", "DOWNLOADS.ERROR.WIFI_REQUIRED_TITLE", fallback: "Wi-Fi Required")
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

// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif
#if canImport(SwiftUI)
  import SwiftUI
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
public typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
public typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
public enum CoreAssets {
  public static let calendarAccess = ImageAsset(name: "calendarAccess")
  public static let syncFailed = ImageAsset(name: "syncFailed")
  public static let syncOffline = ImageAsset(name: "syncOffline")
  public static let synced = ImageAsset(name: "synced")
  public static let appleButtonColor = ColorAsset(name: "AppleButtonColor")
  public static let facebookButtonColor = ColorAsset(name: "FacebookButtonColor")
  public static let googleButtonColor = ColorAsset(name: "GoogleButtonColor")
  public static let microsoftButtonColor = ColorAsset(name: "MicrosoftButtonColor")
  public static let assignmentIcon = ImageAsset(name: "assignment_icon")
  public static let calendarIcon = ImageAsset(name: "calendar_icon")
  public static let certificateIcon = ImageAsset(name: "certificate_icon")
  public static let lockIcon = ImageAsset(name: "lock_icon")
  public static let lockWithWatchIcon = ImageAsset(name: "lock_with_watch_icon")
  public static let schoolCapIcon = ImageAsset(name: "school_cap_icon")
  public static let syncToCalendar = ImageAsset(name: "sync_to_calendar")
  public static let dates = ImageAsset(name: "dates")
  public static let discussions = ImageAsset(name: "discussions")
  public static let downloads = ImageAsset(name: "downloads")
  public static let home = ImageAsset(name: "home")
  public static let more = ImageAsset(name: "more")
  public static let noVideos = ImageAsset(name: "noVideos")
  public static let videos = ImageAsset(name: "videos")
  public static let dashboardEmptyPage = ImageAsset(name: "DashboardEmptyPage")
  public static let addComment = ImageAsset(name: "addComment")
  public static let allPosts = ImageAsset(name: "allPosts")
  public static let chapter = ImageAsset(name: "chapter")
  public static let discussion = ImageAsset(name: "discussion")
  public static let discussionIcon = ImageAsset(name: "discussionIcon")
  public static let extra = ImageAsset(name: "extra")
  public static let filter = ImageAsset(name: "filter")
  public static let finished = ImageAsset(name: "finished")
  public static let followed = ImageAsset(name: "followed")
  public static let pen = ImageAsset(name: "pen")
  public static let question = ImageAsset(name: "question")
  public static let report = ImageAsset(name: "report")
  public static let reported = ImageAsset(name: "reported")
  public static let responses = ImageAsset(name: "responses")
  public static let send = ImageAsset(name: "send")
  public static let sendDisabled = ImageAsset(name: "sendDisabled")
  public static let sort = ImageAsset(name: "sort")
  public static let unread = ImageAsset(name: "unread")
  public static let video = ImageAsset(name: "video")
  public static let vote = ImageAsset(name: "vote")
  public static let voted = ImageAsset(name: "voted")
  public static let deleteDownloading = ImageAsset(name: "deleteDownloading")
  public static let startDownloading = ImageAsset(name: "startDownloading")
  public static let stopDownloading = ImageAsset(name: "stopDownloading")
  public static let announcements = ImageAsset(name: "announcements")
  public static let handouts = ImageAsset(name: "handouts")
  public static let noAnnouncements = ImageAsset(name: "noAnnouncements")
  public static let noHandouts = ImageAsset(name: "noHandouts")
  public static let dashboard = ImageAsset(name: "dashboard")
  public static let discover = ImageAsset(name: "discover")
  public static let learnActive = ImageAsset(name: "learn_active")
  public static let learnInactive = ImageAsset(name: "learn_inactive")
  public static let profileActive = ImageAsset(name: "profile_active")
  public static let profileInactive = ImageAsset(name: "profile_inactive")
  public static let programs = ImageAsset(name: "programs")
  public static let addPhoto = ImageAsset(name: "addPhoto")
  public static let checkmark = ImageAsset(name: "checkmark")
  public static let deleteAccount = ImageAsset(name: "deleteAccount")
  public static let deleteChar = ImageAsset(name: "delete_char")
  public static let done = ImageAsset(name: "done")
  public static let gallery = ImageAsset(name: "gallery")
  public static let leaveProfile = ImageAsset(name: "leaveProfile")
  public static let logOut = ImageAsset(name: "logOut")
  public static let noAvatar = ImageAsset(name: "noAvatar")
  public static let removePhoto = ImageAsset(name: "removePhoto")
  public static let iconApple = ImageAsset(name: "icon_apple")
  public static let iconFacebookWhite = ImageAsset(name: "icon_facebook_white")
  public static let iconGoogleWhite = ImageAsset(name: "icon_google_white")
  public static let iconMicrosoftWhite = ImageAsset(name: "icon_microsoft_white")
  public static let rotateDevice = ImageAsset(name: "rotateDevice")
  public static let sub = ImageAsset(name: "sub")
  public static let alarm = ImageAsset(name: "alarm")
  public static let arrowLeft = ImageAsset(name: "arrowLeft")
  public static let arrowRight16 = ImageAsset(name: "arrowRight16")
  public static let calendarSyncIcon = ImageAsset(name: "calendarSyncIcon")
  public static let certificate = ImageAsset(name: "certificate")
  public static let certificateBadge = ImageAsset(name: "certificateBadge")
  public static let check = ImageAsset(name: "check")
  public static let checkEmail = ImageAsset(name: "checkEmail")
  public static let checkCircle = ImageAsset(name: "check_circle")
  public static let chevronRight = ImageAsset(name: "chevron_right")
  public static let clearInput = ImageAsset(name: "clearInput")
  public static let download = ImageAsset(name: "download")
  public static let edit = ImageAsset(name: "edit")
  public static let favorite = ImageAsset(name: "favorite")
  public static let finishedSequence = ImageAsset(name: "finished_sequence")
  public static let goodWork = ImageAsset(name: "goodWork")
  public static let information = ImageAsset(name: "information")
  public static let learnEmpty = ImageAsset(name: "learn_empty")
  public static let airmail = ImageAsset(name: "airmail")
  public static let defaultMail = ImageAsset(name: "defaultMail")
  public static let fastmail = ImageAsset(name: "fastmail")
  public static let googlegmail = ImageAsset(name: "googlegmail")
  public static let msOutlook = ImageAsset(name: "ms-outlook")
  public static let proton = ImageAsset(name: "proton")
  public static let readdleSpark = ImageAsset(name: "readdle-spark")
  public static let ymail = ImageAsset(name: "ymail")
  public static let noCourseImage = ImageAsset(name: "noCourseImage")
  public static let noWifi = ImageAsset(name: "noWifi")
  public static let noWifiMini = ImageAsset(name: "noWifiMini")
  public static let notAvaliable = ImageAsset(name: "notAvaliable")
  public static let playVideo = ImageAsset(name: "playVideo")
  public static let remove = ImageAsset(name: "remove")
  public static let reportOctagon = ImageAsset(name: "report_octagon")
  public static let resumeCourse = ImageAsset(name: "resumeCourse")
  public static let settings = ImageAsset(name: "settings")
  public static let star = ImageAsset(name: "star")
  public static let starOutline = ImageAsset(name: "star_outline")
  public static let viewAll = ImageAsset(name: "viewAll")
  public static let visibility = ImageAsset(name: "visibility")
  public static let warning = ImageAsset(name: "warning")
  public static let warningFilled = ImageAsset(name: "warning_filled")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

public final class ColorAsset: Sendable {
  public let name: String

  #if os(macOS)
  public typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  public let color: Color

  #if os(iOS) || os(tvOS)
  @available(iOS 11.0, tvOS 11.0, *)
  public func color(compatibleWith traitCollection: UITraitCollection) -> Color {
    let bundle = BundleToken.bundle
    guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  public var swiftUIColor: SwiftUI.Color {
    SwiftUI.Color(uiColor: color)
  }
  #endif

  fileprivate init(name: String) {
    self.name = name
    guard let color = Color(assetName: name) else {
      fatalError("Unable to load color asset named \(name).")
    }
    self.color = color
  }
}

public extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(assetName: String) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: assetName, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(assetName), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: assetName)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
public extension SwiftUI.Color {
  init(assetName: String) {
    let bundle = BundleToken.bundle
    self.init(assetName, bundle: bundle)
  }
}
#endif

public struct ImageAsset: Sendable {
  public let name: String

  #if os(macOS)
  public typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
  public var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if os(iOS) || os(tvOS)
  @available(iOS 8.0, tvOS 9.0, *)
  public func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  public var swiftUIImage: SwiftUI.Image {
    SwiftUI.Image(asset: self)
  }
  #endif
}

public extension ImageAsset.Image {
  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
public extension SwiftUI.Image {
  init(asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }

  init(asset: ImageAsset, label: Text) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle, label: label)
  }

  init(decorative asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(decorative: asset.name, bundle: bundle)
  }
}
#endif

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

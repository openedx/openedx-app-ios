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
public enum ThemeAssets {
  public static let accentButtonColor = ColorAsset(name: "AccentButtonColor")
  public static let accentColor = ColorAsset(name: "AccentColor")
  public static let accentXColor = ColorAsset(name: "AccentXColor")
  public static let alert = ColorAsset(name: "Alert")
  public static let avatarStroke = ColorAsset(name: "AvatarStroke")
  public static let background = ColorAsset(name: "Background")
  public static let backgroundStroke = ColorAsset(name: "BackgroundStroke")
  public static let cardViewBackground = ColorAsset(name: "CardViewBackground")
  public static let cardViewStroke = ColorAsset(name: "CardViewStroke")
  public static let certificateForeground = ColorAsset(name: "CertificateForeground")
  public static let commentCellBackground = ColorAsset(name: "CommentCellBackground")
  public static let courseCardBackground = ColorAsset(name: "CourseCardBackground")
  public static let courseCardShadow = ColorAsset(name: "CourseCardShadow")
  public static let datesSectionBackground = ColorAsset(name: "DatesSectionBackground")
  public static let datesSectionStroke = ColorAsset(name: "DatesSectionStroke")
  public static let nextWeekTimelineColor = ColorAsset(name: "NextWeekTimelineColor")
  public static let thisWeekTimelineColor = ColorAsset(name: "ThisWeekTimelineColor")
  public static let todayTimelineColor = ColorAsset(name: "TodayTimelineColor")
  public static let upcomingTimelineColor = ColorAsset(name: "UpcomingTimelineColor")
  public static let pastDueTimelineColor = ColorAsset(name: "pastDueTimelineColor")
  public static let primaryHeaderColor = ColorAsset(name: "primaryHeaderColor")
  public static let secondaryHeaderColor = ColorAsset(name: "secondaryHeaderColor")
  public static let courseProgressBG = ColorAsset(name: "CourseProgressBG")
  public static let deleteAccountBG = ColorAsset(name: "DeleteAccountBG")
  public static let infoColor = ColorAsset(name: "InfoColor")
  public static let irreversibleAlert = ColorAsset(name: "IrreversibleAlert")
  public static let loginBackground = ColorAsset(name: "LoginBackground")
  public static let loginNavigationText = ColorAsset(name: "LoginNavigationText")
  public static let primaryButtonTextColor = ColorAsset(name: "PrimaryButtonTextColor")
  public static let primaryCardCautionBG = ColorAsset(name: "PrimaryCardCautionBG")
  public static let primaryCardCourseUpgradeBG = ColorAsset(name: "PrimaryCardCourseUpgradeBG")
  public static let primaryCardProgressBG = ColorAsset(name: "PrimaryCardProgressBG")
  public static let onProgress = ColorAsset(name: "OnProgress")
  public static let progressDone = ColorAsset(name: "ProgressDone")
  public static let progressSkip = ColorAsset(name: "ProgressSkip")
  public static let selectedAndDone = ColorAsset(name: "SelectedAndDone")
  public static let resumeButtonBG = ColorAsset(name: "ResumeButtonBG")
  public static let resumeButtonText = ColorAsset(name: "ResumeButtonText")
  public static let secondaryButtonBGColor = ColorAsset(name: "SecondaryButtonBGColor")
  public static let secondaryButtonBorderColor = ColorAsset(name: "SecondaryButtonBorderColor")
  public static let secondaryButtonTextColor = ColorAsset(name: "SecondaryButtonTextColor")
  public static let shadowColor = ColorAsset(name: "ShadowColor")
  public static let slidingSelectedTextColor = ColorAsset(name: "slidingSelectedTextColor")
  public static let slidingStrokeColor = ColorAsset(name: "slidingStrokeColor")
  public static let slidingTextColor = ColorAsset(name: "slidingTextColor")
  public static let snackbarErrorColor = ColorAsset(name: "SnackbarErrorColor")
  public static let snackbarInfoColor = ColorAsset(name: "SnackbarInfoColor")
  public static let snackbarTextColor = ColorAsset(name: "SnackbarTextColor")
  public static let snackbarWarningColor = ColorAsset(name: "SnackbarWarningColor")
  public static let styledButtonText = ColorAsset(name: "StyledButtonText")
  public static let disabledButton = ColorAsset(name: "disabledButton")
  public static let disabledButtonText = ColorAsset(name: "disabledButtonText")
  public static let success = ColorAsset(name: "Success")
  public static let tabbarActiveColor = ColorAsset(name: "TabbarActiveColor")
  public static let tabbarBGColor = ColorAsset(name: "TabbarBGColor")
  public static let tabbarInactiveColor = ColorAsset(name: "TabbarInactiveColor")
  public static let textPrimary = ColorAsset(name: "TextPrimary")
  public static let textSecondary = ColorAsset(name: "TextSecondary")
  public static let textSecondaryLight = ColorAsset(name: "TextSecondaryLight")
  public static let textInputBackground = ColorAsset(name: "TextInputBackground")
  public static let textInputPlaceholderColor = ColorAsset(name: "TextInputPlaceholderColor")
  public static let textInputStroke = ColorAsset(name: "TextInputStroke")
  public static let textInputTextColor = ColorAsset(name: "TextInputTextColor")
  public static let textInputUnfocusedBackground = ColorAsset(name: "TextInputUnfocusedBackground")
  public static let textInputUnfocusedStroke = ColorAsset(name: "TextInputUnfocusedStroke")
  public static let toggleSwitchColor = ColorAsset(name: "ToggleSwitchColor")
  public static let navigationBarTintColor = ColorAsset(name: "navigationBarTintColor")
  public static let shade = ColorAsset(name: "shade")
  public static let warning = ColorAsset(name: "warning")
  public static let warningText = ColorAsset(name: "warningText")
  public static let white = ColorAsset(name: "white")
  public static let appLogo = ImageAsset(name: "appLogo")
  public static let headerBackground = ImageAsset(name: "headerBackground")
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

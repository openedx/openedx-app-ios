//
//  LMSThemeApplier.swift
//  Authorization
//
//  Created by Ivan Stepanok on 20.08.2026.
//

import Core
import Kingfisher
import SwiftUI
import Theme
import UIKit

enum LMSThemeApplier {

    /// Warm every image the directory will ask for, before any screen asks for it.
    ///
    /// The whole directory arrives in one document, so the sign-in background of a
    /// platform is known long before the learner picks it. Fetching it now is what
    /// removes the visible pop-in later: by the time the sign-in screen is built,
    /// the image is already decoded in Kingfisher's cache.
    static func prefetch(_ sources: [LMSImageSource]) {
        let urls = sources.compactMap(\.remoteURL)
        guard !urls.isEmpty else { return }
        ImagePrefetcher(urls: urls).start()
    }

    /// Put the selected platform's sign-in background where `LmsHeaderBackground`
    /// can draw it in its first frame.
    ///
    /// Handing over a decoded image rather than a URL is the whole point: a view
    /// that resolves a URL has to render something else first, and that flash is
    /// what this removes. A bundled image is read straight from the app; a remote
    /// one comes from Kingfisher's cache when it was prefetched, and is fetched
    /// here when it was not.
    static func applyLoginBackground(_ source: LMSImageSource?) {
        guard let source else {
            Theme.Images.update(headerBackground: nil)
            return
        }
        if let bundled = source.bundledImage() {
            Theme.Images.update(headerBackground: bundled)
            return
        }
        guard let url = source.remoteURL else {
            Theme.Images.update(headerBackground: nil)
            return
        }
        KingfisherManager.shared.retrieveImage(with: url) { result in
            let image = try? result.get().image
            Task { @MainActor in
                Theme.Images.update(headerBackground: image)
            }
        }
    }
    static func applyAccentColor(_ color: LMSColor?, darkColor: LMSColor? = nil) {
        guard let color else {
            Theme.Colors.update()
            Theme.UIColors.update()
            return
        }

        let base = color.uiColor
        let lightAccent = base.ensuringBrightness(min: 0.35)
        let darkAccent: UIColor
        if let darkColor {
            darkAccent = darkColor.uiColor
        } else {
            darkAccent = base
                .adjustingSaturation(multiplier: 0.8)
                .ensuringBrightness(min: 0.45, max: 0.85)
        }

        let accentDynamicColor = dynamicColor(light: lightAccent, dark: darkAccent)
        let accentDynamicUIColor = dynamicUIColor(light: lightAccent, dark: darkAccent)

        let buttonBackground = dynamicColor(
            light: lightAccent.blending(with: .white, amount: 0.25),
            dark: darkAccent.blending(with: .black, amount: 0.15)
        )

        let deleteAccountBackground = dynamicColor(
            light: lightAccent.withAlphaComponent(0.15),
            dark: darkAccent.withAlphaComponent(0.2)
        )

        let resumeBackground = dynamicColor(
            light: lightAccent.blending(with: .white, amount: 0.4),
            dark: darkAccent.blending(with: .white, amount: 0.25)
        )

        let socialAuthColor = dynamicColor(
            light: lightAccent.blending(with: .white, amount: 0.2),
            dark: darkAccent
        )

        let slidingStroke = dynamicColor(
            light: lightAccent.blending(with: .white, amount: 0.45),
            dark: ThemeAssets.slidingStrokeColor.color
        )

        let slidingText = dynamicColor(
            light: lightAccent.blending(with: .white, amount: 0.65),
            dark: ThemeAssets.slidingTextColor.color
        )

        Theme.Colors.update(
            accentColor: accentDynamicColor,
            accentXColor: accentDynamicColor,
            accentButtonColor: buttonBackground,
            secondaryButtonBorderColor: accentDynamicColor,
            secondaryButtonTextColor: accentDynamicColor,
            toggleSwitchColor: accentDynamicColor,
            infoColor: accentDynamicColor,
            deleteAccountBG: deleteAccountBackground,
            resumeButtonBG: resumeBackground,
            socialAuthColor: socialAuthColor,
            slidingTextColor: slidingText,
            slidingStrokeColor: slidingStroke
        )

        Theme.UIColors.update(
            accentColor: accentDynamicUIColor,
            accentXColor: accentDynamicUIColor
        )
    }

    private static func dynamicColor(light: UIColor, dark: UIColor) -> Color {
        Color(dynamicUIColor(light: light, dark: dark))
    }

    private static func dynamicUIColor(light: UIColor, dark: UIColor) -> UIColor {
        UIColor { trait in
            trait.userInterfaceStyle == .dark ? dark : light
        }
    }
}

private extension LMSColor {
    var uiColor: UIColor {
        UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
}

private extension UIColor {
    func ensuringBrightness(min: CGFloat? = nil, max: CGFloat? = nil) -> UIColor {
        var hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0, alpha: CGFloat = 0
        guard getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) else {
            return self
        }
        if let min, brightness < min {
            brightness = min
        }
        if let max, brightness > max {
            brightness = max
        }
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }

    func adjustingSaturation(multiplier: CGFloat) -> UIColor {
        var hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0, alpha: CGFloat = 0
        guard getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) else {
            return self
        }
        saturation = min(max(saturation * multiplier, 0), 1)
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }

    func blending(with color: UIColor, amount: CGFloat) -> UIColor {
        let amount = min(max(amount, 0), 1)
        var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0
        var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0
        getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        return UIColor(
            red: r1 * (1 - amount) + r2 * amount,
            green: g1 * (1 - amount) + g2 * amount,
            blue: b1 * (1 - amount) + b2 * amount,
            alpha: a1 * (1 - amount) + a2 * amount
        )
    }
}

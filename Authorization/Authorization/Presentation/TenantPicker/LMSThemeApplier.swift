import SwiftUI
import Theme
import UIKit

enum LMSThemeApplier {
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

        // Upstream Theme.Colors.update(...) defaults every parameter, so we override
        // only the accent-driven colors and leave everything else at the stock theme.
        Theme.Colors.update(
            accentColor: accentDynamicColor,
            accentXColor: accentDynamicColor,
            secondaryButtonBorderColor: accentDynamicColor,
            secondaryButtonTextColor: accentDynamicColor,
            toggleSwitchColor: accentDynamicColor,
            infoColor: accentDynamicColor
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

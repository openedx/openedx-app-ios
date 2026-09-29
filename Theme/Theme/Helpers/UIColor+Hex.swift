//
//  UIColor+Hex.swift
//  Theme
//
//  Created by Rawan Matar on 22/09/2026.
//

import UIKit

extension UIColor {
    /// Parses a "#RRGGBB"/"RRGGBB" or "#RRGGBBAA"/"RRGGBBAA" hex string. `nil` on anything
    /// else -- used for instance-supplied accent colors, which aren't guaranteed well-formed.
    public convenience init?(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if hexString.hasPrefix("#") { hexString.removeFirst() }
        guard hexString.count == 6 || hexString.count == 8, let value = UInt64(hexString, radix: 16) else {
            return nil
        }

        let hasAlpha = hexString.count == 8
        let red, green, blue, alpha: UInt64
        if hasAlpha {
            red = (value >> 24) & 0xFF
            green = (value >> 16) & 0xFF
            blue = (value >> 8) & 0xFF
            alpha = value & 0xFF
        } else {
            red = (value >> 16) & 0xFF
            green = (value >> 8) & 0xFF
            blue = value & 0xFF
            alpha = 0xFF
        }

        self.init(
            red: CGFloat(red) / 255,
            green: CGFloat(green) / 255,
            blue: CGFloat(blue) / 255,
            alpha: CGFloat(alpha) / 255
        )
    }
}

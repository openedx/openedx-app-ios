//
//  CGColorExtension.swift
//  Core
//
//  Created by  Stepanok Ivan on 03.03.2023.
//

import Foundation
import SwiftUI

public extension CGColor {
    var hexString: String? {
        guard let components = self.components, components.count >= 3 else {
            return nil
        }
        let red = components[0]
        let green = components[1]
        let blue = components[2]
        let hexString = String(
            format: "#%02lX%02lX%02lX",
            lroundf(Float(red * 255)),
            lroundf(Float(green * 255)),
            lroundf(Float(blue * 255))
        )
        return hexString
    }
}

//
//  CSSInjector.swift
//  Core
//
//  Created by  Stepanok Ivan on 14.11.2022.
//

import Foundation
import SwiftUI
import Theme

public class CSSInjector {
    
    public let baseURL: URL
    
    public init(config: ConfigProtocol) {
        self.baseURL = config.baseURL
    }
    
    public enum CssType {
        case discovery
        case comment
    }
    
    func invertHexColor(hexColor: String) -> String? {
        var hex = hexColor.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        if hex.hasPrefix("#") {
            hex.remove(at: hex.startIndex)
        }

        var rgbValue: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgbValue)
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1.0)

        let ciColor = CIColor(color: color)

        let invertedColor = CIColor(red: 1 - ciColor.red, green: 1 - ciColor.green, blue: 1 - ciColor.blue)

        let invertedCGColor = UIColor(ciColor: invertedColor).cgColor
        let invertedColorCode = invertedCGColor.converted(to: CGColorSpaceCreateDeviceRGB(),
                                                          intent: .defaultIntent,
                                                          options: nil)?.hexString
        return invertedColorCode
    }

    func replaceHexColorsInHTML(html: String) -> String {
        do {
            let regex = try NSRegularExpression(pattern: "#[0-9a-fA-F]{6}")
            let range = NSRange(html.startIndex..<html.endIndex, in: html)
            let matches = regex.matches(in: html, range: range)

            var invertedHTML = html
            for match in matches.reversed() {
                let hexColorRange = Range(match.range, in: html)!
                let hexColor = String(html[hexColorRange])
                guard let invertedHexColor = invertHexColor(hexColor: hexColor) else {
                    continue
                }
                invertedHTML.replaceSubrange(hexColorRange, with: invertedHexColor)
            }

            return invertedHTML
        } catch {
            print("Error replacing hex colors: \(error)")
            return html
        }
    }

    //swiftlint:disable line_length
    public func injectCSS(
        colorScheme: ColorScheme,
        html: String,
        type: CssType,
        fontSize: Int = 150,
        screenWidth: CGFloat
    ) -> String {
        let meadiaReplace = html.replacingOccurrences(
            of: "/media/",
            with: baseURL.absoluteString + "/media/"
        )
        var replacedHTML = meadiaReplace.replacingOccurrences(
            of: "../..",
            with: baseURL.absoluteString
        ).replacingOccurrences(of: "src=\"/", with: "src=\"" + baseURL.absoluteString + "/")
            .replacingOccurrences(of: "href=\"/", with: "href=\"" + baseURL.absoluteString + "/")
            .replacingOccurrences(of: "href='/honor'", with: "href='\(baseURL.absoluteString)/honor'")
            .replacingOccurrences(of: "href='/privacy'", with: "href='\(baseURL.absoluteString)/privacy'")
        if colorScheme == .dark {
            replacedHTML = replaceHexColorsInHTML(html: replacedHTML)
        }
        
        var maxWidth: String
        switch type {
        case .discovery:
            if screenWidth == .infinity {
                maxWidth = "max-width: 100%;"
            } else {
                maxWidth = "max-width: \(screenWidth)px;"
            }
        case .comment:
            if screenWidth == .infinity {
                maxWidth = "width: 100%;"
            } else {
                maxWidth = "width: \(screenWidth / 1.3)px;"
            }
        }
        
        func currentColor() -> String {
            switch colorScheme {
            case .light:
                return "black"
            case .dark:
                return "white"
            @unknown default:
                return "black"
            }
        }
        
        let style = """
        <style>
        a {
            text-decoration: none;
            color: \(Theme.UIColors.accentXColor.cgColor.hexString ?? "");
        }
        @font-face {
        font-family: "San Francisco";
        font-weight: 400;
        src: url("https://applesocial.s3.amazonaws.com/assets//fonts/sanfrancisco/sanfranciscodisplay-regular-webfont.woff");
        }
        .header {
        font-size: \(fontSize)%;
        font-family: -apple-system, system-ui, BlinkMacSystemFont;
          background-color: clear;
          color: \(currentColor());
        \(maxWidth)
        }
        img {\
        \(maxWidth)
          width: auto;
          height: auto;
        }
        </style>
        <table class="header" style="width:100%">
        <tr>
        <td>
        """
        return style + replacedHTML
    }
    //swiftlint:enable line_length
    
}

// Mark - For testing and SwiftUI preview
#if DEBUG
public class CSSInjectorMock: CSSInjector {
    public convenience init() {
        self.init(config: ConfigMock())
    }
}
#endif

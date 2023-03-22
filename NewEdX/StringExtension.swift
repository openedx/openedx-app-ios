//
//  StringExtension.swift
//  Core
//
//  Created by  Stepanok Ivan on 29.09.2022.
//

import Foundation
import SwiftUI
import Core
import Swinject

public extension String {
   public func injectCSS(colorScheme: ColorScheme) -> String {
        let baseUrl = Container.shared.resolve(Config.self)!.baseURL.absoluteString
        var replacedHTML = self.replacingOccurrences(of: "../..", with: baseUrl)
        
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
        @font-face {
        font-family: "San Francisco";
        font-weight: 400;
        src: url("https://applesocial.s3.amazonaws.com/assets//fonts/sanfrancisco/sanfranciscodisplay-regular-webfont.woff");
        }
        .header {
        font-size: 150%;
        font-family: -apple-system, system-ui, BlinkMacSystemFont;
          background-color: clear;
          color: \(currentColor());
          padding: 18px;
        
        }
        </style>
        <table class="header">
        <tr>
        <td>
        """
    print(">>>> STYLE", style)
        return style + replacedHTML
    }
}

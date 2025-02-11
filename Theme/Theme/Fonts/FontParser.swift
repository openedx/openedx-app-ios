//
//  FontParser.swift
//  Core
//
//  Created by SaeedBashir on 11/20/23.
//

import Foundation

public enum FontIdentifier: String, Sendable {
    case light, regular, medium, semiBold, bold
}

public struct FontParser: Sendable {
    private var fonts: [String: String] = [:]
    
    public init() {
        fonts = loadAndParseFonts()
    }
    
    private func loadAndParseFonts() -> [String: String] {
        if let path = Bundle(for: ThemeBundle.self).path(forResource: "fonts", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let fonts = jsonResult as? [String: String] {
                    return fonts
                }
            } catch {
                return fallbackFonts()
            }
        }
        return fallbackFonts()
    }
    
    @discardableResult public func fallbackFonts() -> [String: String] {
        return FontsDataFactory.fonts
    }
    
    public func fontName(for identiifer: FontIdentifier) -> String {
        guard let fontName = fonts[identiifer.rawValue] else {
            assert(false, "Could not find the required font in fonts.json")
            return FontIdentifier.regular.rawValue
        }
        
        return fontName
    }
}

struct FontsDataFactory {
    static let fonts: [String: String] = [
        "regular": "SFPro-Regular",
        "medium": "SFPro-Medium",
        "semiBold": "SFPro-Semibold",
        "bold": "SFPro-Bold"
    ]
}

public final class ThemeBundle {
    private init() {}
}

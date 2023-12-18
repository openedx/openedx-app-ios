//
//  FontParserTests.swift
//  ThemeTests
//
//  Created by SaeedBashir on 11/23/23.
//

import Foundation
import XCTest
@testable import Theme

class FontParserTests: XCTestCase {
    let fontParser = FontParser()
    
    func testFontFileExistence() {
        let filePath: String? = Bundle(for: ThemeBundle.self).path(forResource: "fonts", ofType: "json")
        XCTAssertNotNil(filePath)
        XCTAssertTrue(FileManager.default.fileExists(atPath: filePath ?? ""))
    }
    
    func testFontDataFactory() {
        fontParser.fallbackFonts()
        XCTAssertNotNil(fontParser.fontName(for: .regular))
    }
    
    func testFontParsing() {
        XCTAssertNotNil(fontParser.fontName(for: .regular))
        XCTAssertNotNil(fontParser.fontName(for: .medium))
        XCTAssertNotNil(fontParser.fontName(for: .semiBold))
        XCTAssertNotNil(fontParser.fontName(for: .bold))
    }
}

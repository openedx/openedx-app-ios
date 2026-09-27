//
//  UIColorHexTests.swift
//  ThemeTests
//
//  Created by Rawan Matar on 22/09/2026.
//

import XCTest
@testable import Theme

final class UIColorHexTests: XCTestCase {

    private func components(_ color: UIColor) -> (CGFloat, CGFloat, CGFloat, CGFloat) {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        return (r, g, b, a)
    }

    func test_sixDigitHex_withHash_parsesOpaque() {
        let color = UIColor(hex: "#FF0000")
        XCTAssertEqual(components(color!), (1, 0, 0, 1))
    }

    func test_sixDigitHex_withoutHash_parses() {
        XCTAssertNotNil(UIColor(hex: "00FF00"))
    }

    func test_eightDigitHex_parsesWithAlpha() {
        let color = UIColor(hex: "#0000FF80")
        let (_, _, b, a) = components(color!)
        XCTAssertEqual(b, 1)
        XCTAssertEqual(a, 128.0 / 255, accuracy: 0.01)
    }

    func test_malformedHex_returnsNil() {
        XCTAssertNil(UIColor(hex: "notacolor"))
        XCTAssertNil(UIColor(hex: "#FFF"))
        XCTAssertNil(UIColor(hex: ""))
    }
}

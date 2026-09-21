//
//  ThemeColorSetTests.swift
//  ThemeTests
//
//  Created by Rawan Matar on 31/08/2026.
//

import XCTest
import SwiftUI
@testable import Theme

final class ThemeColorSetTests: XCTestCase {

    /// Resolves a Color to "#RRGGBB" for a given appearance, for deterministic comparisons.
    private func hex(_ color: Color, style: UIUserInterfaceStyle = .light) -> String {
        let resolved = UIColor(color).resolvedColor(with: UITraitCollection(userInterfaceStyle: style))
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        resolved.getRed(&r, green: &g, blue: &b, alpha: &a)
        return String(format: "#%02X%02X%02X", Int((r * 255).rounded()), Int((g * 255).rounded()), Int((b * 255).rounded()))
    }

    func test_noPalette_matchesPlainHexDerivation() {
        let plain = ThemeColorSet.derived(fromHex: "#3E578C")
        let withEmptyPalette = ThemeColorSet.derived(fromHex: "#3E578C", light: [:], dark: [:])

        XCTAssertEqual(hex(plain.accentColor), hex(withEmptyPalette.accentColor))
        XCTAssertEqual(hex(plain.textPrimary), hex(withEmptyPalette.textPrimary))
    }

    func test_partialPalette_overridesOnlySetFields() {
        let baseline = ThemeColorSet.derived(fromHex: "#3E578C")
        let overridden = ThemeColorSet.derived(fromHex: "#3E578C", light: ["text_primary": "#18202E"])

        // The field the palette set changed to exactly that hex...
        XCTAssertEqual(hex(overridden.textPrimary), "#18202E")
        XCTAssertNotEqual(hex(overridden.textPrimary), hex(baseline.textPrimary))
        // ...but every other field is untouched.
        XCTAssertEqual(hex(baseline.accentColor), hex(overridden.accentColor))
        XCTAssertEqual(hex(baseline.background), hex(overridden.background))
    }

    func test_darkMissing_fallsBackToLightValue() {
        let set = ThemeColorSet.derived(fromHex: "#3E578C", light: ["alert": "#FF3D71"])

        XCTAssertEqual(hex(set.alert, style: .light), "#FF3D71")
        XCTAssertEqual(hex(set.alert, style: .dark), "#FF3D71")
    }

    func test_lightAndDarkDiffer_resolveIndependently() {
        let set = ThemeColorSet.derived(
            fromHex: "#3E578C",
            light: ["background": "#FFFFFF"],
            dark: ["background": "#0A0A0A"]
        )

        XCTAssertEqual(hex(set.background, style: .light), "#FFFFFF")
        XCTAssertEqual(hex(set.background, style: .dark), "#0A0A0A")
    }

    func test_unrecognizedKey_isIgnoredNotCrashing() {
        // Unmapped keys are silently skipped, not treated as an error.
        let baseline = ThemeColorSet.derived(fromHex: "#3E578C")
        let withUnknownKey = ThemeColorSet.derived(fromHex: "#3E578C", light: ["not_a_real_field": "#000000"])

        XCTAssertEqual(hex(baseline.accentColor), hex(withUnknownKey.accentColor))
        XCTAssertEqual(hex(baseline.textPrimary), hex(withUnknownKey.textPrimary))
    }
}

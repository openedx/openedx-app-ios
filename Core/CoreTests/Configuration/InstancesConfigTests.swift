//
//  InstancesConfigTests.swift
//  CoreTests
//

import XCTest
@testable import Core

class InstancesConfigTests: XCTestCase {

    private let requiredFields: [String: Any] = [
        "KEY": "test-instance",
        "NAME": "Test Instance",
        "INSTANCE_NAME": ["en": "Test Instance"],
        "OAUTH_CLIENT_ID": "client-id",
        "API_HOST_URL": "https://test-instance.example.com"
    ]

    func testInstanceLevelFieldsUseAppDefaultsWhenOmitted() {
        let instance = Instance(dictionary: requiredFields)

        XCTAssertEqual(instance?.tokenType, .jwt)
        XCTAssertEqual(instance?.discovery.type, .native)
        XCTAssertEqual(instance?.program.type, .native)
        XCTAssertNil(instance?.faq)
        XCTAssertEqual(instance?.dashboard.type, .gallery)
        XCTAssertEqual(instance?.isRoundedCorners, true)
        XCTAssertEqual(instance?.buttonCornersRadius, 8.0)
        XCTAssertEqual(instance?.features.whatNewEnabled, false)
    }

    func testPlatformNameDefaultsToInstanceNameWhenUnset() {
        let instance = Instance(dictionary: requiredFields)

        XCTAssertEqual(instance?.platformName, "Test Instance")
    }

    func testPlatformNameOverrideWins() {
        var dictionary = requiredFields
        dictionary["PLATFORM_NAME"] = "Custom Platform Name"

        let instance = Instance(dictionary: dictionary)

        XCTAssertEqual(instance?.platformName, "Custom Platform Name")
    }

    func testInstanceLevelFieldsParseWhenProvided() {
        var dictionary = requiredFields
        dictionary["TOKEN_TYPE"] = "BEARER"
        dictionary["FAQ_URL"] = "https://test-instance.example.com/faq"
        dictionary["WHATS_NEW_ENABLED"] = true
        dictionary["DISCOVERY"] = ["TYPE": "webview"]
        dictionary["PROGRAM"] = ["TYPE": "none"]
        dictionary["DASHBOARD"] = ["TYPE": "list"]
        dictionary["THEME"] = [
            "LIGHT": ["accent_color": "#3C68FF"],
            "DARK": ["accent_color": "#1C355E"],
            "ROUNDED_CORNERS_STYLE": false,
            "BUTTON_CORNERS_RADIUS": 4.0
        ]

        let instance = Instance(dictionary: dictionary)

        XCTAssertEqual(instance?.tokenType, .bearer)
        XCTAssertEqual(instance?.faq, URL(string: "https://test-instance.example.com/faq"))
        XCTAssertEqual(instance?.features.whatNewEnabled, true)
        XCTAssertEqual(instance?.discovery.type, .webview)
        XCTAssertEqual(instance?.program.type, DiscoveryConfigType.none)
        XCTAssertEqual(instance?.dashboard.type, .list)
        XCTAssertEqual(instance?.isRoundedCorners, false)
        XCTAssertEqual(instance?.buttonCornersRadius, 4.0)
    }
}

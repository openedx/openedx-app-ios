//
//  ConfigLMSDirectoryTests.swift
//  Core
//
//  Created by Ivan Stepanok on 20.08.2026.
//

import XCTest
@testable import Core

/// CoreTests
/// Regression coverage for the LMS Directory per-platform config overrides. When
/// the feature is on and a platform is selected, the app must talk to that LMS and
/// sign in with *its* OAuth client id / feedback email — not the baked-in config.
/// When the flag is off (default) the stock config values always win.
final class ConfigLMSDirectoryTests: XCTestCase {

    private let baseURLKey = "selectedLMSBaseURL"
    private let clientIdKey = "lmsDirectory.selected_oauth_client_id"
    private let feedbackKey = "lmsDirectory.selected_feedback_email"

    override func tearDown() {
        [baseURLKey, clientIdKey, feedbackKey].forEach {
            UserDefaults.standard.removeObject(forKey: $0)
        }
        super.tearDown()
    }

    private func makeConfig(enabled: Bool, directoryURL: String = "https://registry.example.com") -> Config {
        Config(properties: [
            "API_HOST_URL": "https://config-host.example.com",
            "OAUTH_CLIENT_ID": "config_client",
            "FEEDBACK_EMAIL_ADDRESS": "config@example.com",
            "TOKEN_TYPE": "JWT",
            "LMS_DIRECTORY": ["ENABLED": enabled, "DIRECTORY_URL": directoryURL]
        ])
    }

    func test_selectedLMSOverridesApplied_whenEnabled() {
        UserDefaults.standard.set("https://picked-lms.example.com", forKey: baseURLKey)
        UserDefaults.standard.set("picked_client", forKey: clientIdKey)
        UserDefaults.standard.set("picked@example.com", forKey: feedbackKey)

        let config = makeConfig(enabled: true)

        XCTAssertEqual(config.baseURL.absoluteString, "https://picked-lms.example.com")
        XCTAssertEqual(config.oAuthClientId, "picked_client")
        XCTAssertEqual(config.feedbackEmail, "picked@example.com")
    }

    func test_overridesIgnored_whenFeatureDisabled() {
        UserDefaults.standard.set("https://picked-lms.example.com", forKey: baseURLKey)
        UserDefaults.standard.set("picked_client", forKey: clientIdKey)
        UserDefaults.standard.set("picked@example.com", forKey: feedbackKey)

        let config = makeConfig(enabled: false)

        XCTAssertEqual(config.baseURL.absoluteString, "https://config-host.example.com")
        XCTAssertEqual(config.oAuthClientId, "config_client")
        XCTAssertEqual(config.feedbackEmail, "config@example.com")
    }

    func test_fallsBackToConfig_whenEnabledButNothingSelected() {
        let config = makeConfig(enabled: true)

        XCTAssertEqual(config.baseURL.absoluteString, "https://config-host.example.com")
        XCTAssertEqual(config.oAuthClientId, "config_client")
        XCTAssertEqual(config.feedbackEmail, "config@example.com")
    }

    // Misconfiguration guard: ENABLED=true but no DIRECTORY_URL means the catalog is
    // unreachable, so the app must NOT honor a stale persisted selection (no live
    // registry could have produced it). It must fail closed to the stock config values.
    func test_overridesIgnored_whenEnabledButDirectoryURLMissing() {
        UserDefaults.standard.set("https://picked-lms.example.com", forKey: baseURLKey)
        UserDefaults.standard.set("picked_client", forKey: clientIdKey)
        UserDefaults.standard.set("picked@example.com", forKey: feedbackKey)

        let config = makeConfig(enabled: true, directoryURL: "")

        XCTAssertFalse(config.lmsDirectory.isDirectoryReachable)
        XCTAssertEqual(config.baseURL.absoluteString, "https://config-host.example.com")
        XCTAssertEqual(config.oAuthClientId, "config_client")
        XCTAssertEqual(config.feedbackEmail, "config@example.com")
    }
}

//
//  InstanceAwareConfigTests.swift
//  CoreTests
//
//  Created by Rawan Matar on 22/09/2026.
//

import XCTest
@testable import Core

final class InstanceAwareConfigTests: XCTestCase {

    private func makeAppConfig() -> ConfigProtocolMock {
        let config = ConfigProtocolMock()
        config.baseURL = URL(string: "https://app.example.com")!
        config.oAuthClientId = "app-oauth-client-id"
        config.tokenType = .bearer
        config.feedbackEmail = "app-feedback@example.com"
        config.theme = ThemeConfig(dictionary: [:])
        config.experimentalFeatures = ExperimentalFeaturesConfig(dictionary: [:])
        config.uiComponents = UIComponentsConfig(dictionary: ["LOGIN_REGISTRATION_ENABLED": false as AnyObject])
        config.URIScheme = "app-scheme"
        return config
    }

    /// Builds an `Instance` from a raw dictionary (not `.mock()`, which only covers a handful
    /// of fields) so tests can exercise fields `.mock()` doesn't expose.
    private func makeInstance(_ overrides: [String: Any] = [:]) -> Instance {
        var dict: [String: Any] = [
            "NAME": "Acme",
            "API_HOST_URL": "https://acme.example.com",
            "OAUTH_CLIENT_ID": "acme-oauth-client-id"
        ]
        dict.merge(overrides) { _, override in override }
        return Instance(dictionary: dict)!
    }

    private func makeSUT(appConfig: ConfigProtocolMock, instance: Instance?) -> InstanceAwareConfig {
        InstanceAwareConfig(appConfig: appConfig, instanceProvider: InstanceProviderMock(currentInstance: instance))
    }

    // MARK: - No instance selected: everything falls back to app-level Config

    func test_noInstanceSelected_fallsBackToAppConfigThroughout() {
        let appConfig = makeAppConfig()
        let sut = makeSUT(appConfig: appConfig, instance: nil)

        XCTAssertEqual(sut.baseURL, appConfig.baseURL)
        XCTAssertEqual(sut.oAuthClientId, appConfig.oAuthClientId)
        XCTAssertEqual(sut.tokenType, appConfig.tokenType)
        XCTAssertEqual(sut.feedbackEmail, appConfig.feedbackEmail)
        XCTAssertEqual(sut.theme.isRoundedCorners, appConfig.theme.isRoundedCorners)
        XCTAssertEqual(
            sut.experimentalFeatures.appLevelDownloadsEnabled,
            appConfig.experimentalFeatures.appLevelDownloadsEnabled
        )
    }

    // MARK: - Instance selected: non-optional scalar fields always win

    func test_instanceSelected_overridesScalarFields() {
        let appConfig = makeAppConfig()
        let instance = makeInstance()
        let sut = makeSUT(appConfig: appConfig, instance: instance)

        XCTAssertEqual(sut.baseURL, instance.baseURL)
        XCTAssertEqual(sut.oAuthClientId, instance.oAuthClientId)
    }

    // MARK: - Instance selected but the field is optional-and-unset: falls back to app-level

    func test_instanceSelected_optionalFieldUnset_fallsBackToAppConfig() {
        let appConfig = makeAppConfig()
        let instance = makeInstance() // no FEEDBACK_EMAIL_ADDRESS key
        let sut = makeSUT(appConfig: appConfig, instance: instance)

        XCTAssertEqual(sut.feedbackEmail, appConfig.feedbackEmail)
    }

    func test_instanceSelected_optionalFieldSet_overridesAppConfig() {
        let appConfig = makeAppConfig()
        let instance = makeInstance(["FEEDBACK_EMAIL_ADDRESS": "acme-feedback@example.com"])
        let sut = makeSUT(appConfig: appConfig, instance: instance)

        XCTAssertEqual(sut.feedbackEmail, "acme-feedback@example.com")
    }

    // MARK: - theme: built from Instance's typed corner fields, not a straight `??`

    func test_theme_instanceOmitsThemeBlock_usesInstanceDefaults() {
        let appConfig = makeAppConfig()
        appConfig.theme = ThemeConfig(dictionary: ["ROUNDED_CORNERS_STYLE": false as AnyObject])
        let instance = makeInstance() // no THEME key -> Instance defaults: rounded=true, radius=8.0
        let sut = makeSUT(appConfig: appConfig, instance: instance)

        XCTAssertTrue(sut.theme.isRoundedCorners)
        XCTAssertEqual(sut.theme.buttonCornersRadius, 8.0)
    }

    func test_theme_instanceProvidesThemeBlock_overridesAppConfig() {
        let appConfig = makeAppConfig()
        let instance = makeInstance([
            "THEME": ["ROUNDED_CORNERS_STYLE": false, "BUTTON_CORNERS_RADIUS": 12.0]
        ])
        let sut = makeSUT(appConfig: appConfig, instance: instance)

        XCTAssertFalse(sut.theme.isRoundedCorners)
        XCTAssertEqual(sut.theme.buttonCornersRadius, 12.0)
    }

    func test_theme_noInstanceSelected_fallsBackToAppConfig() {
        let appConfig = makeAppConfig()
        appConfig.theme = ThemeConfig(dictionary: ["ROUNDED_CORNERS_STYLE": false as AnyObject])
        let sut = makeSUT(appConfig: appConfig, instance: nil)

        XCTAssertFalse(sut.theme.isRoundedCorners)
    }

    // MARK: - experimentalFeatures: nil (block omitted) falls back; present overrides

    func test_experimentalFeatures_instanceOmitsBlock_fallsBackToAppConfig() {
        let appConfig = makeAppConfig()
        appConfig.experimentalFeatures = ExperimentalFeaturesConfig(
            dictionary: ["APP_LEVEL_DOWNLOADS": ["ENABLED": true] as AnyObject]
        )
        let instance = makeInstance() // no EXPERIMENTAL_FEATURES key -> appLevelDownloadsEnabled == nil
        let sut = makeSUT(appConfig: appConfig, instance: instance)

        XCTAssertTrue(sut.experimentalFeatures.appLevelDownloadsEnabled)
    }

    func test_experimentalFeatures_instanceProvidesBlock_overridesAppConfig() {
        let appConfig = makeAppConfig()
        appConfig.experimentalFeatures = ExperimentalFeaturesConfig(
            dictionary: ["APP_LEVEL_DOWNLOADS": ["ENABLED": false] as AnyObject]
        )
        let instance = makeInstance([
            "EXPERIMENTAL_FEATURES": ["APP_LEVEL_DOWNLOADS": ["ENABLED": true]]
        ])
        let sut = makeSUT(appConfig: appConfig, instance: instance)

        XCTAssertTrue(sut.experimentalFeatures.appLevelDownloadsEnabled)
    }

    // MARK: - uiComponents: non-optional on Instance, so it always wins once selected --
    // even when the instance's own UI_COMPONENTS block is omitted (Instance's own defaults
    // apply). This is existing Instance-model behavior, not something InstanceAwareConfig
    // introduces.
    func test_uiComponents_instanceSelected_alwaysOverridesAppConfig() {
        let appConfig = makeAppConfig() // loginRegistrationEnabled: false
        let instance = makeInstance() // no UI_COMPONENTS key -> Instance's own default: true
        let sut = makeSUT(appConfig: appConfig, instance: instance)

        XCTAssertTrue(sut.uiComponents.loginRegistrationEnabled)
    }

    // MARK: - App-level-only fields: never sourced from the instance, even when one is selected

    func test_appLevelOnlyField_neverUsesInstance() {
        let appConfig = makeAppConfig()
        let instance = makeInstance()
        let sut = makeSUT(appConfig: appConfig, instance: instance)

        XCTAssertEqual(sut.URIScheme, appConfig.URIScheme)
    }
}

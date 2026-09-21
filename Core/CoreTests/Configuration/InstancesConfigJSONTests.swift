//
//  InstancesConfigJSONTests.swift
//  CoreTests
//
//  Created by Rawan Matar on 31/08/2026.
//

import XCTest
@testable import Core

final class InstancesConfigJSONTests: XCTestCase {

    func test_bareArrayShape_parsesInstances() throws {
        let json = """
        [
            {
                "KEY": "acme",
                "NAME": "Acme",
                "INSTANCE_NAME": { "en": "Acme University" },
                "COLOR": "#112233",
                "OAUTH_CLIENT_ID": "acme-client-id",
                "API_HOST_URL": "https://acme.example.com"
            }
        ]
        """.data(using: .utf8)!

        let config = try InstancesConfig(jsonData: json)

        XCTAssertEqual(config.instances.count, 1)
        XCTAssertEqual(config.instance(withKey: "acme")?.oAuthClientId, "acme-client-id")
        XCTAssertEqual(config.instance(withKey: "acme")?.baseURL.absoluteString, "https://acme.example.com")
    }

    func test_instancesKeyedObjectShape_parsesInstances() throws {
        let json = """
        {
            "INSTANCES": [
                {
                    "NAME": "Beta",
                    "OAUTH_CLIENT_ID": "beta-client-id",
                    "API_HOST_URL": "https://beta.example.com"
                }
            ]
        }
        """.data(using: .utf8)!

        let config = try InstancesConfig(jsonData: json)

        XCTAssertEqual(config.instances.count, 1)
        // No explicit KEY -> falls back to a slugified name, same as the YAML path.
        XCTAssertEqual(config.instance(withKey: "beta")?.name, "Beta")
    }

    func test_liveAPIShape_lowercaseSnakeCaseFields_parsesInstances() throws {
        // Lowercase "instances" wrapper, snake_case field names -- the shape that
        // originally triggered .unrecognizedShape.
        let json = """
        {
            "instances": [
                {
                    "name": "Example Instance",
                    "instance_name": { "ar": "اسم المُزود", "en": "Example Instance" },
                    "color": "#3C68FF",
                    "api_host_url": "https://example-instance.example.com",
                    "oauth_client_id": "example-oauth-client-id",
                    "ui_components": { "course_banner_enabled": true }
                }
            ]
        }
        """.data(using: .utf8)!

        let config = try InstancesConfig(jsonData: json)

        XCTAssertEqual(config.instances.count, 1)
        let instance = try XCTUnwrap(config.instances.first)
        XCTAssertEqual(instance.oAuthClientId, "example-oauth-client-id")
        XCTAssertEqual(instance.baseURL.absoluteString, "https://example-instance.example.com")
        XCTAssertEqual(instance.instanceName, "Example Instance")
        XCTAssertEqual(instance.key, "example-instance")
    }

    func test_unrecognizedShape_throws() {
        // A valid JSON object, but not the bare-array or INSTANCES/instances-keyed
        // shape this parser accepts.
        let json = "{\"foo\": \"bar\"}".data(using: .utf8)!

        XCTAssertThrowsError(try InstancesConfig(jsonData: json)) { error in
            XCTAssertEqual(error as? InstanceJSONError, .unrecognizedShape)
        }
    }

    func test_malformedInstanceEntries_areSkippedNotThrown() throws {
        // Second entry is missing OAUTH_CLIENT_ID/API_HOST_URL -- matches
        // Instance.init?(dictionary:)'s existing "drop, don't crash" behavior.
        let json = """
        [
            { "NAME": "Valid", "OAUTH_CLIENT_ID": "id", "API_HOST_URL": "https://valid.example.com" },
            { "NAME": "Missing fields" }
        ]
        """.data(using: .utf8)!

        let config = try InstancesConfig(jsonData: json)

        XCTAssertEqual(config.instances.count, 1)
        XCTAssertEqual(config.instances.first?.name, "Valid")
    }

    // MARK: - THEME / LOGO_URL (instance-JSON-driven theming)

    func test_themeBlock_parsesLightAndDarkPalettes() throws {
        let json = """
        [
            {
                "KEY": "acme",
                "NAME": "Acme",
                "OAUTH_CLIENT_ID": "acme-client-id",
                "API_HOST_URL": "https://acme.example.com",
                "THEME": {
                    "LIGHT": { "accent_color": "#1E88E5", "background": "#FFFFFF" },
                    "DARK": { "accent_color": "#4FA8FF", "background": "#0A0A0A" },
                    "LOGO_URL": "https://cdn.example.com/acme-logo.png"
                }
            }
        ]
        """.data(using: .utf8)!

        let config = try InstancesConfig(jsonData: json)
        let instance = try XCTUnwrap(config.instance(withKey: "acme"))

        XCTAssertEqual(instance.logoURLString, "https://cdn.example.com/acme-logo.png")
        XCTAssertEqual(instance.themeColors?.light["accent_color"], "#1E88E5")
        XCTAssertEqual(instance.themeColors?.light["background"], "#FFFFFF")
        XCTAssertEqual(instance.themeColors?.dark["accent_color"], "#4FA8FF")
        XCTAssertEqual(instance.themeColors?.dark["background"], "#0A0A0A")
    }

    func test_noThemeBlock_leavesThemeColorsNil() throws {
        // No THEME/LOGO_URL at all -- the additive, backward-compatible path every
        // instance used before this feature.
        let json = """
        [{ "NAME": "Plain", "OAUTH_CLIENT_ID": "id", "API_HOST_URL": "https://plain.example.com" }]
        """.data(using: .utf8)!

        let config = try InstancesConfig(jsonData: json)
        let instance = try XCTUnwrap(config.instances.first)

        XCTAssertNil(instance.themeColors)
        XCTAssertNil(instance.logoURLString)
    }

    func test_themeBlock_unrecognizedFieldKey_doesNotFailParsing() throws {
        // An unknown key inside light/dark is carried through as plain dict data --
        // ThemeColorSet.derived(fromHex:light:dark:) is what ignores unmapped keys.
        // This only confirms the JSON layer never fails the instance over it.
        let json = """
        [
            {
                "NAME": "Acme",
                "OAUTH_CLIENT_ID": "id",
                "API_HOST_URL": "https://acme.example.com",
                "THEME": { "LIGHT": { "not_a_real_field": "#000000" } }
            }
        ]
        """.data(using: .utf8)!

        let config = try InstancesConfig(jsonData: json)

        XCTAssertEqual(config.instances.count, 1)
        XCTAssertEqual(config.instances.first?.themeColors?.light["not_a_real_field"], "#000000")
    }

    func test_remoteSnakeCaseThemeAndLogoKeys_areNormalized() throws {
        // Confirms "theme"/"light"/"logo_url" all normalize to their uppercase
        // equivalents the same way every other remote field does (see
        // remoteToYAMLKeyMap) -- Instance now expects THEME/LIGHT/LOGO_URL uniformly.
        let json = """
        {
            "instances": [
                {
                    "name": "Acme",
                    "oauth_client_id": "id",
                    "api_host_url": "https://acme.example.com",
                    "theme": { "light": { "accent_color": "#1E88E5" }, "logo_url": "acmeAppLogo" }
                }
            ]
        }
        """.data(using: .utf8)!

        let config = try InstancesConfig(jsonData: json)
        let instance = try XCTUnwrap(config.instances.first)

        XCTAssertEqual(instance.logoURLString, "acmeAppLogo")
        XCTAssertEqual(instance.themeColors?.light["accent_color"], "#1E88E5")
    }

    // MARK: - InstanceConfigLoader: baseline = last-cached-good, else bundled, else empty

    func test_loader_returnsEmptyCatalog_whenNoCacheNoBundledAndFetchFails() async {
        let userDefaults = UserDefaults(suiteName: #function)!
        userDefaults.removePersistentDomain(forName: #function)

        let loader = InstanceConfigLoader(apiService: FailingInstanceApiService(), userDefaults: userDefaults)

        let result = await loader.load()

        XCTAssertTrue(result.instances.isEmpty)
    }

    func test_loader_usesCachedResponse_asBaseline_whenFetchFails() async {
        let userDefaults = UserDefaults(suiteName: #function)!
        userDefaults.removePersistentDomain(forName: #function)
        let cachedJSON = """
        [{ "NAME": "Cached", "OAUTH_CLIENT_ID": "cached-id", "API_HOST_URL": "https://cached.example.com" }]
        """.data(using: .utf8)!
        userDefaults.set(cachedJSON, forKey: "org.openedx.core.cachedInstancesJSON")

        let loader = InstanceConfigLoader(apiService: FailingInstanceApiService(), userDefaults: userDefaults)

        let result = await loader.load()

        XCTAssertEqual(result.instances.first?.name, "Cached")
    }

    func test_loader_replacesBaseline_andCachesIt_onNonEmptyFetch() async {
        let userDefaults = UserDefaults(suiteName: #function)!
        userDefaults.removePersistentDomain(forName: #function)

        let remoteJSON = """
        [{ "NAME": "Remote", "OAUTH_CLIENT_ID": "remote-id", "API_HOST_URL": "https://remote.example.com" }]
        """.data(using: .utf8)!

        let loader = InstanceConfigLoader(
            apiService: StubInstanceApiService(data: remoteJSON),
            userDefaults: userDefaults
        )

        let result = await loader.load()

        XCTAssertEqual(result.instances.first?.name, "Remote")
        XCTAssertNotNil(userDefaults.data(forKey: "org.openedx.core.cachedInstancesJSON"))
    }

    func test_loader_keepsCachedBaseline_whenFetchSucceedsWithZeroInstances() async {
        // A reachable catalog endpoint returning an empty array is not the same as it
        // being unreachable -- per product rule, zero instances must NOT replace (or
        // overwrite the cache of) whatever the baseline already was.
        let userDefaults = UserDefaults(suiteName: #function)!
        userDefaults.removePersistentDomain(forName: #function)
        let cachedJSON = """
        [{ "NAME": "Cached", "OAUTH_CLIENT_ID": "cached-id", "API_HOST_URL": "https://cached.example.com" }]
        """.data(using: .utf8)!
        userDefaults.set(cachedJSON, forKey: "org.openedx.core.cachedInstancesJSON")

        let loader = InstanceConfigLoader(
            apiService: StubInstanceApiService(data: "[]".data(using: .utf8)!),
            userDefaults: userDefaults
        )

        let result = await loader.load()

        XCTAssertEqual(result.instances.first?.name, "Cached")
        XCTAssertEqual(userDefaults.data(forKey: "org.openedx.core.cachedInstancesJSON"), cachedJSON)
    }

    func test_bundledCatalogURL_returnsNil_whenNoBundledConfigJSON() {
        // CoreTests' bundle doesn't ship a config.json -- mirrors loadBundled()'s own
        // "not found" path, which every loader test above already exercises indirectly.
        XCTAssertNil(InstanceConfigLoader.bundledCatalogURL())
    }
}

private struct FailingInstanceApiService: InstanceApiServiceProtocol {
    func fetchRawData() async throws -> Data {
        throw URLError(.notConnectedToInternet)
    }
}

private struct StubInstanceApiService: InstanceApiServiceProtocol {
    let data: Data
    func fetchRawData() async throws -> Data { data }
}

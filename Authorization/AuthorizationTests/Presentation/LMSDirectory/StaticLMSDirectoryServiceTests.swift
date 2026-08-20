//
//  StaticLMSDirectoryServiceTests.swift
//  AuthorizationTests
//
//  A directory read from a single JSON document — hosted or shipped inside the
//  app — has to behave exactly like one read from a live service, and it has to
//  keep behaving that way with no network at all. That is the whole promise of
//  the document, so these are the tests that hold it.
//

import Core
import XCTest
@testable import Authorization

final class StaticLMSDirectoryServiceTests: XCTestCase {

    private func makeSession() -> URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [StubURLProtocol.self]
        return URLSession(configuration: configuration)
    }

    override func tearDown() {
        StubURLProtocol.handler = nil
        super.tearDown()
    }

    private static let document = """
    {
      "version": 1,
      "provider": { "name": "Northwind", "tagline": "Five campuses, one app", "logo_url": null },
      "platforms": [
        {
          "id": "1",
          "title": "Alpha",
          "description": "Alpha campus",
          "short_description": "Alpha",
          "base_url": "https://alpha.example.edu",
          "logo_url": "https://cdn.example.com/alpha.png",
          "accent_color": "#112233",
          "api": {
            "host_url": "https://alpha.example.edu",
            "feedback_email": "support@example.edu",
            "oauth_client_id": "alpha-client"
          },
          "feature_flags": { "pre_login_discovery": true, "unknown_units_mode": "block" },
          "theme": { "login_background_url": "alpha-bg.png", "accent_color_dark": "#445566" }
        },
        {
          "id": "2",
          "title": "Beta",
          "description": "Beta campus",
          "short_description": "Beta",
          "base_url": "https://beta.example.edu",
          "logo_url": "beta-logo.png",
          "accent_color": null,
          "api": {
            "host_url": "https://beta.example.edu",
            "feedback_email": "",
            "oauth_client_id": "beta-client"
          },
          "feature_flags": { "pre_login_discovery": false, "unknown_units_mode": null }
        }
      ]
    }
    """

    private func makeRemoteService(body: String? = nil, status: Int = 200) -> StaticLMSDirectoryService {
        let payload = body ?? Self.document
        StubURLProtocol.handler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: status,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, Data(payload.utf8))
        }
        return StaticLMSDirectoryService(
            source: .url(URL(string: "https://example.com/directory.json")!),
            session: makeSession()
        )
    }

    // MARK: - Reading the document

    func testFeaturedReturnsEveryPlatformInDocumentOrder() async throws {
        let items = try await makeRemoteService().fetchFeatured()
        XCTAssertEqual(items.map(\.title), ["Alpha", "Beta"])
    }

    func testDetailsComeFromTheSameDocumentWithoutAnotherRequest() async throws {
        let service = makeRemoteService()
        _ = try await service.fetchFeatured()
        // The document is fetched once and kept; if this asked the network again it
        // would fail, because the stub is torn down below.
        StubURLProtocol.handler = nil
        let detail = try await service.fetchDetails(id: "2")
        XCTAssertEqual(detail.title, "Beta")
        XCTAssertEqual(detail.api.oauthClientId, "beta-client")
    }

    func testUnknownIdIsNotFound() async throws {
        let service = makeRemoteService()
        do {
            _ = try await service.fetchDetails(id: "does-not-exist")
            XCTFail("Expected notFound")
        } catch {
            XCTAssertEqual(error as? LMSDirectoryError, .notFound)
        }
    }

    func testSearchFiltersByTitleAndHost() async throws {
        let service = makeRemoteService()
        let byTitle = try await service.search(query: "beta")
        XCTAssertEqual(byTitle.map(\.title), ["Beta"])

        let byHost = try await service.search(query: "alpha.example.edu")
        XCTAssertEqual(byHost.map(\.title), ["Alpha"])

        let empty = try await service.search(query: "   ")
        XCTAssertEqual(empty.count, 2, "A blank query lists everything, as the picker expects")
    }

    // MARK: - The mode a document implies

    func testADocumentIsAlwaysCuratedAndCarriesTheProviderName() async throws {
        let config = try await makeRemoteService().fetchConfig()
        // This is the property that removes the offline footgun: a fixed list has
        // nothing to search across, so there is no server answer that could turn
        // this build into an open catalog.
        XCTAssertEqual(config.directoryMode, "curated")
        XCTAssertEqual(config.providerName, "Northwind")
        XCTAssertEqual(config.providerTagline, "Five campuses, one app")
    }

    // MARK: - Failures

    /// The smallest document a person could reasonably write by hand. Anything
    /// the apps can default, they must default — the two platforms have to
    /// accept the same file, and Android's parser already does.
    func testAMinimalHandWrittenDocumentIsAccepted() async throws {
        let minimal = """
        {
          "version": 1,
          "platforms": [
            {
              "id": "1",
              "title": "Alpha",
              "description": "Alpha campus",
              "short_description": "Alpha",
              "base_url": "https://alpha.example.edu",
              "api": {
                "host_url": "https://alpha.example.edu",
                "feedback_email": "support@example.edu",
                "oauth_client_id": "alpha-client"
              }
            }
          ]
        }
        """
        let detail = try await makeRemoteService(body: minimal).fetchDetails(id: "1")

        XCTAssertEqual(detail.title, "Alpha")
        XCTAssertFalse(detail.featureFlags.preLoginDiscovery)
        XCTAssertNil(detail.featureFlags.unknownUnitsMode)
        XCTAssertNil(detail.logoURL)
    }

    func testMalformedDocumentReportsDecodingFailure() async {
        let service = makeRemoteService(body: "{\"version\": 1}")
        do {
            _ = try await service.fetchFeatured()
            XCTFail("Expected decodingFailed")
        } catch {
            XCTAssertEqual(error as? LMSDirectoryError, .decodingFailed)
        }
    }

    func testHTTPErrorIsNotFound() async {
        let service = makeRemoteService(status: 500)
        do {
            _ = try await service.fetchFeatured()
            XCTFail("Expected notFound")
        } catch {
            XCTAssertEqual(error as? LMSDirectoryError, .notFound)
        }
    }

    func testALostConnectionSurfacesAsOffline() async {
        StubURLProtocol.handler = { _ in
            throw URLError(.notConnectedToInternet)
        }
        let service = StaticLMSDirectoryService(
            source: .url(URL(string: "https://example.com/directory.json")!),
            session: makeSession()
        )
        do {
            _ = try await service.fetchFeatured()
            XCTFail("Expected offline")
        } catch {
            XCTAssertEqual(error as? LMSDirectoryError, .offline)
        }
    }

    func testAMissingBundledFileIsNotFound() async {
        let service = StaticLMSDirectoryService(
            source: .bundledFile(name: "no-such-directory.json", bundle: .main)
        )
        do {
            _ = try await service.fetchFeatured()
            XCTFail("Expected notFound")
        } catch {
            XCTAssertEqual(error as? LMSDirectoryError, .notFound)
        }
    }

    // MARK: - Images the app will need

    func testImageSourcesSplitRemoteAddressesFromBundledNames() async throws {
        let sources = try await makeRemoteService().imageSources()
        // Alpha: a remote logo and a bundled background. Beta: a bundled logo and
        // no background at all. This is the mixture an operator ends up with when
        // they bundle some artwork and leave the rest hosted.
        XCTAssertTrue(sources.contains(.remote(URL(string: "https://cdn.example.com/alpha.png")!)))
        XCTAssertTrue(sources.contains(.bundled(name: "alpha-bg.png")))
        XCTAssertTrue(sources.contains(.bundled(name: "beta-logo.png")))
        XCTAssertEqual(sources.count, 3)
    }
}

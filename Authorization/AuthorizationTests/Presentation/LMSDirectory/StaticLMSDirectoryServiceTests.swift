//
//  StaticLMSDirectoryServiceTests.swift
//  Authorization
//
//  Created by Ivan Stepanok on 20.08.2026.
//

import Core
import XCTest
@testable import Authorization

/// AuthorizationTests
/// A directory read from a single JSON document — hosted or shipped inside the
/// app — has to behave exactly like one read from a live service, and it has to
/// keep behaving that way with no network at all. That is the whole promise of
/// the document, so these are the tests that hold it.
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
      "format": "v1",
      "provider": { "name": "Northwind", "tagline": "Five campuses, one app", "logo": null },
      "include": [
        {
          "id": "1",
          "name": "Alpha",
          "description": "Alpha",
          "url": "https://alpha.example.edu",
          "logo": "https://cdn.example.com/alpha.png",
          "accent_color": "#112233",
          "api": {
            "host_url": "https://alpha.example.edu",
            "feedback_email": "support@example.edu",
            "oauth_client_id": "alpha-client"
          },
          "feature_flags": { "pre_login_discovery": true, "unknown_units_mode": "block" },
          "theme": { "login_background": "alpha-bg.png", "accent_color_dark": "#445566" }
        },
        {
          "id": "2",
          "name": "Beta",
          "description": "Beta",
          "url": "https://beta.example.edu",
          "logo": "beta-logo.png",
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
        let items = try await makeRemoteService().platforms()
        XCTAssertEqual(items.map(\.title), ["Alpha", "Beta"])
    }

    func testDetailsComeFromTheSameDocumentWithoutAnotherRequest() async throws {
        let service = makeRemoteService()
        _ = try await service.platforms()
        // The document is fetched once and kept; if this asked the network again it
        // would fail, because the stub is torn down below.
        StubURLProtocol.handler = nil
        let detail = try await service.details(id: "2")
        XCTAssertEqual(detail.title, "Beta")
        XCTAssertEqual(detail.api.oauthClientId, "beta-client")
    }

    func testUnknownIdIsNotFound() async throws {
        let service = makeRemoteService()
        do {
            _ = try await service.details(id: "does-not-exist")
            XCTFail("Expected notFound")
        } catch {
            XCTAssertEqual(error as? LMSDirectoryError, .notFound)
        }
    }

    // MARK: - The mode a document implies

    func testTheProviderNameComesFromTheDocument() async throws {
        let name = try await makeRemoteService().providerName()

        XCTAssertEqual(name, "Northwind")
    }

    // MARK: - Failures

    /// The smallest document a person could reasonably write by hand. Anything
    /// the apps can default, they must default — the two platforms have to
    /// accept the same file, and Android's parser already does.
    func testAMinimalHandWrittenDocumentIsAccepted() async throws {
        let minimal = """
        {
          "format": "v1",
          "include": [
            {
              "id": "1",
              "name": "Alpha",
              "description": "Alpha",
              "url": "https://alpha.example.edu"
            }
          ]
        }
        """
        let detail = try await makeRemoteService(body: minimal).details(id: "1")

        XCTAssertEqual(detail.title, "Alpha")
        XCTAssertFalse(detail.featureFlags.preLoginDiscovery)
        XCTAssertNil(detail.featureFlags.unknownUnitsMode)
        XCTAssertNil(detail.logoURL)
        // No "api" block at all: the platform is served from the address the
        // learner picked, and the app signs in with its own OAuth client.
        XCTAssertEqual(detail.api.hostURL.absoluteString, "https://alpha.example.edu")
        XCTAssertTrue(detail.api.oauthClientId.isEmpty)
    }

    /// A multi-instance app carries one OAuth client id of its own, which each
    /// backend registers. A directory that names none per platform is the normal
    /// case, and must not stop the file being read.
    func testAPlatformNeedNotCarryItsOwnOAuthClient() async throws {
        let document = """
        {
          "format": "v1",
          "include": [
            {
              "id": "1",
              "name": "Alpha",
              "description": "Alpha",
              "url": "https://alpha.example.edu",
              "api": { "host_url": "https://api.alpha.example.edu" }
            }
          ]
        }
        """

        let detail = try await makeRemoteService(body: document).details(id: "1")

        XCTAssertEqual(detail.api.hostURL.absoluteString, "https://api.alpha.example.edu")
        XCTAssertTrue(detail.api.oauthClientId.isEmpty)
        XCTAssertTrue(detail.api.feedbackEmail.isEmpty)
    }

    func testMalformedDocumentReportsDecodingFailure() async {
        let service = makeRemoteService(body: "{\"version\": 1}")
        do {
            _ = try await service.platforms()
            XCTFail("Expected decodingFailed")
        } catch {
            XCTAssertEqual(error as? LMSDirectoryError, .decodingFailed)
        }
    }

    func testHTTPErrorIsNotFound() async {
        let service = makeRemoteService(status: 500)
        do {
            _ = try await service.platforms()
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
            _ = try await service.platforms()
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
            _ = try await service.platforms()
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

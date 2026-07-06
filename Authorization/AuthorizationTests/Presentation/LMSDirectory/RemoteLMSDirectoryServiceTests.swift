//
//  RemoteLMSDirectoryServiceTests.swift
//  AuthorizationTests
//
//  Regression coverage for the LMS Directory connectivity fix: the directory
//  service must talk to the registry directly (no ConnectivityProtocol / stock-host
//  ping) and map a genuine network failure to `.offline`.
//

import XCTest
@testable import Authorization

final class RemoteLMSDirectoryServiceTests: XCTestCase {

    private func makeSession() -> URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [StubURLProtocol.self]
        return URLSession(configuration: configuration)
    }

    private func makeService() -> RemoteLMSDirectoryService {
        // Note: the initializer takes no ConnectivityProtocol — the directory's
        // reachability is decided by the call itself, not by the app's stock host.
        RemoteLMSDirectoryService(
            baseURL: URL(string: "https://registry.test")!,
            session: makeSession()
        )
    }

    override func tearDown() {
        StubURLProtocol.handler = nil
        super.tearDown()
    }

    func test_search_decodesRegistryItems() async throws {
        let json = Data(
            """
            {"items":[{"id":"5","title":"Atentamente","short_description":"Atentamente MX",
            "base_url":"https://educar.atentamente.mx","logo_url":"https://cdn.example.com/a.png",
            "accent_color":"#f15d49"}]}
            """.utf8
        )
        StubURLProtocol.handler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, json)
        }

        let results = try await makeService().search(query: "aten")

        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.id, "5")
        XCTAssertEqual(results.first?.title, "Atentamente")
        XCTAssertEqual(results.first?.baseURL.absoluteString, "https://educar.atentamente.mx")
        XCTAssertEqual(results.first?.accentColorHex, "#f15d49")
    }

    func test_search_mapsNoConnectionToOffline() async {
        StubURLProtocol.handler = { _ in throw URLError(.notConnectedToInternet) }
        await assertOffline { try await self.makeService().search(query: "x") }
    }

    func test_search_mapsTimeoutToOffline() async {
        StubURLProtocol.handler = { _ in throw URLError(.timedOut) }
        await assertOffline { try await self.makeService().search(query: "x") }
    }

    func test_fetchFeatured_mapsCannotConnectToOffline() async {
        StubURLProtocol.handler = { _ in throw URLError(.cannotConnectToHost) }
        await assertOffline { try await self.makeService().fetchFeatured() }
    }

    private func assertOffline(
        _ operation: @escaping () async throws -> [LMSSearchResult]
    ) async {
        do {
            _ = try await operation()
            XCTFail("Expected LMSDirectoryError.offline")
        } catch let error as LMSDirectoryError {
            guard case .offline = error else {
                return XCTFail("Expected .offline, got \(error)")
            }
        } catch {
            XCTFail("Expected LMSDirectoryError.offline, got \(error)")
        }
    }
}

/// Injects canned responses / errors into a `URLSession` for deterministic tests.
final class StubURLProtocol: URLProtocol {
    nonisolated(unsafe) static var handler: (@Sendable (URLRequest) throws -> (HTTPURLResponse, Data))?

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        guard let handler = Self.handler else {
            client?.urlProtocol(self, didFailWithError: URLError(.badURL))
            return
        }
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}
}

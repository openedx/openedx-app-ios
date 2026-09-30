//
//  RequestInterceptorTests.swift
//  CoreTests
//
//  Created by Rawan Matar on 15/09/2026.
//

import XCTest
import Alamofire
@testable import Core

final class RequestInterceptorTests: XCTestCase {

    private func makeConfig(baseURL: String = "https://app.example.com") -> ConfigProtocolMock {
        let config = ConfigProtocolMock()
        config.baseURL = URL(string: baseURL)!
        config.oAuthClientId = "app-oauth-client-id"
        return config
    }

    private func adapt(
        _ interceptor: Core.RequestInterceptor,
        url: String
    ) throws -> URLRequest {
        let request = URLRequest(url: URL(string: url)!)
        var result: Result<URLRequest, Error>?
        interceptor.adapt(request, for: Session()) { result = $0 }
        return try XCTUnwrap(result?.get())
    }

    func test_adapt_selectedInstance_rewritesRequestBuiltAgainstAppBaseURL() throws {
        let config = makeConfig()
        let instance = Instance.mock(baseURL: URL(string: "https://acme.example.com")!)
        let instanceStore = InstanceProviderMock(currentInstance: instance)
        let interceptor = Core.RequestInterceptor(
            config: config, storage: CoreStorageMock(), instanceStore: instanceStore
        )

        let adapted = try adapt(interceptor, url: "https://app.example.com/api/v1/courses?page=2")

        XCTAssertEqual(adapted.url?.host, "acme.example.com")
        XCTAssertEqual(adapted.url?.path, "/api/v1/courses")
        XCTAssertEqual(adapted.url?.query, "page=2")
    }

    func test_adapt_noInstanceSelected_leavesRequestUntouched() throws {
        let config = makeConfig()
        let instanceStore = InstanceProviderMock(currentInstance: nil)
        let interceptor = Core.RequestInterceptor(
            config: config, storage: CoreStorageMock(), instanceStore: instanceStore
        )

        let adapted = try adapt(interceptor, url: "https://app.example.com/api/v1/courses")

        XCTAssertEqual(adapted.url?.host, "app.example.com")
    }

    func test_adapt_requestNotBuiltAgainstAppBaseURL_leftUntouched() throws {
        let config = makeConfig()
        let instance = Instance.mock(baseURL: URL(string: "https://acme.example.com")!)
        let instanceStore = InstanceProviderMock(currentInstance: instance)
        let interceptor = Core.RequestInterceptor(
            config: config, storage: CoreStorageMock(), instanceStore: instanceStore
        )

        // e.g. an SSO webview or third-party SDK call -- never rewritten.
        let adapted = try adapt(interceptor, url: "https://sso.thirdparty.com/authorize")

        XCTAssertEqual(adapted.url?.host, "sso.thirdparty.com")
    }

    // Reproduces the real bug: in production `config` is `InstanceAwareConfig`, so
    // `config.baseURL` itself tracks whichever instance is selected. `API`'s own baseURL
    // never moves after DI registration, so requests keep being built against the original
    // default -- if the interceptor compared against the live `config.baseURL` instead of a
    // snapshot taken at init, this stops matching the moment any instance is selected, and
    // rewriteHostIfNeeded silently stops firing.
    func test_adapt_afterConfigBaseURLDrifts_stillRewritesRequestBuiltAgainstOriginalDefault() throws {
        let config = makeConfig()
        let instance = Instance.mock(baseURL: URL(string: "https://acme.example.com")!)
        let instanceStore = InstanceProviderMock(currentInstance: instance)
        let interceptor = Core.RequestInterceptor(
            config: config, storage: CoreStorageMock(), instanceStore: instanceStore
        )

        // Simulate InstanceAwareConfig.baseURL drifting to the selected instance.
        config.baseURL = instance.baseURL

        let adapted = try adapt(interceptor, url: "https://app.example.com/api/v1/courses")

        XCTAssertEqual(adapted.url?.host, "acme.example.com")
    }
}

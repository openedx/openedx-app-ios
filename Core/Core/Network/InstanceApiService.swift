//
//  InstanceApiService.swift
//  Core
//
//  Created by Rawan Matar on 31/08/2026.
//

import Foundation

public enum InstanceApiError: Error {
    /// No `INSTANCES_CATALOG_URL` configured -- caller should fall back without
    /// attempting a network call.
    case notConfigured
    case invalidResponse(statusCode: Int)
}

public protocol InstanceApiServiceProtocol: Sendable {
    func fetchRawData() async throws -> Data
}

/// Fetches the remote instance catalog as raw JSON bytes. Plain `URLSession`, not routed
/// through `OEXFoundation`'s `API`/`Alamofire.Session` -- this is a fixed, anonymous,
/// external endpoint, not a per-instance platform API call. Parsing lives on
/// `InstancesConfig(jsonData:fallback:)`, not here.
public final class InstanceApiService: InstanceApiServiceProtocol, Sendable {
    private let url: URL?
    private let session: URLSession

    /// - Parameter url: `INSTANCES_CATALOG_URL` from the bundled config.json's
    ///   app-level keys (see `InstanceConfigLoader.bundledCatalogURL()`). `nil` when unconfigured.
    public init(url: URL? = nil, session: URLSession = .shared) {
        self.url = url
        self.session = session
    }

    public func fetchRawData() async throws -> Data {
        guard let url else {
            throw InstanceApiError.notConfigured
        }

        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.timeoutInterval = 10

        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse, 200..<300 ~= http.statusCode else {
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
            throw InstanceApiError.invalidResponse(statusCode: statusCode)
        }
        return data
    }
}

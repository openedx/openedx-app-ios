//
//  TenantApiService.swift
//  Core
//
//  Created by Rawan Matar on 31/08/2026.
//

import Foundation

public enum TenantApiError: Error {
    case invalidResponse(statusCode: Int)
}

public protocol TenantApiServiceProtocol: Sendable {
    func fetchRawData() async throws -> Data
}

/// Fetches the remote tenant catalog as raw JSON bytes. Plain `URLSession`, not routed
/// through `OEXFoundation`'s `API`/`Alamofire.Session` -- this is a fixed, anonymous,
/// external endpoint, not a per-tenant platform API call. Parsing lives on
/// `TenantsConfig(jsonData:fallback:)`, not here.
public final class TenantApiService: TenantApiServiceProtocol, Sendable {
    /// Placeholder endpoint -- replace with the real hosted tenant-catalog URL.
    public static let defaultURL = URL(string: "https://example.com/tenants.json")!

    private let url: URL
    private let session: URLSession

    public init(url: URL = TenantApiService.defaultURL, session: URLSession = .shared) {
        self.url = url
        self.session = session
    }

    public func fetchRawData() async throws -> Data {
        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.timeoutInterval = 10

        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse, 200..<300 ~= http.statusCode else {
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
            throw TenantApiError.invalidResponse(statusCode: statusCode)
        }
        return data
    }
}

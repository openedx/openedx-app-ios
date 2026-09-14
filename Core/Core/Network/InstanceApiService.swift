//
//  InstanceApiService.swift
//  Core
//
//  Created by Rawan Matar on 31/08/2026.
//

import Foundation

public enum InstanceApiError: Error {
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
    /// Placeholder endpoint -- replace with the real hosted instance-catalog URL.
    public static let defaultURL = URL(string: "https://example.com/instances.json")!

    private let url: URL
    private let session: URLSession

    public init(url: URL = InstanceApiService.defaultURL, session: URLSession = .shared) {
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
            throw InstanceApiError.invalidResponse(statusCode: statusCode)
        }
        return data
    }
}

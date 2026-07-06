import Core
import Foundation

final class RemoteLMSDirectoryService: LMSDirectoryService {

    private let baseURL: URL
    private let session: URLSession
    private let connectivity: ConnectivityProtocol
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()

    init(
        baseURL: URL,
        connectivity: ConnectivityProtocol,
        session: URLSession = .shared
    ) {
        self.baseURL = baseURL
        self.connectivity = connectivity
        self.session = session
    }

    func search(query: String) async throws -> [LMSSearchResult] {
        try await ensureOnline()

        var components = URLComponents(
            url: baseURL.appendingPathComponent("/api/v1/directory"),
            resolvingAgainstBaseURL: false
        )!
        if !query.isEmpty {
            components.queryItems = [URLQueryItem(name: "q", value: query)]
        }

        let (data, response) = try await session.data(from: components.url!)
        try validateResponse(response)

        do {
            let listResponse = try decoder.decode(LMSListResponse.self, from: data)
            return listResponse.items.map {
                LMSSearchResult(
                    id: $0.id,
                    title: $0.title,
                    shortDescription: $0.shortDescription,
                    baseURL: $0.baseURL,
                    logoURL: $0.logoURL,
                    accentColorHex: $0.accentColor
                )
            }
        } catch {
            throw LMSDirectoryError.decodingFailed
        }
    }

    func fetchDetails(id: String) async throws -> LMSDetail {
        try await ensureOnline()

        let url = baseURL.appendingPathComponent("/api/v1/directory/\(id)")
        let (data, response) = try await session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw LMSDirectoryError.decodingFailed
        }

        if httpResponse.statusCode == 404 {
            throw LMSDirectoryError.notFound
        }

        try validateResponse(response)

        do {
            let dto = try decoder.decode(LMSDetailDTO.self, from: data)
            return dto.domainModel
        } catch {
            throw LMSDirectoryError.decodingFailed
        }
    }

    func fetchConfig() async throws -> LMSRegistryConfig {
        try await ensureOnline()
        let url = baseURL.appendingPathComponent("/api/v1/config")
        let (data, response) = try await session.data(from: url)
        try validateResponse(response)
        do {
            return try decoder.decode(LMSConfigDTO.self, from: data).domainModel
        } catch {
            throw LMSDirectoryError.decodingFailed
        }
    }

    func fetchFeatured() async throws -> [LMSSearchResult] {
        try await ensureOnline()
        var components = URLComponents(
            url: baseURL.appendingPathComponent("/api/v1/directory"),
            resolvingAgainstBaseURL: false
        )!
        components.queryItems = [URLQueryItem(name: "featured", value: "true")]

        let (data, response) = try await session.data(from: components.url!)
        try validateResponse(response)
        do {
            let listResponse = try decoder.decode(LMSListResponse.self, from: data)
            return listResponse.items.map {
                LMSSearchResult(
                    id: $0.id,
                    title: $0.title,
                    shortDescription: $0.shortDescription,
                    baseURL: $0.baseURL,
                    logoURL: $0.logoURL,
                    accentColorHex: $0.accentColor
                )
            }
        } catch {
            throw LMSDirectoryError.decodingFailed
        }
    }

    // MARK: - Private

    private func ensureOnline() async throws {
        let isOnline = await MainActor.run { connectivity.isInternetAvaliable }
        guard isOnline else {
            throw LMSDirectoryError.offline
        }
    }

    private func validateResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw LMSDirectoryError.notFound
        }
    }
}

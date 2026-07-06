import Core
import Foundation

enum LMSDirectoryError: Error {
    case notFound
    case offline
    case decodingFailed
}

protocol LMSDirectoryService: Sendable {
    func search(query: String) async throws -> [LMSSearchResult]
    func fetchDetails(id: String) async throws -> LMSDetail
    /// Registry configuration (search vs curated / provider mode).
    func fetchConfig() async throws -> LMSRegistryConfig
    /// The provider's fixed list, shown directly in curated mode.
    func fetchFeatured() async throws -> [LMSSearchResult]
}

private final class UniversalAppBundleToken {}

final class MockLMSDirectoryService: LMSDirectoryService {
    private let dataSource: [LMSDetail]
    private let connectivity: ConnectivityProtocol
    private let latency: TimeInterval

    init(
        bundle: Bundle = .lmsSelection,
        resourceName: String = "lms_mock_data",
        connectivity: ConnectivityProtocol,
        latency: TimeInterval = 0.3
    ) {
        self.connectivity = connectivity
        self.latency = latency
        self.dataSource = MockLMSDirectoryService.loadData(bundle: bundle, resourceName: resourceName)
    }

    func search(query: String) async throws -> [LMSSearchResult] {
        try await simulateLatency()
        try await ensureOnline()
        let normalized = query.lowercased()
        return dataSource
            .filter {
                normalized.isEmpty ||
                $0.title.lowercased().contains(normalized) ||
                $0.baseURL.absoluteString.lowercased().contains(normalized)
            }
            .map {
                LMSSearchResult(
                    id: $0.id,
                    title: $0.title,
                    shortDescription: $0.shortDescription,
                    baseURL: $0.baseURL,
                    logoURL: $0.logoURL,
                    accentColorHex: $0.accentColorHex
                )
            }
    }

    func fetchDetails(id: String) async throws -> LMSDetail {
        try await simulateLatency()
        try await ensureOnline()
        guard let detail = dataSource.first(where: { $0.id == id }) else {
            throw LMSDirectoryError.notFound
        }
        return detail
    }

    func fetchConfig() async throws -> LMSRegistryConfig {
        .searchDefault
    }

    func fetchFeatured() async throws -> [LMSSearchResult] {
        try await simulateLatency()
        return dataSource.map {
            LMSSearchResult(
                id: $0.id,
                title: $0.title,
                shortDescription: $0.shortDescription,
                baseURL: $0.baseURL,
                logoURL: $0.logoURL,
                accentColorHex: $0.accentColorHex
            )
        }
    }

    private func simulateLatency() async throws {
        if latency > 0 {
            try await Task.sleep(nanoseconds: UInt64(latency * 1_000_000_000))
        }
    }

    private func ensureOnline() async throws {
        try await MainActor.run {
            guard connectivity.isInternetAvaliable else {
                throw LMSDirectoryError.offline
            }
        }
    }

    private static func loadData(bundle: Bundle, resourceName: String) -> [LMSDetail] {
        guard
            let url = bundle.url(forResource: resourceName, withExtension: "json"),
            let data = try? Data(contentsOf: url)
        else {
            assertionFailure("Missing LMS mock data file.")
            return []
        }
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let details = try decoder.decode([LMSDetailDTO].self, from: data)
            return details.map(\.domainModel)
        } catch {
            assertionFailure("Failed to decode LMS mock data: \(error)")
            return []
        }
    }
}

private extension Bundle {
    static var lmsSelection: Bundle {
        #if SWIFT_PACKAGE
        return .module
        #else
        return Bundle(for: UniversalAppBundleToken.self)
        #endif
    }
}

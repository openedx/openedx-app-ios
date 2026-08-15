//
//  StaticLMSDirectoryService.swift
//  Authorization
//
//  Reads the whole directory from a single JSON document instead of a live API.
//
//  The document can come from a URL or from a file inside the app bundle, and
//  nothing downstream can tell the difference. That is the point: an operator
//  publishes the file wherever they like — their own web server, a CDN, or the
//  app binary itself — and the app never learns anything about where it lives.
//
//  Everything arrives at once, so the platform list and every platform's details
//  are known before the learner taps anything. That is what makes it possible to
//  warm the logos and sign-in backgrounds ahead of the screen that shows them.
//

import Core
import Foundation

/// Wire format of the directory document. `version` is the only field a future
/// change is allowed to key off; unknown keys are ignored, so a newer document
/// stays readable by an older build.
struct LMSDirectoryDocumentDTO: Codable {
    struct Provider: Codable {
        let name: String
        let tagline: String?
        let logoURL: URL?

        enum CodingKeys: String, CodingKey {
            case name
            case tagline
            case logoURL = "logo_url"
        }
    }

    let version: Int
    let provider: Provider?
    let platforms: [LMSDetailDTO]
}

/// Where a document is read from.
enum LMSDirectoryDocumentSource: Sendable, Equatable {
    /// Fetched over the network, then kept for the lifetime of the process.
    case url(URL)
    /// Read from a JSON file inside the app bundle. Never touches the network.
    case bundledFile(name: String, bundle: Bundle)

    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case let (.url(l), .url(r)):
            return l == r
        case let (.bundledFile(ln, _), .bundledFile(rn, _)):
            return ln == rn
        default:
            return false
        }
    }
}

final class StaticLMSDirectoryService: LMSDirectoryService {

    private let source: LMSDirectoryDocumentSource
    private let session: URLSession
    private let cache = DocumentCache()

    private static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()

    init(source: LMSDirectoryDocumentSource, session: URLSession = .shared) {
        self.source = source
        self.session = session
    }

    // MARK: - LMSDirectoryService

    func search(query: String) async throws -> [LMSSearchResult] {
        let platforms = try await platforms()
        let needle = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !needle.isEmpty else { return platforms.map(\.searchResult) }
        return platforms
            .filter {
                $0.title.lowercased().contains(needle)
                || $0.baseURL.absoluteString.lowercased().contains(needle)
            }
            .map(\.searchResult)
    }

    func fetchDetails(id: String) async throws -> LMSDetail {
        guard let match = try await platforms().first(where: { $0.id == id }) else {
            throw LMSDirectoryError.notFound
        }
        return match
    }

    func fetchConfig() async throws -> LMSRegistryConfig {
        // A fixed list is a fixed list. There is nothing here to search across, so
        // the document is always curated — and because it never has to ask a server
        // what mode to be in, it cannot fall back to open search when offline.
        let document = try await document()
        return LMSRegistryConfig(
            directoryMode: "curated",
            providerName: document.provider?.name ?? "",
            providerTagline: document.provider?.tagline ?? ""
        )
    }

    func fetchFeatured() async throws -> [LMSSearchResult] {
        try await platforms().map(\.searchResult)
    }

    /// Every image the app will need, so a caller can warm them before they are shown.
    func imageSources() async throws -> [LMSImageSource] {
        try await platforms().flatMap(\.imageSources)
    }

    // MARK: - Private

    private func platforms() async throws -> [LMSDetail] {
        try await document().platforms.map(\.domainModel)
    }

    private func document() async throws -> LMSDirectoryDocumentDTO {
        if let cached = await cache.value {
            return cached
        }
        let data = try await load()
        do {
            let decoded = try Self.decoder.decode(LMSDirectoryDocumentDTO.self, from: data)
            await cache.store(decoded)
            return decoded
        } catch {
            throw LMSDirectoryError.decodingFailed
        }
    }

    private func load() async throws -> Data {
        switch source {
        case let .bundledFile(name, bundle):
            let base = (name as NSString).deletingPathExtension
            let ext = (name as NSString).pathExtension
            // The app target is where an operator would naturally drop the file, but
            // a framework bundle is a reasonable place too, and which one they chose
            // is not worth making them read documentation about.
            for candidate in [bundle, .main] {
                if let url = candidate.url(forResource: base, withExtension: ext.isEmpty ? "json" : ext),
                   let data = try? Data(contentsOf: url) {
                    return data
                }
            }
            throw LMSDirectoryError.notFound

        case let .url(url):
            do {
                let (data, response) = try await session.data(from: url)
                guard
                    let http = response as? HTTPURLResponse,
                    (200...299).contains(http.statusCode)
                else {
                    throw LMSDirectoryError.notFound
                }
                return data
            } catch let error as URLError where Self.offlineCodes.contains(error.code) {
                throw LMSDirectoryError.offline
            }
        }
    }

    private static let offlineCodes: Set<URLError.Code> = [
        .notConnectedToInternet,
        .networkConnectionLost,
        .cannotConnectToHost,
        .cannotFindHost,
        .dnsLookupFailed,
        .timedOut,
        .dataNotAllowed
    ]

    /// Holds the parsed document so the picker, the theming and the prefetch all
    /// work from one copy rather than re-reading it three times.
    private actor DocumentCache {
        private(set) var value: LMSDirectoryDocumentDTO?

        func store(_ document: LMSDirectoryDocumentDTO) {
            value = document
        }
    }
}

private extension LMSDetail {
    var searchResult: LMSSearchResult {
        LMSSearchResult(
            id: id,
            title: title,
            shortDescription: shortDescription,
            baseURL: baseURL,
            logoURL: effectiveLogoURL,
            accentColorHex: accentColorHex
        )
    }

    var imageSources: [LMSImageSource] {
        [effectiveLogoURL, theme?.loginBackgroundURL]
            .compactMap { $0 }
            .compactMap(LMSImageSource.init(url:))
    }
}

extension Bundle {
    /// Where a bundled directory document is looked for first: the app itself,
    /// because that is where whoever ships the build adds the file.
    static var lmsDirectoryHost: Bundle { .main }
}

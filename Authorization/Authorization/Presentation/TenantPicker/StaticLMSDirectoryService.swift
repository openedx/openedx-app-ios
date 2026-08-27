//
//  StaticLMSDirectoryService.swift
//  Authorization
//
//  Created by Ivan Stepanok on 20.08.2026.
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
        let logo: URL?

        enum CodingKeys: String, CodingKey {
            case name
            case tagline
            case logo
        }
    }

    let format: String?
    let provider: Provider?
    let include: [LMSDetailDTO]
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

/// Reads the whole directory from a single JSON document instead of a live API.
///
/// The document can come from a URL or from a file inside the app bundle, and
/// nothing downstream can tell the difference: an operator publishes the file
/// wherever they like and the app never learns anything about where it lives.
/// Everything arrives at once, so the list and every platform's details are
/// known before the learner taps anything — which is what makes it possible to
/// warm the logos and sign-in backgrounds ahead of the screen that shows them.
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

    func platforms() async throws -> [LMSSummary] {
        try await allPlatforms().map(\.summary)
    }

    func details(id: String) async throws -> LMSDetail {
        guard let match = try await allPlatforms().first(where: { $0.id == id }) else {
            throw LMSDirectoryError.notFound
        }
        return match
    }

    /// The name the document's publisher gave themselves, shown above the list.
    func providerName() async throws -> String? {
        try await document().provider?.name
    }

    /// Every image the app will need, so a caller can warm them before they are shown.
    func imageSources() async throws -> [LMSImageSource] {
        try await allPlatforms().flatMap(\.imageSources)
    }

    // MARK: - Private

    private func allPlatforms() async throws -> [LMSDetail] {
        try await document().include.enumerated().map { index, entry in
            entry.domainModel(id: String(index))
        }
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
    var summary: LMSSummary {
        LMSSummary(
            id: id,
            title: title,
            shortDescription: shortDescription,
            baseURL: baseURL,
            logoURL: logoURL,
            accentColorHex: accentColorHex
        )
    }

    var imageSources: [LMSImageSource] {
        [logoURL, theme?.loginBackgroundURL]
            .compactMap { $0 }
            .compactMap(LMSImageSource.init(url:))
    }
}

extension Bundle {
    /// Where a bundled directory document is looked for first: the app itself,
    /// because that is where whoever ships the build adds the file.
    static var lmsDirectoryHost: Bundle { .main }
}

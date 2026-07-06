import Foundation

/// Public configuration served by the registry (`GET /api/v1/config`).
/// Drives whether the app shows a search box or a fixed, curated list.
struct LMSRegistryConfig: Sendable, Equatable {
    let directoryMode: String
    let providerName: String
    let providerTagline: String

    var isCurated: Bool { directoryMode.lowercased() == "curated" }

    static let searchDefault = LMSRegistryConfig(
        directoryMode: "search",
        providerName: "",
        providerTagline: ""
    )
}

// MARK: - Wire DTOs

struct LMSConfigDTO: Codable {
    let directoryMode: String
    let providerName: String
    let providerTagline: String

    enum CodingKeys: String, CodingKey {
        case directoryMode = "directory_mode"
        case providerName = "provider_name"
        case providerTagline = "provider_tagline"
    }

    var domainModel: LMSRegistryConfig {
        LMSRegistryConfig(
            directoryMode: directoryMode,
            providerName: providerName,
            providerTagline: providerTagline
        )
    }
}

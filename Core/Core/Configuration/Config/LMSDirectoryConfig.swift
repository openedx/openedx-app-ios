//
//  LMSDirectoryConfig.swift
//  Core
//
//  Feature flag for the LMS Directory ("pick / access any Open edX LMS") feature.
//  When ENABLED is false the app behaves exactly like a stock single-tenant build.
//

import Foundation
import OEXFoundation

private enum Keys: String, RawStringExtractable {
    case enabled = "ENABLED"
    case directoryURL = "DIRECTORY_URL"
    case directoryMode = "DIRECTORY_MODE"
}

public class LMSDirectoryConfig: NSObject {
    /// Master gate. When false the feature is completely inert.
    public var enabled: Bool
    /// Base URL of the LMS registry that serves the catalog, e.g. https://registry.example.com
    public var directoryURL: String
    /// Optional client override: "" | "search" | "curated". The registry's
    /// /api/v1/config response is authoritative; this only forces a mode client-side.
    public var directoryMode: String

    /// The catalog is only reachable when the feature is on and a registry URL is set.
    public var isDirectoryReachable: Bool {
        enabled && !directoryURL.trimmingCharacters(in: .whitespaces).isEmpty
    }

    init(dictionary: [String: Any]) {
        enabled = dictionary[Keys.enabled] as? Bool ?? false
        directoryURL = dictionary[Keys.directoryURL] as? String ?? ""
        directoryMode = dictionary[Keys.directoryMode] as? String ?? ""
        super.init()
    }
}

private let key = "LMS_DIRECTORY"
extension Config {
    public var lmsDirectory: LMSDirectoryConfig {
        return LMSDirectoryConfig(dictionary: properties[key] as? [String: AnyObject] ?? [:])
    }
}

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
    case directoryFile = "DIRECTORY_FILE"
    case directoryMode = "DIRECTORY_MODE"
}

public class LMSDirectoryConfig: NSObject {
    /// Master gate. When false the feature is completely inert.
    public var enabled: Bool
    /// Where the directory comes from. Either a JSON document
    /// (https://example.com/directory.json) or, for a live catalog, the base URL
    /// of a service that serves /api/v1/directory.
    public var directoryURL: String
    /// A JSON document shipped inside the app, e.g. "lms_directory.json".
    /// Set this and the app never asks the network for its platform list.
    public var directoryFile: String
    /// Optional client override: "" | "search" | "curated". Only meaningful for a
    /// live catalog; a document is a fixed list and is always curated.
    public var directoryMode: String

    /// Whether the app has somewhere to read its platforms from.
    public var isDirectoryReachable: Bool {
        enabled && (!trimmedFile.isEmpty || !trimmedURL.isEmpty)
    }

    /// How to read the directory.
    ///
    /// A bundled file wins over a URL: a build that ships its own copy has
    /// deliberately opted out of the network, and silently preferring a remote
    /// list would undo that.
    public enum Source: Equatable {
        /// A JSON document, fetched once.
        case document(URL)
        /// A JSON document inside the app bundle.
        case bundledDocument(String)
        /// A live catalog service that answers /api/v1/directory.
        case service(URL)
    }

    public var source: Source? {
        guard enabled else { return nil }
        if !trimmedFile.isEmpty {
            return .bundledDocument(trimmedFile)
        }
        guard !trimmedURL.isEmpty, let url = URL(string: trimmedURL) else { return nil }
        // A ".json" address is a document; anything else is a service to query.
        // The distinction is visible in the config file itself, which is where
        // whoever set it will look when the app does not behave as they expected.
        return url.pathExtension.lowercased() == "json" ? .document(url) : .service(url)
    }

    /**
     Whether this build can report a platform to anyone.

     Reporting exists because the open catalog lets a stranger list anything; it
     is part of the universal app, not of a provider's own list. A directory read
     from a document has no service behind it at all, so there is nothing to post
     to and the entry point must not appear.

     A live service in curated mode also refuses reports, and is hidden separately
     by the mode itself.
     */
    public var supportsReporting: Bool {
        if case .service = source { return true }
        return false
    }

    private var trimmedURL: String {
        directoryURL.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var trimmedFile: String {
        directoryFile.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    init(dictionary: [String: Any]) {
        enabled = dictionary[Keys.enabled] as? Bool ?? false
        directoryURL = dictionary[Keys.directoryURL] as? String ?? ""
        directoryFile = dictionary[Keys.directoryFile] as? String ?? ""
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

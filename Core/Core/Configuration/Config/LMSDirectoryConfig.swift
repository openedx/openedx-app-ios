//
//  LMSDirectoryConfig.swift
//  Core
//
//  Feature flag for the multi-tenant LMS Directory: a build that lets a learner
//  choose which Open edX platform to sign in to. With ENABLED false the app
//  behaves exactly like a stock single-tenant build.
//

import Foundation
import OEXFoundation

private enum Keys: String, RawStringExtractable {
    case enabled = "ENABLED"
    case directoryURL = "DIRECTORY_URL"
    case directoryFile = "DIRECTORY_FILE"
}

public class LMSDirectoryConfig: NSObject {
    /// Master gate. When false the feature is completely inert.
    public var enabled: Bool
    /// Address of a JSON document listing the platforms this build offers.
    public var directoryURL: String
    /// The same document, shipped inside the app, e.g. "lms_directory.json".
    /// Set this and the app never asks the network for its platform list.
    public var directoryFile: String

    /// Whether the app has somewhere to read its platforms from.
    public var isDirectoryReachable: Bool {
        enabled && (!trimmedFile.isEmpty || !trimmedURL.isEmpty)
    }

    /// Where the document comes from.
    ///
    /// A bundled file wins over a URL: a build that ships its own copy has
    /// deliberately opted out of the network, and silently preferring a remote
    /// list would undo that.
    public enum Source: Equatable {
        /// Fetched once, from anywhere the publisher chose to put it.
        case document(URL)
        /// Read from the app bundle. Never touches the network.
        case bundledDocument(String)
    }

    public var source: Source? {
        guard enabled else { return nil }
        if !trimmedFile.isEmpty {
            return .bundledDocument(trimmedFile)
        }
        guard !trimmedURL.isEmpty, let url = URL(string: trimmedURL) else { return nil }
        return .document(url)
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
        super.init()
    }
}

private let key = "LMS_DIRECTORY"
extension Config {
    public var lmsDirectory: LMSDirectoryConfig {
        return LMSDirectoryConfig(dictionary: properties[key] as? [String: AnyObject] ?? [:])
    }
}

//
//  InstanceFilePathProvider.swift
//  Core
//
//  Created by Rawan Matar on 20/09/2026.
//

import Foundation
import OEXFoundation

/// Builds the on-disk downloads folder for the current instance + user.
public struct InstanceFilePathProvider: Sendable {
    private let instanceStore: InstanceProvider

    public init(instanceStore: InstanceProvider) {
        self.instanceStore = instanceStore
    }

    /// e.g. Documents/acme/42_Files/. `nil` when there's no signed-in user.
    public func downloadsFolderURL(userId: Int?) -> URL? {
        guard let userId else { return nil }
        let directoryURL = instanceRootURL(instanceKey: instanceStore.currentInstanceKey)
            .appendingPathComponent("\(userId)_Files", isDirectory: true)

        if !FileManager.default.fileExists(atPath: directoryURL.path) {
            do {
                try FileManager.default.createDirectory(
                    at: directoryURL,
                    withIntermediateDirectories: true,
                    attributes: nil
                )
            } catch {
                debugLog("InstanceFilePathProvider: failed to create \(directoryURL.path): \(error)")
                return nil
            }
        }
        return directoryURL
    }

    /// Root folder for an instance key -- used to wipe everything it downloaded on switch.
    public func instanceRootURL(instanceKey: String) -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(instanceKey, isDirectory: true)
    }
}

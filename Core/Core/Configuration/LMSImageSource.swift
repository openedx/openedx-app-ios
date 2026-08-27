//
//  LMSImageSource.swift
//  Core
//
//  Created by Ivan Stepanok on 20.08.2026.
//

import Foundation
import UIKit

/// Where a directory image actually comes from.
/// The directory document carries image fields as plain strings. A string that
/// looks like a web address is fetched; anything else is the name of a file
/// shipped inside the app. That one rule is what lets the same document work for
/// an operator who hosts their images and for one who bundles them, without a
/// second set of fields to keep in step.
public enum LMSImageSource: Sendable, Hashable {
    /// An http(s) address to download.
    case remote(URL)
    /// A file inside the app bundle, e.g. "acme-logo.png" added to the app target.
    case bundled(name: String)

    /// Classify a value taken from the directory document.
    ///
    /// `URL` accepts "acme-logo.png" quite happily and hands back a URL with no
    /// scheme, so the scheme is what separates the two cases — not whether the
    /// value parsed.
    public init?(url: URL?) {
        guard let url else { return nil }
        self.init(value: url.absoluteString)
    }

    public init?(value: String?) {
        guard let value, !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return nil
        }
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        let scheme = URL(string: trimmed)?.scheme?.lowercased()
        if scheme == "http" || scheme == "https", let url = URL(string: trimmed) {
            self = .remote(url)
        } else {
            self = .bundled(name: trimmed)
        }
    }

    /// The address to download, or nil when the image is already on the device.
    public var remoteURL: URL? {
        if case let .remote(url) = self { return url }
        return nil
    }

    /// The bundled image, looked up in `bundle` and then in the main bundle.
    ///
    /// Both are tried because assets added to the app target and assets living in
    /// a framework's own bundle are equally reasonable places for an operator to
    /// have put them, and which one they picked is not worth documenting.
    public func bundledImage(in bundle: Bundle = .main) -> UIImage? {
        guard case let .bundled(name) = self else { return nil }
        if let image = UIImage(named: name, in: bundle, compatibleWith: nil) {
            return image
        }
        if bundle != .main, let image = UIImage(named: name, in: .main, compatibleWith: nil) {
            return image
        }
        let stem = (name as NSString).deletingPathExtension
        let ext = (name as NSString).pathExtension
        for candidate in [bundle, .main] {
            if let url = candidate.url(forResource: stem, withExtension: ext.isEmpty ? nil : ext),
               let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                return image
            }
        }
        return nil
    }
}

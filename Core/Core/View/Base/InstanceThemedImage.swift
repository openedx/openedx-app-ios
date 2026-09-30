//
//  InstanceThemedImage.swift
//  Core
//
//  Created by Rawan Matar on 22/09/2026.
//

import SwiftUI
import UIKit

/// Session-lifetime decoded-image cache so a logo already seen doesn't flash fallback ->
/// branded again on every reappearance (list scroll, revisiting a screen). `URLCache` already
/// avoids the network re-fetch; this avoids the re-decode and, more importantly, the placeholder
/// frame `AsyncImage` always renders first even for a cached response. `NSCache` is thread-safe
/// at runtime (Apple's own docs), but isn't `Sendable`, so the compiler can't verify that --
/// `nonisolated(unsafe)` is the same escape hatch Theme.swift already uses for its static colors.
private enum InstanceImageCache {
    private nonisolated(unsafe) static let cache = NSCache<NSString, UIImage>()

    static func image(for key: String) -> UIImage? {
        cache.object(forKey: key as NSString)
    }

    static func store(_ image: UIImage, for key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}

/// Resolves an `Instance`-provided image source (`logoURLString`/`headerBackgroundURLString`)
/// to a displayable image: a remote URL loads via `URLSession` (backed by `URLCache` on disk,
/// and `InstanceImageCache` in memory for the rest of the session -- see above); a bundled
/// asset name (only `logoURLString` allows this) resolves via `UIImage(named:)`; anything else
/// -- `nil`, an unparsable URL, or a missing asset -- falls back to `fallback`. Callers chain
/// their own sizing/`aspectRatio` modifiers, same as `Image`.
public struct InstanceThemedImage: View {
    private let source: String?
    private let allowsBundledAsset: Bool
    private let fallback: Image

    @State private var loadedImage: UIImage?

    public init(source: String?, allowsBundledAsset: Bool = false, fallback: Image) {
        self.source = source
        self.allowsBundledAsset = allowsBundledAsset
        self.fallback = fallback
        _loadedImage = State(initialValue: source.flatMap(Self.cachedImage))
    }

    public var body: some View {
        if let source, let url = URL(string: source), let scheme = url.scheme,
           scheme.hasPrefix("http") {
            Group {
                if let loadedImage {
                    Image(uiImage: loadedImage).resizable()
                } else {
                    fallback.resizable()
                }
            }
            .task(id: source) {
                guard loadedImage == nil else { return }
                guard let (data, _) = try? await URLSession.shared.data(from: url),
                      let uiImage = UIImage(data: data) else { return }
                InstanceImageCache.store(uiImage, for: source)
                loadedImage = uiImage
            }
        } else if allowsBundledAsset, let source, let uiImage = UIImage(named: source) {
            Image(uiImage: uiImage).resizable()
        } else {
            fallback.resizable()
        }
    }

    /// Memory cache first (this session), then `URLCache`'s disk cache (a prior launch) --
    /// checked synchronously so a previously-seen logo never flashes fallback first.
    private static func cachedImage(for source: String) -> UIImage? {
        if let cached = InstanceImageCache.image(for: source) {
            return cached
        }
        guard let url = URL(string: source),
              let data = URLCache.shared.cachedResponse(for: URLRequest(url: url))?.data,
              let uiImage = UIImage(data: data) else {
            return nil
        }
        InstanceImageCache.store(uiImage, for: source)
        return uiImage
    }
}

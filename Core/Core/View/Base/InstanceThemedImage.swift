//
//  InstanceThemedImage.swift
//  Core
//
//  Created by Rawan Matar on 22/09/2026.
//

import SwiftUI

/// Resolves an `Instance`-provided image source (`logoURLString`/`headerBackgroundURLString`)
/// to a displayable image: a remote URL loads via `AsyncImage`; a bundled asset name (only
/// `logoURLString` allows this) resolves via `UIImage(named:)`; anything else -- `nil`, an
/// unparsable URL, or a missing asset -- falls back to `fallback`. First use of `AsyncImage`
/// in this codebase. Callers chain their own sizing/`aspectRatio` modifiers, same as `Image`.
public struct InstanceThemedImage: View {
    private let source: String?
    private let allowsBundledAsset: Bool
    private let fallback: Image

    public init(source: String?, allowsBundledAsset: Bool = false, fallback: Image) {
        self.source = source
        self.allowsBundledAsset = allowsBundledAsset
        self.fallback = fallback
    }

    public var body: some View {
        if let source, let url = URL(string: source), let scheme = url.scheme,
           scheme.hasPrefix("http") {
            AsyncImage(url: url) { image in
                image.resizable()
            } placeholder: {
                fallback.resizable()
            }
        } else if allowsBundledAsset, let source, let uiImage = UIImage(named: source) {
            Image(uiImage: uiImage).resizable()
        } else {
            fallback.resizable()
        }
    }
}

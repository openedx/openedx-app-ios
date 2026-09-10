//
//  ThemeDefinition.swift
//  Theme
//
//  Created by Rawan Matar on 31/08/2026.
//

import SwiftUI

public struct ThemeDefinition: Sendable {
    public var name: String
    public var appLogo: Image
    /// Set when the logo is a remote URL; falls back to `appLogo` while loading/on failure.
    public var appLogoURL: URL?
    public var bgColor: Image
    /// Set when the header background is a remote URL; falls back to `bgColor`.
    public var appHeaderBackgroundURL: URL?
    public var colors: ThemeColorSet
    public var fonts: ThemeFontSet

    public init(
        colors: ThemeColorSet = .default,
        fonts: ThemeFontSet = .default,
        appLogo: Image = ThemeAssets.appLogo.swiftUIImage,
        appLogoURL: URL? = nil,
        bgColor: Image = ThemeAssets.headerBackground.swiftUIImage,
        appHeaderBackgroundURL: URL? = nil,
        name: String = "default"
    ) {
        self.colors = colors
        self.fonts = fonts
        self.appLogo = appLogo
        self.appLogoURL = appLogoURL
        self.bgColor = bgColor
        self.appHeaderBackgroundURL = appHeaderBackgroundURL
        self.name = name
    }

    /// Compiled default theme, unaffected by any tenant.
    public static let `default` = ThemeDefinition()

    /// Resolves a tenant's theme straight from its JSON fields. `key == nil` returns `.default`.
    ///
    /// - Parameters:
    ///   - key: the tenant's stable `Tenant.key`.
    ///   - tenantName: display name, used as `ThemeDefinition.name`.
    ///   - colorHex: the tenant's `color` field — fallback accent, and the value used
    ///     for any color `themeColorsLight`/`themeColorsDark` don't set.
    ///   - themeColorsLight: the tenant's `THEME.light` block (snake_case field -> hex).
    ///   - themeColorsDark: the tenant's `THEME.dark` block; a missing field reuses light.
    ///   - logoURLString: `http(s)://...` resolves via `appLogoURL` (remote), anything
    ///     else is looked up as a bundled asset name; `nil`/not-found keeps the default logo.
    ///   - headerBackgroundURLString: `http(s)://...` resolves via `appHeaderBackgroundURL`;
    ///     otherwise keeps the compiled default `bgColor`.
    public static func resolve(
        key: String?,
        tenantName: String?,
        colorHex: String?,
        themeColorsLight: [String: String] = [:],
        themeColorsDark: [String: String] = [:],
        logoURLString: String? = nil,
        headerBackgroundURLString: String? = nil
    ) -> ThemeDefinition {
        guard let key else { return .default }

        var resolved = ThemeDefinition.default
        resolved.name = tenantName ?? key
        resolved.colors = .derived(fromHex: colorHex ?? "#007AFF", light: themeColorsLight, dark: themeColorsDark)

        if let logoURLString {
            if let url = httpsURL(from: logoURLString) {
                resolved.appLogoURL = url
            } else if let bundled = bundledLogoImage(named: logoURLString) {
                resolved.appLogo = bundled
            }
        }

        if let headerBackgroundURLString {
            resolved.appHeaderBackgroundURL = httpsURL(from: headerBackgroundURLString)
        }

        return resolved
    }

    /// "http(s)://..." -> `URL`, anything else -> `nil`.
    private static func httpsURL(from string: String) -> URL? {
        guard let url = URL(string: string),
              let scheme = url.scheme?.lowercased(), scheme == "http" || scheme == "https"
        else { return nil }
        return url
    }

    /// Looks up a bundled image asset by name (for tenant-JSON-supplied logo names).
    private static func bundledLogoImage(named name: String) -> Image? {
        guard let uiImage = UIImage(named: name, in: Bundle(for: ThemeBundleMarker.self), compatibleWith: nil) else {
            return nil
        }
        return Image(uiImage: uiImage)
    }
}

private final class ThemeBundleMarker {}

/// In-memory cache so a tenant image (logo, header background) only downloads
/// once per app run. Keyed by URL, so logos and header backgrounds share one cache.
private final class RemoteThemeImageCache: @unchecked Sendable {
    static let shared = RemoteThemeImageCache()
    private let cache = NSCache<NSURL, UIImage>()

    func image(for url: URL) -> UIImage? {
        cache.object(forKey: url as NSURL)
    }

    func store(_ image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url as NSURL)
    }
}

/// Renders a remote tenant-branding image at `url`, falling back to `fallback`
/// while loading, on failure, or when `url` is `nil`.
private struct RemoteThemeImage: View {
    let url: URL?
    let fallback: Image
    @State private var loadedImage: UIImage?

    init(url: URL?, fallback: Image) {
        self.url = url
        self.fallback = fallback
        // Synchronous cache check so a cache hit renders immediately, no placeholder flash.
        _loadedImage = State(initialValue: url.flatMap(RemoteThemeImageCache.shared.image(for:)))
    }

    var body: some View {
        Group {
            if let loadedImage {
                Image(uiImage: loadedImage).resizable()
            } else {
                fallback.resizable()
            }
        }
        .task(id: url) {
            await load()
        }
    }

    @MainActor
    private func load() async {
        guard let url else {
            loadedImage = nil
            return
        }
        if let cached = RemoteThemeImageCache.shared.image(for: url) {
            loadedImage = cached
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let uiImage = UIImage(data: data) else { return }
            RemoteThemeImageCache.shared.store(uiImage, for: url)
            loadedImage = uiImage
        } catch {
            #if DEBUG
            print("⚠️ RemoteThemeImage: failed to load \(url.absoluteString) — \(error)")
            #endif
        }
    }
}

/// A resolved theme's logo — remote (`appLogoURL`) falling back to bundled (`appLogo`).
public struct TenantLogoImage: View {
    let theme: ThemeDefinition

    public init(theme: ThemeDefinition) {
        self.theme = theme
    }

    public var body: some View {
        RemoteThemeImage(url: theme.appLogoURL, fallback: theme.appLogo)
    }
}

/// A resolved theme's header banner — remote (`appHeaderBackgroundURL`) falling back to `bgColor`.
public struct TenantHeaderBackgroundImage: View {
    let theme: ThemeDefinition

    public init(theme: ThemeDefinition) {
        self.theme = theme
    }

    public var body: some View {
        RemoteThemeImage(url: theme.appHeaderBackgroundURL, fallback: theme.bgColor)
    }
}

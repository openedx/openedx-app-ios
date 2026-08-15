//
//  LMSDirectoryState.swift
//  Core
//
//  What the app remembers about the directory between launches, and the rule
//  that decides when to stop believing it.
//
//  Only the server can say whether a live catalog is curated, and it says so on a
//  screen the app skips once a platform has been picked. So the answer is
//  remembered — and a remembered answer is worth exactly nothing after the build
//  has been pointed at a different directory. Everything stored here is therefore
//  stamped with the source it came from, and read back only when that still
//  matches.
//

import Foundation

public enum LMSDirectoryState {

    private enum Keys {
        static let curated = "lmsDirectory.isCurated"
        static let sourceKey = "lmsDirectory.sourceKey"
    }

    /// Record what the server said, against the source that said it.
    public static func rememberCurated(
        _ curated: Bool,
        for config: LMSDirectoryConfig,
        defaults: UserDefaults = .standard
    ) {
        defaults.set(curated, forKey: Keys.curated)
        defaults.set(config.sourceKey, forKey: Keys.sourceKey)
    }

    /// Forget everything source-specific. Used when the feature is switched off.
    public static func clear(defaults: UserDefaults = .standard) {
        defaults.removeObject(forKey: Keys.curated)
        defaults.removeObject(forKey: Keys.sourceKey)
    }

    /**
     Whether this build shows a fixed list of platforms.

     The config decides on its own whenever it can. Only when it cannot — a live
     service with no forced mode — does the remembered answer matter, and then
     only if it was recorded against this same source. A value left over from a
     different directory is discarded rather than obeyed, which is what stops a
     build that used to be curated from staying curated after it is pointed at an
     open catalog.
     */
    public static func isCurated(
        for config: LMSDirectoryConfig,
        defaults: UserDefaults = .standard
    ) -> Bool {
        if config.isCuratedByConfiguration { return true }
        guard defaults.string(forKey: Keys.sourceKey) == config.sourceKey else { return false }
        return defaults.bool(forKey: Keys.curated)
    }

    /**
     Whether to offer reporting a platform.

     Reporting exists because an open catalog lets a stranger list anything, so it
     needs a live service to post to and a list nobody vouched for. A document has
     no service; a curated catalog vouches for its own platforms.
     */
    public static func canReport(
        for config: LMSDirectoryConfig,
        defaults: UserDefaults = .standard
    ) -> Bool {
        config.supportsReporting && !isCurated(for: config, defaults: defaults)
    }

    /**
     Drop a remembered answer that belongs to a directory this build no longer
     reads. Safe to call on every launch; does nothing when the source is unchanged.
     */
    public static func reconcile(
        with config: LMSDirectoryConfig,
        defaults: UserDefaults = .standard
    ) {
        let stored = defaults.string(forKey: Keys.sourceKey)
        guard stored != nil, stored != config.sourceKey else { return }
        defaults.removeObject(forKey: Keys.curated)
        defaults.removeObject(forKey: Keys.sourceKey)
    }
}

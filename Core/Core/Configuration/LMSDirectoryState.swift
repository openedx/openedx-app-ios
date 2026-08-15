//
//  LMSDirectoryState.swift
//  Core
//
//  What the app knows about the directory it reads, and how long that knowledge
//  is good for.
//
//  Whether a live catalog is open to anyone or is one organisation's own list is
//  something only the server can say, and it says so on a screen the app stops
//  showing once a platform has been picked. So the answer is remembered — and a
//  remembered answer is worth nothing after the build is pointed somewhere else,
//  or after the server changes its mind. Hence three states rather than a flag:
//  until the current source has actually answered, the mode is *unknown*, and
//  anything that depends on it stays hidden.
//

import Foundation

/// What kind of list a directory is.
public enum LMSDirectoryMode: String, Equatable, Sendable {
    /// Nobody has said yet. A live service that has not answered this launch.
    case unknown
    /// An open catalog: anyone may list a platform, so nothing is vouched for.
    case search
    /// A fixed list published by one organisation.
    case curated
}

@MainActor
public final class LMSDirectoryState: ObservableObject {

    /// The one every screen reads. Tests make their own against a scratch suite.
    public static let shared = LMSDirectoryState(defaults: .standard)

    private enum Keys {
        static let mode = "lmsDirectory.mode"
        static let sourceKey = "lmsDirectory.sourceKey"
        /// Written by builds that predate the mode/source pair. Never read.
        static let legacyCurated = "lmsDirectory.isCurated"
    }

    private let defaults: UserDefaults

    /// Bumped whenever the stored answer changes, so a view observing this object
    /// redraws when the server finally answers.
    @Published private var revision: Int = 0

    public init(defaults: UserDefaults) {
        self.defaults = defaults
    }

    // MARK: - Reading

    /**
     What this build's directory is, as far as anyone currently knows.

     A document is a fixed list by construction. `DIRECTORY_MODE` settles it
     locally either way. Only a live service with no override has to ask, and
     until it has answered *for this exact source* the honest answer is `.unknown`.
     */
    public func mode(for config: LMSDirectoryConfig) -> LMSDirectoryMode {
        if let configured = config.configuredMode { return configured }
        guard defaults.string(forKey: Keys.sourceKey) == config.sourceKey,
              let stored = defaults.string(forKey: Keys.mode),
              let mode = LMSDirectoryMode(rawValue: stored) else {
            return .unknown
        }
        return mode
    }

    /**
     Whether to offer reporting a platform.

     Reporting exists because an open catalog lets a stranger list anything, so it
     needs both a live service to post to and a list nobody vouched for. A document
     has no service; a curated catalog vouches for its own platforms; and an
     unanswered service is not yet known to be either, so it shows nothing rather
     than guessing.
     */
    public func canReport(for config: LMSDirectoryConfig) -> Bool {
        config.supportsReporting && mode(for: config) == .search
    }

    // MARK: - Writing

    /// Record what a source said, against the source that said it.
    public func remember(_ mode: LMSDirectoryMode, for config: LMSDirectoryConfig) {
        guard mode != .unknown else { return }
        let changed = defaults.string(forKey: Keys.mode) != mode.rawValue
            || defaults.string(forKey: Keys.sourceKey) != config.sourceKey
        defaults.set(mode.rawValue, forKey: Keys.mode)
        defaults.set(config.sourceKey, forKey: Keys.sourceKey)
        defaults.removeObject(forKey: Keys.legacyCurated)
        if changed { revision &+= 1 }
    }

    /// Forget everything source-specific. Used when the feature is switched off.
    public func clear() {
        defaults.removeObject(forKey: Keys.mode)
        defaults.removeObject(forKey: Keys.sourceKey)
        defaults.removeObject(forKey: Keys.legacyCurated)
        revision &+= 1
    }

    /**
     Drop knowledge that belongs to a directory this build no longer reads.

     Safe on every launch. Also clears the boolean an older build left behind: it
     names no source, so there is no way to tell what it was ever true of.
     */
    public func reconcile(with config: LMSDirectoryConfig) {
        if defaults.object(forKey: Keys.legacyCurated) != nil {
            defaults.removeObject(forKey: Keys.legacyCurated)
            revision &+= 1
        }
        let stored = defaults.string(forKey: Keys.sourceKey)
        guard stored != nil, stored != config.sourceKey else { return }
        defaults.removeObject(forKey: Keys.mode)
        defaults.removeObject(forKey: Keys.sourceKey)
        revision &+= 1
    }

    /**
     Ask the directory what it is, now, rather than trusting what it said last time.

     Called at launch so a service that has changed its mode is noticed even by a
     build that never shows the platform picker again. `ask` returns the mode the
     server reports; a failure leaves what is already known untouched, because a
     network error is not evidence of anything.
     */
    public func refresh(
        for config: LMSDirectoryConfig,
        ask: () async throws -> LMSDirectoryMode
    ) async {
        guard config.configuredMode == nil, config.supportsReporting else { return }
        guard let answered = try? await ask(), answered != .unknown else { return }
        remember(answered, for: config)
    }
}

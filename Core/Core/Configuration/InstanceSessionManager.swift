//
//  InstanceSessionManager.swift
//  Core
//
//  Created by Rawan Matar on 20/09/2026.
//

import Foundation
import SwiftUI
import Theme

/// @mockable
public protocol InstanceSessionManagerProtocol: Sendable {
    /// Switches the active instance without tearing down the outgoing one's session.
    /// Use `logoutCurrentInstance()` to actually end a session.
    func switchActiveInstance(to instance: Instance) async

    /// Logs out of the current instance: cancels downloads, unregisters push, clears
    /// storage, then clears the selection. Leaves CoreData rows and downloaded files
    /// in place so a later re-login resumes fast.
    func logoutCurrentInstance() async

    /// Logs out of `instance`'s session. Routes to `logoutCurrentInstance()` (full teardown)
    /// when it's the active instance; otherwise just clears that instance's stored tokens,
    /// leaving the active session untouched.
    func logout(_ instance: Instance) async

    /// Applies the current instance's accent color (or resets to the app default if none is
    /// selected). Called once at launch after the catalog resolves -- a persisted-selection
    /// restore doesn't go through `switchActiveInstance(to:)`, so nothing else triggers it.
    func applyThemeForCurrentInstance()
}

public final class InstanceSessionManager: InstanceSessionManagerProtocol {
    private let instanceStore: InstanceStore
    private let storage: CoreStorage
    private let downloadManager: DownloadManagerProtocol
    private let pushTokenUnregistrar: PushTokenUnregistering?

    public init(
        instanceStore: InstanceStore,
        storage: CoreStorage,
        downloadManager: DownloadManagerProtocol,
        pushTokenUnregistrar: PushTokenUnregistering? = nil
    ) {
        self.instanceStore = instanceStore
        self.storage = storage
        self.downloadManager = downloadManager
        self.pushTokenUnregistrar = pushTokenUnregistrar
    }

    public func switchActiveInstance(to instance: Instance) async {
        // No teardown -- storage, CoreData, and downloads stay untouched.
        instanceStore.select(instance)

        applyThemeForCurrentInstance()
    }

    public func logoutCurrentInstance() async {
        // Cancel downloads before clearing storage.
        try? await downloadManager.cancelAllDownloading()

        // Unregister push while the access token is still valid.
        await pushTokenUnregistrar?.unregisterCurrentPushToken()

        // Clear tokens/cookies/cached user.
        storage.clear()

        // Clear selection last, so nothing observes a half-logged-out state.
        instanceStore.select(nil)

        applyThemeForCurrentInstance()

        // CoreData rows and downloaded files are left in place on purpose --
        // see CoreDataHandlerProtocol.clear(instanceKey:) for an explicit wipe.
    }

    public func logout(_ instance: Instance) async {
        if instanceStore.currentInstance?.key == instance.key {
            await logoutCurrentInstance()
        } else {
            storage.clearSession(forInstanceKey: instance.key)
        }
    }

    public func applyThemeForCurrentInstance() {
        guard let accentColor = Self.resolveAccentColor(for: instanceStore.currentInstance) else {
            // Nothing selected, or the instance didn't supply an accent_color -- back to
            // the app-level default (every other Theme.Colors.update() param already
            // defaults to it).
            Theme.Colors.update()
            Theme.UIColors.update()
            return
        }
        Theme.Colors.update(accentColor: Color(uiColor: accentColor))
        Theme.UIColors.update(accentColor: accentColor)
    }

    /// A single UIColor that resolves to the instance's light/dark "accent_color" hex per the
    /// active trait collection -- SwiftUI's `Color(uiColor:)` stays adaptive through this.
    private static func resolveAccentColor(for instance: Instance?) -> UIColor? {
        guard let lightHex = instance?.themeColors?.light["accent_color"],
              let light = UIColor(hex: lightHex) else {
            return nil
        }
        let dark = instance?.themeColors?.dark["accent_color"].flatMap { UIColor(hex: $0) } ?? light
        return UIColor { $0.userInterfaceStyle == .dark ? dark : light }
    }
}

#if DEBUG
public final class InstanceSessionManagerProtocolMock: InstanceSessionManagerProtocol, @unchecked Sendable {
    public private(set) var switchActiveInstanceCallCount = 0
    public private(set) var logoutCurrentInstanceCallCount = 0
    public private(set) var logoutCallCount = 0
    public private(set) var lastLoggedOutInstance: Instance?

    /// Optional side effect run by `logout(_:)`, for tests that need to simulate the real
    /// implementation's storage mutation (e.g. clearing a `CoreStorageMock` session key).
    public var logoutHandler: ((Instance) -> Void)?

    public init() {}

    public func switchActiveInstance(to instance: Instance) async {
        switchActiveInstanceCallCount += 1
    }

    public func logoutCurrentInstance() async {
        logoutCurrentInstanceCallCount += 1
    }

    public func logout(_ instance: Instance) async {
        logoutCallCount += 1
        lastLoggedOutInstance = instance
        logoutHandler?(instance)
    }

    public private(set) var applyThemeForCurrentInstanceCallCount = 0
    public func applyThemeForCurrentInstance() {
        applyThemeForCurrentInstanceCallCount += 1
    }
}
#endif

//
//  InstanceSessionManager.swift
//  Core
//
//  Created by Rawan Matar on 20/09/2026.
//

import Foundation

/// @mockable
public protocol InstanceSessionManagerProtocol: Sendable {
    /// Switches the active instance without tearing down the outgoing one's session.
    /// Use `logoutCurrentInstance()` to actually end a session.
    func switchActiveInstance(to instance: Instance) async

    /// Logs out of the current instance: cancels downloads, unregisters push, clears
    /// storage, then clears the selection. Leaves CoreData rows and downloaded files
    /// in place so a later re-login resumes fast.
    func logoutCurrentInstance() async
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

        // No ThemeManager yet -- apply per-instance theme here once it exists.
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

        // No ThemeManager yet -- reset theme here once it exists.

        // CoreData rows and downloaded files are left in place on purpose --
        // see CoreDataHandlerProtocol.clear(instanceKey:) for an explicit wipe.
    }
}

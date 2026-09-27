//
//  LearningSitesViewModel.swift
//  Authorization
//
//  Created by Rawan Matar on 22/09/2026.
//

import Foundation
import Core

@MainActor
@Observable public class LearningSitesViewModel {

    private let instanceStore: InstanceStore
    private let storage: CoreStorage
    private let sessionManager: InstanceSessionManagerProtocol
    let router: AuthorizationRouter

    /// true when pushed from Settings (shows a back button, manages existing sites); false
    /// at first launch, where this is the root screen with nothing logged into yet.
    let isSwitching: Bool

    /// Catalog instances the user is already logged into.
    private(set) var currentLearningSites: [Instance] = []

    /// Catalog instances not yet logged into, filtered by `searchText`.
    private(set) var addableSites: [Instance] = []

    var searchText: String = "" {
        didSet { updateAddableSites() }
    }

    /// The full catalog, alphabetical -- refreshed on init and after a logout, since that's
    /// the only action that can change which instances count as "learning sites".
    private var catalog: [Instance] = []

    public init(
        instanceStore: InstanceStore,
        storage: CoreStorage,
        sessionManager: InstanceSessionManagerProtocol,
        router: AuthorizationRouter,
        isSwitching: Bool
    ) {
        self.instanceStore = instanceStore
        self.storage = storage
        self.sessionManager = sessionManager
        self.router = router
        self.isSwitching = isSwitching
        refresh()
    }

    private func hasSession(_ instance: Instance) -> Bool {
        storage.hasSession(forInstanceKey: instance.key)
    }

    private func refresh() {
        catalog = instanceStore.instancesConfig.instances.sorted {
            $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
        }
        currentLearningSites = catalog.filter(hasSession)
        updateAddableSites()
    }

    private func updateAddableSites() {
        let notLoggedIn = catalog.filter { !hasSession($0) }
        guard !searchText.isEmpty else {
            addableSites = notLoggedIn
            return
        }
        addableSites = notLoggedIn.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
                || $0.instanceName.localizedCaseInsensitiveContains(searchText)
        }
    }

    /// Selecting an already-signed-in site switches straight to Main; otherwise switches
    /// the active instance and routes to that site's own Sign In screen.
    func select(_ instance: Instance) async {
        let alreadySignedIn = hasSession(instance)
        await sessionManager.switchActiveInstance(to: instance)
        if alreadySignedIn {
            router.showMainOrWhatsNewScreen(sourceScreen: .learningSites, postLoginData: nil)
        } else {
            router.showLoginScreen(sourceScreen: .learningSites)
        }
    }

    /// Logs out of `instance`. Full teardown if it's the active instance, otherwise just
    /// clears that instance's stored session -- see `InstanceSessionManagerProtocol.logout`.
    /// The confirm dialog is presented by the view directly (`router.presentAlert`), same
    /// pattern as Settings' own Log Out button -- no pending-state needed here.
    func logOut(_ instance: Instance) async {
        await sessionManager.logout(instance)
        refresh()
    }
}

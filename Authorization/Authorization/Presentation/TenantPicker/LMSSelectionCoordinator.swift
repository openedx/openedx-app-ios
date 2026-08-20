//
//  LMSSelectionCoordinator.swift
//  Authorization
//
//  Created by Ivan Stepanok on 20.08.2026.
//

import Core
import Foundation
import Swinject
import OEXFoundation
import Alamofire

@MainActor
public protocol LMSSelectionRouting: AnyObject {
    func presentDiscovery()
    func showLogin()
    /// Return to the LMS directory landing (the sign-in "Change" affordance).
    func showLanding()
}

@MainActor
protocol LMSSelectionCoordinating: Sendable {
    func applySelection(detail: LMSDetail, payload: Data) async
}

@MainActor
final class LMSSelectionCoordinator: LMSSelectionCoordinating {
    private let overridesStore: LMSOverridesStoreProtocol
    private let analytics: LMSDirectoryAnalytics
    private weak var router: LMSSelectionRouting?
    private let coreStorage: CoreStorage?
    private let container: Container

    init(
        overridesStore: LMSOverridesStoreProtocol,
        analytics: LMSDirectoryAnalytics,
        router: LMSSelectionRouting?,
        coreStorage: CoreStorage?,
        container: Container
    ) {
        self.overridesStore = overridesStore
        self.analytics = analytics
        self.router = router
        self.coreStorage = coreStorage
        self.container = container
    }

    func applySelection(detail: LMSDetail, payload: Data) async {
        do {
            try overridesStore.save(detail: detail, payload: payload, storage: coreStorage)
            analytics.selectionMade(id: detail.id)
            LMSThemeApplier.applyAccentColor(detail.accentColor, darkColor: detail.accentColorDark)
            LMSThemeApplier.applyLoginBackground(LMSImageSource(url: detail.theme?.loginBackgroundURL))
            reRegisterAPI(with: detail.api.hostURL)
            await handlePostSelection(for: detail)
        } catch {
            assertionFailure("Failed to apply LMS selection: \(error)")
        }
    }

    private func reRegisterAPI(with baseURL: URL) {
        container.register(API.self) { r in
            API(session: r.resolve(Alamofire.Session.self)!, baseURL: baseURL)
        }.inObjectScope(.container)
    }

    private func handlePostSelection(for detail: LMSDetail) async {
        if detail.featureFlags.preLoginDiscovery {
            router?.presentDiscovery()
        } else {
            router?.showLogin()
        }
    }
}

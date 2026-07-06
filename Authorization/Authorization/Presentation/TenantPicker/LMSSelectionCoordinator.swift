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
    func applySelection(
        detail: LMSDetail,
        payload: Data,
        fromHistory: Bool
    ) async
}

@MainActor
final class LMSSelectionCoordinator: LMSSelectionCoordinating {
    private let historyStore: LMSHistoryStoreProtocol
    private let overridesStore: LMSOverridesStoreProtocol
    private let analytics: LMSDirectoryAnalytics
    private weak var router: LMSSelectionRouting?
    private let coreStorage: CoreStorage?
    private let container: Container

    init(
        historyStore: LMSHistoryStoreProtocol,
        overridesStore: LMSOverridesStoreProtocol,
        analytics: LMSDirectoryAnalytics,
        router: LMSSelectionRouting?,
        coreStorage: CoreStorage?,
        container: Container
    ) {
        self.historyStore = historyStore
        self.overridesStore = overridesStore
        self.analytics = analytics
        self.router = router
        self.coreStorage = coreStorage
        self.container = container
    }

    func applySelection(
        detail: LMSDetail,
        payload: Data,
        fromHistory: Bool
    ) async {
        do {
            try historyStore.unpinAll()
            try historyStore.save(detail: detail, payload: payload, pinned: true)
            try overridesStore.save(detail: detail, payload: payload, storage: coreStorage)
            analytics.selectionMade(id: detail.id, fromHistory: fromHistory)
            LMSThemeApplier.applyAccentColor(detail.accentColor, darkColor: detail.accentColorDark)
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

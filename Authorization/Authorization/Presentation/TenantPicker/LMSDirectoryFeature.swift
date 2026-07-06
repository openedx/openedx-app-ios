import Core
import Foundation
import SwiftUI
import UIKit
import Swinject

public struct LMSDirectorySelectionInfo: Equatable, Sendable {
    public let title: String
    public let logoURL: URL?
}

public enum LMSDirectoryFeature {

    private nonisolated(unsafe) static var isRegistered = false
    private nonisolated(unsafe) static var isEnabled = false
    private nonisolated(unsafe) static var directoryURL: URL?
    private nonisolated(unsafe) static var logoutObserver: NSObjectProtocol?

    private static let landingTitle = NSLocalizedString(
        "Find your LMS",
        comment: "Title for universal app landing screen"
    )

    public static func register(directoryBaseURL: String? = nil) {
        guard !isRegistered else { return }
        isRegistered = true
        isEnabled = true
        if let urlString = directoryBaseURL, let url = URL(string: urlString) {
            directoryURL = url
            // Bridge the registry URL to shared storage so other modules (e.g. the
            // Profile tab's "Report this LMS") can post complaints without a direct
            // dependency on this feature. Mirrors how the selected LMS base URL is shared.
            UserDefaults.standard.set(url.absoluteString, forKey: "lmsRegistryURL")
        }
        registerDependencies()
        applyPersistedSelectionIfNeeded()
        observeLogout()
    }

    public static func shouldPresentLanding(storage: CoreStorage?) -> Bool {
        guard isEnabled else { return false }
        let selectedUrl = storage?.selectedLMSBaseURL
        return selectedUrl == nil || selectedUrl?.isEmpty == true
    }

    @MainActor
    public static func makeLandingController() -> UIViewController {
        let viewModel = makeViewModel()
        let view = LMSDirectoryLandingView(viewModel: viewModel)
        let controller = UIHostingController(rootView: view)
        controller.title = landingTitle
        controller.navigationItem.largeTitleDisplayMode = .never
        return controller
    }

    public static func currentSelectionInfo() -> LMSDirectorySelectionInfo? {
        guard isEnabled else { return nil }
        let overrides = Container.shared.resolve(LMSOverridesStoreProtocol.self) ?? LMSOverridesStore()
        guard let detail = overrides.currentSelection() else { return nil }
        return LMSDirectorySelectionInfo(
            title: detail.title,
            logoURL: detail.logoURL
        )
    }

    @MainActor
    private static func makeViewModel() -> LMSDirectoryViewModel {
        let container = Container.shared
        // The coordinator is @MainActor; build it here (this factory is @MainActor)
        // rather than via a nonisolated Swinject factory.
        let coordinator = LMSSelectionCoordinator(
            historyStore: container.resolve(LMSHistoryStoreProtocol.self)!,
            overridesStore: container.resolve(LMSOverridesStoreProtocol.self)!,
            analytics: container.resolve(LMSDirectoryAnalytics.self)!,
            router: container.resolve(LMSSelectionRouting.self),
            coreStorage: container.resolve(CoreStorage.self),
            container: container
        )
        return LMSDirectoryViewModel(
            service: container.resolve(LMSDirectoryService.self)!,
            historyStore: container.resolve(LMSHistoryStoreProtocol.self)!,
            coordinator: coordinator,
            overridesStore: container.resolve(LMSOverridesStoreProtocol.self)!,
            analytics: container.resolve(LMSDirectoryAnalytics.self)!
        )
    }

    private static func registerDependencies() {
        let container = Container.shared

        container.register(LMSHistoryStoreProtocol.self) { _ in
            LMSHistoryStore()
        }.inObjectScope(.container)

        container.register(LMSOverridesStoreProtocol.self) { _ in
            LMSOverridesStore()
        }.inObjectScope(.container)

        container.register(LMSDirectoryAnalytics.self) { _ in
            LMSDirectoryAnalyticsNoop()
        }.inObjectScope(.container)

        container.register(LMSDirectoryService.self) { resolver in
            if let baseURL = directoryURL {
                return RemoteLMSDirectoryService(baseURL: baseURL)
            }
            let connectivity = resolver.resolve(ConnectivityProtocol.self)!
            return MockLMSDirectoryService(connectivity: connectivity)
        }.inObjectScope(.container)
    }

    private static func applyPersistedSelectionIfNeeded() {
        let overrides = Container.shared.resolve(LMSOverridesStoreProtocol.self) ?? LMSOverridesStore()
        guard let selection = overrides.currentSelection() else { return }

        LMSThemeApplier.applyAccentColor(selection.accentColor, darkColor: selection.accentColorDark)
        // Config classes (UIComponentsConfig, DashboardConfig, FeaturesConfig)
        // read UserDefaults overrides automatically — no manual override needed
    }

    private static func observeLogout() {
        logoutObserver = NotificationCenter.default.addObserver(
            forName: .userLoggedOut,
            object: nil,
            queue: nil
        ) { _ in
            resetOverrides()
        }
    }

    private static func resetOverrides() {
        let overrides = Container.shared.resolve(LMSOverridesStoreProtocol.self) ?? LMSOverridesStore()
        let history = Container.shared.resolve(LMSHistoryStoreProtocol.self) ?? LMSHistoryStore()
        let storage = Container.shared.resolve(CoreStorage.self)
        try? overrides.clear(storage: storage)
        try? history.unpinAll()
        LMSThemeApplier.applyAccentColor(nil)
    }
}

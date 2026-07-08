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
        // Client-side DIRECTORY_MODE override: a non-empty value forces the mode.
        let directoryMode = container.resolve(ConfigProtocol.self)?.lmsDirectory.directoryMode ?? ""
        return LMSDirectoryViewModel(
            service: container.resolve(LMSDirectoryService.self)!,
            historyStore: container.resolve(LMSHistoryStoreProtocol.self)!,
            coordinator: coordinator,
            overridesStore: container.resolve(LMSOverridesStoreProtocol.self)!,
            analytics: container.resolve(LMSDirectoryAnalytics.self)!,
            connectivity: container.resolve(ConnectivityProtocol.self)!,
            directoryModeOverride: directoryMode
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
            #if DEBUG
            // Bundled sample catalog is DEBUG-only so it can never ship in a release
            // build. In production the feature is gated on `lmsDirectory.isDirectoryReachable`
            // (see AppDelegate/RouteController/Router), so this factory is only ever built
            // with a real registry URL via the branch above.
            let connectivity = resolver.resolve(ConnectivityProtocol.self)!
            return MockLMSDirectoryService(connectivity: connectivity)
            #else
            fatalError(
                "LMSDirectoryService requires a registry URL. The LMS Directory feature must be "
                + "activated only when lmsDirectory.isDirectoryReachable is true; there is no mock "
                + "catalog fallback in release builds."
            )
            #endif
        }.inObjectScope(.container)

        // LMSSelectionCoordinating is intentionally NOT registered as a Swinject
        // factory: the coordinator is @MainActor-isolated while Swinject's factory
        // closure is nonisolated, so a registration drops the global actor and fails
        // to compile under Swift 6 (converting an '@MainActor @Sendable (Resolver) -> ...'
        // loses 'MainActor'). makeViewModel builds it inline on the main actor instead.
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

    /// Purge any persisted LMS selection (base URL, branding, OAuth/feedback overrides)
    /// and reset the theme to stock. Safe to call even when the feature never registered —
    /// it falls back to a default store. Called on logout and when the feature is
    /// disabled/unreachable at launch, so a stale selection can't leak branding into the
    /// header/logo or route the app to a since-removed host.
    public static func clearPersistedSelection() {
        let overrides = Container.shared.resolve(LMSOverridesStoreProtocol.self) ?? LMSOverridesStore()
        let storage = Container.shared.resolve(CoreStorage.self)
        try? overrides.clear(storage: storage)
        LMSThemeApplier.applyAccentColor(nil)
    }

    private static func resetOverrides() {
        clearPersistedSelection()
        let history = Container.shared.resolve(LMSHistoryStoreProtocol.self) ?? LMSHistoryStore()
        try? history.unpinAll()
    }
}

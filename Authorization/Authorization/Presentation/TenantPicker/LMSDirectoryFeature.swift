//
//  LMSDirectoryFeature.swift
//  Authorization
//
//  Created by Ivan Stepanok on 20.08.2026.
//

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
    private nonisolated(unsafe) static var source: LMSDirectoryConfig.Source?
    private nonisolated(unsafe) static var logoutObserver: NSObjectProtocol?

    private static let landingTitle = AuthLocalization.LmsDirectory.title

    public static func register(source: LMSDirectoryConfig.Source? = nil) {
        guard !isRegistered else { return }
        isRegistered = true
        isEnabled = true
        Self.source = source
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
            overridesStore: container.resolve(LMSOverridesStoreProtocol.self)!,
            analytics: container.resolve(LMSDirectoryAnalytics.self)!,
            router: container.resolve(LMSSelectionRouting.self),
            coreStorage: container.resolve(CoreStorage.self),
            container: container
        )
        return LMSDirectoryViewModel(
            service: container.resolve(LMSDirectoryService.self)!,
            coordinator: coordinator,
            overridesStore: container.resolve(LMSOverridesStoreProtocol.self)!,
            analytics: container.resolve(LMSDirectoryAnalytics.self)!
        )
    }

    private static func registerDependencies() {
        let container = Container.shared

        container.register(LMSOverridesStoreProtocol.self) { _ in
            LMSOverridesStore()
        }.inObjectScope(.container)

        container.register(LMSDirectoryAnalytics.self) { _ in
            LMSDirectoryAnalyticsNoop()
        }.inObjectScope(.container)

        container.register(LMSDirectoryService.self) { _ in
            switch source {
            case let .document(url):
                return StaticLMSDirectoryService(source: .url(url))
            case let .bundledDocument(name):
                return StaticLMSDirectoryService(
                    source: .bundledFile(name: name, bundle: .lmsDirectoryHost)
                )
            case .none:
                // The feature is only ever registered when the config names a
                // source (see AppDelegate/RouteController/Router), so this is a
                // programming error rather than a state a build can ship in.
                fatalError("LMSDirectoryService requires a directory source.")
            }
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
        LMSThemeApplier.applyLoginBackground(LMSImageSource(url: selection.theme?.loginBackgroundURL))
        // Config classes (UIComponentsConfig, DashboardConfig, FeaturesConfig)
        // read UserDefaults overrides automatically — no manual override needed
    }

    private static func observeLogout() {
        logoutObserver = NotificationCenter.default.addObserver(
            forName: .userLoggedOut,
            object: nil,
            queue: nil
        ) { _ in
            clearPersistedSelection()
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
        LMSThemeApplier.applyLoginBackground(nil)
    }

}

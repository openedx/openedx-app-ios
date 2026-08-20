//
//  LMSDirectoryViewModel.swift
//  Authorization
//
//  Created by Ivan Stepanok on 20.08.2026.
//

import Core
import Foundation

/// The platform picker: read the directory, show what is in it, and hand the
/// chosen platform to the coordinator that re-themes the app and routes on to
/// sign-in.
@MainActor
final class LMSDirectoryViewModel: ObservableObject {

    enum ViewState: Equatable {
        case loading
        case ready
        case empty
        case failed(String)
    }

    @Published private(set) var platforms: [LMSSummary] = []
    @Published private(set) var providerName: String?
    @Published private(set) var state: ViewState = .loading

    private let service: LMSDirectoryService
    private let coordinator: LMSSelectionCoordinating
    private let overridesStore: LMSOverridesStoreProtocol
    private let analytics: LMSDirectoryAnalytics

    init(
        service: LMSDirectoryService,
        coordinator: LMSSelectionCoordinating,
        overridesStore: LMSOverridesStoreProtocol,
        analytics: LMSDirectoryAnalytics
    ) {
        self.service = service
        self.coordinator = coordinator
        self.overridesStore = overridesStore
        self.analytics = analytics
        applyPersistedTheme()
        Task { await load() }
    }

    func select(_ platform: LMSSummary) {
        Task { await applyDetails(id: platform.id) }
    }

    func retry() {
        Task { await load() }
    }

    // MARK: - Private

    private func load() async {
        state = .loading
        do {
            let items = try await service.platforms()
            platforms = items
            state = items.isEmpty ? .empty : .ready
            if let document = service as? StaticLMSDirectoryService {
                providerName = try? await document.providerName()
            }
            await prefetchArtwork(for: items)
        } catch {
            state = .failed(AuthLocalization.LmsDirectory.loadFailed)
        }
    }

    /**
     Pull the images the next screens will need into the shared cache.

     The whole directory arrives in one document, so every platform's sign-in
     background is known while the learner is still choosing. Fetching them now
     is the difference between a branded screen that draws in its first frame and
     one that shows a placeholder first.
     */
    private func prefetchArtwork(for items: [LMSSummary]) async {
        var sources = items.compactMap { LMSImageSource(url: $0.logoURL) }
        if let document = service as? StaticLMSDirectoryService,
           let all = try? await document.imageSources() {
            sources = all
        }
        LMSThemeApplier.prefetch(sources)
    }

    private func applyDetails(id: String) async {
        do {
            let detail = try await service.details(id: id)
            guard let payload = try? JSONEncoder().encode(detail.asDTO()) else {
                state = .failed(AuthLocalization.LmsDirectory.invalidPlatform)
                return
            }
            await coordinator.applySelection(detail: detail, payload: payload)
        } catch {
            state = .failed(AuthLocalization.LmsDirectory.selectFailed)
        }
    }

    /// Re-apply the branding of whatever was chosen last, so returning to this
    /// screen does not flash the stock theme before a choice is made.
    private func applyPersistedTheme() {
        guard let selection = overridesStore.currentSelection() else { return }
        LMSThemeApplier.applyAccentColor(selection.accentColor, darkColor: selection.accentColorDark)
        LMSThemeApplier.applyLoginBackground(LMSImageSource(url: selection.theme?.loginBackgroundURL))
    }
}

private extension LMSDetail {
    func asDTO() -> LMSDetailDTO {
        LMSDetailDTO(
            id: id,
            title: title,
            description: description,
            api: .init(
                hostURL: api.hostURL,
                feedbackEmail: api.feedbackEmail,
                oauthClientId: api.oauthClientId
            ),
            featureFlags: featureFlags,
            theme: theme,
            uiComponents: uiComponents,
            dashboard: dashboard,
            accentColor: accentColorHex,
            shortDescription: shortDescription,
            baseURL: baseURL,
            logoURL: logoURL
        )
    }
}

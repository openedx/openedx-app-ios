import Combine
import Core
import Foundation

@MainActor
final class LMSDirectoryViewModel: ObservableObject {

    enum ViewState: Equatable {
        case idle
        case history
        case searching
        case results
        case empty
        case offline
        case error(String)
    }

    @Published var searchText: String = "" {
        didSet {
            scheduleSearch()
        }
    }
    @Published private(set) var results: [LMSSearchResult] = []
    @Published private(set) var history: [LMSHistoryItem] = []
    @Published private(set) var state: ViewState = .history
    /// When the registry runs in curated / provider mode the app shows a fixed
    /// list of the provider's own instances instead of a search box.
    @Published private(set) var isCurated: Bool = false

    private let service: LMSDirectoryService
    private let historyStore: LMSHistoryStoreProtocol
    private let coordinator: LMSSelectionCoordinating
    private let overridesStore: LMSOverridesStoreProtocol
    private let analytics: LMSDirectoryAnalytics
    private let connectivity: ConnectivityProtocol
    /// Client-side DIRECTORY_MODE override from the app's LMS_DIRECTORY config.
    /// A non-empty value ("search" | "curated") forces the mode regardless of the
    /// registry's `/api/v1/config` response; empty means defer to the registry.
    private let directoryModeOverride: String
    private let historyLimit = 10

    private var debounceTask: Task<Void, Never>?
    private var historyTask: Task<Void, Never>?
    private var cancellables: Set<AnyCancellable> = []

    init(
        service: LMSDirectoryService,
        historyStore: LMSHistoryStoreProtocol,
        coordinator: LMSSelectionCoordinating,
        overridesStore: LMSOverridesStoreProtocol,
        analytics: LMSDirectoryAnalytics,
        connectivity: ConnectivityProtocol,
        directoryModeOverride: String = ""
    ) {
        self.service = service
        self.historyStore = historyStore
        self.coordinator = coordinator
        self.overridesStore = overridesStore
        self.analytics = analytics
        self.connectivity = connectivity
        self.directoryModeOverride = directoryModeOverride
        observeConnectivity()
        loadHistory()
        applyPersistedTheme()
        loadConfig()
    }

    deinit {
        debounceTask?.cancel()
        historyTask?.cancel()
    }

    func clearHistory() {
        do {
            try historyStore.clearHistory()
            history = []
            state = searchText.isEmpty ? .idle : state
            analytics.historyCleared()
        } catch {
            state = .error("Unable to clear history.")
        }
    }

    func selectHistoryItem(_ item: LMSHistoryItem) {
        // Always fetch fresh config from server; fall back to cache if offline
        Task {
            await fetchAndApplyDetails(
                id: item.id,
                fromHistory: true,
                fallback: item.decodedDetail()
            )
        }
    }

    func selectResult(_ result: LMSSearchResult) {
        Task { await fetchAndApplyDetails(id: result.id, fromHistory: false) }
    }

    // MARK: - Private

    private func loadConfig() {
        Task { [weak self] in
            guard let self else { return }
            let config = (try? await service.fetchConfig()) ?? .searchDefault
            // A non-empty client DIRECTORY_MODE override wins over the registry's mode.
            let curated: Bool
            switch self.directoryModeOverride.lowercased() {
            case "curated":
                curated = true
            case "search":
                curated = false
            default:
                curated = config.isCurated
            }
            await MainActor.run { self.isCurated = curated }
            // Share the mode so other tabs (e.g. Profile's "Report this LMS") can behave
            // correctly: a curated/institution registry has no trust-&-safety reporting.
            UserDefaults.standard.set(curated, forKey: "lmsDirectory.isCurated")
            if curated {
                await self.loadFeatured()
            }
        }
    }

    private func loadFeatured() async {
        await MainActor.run { self.state = .searching }
        do {
            let items = try await service.fetchFeatured()
            await MainActor.run {
                self.results = items
                self.state = items.isEmpty ? .empty : .results
            }
            // Warm the artwork now. A document-backed directory already knows every
            // platform's sign-in background, so fetching them while the learner is
            // still choosing means the branded screen is ready the moment they do.
            await prefetchArtwork(for: items)
        } catch {
            await MainActor.run {
                self.state = .error("We couldn't load the list of platforms.")
            }
        }
    }

    /// Pull the images the next screens will need into the shared image cache.
    ///
    /// Only a document-backed directory can do this — a live catalog does not know
    /// a platform's sign-in background until that platform is asked about, which is
    /// exactly one round trip too late.
    private func prefetchArtwork(for items: [LMSSearchResult]) async {
        var sources = items.compactMap { LMSImageSource(url: $0.logoURL) }
        if let documentService = service as? StaticLMSDirectoryService,
           let all = try? await documentService.imageSources() {
            sources = all
        }
        LMSThemeApplier.prefetch(sources)
    }

    private func loadHistory() {
        historyTask?.cancel()
        historyTask = Task { [weak self] in
            guard let self else { return }
            let entries = historyStore.fetchHistory(limit: historyLimit)
            await MainActor.run {
                self.history = entries
                self.state = self.searchText.isEmpty ? (entries.isEmpty ? .idle : .history) : self.state
            }
        }
    }

    private func observeConnectivity() {
        connectivity.internetReachableSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let state, let self else { return }
                if case .notReachable = state, !self.searchText.isEmpty {
                    self.state = .offline
                }
            }
            .store(in: &cancellables)
    }

    private func scheduleSearch() {
        debounceTask?.cancel()
        guard !searchText.isEmpty else {
            state = history.isEmpty ? .idle : .history
            results = []
            return
        }
        state = .searching
        analytics.searchStarted(query: searchText)
        let query = searchText
        debounceTask = Task { [weak self] in
            do {
                try await Task.sleep(nanoseconds: 500_000_000)
                await self?.performSearch(query: query)
            } catch {
                // Task cancelled
            }
        }
    }

    private func performSearch(query: String) async {
        do {
            let results = try await service.search(query: query)
            await MainActor.run {
                self.results = results
                if results.isEmpty {
                    self.state = .empty
                } else {
                    self.state = .results
                    self.analytics.searchResultsShown(count: results.count)
                }
            }
        } catch LMSDirectoryError.offline {
            await MainActor.run {
                self.state = .offline
            }
        } catch {
            await MainActor.run {
                self.state = .error("We couldn't load the list of platforms.")
            }
        }
    }

    private func fetchAndApplyDetails(id: String, fromHistory: Bool, fallback: LMSDetail? = nil) async {
        do {
            let detail = try await service.fetchDetails(id: id)
            await apply(detail: detail, fromHistory: fromHistory)
        } catch LMSDirectoryError.offline {
            // Offline — use cached data if available
            if let fallback {
                await apply(detail: fallback, fromHistory: fromHistory)
            } else {
                state = .offline
            }
        } catch {
            // Network error — try fallback from cache
            if let fallback {
                await apply(detail: fallback, fromHistory: fromHistory)
            } else {
                state = .error("Failed to load LMS settings.")
            }
        }
    }

    private func apply(detail: LMSDetail, fromHistory: Bool) async {
        guard let payload = try? JSONEncoder().encode(detail.asDTO()) else {
            state = .error("This LMS returned invalid data.")
            return
        }
        await coordinator.applySelection(
            detail: detail,
            payload: payload,
            fromHistory: fromHistory
        )
        loadHistory()
    }

    private func applyPersistedTheme() {
        if let selection = overridesStore.currentSelection() {
            LMSThemeApplier.applyAccentColor(selection.accentColor, darkColor: selection.accentColorDark)
            LMSThemeApplier.applyLoginBackground(LMSImageSource(url: selection.theme?.loginBackgroundURL))
        }
    }

    /// Resolve a scanned LMS URL against the registry and select it straight away —
    /// re-theming and routing to sign-in or pre-login Discovery per the platform's
    /// settings (same path as tapping a catalog result). Returns an error message to
    /// surface to the user, or nil on success (success navigates away via the coordinator).
    func selectScannedURL(_ value: String) async -> String? {
        guard let host = normalizeScannedValue(value) else {
            return "We couldn't read the QR code. Try again."
        }
        do {
            let results = try await service.search(query: host)
            // Prefer an exact host match; fall back to the first result the registry returns.
            let match = results.first {
                $0.baseURL.host?.caseInsensitiveCompare(host) == .orderedSame
            } ?? results.first
            guard let match else {
                return "That platform isn't in the directory yet."
            }
            await fetchAndApplyDetails(id: match.id, fromHistory: false)
            return nil
        } catch LMSDirectoryError.offline {
            return "You appear to be offline. Check your connection and try again."
        } catch {
            return "We couldn't reach the directory. Try again."
        }
    }

    private func normalizeScannedValue(_ value: String) -> String? {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }

        if let url = URL(string: trimmed), let host = url.host {
            return host
        }

        if let url = URL(string: "https://\(trimmed)"), let host = url.host {
            return host
        }

        return nil
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

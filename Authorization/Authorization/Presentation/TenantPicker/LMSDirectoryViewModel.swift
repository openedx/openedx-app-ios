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
        connectivity: ConnectivityProtocol
    ) {
        self.service = service
        self.historyStore = historyStore
        self.coordinator = coordinator
        self.overridesStore = overridesStore
        self.analytics = analytics
        self.connectivity = connectivity
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
            await MainActor.run { self.isCurated = config.isCurated }
            if config.isCurated {
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
        } catch {
            await MainActor.run {
                self.state = .error("We couldn't load the list of platforms.")
            }
        }
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
        }
    }

    func handleScannedURL(_ value: String) -> Bool {
        guard let normalized = normalizeScannedValue(value) else {
            state = .error("Unable to read QR code. Try again.")
            return false
        }
        searchText = normalized
        return true
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

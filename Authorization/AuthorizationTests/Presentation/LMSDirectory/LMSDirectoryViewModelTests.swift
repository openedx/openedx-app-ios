//
//  LMSDirectoryViewModelTests.swift
//  AuthorizationTests
//
//  Regression coverage for the LMS Directory connectivity behavior. The view model
//  takes a ConnectivityProtocol and mirrors the source: a registry `.offline` failure
//  on the search path surfaces as `.offline`, while the curated/featured path maps a
//  load failure to a generic `.error` (the reactive connectivity observer only forces
//  `.offline` while the user is actively searching, i.e. searchText is non-empty).
//

import XCTest
import Foundation
import Combine
@testable import Core
@testable import Authorization

@MainActor
final class LMSDirectoryViewModelTests: XCTestCase {

    func test_search_success_setsResultsState() async {
        let service = StubDirectoryService()
        service.searchResult = .success([Self.sampleResult])
        let viewModel = makeViewModel(service: service)

        viewModel.searchText = "aten"

        await waitUntil { viewModel.state == .results }
        XCTAssertEqual(viewModel.results.count, 1)
        XCTAssertEqual(viewModel.results.first?.id, "5")
    }

    func test_search_offlineFailure_setsOfflineState() async {
        let service = StubDirectoryService()
        service.searchResult = .failure(LMSDirectoryError.offline)
        let viewModel = makeViewModel(service: service)

        viewModel.searchText = "aten"

        await waitUntil { viewModel.state == .offline }
        XCTAssertEqual(viewModel.state, .offline)
    }

    // Covers the curated/provider path: featured loading maps a load failure to a
    // generic `.error` (matching the source — the connectivity observer only forces
    // `.offline` while the user is actively searching, i.e. searchText is non-empty).
    func test_curatedFeatured_offlineFailure_setsErrorState() async {
        let service = StubDirectoryService()
        service.config = LMSRegistryConfig(
            directoryMode: "curated",
            providerName: "Provider",
            providerTagline: ""
        )
        service.featuredResult = .failure(LMSDirectoryError.offline)

        let viewModel = makeViewModel(service: service)

        await waitUntil {
            if case .error = viewModel.state { return true }
            return false
        }
        if case .error = viewModel.state {
            // expected
        } else {
            XCTFail("Expected .error for a curated/featured offline failure, got \(viewModel.state)")
        }
    }

    // A scanned QR resolves to a registry platform: the host is looked up, its details
    // fetched, and the selection applied through the coordinator (which routes to sign-in
    // or pre-login Discovery). This is the QR path replacing the old "prefill search" one.
    func test_selectScannedURL_resolvesFromRegistryAndApplies() async {
        let service = StubDirectoryService()
        service.searchResult = .success([Self.sampleResult])
        service.detailsResult = .success(Self.sampleDetail(preLoginDiscovery: true))
        let coordinator = StubCoordinator()
        let viewModel = makeViewModel(service: service, coordinator: coordinator)

        let error = await viewModel.selectScannedURL("https://educar.atentamente.mx")

        XCTAssertNil(error)
        XCTAssertEqual(coordinator.appliedDetail?.id, "5")
        XCTAssertEqual(coordinator.appliedDetail?.featureFlags.preLoginDiscovery, true)
    }

    // A scanned host that isn't registered surfaces an error and applies nothing.
    func test_selectScannedURL_unknownHost_returnsErrorAndDoesNotApply() async {
        let service = StubDirectoryService()
        service.searchResult = .success([])
        let coordinator = StubCoordinator()
        let viewModel = makeViewModel(service: service, coordinator: coordinator)

        let error = await viewModel.selectScannedURL("https://unknown.example.com")

        XCTAssertNotNil(error)
        XCTAssertNil(coordinator.appliedDetail)
    }

    // An unreadable code (no host) surfaces an error without touching the network.
    func test_selectScannedURL_unreadableCode_returnsError() async {
        let coordinator = StubCoordinator()
        let viewModel = makeViewModel(service: StubDirectoryService(), coordinator: coordinator)

        let error = await viewModel.selectScannedURL("   ")

        XCTAssertNotNil(error)
        XCTAssertNil(coordinator.appliedDetail)
    }

    // MARK: - Helpers

    private func makeViewModel(
        service: LMSDirectoryService,
        coordinator: LMSSelectionCoordinating? = nil
    ) -> LMSDirectoryViewModel {
        LMSDirectoryViewModel(
            service: service,
            historyStore: StubHistoryStore(),
            coordinator: coordinator ?? StubCoordinator(),
            overridesStore: StubOverridesStore(),
            analytics: LMSDirectoryAnalyticsNoop(),
            connectivity: StubConnectivity()
        )
    }

    private func waitUntil(
        timeout: TimeInterval = 3,
        _ condition: @MainActor () -> Bool
    ) async {
        let deadline = Date().addingTimeInterval(timeout)
        while !condition() && Date() < deadline {
            try? await Task.sleep(nanoseconds: 50_000_000)
        }
    }

    private static var sampleResult: LMSSearchResult {
        LMSSearchResult(
            id: "5",
            title: "Atentamente",
            shortDescription: "Atentamente MX",
            baseURL: URL(string: "https://educar.atentamente.mx")!,
            logoURL: nil,
            accentColorHex: "#f15d49"
        )
    }

    private static func sampleDetail(preLoginDiscovery: Bool) -> LMSDetail {
        LMSDetail(
            id: "5",
            title: "Atentamente",
            description: "",
            api: LMSDetail.API(
                hostURL: URL(string: "https://educar.atentamente.mx")!,
                feedbackEmail: "support@atentamente.mx",
                oauthClientId: "client-id"
            ),
            featureFlags: LMSDetail.FeatureFlags(preLoginDiscovery: preLoginDiscovery, unknownUnitsMode: nil),
            theme: nil,
            uiComponents: nil,
            dashboard: nil,
            accentColorHex: "#f15d49",
            shortDescription: "Atentamente MX",
            baseURL: URL(string: "https://educar.atentamente.mx")!,
            logoURL: nil
        )
    }
}

// MARK: - Test doubles

private final class StubDirectoryService: LMSDirectoryService, @unchecked Sendable {
    var searchResult: Result<[LMSSearchResult], Error> = .success([])
    var featuredResult: Result<[LMSSearchResult], Error> = .success([])
    var detailsResult: Result<LMSDetail, Error> = .failure(LMSDirectoryError.notFound)
    var config: LMSRegistryConfig = .searchDefault

    func search(query: String) async throws -> [LMSSearchResult] { try searchResult.get() }
    func fetchDetails(id: String) async throws -> LMSDetail { try detailsResult.get() }
    func fetchConfig() async throws -> LMSRegistryConfig { config }
    func fetchFeatured() async throws -> [LMSSearchResult] { try featuredResult.get() }
}

private final class StubHistoryStore: LMSHistoryStoreProtocol, @unchecked Sendable {
    func fetchHistory(limit: Int) -> [LMSHistoryItem] { [] }
    func save(detail: LMSDetail, payload: Data, pinned: Bool) throws {}
    func clearHistory() throws {}
    func deleteAllOverrides() throws {}
    func unpinAll() throws {}
    func pinnedItem() -> LMSHistoryItem? { nil }
}

private final class StubCoordinator: LMSSelectionCoordinating, @unchecked Sendable {
    private(set) var appliedDetail: LMSDetail?
    func applySelection(detail: LMSDetail, payload: Data, fromHistory: Bool) async {
        appliedDetail = detail
    }
}

private final class StubOverridesStore: LMSOverridesStoreProtocol, @unchecked Sendable {
    func save(detail: LMSDetail, payload: Data, storage: CoreStorage?) throws {}
    func currentSelection() -> LMSDetail? { nil }
    func clear(storage: CoreStorage?) throws {}
}

private final class StubConnectivity: ConnectivityProtocol, @unchecked Sendable {
    var isInternetAvaliable: Bool = true
    var isMobileData: Bool = false
    let internetReachableSubject = CurrentValueSubject<InternetState?, Never>(.reachable)
    var internetState: InternetState? { internetReachableSubject.value }
}

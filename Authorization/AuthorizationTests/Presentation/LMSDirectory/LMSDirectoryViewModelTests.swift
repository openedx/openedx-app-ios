//
//  LMSDirectoryViewModelTests.swift
//  AuthorizationTests
//
//  Regression coverage for the LMS Directory connectivity fix. The view model no
//  longer takes a ConnectivityProtocol (this file wouldn't compile if it did), and
//  a real registry `.offline` failure surfaces as `.offline` for both search and
//  curated/featured loading — not a generic error.
//

import XCTest
import Foundation
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

    // Covers the curated/provider path: featured loading must map .offline to
    // .offline too, not to a generic .error.
    func test_curatedFeatured_offlineFailure_setsOfflineState() async {
        let service = StubDirectoryService()
        service.config = LMSRegistryConfig(
            directoryMode: "curated",
            providerName: "Provider",
            providerTagline: ""
        )
        service.featuredResult = .failure(LMSDirectoryError.offline)

        let viewModel = makeViewModel(service: service)

        await waitUntil { viewModel.state == .offline }
        XCTAssertEqual(viewModel.state, .offline)
    }

    // MARK: - Helpers

    private func makeViewModel(service: LMSDirectoryService) -> LMSDirectoryViewModel {
        LMSDirectoryViewModel(
            service: service,
            historyStore: StubHistoryStore(),
            coordinator: StubCoordinator(),
            overridesStore: StubOverridesStore(),
            analytics: LMSDirectoryAnalyticsNoop()
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
}

// MARK: - Test doubles

private final class StubDirectoryService: LMSDirectoryService, @unchecked Sendable {
    var searchResult: Result<[LMSSearchResult], Error> = .success([])
    var featuredResult: Result<[LMSSearchResult], Error> = .success([])
    var config: LMSRegistryConfig = .searchDefault

    func search(query: String) async throws -> [LMSSearchResult] { try searchResult.get() }
    func fetchDetails(id: String) async throws -> LMSDetail { throw LMSDirectoryError.notFound }
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
    func applySelection(detail: LMSDetail, payload: Data, fromHistory: Bool) async {}
}

private final class StubOverridesStore: LMSOverridesStoreProtocol, @unchecked Sendable {
    func save(detail: LMSDetail, payload: Data, storage: CoreStorage?) throws {}
    func currentSelection() -> LMSDetail? { nil }
    func clear(storage: CoreStorage?) throws {}
}

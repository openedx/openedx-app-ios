//
//  LMSDirectoryViewModelTests.swift
//  Authorization
//
//  Created by Ivan Stepanok on 20.08.2026.
//

import XCTest
import Foundation
@testable import Core
@testable import Authorization

/// AuthorizationTests
/// The platform picker reads a fixed list and hands one platform to the
/// coordinator. These cover what the learner sees while that happens: the list,
/// an empty directory, a document that could not be read, and the selection
/// actually reaching the coordinator that re-themes the app.
@MainActor
final class LMSDirectoryViewModelTests: XCTestCase {

    private func makeViewModel(_ service: StubDirectoryService) -> (LMSDirectoryViewModel, StubCoordinator) {
        let coordinator = StubCoordinator()
        let viewModel = LMSDirectoryViewModel(
            service: service,
            coordinator: coordinator,
            overridesStore: StubOverridesStore(),
            analytics: LMSDirectoryAnalyticsNoop()
        )
        return (viewModel, coordinator)
    }

    private func settle() async {
        try? await Task.sleep(nanoseconds: 200_000_000)
    }

    func testTheDirectoryIsListedAsTheDocumentOrdersIt() async {
        let service = StubDirectoryService()
        service.platformsResult = .success([Self.sampleResult])
        let (viewModel, _) = makeViewModel(service)

        await settle()

        XCTAssertEqual(viewModel.state, .ready)
        XCTAssertEqual(viewModel.platforms.map(\.id), [Self.sampleResult.id])
    }

    func testADocumentWithNoPlatformsSaysSoRatherThanLookingBroken() async {
        let service = StubDirectoryService()
        service.platformsResult = .success([])
        let (viewModel, _) = makeViewModel(service)

        await settle()

        XCTAssertEqual(viewModel.state, .empty)
    }

    func testADocumentThatCannotBeReadSurfacesAsAFailure() async {
        let service = StubDirectoryService()
        service.platformsResult = .failure(LMSDirectoryError.decodingFailed)
        let (viewModel, _) = makeViewModel(service)

        await settle()

        guard case .failed = viewModel.state else {
            return XCTFail("expected a failure state, got \(viewModel.state)")
        }
        XCTAssertTrue(viewModel.platforms.isEmpty)
    }

    func testChoosingAPlatformHandsItToTheCoordinator() async {
        let service = StubDirectoryService()
        service.platformsResult = .success([Self.sampleResult])
        service.detailsResult = .success(Self.sampleDetail(preLoginDiscovery: false))
        let (viewModel, coordinator) = makeViewModel(service)
        await settle()

        viewModel.select(Self.sampleResult)
        await settle()

        XCTAssertEqual(coordinator.appliedDetail?.id, Self.sampleResult.id)
    }

    func testAPlatformThatCannotBeReadLeavesTheListUsable() async {
        let service = StubDirectoryService()
        service.platformsResult = .success([Self.sampleResult])
        service.detailsResult = .failure(LMSDirectoryError.notFound)
        let (viewModel, coordinator) = makeViewModel(service)
        await settle()

        viewModel.select(Self.sampleResult)
        await settle()

        XCTAssertNil(coordinator.appliedDetail)
        guard case .failed = viewModel.state else {
            return XCTFail("expected a failure state, got \(viewModel.state)")
        }
    }

    private static var sampleResult: LMSSummary {
        LMSSummary(
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
    var platformsResult: Result<[LMSSummary], Error> = .success([])
    var detailsResult: Result<LMSDetail, Error> = .failure(LMSDirectoryError.notFound)

    func platforms() async throws -> [LMSSummary] { try platformsResult.get() }
    func details(id: String) async throws -> LMSDetail { try detailsResult.get() }
}

private final class StubCoordinator: LMSSelectionCoordinating, @unchecked Sendable {
    private(set) var appliedDetail: LMSDetail?
    func applySelection(detail: LMSDetail, payload: Data) async {
        appliedDetail = detail
    }
}

private final class StubOverridesStore: LMSOverridesStoreProtocol, @unchecked Sendable {
    func save(detail: LMSDetail, payload: Data, storage: CoreStorage?) throws {}
    func currentSelection() -> LMSDetail? { nil }
    func clear(storage: CoreStorage?) throws {}
}

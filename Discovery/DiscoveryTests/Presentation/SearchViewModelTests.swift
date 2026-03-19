//
//  SearchViewModelTests.swift
//  DiscoveryUnitTests
//
//  Created by Paul Maul on 14.02.2023.
//

import XCTest
@testable import Core
@testable import Discovery
import Alamofire
import SwiftUI

@MainActor
final class SearchViewModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSearchSuccess() async throws {
        let interactor = DiscoveryInteractorProtocolMock()
        let connectivity = Connectivity(config: ConfigMock())
        let analytics = DiscoveryAnalyticsMock()
        let router = DiscoveryRouterMock()
        let viewModel = SearchViewModel(
            interactor: interactor,
            connectivity: connectivity,
            router: router,
            analytics: analytics,
            storage: CoreStorageMock(),
            debounce: .test
        )

        let items = [
            CourseItem(name: "Test",
                       org: "org",
                       shortDescription: "",
                       imageURL: "",
                       hasAccess: true,
                       courseStart: Date(),
                       courseEnd: nil,
                       enrollmentStart: Date(),
                       enrollmentEnd: Date(),
                       courseID: "123",
                       numPages: 2,
                       coursesCount: 0,
                       courseRawImage: nil,
                       progressEarned: 0,
                       progressPossible: 0),
            CourseItem(name: "Test2",
                       org: "org2",
                       shortDescription: "",
                       imageURL: "",
                       hasAccess: true,
                       courseStart: Date(),
                       courseEnd: nil,
                       enrollmentStart: Date(),
                       enrollmentEnd: Date(),
                       courseID: "1243",
                       numPages: 1,
                       coursesCount: 0,
                       courseRawImage: nil,
                       progressEarned: 0,
                       progressPossible: 0)
        ]

        interactor.searchHandler = { _, _ in items }

        viewModel.searchText = "Test"

        // Wait for search to complete
        try await Task.sleep(for: .milliseconds(10))

        XCTAssertTrue(interactor.searchCallCount > 0)
        XCTAssertTrue(analytics.discoveryCoursesSearchCallCount > 0)

        XCTAssertFalse(viewModel.showError)
        XCTAssertFalse(viewModel.fetchInProgress)
    }

    func testSearchEmptyQuerySuccess() async throws {
        let interactor = DiscoveryInteractorProtocolMock()
        let connectivity = Connectivity(config: ConfigMock())
        let analytics = DiscoveryAnalyticsMock()
        let router = DiscoveryRouterMock()
        let viewModel = SearchViewModel(
            interactor: interactor,
            connectivity: connectivity,
            router: router,
            analytics: analytics,
            storage: CoreStorageMock(),
            debounce: .test
        )

        viewModel.searchText = ""

        await Task.yield()

        XCTAssertEqual(interactor.searchCallCount, 0)

        XCTAssertFalse(viewModel.showError)
        XCTAssertFalse(viewModel.fetchInProgress)
    }

    func testSearchNoInternetError() async throws {
        let interactor = DiscoveryInteractorProtocolMock()
        let connectivity = Connectivity(config: ConfigMock())
        let analytics = DiscoveryAnalyticsMock()
        let router = DiscoveryRouterMock()
        let viewModel = SearchViewModel(
            interactor: interactor,
            connectivity: connectivity,
            router: router,
            analytics: analytics,
            storage: CoreStorageMock(),
            debounce: .test
        )

        let noInternetError = AFError.sessionInvalidated(error: URLError(.notConnectedToInternet))

        interactor.searchHandler = { _, _ in throw noInternetError }

        viewModel.searchText = "Test"

        // Wait for search to complete
        try await Task.sleep(for: .milliseconds(10))

        XCTAssertEqual(interactor.searchCallCount, 1)

        XCTAssertTrue(viewModel.showError)
        XCTAssertFalse(viewModel.fetchInProgress)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.slowOrNoInternetConnection)
    }

    func testSearchUnknownError() async throws {
        let interactor = DiscoveryInteractorProtocolMock()
        let connectivity = Connectivity(config: ConfigMock())
        let analytics = DiscoveryAnalyticsMock()
        let router = DiscoveryRouterMock()
        let viewModel = SearchViewModel(
            interactor: interactor,
            connectivity: connectivity,
            router: router,
            analytics: analytics,
            storage: CoreStorageMock(),
            debounce: .test
        )

        let unknownError = AFError.sessionInvalidated(error: NSError())

        interactor.searchHandler = { _, _ in throw unknownError }

        viewModel.searchText = "Test"

        // Wait for search to complete
        try await Task.sleep(for: .milliseconds(10))

        XCTAssertEqual(interactor.searchCallCount, 1)

        XCTAssertTrue(viewModel.showError)
        XCTAssertFalse(viewModel.fetchInProgress)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.unknownError)
    }

}

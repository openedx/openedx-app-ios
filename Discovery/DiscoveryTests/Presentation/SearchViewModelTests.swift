//
//  SearchViewModelTests.swift
//  DiscoveryUnitTests
//
//  Created by Paul Maul on 14.02.2023.
//

import SwiftyMocky
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
        let connectivity = Connectivity()
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

        Given(interactor, .search(page: 1, searchTerm: .any, willReturn: items))

        viewModel.searchText = "Test"
        
        // Wait for debounce + next event loop iteration
        try await Task.sleep(nanoseconds: UInt64(0.5 * Double(NSEC_PER_SEC)))
        await Task.yield()
        
        Verify(interactor, .search(page: 1, searchTerm: .any))
        Verify(analytics, .discoveryCoursesSearch(label: .any, coursesCount: .any))

        XCTAssertFalse(viewModel.showError)
        XCTAssertFalse(viewModel.fetchInProgress)
    }
    
    func testSearchEmptyQuerySuccess() async throws {
        let interactor = DiscoveryInteractorProtocolMock()
        let connectivity = Connectivity()
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
        
        Verify(interactor, 0, .search(page: 1, searchTerm: .any))

        XCTAssertFalse(viewModel.showError)
        XCTAssertFalse(viewModel.fetchInProgress)
    }
    
    func testSearchNoInternetError() async throws {
        let interactor = DiscoveryInteractorProtocolMock()
        let connectivity = Connectivity()
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

        Given(interactor, .search(page: .any, searchTerm: .any, willThrow: noInternetError))
        
        viewModel.searchText = "Test"

        // Wait for debounce + next event loop iteration
        try await Task.sleep(nanoseconds: UInt64(0.5 * Double(NSEC_PER_SEC)))
        await Task.yield()
        
        
        Verify(interactor, 1, .search(page: 1, searchTerm: .any))

        XCTAssertTrue(viewModel.showError)
        XCTAssertFalse(viewModel.fetchInProgress)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.slowOrNoInternetConnection)
    }

    func testSearchUnknownError() async throws {
        let interactor = DiscoveryInteractorProtocolMock()
        let connectivity = Connectivity()
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
        
        Given(interactor, .search(page: .any, searchTerm: .any, willThrow: unknownError))

        viewModel.searchText = "Test"
        
        // Wait for debounce + next event loop iteration
        try await Task.sleep(nanoseconds: UInt64(0.5 * Double(NSEC_PER_SEC)))
        await Task.yield()

        Verify(interactor, 1, .search(page: 1, searchTerm: .any))

        XCTAssertTrue(viewModel.showError)
        XCTAssertFalse(viewModel.fetchInProgress)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.unknownError)
    }

}

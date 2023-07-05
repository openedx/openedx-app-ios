//
//  DiscoveryUnitTests.swift
//  DiscoveryUnitTests
//
//  Created by  Stepanok Ivan on 17.01.2023.
//

import SwiftyMocky
import XCTest
@testable import Core
@testable import Discovery
import Alamofire
import SwiftUI

final class DiscoveryViewModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGetDiscoveryCourses() async throws {
        let interactor = DiscoveryInteractorProtocolMock()
        let connectivity = Connectivity()
        let analytics = DiscoveryAnalyticsMock()
        let viewModel = DiscoveryViewModel(interactor: interactor, connectivity: connectivity, analytics: analytics)

        let items = [
            CourseItem(name: "Test",
                       org: "org",
                       shortDescription: "",
                       imageURL: "",
                       isActive: true,
                       courseStart: Date(),
                       courseEnd: nil,
                       enrollmentStart: Date(),
                       enrollmentEnd: Date(),
                       courseID: "123",
                       numPages: 2,
                       coursesCount: 2),
            CourseItem(name: "Test2",
                       org: "org2",
                       shortDescription: "",
                       imageURL: "",
                       isActive: true,
                       courseStart: Date(),
                       courseEnd: nil,
                       enrollmentStart: Date(),
                       enrollmentEnd: Date(),
                       courseID: "1243",
                       numPages: 1,
                       coursesCount: 2)
        ]
        viewModel.courses = items + items + items
        viewModel.totalPages = 2

        Given(interactor, .discovery(page: 1, willReturn: items))

        await viewModel.getDiscoveryCourses(index: 3)

        Verify(interactor, 1, .discovery(page: 1))

        XCTAssertFalse(viewModel.showError)
        XCTAssertEqual(viewModel.totalPages, 2)
    }
    
    func testDiscoverySuccess() async throws {
        let interactor = DiscoveryInteractorProtocolMock()
        let connectivity = Connectivity()
        let analytics = DiscoveryAnalyticsMock()
        let viewModel = DiscoveryViewModel(interactor: interactor, connectivity: connectivity, analytics: analytics)

        let items = [
            CourseItem(name: "Test",
                       org: "org",
                       shortDescription: "",
                       imageURL: "",
                       isActive: true,
                       courseStart: Date(),
                       courseEnd: nil,
                       enrollmentStart: Date(),
                       enrollmentEnd: Date(),
                       courseID: "123",
                       numPages: 2,
                       coursesCount: 0),
            CourseItem(name: "Test2",
                       org: "org2",
                       shortDescription: "",
                       imageURL: "",
                       isActive: true,
                       courseStart: Date(),
                       courseEnd: nil,
                       enrollmentStart: Date(),
                       enrollmentEnd: Date(),
                       courseID: "1243",
                       numPages: 1,
                       coursesCount: 0)
        ]

        Given(interactor, .discovery(page: 1, willReturn: items))

        await viewModel.discovery(page: 1)

        Verify(interactor, 1, .discovery(page: 1))

        XCTAssertFalse(viewModel.showError)
        XCTAssertFalse(viewModel.fetchInProgress)
        XCTAssertEqual(viewModel.nextPage, 2)
    }
    
    func testDiscoveryOfflineSuccess() async throws {
        let interactor = DiscoveryInteractorProtocolMock()
        let connectivity = ConnectivityProtocolMock()
        let analytics = DiscoveryAnalyticsMock()
        let viewModel = DiscoveryViewModel(interactor: interactor, connectivity: connectivity, analytics: analytics)
        
        let items = [
            CourseItem(name: "Test",
                       org: "org",
                       shortDescription: "",
                       imageURL: "",
                       isActive: true,
                       courseStart: Date(),
                       courseEnd: nil,
                       enrollmentStart: Date(),
                       enrollmentEnd: Date(),
                       courseID: "123",
                       numPages: 2,
                       coursesCount: 2),
            CourseItem(name: "Test2",
                       org: "org2",
                       shortDescription: "",
                       imageURL: "",
                       isActive: true,
                       courseStart: Date(),
                       courseEnd: nil,
                       enrollmentStart: Date(),
                       enrollmentEnd: Date(),
                       courseID: "1243",
                       numPages: 1,
                       coursesCount: 2)
        ]
        
        Given(connectivity, .isInternetAvaliable(getter: false))
                        
        Given(interactor, .discoveryOffline(willReturn: items))
        
        await viewModel.discovery(page: 1)
        
        Verify(interactor, 1, .discoveryOffline())
        
        XCTAssertFalse(viewModel.showError)
        XCTAssertFalse(viewModel.fetchInProgress)
        XCTAssertEqual(viewModel.nextPage, 2)
    }
    
    func testDiscoveryNoInternetError() async throws {
        let interactor = DiscoveryInteractorProtocolMock()
        let connectivity = Connectivity()
        let analytics = DiscoveryAnalyticsMock()
        let viewModel = DiscoveryViewModel(interactor: interactor, connectivity: connectivity, analytics: analytics)
        
        let noInternetError = AFError.sessionInvalidated(error: URLError(.notConnectedToInternet))
                        
        Given(interactor, .discovery(page: 1, willThrow: noInternetError))
        
        await viewModel.discovery(page: 1)
        
        Verify(interactor, 1, .discovery(page: 1))
        
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.slowOrNoInternetConnection)
        XCTAssertTrue(viewModel.showError)
        XCTAssertFalse(viewModel.fetchInProgress)
    }
    
    func testDiscoveryUnknownError() async throws {
        let interactor = DiscoveryInteractorProtocolMock()
        let connectivity = Connectivity()
        let analytics = DiscoveryAnalyticsMock()
        let viewModel = DiscoveryViewModel(interactor: interactor, connectivity: connectivity, analytics: analytics)
        
        let noInternetError = AFError.sessionInvalidated(error: NSError())
                        
        Given(interactor, .discovery(page: 1, willThrow: noInternetError))
        
        await viewModel.discovery(page: 1)
        
        Verify(interactor, 1, .discovery(page: 1))
        
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.unknownError)
        XCTAssertTrue(viewModel.showError)
        XCTAssertFalse(viewModel.fetchInProgress)
    }
    
}

//
//  DashboardViewModelTests.swift
//  DashboardTests
//
//  Created by  Stepanok Ivan on 18.01.2023.
//

import SwiftyMocky
import XCTest
@testable import Core
@testable import Dashboard
import Alamofire
import SwiftUI

final class DashboardViewModelTests: XCTestCase {
    
    func testGetMyCoursesSuccess() async throws {
        let interactor = DashboardInteractorProtocolMock()
        let connectivity = ConnectivityProtocolMock()
        let viewModel = DashboardViewModel(interactor: interactor, connectivity: connectivity)
        
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
                       certificate: nil,
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
                       certificate: nil,
                       numPages: 1,
                       coursesCount: 2)
        ]

        Given(connectivity, .isInternetAvaliable(getter: true))
        Given(interactor, .getMyCourses(willReturn: items))

        await viewModel.getMyCourses()

        Verify(interactor, 1, .getMyCourses())

        XCTAssertTrue(viewModel.courses == items)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertFalse(viewModel.showError)
    }
    
    func testGetMyCoursesOfflineSuccess() async throws {
        let interactor = DashboardInteractorProtocolMock()
        let connectivity = ConnectivityProtocolMock()
        let viewModel = DashboardViewModel(interactor: interactor, connectivity: connectivity)
        
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
                       certificate: nil,
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
                       certificate: nil,
                       numPages: 1,
                       coursesCount: 2)
        ]
        
        Given(connectivity, .isInternetAvaliable(getter: false))
        Given(interactor, .discoveryOffline(willReturn: items))
        
        await viewModel.getMyCourses()
        
        Verify(interactor, 1, .discoveryOffline())
        
        XCTAssertTrue(viewModel.courses == items)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertFalse(viewModel.showError)
    }
    
    func testGetMyCoursesNoCacheError() async throws {
        let interactor = DashboardInteractorProtocolMock()
        let connectivity = ConnectivityProtocolMock()
        let viewModel = DashboardViewModel(interactor: interactor, connectivity: connectivity)
        
        Given(connectivity, .isInternetAvaliable(getter: true))
        Given(interactor, .getMyCourses(willThrow: NoCachedDataError()) )
        
        await viewModel.getMyCourses()
        
        Verify(interactor, 1, .getMyCourses())
        
        XCTAssertTrue(viewModel.courses.isEmpty)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.noCachedData)
        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertTrue(viewModel.showError)
    }
    
    func testGetMyCoursesUnknownError() async throws {
        let interactor = DashboardInteractorProtocolMock()
        let connectivity = ConnectivityProtocolMock()
        let viewModel = DashboardViewModel(interactor: interactor, connectivity: connectivity)
        
        Given(connectivity, .isInternetAvaliable(getter: true))
        Given(interactor, .getMyCourses(willThrow: NSError()) )
        
        await viewModel.getMyCourses()
        
        Verify(interactor, 1, .getMyCourses())
        
        XCTAssertTrue(viewModel.courses.isEmpty)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.unknownError)
        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertTrue(viewModel.showError)
    }
}

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
        let analytics = DashboardAnalyticsMock()
        let viewModel = DashboardViewModel(interactor: interactor, connectivity: connectivity, analytics: analytics)
        
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
                       coursesCount: 2,
                        isSelfPaced: false),
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
                       coursesCount: 2,
                       isSelfPaced: false)
        ]

        Given(connectivity, .isInternetAvaliable(getter: true))
        Given(interactor, .getMyCourses(page: .any, willReturn: items))

        await viewModel.getMyCourses(page: 1)

        Verify(interactor, 1, .getMyCourses(page: .value(1)))

        XCTAssertTrue(viewModel.courses == items)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.showError)
    }
    
    func testGetMyCoursesOfflineSuccess() async throws {
        let interactor = DashboardInteractorProtocolMock()
        let connectivity = ConnectivityProtocolMock()
        let analytics = DashboardAnalyticsMock()
        let viewModel = DashboardViewModel(interactor: interactor, connectivity: connectivity, analytics: analytics)
        
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
                       coursesCount: 2,
                       isSelfPaced: false),
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
                       coursesCount: 2,
                       isSelfPaced: false)
        ]
        
        Given(connectivity, .isInternetAvaliable(getter: false))
        Given(interactor, .discoveryOffline(willReturn: items))
        
        await viewModel.getMyCourses(page: 1)
        
        Verify(interactor, 1, .discoveryOffline())
        
        XCTAssertTrue(viewModel.courses == items)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.showError)
    }
    
    func testGetMyCoursesNoCacheError() async throws {
        let interactor = DashboardInteractorProtocolMock()
        let connectivity = ConnectivityProtocolMock()
        let analytics = DashboardAnalyticsMock()
        let viewModel = DashboardViewModel(interactor: interactor, connectivity: connectivity, analytics: analytics)
        
        Given(connectivity, .isInternetAvaliable(getter: true))
        Given(interactor, .getMyCourses(page: .any, willThrow: NoCachedDataError()) )
        
        await viewModel.getMyCourses(page: 1)
        
        Verify(interactor, 1, .getMyCourses(page: .value(1)))
        
        XCTAssertTrue(viewModel.courses.isEmpty)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.noCachedData)
        XCTAssertTrue(viewModel.showError)
    }
    
    func testGetMyCoursesUnknownError() async throws {
        let interactor = DashboardInteractorProtocolMock()
        let connectivity = ConnectivityProtocolMock()
        let analytics = DashboardAnalyticsMock()
        let viewModel = DashboardViewModel(interactor: interactor, connectivity: connectivity, analytics: analytics)
        
        Given(connectivity, .isInternetAvaliable(getter: true))
        Given(interactor, .getMyCourses(page: .any, willThrow: NSError()) )
        
        await viewModel.getMyCourses(page: 1)
        
        Verify(interactor, 1, .getMyCourses(page: .value(1)))
        
        XCTAssertTrue(viewModel.courses.isEmpty)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.unknownError)
        XCTAssertTrue(viewModel.showError)
    }
}

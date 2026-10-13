//
//  ListDashboardViewModelTests.swift
//  DashboardTests
//
//  Created by  Stepanok Ivan on 18.01.2023.
//

import XCTest
@testable import Core
@testable import Dashboard
import Alamofire
import SwiftUI

@MainActor
final class ListDashboardViewModelTests: XCTestCase {

    func testGetMyCoursesSuccess() async throws {
        let interactor = DashboardInteractorProtocolMock()
        let connectivity = ConnectivityProtocolMock()
        connectivity.internetReachableSubject = .init(.reachable)
        let analytics = DashboardAnalyticsMock()
        let viewModel = ListDashboardViewModel(
            interactor: interactor,
            connectivity: connectivity,
            analytics: analytics,
            storage: CoreStorageMock()
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
                       coursesCount: 2,
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
                       coursesCount: 2,
                       courseRawImage: nil,
                       progressEarned: 0,
                       progressPossible: 0)
        ]

        connectivity.isInternetAvaliable = true
        interactor.getEnrollmentsHandler = { _ in items }

        await viewModel.getMyCourses(page: 1)

        XCTAssertEqual(interactor.getEnrollmentsCallCount, 1)
        XCTAssertTrue(viewModel.courses == items)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.showError)
    }

    func testGetMyCoursesOfflineSuccess() async throws {
        let interactor = DashboardInteractorProtocolMock()
        let connectivity = ConnectivityProtocolMock()
        connectivity.internetReachableSubject = .init(.reachable)
        let analytics = DashboardAnalyticsMock()
        let viewModel = ListDashboardViewModel(
            interactor: interactor,
            connectivity: connectivity,
            analytics: analytics,
            storage: CoreStorageMock()
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
                       coursesCount: 2,
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
                       coursesCount: 2,
                       courseRawImage: nil,
                       progressEarned: 0,
                       progressPossible: 0)
        ]

        connectivity.isInternetAvaliable = false
        interactor.getEnrollmentsOfflineHandler = { items }

        await viewModel.getMyCourses(page: 1)

        XCTAssertEqual(interactor.getEnrollmentsOfflineCallCount, 1)
        XCTAssertTrue(viewModel.courses == items)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.showError)
    }

    func testGetMyCoursesNoCacheError() async throws {
        let interactor = DashboardInteractorProtocolMock()
        let connectivity = ConnectivityProtocolMock()
        connectivity.internetReachableSubject = .init(.reachable)
        let analytics = DashboardAnalyticsMock()
        let viewModel = ListDashboardViewModel(
            interactor: interactor,
            connectivity: connectivity,
            analytics: analytics,
            storage: CoreStorageMock()
        )

        connectivity.isInternetAvaliable = true
        interactor.getEnrollmentsHandler = { _ in throw NoCachedDataError() }

        await viewModel.getMyCourses(page: 1)

        XCTAssertEqual(interactor.getEnrollmentsCallCount, 1)
        XCTAssertTrue(viewModel.courses.isEmpty)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.noCachedData)
        XCTAssertTrue(viewModel.showError)
    }

    func testGetMyCoursesUnknownError() async throws {
        let interactor = DashboardInteractorProtocolMock()
        let connectivity = ConnectivityProtocolMock()
        connectivity.internetReachableSubject = .init(.reachable)
        let analytics = DashboardAnalyticsMock()
        let viewModel = ListDashboardViewModel(
            interactor: interactor,
            connectivity: connectivity,
            analytics: analytics,
            storage: CoreStorageMock()
        )

        connectivity.isInternetAvaliable = true
        interactor.getEnrollmentsHandler = { _ in throw NSError(domain: "error", code: -1, userInfo: nil) }
        interactor.getEnrollmentsOfflineHandler = { throw NoCachedDataError() }

        await viewModel.getMyCourses(page: 1)

        XCTAssertEqual(interactor.getEnrollmentsCallCount, 1)
        XCTAssertTrue(viewModel.courses.isEmpty)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.unknownError)
        XCTAssertTrue(viewModel.showError)
    }

    func testGetMyCourses_whenTheRequestFails_showsTheSavedCourses() async {
        let interactor = DashboardInteractorProtocolMock()
        let connectivity = ConnectivityProtocolMock()
        connectivity.internetReachableSubject = .init(.reachable)
        let viewModel = ListDashboardViewModel(
            interactor: interactor,
            connectivity: connectivity,
            analytics: DashboardAnalyticsMock(),
            storage: CoreStorageMock()
        )
        let saved = [
            CourseItem(name: "Saved",
                       org: "org",
                       shortDescription: "",
                       imageURL: "",
                       hasAccess: true,
                       courseStart: Date(),
                       courseEnd: nil,
                       enrollmentStart: Date(),
                       enrollmentEnd: Date(),
                       courseID: "123",
                       numPages: 1,
                       coursesCount: 1,
                       courseRawImage: nil,
                       progressEarned: 0,
                       progressPossible: 0)
        ]
        connectivity.isInternetAvaliable = true
        interactor.getEnrollmentsHandler = { _ in throw URLError(.timedOut) }
        interactor.getEnrollmentsOfflineHandler = { saved }

        await viewModel.getMyCourses(page: 1)

        XCTAssertTrue(viewModel.courses == saved)
        XCTAssertTrue(viewModel.showError)
        XCTAssertFalse(viewModel.fetchInProgress)
    }
}

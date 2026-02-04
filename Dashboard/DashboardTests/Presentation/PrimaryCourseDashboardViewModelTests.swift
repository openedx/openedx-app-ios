//
//  PrimaryCourseDashboardViewModelTests.swift
//  Dashboard
//
//  Created by Ivan Stepanok on 30.10.2024.
//

import XCTest
@testable import Core
@testable import Dashboard
import Combine
import SwiftUI

@MainActor
final class PrimaryCourseDashboardViewModelTests: XCTestCase {

    var interactor: DashboardInteractorProtocolMock!
    var connectivity: ConnectivityProtocolMock!
    var analytics: DashboardAnalyticsMock!
    var storage: CoreStorageMock!
    var config: ConfigMock!
    var router: DashboardRouterMock!

    override func setUp() {
        super.setUp()
        interactor = DashboardInteractorProtocolMock()
        connectivity = ConnectivityProtocolMock()
        analytics = DashboardAnalyticsMock()
        storage = CoreStorageMock()
        config = ConfigMock()
        router = DashboardRouterMock()
    }

    let enrollment = PrimaryEnrollment(
        primaryCourse: PrimaryCourse(
            name: "Primary Course",
            org: "OpenEdX",
            courseID: "1",
            hasAccess: true,
            courseStart: Date(),
            courseEnd: nil,
            courseBanner: "https://example.com/banner.jpg",
            futureAssignments: [],
            pastAssignments: [],
            progressEarned: 0,
            progressPossible: 1,
            lastVisitedBlockID: nil,
            resumeTitle: nil
        ),
        courses: [
            CourseItem(
                name: "Course",
                org: "OpenEdX",
                shortDescription: "short description",
                imageURL: "https://examlpe.com/image.jpg",
                hasAccess: true,
                courseStart: nil,
                courseEnd: nil,
                enrollmentStart: nil,
                enrollmentEnd: nil,
                courseID: "2",
                numPages: 1,
                coursesCount: 3,
                courseRawImage: nil,
                progressEarned: 0,
                progressPossible: 2
            )
        ],
        totalPages: 1,
        count: 1
    )

    func testGetEnrollmentsSuccess() async throws {
        // Given
        let viewModel = PrimaryCourseDashboardViewModel(
            interactor: interactor,
            connectivity: connectivity,
            analytics: analytics,
            config: config,
            storage: storage,
            router: router
        )

        connectivity.isInternetAvaliable = true
        interactor.getPrimaryEnrollmentHandler = { _ in self.enrollment }

        // When
        await viewModel.getEnrollments()

        // Then
        XCTAssertEqual(interactor.getPrimaryEnrollmentCallCount, 1)
        XCTAssertEqual(viewModel.enrollments, enrollment)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.showError)
        XCTAssertFalse(viewModel.fetchInProgress)
    }

    func testGetEnrollmentsOfflineSuccess() async throws {
        // Given
        let viewModel = PrimaryCourseDashboardViewModel(
            interactor: interactor,
            connectivity: connectivity,
            analytics: analytics,
            config: config,
            storage: storage,
            router: router
        )

        connectivity.isInternetAvaliable = false
        interactor.getPrimaryEnrollmentOfflineHandler = { self.enrollment }

        // When
        await viewModel.getEnrollments()

        // Then
        XCTAssertEqual(interactor.getPrimaryEnrollmentOfflineCallCount, 1)
        XCTAssertEqual(viewModel.enrollments, enrollment)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.showError)
        XCTAssertFalse(viewModel.fetchInProgress)
    }

    func testGetEnrollmentsNoCacheError() async throws {
        // Given
        let viewModel = PrimaryCourseDashboardViewModel(
            interactor: interactor,
            connectivity: connectivity,
            analytics: analytics,
            config: config,
            storage: storage,
            router: router
        )

        connectivity.isInternetAvaliable = true
        interactor.getPrimaryEnrollmentHandler = { _ in throw NoCachedDataError() }

        // When
        await viewModel.getEnrollments()

        // Then
        XCTAssertEqual(interactor.getPrimaryEnrollmentCallCount, 1)
        XCTAssertNil(viewModel.enrollments)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.noCachedData)
        XCTAssertTrue(viewModel.showError)
        XCTAssertFalse(viewModel.fetchInProgress)
    }

    func testGetEnrollmentsUnknownError() async throws {
        // Given
        let viewModel = PrimaryCourseDashboardViewModel(
            interactor: interactor,
            connectivity: connectivity,
            analytics: analytics,
            config: config,
            storage: storage,
            router: router
        )

        connectivity.isInternetAvaliable = true
        interactor.getPrimaryEnrollmentHandler = { _ in throw NSError(domain: "error", code: -1, userInfo: nil) }

        // When
        await viewModel.getEnrollments()

        // Then
        XCTAssertEqual(interactor.getPrimaryEnrollmentCallCount, 1)
        XCTAssertNil(viewModel.enrollments)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.unknownError)
        XCTAssertTrue(viewModel.showError)
        XCTAssertFalse(viewModel.fetchInProgress)
    }

    func testTrackDashboardCourseClicked() {
        // Given
        let viewModel = PrimaryCourseDashboardViewModel(
            interactor: interactor,
            connectivity: connectivity,
            analytics: analytics,
            config: config,
            storage: storage,
            router: router
        )

        let courseID = "test-course-id"
        let courseName = "Test Course"

        // When
        viewModel.trackDashboardCourseClicked(courseID: courseID, courseName: courseName)

        // Then
        XCTAssertEqual(analytics.dashboardCourseClickedCallCount, 1)
    }

    func testNotificationCenterSubscriptions() async {
        // Given
        let viewModel = PrimaryCourseDashboardViewModel(
            interactor: interactor,
            connectivity: connectivity,
            analytics: analytics,
            config: config,
            storage: storage,
            router: router
        )

        connectivity.isInternetAvaliable = true
        interactor.getPrimaryEnrollmentHandler = { _ in self.enrollment }

        // When
        NotificationCenter.default.post(name: .onCourseEnrolled, object: nil)
        NotificationCenter.default.post(name: .onblockCompletionRequested, object: nil)
        NotificationCenter.default.post(name: .refreshEnrollments, object: nil)

        // Wait a bit for async operations to complete
        try? await Task.sleep(nanoseconds: 100_000_000)

        // Then
        // Verify that getEnrollments was called multiple times due to notifications
        XCTAssertTrue(interactor.getPrimaryEnrollmentCallCount > 0)
    }
}

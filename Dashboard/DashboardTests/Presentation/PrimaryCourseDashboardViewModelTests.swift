//
//  PrimaryCourseDashboardViewModelTests.swift
//  Dashboard
//
//  Created by Ivan Stepanok on 30.10.2024.
//


import SwiftyMocky
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
    var config: ConfigProtocolMock!
    
    override func setUp() {
        super.setUp()
        interactor = DashboardInteractorProtocolMock()
        connectivity = ConnectivityProtocolMock()
        analytics = DashboardAnalyticsMock()
        storage = CoreStorageMock()
        config = ConfigProtocolMock()
        interactor = DashboardInteractorProtocolMock()
    }
    
    let enrollment = PrimaryEnrollment(
        primaryCourse: PrimaryCourse.init(
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
            CourseItem.init(
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
            storage: storage
        )
        
        Given(connectivity, .isInternetAvaliable(getter: true))
        Given(interactor, .getPrimaryEnrollment(pageSize: .any, willReturn: enrollment))
        
        // When
        await viewModel.getEnrollments()
        
        // Then
        Verify(interactor, 1, .getPrimaryEnrollment(pageSize: .value(UIDevice.current.userInterfaceIdiom == .pad ? 7 : 5)))
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
            storage: storage
        )
                
        Given(connectivity, .isInternetAvaliable(getter: false))
        Given(interactor, .getPrimaryEnrollmentOffline(willReturn: enrollment))
        
        // When
        await viewModel.getEnrollments()
        
        // Then
        Verify(interactor, 1, .getPrimaryEnrollmentOffline())
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
            storage: storage
        )
        
        Given(connectivity, .isInternetAvaliable(getter: true))
        Given(interactor, .getPrimaryEnrollment(pageSize: .any, willThrow: NoCachedDataError()))
        
        // When
        await viewModel.getEnrollments()
        
        // Then
        Verify(interactor, 1, .getPrimaryEnrollment(pageSize: .value(UIDevice.current.userInterfaceIdiom == .pad ? 7 : 5)))
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
            storage: storage
        )
        
        Given(connectivity, .isInternetAvaliable(getter: true))
        Given(interactor, .getPrimaryEnrollment(pageSize: .any, willThrow: NSError()))
        
        // When
        await viewModel.getEnrollments()
        
        // Then
        Verify(interactor, 1, .getPrimaryEnrollment(pageSize: .value(UIDevice.current.userInterfaceIdiom == .pad ? 7 : 5)))
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
            storage: storage
        )
        
        let courseID = "test-course-id"
        let courseName = "Test Course"
        
        // When
        viewModel.trackDashboardCourseClicked(courseID: courseID, courseName: courseName)
        
        // Then
        Verify(analytics, 1, .dashboardCourseClicked(courseID: .value(courseID), courseName: .value(courseName)))
    }
    
    func testNotificationCenterSubscriptions() async {
        // Given
        let viewModel = PrimaryCourseDashboardViewModel(
            interactor: interactor,
            connectivity: connectivity,
            analytics: analytics,
            config: config,
            storage: storage
        )
        
        Given(connectivity, .isInternetAvaliable(getter: true))
        Given(interactor, .getPrimaryEnrollment(pageSize: .any, willReturn: enrollment))
        
        // When
        NotificationCenter.default.post(name: .onCourseEnrolled, object: nil)
        NotificationCenter.default.post(name: .onblockCompletionRequested, object: nil)
        NotificationCenter.default.post(name: .refreshEnrollments, object: nil)
        
        // Wait a bit for async operations to complete
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        // Verify that getEnrollments was called multiple times due to notifications
        Verify(interactor, .getPrimaryEnrollment(pageSize: .any))
    }
}

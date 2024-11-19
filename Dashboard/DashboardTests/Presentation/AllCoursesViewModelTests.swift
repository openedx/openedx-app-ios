//
//  AllCoursesViewModelTests.swift
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
final class AllCoursesViewModelTests: XCTestCase {
    
    var interactor: DashboardInteractorProtocolMock!
    var connectivity: ConnectivityProtocolMock!
    var analytics: DashboardAnalyticsMock!
    var storage: CoreStorageMock!
    
    override func setUp() {
        super.setUp()
        interactor = DashboardInteractorProtocolMock()
        connectivity = ConnectivityProtocolMock()
        analytics = DashboardAnalyticsMock()
        storage = CoreStorageMock()
    }
    
    let mockEnrollment = PrimaryEnrollment(
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
            ),
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
                courseID: "3",
                numPages: 1,
                coursesCount: 3,
                courseRawImage: nil,
                progressEarned: 0,
                progressPossible: 2
            ),
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
                courseID: "4",
                numPages: 1,
                coursesCount: 3,
                courseRawImage: nil,
                progressEarned: 0,
                progressPossible: 2
            )
        ],
        totalPages: 2,
        count: 1
    )
    
    func testGetCoursesSuccess() async throws {
        // Given
        let viewModel = AllCoursesViewModel(
            interactor: interactor,
            connectivity: connectivity,
            analytics: analytics,
            storage: storage
        )
        
        Given(interactor, .getAllCourses(filteredBy: .any, page: .any, willReturn: mockEnrollment))
        
        // When
        await viewModel.getCourses(page: 1)
        
        // Then
        Verify(interactor, 1, .getAllCourses(filteredBy: .any, page: .value(1)))
        XCTAssertEqual(viewModel.myEnrollments?.courses.count, 3)
        XCTAssertEqual(viewModel.nextPage, 2)
        XCTAssertEqual(viewModel.totalPages, 2)
        XCTAssertFalse(viewModel.fetchInProgress)
        XCTAssertFalse(viewModel.showError)
    }
    
    func testGetCoursesWithPagination() async throws {
        // Given
        let viewModel = AllCoursesViewModel(
            interactor: interactor,
            connectivity: connectivity,
            analytics: analytics,
            storage: storage
        )
        
        Given(interactor, .getAllCourses(filteredBy: .any, page: .any, willReturn: mockEnrollment))
        
        // When
        await viewModel.getCourses(page: 1)
        await viewModel.getCourses(page: 2)
        
        // Then
        Verify(interactor, 2, .getAllCourses(filteredBy: .any, page: .any))
        XCTAssertEqual(viewModel.nextPage, 3)
    }
    
    func testGetCoursesNoCachedDataError() async throws {
        // Given
        let viewModel = AllCoursesViewModel(
            interactor: interactor,
            connectivity: connectivity,
            analytics: analytics,
            storage: storage
        )
        
        Given(interactor, .getAllCourses(filteredBy: .any, page: .any, willThrow: NoCachedDataError()))
        
        // When
        await viewModel.getCourses(page: 1)
        
        // Then
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.noCachedData)
        XCTAssertTrue(viewModel.showError)
        XCTAssertFalse(viewModel.fetchInProgress)
    }
    
    func testGetCoursesUnknownError() async throws {
        // Given
        let viewModel = AllCoursesViewModel(
            interactor: interactor,
            connectivity: connectivity,
            analytics: analytics,
            storage: storage
        )
        
        Given(interactor, .getAllCourses(filteredBy: .any, page: .any, willThrow: NSError()))
        
        // When
        await viewModel.getCourses(page: 1)
        
        // Then
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.unknownError)
        XCTAssertTrue(viewModel.showError)
        XCTAssertFalse(viewModel.fetchInProgress)
    }
    
    func testGetMyCoursesPagination() async {
        // Given
        let viewModel = AllCoursesViewModel(
            interactor: interactor,
            connectivity: connectivity,
            analytics: analytics,
            storage: storage
        )
        
        Given(interactor, .getAllCourses(filteredBy: .any, page: .any, willReturn: mockEnrollment))
        
        // When
        await viewModel.getCourses(page: 1)
        await viewModel.getMyCoursesPagination(index: 0)
        await viewModel.getMyCoursesPagination(index: mockEnrollment.courses.count - 3)
        
        // Then
        Verify(interactor, 2, .getAllCourses(filteredBy: .any, page: .any))
    }
    
    func testTrackDashboardCourseClicked() {
        // Given
        let viewModel = AllCoursesViewModel(
            interactor: interactor,
            connectivity: connectivity,
            analytics: analytics,
            storage: storage
        )
        
        // When
        viewModel.trackDashboardCourseClicked(courseID: "test-id", courseName: "Test Course")
        
        // Then
        Verify(analytics, 1, .dashboardCourseClicked(courseID: .value("test-id"), courseName: .value("Test Course")))
    }
}

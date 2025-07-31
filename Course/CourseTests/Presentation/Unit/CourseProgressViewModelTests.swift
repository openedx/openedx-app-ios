//
//  CourseProgressViewModelTests.swift
//  CourseTests
//
//  Created by Ivan Stepanok on 20.06.2025.
//

import SwiftyMocky
import XCTest
@testable import Core
@testable import Course
import Alamofire
import SwiftUI

@MainActor
final class CourseProgressViewModelTests: XCTestCase {
    
    static let mockCourseProgress = CourseProgressDetails(
        verifiedMode: nil,
        accessExpiration: nil,
        certificateData: CourseProgressCertificateData(
            certStatus: "downloadable",
            certWebViewUrl: "https://example.com/cert",
            downloadUrl: "https://example.com/download",
            certificateAvailableDate: nil
        ),
        completionSummary: CourseProgressCompletionSummary(
            completeCount: 8,
            incompleteCount: 2,
            lockedCount: 0
        ),
        courseGrade: CourseProgressGrade(
            letterGrade: "A",
            percent: 0.85,
            isPassing: true
        ),
        creditCourseRequirements: nil,
        end: nil,
        enrollmentMode: "honor",
        gradingPolicy: CourseProgressGradingPolicy(
            assignmentPolicies: [
                CourseProgressAssignmentPolicy(
                    numDroppable: 1,
                    numTotal: 5,
                    shortLabel: "HW",
                    type: "Homework",
                    weight: 0.5
                ),
                CourseProgressAssignmentPolicy(
                    numDroppable: 0,
                    numTotal: 2,
                    shortLabel: "Exam",
                    type: "Exam",
                    weight: 0.5
                )
            ],
            gradeRange: ["Pass": 0.6, "Fail": 0.0],
            assignmentColors: ["#FF5733", "#33C1FF"]
        ),
        hasScheduledContent: false,
        sectionScores: [
            CourseProgressSectionScore(
                displayName: "Section 1",
                subsections: [
                    CourseProgressSubsection(
                        assignmentType: "Homework",
                        blockKey: "hw1",
                        displayName: "Homework 1",
                        hasGradedAssignment: true,
                        override: nil,
                        learnerHasAccess: true,
                        numPointsEarned: 8.0,
                        numPointsPossible: 10.0,
                        percentGraded: 0.8,
                        problemScores: [
                            CourseProgressProblemScore(earned: 8.0, possible: 10.0)
                        ],
                        showCorrectness: "always",
                        showGrades: true,
                        url: "https://example.com/hw1"
                    )
                ]
            )
        ],
        verificationData: nil
    )
    
    static let mockEmptyProgress = CourseProgressDetails(
        verifiedMode: nil,
        accessExpiration: nil,
        certificateData: CourseProgressCertificateData(
            certStatus: nil,
            certWebViewUrl: nil,
            downloadUrl: nil,
            certificateAvailableDate: nil
        ),
        completionSummary: CourseProgressCompletionSummary(
            completeCount: 0,
            incompleteCount: 0,
            lockedCount: 0
        ),
        courseGrade: CourseProgressGrade(
            letterGrade: nil,
            percent: 0.0,
            isPassing: false
        ),
        creditCourseRequirements: nil,
        end: nil,
        enrollmentMode: "honor",
        gradingPolicy: CourseProgressGradingPolicy(
            assignmentPolicies: [],
            gradeRange: [:],
            assignmentColors: []
        ),
        hasScheduledContent: false,
        sectionScores: [],
        verificationData: nil
    )

    func testGetCourseProgressSuccess() async throws {
        let interactor = CourseInteractorProtocolMock()
        let router = CourseRouterMock()
        let connectivity = ConnectivityProtocolMock()
        let analytics = CourseAnalyticsMock()
        
        let viewModel = CourseProgressViewModel(
            interactor: interactor,
            router: router,
            analytics: analytics,
            connectivity: connectivity
        )
        
        Given(connectivity, .isInternetAvaliable(getter: true))
        Given(interactor, .getCourseProgress(courseID: .any, willReturn: CourseProgressViewModelTests.mockCourseProgress))
        
        await viewModel.getCourseProgress(courseID: "test-course-id")
        
        Verify(interactor, .getCourseProgress(courseID: .any))
        
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(viewModel.showError)
        XCTAssertNotNil(viewModel.courseProgress)
        XCTAssertEqual(viewModel.courseProgress?.courseGrade.percent, 0.85)
    }

    func testGetCourseProgressOfflineSuccess() async throws {
        let interactor = CourseInteractorProtocolMock()
        let router = CourseRouterMock()
        let connectivity = ConnectivityProtocolMock()
        let analytics = CourseAnalyticsMock()
        
        let viewModel = CourseProgressViewModel(
            interactor: interactor,
            router: router,
            analytics: analytics,
            connectivity: connectivity
        )
        
        Given(connectivity, .isInternetAvaliable(getter: false))
        Given(interactor, .getCourseProgressOffline(courseID: .any, willReturn: CourseProgressViewModelTests.mockCourseProgress))
        
        await viewModel.getCourseProgress(courseID: "test-course-id")
        
        Verify(interactor, .getCourseProgressOffline(courseID: .any))
        
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(viewModel.showError)
        XCTAssertNotNil(viewModel.courseProgress)
    }
    
    func testGetCourseProgressUnknownError() async throws {
        let interactor = CourseInteractorProtocolMock()
        let router = CourseRouterMock()
        let connectivity = ConnectivityProtocolMock()
        let analytics = CourseAnalyticsMock()
        
        let viewModel = CourseProgressViewModel(
            interactor: interactor,
            router: router,
            analytics: analytics,
            connectivity: connectivity
        )
        
        Given(connectivity, .isInternetAvaliable(getter: true))
        Given(interactor, .getCourseProgress(courseID: .any, willThrow: NSError(domain: "error", code: -1, userInfo: nil)))
        
        await viewModel.getCourseProgress(courseID: "test-course-id")
        
        Verify(interactor, .getCourseProgress(courseID: .any))
        
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.unknownError)
    }
    
    func testGetCourseProgressNoInternetError() async throws {
        let interactor = CourseInteractorProtocolMock()
        let router = CourseRouterMock()
        let connectivity = ConnectivityProtocolMock()
        let analytics = CourseAnalyticsMock()
        
        let viewModel = CourseProgressViewModel(
            interactor: interactor,
            router: router,
            analytics: analytics,
            connectivity: connectivity
        )
        
        let noInternetError = AFError.sessionInvalidated(error: URLError(.notConnectedToInternet))
        
        Given(connectivity, .isInternetAvaliable(getter: true))
        Given(interactor, .getCourseProgress(courseID: .any, willThrow: noInternetError))
        
        await viewModel.getCourseProgress(courseID: "test-course-id")
        
        Verify(interactor, .getCourseProgress(courseID: .any))
        
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.slowOrNoInternetConnection)
    }
    
    func testGetCourseProgressNoCacheError() async throws {
        let interactor = CourseInteractorProtocolMock()
        let router = CourseRouterMock()
        let connectivity = ConnectivityProtocolMock()
        let analytics = CourseAnalyticsMock()
        
        let viewModel = CourseProgressViewModel(
            interactor: interactor,
            router: router,
            analytics: analytics,
            connectivity: connectivity
        )
        
        Given(connectivity, .isInternetAvaliable(getter: true))
        Given(interactor, .getCourseProgress(courseID: .any, willThrow: NoCachedDataError()))
        
        await viewModel.getCourseProgress(courseID: "test-course-id")
        
        Verify(interactor, .getCourseProgress(courseID: .any))
        
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.slowOrNoInternetConnection)
    }
    
    func testTrackProgressTabClicked() {
        let interactor = CourseInteractorProtocolMock()
        let router = CourseRouterMock()
        let connectivity = ConnectivityProtocolMock()
        let analytics = CourseAnalyticsMock()
        
        let viewModel = CourseProgressViewModel(
            interactor: interactor,
            router: router,
            analytics: analytics,
            connectivity: connectivity
        )
        
        viewModel.trackProgressTabClicked(courseId: "test-course", courseName: "Test Course")
        
        Verify(analytics, .courseOutlineProgressTabClicked(courseId: .any, courseName: .any))
    }
    
    func testRefreshProgress() async throws {
        let interactor = CourseInteractorProtocolMock()
        let router = CourseRouterMock()
        let connectivity = ConnectivityProtocolMock()
        let analytics = CourseAnalyticsMock()
        
        let viewModel = CourseProgressViewModel(
            interactor: interactor,
            router: router,
            analytics: analytics,
            connectivity: connectivity
        )
        
        Given(connectivity, .isInternetAvaliable(getter: true))
        Given(interactor, .getCourseProgress(courseID: .any, willReturn: CourseProgressViewModelTests.mockCourseProgress))
        
        await viewModel.getCourseProgress(courseID: "test-course-id", withProgress: false)
        
        Verify(interactor, .getCourseProgress(courseID: .any))
        
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNotNil(viewModel.courseProgress)
    }

    func testIsProgressEmpty() {
        let interactor = CourseInteractorProtocolMock()
        let router = CourseRouterMock()
        let connectivity = ConnectivityProtocolMock()
        let analytics = CourseAnalyticsMock()
        
        let viewModel = CourseProgressViewModel(
            interactor: interactor,
            router: router,
            analytics: analytics,
            connectivity: connectivity
        )
        
        // Test with nil progress
        XCTAssertTrue(viewModel.isProgressEmpty)
        
        // Test with empty progress
        viewModel.courseProgress = CourseProgressViewModelTests.mockEmptyProgress
        XCTAssertTrue(viewModel.isProgressEmpty)
        
        // Test with non-empty progress
        viewModel.courseProgress = CourseProgressViewModelTests.mockCourseProgress
        XCTAssertFalse(viewModel.isProgressEmpty)
    }
    
    func testHasGradedAssignments() {
        let interactor = CourseInteractorProtocolMock()
        let router = CourseRouterMock()
        let connectivity = ConnectivityProtocolMock()
        let analytics = CourseAnalyticsMock()
        
        let viewModel = CourseProgressViewModel(
            interactor: interactor,
            router: router,
            analytics: analytics,
            connectivity: connectivity
        )
        
        // Test with nil progress
        XCTAssertFalse(viewModel.hasGradedAssignments)
        
        // Test with empty progress
        viewModel.courseProgress = CourseProgressViewModelTests.mockEmptyProgress
        XCTAssertFalse(viewModel.hasGradedAssignments)
        
        // Test with progress that has graded assignments
        viewModel.courseProgress = CourseProgressViewModelTests.mockCourseProgress
        XCTAssertTrue(viewModel.hasGradedAssignments)
    }
    
    func testOverallProgressPercentage() {
        let interactor = CourseInteractorProtocolMock()
        let router = CourseRouterMock()
        let connectivity = ConnectivityProtocolMock()
        let analytics = CourseAnalyticsMock()
        
        let viewModel = CourseProgressViewModel(
            interactor: interactor,
            router: router,
            analytics: analytics,
            connectivity: connectivity
        )
        
        // Test with nil progress
        XCTAssertEqual(viewModel.overallProgressPercentage, 0.0)
        
        // Test with actual progress
        viewModel.courseProgress = CourseProgressViewModelTests.mockCourseProgress
        XCTAssertEqual(viewModel.overallProgressPercentage, 0.8) // 8/10 = 0.8
    }
    
    func testGradePercentage() {
        let interactor = CourseInteractorProtocolMock()
        let router = CourseRouterMock()
        let connectivity = ConnectivityProtocolMock()
        let analytics = CourseAnalyticsMock()
        
        let viewModel = CourseProgressViewModel(
            interactor: interactor,
            router: router,
            analytics: analytics,
            connectivity: connectivity
        )
        
        // Test with nil progress
        XCTAssertEqual(viewModel.gradePercentage, 0.0)
        
        // Test with actual progress
        viewModel.courseProgress = CourseProgressViewModelTests.mockCourseProgress
        XCTAssertEqual(viewModel.gradePercentage, 0.85)
    }
    
    func testIsPassing() {
        let interactor = CourseInteractorProtocolMock()
        let router = CourseRouterMock()
        let connectivity = ConnectivityProtocolMock()
        let analytics = CourseAnalyticsMock()
        
        let viewModel = CourseProgressViewModel(
            interactor: interactor,
            router: router,
            analytics: analytics,
            connectivity: connectivity
        )
        
        // Test with nil progress
        XCTAssertFalse(viewModel.isPassing)
        
        // Test with passing progress
        viewModel.courseProgress = CourseProgressViewModelTests.mockCourseProgress
        XCTAssertTrue(viewModel.isPassing)
    }
    
    func testHasCertificate() {
        let interactor = CourseInteractorProtocolMock()
        let router = CourseRouterMock()
        let connectivity = ConnectivityProtocolMock()
        let analytics = CourseAnalyticsMock()
        
        let viewModel = CourseProgressViewModel(
            interactor: interactor,
            router: router,
            analytics: analytics,
            connectivity: connectivity
        )
        
        // Test with nil progress
        XCTAssertFalse(viewModel.hasCertificate)
        
        // Test with certificate available
        viewModel.courseProgress = CourseProgressViewModelTests.mockCourseProgress
        XCTAssertTrue(viewModel.hasCertificate)
    }
    
    func testCertificateUrl() {
        let interactor = CourseInteractorProtocolMock()
        let router = CourseRouterMock()
        let connectivity = ConnectivityProtocolMock()
        let analytics = CourseAnalyticsMock()
        
        let viewModel = CourseProgressViewModel(
            interactor: interactor,
            router: router,
            analytics: analytics,
            connectivity: connectivity
        )
        
        // Test with nil progress
        XCTAssertNil(viewModel.certificateUrl)
        
        // Test with certificate URL
        viewModel.courseProgress = CourseProgressViewModelTests.mockCourseProgress
        XCTAssertEqual(viewModel.certificateUrl, "https://example.com/download")
    }

    func testRequiredGradePercentage() {
        let interactor = CourseInteractorProtocolMock()
        let router = CourseRouterMock()
        let connectivity = ConnectivityProtocolMock()
        let analytics = CourseAnalyticsMock()
        
        let viewModel = CourseProgressViewModel(
            interactor: interactor,
            router: router,
            analytics: analytics,
            connectivity: connectivity
        )
        
        // Test with nil progress
        XCTAssertEqual(viewModel.requiredGradePercentage, 0.0)
        
        // Test with actual progress
        viewModel.courseProgress = CourseProgressViewModelTests.mockCourseProgress
        XCTAssertEqual(viewModel.requiredGradePercentage, 0.6)
    }
    
    func testAssignmentPolicies() {
        let interactor = CourseInteractorProtocolMock()
        let router = CourseRouterMock()
        let connectivity = ConnectivityProtocolMock()
        let analytics = CourseAnalyticsMock()
        
        let viewModel = CourseProgressViewModel(
            interactor: interactor,
            router: router,
            analytics: analytics,
            connectivity: connectivity
        )
        
        // Test with nil progress
        XCTAssertTrue(viewModel.assignmentPolicies.isEmpty)
        
        // Test with actual progress
        viewModel.courseProgress = CourseProgressViewModelTests.mockCourseProgress
        XCTAssertEqual(viewModel.assignmentPolicies.count, 2)
        XCTAssertEqual(viewModel.assignmentPolicies[0].type, "Homework")
        XCTAssertEqual(viewModel.assignmentPolicies[1].type, "Exam")
    }
    
    func testGetAssignmentProgress() {
        let interactor = CourseInteractorProtocolMock()
        let router = CourseRouterMock()
        let connectivity = ConnectivityProtocolMock()
        let analytics = CourseAnalyticsMock()
        
        let viewModel = CourseProgressViewModel(
            interactor: interactor,
            router: router,
            analytics: analytics,
            connectivity: connectivity
        )
        
        // Test with nil progress
        let emptyProgress = viewModel.getAssignmentProgress(for: "Homework")
        XCTAssertEqual(emptyProgress.completed, 0)
        XCTAssertEqual(emptyProgress.total, 0)
        XCTAssertEqual(emptyProgress.earnedPoints, 0.0)
        XCTAssertEqual(emptyProgress.possiblePoints, 0.0)
        
        // Test with actual progress
        viewModel.courseProgress = CourseProgressViewModelTests.mockCourseProgress
        let homeworkProgress = viewModel.getAssignmentProgress(for: "Homework")
        XCTAssertEqual(homeworkProgress.completed, 1)
        XCTAssertEqual(homeworkProgress.total, 1)
        XCTAssertEqual(homeworkProgress.earnedPoints, 8.0)
        XCTAssertEqual(homeworkProgress.possiblePoints, 10.0)
        XCTAssertEqual(homeworkProgress.percentGraded, 0.8)
    }
    
    func testGetAllAssignmentProgressData() {
        let interactor = CourseInteractorProtocolMock()
        let router = CourseRouterMock()
        let connectivity = ConnectivityProtocolMock()
        let analytics = CourseAnalyticsMock()
        
        let viewModel = CourseProgressViewModel(
            interactor: interactor,
            router: router,
            analytics: analytics,
            connectivity: connectivity
        )
        
        // Test with nil progress
        let emptyData = viewModel.getAllAssignmentProgressData()
        XCTAssertTrue(emptyData.isEmpty)
        
        // Test with actual progress
        viewModel.courseProgress = CourseProgressViewModelTests.mockCourseProgress
        let allData = viewModel.getAllAssignmentProgressData()
        XCTAssertEqual(allData.count, 2)
        XCTAssertNotNil(allData["Homework"])
        XCTAssertNotNil(allData["Exam"])
    }
}

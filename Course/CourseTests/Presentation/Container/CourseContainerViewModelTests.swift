//
//  CourseContainerViewModelTests.swift
//  CourseTests
//
//  Created by  Stepanok Ivan on 20.01.2023.
//

import XCTest
import Core
@testable import Course
import Alamofire
import SwiftUI
import Combine

@MainActor
final class CourseContainerViewModelTests: XCTestCase {
    var courseHelperMock: CourseDownloadHelperProtocolMock!

    override func setUpWithError() throws {
        try super.setUpWithError()
        courseHelperMock = CourseDownloadHelperProtocolMock()
        courseHelperMock.publisherHandler = { Just(.empty).eraseToAnyPublisher() }
    }

    func testGetCourseBlocksSuccess() async throws {
        let interactor = CourseInteractorProtocolMock()
        let authInteractor = AuthInteractorProtocolMock()
        let router = CourseRouterMock()
        let analytics = CourseAnalyticsMock()
        let config = ConfigMock()
        let connectivity = ConnectivityProtocolMock()

        connectivity.isInternetAvaliable = true
        connectivity.internetReachableSubject = .init(.reachable)

        let downloadManager = DownloadManagerMock()

        let viewModel = CourseContainerViewModel(
            interactor: interactor,
            authInteractor: authInteractor,
            router: router,
            analytics: analytics,
            config: config,
            connectivity: connectivity,
            manager: downloadManager,
            storage: CourseStorageMock(),
            isActive: true,
            courseStart: Date(),
            courseEnd: nil,
            enrollmentStart: nil,
            enrollmentEnd: nil,
            lastVisitedBlockID: nil,
            coreAnalytics: CoreAnalyticsMock(),
            courseHelper: courseHelperMock
        )

        let block = CourseBlock(
            blockId: "",
            id: "",
            courseId: "123",
            topicId: "",
            graded: true,
            due: Date(),
            completion: 0,
            type: .problem,
            displayName: "",
            studentUrl: "",
            webUrl: "",
            encodedVideo: nil,
            multiDevice: true,
            offlineDownload: nil
        )
        let vertical = CourseVertical(
            blockId: "",
            id: "",
            courseId: "123",
            displayName: "",
            type: .vertical,
            completion: 0,
            childs: [block],
            webUrl: ""
        )
        let sequential = CourseSequential(
            blockId: "",
            id: "",
            displayName: "",
            type: .chapter,
            completion: 0,
            childs: [vertical],
            sequentialProgress: nil,
            due: Date()
        )
        let chapter = CourseChapter(
            blockId: "",
            id: "",
            displayName: "",
            type: .chapter,
            childs: [sequential]
        )

        let childs = [chapter]

        let courseStructure = CourseStructure(
            id: "123",
            graded: true,
            completion: 0,
            viewYouTubeUrl: "",
            encodedVideo: "",
            displayName: "",
            topicID: nil,
            childs: childs,
            media: CourseMedia(
                image: CourseImage(
                    raw: "",
                    small: "",
                    large: ""
                )
            ),
            certificate: nil,
            org: "",
            isSelfPaced: true,
            courseProgress: nil
        )

        let resumeBlock = ResumeBlock(blockID: "123")

        interactor.getCourseBlocksHandler = { _ in courseStructure }
        interactor.resumeBlockHandler = { _ in resumeBlock }
        interactor.getCourseVideoBlocksHandler = { _ in courseStructure }
        interactor.getCourseAssignmentBlocksHandler = { _ in courseStructure }

        let mockCourseProgress = CourseProgressDetails(
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
            enrollmentMode: "audit",
            gradingPolicy: CourseProgressGradingPolicy(
                assignmentPolicies: [],
                gradeRange: [:],
                assignmentColors: []
            ),
            hasScheduledContent: false,
            sectionScores: [],
            verificationData: nil
        )
        interactor.getCourseProgressHandler = { _ in mockCourseProgress }

        await viewModel.getCourseBlocks(courseID: "123")

        XCTAssertTrue(interactor.getCourseBlocksCallCount > 0)
        XCTAssertTrue(interactor.getCourseVideoBlocksCallCount > 0)
        XCTAssertTrue(interactor.resumeBlockCallCount > 0)
        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertFalse(viewModel.showError)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.courseStructure, courseStructure)
        XCTAssertEqual(viewModel.courseHelper.courseStructure, courseStructure)
    }

    func testGetCourseBlocksOfflineSuccess() async throws {
        let interactor = CourseInteractorProtocolMock()
        let authInteractor = AuthInteractorProtocolMock()
        let router = CourseRouterMock()
        let analytics = CourseAnalyticsMock()
        let config = ConfigMock()
        let connectivity = ConnectivityProtocolMock()

        connectivity.isInternetAvaliable = false
        connectivity.internetReachableSubject = .init(.reachable)

        let downloadManager = DownloadManagerMock()

        let viewModel = CourseContainerViewModel(
            interactor: interactor,
            authInteractor: authInteractor,
            router: router,
            analytics: analytics,
            config: config,
            connectivity: connectivity,
            manager: downloadManager,
            storage: CourseStorageMock(),
            isActive: true,
            courseStart: Date(),
            courseEnd: nil,
            enrollmentStart: nil,
            enrollmentEnd: nil,
            lastVisitedBlockID: nil,
            coreAnalytics: CoreAnalyticsMock(),
            courseHelper: courseHelperMock
        )

        let courseStructure = CourseStructure(
            id: "123",
            graded: true,
            completion: 0,
            viewYouTubeUrl: "",
            encodedVideo: "",
            displayName: "",
            topicID: nil,
            childs: [],
            media: CourseMedia(
                image: CourseImage(
                    raw: "",
                    small: "",
                    large: ""
                )
            ),
            certificate: nil,
            org: "",
            isSelfPaced: true,
            courseProgress: nil
        )

        interactor.getLoadedCourseBlocksHandler = { _ in courseStructure }
        interactor.getCourseVideoBlocksHandler = { _ in courseStructure }
        interactor.getCourseAssignmentBlocksHandler = { _ in courseStructure }

        let mockCourseProgress = CourseProgressDetails(
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
            enrollmentMode: "audit",
            gradingPolicy: CourseProgressGradingPolicy(
                assignmentPolicies: [],
                gradeRange: [:],
                assignmentColors: []
            ),
            hasScheduledContent: false,
            sectionScores: [],
            verificationData: nil
        )
        interactor.getCourseProgressOfflineHandler = { _ in mockCourseProgress }

        await viewModel.getCourseBlocks(courseID: "123")

        XCTAssertTrue(interactor.getLoadedCourseBlocksCallCount > 0)
        XCTAssertTrue(interactor.getCourseVideoBlocksCallCount > 0)
        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertFalse(viewModel.showError)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.courseStructure, courseStructure)
        XCTAssertEqual(viewModel.courseHelper.courseStructure, courseStructure)
    }

    func testGetCourseBlocksNoInternetError() async throws {
        let interactor = CourseInteractorProtocolMock()
        let authInteractor = AuthInteractorProtocolMock()
        let router = CourseRouterMock()
        let analytics = CourseAnalyticsMock()
        let config = ConfigMock()
        let connectivity = ConnectivityProtocolMock()

        connectivity.isInternetAvaliable = true
        connectivity.internetReachableSubject = .init(.reachable)

        let downloadManager = DownloadManagerMock()

        let viewModel = CourseContainerViewModel(
            interactor: interactor,
            authInteractor: authInteractor,
            router: router,
            analytics: analytics,
            config: config,
            connectivity: connectivity,
            manager: downloadManager,
            storage: CourseStorageMock(),
            isActive: true,
            courseStart: Date(),
            courseEnd: nil,
            enrollmentStart: nil,
            enrollmentEnd: nil,
            lastVisitedBlockID: nil,
            coreAnalytics: CoreAnalyticsMock(),
            courseHelper: courseHelperMock
        )

        let noInternetError = AFError.sessionInvalidated(error: URLError(.notConnectedToInternet))

        let courseStructure = CourseStructure(
            id: "123",
            graded: true,
            completion: 0,
            viewYouTubeUrl: "",
            encodedVideo: "",
            displayName: "",
            topicID: nil,
            childs: [],
            media: CourseMedia(
                image: CourseImage(
                    raw: "",
                    small: "",
                    large: ""
                )
            ),
            certificate: nil,
            org: "",
            isSelfPaced: true,
            courseProgress: nil
        )

        interactor.getCourseBlocksHandler = { _ in throw noInternetError }
        interactor.getLoadedCourseBlocksHandler = { _ in throw NoCachedDataError() }
        interactor.getCourseAssignmentBlocksHandler = { _ in courseStructure }

        let mockCourseProgress = CourseProgressDetails(
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
            enrollmentMode: "audit",
            gradingPolicy: CourseProgressGradingPolicy(
                assignmentPolicies: [],
                gradeRange: [:],
                assignmentColors: []
            ),
            hasScheduledContent: false,
            sectionScores: [],
            verificationData: nil
        )
        interactor.getCourseProgressHandler = { _ in mockCourseProgress }

        await viewModel.getCourseBlocks(courseID: "123")

        XCTAssertTrue(interactor.getCourseBlocksCallCount > 0)
        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertNil(viewModel.courseStructure)
        XCTAssertNil(viewModel.courseVideosStructure)
        XCTAssertNil(viewModel.courseHelper.courseStructure)
    }

    func testGetCourseBlocksNoCacheError() async throws {
        let interactor = CourseInteractorProtocolMock()
        let authInteractor = AuthInteractorProtocolMock()
        let router = CourseRouterMock()
        let analytics = CourseAnalyticsMock()
        let config = ConfigMock()
        let connectivity = ConnectivityProtocolMock()

        connectivity.isInternetAvaliable = true
        connectivity.internetReachableSubject = .init(.reachable)

        let downloadManager = DownloadManagerMock()

        let viewModel = CourseContainerViewModel(
            interactor: interactor,
            authInteractor: authInteractor,
            router: router,
            analytics: analytics,
            config: config,
            connectivity: connectivity,
            manager: downloadManager,
            storage: CourseStorageMock(),
            isActive: true,
            courseStart: Date(),
            courseEnd: nil,
            enrollmentStart: nil,
            enrollmentEnd: nil,
            lastVisitedBlockID: nil,
            coreAnalytics: CoreAnalyticsMock(),
            courseHelper: courseHelperMock
        )

        let courseStructure = CourseStructure(
            id: "123",
            graded: true,
            completion: 0,
            viewYouTubeUrl: "",
            encodedVideo: "",
            displayName: "",
            topicID: nil,
            childs: [],
            media: CourseMedia(
                image: CourseImage(
                    raw: "",
                    small: "",
                    large: ""
                )
            ),
            certificate: nil,
            org: "",
            isSelfPaced: true,
            courseProgress: nil
        )

        interactor.getCourseBlocksHandler = { _ in throw NoCachedDataError() }
        interactor.getCourseAssignmentBlocksHandler = { _ in courseStructure }

        let mockCourseProgress = CourseProgressDetails(
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
            enrollmentMode: "audit",
            gradingPolicy: CourseProgressGradingPolicy(
                assignmentPolicies: [],
                gradeRange: [:],
                assignmentColors: []
            ),
            hasScheduledContent: false,
            sectionScores: [],
            verificationData: nil
        )
        interactor.getCourseProgressHandler = { _ in mockCourseProgress }

        await viewModel.getCourseBlocks(courseID: "123")

        XCTAssertTrue(interactor.getCourseBlocksCallCount > 0)
        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertNil(viewModel.courseStructure)
        XCTAssertNil(viewModel.courseVideosStructure)
        XCTAssertNil(viewModel.courseHelper.courseStructure)
    }

    func testGetCourseBlocksUnknownError() async throws {
        let interactor = CourseInteractorProtocolMock()
        let authInteractor = AuthInteractorProtocolMock()
        let router = CourseRouterMock()
        let analytics = CourseAnalyticsMock()
        let config = ConfigMock()
        let connectivity = ConnectivityProtocolMock()

        connectivity.isInternetAvaliable = true
        connectivity.internetReachableSubject = .init(.reachable)

        let downloadManager = DownloadManagerMock()

        let viewModel = CourseContainerViewModel(
            interactor: interactor,
            authInteractor: authInteractor,
            router: router,
            analytics: analytics,
            config: config,
            connectivity: connectivity,
            manager: downloadManager,
            storage: CourseStorageMock(),
            isActive: true,
            courseStart: Date(),
            courseEnd: nil,
            enrollmentStart: nil,
            enrollmentEnd: nil,
            lastVisitedBlockID: nil,
            coreAnalytics: CoreAnalyticsMock(),
            courseHelper: courseHelperMock
        )

        let courseStructure = CourseStructure(
            id: "123",
            graded: true,
            completion: 0,
            viewYouTubeUrl: "",
            encodedVideo: "",
            displayName: "",
            topicID: nil,
            childs: [],
            media: CourseMedia(
                image: CourseImage(
                    raw: "",
                    small: "",
                    large: ""
                )
            ),
            certificate: nil,
            org: "",
            isSelfPaced: true,
            courseProgress: nil
        )

        interactor.getCourseBlocksHandler = { _ in throw NSError(domain: "error", code: -1, userInfo: nil) }
        interactor.getCourseAssignmentBlocksHandler = { _ in courseStructure }

        let mockCourseProgress = CourseProgressDetails(
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
            enrollmentMode: "audit",
            gradingPolicy: CourseProgressGradingPolicy(
                assignmentPolicies: [],
                gradeRange: [:],
                assignmentColors: []
            ),
            hasScheduledContent: false,
            sectionScores: [],
            verificationData: nil
        )
        interactor.getCourseProgressHandler = { _ in mockCourseProgress }

        await viewModel.getCourseBlocks(courseID: "123")

        XCTAssertTrue(interactor.getCourseBlocksCallCount > 0)
        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertNil(viewModel.courseStructure)
        XCTAssertNil(viewModel.courseVideosStructure)
        XCTAssertNil(viewModel.courseHelper.courseStructure)
    }

    func testTabSelectedAnalytics() {
        let interactor = CourseInteractorProtocolMock()
        let authInteractor = AuthInteractorProtocolMock()
        let router = CourseRouterMock()
        let analytics = CourseAnalyticsMock()
        let config = ConfigMock()
        let connectivity = ConnectivityProtocolMock()

        connectivity.isInternetAvaliable = true
        connectivity.internetReachableSubject = .init(.reachable)

        let downloadManager = DownloadManagerMock()

        let viewModel = CourseContainerViewModel(
            interactor: interactor,
            authInteractor: authInteractor,
            router: router,
            analytics: analytics,
            config: config,
            connectivity: connectivity,
            manager: downloadManager,
            storage: CourseStorageMock(),
            isActive: true,
            courseStart: Date(),
            courseEnd: nil,
            enrollmentStart: nil,
            enrollmentEnd: nil,
            lastVisitedBlockID: nil,
            coreAnalytics: CoreAnalyticsMock(),
            courseHelper: courseHelperMock
        )

        viewModel.trackSelectedTab(selection: .course, courseId: "1", courseName: "name")
        XCTAssertEqual(analytics.courseOutlineCourseTabClickedCallCount, 1)

        viewModel.trackSelectedTab(selection: .discussion, courseId: "1", courseName: "name")
        XCTAssertEqual(analytics.courseOutlineDiscussionTabClickedCallCount, 1)

        viewModel.trackSelectedTab(selection: .handounds, courseId: "1", courseName: "name")
        XCTAssertEqual(analytics.courseOutlineHandoutsTabClickedCallCount, 1)
    }

    private func makeViewModel(
        manager: DownloadManagerProtocol = DownloadManagerMock(),
        interactor: CourseInteractorProtocolMock = CourseInteractorProtocolMock()
    ) -> CourseContainerViewModel {
        let connectivity = ConnectivityProtocolMock()
        connectivity.isInternetAvaliable = true
        connectivity.internetReachableSubject = .init(.reachable)
        return CourseContainerViewModel(
            interactor: interactor,
            authInteractor: AuthInteractorProtocolMock(),
            router: CourseRouterMock(),
            analytics: CourseAnalyticsMock(),
            config: ConfigMock(),
            connectivity: connectivity,
            manager: manager,
            storage: CourseStorageMock(),
            isActive: true,
            courseStart: Date(),
            courseEnd: nil,
            enrollmentStart: nil,
            enrollmentEnd: nil,
            lastVisitedBlockID: nil,
            coreAnalytics: CoreAnalyticsMock(),
            courseHelper: courseHelperMock
        )
    }

    private func block(_ id: String, _ type: BlockType, completion: Double) -> CourseBlock {
        CourseBlock(
            blockId: id,
            id: id,
            courseId: "course",
            graded: true,
            due: nil,
            completion: completion,
            type: type,
            displayName: id,
            studentUrl: "",
            webUrl: "",
            encodedVideo: nil,
            multiDevice: true,
            offlineDownload: nil
        )
    }

    private func course(withAssignment blocks: [CourseBlock]) -> CourseStructure {
        let unit = CourseVertical(
            blockId: "unit",
            id: "unit",
            courseId: "course",
            displayName: "Unit",
            type: .vertical,
            completion: 0,
            childs: blocks,
            webUrl: ""
        )
        let assignment = CourseSequential(
            blockId: "homework",
            id: "homework",
            displayName: "Homework",
            type: .sequential,
            completion: 0.75,
            childs: [unit],
            sequentialProgress: nil,
            due: nil
        )
        return CourseStructure(
            id: "course",
            graded: true,
            completion: 0,
            viewYouTubeUrl: "",
            encodedVideo: "",
            displayName: "Course",
            topicID: nil,
            childs: [
                CourseChapter(blockId: "section", id: "section", displayName: "Section", type: .chapter, childs: [assignment])
            ],
            media: CourseMedia(image: CourseImage(raw: "", small: "", large: "")),
            certificate: nil,
            org: "",
            isSelfPaced: true,
            courseProgress: nil
        )
    }

    func testOutlineInputs_withNewCompletion_doNotCompareEqual() {
        // SwiftUI redraws the outline only when its inputs compare unequal.
        let started = course(withAssignment: [block("problem", .problem, completion: 0)])
        let finished = course(withAssignment: [block("problem", .problem, completion: 1)])

        XCTAssertNotEqual(started, finished)
        XCTAssertNotEqual(started.childs[0], finished.childs[0])
        XCTAssertNotEqual(started.childs[0].childs[0], finished.childs[0].childs[0])
    }

    func testSectionIndicatorWhileDownloading_opensDownloadsListInsteadOfCancelling() async {
        let downloadManager = DownloadManagerProtocolMock()
        let viewModel = makeViewModel(manager: downloadManager)
        let section = CourseChapter(blockId: "", id: "section", displayName: "Section", type: .chapter, childs: [])

        await viewModel.onDownloadViewTap(chapter: section, state: .downloading)

        XCTAssertTrue(viewModel.isDownloadsListPresented)
        XCTAssertEqual(downloadManager.cancelDownloadingCallCount, 0)
    }

    func testAssignmentWithEveryGradedProblemAttempted_isCompleted_evenWithAnUnwatchedVideo() {
        let viewModel = makeViewModel()
        viewModel.courseStructure = course(withAssignment: [
            block("setup", .html, completion: 1),
            block("video", .video, completion: 0),
            block("problem1", .problem, completion: 1),
            block("problem2", .problem, completion: 1)
        ])

        XCTAssertEqual(viewModel.getSequentialAssignmentStatus(for: "homework"), .completed)
    }

    func testAssignmentWithAnUnattemptedGradedProblem_isNotCompleted() {
        let viewModel = makeViewModel()
        viewModel.courseStructure = course(withAssignment: [
            block("problem1", .problem, completion: 1),
            block("problem2", .problem, completion: 0)
        ])

        XCTAssertEqual(viewModel.getSequentialAssignmentStatus(for: "homework"), .incomplete)
    }

    func testCourseStructure_whenTheNetworkFails_opensTheSavedCopy() async throws {
        let interactor = CourseInteractorProtocolMock()
        let saved = course(withAssignment: [block("problem", .problem, completion: 0)])
        interactor.getCourseBlocksHandler = { _ in throw AFError.sessionTaskFailed(error: URLError(.timedOut)) }
        interactor.getLoadedCourseBlocksHandler = { _ in saved }
        let viewModel = makeViewModel(interactor: interactor)

        let structure = try await viewModel.getCourseStructure(courseID: "course")

        XCTAssertEqual(structure?.id, saved.id)
        XCTAssertEqual(interactor.getLoadedCourseBlocksCallCount, 1)
    }
}

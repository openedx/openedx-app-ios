//
//  DownloadsTests.swift
//  DownloadsTests
//
//  Created by Ivan Stepanok on 4.02.2025.
//

import XCTest
import Combine
import OEXFoundation
@testable import Downloads
@testable import Core

@MainActor
final class DownloadsTests: XCTestCase {

    var downloadsInteractor: DownloadsInteractorProtocolMock!
    var courseManager: CourseStructureManagerProtocolMock!
    var downloadManager: DownloadManagerProtocolMock!
    var connectivity: ConnectivityProtocolMock!
    var downloadsHelper: DownloadsHelperProtocolMock!
    var router: DownloadsRouterMock!
    var viewModel: AppDownloadsViewModel!
    var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        downloadsInteractor = DownloadsInteractorProtocolMock()
        courseManager = CourseStructureManagerProtocolMock()
        downloadManager = DownloadManagerProtocolMock()
        connectivity = ConnectivityProtocolMock()
        downloadsHelper = DownloadsHelperProtocolMock()
        router = DownloadsRouterMock()
        cancellables = Set<AnyCancellable>()

        connectivity.isInternetAvaliable = true
        connectivity.isMobileData = false
        connectivity.internetReachableSubject = .init(.reachable)
        downloadManager.eventPublisherHandler = {
            PassthroughSubject<DownloadManagerEvent, Never>().eraseToAnyPublisher()
        }

        downloadsHelper.calculateDownloadProgressHandler = { _ in (0, 0) }
        downloadsHelper.isDownloadingHandler = { _ in false }
        downloadsHelper.isFullyDownloadedHandler = { _ in false }
        downloadsHelper.getDownloadTasksForCourseHandler = { _ in [] }

        let mockCourseStructure = createMockCourseStructure()
        courseManager.getLoadedCourseBlocksHandler = { _ in mockCourseStructure }
        courseManager.getCourseBlocksHandler = { _ in mockCourseStructure }
        downloadManager.getFreeDiskSpaceHandler = { 1000000000 } // 1GB free space
        downloadManager.isLargeVideosSizeHandler = { _ in false }

        viewModel = AppDownloadsViewModel(
            interactor: DownloadsInteractor(repository: DownloadsRepositoryMock()),
            courseManager: courseManager,
            downloadManager: downloadManager,
            connectivity: connectivity,
            downloadsHelper: downloadsHelper,
            router: router,
            storage: DownloadsStorageMock(),
            analytics: DownloadsAnalyticsMock()
        )
    }

    override func tearDownWithError() throws {
        downloadsInteractor = nil
        courseManager = nil
        downloadManager = nil
        connectivity = nil
        downloadsHelper = nil
        router = nil
        viewModel = nil
        cancellables = nil
    }

    // MARK: - Test Getting Download Courses

    func testGetDownloadCourses_WhenOnline_ShouldFetchCoursesFromNetwork() async throws {
        // Given
        let expectedCourses = [
            createMockDownloadCoursePreview(id: "course0"),
            createMockDownloadCoursePreview(id: "course1")
        ]

        let analytics = DownloadsAnalyticsMock()

        connectivity.isInternetAvaliable = true
        downloadsInteractor.getDownloadCoursesHandler = { expectedCourses }

        viewModel = AppDownloadsViewModel(
            interactor: downloadsInteractor,
            courseManager: courseManager,
            downloadManager: downloadManager,
            connectivity: connectivity,
            downloadsHelper: downloadsHelper,
            router: router,
            storage: DownloadsStorageMock(),
            analytics: analytics
        )

        // When
        await viewModel.getDownloadCourses()

        // Then
        XCTAssertEqual(downloadsInteractor.getDownloadCoursesCallCount, 1)
        XCTAssertEqual(analytics.downloadsScreenViewedCallCount, 1)
        XCTAssertEqual(viewModel.courses.count, 2)
        XCTAssertEqual(viewModel.courses[0].id, "course0")
        XCTAssertEqual(viewModel.courses[1].id, "course1")
    }

    func testRefreshDownloadStates_ShouldUpdateDownloadStates() async {
        // Given
        let courses = [
            createMockDownloadCoursePreview(id: "course1"),
            createMockDownloadCoursePreview(id: "course2")
        ]

        let downloadsInteractor = DownloadsInteractorProtocolMock()
        downloadsInteractor.getDownloadCoursesHandler = { courses }
        downloadsInteractor.getDownloadCoursesOfflineHandler = { courses }

        let task1 = createMockDownloadTask(
            courseId: "course1",
            state: .finished,
            fileSize: 100,
            actualSize: 100
        )

        // Setup mocks with specific values
        downloadsHelper.calculateDownloadProgressHandler = { courseID in
            if courseID == "course1" {
                return (100, 100)
            } else {
                return (50, 100)
            }
        }
        downloadsHelper.isDownloadingHandler = { courseID in
            return courseID == "course2"
        }
        downloadsHelper.isFullyDownloadedHandler = { courseID in
            return courseID == "course1"
        }
        downloadsHelper.getDownloadTasksForCourseHandler = { courseID in
            return courseID == "course1" ? [task1] : []
        }
        courseManager.getLoadedCourseBlocksHandler = { _ in throw NoCachedDataError() }

        viewModel = AppDownloadsViewModel(
            interactor: downloadsInteractor,
            courseManager: courseManager,
            downloadManager: downloadManager,
            connectivity: connectivity,
            downloadsHelper: downloadsHelper,
            router: router,
            storage: DownloadsStorageMock(),
            analytics: DownloadsAnalyticsMock()
        )

        viewModel.courses = courses

        await viewModel.refreshDownloadStates()

        // Then
        XCTAssertGreaterThanOrEqual(downloadsHelper.calculateDownloadProgressCallCount, 2)

        XCTAssertEqual(viewModel.downloadedSizes["course1"], 100)
        XCTAssertEqual(viewModel.downloadStates["course2"], .inProgress)
    }

    // MARK: - Test Download Course

    func testDownloadCourse_WhenCourseStructureAvailable_ShouldAddToDownloadQueue() async throws {
        // Given
        let courseID = "course1"
        let courseStructure = createMockCourseStructure(withDownloadableBlocks: true)
        let analytics = DownloadsAnalyticsMock()
        let expectation = XCTestExpectation(description: "Download course completed")

        courseManager.getLoadedCourseBlocksHandler = { _ in courseStructure }
        downloadManager.getFreeDiskSpaceHandler = { 1000000000 } // 1GB free space
        downloadManager.isLargeVideosSizeHandler = { _ in false }
        downloadManager.addToDownloadQueueHandler = { _ in
            expectation.fulfill()
        }

        viewModel = AppDownloadsViewModel(
            interactor: DownloadsInteractor(repository: DownloadsRepositoryMock()),
            courseManager: courseManager,
            downloadManager: downloadManager,
            connectivity: connectivity,
            downloadsHelper: downloadsHelper,
            router: router,
            storage: DownloadsStorageMock(),
            analytics: analytics
        )

        // When
        await viewModel.downloadCourse(courseID: courseID)
        await fulfillment(of: [expectation])

        // Then
        XCTAssertEqual(downloadManager.addToDownloadQueueCallCount, 1)
        XCTAssertEqual(analytics.downloadCourseClickedCallCount, 1)
        XCTAssertEqual(analytics.downloadStartedCallCount, 1)
    }

    func testDownloadCourse_WhenNoCachedData_ShouldFetchFromNetwork() async throws {
        // Given
        let courseID = "course1"
        let courseStructure = createMockCourseStructure(withDownloadableBlocks: true)
        let analytics = DownloadsAnalyticsMock()
        let expectation = XCTestExpectation(description: "Download course completed")

        courseManager.getLoadedCourseBlocksHandler = { _ in throw NoCachedDataError() }
        courseManager.getCourseBlocksHandler = { _ in courseStructure }
        downloadManager.getFreeDiskSpaceHandler = { 1000000000 } // 1GB free space
        downloadManager.isLargeVideosSizeHandler = { _ in false }
        downloadManager.addToDownloadQueueHandler = { _ in
            expectation.fulfill()
        }

        viewModel = AppDownloadsViewModel(
            interactor: DownloadsInteractor(repository: DownloadsRepositoryMock()),
            courseManager: courseManager,
            downloadManager: downloadManager,
            connectivity: connectivity,
            downloadsHelper: downloadsHelper,
            router: router,
            storage: DownloadsStorageMock(),
            analytics: analytics
        )

        // When
        await viewModel.downloadCourse(courseID: courseID)
        await fulfillment(of: [expectation])

        // Then
        XCTAssertEqual(courseManager.getCourseBlocksCallCount, 1)
        XCTAssertEqual(downloadManager.addToDownloadQueueCallCount, 1)
        XCTAssertEqual(analytics.downloadCourseClickedCallCount, 1)
        XCTAssertEqual(analytics.downloadStartedCallCount, 1)
        XCTAssertEqual(viewModel.downloadStates[courseID], .inProgress)
    }

    func testDownloadCourse_WhenNoWiFi_ShouldSetErrorMessage() async throws {
        // Given
        let courseID = "course1"
        let courseStructure = createMockCourseStructure(withDownloadableBlocks: true)
        let analytics = DownloadsAnalyticsMock()
        let expectation = XCTestExpectation(description: "Download course error")

        courseManager.getLoadedCourseBlocksHandler = { _ in courseStructure }
        downloadManager.addToDownloadQueueHandler = { _ in throw NoWiFiError() }
        downloadManager.getFreeDiskSpaceHandler = { 1000000000 } // 1GB free space
        downloadManager.isLargeVideosSizeHandler = { _ in false }
        analytics.downloadErrorHandler = { _, _, _ in
            expectation.fulfill()
        }

        viewModel = AppDownloadsViewModel(
            interactor: DownloadsInteractor(repository: DownloadsRepositoryMock()),
            courseManager: courseManager,
            downloadManager: downloadManager,
            connectivity: connectivity,
            downloadsHelper: downloadsHelper,
            router: router,
            storage: DownloadsStorageMock(),
            analytics: analytics
        )

        // When
        await viewModel.downloadCourse(courseID: courseID)
        await fulfillment(of: [expectation])

        // Then
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.wifi)
        XCTAssertEqual(analytics.downloadCourseClickedCallCount, 1)
        XCTAssertEqual(analytics.downloadErrorCallCount, 1)
    }

    // MARK: - Test Cancel Download

    func testCancelDownload_ShouldCancelAllTasksForCourse() async throws {
        // Given
        let courseID = "course1"
        let currentTask = createMockDownloadTask(courseId: courseID)
        let secondTask = createMockDownloadTask(id: "task2", courseId: courseID, state: .waiting)
        let tasks = [secondTask] // Only include the second task, not the current task
        let analytics = DownloadsAnalyticsMock()

        downloadManager.getCurrentDownloadTaskHandler = { currentTask }
        downloadManager.getDownloadTasksForCourseHandler = { _ in tasks }
        downloadManager.cancelDownloadingTaskHandler = { _ in }

        viewModel = AppDownloadsViewModel(
            interactor: DownloadsInteractor(repository: DownloadsRepositoryMock()),
            courseManager: courseManager,
            downloadManager: downloadManager,
            connectivity: connectivity,
            downloadsHelper: downloadsHelper,
            router: router,
            storage: DownloadsStorageMock(),
            analytics: analytics
        )

        // When
        await viewModel.cancelDownload(courseID: courseID)

        // Then
        XCTAssertEqual(downloadManager.getCurrentDownloadTaskCallCount, 1)
        XCTAssertEqual(downloadManager.getDownloadTasksForCourseCallCount, 1)
        XCTAssertEqual(downloadManager.cancelDownloadingTaskCallCount, 2)
        XCTAssertEqual(analytics.cancelDownloadClickedCallCount, 1)
        XCTAssertEqual(analytics.downloadCancelledCallCount, 1)
    }

    // MARK: - Test Remove Download

    func testRemoveDownload_ShouldDeleteFilesForCourse() async throws {
        // Given
        let courseID = "course1"
        let courseStructure = createMockCourseStructure(withDownloadableBlocks: true)
        let expectation = XCTestExpectation(description: "Remove download completed")

        courseManager.getLoadedCourseBlocksHandler = { _ in courseStructure }

        downloadManager.deleteHandler = { _, _ in
            expectation.fulfill()
        }

        // When
        await viewModel.removeDownload(courseID: courseID, skipConfirmation: true)
        await fulfillment(of: [expectation])

        // Then
        XCTAssertGreaterThanOrEqual(courseManager.getLoadedCourseBlocksCallCount, 1)
        XCTAssertEqual(downloadManager.deleteCallCount, 1)
    }

    func testDownloadEvents_FinishedEvent_ShouldMarkAsFinished() async throws {
        // Given
        let courseID = "course1"
        let blockID = "block123"

        let task = createMockDownloadTask(
            id: "task1",
            blockId: blockID,
            courseId: courseID,
            state: .finished,
            fileSize: 100,
            actualSize: 100
        )

        let subject = PassthroughSubject<DownloadManagerEvent, Never>()
        let analytics = DownloadsAnalyticsMock()
        let expectation = XCTestExpectation(description: "Download finished event processed")
        let mockCourse = createMockDownloadCoursePreview(id: courseID, totalSize: 100)
        let courseStructure = createMockCourseStructure(withDownloadableBlocks: true)

        downloadManager.eventPublisherHandler = { subject.eraseToAnyPublisher() }

        downloadsHelper.calculateDownloadProgressHandler = { _ in (100, 100) }
        downloadsHelper.isFullyDownloadedHandler = { _ in true }
        courseManager.getLoadedCourseBlocksHandler = { _ in courseStructure }
        downloadsHelper.getDownloadTasksForCourseHandler = { _ in [task] }

        var downloadCompletedCalled = false
        var downloadCompletedSize: Int64 = 0

        analytics.downloadCompletedHandler = { _, _, size in
            downloadCompletedCalled = true
            downloadCompletedSize = size
            expectation.fulfill()
        }

        viewModel = AppDownloadsViewModel(
            interactor: DownloadsInteractor(repository: DownloadsRepositoryMock()),
            courseManager: courseManager,
            downloadManager: downloadManager,
            connectivity: connectivity,
            downloadsHelper: downloadsHelper,
            router: router,
            storage: DownloadsStorageMock(),
            analytics: analytics
        )

        viewModel.courses = [mockCourse]
        viewModel.downloadStates[courseID] = .inProgress

        // When
        subject.send(.finished(task))
        await fulfillment(of: [expectation])

        // Then
        XCTAssertGreaterThanOrEqual(downloadsHelper.getDownloadTasksForCourseCallCount, 1)
        XCTAssertGreaterThanOrEqual(downloadsHelper.isFullyDownloadedCallCount, 1)

        XCTAssertTrue(downloadCompletedCalled, "downloadCompleted should have been called")
        XCTAssertEqual(downloadCompletedSize, 100, "downloadCompleted should have been called with size 100")

        XCTAssertEqual(viewModel.downloadedSizes[courseID], 100)
        XCTAssertEqual(viewModel.downloadStates[courseID], .finished)
    }

    // MARK: - Helper Methods

    private func createMockDownloadCoursePreview(
        id: String = "test123",
        name: String = "Test Course",
        image: String? = "https://test.com/image.jpg",
        totalSize: Int64 = 1000
    ) -> DownloadCoursePreview {
        DownloadCoursePreview(
            id: id,
            name: name,
            image: image,
            totalSize: totalSize
        )
    }

    private func createMockDownloadTask(
        id: String = "task1",
        blockId: String = "block123",
        courseId: String = "course1",
        state: DownloadState = .inProgress,
        fileSize: Int = 1000,
        actualSize: Int = 500
    ) -> DownloadDataTask {
        DownloadDataTask(
            id: id,
            blockId: blockId,
            courseId: courseId,
            userId: 1,
            url: "https://test.com/video.mp4",
            fileName: "video.mp4",
            displayName: "Test Video",
            progress: 0.5,
            resumeData: nil,
            state: state,
            type: .video,
            fileSize: fileSize,
            lastModified: "2024-01-01",
            actualSize: actualSize
        )
    }

    private func createMockCourseStructure(withDownloadableBlocks: Bool = false) -> CourseStructure {
        let block = CourseBlock(
            blockId: "block123",
            id: "block123",
            courseId: "course1",
            topicId: nil,
            graded: false,
            due: nil,
            completion: 0.0,
            type: .video,
            displayName: "Test Video",
            studentUrl: "https://test.com",
            webUrl: "https://test.com",
            subtitles: nil,
            encodedVideo: withDownloadableBlocks ? CourseBlockEncodedVideo(
                fallback: CourseBlockVideo(
                    url: "https://test.com/video.mp4",
                    fileSize: 100,
                    streamPriority: 1,
                    type: .desktopMP4
                ),
                youtube: nil,
                desktopMP4: nil,
                mobileHigh: nil,
                mobileLow: nil,
                hls: nil
            ) : nil,
            multiDevice: true,
            offlineDownload: nil
        )

        let vertical = CourseVertical(
            blockId: "vertical1",
            id: "vertical1",
            courseId: "course1",
            displayName: "Test Vertical",
            type: .vertical,
            completion: 0.0,
            childs: [block],
            webUrl: "https://test.com"
        )

        let sequential = CourseSequential(
            blockId: "sequential1",
            id: "sequential1",
            displayName: "Test Sequential",
            type: .sequential,
            completion: 0.0,
            childs: [vertical],
            sequentialProgress: nil,
            due: nil
        )

        let chapter = CourseChapter(
            blockId: "chapter1",
            id: "chapter1",
            displayName: "Test Chapter",
            type: .chapter,
            childs: [sequential]
        )

        return CourseStructure(
            id: "course1",
            graded: false,
            completion: 0.0,
            viewYouTubeUrl: "",
            encodedVideo: "",
            displayName: "Test Course",
            topicID: nil,
            childs: [chapter],
            media: CourseMedia(
                image: CourseImage(
                    raw: "https://test.com/image.jpg",
                    small: "https://test.com/image_small.jpg",
                    large: "https://test.com/image_large.jpg"
                )
            ),
            certificate: nil,
            org: "Test Org",
            isSelfPaced: true,
            courseProgress: nil
        )
    }
}

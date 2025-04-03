//
//  DownloadsTests.swift
//  DownloadsTests
//
//  Created by Ivan Stepanok on 4.02.2025.
//

import XCTest
import Combine
import SwiftyMocky
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
        
        Given(connectivity, .isInternetAvaliable(getter: true))
        Given(connectivity, .isMobileData(getter: false))
        Given(connectivity, .internetReachableSubject(getter: .init(.reachable)))
        Given(downloadManager, .eventPublisher(willReturn: PassthroughSubject<DownloadManagerEvent, Never>().eraseToAnyPublisher()))
        
        Given(downloadsHelper, .calculateDownloadProgress(courseID: .any, willReturn: (0, 0)))
        Given(downloadsHelper, .isDownloading(courseID: .any, willReturn: false))
        Given(downloadsHelper, .isFullyDownloaded(courseID: .any, willReturn: false))
        Given(downloadsHelper, .getDownloadTasksForCourse(courseID: .any, willReturn: []))
        Given(courseManager, .getLoadedCourseBlocks(courseID: .any, willReturn: createMockCourseStructure()))
        Given(courseManager, .getCourseBlocks(courseID: .any, willReturn: createMockCourseStructure()))
        Given(downloadManager, .getFreeDiskSpace(willReturn: 1000000000)) // 1GB free space
        Given(downloadManager, .isLargeVideosSize(blocks: .any, willReturn: false))
        
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
        
        Given(connectivity, .isInternetAvaliable(getter: true))
        Given(downloadsInteractor, .getDownloadCourses(willReturn: expectedCourses))
        
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
        Verify(downloadsInteractor, 1, .getDownloadCourses())
        Verify(analytics, 1, .downloadsScreenViewed())
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
        Given(downloadsInteractor, .getDownloadCourses(willReturn: courses))
        Given(downloadsInteractor, .getDownloadCoursesOffline(willReturn: courses))
        
        let task1 = createMockDownloadTask(
            courseId: "course1",
            state: .finished,
            fileSize: 100,
            actualSize: 100
        )
        
        // Setup mocks with specific values
        Given(downloadsHelper, .calculateDownloadProgress(courseID: .value("course1"), willReturn: (100, 100)))
        Given(downloadsHelper, .isDownloading(courseID: .value("course1"), willReturn: false))
        Given(downloadsHelper, .isFullyDownloaded(courseID: .value("course1"), willReturn: true))
        Given(downloadsHelper, .getDownloadTasksForCourse(courseID: .value("course1"), willReturn: [task1]))
        
        Given(downloadsHelper, .calculateDownloadProgress(courseID: .value("course2"), willReturn: (50, 100)))
        Given(downloadsHelper, .isDownloading(courseID: .value("course2"), willReturn: true))
        Given(downloadsHelper, .isFullyDownloaded(courseID: .value("course2"), willReturn: false))
        Given(courseManager, .getLoadedCourseBlocks(courseID: .any, willThrow: NoCachedDataError()))
        
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
        Verify(downloadsHelper, .atLeastOnce, .calculateDownloadProgress(courseID: .value("course1")))
        Verify(downloadsHelper, .atLeastOnce, .calculateDownloadProgress(courseID: .value("course2")))
        
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
        Given(courseManager, .getLoadedCourseBlocks(courseID: .value(courseID), willReturn: courseStructure))
        Given(downloadManager, .getFreeDiskSpace(willReturn: 1000000000)) // 1GB free space
        Given(downloadManager, .isLargeVideosSize(blocks: .any, willReturn: false))
        Perform(downloadManager, .addToDownloadQueue(blocks: .any, perform: { _ in
            expectation.fulfill()
        }))
        
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
        Verify(downloadManager, 1, .addToDownloadQueue(blocks: .any))
        Verify(analytics, 1, .downloadCourseClicked(courseId: .value(courseID), courseName: .any))
        Verify(analytics, 1, .downloadStarted(courseId: .value(courseID), courseName: .any, downloadSize: .any))
    }
    
    func testDownloadCourse_WhenNoCachedData_ShouldFetchFromNetwork() async throws {
        // Given
        let courseID = "course1"
        let courseStructure = createMockCourseStructure(withDownloadableBlocks: true)
        let analytics = DownloadsAnalyticsMock()
        let expectation = XCTestExpectation(description: "Download course completed")
        
        Given(courseManager, .getLoadedCourseBlocks(courseID: .value(courseID), willThrow: NoCachedDataError()))
        Given(courseManager, .getCourseBlocks(courseID: .value(courseID), willReturn: courseStructure))
        Given(downloadManager, .getFreeDiskSpace(willReturn: 1000000000)) // 1GB free space
        Given(downloadManager, .isLargeVideosSize(blocks: .any, willReturn: false))
        Perform(downloadManager, .addToDownloadQueue(blocks: .any, perform: { _ in
            expectation.fulfill()
        }))
        
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
        Verify(courseManager, 1, .getCourseBlocks(courseID: .value(courseID)))
        Verify(downloadManager, 1, .addToDownloadQueue(blocks: .any))
        Verify(analytics, 1, .downloadCourseClicked(courseId: .value(courseID), courseName: .any))
        Verify(analytics, 1, .downloadStarted(courseId: .value(courseID), courseName: .any, downloadSize: .any))
        XCTAssertEqual(viewModel.downloadStates[courseID], .inProgress)
    }
    
    func testDownloadCourse_WhenNoWiFi_ShouldSetErrorMessage() async throws {
        // Given
        let courseID = "course1"
        let courseStructure = createMockCourseStructure(withDownloadableBlocks: true)
        let analytics = DownloadsAnalyticsMock()
        let expectation = XCTestExpectation(description: "Download course error")
        
        Given(courseManager, .getLoadedCourseBlocks(courseID: .value(courseID), willReturn: courseStructure))
        Given(downloadManager, .addToDownloadQueue(blocks: .any, willThrow: NoWiFiError()))
        Given(downloadManager, .getFreeDiskSpace(willReturn: 1000000000)) // 1GB free space
        Given(downloadManager, .isLargeVideosSize(blocks: .any, willReturn: false))
        Perform(analytics, .downloadError(courseId: .any, courseName: .any, errorType: .any, perform: { _, _, _ in
            expectation.fulfill()
        }))
        
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
        Verify(analytics, 1, .downloadCourseClicked(courseId: .value(courseID), courseName: .any))
        Verify(analytics, 1, .downloadError(courseId: .value(courseID), courseName: .any, errorType: .value("wifi_required")))
    }
    
    // MARK: - Test Cancel Download
    
    func testCancelDownload_ShouldCancelAllTasksForCourse() async throws {
        // Given
        let courseID = "course1"
        let currentTask = createMockDownloadTask(courseId: courseID)
        let secondTask = createMockDownloadTask(id: "task2", courseId: courseID, state: .waiting)
        let tasks = [secondTask] // Only include the second task, not the current task
        let analytics = DownloadsAnalyticsMock()
        
        Given(downloadManager, .getCurrentDownloadTask(willReturn: currentTask))
        Given(downloadManager, .getDownloadTasksForCourse(.value(courseID), willReturn: tasks))
        
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
        Verify(downloadManager, 1, .getCurrentDownloadTask())
        Verify(downloadManager, 1, .getDownloadTasksForCourse(.value(courseID)))
        Verify(downloadManager, 1, .cancelDownloading(task: .value(currentTask)))
        Verify(downloadManager, 1, .cancelDownloading(task: .value(secondTask)))
        Verify(analytics, 1, .cancelDownloadClicked(courseId: .value(courseID), courseName: .any))
        Verify(analytics, 1, .downloadCancelled(courseId: .value(courseID), courseName: .any))
    }
    
    // MARK: - Test Remove Download
    
    func testRemoveDownload_ShouldDeleteFilesForCourse() async throws {
        // Given
        let courseID = "course1"
        let courseStructure = createMockCourseStructure(withDownloadableBlocks: true)
        let expectation = XCTestExpectation(description: "Remove download completed")
        
        Given(courseManager, .getLoadedCourseBlocks(courseID: .value(courseID), willReturn: courseStructure))
        
        Perform(downloadManager, .delete(blocks: .any, courseId: .any, perform: { _, _ in
            expectation.fulfill()
        }))
        
        // When
        await viewModel.removeDownload(courseID: courseID, skipConfirmation: true)
        await fulfillment(of: [expectation])
        
        // Then
        Verify(courseManager, 1, .getLoadedCourseBlocks(courseID: .value(courseID)))
        Verify(downloadManager, 1, .delete(blocks: .any, courseId: .value(courseID)))
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
        
        Given(downloadManager, .eventPublisher(willReturn: subject.eraseToAnyPublisher()))
        
        Given(downloadsHelper, .calculateDownloadProgress(courseID: .value(courseID), willReturn: (100, 100)))
        Given(downloadsHelper, .isFullyDownloaded(courseID: .value(courseID), willReturn: true))
        Given(courseManager, .getLoadedCourseBlocks(courseID: .value(courseID), willReturn: courseStructure))
        Given(downloadsHelper, .getDownloadTasksForCourse(courseID: .value(courseID), willReturn: [task]))
        
        var downloadCompletedCalled = false
        var downloadCompletedSize: Int64 = 0
        
        Perform(analytics, .downloadCompleted(courseId: .any, courseName: .any, downloadSize: .any, perform: { id, name, size in
            downloadCompletedCalled = true
            downloadCompletedSize = size
            expectation.fulfill()
        }))
        
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
        Verify(downloadsHelper, 1, .getDownloadTasksForCourse(courseID: .value(courseID)))
        Verify(downloadsHelper, 1, .isFullyDownloaded(courseID: .value(courseID)))
        
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

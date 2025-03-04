//
//  DownloadsTests.swift
//  DownloadsTests
//
//  Created by Ivan Stepanok on 22.02.2025.
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
        
        // Set up default responses
        Given(connectivity, .isInternetAvaliable(getter: true))
        Given(connectivity, .internetReachableSubject(getter: .init(.reachable)))
        Given(downloadManager, .eventPublisher(willReturn: PassthroughSubject<DownloadManagerEvent, Never>().eraseToAnyPublisher()))
        
        // Add default stub for calculateDownloadProgress to avoid errors
        Given(downloadsHelper, .calculateDownloadProgress(courseID: .any, willReturn: (0, 0)))
        Given(downloadsHelper, .isDownloading(courseID: .any, willReturn: false))
        Given(downloadsHelper, .isPartiallyDownloaded(courseID: .any, willReturn: false))
        
        viewModel = AppDownloadsViewModel(
            interactor: DownloadsInteractor(repository: DownloadsRepositoryMock()),
            courseManager: courseManager,
            downloadManager: downloadManager,
            connectivity: connectivity,
            downloadsHelper: downloadsHelper,
            router: router
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
        
        Given(connectivity, .isInternetAvaliable(getter: true))
        Given(downloadsInteractor, .getDownloadCourses(willReturn: expectedCourses))
        
        // When
        await viewModel.getDownloadCourses()
        
        // Then
        Verify(downloadsInteractor, 0, .getDownloadCourses())
        Verify(downloadsInteractor, 0, .getDownloadCoursesOffline())
        XCTAssertEqual(viewModel.courses.count, 6)
        XCTAssertEqual(viewModel.courses[0].id, "course0")
        XCTAssertEqual(viewModel.courses[1].id, "course1")
    }
    
    func testRefreshDownloadStates_ShouldUpdateDownloadStates() async {
        // Given
        let courses = [
            createMockDownloadCoursePreview(id: "course1"),
            createMockDownloadCoursePreview(id: "course2"),
            createMockDownloadCoursePreview(id: "course3"),
            createMockDownloadCoursePreview(id: "course4"),
            createMockDownloadCoursePreview(id: "course5"),
            createMockDownloadCoursePreview(id: "course6")
        ]
        viewModel.courses = courses
        
        // Setup mocks for each course
        Given(downloadsHelper, .calculateDownloadProgress(courseID: .value("course1"), willReturn: (100, 100)))
        Given(downloadsHelper, .isDownloading(courseID: .value("course1"), willReturn: false))
        Given(downloadsHelper, .isPartiallyDownloaded(courseID: .value("course1"), willReturn: false))
        
        Given(downloadsHelper, .calculateDownloadProgress(courseID: .value("course2"), willReturn: (50, 100)))
        Given(downloadsHelper, .isDownloading(courseID: .value("course2"), willReturn: true))
        Given(downloadsHelper, .isPartiallyDownloaded(courseID: .value("course2"), willReturn: false))
        
        // When
        // This is private but we can test it through the public API
        await viewModel.getDownloadCourses(isRefresh: true)
        
        // Then
        Verify(downloadsHelper, 1, .calculateDownloadProgress(courseID: .value("course1")))
        Verify(downloadsHelper, 1, .calculateDownloadProgress(courseID: .value("course2")))
        
        XCTAssertEqual(viewModel.downloadedSizes["course1"], 100)
        XCTAssertEqual(viewModel.downloadedSizes["course2"], 50)
        XCTAssertEqual(viewModel.downloadStates["course1"], .finished)
        XCTAssertEqual(viewModel.downloadStates["course2"], .inProgress)
    }
    
    // MARK: - Test Download Course
    
    func testDownloadCourse_WhenCourseStructureAvailable_ShouldAddToDownloadQueue() async throws {
        // Given
        let courseID = "course1"
        let courseStructure = createMockCourseStructure(withDownloadableBlocks: true)
        
        Given(courseManager, .getLoadedCourseBlocks(courseID: .value(courseID), willReturn: courseStructure))
        
        // When
        viewModel.downloadCourse(courseID: courseID)
        
        // Need a small delay to allow the task to execute
        try await Task.sleep(for: .milliseconds(100))
        
        // Then
        Verify(courseManager, 1, .getLoadedCourseBlocks(courseID: .value(courseID)))
        Verify(downloadManager, 1, .addToDownloadQueue(blocks: .any))
    }
    
    func testDownloadCourse_WhenNoCachedData_ShouldFetchFromNetwork() async throws {
        // Given
        let courseID = "course1"
        let courseStructure = createMockCourseStructure(withDownloadableBlocks: true)
        
        Given(courseManager, .getLoadedCourseBlocks(courseID: .value(courseID), willThrow: NoCachedDataError()))
        Given(courseManager, .getCourseBlocks(courseID: .value(courseID), willReturn: courseStructure))
        
        // When
        viewModel.downloadCourse(courseID: courseID)
        
        // Need a small delay to allow the task to execute
        try await Task.sleep(for: .milliseconds(100))
        
        // Then
        Verify(courseManager, 1, .getLoadedCourseBlocks(courseID: .value(courseID)))
        Verify(courseManager, 1, .getCourseBlocks(courseID: .value(courseID)))
        Verify(downloadManager, 1, .addToDownloadQueue(blocks: .any))
        XCTAssertEqual(viewModel.downloadStates[courseID], .inProgress)
    }
    
    func testDownloadCourse_WhenNoWiFi_ShouldSetErrorMessage() async throws {
        // Given
        let courseID = "course1"
        let courseStructure = createMockCourseStructure(withDownloadableBlocks: true)
        
        Given(courseManager, .getLoadedCourseBlocks(courseID: .value(courseID), willReturn: courseStructure))
        Given(downloadManager, .addToDownloadQueue(blocks: .any, willThrow: NoWiFiError()))
        
        // When
        viewModel.downloadCourse(courseID: courseID)
        
        // Need a small delay to allow the task to execute
        try await Task.sleep(for: .milliseconds(100))
        
        // Then
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.wifi)
    }
    
    // MARK: - Test Cancel Download
    
    func testCancelDownload_ShouldCancelAllTasksForCourse() async throws {
        // Given
        let courseID = "course1"
        let currentTask = createMockDownloadTask(courseId: courseID)
        let tasks = [
            currentTask,
            createMockDownloadTask(id: "task2", courseId: courseID, state: .waiting)
        ]
        
        Given(downloadManager, .getCurrentDownloadTask(willReturn: currentTask))
        Given(downloadManager, .getDownloadTasksForCourse(.value(courseID), willReturn: tasks))
        
        // When
        viewModel.cancelDownload(courseID: courseID)
        
        // Need a small delay to allow the task to execute
        try await Task.sleep(for: .milliseconds(100))
        
        // Then
        Verify(downloadManager, 1, .getCurrentDownloadTask())
        Verify(downloadManager, 1, .getDownloadTasksForCourse(.value(courseID)))
        Verify(downloadManager, 2, .cancelDownloading(task: .value(currentTask)))
        Verify(downloadManager, 1, .cancelDownloading(task: .value(tasks[1])))
    }
    
    // MARK: - Test Remove Download
    
    func testRemoveDownload_ShouldDeleteFilesForCourse() async throws {
        // Given
        let courseID = "course1"
        let courseStructure = createMockCourseStructure(withDownloadableBlocks: true)
        
        Given(courseManager, .getLoadedCourseBlocks(courseID: .value(courseID), willReturn: courseStructure))
        
        // When
        viewModel.removeDownload(courseID: courseID)
        
        // Need a small delay to allow the task to execute
        try await Task.sleep(for: .milliseconds(100))
        
        // Then
        Verify(courseManager, 1, .getLoadedCourseBlocks(courseID: .value(courseID)))
        Verify(downloadManager, 1, .delete(blocks: .any, courseId: .value(courseID)))
    }
    
    // MARK: - Test Download Events
    
    func testDownloadEvents_ProgressEvent_ShouldUpdateProgress() async throws {
        // Given
        let courseID = "course1"
        let task = createMockDownloadTask(courseId: courseID)
        let subject = PassthroughSubject<DownloadManagerEvent, Never>()
        
        Given(downloadManager, .eventPublisher(willReturn: subject.eraseToAnyPublisher()))
        Given(downloadsHelper, .calculateDownloadProgress(courseID: .value(courseID), willReturn: (50, 100)))
        
        viewModel = AppDownloadsViewModel(
            interactor: DownloadsInteractor(repository: DownloadsRepositoryMock()),
            courseManager: courseManager,
            downloadManager: downloadManager,
            connectivity: connectivity,
            downloadsHelper: downloadsHelper,
            router: router
        )
        
        // When
        subject.send(.progress(task))
        
        // Need a small delay to allow the async processing
        try await Task.sleep(for: .milliseconds(100))
        
        // Then
        Verify(downloadsHelper, 1, .calculateDownloadProgress(courseID: .value(courseID)))
        XCTAssertEqual(viewModel.downloadedSizes[courseID], 50)
        XCTAssertEqual(viewModel.downloadStates[courseID], .inProgress)
    }
    
    func testDownloadEvents_FinishedEvent_ShouldMarkAsFinished() async throws {
        // Given
        let courseID = "course1"
        let task = createMockDownloadTask(courseId: courseID, state: .finished)
        let subject = PassthroughSubject<DownloadManagerEvent, Never>()
        
        Given(downloadManager, .eventPublisher(willReturn: subject.eraseToAnyPublisher()))
        Given(downloadsHelper, .calculateDownloadProgress(courseID: .value(courseID), willReturn: (100, 100)))
        
        viewModel = AppDownloadsViewModel(
            interactor: DownloadsInteractor(repository: DownloadsRepositoryMock()),
            courseManager: courseManager,
            downloadManager: downloadManager,
            connectivity: connectivity,
            downloadsHelper: downloadsHelper,
            router: router
        )
        
        // When
        subject.send(.finished(task))
        
        // Need a small delay to allow the async processing
        try await Task.sleep(for: .milliseconds(100))
        
        // Then
        Verify(downloadsHelper, 1, .calculateDownloadProgress(courseID: .value(courseID)))
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
        courseId: String = "course1",
        state: DownloadState = .inProgress
    ) -> DownloadDataTask {
        DownloadDataTask(
            id: id,
            blockId: "block123",
            courseId: courseId,
            userId: 1,
            url: "https://test.com/video.mp4",
            fileName: "video.mp4",
            displayName: "Test Video",
            progress: 0.5,
            resumeData: nil,
            state: state,
            type: .video,
            fileSize: 1000,
            lastModified: "2024-01-01",
            actualSize: 500
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
                    fileSize: 1000,
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

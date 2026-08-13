//
//  DownloadManagerTests.swift
//  Core
//
//  Created by Ivan Stepanok on 22.10.2024.
//

import XCTest
import Combine
@testable import Core

@MainActor
final class DownloadManagerTests: XCTestCase {

    var persistence: CorePersistenceProtocolMock!
    var storage: CoreStorageMock!
    var connectivity: ConnectivityProtocolMock!

    override func setUp() {
        super.setUp()
        persistence = CorePersistenceProtocolMock()
        storage = CoreStorageMock()
        connectivity = ConnectivityProtocolMock()

        let mockTask = createMockDownloadTask()
        persistence.getDownloadDataTasksHandler = { [mockTask] }
        connectivity.isInternetAvaliable = true
        connectivity.internetReachableSubject = .init(.reachable)
        storage.user = .init(id: 19, username: "username", email: "email", name: "name")
    }

    // MARK: - Test Add to Queue

    func testAddToDownloadQueue_WhenWiFiOnlyAndOnWiFi_ShouldAddToQueue() async throws {
        // Given
        connectivity.isMobileData = false
        storage.userSettings = UserSettings(
            wifiOnly: true,
            streamingQuality: .auto,
            downloadQuality: .auto,
            playbackSpeed: 1.0
        )

        var capturedBlocks: [CourseBlock]?
        var capturedQuality: DownloadQuality?
        persistence.addToDownloadQueueBlocksHandler = { blocks, quality in
            capturedBlocks = blocks
            capturedQuality = quality
        }

        let downloadManager = DownloadManager(
            persistence: persistence,
            appStorage: storage,
            connectivity: connectivity
        )

        let blocks = [createMockCourseBlock()]

        // When
        try await downloadManager.addToDownloadQueue(blocks: blocks)

        // Then
        XCTAssertEqual(persistence.addToDownloadQueueBlocksCallCount, 1)
        XCTAssertEqual(capturedBlocks?.count, blocks.count)
        XCTAssertEqual(capturedQuality, .auto)
    }

    func testAddToDownloadQueue_WhenWiFiOnlyAndOnMobileData_ShouldThrowError() async {
        // Given
        storage.userSettings = UserSettings(
            wifiOnly: true,
            streamingQuality: .auto,
            downloadQuality: .auto,
            playbackSpeed: 1.0
        )
        connectivity.isMobileData = true

        let downloadManager = DownloadManager(
            persistence: persistence,
            appStorage: storage,
            connectivity: connectivity
        )

        let blocks = [createMockCourseBlock()]

        // When/Then
        do {
            try await downloadManager.addToDownloadQueue(blocks: blocks)
            XCTFail("Should throw NoWiFiError")
        } catch is NoWiFiError {
            // Success
            XCTAssertEqual(persistence.addToDownloadQueueBlocksCallCount, 0)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    // MARK: - Test New Download

    func testNewDownload_WhenTaskAvailable_ShouldStartDownloading() async throws {
        // Given
        let mockTask = createMockDownloadTask()
        persistence.getDownloadDataTasksHandler = { [mockTask] }
        connectivity.isMobileData = false

        let downloadManager = DownloadManager(
            persistence: persistence,
            appStorage: storage,
            connectivity: connectivity
        )

        // When
        try await downloadManager.resumeDownloading()
        let currentDownloadTask: DownloadDataTask? = Mirror(reflecting: downloadManager).descendant("currentDownloadTask") as? DownloadDataTask

        // Then
        XCTAssertEqual(currentDownloadTask?.id, mockTask.id)
    }

    // MARK: - Test Cancel Downloads

    func testCancelDownloading_ForSpecificTask_ShouldRemoveFileAndTask() async throws {
        // Given
        let task = createMockDownloadTask()
        connectivity.isMobileData = false

        var deletedIds: [String]?
        persistence.deleteDownloadDataTasksHandler = { ids in
            deletedIds = ids
        }

        let downloadManager = DownloadManager(
            persistence: persistence,
            appStorage: storage,
            connectivity: connectivity
        )

        // When
        try await downloadManager.cancelDownloading(task: task)

        // Then
        XCTAssertEqual(persistence.deleteDownloadDataTasksCallCount, 1)
        XCTAssertEqual(deletedIds, [task.id])
    }

    func testCancelDownloading_ForCourse_ShouldCancelAllTasksForCourse() async throws {
        // Given
        let courseId = "course123"
        let task = createMockDownloadTask(courseId: courseId)
        let tasks = [task]
        connectivity.isMobileData = false

        persistence.getDownloadDataTasksForCourseHandler = { requestedCourseId in
            return requestedCourseId == courseId ? tasks : []
        }

        var deletedIds: [String]?
        persistence.deleteDownloadDataTasksHandler = { ids in
            deletedIds = ids
        }

        let downloadManager = DownloadManager(
            persistence: persistence,
            appStorage: storage,
            connectivity: connectivity
        )

        // When
        try await downloadManager.cancelDownloading(courseId: courseId)

        // Then
        XCTAssertEqual(persistence.getDownloadDataTasksForCourseCallCount, 1)
        XCTAssertEqual(persistence.deleteDownloadDataTasksCallCount, 1)
        XCTAssertEqual(deletedIds, [task.id])
    }

    // MARK: - Test File Management

    func testDeleteFile_ShouldRemoveFileAndTask() async {
        // Given
        let block = createMockCourseBlock()
        let task = createMockDownloadTask()
        connectivity.isMobileData = false

        persistence.getDownloadDataTasksForCourseHandler = { _ in [task] }

        var deletedIds: [String]?
        persistence.deleteDownloadDataTasksHandler = { ids in
            deletedIds = ids
        }

        let downloadManager = DownloadManager(
            persistence: persistence,
            appStorage: storage,
            connectivity: connectivity
        )

        // When
        await downloadManager.delete(blocks: [block], courseId: block.courseId)

        // Then
        XCTAssertEqual(persistence.deleteDownloadDataTasksCallCount, 1)
        XCTAssertEqual(deletedIds, [task.id])
    }

    func testFileUrl_ForFinishedTask_ShouldReturnCorrectUrl() async {
        // Given
        let task = createMockDownloadTask(state: .finished)
        let mockUser = DataLayer.User(
            id: 1,
            username: "test",
            email: "test@test.com",
            name: "Test User"
        )

        storage.user = mockUser
        connectivity.isMobileData = false

        persistence.downloadDataTaskHandler = { blockId in
            return blockId == task.id ? task : nil
        }

        let downloadManager = DownloadManager(
            persistence: persistence,
            appStorage: storage,
            connectivity: connectivity
        )

        // When
        let url = await downloadManager.fileUrl(for: task.id)

        // Then
        XCTAssertNotNil(url)
        XCTAssertEqual(persistence.downloadDataTaskCallCount, 1)
        XCTAssertEqual(url?.lastPathComponent, task.fileName)
    }

    // MARK: - Test Video Size Calculation

    func testIsLargeVideosSize_WhenOver1GB_ShouldReturnTrue() async {
        // Given
        let blocks = [createMockCourseBlock(videoSize: 1_200_000_000)] // 1.2 GB
        connectivity.isMobileData = false

        let downloadManager = DownloadManager(
            persistence: persistence,
            appStorage: storage,
            connectivity: connectivity
        )

        // When
        let isLarge = await downloadManager.isLargeVideosSize(blocks: blocks)

        // Then
        XCTAssertTrue(isLarge)
    }

    func testIsLargeVideosSize_WhenUnder1GB_ShouldReturnFalse() async {
        // Given
        let blocks = [createMockCourseBlock(videoSize: 500_000_000)] // 500 MB
        connectivity.isMobileData = false

        let downloadManager = DownloadManager(
            persistence: persistence,
            appStorage: storage,
            connectivity: connectivity
        )

        // When
        let isLarge = await downloadManager.isLargeVideosSize(blocks: blocks)

        // Then
        XCTAssertFalse(isLarge)
    }

    // MARK: - Test Download Tasks Retrieval

    func testGetDownloadTasks_ShouldReturnAllTasks() async {
        // Given
        let expectedTasks = [
            createMockDownloadTask(id: "1"),
            createMockDownloadTask(id: "2")
        ]

        connectivity.isMobileData = false
        persistence.getDownloadDataTasksHandler = { expectedTasks }

        let downloadManager = DownloadManager(
            persistence: persistence,
            appStorage: storage,
            connectivity: connectivity
        )

        // When
        let tasks = await downloadManager.getDownloadTasks()

        // Then
        XCTAssertEqual(persistence.getDownloadDataTasksCallCount, 1)
        XCTAssertEqual(tasks.count, expectedTasks.count)
        XCTAssertEqual(tasks[0].id, expectedTasks[0].id)
        XCTAssertEqual(tasks[1].id, expectedTasks[1].id)
    }

    // MARK: - Helper Methods

    private func createMockDownloadTask(
        id: String = "test123",
        courseId: String = "course123",
        state: DownloadState = .waiting
    ) -> DownloadDataTask {
        DownloadDataTask(
            id: id,
            blockId: "test123",
            courseId: courseId,
            userId: 1,
            url: "https://test.com/video.mp4",
            fileName: "video.mp4",
            displayName: "Test Video",
            progress: 0,
            resumeData: nil,
            state: state,
            type: .video,
            fileSize: 1000,
            lastModified: "2024-01-01",
            actualSize: 333
        )
    }

    private func createMockCourseBlock(videoSize: Int = 1000) -> CourseBlock {
        CourseBlock(
            blockId: "block123",
            id: "test123",
            courseId: "course123",
            graded: false,
            due: nil,
            completion: 0,
            type: .video,
            displayName: "Test Video",
            studentUrl: "https://test.com",
            webUrl: "https://test.com",
            encodedVideo: CourseBlockEncodedVideo(
                fallback: CourseBlockVideo(
                    url: "https://test.com/video.mp4",
                    fileSize: videoSize,
                    streamPriority: 1,
                    type: .desktopMP4
                ),
                youtube: nil,
                desktopMP4: nil,
                mobileHigh: nil,
                mobileLow: nil,
                hls: nil
            ),
            multiDevice: true,
            offlineDownload: nil
        )
    }
}

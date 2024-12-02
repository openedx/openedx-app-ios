//
//  DownloadManagerTests.swift
//  Core
//
//  Created by Ivan Stepanok on 22.10.2024.
//

import XCTest
import SwiftyMocky
@testable import Core

@MainActor
final class DownloadManagerTests: XCTestCase {
    
    var persistence: CorePersistenceProtocolMock!
    var storage: CoreStorageMock!
    var connectivity: ConnectivityProtocolMock!
    
    override func setUp() {
        super.setUp()
        persistence = CorePersistenceProtocolMock()
        let mockTask = createMockDownloadTask()
        storage = CoreStorageMock()
        connectivity = ConnectivityProtocolMock()
        Given(persistence, .getDownloadDataTasks(willReturn: [mockTask]))
        Given(connectivity, .isInternetAvaliable(getter: true))
        Given(connectivity, .internetReachableSubject(getter: .init(.reachable)))
        Given(storage, .user(getter: .init(id: 19, username: "username", email: "email", name: "name")))
    }
    
    // MARK: - Test Add to Queue
    
    func testAddToDownloadQueue_WhenWiFiOnlyAndOnWiFi_ShouldAddToQueue() async throws {
        // Given
        Given(connectivity, .isMobileData(getter: false))
        
        let downloadManager = DownloadManager(
            persistence: persistence,
            appStorage: storage,
            connectivity: connectivity
        )
        
        Given(storage, .userSettings(getter: UserSettings(
            wifiOnly: true,
            streamingQuality: .auto,
            downloadQuality: .auto
        )))
        
        let blocks = [createMockCourseBlock()]
        
        // When
        try downloadManager.addToDownloadQueue(blocks: blocks)
        // Then
        Verify(persistence, 1, .addToDownloadQueue(blocks: .value(blocks), downloadQuality: .value(.auto)))
    }
    
    func testAddToDownloadQueue_WhenWiFiOnlyAndOnMobileData_ShouldThrowError() async {
        // Given
        Given(storage, .userSettings(getter: UserSettings(
            wifiOnly: true,
            streamingQuality: .auto,
            downloadQuality: .auto
        )))
        Given(connectivity, .isMobileData(getter: true))
        
        let downloadManager = DownloadManager(
            persistence: persistence,
            appStorage: storage,
            connectivity: connectivity
        )
        
        let blocks = [createMockCourseBlock()]
        
        // When/Then
        do {
            try downloadManager.addToDownloadQueue(blocks: blocks)
            XCTFail("Should throw NoWiFiError")
        } catch is NoWiFiError {
            // Success
            Verify(persistence, 0, .addToDownloadQueue(blocks: .any, downloadQuality: .value(.auto)))
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    // MARK: - Test New Download
    
    func testNewDownload_WhenTaskAvailable_ShouldStartDownloading() async throws {
        // Given
        let mockTask = createMockDownloadTask()
        Given(persistence, .getDownloadDataTasks(willReturn: [mockTask]))
        Given(persistence, .nextBlockForDownloading(willReturn: mockTask))
        Given(connectivity, .isMobileData(getter: false))
        
        let downloadManager = DownloadManager(
            persistence: persistence,
            appStorage: storage,
            connectivity: connectivity
        )
        
        // When
        try await downloadManager.resumeDownloading()
        
        // Then
        XCTAssertEqual(downloadManager.currentDownloadTask?.id, mockTask.id)
    }
    
    // MARK: - Test Cancel Downloads
    
    func testCancelDownloading_ForSpecificTask_ShouldRemoveFileAndTask() async throws {
        // Given
        let task = createMockDownloadTask()
        Given(connectivity, .isMobileData(getter: false))
        
        let downloadManager = DownloadManager(
            persistence: persistence,
            appStorage: storage,
            connectivity: connectivity
        )
        
        // When
        try downloadManager.cancelDownloading(task: task)
        
        // Then
        Verify(persistence, 1, .deleteDownloadDataTasks(ids: .value([task.id])))
    }
    
    func testCancelDownloading_ForCourse_ShouldCancelAllTasksForCourse() async throws {
        // Given
        let courseId = "course123"
        let task = createMockDownloadTask(courseId: courseId)
        let tasks = [task]
        Given(connectivity, .isMobileData(getter: false))
        Given(persistence, .getDownloadDataTasksForCourse(.value(courseId), willReturn: tasks))
        
        let downloadManager = DownloadManager(
            persistence: persistence,
            appStorage: storage,
            connectivity: connectivity
        )
        
        // When
        try await downloadManager.cancelDownloading(courseId: courseId)
        
        // Then
        Verify(persistence, 1, .getDownloadDataTasksForCourse(.value(courseId)))
        Verify(persistence, 1, .deleteDownloadDataTasks(ids: .value([task.id])))
    }
    
    // MARK: - Test File Management
    
    func testDeleteFile_ShouldRemoveFileAndTask() async {
        // Given
        let block = createMockCourseBlock()
        let task = createMockDownloadTask()
        Given(connectivity, .isMobileData(getter: false))
        Given(persistence, .getDownloadDataTasksForCourse(.value(block.courseId), willReturn: [task]))
        
        let downloadManager = DownloadManager(
            persistence: persistence,
            appStorage: storage,
            connectivity: connectivity
        )
        
        // When
        await downloadManager.delete(blocks: [block], courseId: block.courseId)
        
        // Then
        Verify(persistence, 1, .deleteDownloadDataTasks(ids: .value([task.id])))
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
        
        Given(storage, .user(getter: mockUser))
        Given(connectivity, .isMobileData(getter: false))
        Given(persistence, .downloadDataTask(for: .value(task.id), willReturn: task))
        
        let downloadManager = DownloadManager(
            persistence: persistence,
            appStorage: storage,
            connectivity: connectivity
        )
        
        // When
        let url = await downloadManager.fileUrl(for: task.id)
        
        // Then
        XCTAssertNotNil(url)
        Verify(persistence, 1, .downloadDataTask(for: .value(task.id)))
        XCTAssertEqual(url?.lastPathComponent, task.fileName)
    }
    
    // MARK: - Test Video Size Calculation
    
    func testIsLargeVideosSize_WhenOver1GB_ShouldReturnTrue() {
        // Given
        let blocks = [createMockCourseBlock(videoSize: 1_200_000_000)] // 1.2 GB
        Given(connectivity, .isMobileData(getter: false))
        
        let downloadManager = DownloadManager(
            persistence: persistence,
            appStorage: storage,
            connectivity: connectivity
        )
        
        // When
        let isLarge = downloadManager.isLargeVideosSize(blocks: blocks)
        
        // Then
        XCTAssertTrue(isLarge)
    }
    
    func testIsLargeVideosSize_WhenUnder1GB_ShouldReturnFalse() {
        // Given
        let blocks = [createMockCourseBlock(videoSize: 500_000_000)] // 500 MB
        Given(connectivity, .isMobileData(getter: false))
        
        let downloadManager = DownloadManager(
            persistence: persistence,
            appStorage: storage,
            connectivity: connectivity
        )
        
        // When
        let isLarge = downloadManager.isLargeVideosSize(blocks: blocks)
        
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
        
        Given(connectivity, .isMobileData(getter: false))
        Given(persistence, .getDownloadDataTasks(willReturn: expectedTasks))
        
        let downloadManager = DownloadManager(
            persistence: persistence,
            appStorage: storage,
            connectivity: connectivity
        )
        
        // When
        let tasks = await downloadManager.getDownloadTasks()
        
        // Then
        Verify(persistence, 1, .getDownloadDataTasks())
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
            lastModified: "2024-01-01"
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
                    streamPriority: 1
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

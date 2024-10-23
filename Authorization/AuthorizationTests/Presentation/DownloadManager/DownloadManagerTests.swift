//
//  DownloadManagerTests.swift
//  Authorization
//
//  Created by Ivan Stepanok on 22.10.2024.
//


import XCTest
@testable import Core

class DownloadManagerTests: XCTestCase {
    
    var downloadManager: DownloadManager!
    var mockPersistence: CorePersistenceProtocolMock!
    var mockConnectivity: ConnectivityProtocolMock!
    var mockAppStorage: CoreStorage!
    
    override func setUp() {
        super.setUp()
        mockPersistence = CorePersistenceProtocolMock()
        mockConnectivity = ConnectivityProtocolMock()
        mockAppStorage = CoreStorage()
        
        // Default connectivity setup
        Given(mockConnectivity, .isInternetAvaliable(getter: true))
        Given(mockConnectivity, .isMobileData(getter: false))
        
        downloadManager = DownloadManager(
            persistence: mockPersistence,
            appStorage: mockAppStorage,
            connectivity: mockConnectivity
        )
    }
    
    // MARK: - Add to Download Queue Tests
    
    func testAddToDownloadQueue_WifiOnly_WithWifi_Success() async throws {
        // Given
        let blocks = [CourseBlock.mock()]
        mockAppStorage.userSettings = UserSettings(wifiOnly: true)
        Given(mockConnectivity, .isInternetAvaliable(getter: true))
        Given(mockConnectivity, .isMobileData(getter: false))
        
        // When
        try await downloadManager.addToDownloadQueue(blocks: blocks)
        
        // Then
        Verify(mockPersistence, .addToDownloadQueue(blocks: .value(blocks), downloadQuality: .any))
    }
    
    func testAddToDownloadQueue_WifiOnly_WithMobileData_ThrowsError() async {
        // Given
        let blocks = [CourseBlock.mock()]
        mockAppStorage.userSettings = UserSettings(wifiOnly: true)
        Given(mockConnectivity, .isInternetAvaliable(getter: true))
        Given(mockConnectivity, .isMobileData(getter: true))
        
        // Then
        await XCTAssertThrowsError(try await downloadManager.addToDownloadQueue(blocks: blocks)) { error in
            XCTAssertTrue(error is NoWiFiError)
        }
    }
    
    func testAddToDownloadQueue_AllowMobileData_WithMobileData_Success() async throws {
        // Given
        let blocks = [CourseBlock.mock()]
        mockAppStorage.userSettings = UserSettings(wifiOnly: false)
        Given(mockConnectivity, .isInternetAvaliable(getter: true))
        Given(mockConnectivity, .isMobileData(getter: true))
        
        // When
        try await downloadManager.addToDownloadQueue(blocks: blocks)
        
        // Then
        Verify(mockPersistence, .addToDownloadQueue(blocks: .value(blocks), downloadQuality: .any))
    }
    
    // MARK: - Cancel Download Tests
    
    func testCancelDownloading_Task_Success() async throws {
        // Given
        let task = DownloadDataTask.mock()
        Given(mockPersistence, .deleteDownloadDataTask(id: .value(task.id), willProduce: { stubber in
            stubber.return()
        }))
        
        // When
        try await downloadManager.cancelDownloading(task: task)
        
        // Then
        Verify(mockPersistence, .deleteDownloadDataTask(id: .value(task.id)))
    }
    
    func testCancelDownloading_Course_Success() async throws {
        // Given
        let courseId = "test-course"
        let tasks = [DownloadDataTask.mock(courseId: courseId)]
        Given(mockPersistence, .getDownloadDataTasksForCourse(.value(courseId), willReturn: tasks))
        
        // When
        try await downloadManager.cancelDownloading(courseId: courseId)
        
        // Then
        Verify(mockPersistence, .deleteDownloadDataTask(id: .value(tasks[0].id)))
    }
    
    // MARK: - File Management Tests
    
    func testFileUrl_ForFinishedVideo_ReturnsCorrectURL() {
        // Given
        let task = DownloadDataTask.mock(state: .finished, type: .video)
        Given(mockPersistence, .downloadDataTask(for: .value(task.id), willReturn: task))
        
        // When
        let url = downloadManager.fileUrl(for: task.id)
        
        // Then
        XCTAssertNotNil(url)
        XCTAssertTrue(url?.lastPathComponent == task.fileName)
    }
    
    func testFileUrl_ForUnfinishedVideo_ReturnsNil() {
        // Given
        let task = DownloadDataTask.mock(state: .waiting, type: .video)
        Given(mockPersistence, .downloadDataTask(for: .value(task.id), willReturn: task))
        
        // When
        let url = downloadManager.fileUrl(for: task.id)
        
        // Then
        XCTAssertNil(url)
    }
    
    // MARK: - Video Size Tests
    
    func testIsLargeVideosSize_AboveThreshold_ReturnsTrue() {
        // Given
        let blocks = [CourseBlock.mockWithLargeVideo(2 * 1024 * 1024 * 1024)] // 2GB
        
        // When
        let isLarge = downloadManager.isLargeVideosSize(blocks: blocks)
        
        // Then
        XCTAssertTrue(isLarge)
    }
    
    func testIsLargeVideosSize_BelowThreshold_ReturnsFalse() {
        // Given
        let blocks = [CourseBlock.mockWithLargeVideo(500 * 1024 * 1024)] // 500MB
        
        // When
        let isLarge = downloadManager.isLargeVideosSize(blocks: blocks)
        
        // Then
        XCTAssertFalse(isLarge)
    }
}

// MARK: - Mock Helpers

private extension CourseBlock {
    static func mock() -> CourseBlock {
        CourseBlock(
            id: "test-block",
            blockId: "test-block",
            courseId: "test-course",
            type: .video,
            displayName: "Test Block",
            childs: [],
            completion: 0,
            isGated: false
        )
    }
    
    static func mockWithLargeVideo(_ size: Int) -> CourseBlock {
        var block = mock()
        block.encodedVideo = CourseBlockEncodedVideo(
            fallback: <#T##CourseBlockVideo?#>,
            youtube: <#T##CourseBlockVideo?#>,
            desktopMP4: <#T##CourseBlockVideo?#>,
            mobileHigh: <#T##CourseBlockVideo?#>,
            mobileLow: <#T##CourseBlockVideo?#>,
            hls: <#T##CourseBlockVideo?#>
        )
        return block
    }
}

private extension DownloadDataTask {
    static func mock(
        courseId: String = "test-course",
        state: DownloadState = .waiting,
        type: DownloadType = .video
    ) -> DownloadDataTask {
        DownloadDataTask(
            id: "test-task",
            blockId: "test-block",
            courseId: courseId,
            userId: 1,
            url: "https://test.com/video.mp4",
            fileName: "video.mp4",
            displayName: "Test Video",
            progress: 0,
            resumeData: nil,
            state: state,
            type: type,
            fileSize: 1024,
            lastModified: "2024-01-01"
        )
    }
}

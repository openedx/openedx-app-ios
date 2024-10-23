//
//  DownloadManagerTests.swift
//  Core
//
//  Created by Ivan Stepanok on 22.10.2024.
//

import XCTest
@testable import Core

final class DownloadManagerTests: XCTestCase {
    
    var sut: DownloadManager!
    var persistence: CorePersistenceMock!
    var storage: CoreStorageMock!
    var connectivity: ConnectivityMock!
    
    override func setUp() {
        super.setUp()
        persistence = CorePersistenceMock()
        storage = CoreStorageMock()
        connectivity = ConnectivityMock()
        storage.user = DataLayer.User(
            id: 1,
            username: "test",
            email: "test@test.com",
            name: "Test User"
        )
        storage.userSettings = UserSettings(
            wifiOnly: true,
            streamingQuality: .auto,
            downloadQuality: .auto
        )
        
        sut = DownloadManager(
            persistence: persistence,
            appStorage: storage,
            connectivity: connectivity
        )
    }
    
    override func tearDown() {
        persistence.reset()
        sut = nil
        persistence = nil
        storage = nil
        connectivity = nil
        super.tearDown()
    }
    
    // MARK: - Test Add to Queue
    
    func testAddToDownloadQueue_WhenWiFiOnlyAndOnWiFi_ShouldAddToQueue() async throws {
        // Given
        storage.userSettings?.wifiOnly = true
        connectivity.isInternetAvaliable = true
        connectivity.isMobileData = false
        let blocks = [createMockCourseBlock()]
        
        persistence.mockDownloadTask = nil
        
        // When
        try await sut.addToDownloadQueue(blocks: blocks)
        
        // Then
        XCTAssertTrue(persistence.addToDownloadQueueCalled)
    }
    
    func testAddToDownloadQueue_WhenWiFiOnlyAndOnMobileData_ShouldThrowError() async {
        // Given
        storage.userSettings?.wifiOnly = true
        connectivity.isInternetAvaliable = true
        connectivity.isMobileData = true
        let blocks = [createMockCourseBlock()]
        
        // When/Then
        do {
            try await sut.addToDownloadQueue(blocks: blocks)
            XCTFail("Should throw NoWiFiError")
        } catch is NoWiFiError {
            // Success
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    // MARK: - Test New Download
     
     func testNewDownload_WhenTaskAvailable_ShouldStartDownloading() async throws {
         // Given
         let mockTask = createMockDownloadTask()
         persistence.mockDownloadTask = mockTask
         connectivity.isInternetAvaliable = true
         connectivity.isMobileData = false
         
         // When
         try await sut.resumeDownloading()
         
         // Then
         XCTAssertEqual(sut.currentDownloadTask?.id, mockTask.id)
     }
    
    // MARK: - Test Cancel Downloads
    
    func testCancelDownloading_ForSpecificTask_ShouldRemoveFileAndTask() async throws {
        // Given
        let task = createMockDownloadTask()
        
        // When
        try await sut.cancelDownloading(task: task)
        
        // Then
        XCTAssertTrue(persistence.deleteDownloadDataTaskCalled)
    }
    
    func testCancelDownloading_ForCourse_ShouldCancelAllTasksForCourse() async throws {
        // Given
        let courseId = "course123"
        let tasks = [createMockDownloadTask(courseId: courseId)]
        persistence.mockDownloadTasks = tasks
        
        // When
        try await sut.cancelDownloading(courseId: courseId)
        
        // Then
        XCTAssertTrue(persistence.deleteDownloadDataTaskCalled)
    }
    
    func testCancelAllDownloading_ShouldCancelAllTasks() async throws {
        // Given
        let tasks = [createMockDownloadTask(), createMockDownloadTask()]
        persistence.mockDownloadTasks = tasks
        
        // When
        try await sut.cancelAllDownloading()
        
        // Then
        XCTAssertTrue(persistence.deleteDownloadDataTaskCalled)
    }
    
    // MARK: - Test File Management
    
    func testDeleteFile_ShouldRemoveFileAndTask() async {
        // Given
        let block = createMockCourseBlock()
        
        // When
        await sut.deleteFile(blocks: [block])
        
        // Then
        XCTAssertTrue(persistence.deleteDownloadDataTaskCalled)
    }
    
    func testFileUrl_ForFinishedTask_ShouldReturnCorrectUrl() {
        // Given
        let task = createMockDownloadTask(state: .finished)
        persistence.mockDownloadTask = task
        
        // When
        let url = sut.fileUrl(for: task.id)
        
        // Then
        XCTAssertNotNil(url)
    }
    
    func testFileUrl_ForUnfinishedTask_ShouldReturnNil() {
        // Given
        let task = createMockDownloadTask(state: .waiting)
        persistence.mockDownloadTask = task
        
        // When
        let url = sut.fileUrl(for: task.id)
        
        // Then
        XCTAssertNil(url)
    }
    
    // MARK: - Test Video Size Calculation
    
    func testIsLargeVideosSize_WhenOver1GB_ShouldReturnTrue() {
        // Given
        let blocks = [
            createMockCourseBlock(videoSize: 1_200_000_000) // 1.2 GB
        ]
        
        // When
        let isLarge = sut.isLargeVideosSize(blocks: blocks)
        
        // Then
        XCTAssertTrue(isLarge)
    }
    
    func testIsLargeVideosSize_WhenUnder1GB_ShouldReturnFalse() {
        // Given
        let blocks = [
            createMockCourseBlock(videoSize: 500_000_000) // 500 MB
        ]
        
        // When
        let isLarge = sut.isLargeVideosSize(blocks: blocks)
        
        // Then
        XCTAssertFalse(isLarge)
    }
    
    func testGetDownloadTasks_ShouldReturnAllTasks() async {
           // Given
           let expectedTasks = [
               createMockDownloadTask(id: "1"),
               createMockDownloadTask(id: "2")
           ]
           persistence.mockDownloadTasks = expectedTasks
           
           // When
           let tasks = await sut.getDownloadTasks()
           
           // Then
           XCTAssertEqual(tasks.count, expectedTasks.count)
           XCTAssertEqual(tasks[0].id, expectedTasks[0].id)
           XCTAssertEqual(tasks[1].id, expectedTasks[1].id)
       }
       
       func testGetDownloadTasksForCourse_ShouldReturnTasksForSpecificCourse() async {
           // Given
           let courseId = "course123"
           let expectedTasks = [
               createMockDownloadTask(courseId: courseId),
               createMockDownloadTask(courseId: courseId)
           ]
           persistence.mockDownloadTasks = expectedTasks
           
           // When
           let tasks = await sut.getDownloadTasksForCourse(courseId)
           
           // Then
           XCTAssertEqual(tasks.count, expectedTasks.count)
           XCTAssertTrue(tasks.allSatisfy { $0.courseId == courseId })
       }
       
       // MARK: - Test File Size Calculations
       
       func testCalculateFolderSize_WithValidFolder() throws {
           // Given
           let fileManager = FileManager.default
           let tempDir = fileManager.temporaryDirectory
           let testFolder = tempDir.appendingPathComponent(UUID().uuidString)
           let testFile = testFolder.appendingPathComponent("test.txt")
           let testData = Data()
           
           try fileManager.createDirectory(at: testFolder, withIntermediateDirectories: true)
           try testData.write(to: testFile)
           
           // When
           let size = try sut.calculateFolderSize(at: testFolder)
           
           // Then
           XCTAssertEqual(size, testData.count)
           
           // Cleanup
           try? fileManager.removeItem(at: testFolder)
       }
       
       func testUpdateUnzippedFileSize_ShouldUpdateSequentials() {
           // Given
           let sequentials = [createMockCourseSequential()]
           
           // When
           let updatedSequentials = sut.updateUnzippedFileSize(for: sequentials)
           
           // Then
           XCTAssertEqual(updatedSequentials.count, sequentials.count)
           // Note: Actual file size cannot be verified since it depends on file system
       }
       
       // MARK: - Test URL Generation
       
       func testFileUrlForHTML_ShouldReturnCorrectURL() {
           // Given
           let blockId = "test123"
           let task = createMockDownloadTask(
               id: blockId,
               state: .finished,
               type: .html,
               url: "https://test.com/content.zip"
           )
           persistence.mockDownloadTask = task
           
           // When
           let url = sut.fileUrl(for: blockId)
           
           // Then
           XCTAssertNotNil(url)
           XCTAssertTrue(url?.lastPathComponent == "index.html")
       }
       
       func testFileOrFolderUrlForHTML_ShouldReturnFolderURL() {
           // Given
           let blockId = "test123"
           let task = createMockDownloadTask(
               id: blockId,
               state: .finished,
               type: .html,
               url: "https://test.com/content.zip"
           )
           persistence.mockDownloadTask = task
           
           // When
           let url = sut.fileOrFolderUrl(for: blockId)
           
           // Then
           XCTAssertNotNil(url)
           XCTAssertTrue(url?.lastPathComponent == "content")
       }
       
       // MARK: - Test MD5 Hash Validation
       
       func testIsMD5Hash_WithValidHash_ShouldReturnTrue() {
           // Given
           let validHash = "d41d8cd98f00b204e9800998ecf8427e"
           
           // When
           let result = sut.isMD5Hash(validHash)
           
           // Then
           XCTAssertTrue(result)
       }
       
       func testIsMD5Hash_WithInvalidHash_ShouldReturnFalse() {
           // Given
           let invalidHash = "not-a-hash"
           
           // When
           let result = sut.isMD5Hash(invalidHash)
           
           // Then
           XCTAssertFalse(result)
       }
    
    // MARK: - Helper Methods
    
    private func createMockDownloadTask(
        id: String = "test123",
        courseId: String = "course123",
        state: DownloadState = .waiting
    ) -> DownloadDataTask {
        DownloadDataTask(
            id: id,
            blockId: "block123",
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
    
    private func createMockDownloadTask(
        id: String = "test123",
        courseId: String = "course123",
        state: DownloadState = .waiting,
        type: DownloadType = .video,
        url: String = "https://test.com/video.mp4"
    ) -> DownloadDataTask {
        DownloadDataTask(
            id: id,
            blockId: "block123",
            courseId: courseId,
            userId: 1,
            url: url,
            fileName: "video.mp4",
            displayName: "Test Video",
            progress: 0,
            resumeData: nil,
            state: state,
            type: type,
            fileSize: 1000,
            lastModified: "2024-01-01"
        )
    }
    
    private func createMockCourseSequential() -> CourseSequential {
            CourseSequential(
                blockId: "sequential123",
                id: "seq123",
                displayName: "Test Sequential",
                type: .sequential,
                completion: 0,
                childs: [
                    CourseVertical(
                        blockId: "vertical123",
                        id: "vert123",
                        courseId: "course123",
                        displayName: "Test Vertical",
                        type: .vertical,
                        completion: 0,
                        childs: [createMockCourseBlock()]
                    )
                ],
                sequentialProgress: nil,
                due: nil
            )
        }
}

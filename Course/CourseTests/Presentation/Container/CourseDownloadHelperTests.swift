//
//  CourseDownloadHelperTests.swift
//  Course
//
//  Created by Vadim Kuznetsov on 25.01.25.
//

import Core
import Combine
import XCTest

@testable import Course

@MainActor
final class CourseDownloadHelperTests: XCTestCase {
    var downloadManagerMock: DownloadManagerProtocolMock!
    var helper: CourseDownloadHelper!
    var cancellables: [AnyCancellable] = []
    var downloadPublisher: PassthroughSubject<DownloadManagerEvent, Never> = .init()
    var block: CourseBlock!
    var sequential: CourseSequential!
    var task: DownloadDataTask!
    var value: CourseDownloadValue!
    var timeout: TimeInterval = 15

    override func setUp() {
        super.setUp()
        downloadManagerMock = DownloadManagerProtocolMock()
        block = CourseBlock(
            blockId: "",
            id: "1",
            courseId: "123",
            topicId: "",
            graded: false,
            due: Date(),
            completion: 0,
            type: .video,
            displayName: "",
            studentUrl: "",
            webUrl: "",
            encodedVideo: .init(
                fallback: nil,
                youtube: nil,
                desktopMP4: .init(url: "http://test/test.mp4", fileSize: 1000, streamPriority: 1, type: .desktopMP4),
                mobileHigh: nil,
                mobileLow: nil,
                hls: nil
            ),
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
        sequential = CourseSequential(
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
        task = DownloadDataTask(block: block, userId: 0, downloadQuality: .auto)
        value = .init(
            currentDownloadTask: task,
            courseDownloadTasks: [task],
            allDownloadTasks: [task],
            notFinishedTasks: [task],
            downloadableVerticals: [.init(vertical: vertical, state: .downloading)],
            sequentialsStates: [sequential.id: .downloading],
            totalFilesSize: block.fileSize!,
            downloadedFilesSize: 0,
            largestBlocks: [],
            state: .cancel
        )
        let taskCopy = task!
        let publisher = downloadPublisher.eraseToAnyPublisher()
        downloadManagerMock.getDownloadTasksHandler = { [taskCopy] in [taskCopy] }
        downloadManagerMock.getCurrentDownloadTaskHandler = { [taskCopy] in taskCopy }
        downloadManagerMock.eventPublisherHandler = { publisher }
        helper = CourseDownloadHelper(courseStructure: courseStructure, manager: downloadManagerMock)
    }

    override func tearDown() {
        super.tearDown()
        cancellables.removeAll()
        cancellables = []
    }

    func testSizeForBlock_whenCalled_ShouldReturnSize() {
        // when
        let size = helper.sizeFor(block: block)
        // then
        XCTAssertEqual(size, block.fileSize)
    }

    func testSizeForBlocks_whenCalled_ShouldReturnSize() {
        // when
        let size = helper.sizeFor(blocks: [block])
        // then
        XCTAssertEqual(size, block.fileSize)
    }

    func testSizeForSequential_whenCalled_ShouldReturnSize() {
        // when
        let size = helper.sizeFor(sequential: sequential)
        // then
        XCTAssertEqual(size, sequential.totalSize)
    }

    func testSizeForSequentials_whenCalled_ShouldReturnSize() {
        // when
        let size = helper.sizeFor(sequentials: [sequential])
        // then
        XCTAssertEqual(size, sequential.totalSize)
    }

    func testCancelDownloading_whenCalled_ShouldCallManagerMethod() async throws {
        // given
        downloadManagerMock.cancelDownloadingTaskHandler = { _ in }
        // when
        try await helper.cancelDownloading(task: task)
        // then
        XCTAssertEqual(downloadManagerMock.cancelDownloadingTaskCallCount, 1)
    }
}


//
//  CourseDownloadHelperTests.swift
//  Course
//
//  Created by Vadim Kuznetsov on 25.01.25.
//

import Core
import Combine
import SwiftyMocky
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
    var timeout: TimeInterval = 60
    
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
                desktopMP4: .init(url: "http://test/test.mp4", fileSize: 1000, streamPriority: 1),
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
        Given(downloadManagerMock, .getDownloadTasks(willReturn: [task!]))
        Given(downloadManagerMock, .getCurrentDownloadTask(willReturn: task))
        Given(downloadManagerMock, .eventPublisher(willReturn: downloadPublisher.eraseToAnyPublisher()))
        helper = CourseDownloadHelper(courseStructure: courseStructure, manager: downloadManagerMock)
    }
    
    override func tearDown() {
        super.tearDown()
        cancellables.removeAll()
        cancellables = []
    }
    
    func testPublisher_whenRefresh_ShouldSendValue() {
        // given
        var valueReceived: CourseDownloadValue?
        let expectation = expectation(description: "wait for publisher")
        helper.publisher()
            .sink { value in
                valueReceived = value
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // when
        helper.refreshValue()
        
        // then
        wait(for: [expectation], timeout: timeout)
        Verify(downloadManagerMock, .once, .getDownloadTasks())
        Verify(downloadManagerMock, .once, .getCurrentDownloadTask())
        XCTAssertEqual(valueReceived, value)
    }
    
    func testPublisher_whenAsyncRefresh_ShouldSendValue() async {
        // given
        var valueReceived: CourseDownloadValue?
        let expectation = expectation(description: "wait for publisher")
        helper.publisher()
            .sink { value in
                valueReceived = value
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // when
        await helper.refreshValue()
        
        // then
        await fulfillment(of: [expectation], timeout: timeout)
        Verify(downloadManagerMock, .once, .getDownloadTasks())
        Verify(downloadManagerMock, .once, .getCurrentDownloadTask())
        XCTAssertEqual(valueReceived, value)
    }
    
    func testPublisher_whenReceivedNotProgressEvent_ShouldSendValue() async {
        // given
        var valueReceived: CourseDownloadValue?
        var receivedCount = 0
        let addedExpectation = expectation(description: "wait for added event")
        let startedExpectation = expectation(description: "wait for started event")
        let pausedExpectation = expectation(description: "wait for paused event")
        let canceledExpectation = expectation(description: "wait for canceled event")
        let courseCanceledExpectation = expectation(description: "wait for courseCanceled event")
        let allCanceledExpectation = expectation(description: "wait for allCanceled event")
        let finishedExpectation = expectation(description: "wait for finished event")
        let deletedFileExpectation = expectation(description: "wait for deletedFile event")
        let clearedAllExpectation = expectation(description: "wait for clearedAll event")
        
        let expectations: [XCTestExpectation] = [
            addedExpectation,
            startedExpectation,
            pausedExpectation,
            canceledExpectation,
            courseCanceledExpectation,
            allCanceledExpectation,
            finishedExpectation,
            deletedFileExpectation,
            clearedAllExpectation
        ]
        
        helper.publisher()
            .sink { value in
                expectations[receivedCount].fulfill()
                receivedCount += 1
                valueReceived = value
            }
            .store(in: &cancellables)
        // when
        downloadPublisher.send(.added) //1
        downloadPublisher.send(.started(task)) //2
        downloadPublisher.send(.paused([task])) //3
        downloadPublisher.send(.canceled([task])) //4
        downloadPublisher.send(.courseCanceled(task.courseId)) //5
        downloadPublisher.send(.allCanceled) //6
        downloadPublisher.send(.finished(task)) //7
        downloadPublisher.send(.deletedFile([task.blockId])) //8
        downloadPublisher.send(.clearedAll) //9
        downloadPublisher.send(.progress(task)) //Helper shouldn't send event for that
        // then
        await fulfillment(of: expectations, timeout: timeout)
        Verify(downloadManagerMock, 9, .getDownloadTasks())
        Verify(downloadManagerMock, 9, .getCurrentDownloadTask())
        XCTAssertEqual(receivedCount, 9)
        XCTAssertEqual(valueReceived, value)
    }
    
    func testEventPublisher_whenReceivedProgressEvent_ShouldSendEvent() async {
        // given
        var valueReceived: DownloadDataTask?
        task.progress = 0.5
        let expectation = expectation(description: "wait for progress event")
        var countOfEvents: Int = 0
        helper.progressPublisher()
            .sink { value in
                expectation.fulfill()
                countOfEvents += 1
                valueReceived = value
            }
            .store(in: &cancellables)
        helper.value = value
        // when
        downloadPublisher.send(.progress(task))
        // then
        await fulfillment(of: [expectation], timeout: timeout)
        value.currentDownloadTask = task
        XCTAssertEqual(helper.value, value)
        XCTAssertEqual(valueReceived, task)
        XCTAssertEqual(countOfEvents, 1)
        Verify(downloadManagerMock, .never, .getDownloadTasks())
        Verify(downloadManagerMock, .never, .getCurrentDownloadTask())
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
        // when
        try await helper.cancelDownloading(task: task)
        // then
        Verify(downloadManagerMock, .cancelDownloading(task: .value(task)))
    }
}

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

final class CourseDownloadHelperTests: XCTestCase {
    var downloadManagerMock: DownloadManagerProtocolMock!
    var helper: CourseDownloadHelper!
    var cancellables: [AnyCancellable] = []
    var downloadPublisher: PassthroughSubject<DownloadManagerEvent, Never> = .init()
    var block: CourseBlock!
    var sequential: CourseSequential!
    var task: DownloadDataTask!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        cancellables.removeAll()
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

        Given(downloadManagerMock, .getDownloadTasks(willReturn: [task!]))
        Given(downloadManagerMock, .getCurrentDownloadTask(willReturn: task))
        Given(downloadManagerMock, .eventPublisher(willReturn: downloadPublisher.eraseToAnyPublisher()))
        helper = CourseDownloadHelper(courseStructure: courseStructure, manager: downloadManagerMock)
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
        wait(for: [expectation], timeout: 1)
        Verify(downloadManagerMock, .once, .getDownloadTasks())
        Verify(downloadManagerMock, .once, .getCurrentDownloadTask())
        XCTAssert(valueReceived != nil)
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
        await Task.yield()
        await fulfillment(of: [expectation], timeout: 1)
        Verify(downloadManagerMock, .once, .getDownloadTasks())
        Verify(downloadManagerMock, .once, .getCurrentDownloadTask())
        XCTAssert(valueReceived != nil)
    }
    
    func testPublisher_whenReceivedEvent_ShouldSendValue() async {
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
        downloadPublisher.send(.added)
        // then
        await Task.yield()
        await fulfillment(of: [expectation], timeout: 1)
        Verify(downloadManagerMock, .once, .getDownloadTasks())
        Verify(downloadManagerMock, .once, .getCurrentDownloadTask())
        XCTAssert(valueReceived != nil)
    }
    
    func testSizeForBlock_whenCalled_ShouldReturnSize() {
        // when
        let size = helper.sizeFor(block: block)
        // then
        XCTAssert(size == block.fileSize)
    }
    
    func testSizeForBlocks_whenCalled_ShouldReturnSize() {
        // when
        let size = helper.sizeFor(blocks: [block])
        // then
        XCTAssert(size == block.fileSize)
    }
    
    func testSizeForSequential_whenCalled_ShouldReturnSize() {
        // when
        let size = helper.sizeFor(sequential: sequential)
        // then
        XCTAssert(size == sequential.totalSize)
    }
    
    func testSizeForSequentials_whenCalled_ShouldReturnSize() {
        // when
        let size = helper.sizeFor(sequentials: [sequential])
        // then
        XCTAssert(size == sequential.totalSize)
    }
    
    func testCancelDownloading_whenCalled_ShouldCallManagerMethod() async throws {
        // when
        try await helper.cancelDownloading(task: task)
        // then
        Verify(downloadManagerMock, .cancelDownloading(task: .value(task)))
    }
}

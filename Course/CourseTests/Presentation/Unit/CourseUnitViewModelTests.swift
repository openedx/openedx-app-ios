//
//  CourseUnitViewModelTests.swift
//  CourseTests
//
//  Created by  Stepanok Ivan on 23.01.2023.
//

import SwiftyMocky
import XCTest
@testable import Core
@testable import Course
import Alamofire
import SwiftUI

@MainActor
final class CourseUnitViewModelTests: XCTestCase {
    var config = Config()

    static let blocks = [
        CourseBlock(blockId: "1",
                    id: "1",
                    courseId: "123",
                    topicId: "1",
                    graded: false, 
                    due: Date(),
                    completion: 0,
                    type: .video,
                    displayName: "Lesson 1",
                    studentUrl: "",
                    webUrl: "",
                    encodedVideo: nil,
                    multiDevice: true,
                    offlineDownload: nil
                   ),
        CourseBlock(blockId: "2",
                    id: "2",
                    courseId: "123",
                    topicId: "2",
                    graded: false,
                    due: Date(),
                    completion: 0,
                    type: .video,
                    displayName: "Lesson 2",
                    studentUrl: "2",
                    webUrl: "2",
                    encodedVideo: nil,
                    multiDevice: false,
                    offlineDownload: nil
                   ),
        CourseBlock(blockId: "3",
                    id: "3",
                    courseId: "123",
                    topicId: "3",
                    graded: false,
                    due: Date(),
                    completion: 0,
                    type: .unknown,
                    displayName: "Lesson 3",
                    studentUrl: "3",
                    webUrl: "3",
                    encodedVideo: nil,
                    multiDevice: true,
                    offlineDownload: nil
                   ),
        CourseBlock(blockId: "4",
                    id: "4",
                    courseId: "123",
                    topicId: "4",
                    graded: false,
                    due: Date(),
                    completion: 0,
                    type: .unknown,
                    displayName: "4",
                    studentUrl: "4",
                    webUrl: "4",
                    encodedVideo: nil,
                    multiDevice: false,
                    offlineDownload: nil
                   ),
    ]
    
    let chapters = [
        CourseChapter(
        blockId: "0",
        id: "0",
        displayName: "0",
        type: .chapter,
        childs: [
            CourseSequential(
                blockId: "5",
                id: "5",
                displayName: "5",
                type: .sequential,
                completion: 0,
                childs: [
                    CourseVertical(
                        blockId: "6",
                        id: "6",
                        courseId: "123",
                        displayName: "6",
                        type: .vertical,
                        completion: 0,
                        childs: blocks,
                        webUrl: ""
                    )
                ],
                sequentialProgress: nil,
                due: Date()
            )
            
        ]),
        CourseChapter(
        blockId: "2",
        id: "2",
        displayName: "2",
        type: .chapter,
        childs: [
            CourseSequential(
                blockId: "3",
                id: "3",
                displayName: "3",
                type: .sequential,
                completion: 0,
                childs: [
                    CourseVertical(
                        blockId: "4",
                        id: "4",
                        courseId: "123",
                        displayName: "4",
                        type: .vertical,
                        completion: 0,
                        childs: blocks,
                        webUrl: ""
                    )
                ],
                sequentialProgress: nil,
                due: Date()
            )
            
        ])
        ]
    
    func testBlockCompletionRequestSuccess() async throws {
        let interactor = CourseInteractorProtocolMock()
        let router = CourseRouterMock()
        let connectivity = ConnectivityProtocolMock()
        let analytics = CourseAnalyticsMock()
        
        let viewModel = CourseUnitViewModel(
            lessonID: "123",
            courseID: "456",
            courseName: "name",
            chapters: chapters,
            chapterIndex: 0,
            sequentialIndex: 0,
            verticalIndex: 0,
            interactor: interactor,
            config: config,
            router: router,
            analytics: analytics,
            connectivity: connectivity,
            storage: CourseStorageMock(),
            manager: DownloadManagerMock()
        )
        
        Given(interactor, .blockCompletionRequest(courseID: .any, blockID: .any, willProduce: {_ in}))
        
        await viewModel.blockCompletionRequest(blockID: "1")
        
        Verify(interactor, .blockCompletionRequest(courseID: .any, blockID: .any))
    }
        
    func testBlockCompletionRequestUnknownError() async throws {
        let interactor = CourseInteractorProtocolMock()
        let router = CourseRouterMock()
        let connectivity = ConnectivityProtocolMock()
        let analytics = CourseAnalyticsMock()
        
        let viewModel = CourseUnitViewModel(
            lessonID: "123",
            courseID: "456",
            courseName: "name",
            chapters: chapters,
            chapterIndex: 0,
            sequentialIndex: 0,
            verticalIndex: 0,
            interactor: interactor,
            config: config,
            router: router,
            analytics: analytics,
            connectivity: connectivity, 
            storage: CourseStorageMock(),
            manager: DownloadManagerMock()
        )
        
        Given(interactor, .blockCompletionRequest(courseID: .any,
                                                  blockID: .any,
                                                  willThrow: NSError()))
        
        await viewModel.blockCompletionRequest(blockID: "1")
        
        Verify(interactor, .blockCompletionRequest(courseID: .any, blockID: .any))
        
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.unknownError)
    }
    
    func testBlockCompletionRequestNoInternetError() async throws {
        let interactor = CourseInteractorProtocolMock()
        let router = CourseRouterMock()
        let connectivity = ConnectivityProtocolMock()
        let analytics = CourseAnalyticsMock()
        
        let viewModel = CourseUnitViewModel(
            lessonID: "123",
            courseID: "456",
            courseName: "name",
            chapters: chapters,
            chapterIndex: 0,
            sequentialIndex: 0,
            verticalIndex: 0,
            interactor: interactor,
            config: config,
            router: router,
            analytics: analytics,
            connectivity: connectivity,
            storage: CourseStorageMock(),
            manager: DownloadManagerMock()
        )
        
        let noInternetError = AFError.sessionInvalidated(error: URLError(.notConnectedToInternet))

        Given(interactor, .blockCompletionRequest(courseID: .any,
                                                  blockID: .any,
                                                  willThrow: noInternetError))
        
        await viewModel.blockCompletionRequest(blockID: "1")
        
        Verify(interactor, .blockCompletionRequest(courseID: .any, blockID: .any))
        
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.slowOrNoInternetConnection)
    }
    
    func testBlockCompletionRequestNoCacheError() async throws {
        let interactor = CourseInteractorProtocolMock()
        let router = CourseRouterMock()
        let connectivity = ConnectivityProtocolMock()
        let analytics = CourseAnalyticsMock()
        
        let viewModel = CourseUnitViewModel(
            lessonID: "123",
            courseID: "456",
            courseName: "name",
            chapters: chapters,
            chapterIndex: 0,
            sequentialIndex: 0,
            verticalIndex: 0,
            interactor: interactor,
            config: config,
            router: router,
            analytics: analytics,
            connectivity: connectivity,
            storage: CourseStorageMock(),
            manager: DownloadManagerMock()
        )
        
        Given(interactor, .blockCompletionRequest(courseID: .any,
                                                  blockID: .any,
                                                  willThrow: NoCachedDataError()))
        
        await viewModel.blockCompletionRequest(blockID: "1")
        
        Verify(interactor, .blockCompletionRequest(courseID: .any, blockID: .any))
        
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.slowOrNoInternetConnection)
    }
    
    
    func testCourseNavigation() async throws {
        let interactor = CourseInteractorProtocolMock()
        let router = CourseRouterMock()
        let connectivity = ConnectivityProtocolMock()
        let analytics = CourseAnalyticsMock()
        
        let viewModel = CourseUnitViewModel(
            lessonID: "123",
            courseID: "456",
            courseName: "name",
            chapters: chapters,
            chapterIndex: 0,
            sequentialIndex: 0,
            verticalIndex: 0,
            interactor: interactor,
            config: config,
            router: router,
            analytics: analytics,
            connectivity: connectivity,
            storage: CourseStorageMock(),
            manager: DownloadManagerMock()
        )
        
        viewModel.loadIndex()
        
        for _ in 0...CourseUnitViewModelTests.blocks.count - 1 {
            viewModel.select(move: .next)
        }
        
        Verify(analytics, .nextBlockClicked(courseId: .any, courseName: .any, blockId: .any, blockName: .any))
        
        XCTAssertEqual(viewModel.index, 3)
        
        for _ in 0...CourseUnitViewModelTests.blocks.count - 1 {
            viewModel.select(move: .previous)
        }
        
        Verify(analytics, .prevBlockClicked(courseId: .any, courseName: .any, blockId: .any, blockName: .any))
        
        XCTAssertEqual(viewModel.index, 0)
    }
}

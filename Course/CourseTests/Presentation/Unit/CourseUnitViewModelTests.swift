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

final class CourseUnitViewModelTests: XCTestCase {
    
    let blocks = [
        CourseBlock(blockId: "1",
                    id: "1",
                    topicId: "1",
                    graded: false,
                    completion: 0,
                    type: .course,
                    displayName: "One",
                    studentUrl: "",
                    videoUrl: nil,
                    youTubeUrl: nil),
        CourseBlock(blockId: "1",
                    id: "1",
                    topicId: "1",
                    graded: false,
                    completion: 0,
                    type: .course,
                    displayName: "One",
                    studentUrl: "",
                    videoUrl: nil,
                    youTubeUrl: nil),
        CourseBlock(blockId: "2",
                    id: "2",
                    topicId: "2",
                    graded: false,
                    completion: 0,
                    type: .html,
                    displayName: "Two",
                    studentUrl: "",
                    videoUrl: nil,
                    youTubeUrl: nil),
        CourseBlock(blockId: "3",
                    id: "3",
                    topicId: "3",
                    graded: false,
                    completion: 0,
                    type: .discussion,
                    displayName: "Three",
                    studentUrl: "",
                    videoUrl: nil,
                    youTubeUrl: nil),
        CourseBlock(blockId: "4",
                    id: "4",
                    topicId: "4",
                    graded: false,
                    completion: 0,
                    type: .video,
                    displayName: "Four",
                    studentUrl: "",
                    videoUrl: "url",
                    youTubeUrl: "url"),
        CourseBlock(blockId: "5",
                    id: "5",
                    topicId: "5",
                    graded: false,
                    completion: 0,
                    type: .video,
                    displayName: "Five",
                    studentUrl: "",
                    videoUrl: "url",
                    youTubeUrl: nil),
        CourseBlock(blockId: "6",
                    id: "6",
                    topicId: "6",
                    graded: false,
                    completion: 0,
                    type: .video,
                    displayName: "Six",
                    studentUrl: "",
                    videoUrl: nil,
                    youTubeUrl: nil),
        CourseBlock(blockId: "7",
                    id: "7",
                    topicId: "7",
                    graded: false,
                    completion: 0,
                    type: .problem,
                    displayName: "Seven",
                    studentUrl: "",
                    videoUrl: nil,
                    youTubeUrl: nil)
    ]
    
    func testBlockCompletionRequestSuccess() async throws {
        let interactor = CourseInteractorProtocolMock()
        let router = CourseRouterMock()
        let connectivity = ConnectivityProtocolMock()
        
        let viewModel = CourseUnitViewModel(
            lessonID: "123",
            courseID: "456",
            blocks: blocks,
            interactor: interactor,
            router: router,
            connectivity: connectivity,
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
        
        let viewModel = CourseUnitViewModel(
            lessonID: "123",
            courseID: "456",
            blocks: blocks,
            interactor: interactor,
            router: router,
            connectivity: connectivity,
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
        
        let viewModel = CourseUnitViewModel(
            lessonID: "123",
            courseID: "456",
            blocks: blocks,
            interactor: interactor,
            router: router,
            connectivity: connectivity,
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
        
        let viewModel = CourseUnitViewModel(
            lessonID: "123",
            courseID: "456",
            blocks: blocks,
            interactor: interactor,
            router: router,
            connectivity: connectivity,
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
        
        let viewModel = CourseUnitViewModel(
            lessonID: "123",
            courseID: "456",
            blocks: blocks,
            interactor: interactor,
            router: router,
            connectivity: connectivity,
            manager: DownloadManagerMock()
        )
        
        viewModel.loadIndex()
        
        for _ in 0...blocks.count - 1 {
            viewModel.select(move: .next)
            viewModel.createLessonType()
        }
        
        XCTAssertEqual(viewModel.index, 7)
        
        for _ in 0...blocks.count - 1 {
            viewModel.select(move: .previous)
            viewModel.createLessonType()
        }
        
        
        XCTAssertEqual(viewModel.index, 0)
    }
}

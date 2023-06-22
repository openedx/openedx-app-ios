//
//  DiscussionSearchTopicsViewModelTests.swift
//  DiscussionTests
//
//  Created by  Stepanok Ivan on 24.02.2023.
//

import SwiftyMocky
import XCTest
@testable import Core
@testable import Discussion
import Alamofire
import SwiftUI

final class DiscussionSearchTopicsViewModelTests: XCTestCase {

    func testSearchSuccess() async throws {
        let interactor = DiscussionInteractorProtocolMock()
        let router = DiscussionRouterMock()
        let viewModel = DiscussionSearchTopicsViewModel(courseID: "123",
                                                        interactor: interactor,
                                                        router: router,
                                                        debounce: .test)
        
        let items = ThreadLists(
            threads: [
                UserThread(id: "1",
                           author: "1",
                           authorLabel: "1",
                           createdAt: Date(),
                           updatedAt: Date(),
                           rawBody: "1",
                           renderedBody: "1",
                           voted: false,
                           voteCount: 1,
                           courseID: "1",
                           type: .discussion,
                           title: "1",
                           pinned: false,
                           closed: false,
                           following: true,
                           commentCount: 1,
                           avatar: "avatar",
                           unreadCommentCount: 1,
                           abuseFlagged: false,
                           hasEndorsed: true,
                           numPages: 1)
            ]
        )

        Given(interactor, .searchThreads(courseID: .any, searchText: .any, pageNumber: .any, willReturn: items))

        viewModel.searchText = "Test"
        
        
        let exp = expectation(description: "Task Starting")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)

        Verify(interactor, .searchThreads(courseID: .any, searchText: .any, pageNumber: .any))

        XCTAssertFalse(viewModel.showError)
        XCTAssertFalse(viewModel.fetchInProgress)
    }

    func testSearchNoInternetError() async throws {
        let interactor = DiscussionInteractorProtocolMock()
        let router = DiscussionRouterMock()
        let viewModel = DiscussionSearchTopicsViewModel(courseID: "123",
                                                        interactor: interactor,
                                                        router: router,
                                                        debounce: .test)
        
        let noInternetError = AFError.sessionInvalidated(error: URLError(.notConnectedToInternet))

        Given(interactor, .searchThreads(courseID: .any, searchText: .any, pageNumber: .any, willThrow: noInternetError))

        viewModel.searchText = "Test"
        
        
        let exp = expectation(description: "Task Starting")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)

        Verify(interactor, .searchThreads(courseID: .any, searchText: .any, pageNumber: .any))

        XCTAssertTrue(viewModel.showError)
        XCTAssertTrue(viewModel.errorMessage == CoreLocalization.Error.slowOrNoInternetConnection)
        XCTAssertFalse(viewModel.fetchInProgress)
    }
    
    func testSearchUnknownError() async throws {
        let interactor = DiscussionInteractorProtocolMock()
        let router = DiscussionRouterMock()
        let viewModel = DiscussionSearchTopicsViewModel(courseID: "123",
                                                        interactor: interactor,
                                                        router: router,
                                                        debounce: .test)

        Given(interactor, .searchThreads(courseID: .any, searchText: .any, pageNumber: .any, willThrow: NSError()))

        viewModel.searchText = "Test"
        
        
        let exp = expectation(description: "Task Starting")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)

        Verify(interactor, .searchThreads(courseID: .any, searchText: .any, pageNumber: .any))

        XCTAssertTrue(viewModel.showError)
        XCTAssertTrue(viewModel.errorMessage == CoreLocalization.Error.unknownError)
        XCTAssertFalse(viewModel.fetchInProgress)
    }
    
    func testEmptyQuerySuccess() async throws {
        let interactor = DiscussionInteractorProtocolMock()
        let router = DiscussionRouterMock()
        let viewModel = DiscussionSearchTopicsViewModel(courseID: "123",
                                                        interactor: interactor,
                                                        router: router,
                                                        debounce: .test)
        
        viewModel.searchText = ""
        
        
        let exp = expectation(description: "Task Starting")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)

        Verify(interactor, 0, .searchThreads(courseID: .any, searchText: .any, pageNumber: .any))

        XCTAssertFalse(viewModel.showError)
        XCTAssertFalse(viewModel.fetchInProgress)
    }
}

//
//  ResponsesViewModelTests.swift
//  DiscussionTests
//
//  Created by  Stepanok Ivan on 31.01.2023.
//

import SwiftyMocky
import XCTest
@testable import Core
@testable import Discussion
import Alamofire
import SwiftUI

@MainActor
final class ResponsesViewModelTests: XCTestCase {
    
    let userComments = [
        UserComment(authorName: "1",
                    authorAvatar: "1",
                    postDate: Date(),
                    postTitle: "1",
                    postBody: "1",
                    postBodyHtml: "1",
                    postVisible: true,
                    voted: true,
                    followed: true,
                    votesCount: 1,
                    responsesCount: 1,
                    threadID: "1",
                    commentID: "1",
                    parentID: nil,
                    abuseFlagged: false),
        UserComment(authorName: "2",
                    authorAvatar: "2",
                    postDate: Date(),
                    postTitle: "2",
                    postBody: "2",
                    postBodyHtml: "2",
                    postVisible: true,
                    voted: true,
                    followed: true,
                    votesCount: 2,
                    responsesCount: 2,
                    threadID: "2",
                    commentID: "2",
                    parentID: nil,
                    abuseFlagged: false),
        UserComment(authorName: "3",
                    authorAvatar: "3",
                    postDate: Date(),
                    postTitle: "3",
                    postBody: "3",
                    postBodyHtml: "3",
                    postVisible: true,
                    voted: true,
                    followed: true,
                    votesCount: 3,
                    responsesCount: 3,
                    threadID: "3",
                    commentID: "3",
                    parentID: nil,
                    abuseFlagged: false)
    ]
    
    let post = Post(authorName: "1",
                    authorAvatar: "1",
                    postDate: Date(),
                    postTitle: "1",
                    postBodyHtml: "1",
                    postBody: "1",
                    postVisible: true,
                    voted: false,
                    followed: true,
                    votesCount: 1,
                    responsesCount: 1,
                    comments: [
                        Post(authorName: "1",
                             authorAvatar: "1",
                             postDate: Date(),
                             postTitle: "1",
                             postBodyHtml: "1",
                             postBody: "1",
                             postVisible: true,
                             voted: false,
                             followed: true,
                             votesCount: 1,
                             responsesCount: 1,
                             comments: [],
                             threadID: "1",
                             commentID: "1",
                             parentID: nil,
                             abuseFlagged: false,
                             closed: false)
                    ],
                    threadID: "1",
                    commentID: "1",
                    parentID: nil,
                    abuseFlagged: false,
                    closed: false
    )

    func testGetCommentsSuccess() async throws {
        let interactor = DiscussionInteractorProtocolMock()
        let router = DiscussionRouterMock()
        let config = ConfigMock()
        var result = false

        let viewModel = ResponsesViewModel(interactor: interactor,
                                           router: router,
                                           config: config,
                                           storage: CoreStorageMock(),
                                           threadStateSubject: .init(.postAdded(id: "1")))
        
        Given(interactor, .getCommentResponses(commentID: .any, page: .any,
                                               willReturn: (userComments, Pagination(next: "",
                                                                                     previous: "",
                                                                                     count: 1,
                                                                                     numPages: 1))))
        
        result = await viewModel.getResponsesData(commentID: "1", parentComment: post, page: 1)
        
        Verify(interactor, .getCommentResponses(commentID: .any, page: .any))
        
        XCTAssertTrue(result)
        XCTAssertFalse(viewModel.showError)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isShowProgress)
    }
    
    func testGetCommentsNoInternetError() async throws {
        let interactor = DiscussionInteractorProtocolMock()
        let router = DiscussionRouterMock()
        let config = ConfigMock()
        var result = false

        let viewModel = ResponsesViewModel(interactor: interactor,
                                           router: router,
                                           config: config,
                                           storage: CoreStorageMock(),
                                           threadStateSubject: .init(.postAdded(id: "1")))
        
        let noInternetError = AFError.sessionInvalidated(error: URLError(.notConnectedToInternet))
        
        Given(interactor, .getCommentResponses(commentID: .any, page: .any, willThrow: noInternetError))
        
        result = await viewModel.getResponsesData(commentID: "1", parentComment: post, page: 1)
        
        Verify(interactor, .getCommentResponses(commentID: .any, page: .any))
        
        XCTAssertFalse(result)
        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertTrue(viewModel.showError)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.slowOrNoInternetConnection)
    }
    
    func testGetCommentsUnknownError() async throws {
        let interactor = DiscussionInteractorProtocolMock()
        let router = DiscussionRouterMock()
        let config = ConfigMock()
        var result = false

        let viewModel = ResponsesViewModel(interactor: interactor,
                                           router: router,
                                           config: config,
                                           storage: CoreStorageMock(),
                                           threadStateSubject: .init(.postAdded(id: "1")))
        
        Given(interactor, .getCommentResponses(commentID: .any, page: .any, willThrow: NSError()))
        
        result = await viewModel.getResponsesData(commentID: "1", parentComment: post, page: 1)
        
        Verify(interactor, .getCommentResponses(commentID: .any, page: .any))
        
        XCTAssertFalse(result)
        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertTrue(viewModel.showError)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.unknownError)
    }

    func testPostCommentSuccess() async throws {
        let interactor = DiscussionInteractorProtocolMock()
        let router = DiscussionRouterMock()
        let config = ConfigMock()

        let viewModel = ResponsesViewModel(interactor: interactor,
                                           router: router,
                                           config: config,
                                           storage: CoreStorageMock(),
                                           threadStateSubject: .init(.postAdded(id: "1")))
        
        Given(interactor, .addCommentTo(threadID: .any, rawBody: .any, parentID: .any, willReturn: post))
        
        await viewModel.postComment(threadID: "1", rawBody: "1", parentID: nil)
        
        Verify(interactor, .addCommentTo(threadID: .any, rawBody: .any, parentID: .any))
        
        XCTAssertFalse(viewModel.showError)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isShowProgress)
    }
    
    func testPostCommentNoInternetError() async throws {
        let interactor = DiscussionInteractorProtocolMock()
        let router = DiscussionRouterMock()
        let config = ConfigMock()

        let viewModel = ResponsesViewModel(interactor: interactor,
                                           router: router,
                                           config: config,
                                           storage: CoreStorageMock(),
                                           threadStateSubject: .init(.postAdded(id: "1")))
        
        let noInternetError = AFError.sessionInvalidated(error: URLError(.notConnectedToInternet))
        
        Given(interactor, .addCommentTo(threadID: .any, rawBody: .any, parentID: .any, willThrow: noInternetError))
        
        await viewModel.postComment(threadID: "1", rawBody: "1", parentID: nil)
        
        Verify(interactor, .addCommentTo(threadID: .any, rawBody: .any, parentID: .any))
        
        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.slowOrNoInternetConnection)
    }
    
    func testPostCommentUnknownError() async throws {
        let interactor = DiscussionInteractorProtocolMock()
        let router = DiscussionRouterMock()
        let config = ConfigMock()

        let viewModel = ResponsesViewModel(interactor: interactor,
                                           router: router,
                                           config: config,
                                           storage: CoreStorageMock(),
                                           threadStateSubject: .init(.postAdded(id: "1")))
        
        Given(interactor, .addCommentTo(threadID: .any, rawBody: .any, parentID: .any, willThrow: NSError()))

        await viewModel.postComment(threadID: "1", rawBody: "1", parentID: nil)
        
        Verify(interactor, .addCommentTo(threadID: .any, rawBody: .any, parentID: .any))
        
        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.unknownError)
    }
    
    func testFetchMorePosts() async {
        let interactor = DiscussionInteractorProtocolMock()
        let router = DiscussionRouterMock()
        let config = ConfigMock()

        let viewModel = ResponsesViewModel(interactor: interactor,
                                           router: router,
                                           config: config,
                                           storage: CoreStorageMock(),
                                           threadStateSubject: .init(.postAdded(id: "1")))
        
        viewModel.totalPages = 2
        viewModel.comments = userComments
        
        Given(interactor, .getCommentResponses(commentID: .any, page: .any,
                                               willReturn: (userComments, Pagination(next: "",
                                                                                     previous: "",
                                                                                     count: 1,
                                                                                     numPages: 1))))
        
        await viewModel.fetchMorePosts(commentID: "1", parentComment: post, index: 0)
        
        Verify(interactor, .getCommentResponses(commentID: .any, page: .any))
        
        XCTAssertEqual(viewModel.comments.count, (userComments + userComments).count)
        XCTAssertFalse(viewModel.showError)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isShowProgress)
    }

}

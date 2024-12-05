//
//  ThreadViewModelTests.swift
//  DiscussionTests
//
//  Created by  Stepanok Ivan on 30.01.2023.
//

import SwiftyMocky
import XCTest
@testable import Core
@testable import Discussion
import Alamofire
import SwiftUI

@MainActor
final class ThreadViewModelTests: XCTestCase {
    
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
    
    let threads = ThreadLists(threads: [
        UserThread(id: "1",
                   author: "1",
                   authorLabel: "1",
                   createdAt: Date(),
                   updatedAt: Date(),
                   rawBody: "1",
                   renderedBody: "1",
                   voted: true,
                   voteCount: 18,
                   courseID: "1",
                   type: .question,
                   title: "1",
                   pinned: false,
                   closed: false,
                   following: false,
                   commentCount: 1,
                   avatar: "1",
                   unreadCommentCount: 1,
                   abuseFlagged: false,
                   hasEndorsed: true,
                   numPages: 2),
        UserThread(id: "2",
                   author: "2",
                   authorLabel: "2",
                   createdAt: Date(),
                   updatedAt: Date(),
                   rawBody: "2",
                   renderedBody: "2",
                   voted: false,
                   voteCount: 4,
                   courseID: "2",
                   type: .discussion,
                   title: "2",
                   pinned: false,
                   closed: false,
                   following: false,
                   commentCount: 2,
                   avatar: "2",
                   unreadCommentCount: 2,
                   abuseFlagged: false,
                   hasEndorsed: true,
                   numPages: 2),
        UserThread(id: "3",
                   author: "3",
                   authorLabel: "3",
                   createdAt: Date(),
                   updatedAt: Date(),
                   rawBody: "3",
                   renderedBody: "3",
                   voted: false,
                   voteCount: 7,
                   courseID: "3",
                   type: .discussion,
                   title: "3",
                   pinned: false,
                   closed: false,
                   following: false,
                   commentCount: 3,
                   avatar: "3",
                   unreadCommentCount: 3,
                   abuseFlagged: false,
                   hasEndorsed: true,
                   numPages: 1),
        UserThread(id: "4",
                   author: "4",
                   authorLabel: "4",
                   createdAt: Date(),
                   updatedAt: Date(),
                   rawBody: "4",
                   renderedBody: "4",
                   voted: true,
                   voteCount: 4,
                   courseID: "4",
                   type: .question,
                   title: "4",
                   pinned: false,
                   closed: false,
                   following: false,
                   commentCount: 1,
                   avatar: "4",
                   unreadCommentCount: 1,
                   abuseFlagged: false,
                   hasEndorsed: true,
                   numPages: 2),
    ])
    
    let postComments = Post(authorName: "1",
                            authorAvatar: "1",
                            postDate: Date(),
                            postTitle: "1",
                            postBodyHtml: "1",
                            postBody: "1",
                            postVisible: true,
                            voted: true,
                            followed: true,
                            votesCount: 1,
                            responsesCount: 1,
                            comments: [
                                Post(authorName: "2",
                                     authorAvatar: "2",
                                     postDate: Date(),
                                     postTitle: "2",
                                     postBodyHtml: "2",
                                     postBody: "2",
                                     postVisible: true,
                                     voted: true,
                                     followed: true,
                                     votesCount: 1,
                                     responsesCount: 1,
                                     comments: [],
                                     threadID: "2",
                                     commentID: "2",
                                     parentID: nil,
                                     abuseFlagged: false,
                                     closed: false),
                                Post(authorName: "2",
                                     authorAvatar: "2",
                                     postDate: Date(),
                                     postTitle: "2",
                                     postBodyHtml: "2",
                                     postBody: "2",
                                     postVisible: true,
                                     voted: true,
                                     followed: true,
                                     votesCount: 1,
                                     responsesCount: 1,
                                     comments: [],
                                     threadID: "2",
                                     commentID: "2",
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

    func testGetQuestionPostsSuccess() async {
        let interactor = DiscussionInteractorProtocolMock()
        let router = DiscussionRouterMock()
        let config = ConfigMock()
        var result = false

        let viewModel = ThreadViewModel(interactor: interactor,
                                        router: router,
                                        config: config,
                                        storage: CoreStorageMock(),
                                        postStateSubject: .init(.readed(id: "1")))
                
        Given(interactor, .readBody(threadID: .any, willProduce: {_ in}))
        Given(interactor,   .getQuestionComments(threadID: .any, page: .any,
                                                 willReturn: (userComments, Pagination(next: "",
                                                                                       previous: "",
                                                                                       count: 1,
                                                                                       numPages: 1))))
        
        result = await viewModel.getThreadData(thread: threads.threads[0], page: 1)
        
        Verify(interactor, .readBody(threadID: .value(threads.threads[0].id)))
        Verify(interactor, .getQuestionComments(threadID: .value(threads.threads[0].id), page: .value(1)))
        
        XCTAssertTrue(result)
        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertFalse(viewModel.showError)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testGetDiscussionPostsSuccess() async {
        let interactor = DiscussionInteractorProtocolMock()
        let router = DiscussionRouterMock()
        let config = ConfigMock()
        var result = false

        let viewModel = ThreadViewModel(interactor: interactor,
                                        router: router,
                                        config: config,
                                        storage: CoreStorageMock(),
                                        postStateSubject: .init(.readed(id: "1")))
                
        Given(interactor, .readBody(threadID: .any, willProduce: {_ in}))
        Given(interactor, .getDiscussionComments(threadID: .any, page: .any,
                                                 willReturn: (userComments, Pagination(next: "",
                                                                                       previous: "",
                                                                                       count: 1,
                                                                                       numPages: 1))))
                
        result = await viewModel.getThreadData(thread: threads.threads[1], page: 1)
        
        Verify(interactor, .readBody(threadID: .value(threads.threads[1].id)))
        Verify(interactor, .getDiscussionComments(threadID: .value(threads.threads[1].id), page: .value(1)))
        
        XCTAssertTrue(result)
        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertFalse(viewModel.showError)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testGetPostsNoInternetError() async {
        let interactor = DiscussionInteractorProtocolMock()
        let router = DiscussionRouterMock()
        let config = ConfigMock()
        var result = false

        let viewModel = ThreadViewModel(interactor: interactor,
                                        router: router,
                                        config: config,
                                        storage: CoreStorageMock(),
                                        postStateSubject: .init(.readed(id: "1")))
        
        let noInternetError = AFError.sessionInvalidated(error: URLError(.notConnectedToInternet))
                
        Given(interactor, .readBody(threadID: .any, willThrow: noInternetError))
        Given(interactor, .getQuestionComments(threadID: .any, page: .any, willThrow: noInternetError))
                
        result = await viewModel.getThreadData(thread: threads.threads[0], page: 1)
        
        viewModel.postComments = postComments
        
        Verify(interactor,    .readBody(threadID: .any))
        Verify(interactor, 0, .getQuestionComments(threadID: .any, page: .any))
        
        XCTAssertFalse(result)
        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertTrue(viewModel.showError)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.slowOrNoInternetConnection)
    }
    
    
    func testGetPostsUnknownError() async {
        let interactor = DiscussionInteractorProtocolMock()
        let router = DiscussionRouterMock()
        let config = ConfigMock()
        var result = false

        let viewModel = ThreadViewModel(interactor: interactor,
                                        router: router,
                                        config: config,
                                        storage: CoreStorageMock(),
                                        postStateSubject: .init(.readed(id: "1")))
                        
        Given(interactor, .readBody(threadID: .any, willThrow: NSError()))
        Given(interactor, .getQuestionComments(threadID: .any, page: .any, willThrow: NSError()))
                
        result = await viewModel.getThreadData(thread: threads.threads[0], page: 1)
        
        viewModel.postComments = postComments
        
        Verify(interactor,    .readBody(threadID: .value(threads.threads[0].id)))
        Verify(interactor, 0, .getQuestionComments(threadID: .value(threads.threads[0].id), page: .value(1)))
        
        XCTAssertFalse(result)
        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertTrue(viewModel.showError)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.unknownError)
    }
    
    func testPostCommentSuccess() async {
        let interactor = DiscussionInteractorProtocolMock()
        let router = DiscussionRouterMock()
        let config = ConfigMock()

        let viewModel = ThreadViewModel(interactor: interactor,
                                        router: router,
                                        config: config,
                                        storage: CoreStorageMock(),
                                        postStateSubject: .init(.readed(id: "1")))
        
        let post = Post(authorName: "",
                        authorAvatar: "",
                        postDate: Date(),
                        postTitle: "",
                        postBodyHtml: "",
                        postBody: "",
                        postVisible: true,
                        voted: true,
                        followed: true,
                        votesCount: 0,
                        responsesCount: 0,
                        comments: [],
                        threadID: "",
                        commentID: "",
                        parentID: nil,
                        abuseFlagged: true,
                        closed: false)
                
        Given(interactor, .addCommentTo(threadID: .any, rawBody: .any, parentID: .any, willReturn: post) )
                
        await viewModel.postComment(threadID: "1", rawBody: "1", parentID: nil)
        
        Verify(interactor, .addCommentTo(threadID: .value("1"), rawBody: .value("1"), parentID: .value(nil)))
        
        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertFalse(viewModel.showError)
        XCTAssertNil(viewModel.errorMessage)

    }
    
    func testPostCommentNoInternetError() async {
        let interactor = DiscussionInteractorProtocolMock()
        let router = DiscussionRouterMock()
        let config = ConfigMock()

        let viewModel = ThreadViewModel(interactor: interactor,
                                        router: router,
                                        config: config,
                                        storage: CoreStorageMock(),
                                        postStateSubject: .init(.readed(id: "1")))
        
        let noInternetError = AFError.sessionInvalidated(error: URLError(.notConnectedToInternet))
                
        Given(interactor, .addCommentTo(threadID: .any, rawBody: .any, parentID: .any, willThrow: noInternetError) )
                
        await viewModel.postComment(threadID: "1", rawBody: "1", parentID: nil)
        
        Verify(interactor, .addCommentTo(threadID: .value("1"), rawBody: .value("1"), parentID: .value(nil)))

        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertTrue(viewModel.showError)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.slowOrNoInternetConnection)
    }
    
    func testPostCommentUnknownError() async {
        let interactor = DiscussionInteractorProtocolMock()
        let router = DiscussionRouterMock()
        let config = ConfigMock()

        let viewModel = ThreadViewModel(interactor: interactor,
                                        router: router,
                                        config: config,
                                        storage: CoreStorageMock(),
                                        postStateSubject: .init(.readed(id: "1")))
                        
        Given(interactor, .addCommentTo(threadID: .any, rawBody: .any, parentID: .any, willThrow: NSError()) )
                
        await viewModel.postComment(threadID: "1", rawBody: "1", parentID: nil)
        
        Verify(interactor, .addCommentTo(threadID: .value("1"), rawBody: .value("1"), parentID: .value(nil)))

        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertTrue(viewModel.showError)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.unknownError)
    }
    
    func testFetchMorePosts() async {
        let interactor = DiscussionInteractorProtocolMock()
        let router = DiscussionRouterMock()
        let config = ConfigMock()
        var result = false
        
        let viewModel = ThreadViewModel(interactor: interactor,
                                        router: router,
                                        config: config,
                                        storage: CoreStorageMock(),
                                        postStateSubject: .init(.readed(id: "1")))
        
        viewModel.totalPages = 2
        viewModel.comments = userComments + userComments
        
        Given(interactor, .getQuestionComments(threadID: .any, page: .any,
                                               willReturn: (userComments, Pagination(next: "",
                                                                                     previous: "",
                                                                                     count: 1,
                                                                                     numPages: 1))))
        
        result = await viewModel.fetchMorePosts(thread: threads.threads[0], index: 3)
        
        XCTAssertTrue(result)
    }
}

//
//  BaseResponsesViewModelTests.swift
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
final class BaseResponsesViewModelTests: XCTestCase {
    
    let post = Post(authorName: "1",
                    authorAvatar: "1",
                    postDate: Date(),
                    postTitle: "1",
                    postBodyHtml: "1",
                    postBody: "1",
                    postVisible: true,
                    voted: false,
                    followed: false,
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
                                        voted: true,
                                        followed: false,
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
                    closed: false)
    
    var interactor: DiscussionInteractorProtocolMock!
    var router: DiscussionRouterMock!
    var config: ConfigMock!
    var viewModel: BaseResponsesViewModel!
    
    override func setUp() async throws {
        try await super.setUp()
        
        interactor = DiscussionInteractorProtocolMock()
        router = DiscussionRouterMock()
        config = ConfigMock()
        viewModel = BaseResponsesViewModel(
            interactor: interactor,
            router: router,
            config: config,
            storage: CoreStorageMock(),
            analytics: DiscussionAnalyticsMock()
        )
    }
    
    func testVoteThreadSuccess() async throws {
        let interactor = DiscussionInteractorProtocolMock()
        let router = DiscussionRouterMock()
        let config = ConfigMock()
        let viewModel = BaseResponsesViewModel(
            interactor: interactor,
            router: router,
            config: config,
            storage: CoreStorageMock(),
            analytics: DiscussionAnalyticsMock()
        )
        var result = false

        viewModel.postComments = post
        
        Given(interactor, .voteThread(voted: .any, threadID: .any, willProduce: {_ in}))
                
        result = await viewModel.vote(id: "1", isThread: true, voted: true, index: 0, courseID: "courseID")

        Verify(interactor, .voteThread(voted: .value(true), threadID: .value("1")))
        
        XCTAssertTrue(result)
        XCTAssertFalse(viewModel.postComments!.comments[0].voted)
        XCTAssertFalse(viewModel.showError)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isShowProgress)
    }
    
    func testVoteResponseSuccess() async throws {
        let interactor = DiscussionInteractorProtocolMock()
        let router = DiscussionRouterMock()
        let config = ConfigMock()
        let viewModel = BaseResponsesViewModel(
            interactor: interactor,
            router: router,
            config: config,
            storage: CoreStorageMock(),
            analytics: DiscussionAnalyticsMock()
        )

        var result = false

        viewModel.postComments = post
        viewModel.postComments?.comments[0].voted = false
        
        Given(interactor, .voteResponse(voted: .any, responseID: .any, willProduce: {_ in}))

        result = await viewModel.vote(id: "1", isThread: false, voted: true, index: 0, courseID: "courseID")

        Verify(interactor, .voteResponse(voted: .value(true), responseID: .value("1")))

        XCTAssertTrue(result)
        XCTAssertTrue(viewModel.postComments!.comments[0].voted)
        XCTAssertFalse(viewModel.showError)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isShowProgress)
    }
    
    func testVoteParentThreadSuccess() async throws {
        let interactor = DiscussionInteractorProtocolMock()
        let router = DiscussionRouterMock()
        let config = ConfigMock()
        let viewModel = BaseResponsesViewModel(
            interactor: interactor,
            router: router,
            config: config,
            storage: CoreStorageMock(),
            analytics: DiscussionAnalyticsMock()
        )

        var result = false

        viewModel.postComments = post
        
        Given(interactor, .voteThread(voted: .any, threadID: .any, willProduce: {_ in}))
         
        result = await viewModel.vote(id: "1", isThread: true, voted: true, index: nil, courseID: "courseID")

        Verify(interactor, .voteThread(voted: .value(true), threadID: .value("1")))
        
        XCTAssertTrue(result)
        XCTAssertTrue(viewModel.postComments!.voted)
        XCTAssertFalse(viewModel.showError)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isShowProgress)
    }
    
    func testVoteParentResponseSuccess() async throws {
        let interactor = DiscussionInteractorProtocolMock()
        let router = DiscussionRouterMock()
        let config = ConfigMock()
        let viewModel = BaseResponsesViewModel(
            interactor: interactor,
            router: router,
            config: config,
            storage: CoreStorageMock(),
            analytics: DiscussionAnalyticsMock()
        )

        var result = false
        
        viewModel.postComments = post

        Given(interactor, .voteResponse(voted: .any, responseID: .any, willProduce: {_ in}))

        viewModel.postComments?.voted = true

        result = await viewModel.vote(id: "2", isThread: false, voted: false, index: nil, courseID: "courseID")
        
        Verify(interactor, .voteResponse(voted: .value(false), responseID: .value("2")))

        XCTAssertTrue(result)
        XCTAssertFalse(viewModel.postComments!.voted)
        XCTAssertFalse(viewModel.showError)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isShowProgress)
    }
    
    func testVoteNoInternetError() async throws {
        let interactor = DiscussionInteractorProtocolMock()
        let router = DiscussionRouterMock()
        let config = ConfigMock()
        let viewModel = BaseResponsesViewModel(
            interactor: interactor,
            router: router,
            config: config,
            storage: CoreStorageMock(),
            analytics: DiscussionAnalyticsMock()
        )

        var result = false

        let noInternetError = AFError.sessionInvalidated(error: URLError(.notConnectedToInternet))
        
        Given(interactor, .voteThread(voted: .any, threadID: .any, willThrow: noInternetError))
        
        result = await viewModel.vote(id: "1", isThread: true, voted: true, index: 1, courseID: "courseID")
        
        Verify(interactor, .voteThread(voted: .value(true), threadID: .value("1")))
        
        XCTAssertFalse(result)
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.slowOrNoInternetConnection)
        XCTAssertFalse(viewModel.isShowProgress)
    }
    
    func testVoteUnknownError() async throws {
        let interactor = DiscussionInteractorProtocolMock()
        let router = DiscussionRouterMock()
        let config = ConfigMock()
        let viewModel = BaseResponsesViewModel(
            interactor: interactor,
            router: router,
            config: config,
            storage: CoreStorageMock(),
            analytics: DiscussionAnalyticsMock()
        )

        var result = false
        
        Given(interactor, .voteThread(voted: .any, threadID: .any, willThrow: NSError()))
        
        result = await viewModel.vote(id: "1", isThread: true, voted: true, index: nil, courseID: "courseID")
        
        Verify(interactor, .voteThread(voted: .value(true), threadID: .value("1")))
        
        XCTAssertFalse(result)
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.unknownError)
        XCTAssertFalse(viewModel.isShowProgress)
    }
    
    func testFlagThreadSuccess() async throws {
        let interactor = DiscussionInteractorProtocolMock()
        let router = DiscussionRouterMock()
        let config = ConfigMock()
        let viewModel = BaseResponsesViewModel(
            interactor: interactor,
            router: router,
            config: config,
            storage: CoreStorageMock(),
            analytics: DiscussionAnalyticsMock()
        )

        var result = false
        
        viewModel.postComments = post
        
        Given(interactor, .flagThread(abuseFlagged: .any, threadID: .any, willProduce: {_ in}))
        
        result = await viewModel.flag(id: "1", isThread: true, abuseFlagged: true, index: nil, courseID: "courseID")
        
        Verify(interactor, .flagThread(abuseFlagged: .value(true), threadID: .value("1")))
        
        XCTAssertTrue(result)
        XCTAssertTrue(viewModel.postComments!.abuseFlagged)
        XCTAssertFalse(viewModel.showError)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isShowProgress)
    }
    
    func testFlagCommentSuccess() async throws {
        let interactor = DiscussionInteractorProtocolMock()
        let router = DiscussionRouterMock()
        let config = ConfigMock()
        let viewModel = BaseResponsesViewModel(
            interactor: interactor,
            router: router,
            config: config,
            storage: CoreStorageMock(),
            analytics: DiscussionAnalyticsMock()
        )

        var result = false
        
        viewModel.postComments = post
        
        Given(interactor, .flagComment(abuseFlagged: .any, commentID: .any, willProduce: {_ in}))
        
        result = await viewModel.flag(id: "1", isThread: false, abuseFlagged: true, index: 0, courseID: "courseID")
        
        Verify(interactor, .flagComment(abuseFlagged: .value(true), commentID: .value("1")))
        
        XCTAssertTrue(result)
        XCTAssertTrue(viewModel.postComments!.comments[0].abuseFlagged)
        XCTAssertFalse(viewModel.showError)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isShowProgress)
    }
    
    func testFlagNoInternetError() async throws {
        let interactor = DiscussionInteractorProtocolMock()
        let router = DiscussionRouterMock()
        let config = ConfigMock()
        let viewModel = BaseResponsesViewModel(
            interactor: interactor,
            router: router,
            config: config,
            storage: CoreStorageMock(),
            analytics: DiscussionAnalyticsMock()
        )

        var result = false

        let noInternetError = AFError.sessionInvalidated(error: URLError(.notConnectedToInternet))
        
        Given(interactor, .flagThread(abuseFlagged: .any, threadID: .any, willThrow: noInternetError))
        
        result = await viewModel.flag(id: "1", isThread: true, abuseFlagged: true, index: 1, courseID: "courseID")
        
        Verify(interactor, .flagThread(abuseFlagged: .value(true), threadID: .value("1")))

        XCTAssertFalse(result)
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.slowOrNoInternetConnection)
        XCTAssertFalse(viewModel.isShowProgress)
    }
    
    func testFlagUnknownError() async throws {
        let interactor = DiscussionInteractorProtocolMock()
        let router = DiscussionRouterMock()
        let config = ConfigMock()
        let viewModel = BaseResponsesViewModel(
            interactor: interactor,
            router: router,
            config: config,
            storage: CoreStorageMock(),
            analytics: DiscussionAnalyticsMock()
        )

        var result = false

        Given(interactor, .flagThread(abuseFlagged: .any, threadID: .any, willThrow: NSError()))
        
        result = await viewModel.flag(id: "1", isThread: true, abuseFlagged: true, index: nil, courseID: "courseID")
        
        Verify(interactor, .flagThread(abuseFlagged: .value(true), threadID: .value("1")))

        XCTAssertFalse(result)
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.unknownError)
        XCTAssertFalse(viewModel.isShowProgress)
    }
    
    func testFollowThreadSuccess() async throws {
        let interactor = DiscussionInteractorProtocolMock()
        let router = DiscussionRouterMock()
        let config = ConfigMock()
        let viewModel = BaseResponsesViewModel(
            interactor: interactor,
            router: router,
            config: config,
            storage: CoreStorageMock(),
            analytics: DiscussionAnalyticsMock()
        )

        var result = false
        
        viewModel.postComments = post

        Given(interactor, .followThread(following: .any, threadID: .any, willProduce: {_ in}))
        
        result = await viewModel.followThread(following: true, threadID: "1")
        
        Verify(interactor, .followThread(following: .value(true), threadID: .value("1")))
        
        XCTAssertTrue(result)
        XCTAssertTrue(viewModel.postComments!.followed)
        XCTAssertFalse(viewModel.showError)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isShowProgress)
    }
    
    func testFollowThreadNoInternetError() async throws {
        let interactor = DiscussionInteractorProtocolMock()
        let router = DiscussionRouterMock()
        let config = ConfigMock()
        let viewModel = BaseResponsesViewModel(
            interactor: interactor,
            router: router,
            config: config,
            storage: CoreStorageMock(),
            analytics: DiscussionAnalyticsMock()
        )

        var result = false

        let noInternetError = AFError.sessionInvalidated(error: URLError(.notConnectedToInternet))
        
        Given(interactor, .followThread(following: .any, threadID: .any, willThrow: noInternetError))
        
        result = await viewModel.followThread(following: true, threadID: "1")

        Verify(interactor, .followThread(following: .value(true), threadID: .value("1")))

        XCTAssertFalse(result)
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.slowOrNoInternetConnection)
        XCTAssertFalse(viewModel.isShowProgress)
    }
    
    func testFollowThreadUnknownError() async throws {
        let interactor = DiscussionInteractorProtocolMock()
        let router = DiscussionRouterMock()
        let config = ConfigMock()
        let viewModel = BaseResponsesViewModel(
            interactor: interactor,
            router: router,
            config: config,
            storage: CoreStorageMock(),
            analytics: DiscussionAnalyticsMock()
        )

        var result = false

        Given(interactor, .followThread(following: .any, threadID: .any, willThrow: NSError()))
        
        result = await viewModel.followThread(following: true, threadID: "1")

        Verify(interactor, .followThread(following: .value(true), threadID: .value("1")))

        XCTAssertFalse(result)
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.unknownError)
        XCTAssertFalse(viewModel.isShowProgress)
    }
    
    func testAddNewPost() {
        let interactor = DiscussionInteractorProtocolMock()
        let router = DiscussionRouterMock()
        let config = ConfigMock()
        let viewModel = BaseResponsesViewModel(
            interactor: interactor,
            router: router,
            config: config,
            storage: CoreStorageMock(),
            analytics: DiscussionAnalyticsMock()
        )
        
        viewModel.postComments = post
        
        let newPost = Post(authorName: "new",
                           authorAvatar: "new",
                           postDate: Date(),
                           postTitle: "new",
                           postBodyHtml: "new",
                           postBody: "new",
                           postVisible: true,
                           voted: false,
                           followed: false,
                           votesCount: 0,
                           responsesCount: 0,
                           comments: [],
                           threadID: "3",
                           commentID: "3",
                           parentID: nil,
                           abuseFlagged: false,
                           closed: false)
        
        viewModel.addNewPost(newPost)
        
        XCTAssertTrue(viewModel.postComments!.comments.last!.authorName == "new")
    }
    
}

//
//  DiscussionTests.swift
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

final class PostViewModelTests: XCTestCase {
    
    let threads = ThreadLists(threads: [
        UserThread(id: "1",
                   author: "1",
                   authorLabel: "1",
                   createdAt: Date(),
                   updatedAt: Date(),
                   rawBody: "1",
                   renderedBody: "1",
                   voted: true,
                   voteCount: 1,
                   courseID: "1",
                   type: .question,
                   title: "1",
                   pinned: false,
                   following: false,
                   commentCount: 1,
                   avatar: "1",
                   unreadCommentCount: 0,
                   abuseFlagged: false,
                   hasEndorsed: true,
                   numPages: 1),
        UserThread(id: "2",
                   author: "2",
                   authorLabel: "2",
                   createdAt: Date().addingTimeInterval(TimeInterval(86400*7)),
                   updatedAt: Date().addingTimeInterval(TimeInterval(86400*7)),
                   rawBody: "2",
                   renderedBody: "2",
                   voted: false,
                   voteCount: 2,
                   courseID: "2",
                   type: .discussion,
                   title: "2",
                   pinned: false,
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
                   voteCount: 333,
                   courseID: "3",
                   type: .question,
                   title: "3",
                   pinned: false,
                   following: false,
                   commentCount: 3,
                   avatar: "3",
                   unreadCommentCount: 3,
                   abuseFlagged: false,
                   hasEndorsed: false,
                   numPages: 3),
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
                   following: false,
                   commentCount: 4,
                   avatar: "4",
                   unreadCommentCount: 4,
                   abuseFlagged: false,
                   hasEndorsed: true,
                   numPages: 4),
    ])
    
    func testGetThreadListSuccess() async throws {
        let interactor = DiscussionInteractorProtocolMock()
        let router = DiscussionRouterMock()
        let config = ConfigMock()
        var result = false
        let viewModel = PostsViewModel(interactor: interactor, router: router, config: config)
        
        viewModel.type = .allPosts

        Given(interactor, .getThreadsList(courseID: .any, type: .any, page: .any, willReturn: threads))

        viewModel.type = .allPosts
        result = await viewModel.getPostsPagination(courseID: "1")
        XCTAssertTrue(result)
        result = false
        
        viewModel.type = .courseTopics(topicID: "")
        result = await viewModel.getPostsPagination(courseID: "1")
        XCTAssertTrue(result)
        result = false
        
        viewModel.type = .followingPosts
        result = await viewModel.getPostsPagination(courseID: "1")
        XCTAssertTrue(result)
        result = false
        
        viewModel.type = .nonCourseTopics
        result = await viewModel.getPostsPagination(courseID: "1")
        XCTAssertTrue(result)
        result = false
        
        viewModel.type = .none
        result = await viewModel.getPostsPagination(courseID: "1")
        XCTAssertFalse(result)

        Verify(interactor, 4, .getThreadsList(courseID: .value("1"), type: .any, page: .value(1)))
        
        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertFalse(viewModel.showError)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testGetThreadListNoInternetError() async throws {
        let interactor = DiscussionInteractorProtocolMock()
        let router = DiscussionRouterMock()
        let config = ConfigMock()
        var result = false
        let viewModel = PostsViewModel(interactor: interactor, router: router, config: config)
        
        let noInternetError = AFError.sessionInvalidated(error: URLError(.notConnectedToInternet))

        Given(interactor, .getThreadsList(courseID: .any, type: .any, page: .any, willThrow: noInternetError))

        viewModel.type = .allPosts
        result = await viewModel.getPostsPagination(courseID: "1")

        Verify(interactor, 1, .getThreadsList(courseID: .any, type: .any, page: .any))
        
        XCTAssertFalse(result)
        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.slowOrNoInternetConnection)
    }
    
    func testGetThreadListUnknownError() async throws {
        let interactor = DiscussionInteractorProtocolMock()
        let router = DiscussionRouterMock()
        let config = ConfigMock()
        var result = false
        let viewModel = PostsViewModel(interactor: interactor, router: router, config: config)

        Given(interactor, .getThreadsList(courseID: .any, type: .any, page: .any, willThrow: NSError()))

        viewModel.type = .allPosts
        result = await viewModel.getPostsPagination(courseID: "1")

        Verify(interactor, 1, .getThreadsList(courseID: .any, type: .any, page: .any))
        
        XCTAssertFalse(result)
        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.unknownError)
    }
    
    func testSortingAndFilters() async throws {
        let interactor = DiscussionInteractorProtocolMock()
        let router = DiscussionRouterMock()
        let config = ConfigMock()
        let viewModel = PostsViewModel(interactor: interactor, router: router, config: config)
        
        viewModel.type = .allPosts
        Given(interactor, .getThreadsList(courseID: .any, type: .any, page: .any, willReturn: threads))
        
        viewModel.type = .allPosts
        viewModel.filterTitle = .allPosts
        viewModel.sortTitle = .mostActivity
        _ = await viewModel.getPostsPagination(courseID: "1")
        XCTAssertTrue(viewModel.filteredPosts[0].title == "4")
        
        viewModel.filterTitle = .unread
        viewModel.sortTitle = .recentActivity
        _ = await viewModel.getPostsPagination(courseID: "1")
        XCTAssertTrue(viewModel.filteredPosts[0].title == "2")
        XCTAssertNil(viewModel.filteredPosts.first(where: {$0.unreadCommentCount == 0}))
        
        viewModel.filterTitle = .unanswered
        viewModel.sortTitle = .mostVotes
        _ = await viewModel.getPostsPagination(courseID: "1")
        XCTAssertTrue(viewModel.filteredPosts[0].title == "3")
        XCTAssertNil(viewModel.filteredPosts.first(where: { $0.hasEndorsed }))
        
        Verify(interactor, .getThreadsList(courseID: .any, type: .any, page: .any))
    }

}

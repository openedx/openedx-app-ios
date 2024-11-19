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

@MainActor
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
                   closed: false,
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
                   voteCount: 333,
                   courseID: "3",
                   type: .question,
                   title: "3",
                   pinned: false,
                   closed: false,
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
                   closed: false,
                   following: false,
                   commentCount: 4,
                   avatar: "4",
                   unreadCommentCount: 4,
                   abuseFlagged: false,
                   hasEndorsed: true,
                   numPages: 4),
    ])

    let discussionInfo = DiscussionInfo(discussionID: "1", blackouts: [])
    
    var interactor: DiscussionInteractorProtocolMock!
    var router: DiscussionRouterMock!
    var config: ConfigMock!
    var viewModel: PostsViewModel!
    
    override func setUp() async throws {
        try await super.setUp()
        
        interactor = DiscussionInteractorProtocolMock()
        router = DiscussionRouterMock()
        config = ConfigMock()
        let storage = CoreStorageMock()

        Given(storage, .useRelativeDates(getter: false))
        
        viewModel = PostsViewModel(
            interactor: interactor,
            router: router,
            config: config,
            storage: storage
        )
    }

    func testGetThreadListSuccess() async throws {
        var result = false
        
        viewModel.courseID = "1"
        viewModel.type = .allPosts

        Given(interactor, .getThreadsList(courseID: .any, type: .any, sort: .any, filter: .any, page: .any, willReturn: threads))
        Given(interactor, .getCourseDiscussionInfo(courseID: .any, willReturn: discussionInfo))

        viewModel.type = .allPosts
        result = await viewModel.getPosts(pageNumber: 1)
        XCTAssertTrue(result)
        result = false
        
        viewModel.type = .courseTopics(topicID: "")
        result = await viewModel.getPosts(pageNumber: 1)
        XCTAssertTrue(result)
        result = false
        
        viewModel.type = .followingPosts
        result = await viewModel.getPosts(pageNumber: 1)
        XCTAssertTrue(result)
        result = false
        
        viewModel.type = .nonCourseTopics
        result = await viewModel.getPosts(pageNumber: 1)
        XCTAssertTrue(result)
        result = false

        Verify(interactor, 4, .getThreadsList(courseID: .value("1"), type: .any, sort: .any, filter: .any, page: .value(1)))
        
        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertFalse(viewModel.showError)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testGetThreadListNoInternetError() async throws {
        var result = false
        
        viewModel.isBlackedOut = false

        let noInternetError = AFError.sessionInvalidated(error: URLError(.notConnectedToInternet))

        Given(interactor, .getThreadsList(courseID: .any, type: .any, sort: .any, filter: .any, page: .any, willThrow: noInternetError))
        Given(interactor, .getCourseDiscussionInfo(courseID: .any, willThrow: noInternetError))

        viewModel.courseID = "1"
        viewModel.type = .allPosts
        result = await viewModel.getPosts(pageNumber: 1)

        Verify(interactor, 1, .getThreadsList(courseID: .any, type: .any, sort: .any, filter: .any, page: .any))
        
        XCTAssertFalse(result)
        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.slowOrNoInternetConnection)
    }
    
    func testGetThreadListUnknownError() async throws {
        var result = false
                
        viewModel.isBlackedOut = false

        Given(interactor, .getThreadsList(courseID: .any, type: .any, sort: .any, filter: .any, page: .any, willThrow: NSError()))
        Given(interactor, .getCourseDiscussionInfo(courseID: .any, willThrow: NSError()))

        viewModel.courseID = "1"
        viewModel.type = .allPosts
        result = await viewModel.getPosts(pageNumber: 1)

        Verify(interactor, 1, .getThreadsList(courseID: .any, type: .any, sort: .any, filter: .any, page: .any))
        
        XCTAssertFalse(result)
        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.unknownError)
    }
    
    func testSortingAndFilters() async throws {
       
        Given(interactor, .getThreadsList(courseID: .any, type: .any, sort: .any, filter: .any, page: .any,
                                          willReturn: threads))
        Given(interactor, .getCourseDiscussionInfo(courseID: "1", willReturn: discussionInfo))
        
        viewModel.courseID = "1"
        viewModel.type = .allPosts
        viewModel.sortTitle = .mostActivity
        _ = await viewModel.getPosts(pageNumber: 1)
        XCTAssertTrue(viewModel.filteredPosts[0].title == "1")
        
        Given(interactor, .getThreadsList(courseID: .any, type: .any, sort: .value(.recentActivity), filter: .any, page: .any,
                                          willReturn: threads))
        
        viewModel.filterTitle = .unread
        viewModel.sortTitle = .recentActivity
        _ = await viewModel.getPosts(pageNumber: 1)
        XCTAssertTrue(viewModel.filteredPosts[0].title == "1")
        XCTAssertNotNil(viewModel.filteredPosts.first(where: {$0.unreadCommentCount == 4}))
        
        Given(interactor, .getThreadsList(courseID: .any, type: .any, sort: .value(.mostVotes), filter: .any, page: .any,
                                          willReturn: threads))
        
        viewModel.filterTitle = .unanswered
        viewModel.sortTitle = .mostVotes
        _ = await viewModel.getPosts(pageNumber: 1)
        XCTAssertTrue(viewModel.filteredPosts[0].title == "1")
        XCTAssertNotNil(viewModel.filteredPosts.first(where: { $0.hasEndorsed }))
        
        Verify(interactor, .getThreadsList(courseID: .any, type: .any, sort: .any, filter: .any, page: .any))
    }

}

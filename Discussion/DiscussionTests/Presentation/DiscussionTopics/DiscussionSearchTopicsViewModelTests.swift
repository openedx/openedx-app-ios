//
//  DiscussionSearchTopicsViewModelTests.swift
//  DiscussionTests
//
//  Created by  Stepanok Ivan on 24.02.2023.
//

import XCTest
@testable import Core
@testable import Discussion
import Alamofire
import SwiftUI

@MainActor
final class DiscussionSearchTopicsViewModelTests: XCTestCase {

    func testSearchSuccess() async throws {
        let interactor = DiscussionInteractorProtocolMock()
        let router = DiscussionRouterMock()
        let storage = CoreStorageMock()
        storage.useRelativeDates = false

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

        interactor.searchThreadsHandler = { _, _, _ in items }

        let viewModel = DiscussionSearchTopicsViewModel(courseID: "123",
                                                        interactor: interactor,
                                                        storage: storage,
                                                        router: router,
                                                        debounceInterval: 0.1)

        viewModel.searchText = "Test"

        // Wait for debounce + next event loop iteration
        try await Task.sleep(nanoseconds: UInt64(0.5 * Double(NSEC_PER_SEC)))
        await Task.yield()

        XCTAssertEqual(interactor.searchThreadsCallCount, 1)
        XCTAssertFalse(viewModel.showError)
        XCTAssertFalse(viewModel.fetchInProgress)
    }

    func testSearchNoInternetError() async throws {
        let interactor = DiscussionInteractorProtocolMock()
        let router = DiscussionRouterMock()
        let storage = CoreStorageMock()
        storage.useRelativeDates = false

        let noInternetError = AFError.sessionInvalidated(error: URLError(.notConnectedToInternet))

        interactor.searchThreadsHandler = { _, _, _ in throw noInternetError }

        let viewModel = DiscussionSearchTopicsViewModel(courseID: "123",
                                                        interactor: interactor,
                                                        storage: storage,
                                                        router: router,
                                                        debounceInterval: 0.1)

        viewModel.searchText = "Test"

        // Wait for debounce + next event loop iteration
        try await Task.sleep(nanoseconds: UInt64(0.5 * Double(NSEC_PER_SEC)))
        await Task.yield()

        XCTAssertEqual(interactor.searchThreadsCallCount, 1)
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.slowOrNoInternetConnection)
        XCTAssertFalse(viewModel.fetchInProgress)
    }

    func testSearchUnknownError() async throws {
        let interactor = DiscussionInteractorProtocolMock()
        let router = DiscussionRouterMock()
        let storage = CoreStorageMock()
        storage.useRelativeDates = false

        interactor.searchThreadsHandler = { _, _, _ in throw NSError(domain: "error", code: -1, userInfo: nil) }

        let viewModel = DiscussionSearchTopicsViewModel(courseID: "123",
                                                        interactor: interactor,
                                                        storage: storage,
                                                        router: router,
                                                        debounceInterval: 0.1)

        viewModel.searchText = "Test"

        // Wait for debounce + next event loop iteration
        try await Task.sleep(nanoseconds: UInt64(0.5 * Double(NSEC_PER_SEC)))
        await Task.yield()

        XCTAssertEqual(interactor.searchThreadsCallCount, 1)
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.unknownError)
        XCTAssertFalse(viewModel.fetchInProgress)
    }

    func testEmptyQuerySuccess() async throws {
        let interactor = DiscussionInteractorProtocolMock()
        let router = DiscussionRouterMock()
        let storage = CoreStorageMock()
        storage.useRelativeDates = false

        let viewModel = DiscussionSearchTopicsViewModel(courseID: "123",
                                                        interactor: interactor,
                                                        storage: storage,
                                                        router: router,
                                                        debounceInterval: 0.1)

        viewModel.searchText = ""

        // Wait for debounce + next event loop iteration
        try await Task.sleep(nanoseconds: UInt64(0.5 * Double(NSEC_PER_SEC)))
        await Task.yield()

        XCTAssertEqual(interactor.searchThreadsCallCount, 0)
        XCTAssertFalse(viewModel.showError)
        XCTAssertFalse(viewModel.fetchInProgress)
    }
}

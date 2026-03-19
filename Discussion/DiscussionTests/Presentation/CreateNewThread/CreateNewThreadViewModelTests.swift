//
//  CreateNewThreadViewModelTests.swift
//  DiscussionTests
//
//  Created by  Stepanok Ivan on 31.01.2023.
//

import XCTest
@testable import Core
@testable import Discussion
import Alamofire
import SwiftUI

@MainActor
final class CreateNewThreadViewModelTests: XCTestCase {

    let newThread = DiscussionNewThread(
        courseID: "1",
        topicID: "1",
        type: .discussion,
        title: "1",
        rawBody: "1",
        followPost: false
    )

    func testCreateNewThreadSuccess() async {
        let interactor = DiscussionInteractorProtocolMock()
        let router = DiscussionRouterMock()
        let config = ConfigProtocolMock()
        var result = false

        interactor.createNewThreadHandler = { _ in }

        let viewModel = CreateNewThreadViewModel(
            interactor: interactor,
            router: router,
            config: config,
            analytics: DiscussionAnalyticsMock(),
            storage: CoreStorageMock()
        )

        result = await viewModel.createNewThread(newThread: newThread)

        XCTAssertEqual(interactor.createNewThreadCallCount, 1)
        XCTAssertEqual(router.backCallCount, 1)

        XCTAssertTrue(result)
        XCTAssertFalse(viewModel.showError)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isShowProgress)
    }

    func testCreateNewThreadNoInternetError() async {
        let interactor = DiscussionInteractorProtocolMock()
        let router = DiscussionRouterMock()
        let config = ConfigProtocolMock()
        var result = false

        let noInternetError = AFError.sessionInvalidated(error: URLError(.notConnectedToInternet))

        interactor.createNewThreadHandler = { _ in throw noInternetError }

        let viewModel = CreateNewThreadViewModel(
            interactor: interactor,
            router: router,
            config: config,
            analytics: DiscussionAnalyticsMock(),
            storage: CoreStorageMock()
        )

        result = await viewModel.createNewThread(newThread: newThread)

        XCTAssertEqual(interactor.createNewThreadCallCount, 1)
        XCTAssertEqual(router.backCallCount, 0)

        XCTAssertFalse(result)
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.slowOrNoInternetConnection)
        XCTAssertFalse(viewModel.isShowProgress)
    }

    func testCreateNewThreadUnknownError() async {
        let interactor = DiscussionInteractorProtocolMock()
        let router = DiscussionRouterMock()
        let config = ConfigProtocolMock()
        var result = false

        interactor.createNewThreadHandler = { _ in throw NSError(domain: "error", code: -1, userInfo: nil) }

        let viewModel = CreateNewThreadViewModel(
            interactor: interactor,
            router: router,
            config: config,
            analytics: DiscussionAnalyticsMock(),
            storage: CoreStorageMock()
        )

        result = await viewModel.createNewThread(newThread: newThread)

        XCTAssertEqual(interactor.createNewThreadCallCount, 1)
        XCTAssertEqual(router.backCallCount, 0)

        XCTAssertFalse(result)
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.unknownError)
        XCTAssertFalse(viewModel.isShowProgress)
    }
}

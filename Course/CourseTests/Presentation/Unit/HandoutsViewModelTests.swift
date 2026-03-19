//
//  HandoutsViewModelTests.swift
//  CourseTests
//
//  Created by  Stepanok Ivan on 28.02.2023.
//

import XCTest
@testable import Core
@testable import Course
import Alamofire
import SwiftUI

@MainActor
final class HandoutsViewModelTests: XCTestCase {

    func testGetHandoutsSuccess() async throws {
        let interactor = CourseInteractorProtocolMock()
        let router = CourseRouterMock()
        let connectivity = ConnectivityProtocolMock()

        let courseUpdate = [CourseUpdate(id: 1, date: "1", content: "Update", status: "1")]

        interactor.getHandoutsHandler = { _ in "Result" }
        interactor.getUpdatesHandler = { _ in courseUpdate }

        let viewModel = HandoutsViewModel(
            interactor: interactor,
            router: router,
            cssInjector: CSSInjectorMock(),
            connectivity: connectivity,
            courseID: "123",
            analytics: CourseAnalyticsMock())

        await viewModel.getHandouts(courseID: "")

        XCTAssertEqual(interactor.getHandoutsCallCount, 1)
        XCTAssertEqual(viewModel.handouts, "Result")
        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.showError)
    }

    func testGetHandoutsNoInternetError() async throws {
        let interactor = CourseInteractorProtocolMock()
        let router = CourseRouterMock()
        let connectivity = ConnectivityProtocolMock()

        let noInternetError = AFError.sessionInvalidated(error: URLError(.notConnectedToInternet))

        interactor.getHandoutsHandler = { _ in throw noInternetError }
        interactor.getUpdatesHandler = { _ in throw noInternetError }

        let viewModel = HandoutsViewModel(
            interactor: interactor,
            router: router,
            cssInjector: CSSInjectorMock(),
            connectivity: connectivity,
            courseID: "123",
            analytics: CourseAnalyticsMock())

        await viewModel.getHandouts(courseID: "")

        XCTAssertEqual(interactor.getHandoutsCallCount, 1)
        XCTAssertNil(viewModel.handouts)
        XCTAssertFalse(viewModel.isShowProgress)
    }

    func testGetHandoutsUnknownError() async throws {
        let interactor = CourseInteractorProtocolMock()
        let router = CourseRouterMock()
        let connectivity = ConnectivityProtocolMock()

        interactor.getHandoutsHandler = { _ in throw NSError(domain: "error", code: -1, userInfo: nil) }
        interactor.getUpdatesHandler = { _ in throw NSError(domain: "error", code: -1, userInfo: nil) }

        let viewModel = HandoutsViewModel(
            interactor: interactor,
            router: router,
            cssInjector: CSSInjectorMock(),
            connectivity: connectivity,
            courseID: "123",
            analytics: CourseAnalyticsMock())

        await viewModel.getHandouts(courseID: "")

        XCTAssertEqual(interactor.getHandoutsCallCount, 1)
        XCTAssertNil(viewModel.handouts)
        XCTAssertFalse(viewModel.isShowProgress)
    }

    func testGetUpdatesSuccess() async throws {
        let interactor = CourseInteractorProtocolMock()
        let router = CourseRouterMock()
        let connectivity = ConnectivityProtocolMock()

        let courseUpdate = [CourseUpdate(id: 1, date: "1", content: "Update", status: "1")]

        interactor.getUpdatesHandler = { _ in courseUpdate }

        let viewModel = HandoutsViewModel(
            interactor: interactor,
            router: router,
            cssInjector: CSSInjectorMock(),
            connectivity: connectivity,
            courseID: "123",
            analytics: CourseAnalyticsMock())

        await viewModel.getUpdates(courseID: "")

        XCTAssertEqual(interactor.getUpdatesCallCount, 1)
        XCTAssertEqual(viewModel.updates[0].content, "Update")
        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.showError)
    }

    func testGetUpdatesNoInternetError() async throws {
        let interactor = CourseInteractorProtocolMock()
        let router = CourseRouterMock()
        let connectivity = ConnectivityProtocolMock()

        let viewModel = HandoutsViewModel(
            interactor: interactor,
            router: router,
            cssInjector: CSSInjectorMock(),
            connectivity: connectivity,
            courseID: "123",
            analytics: CourseAnalyticsMock())

        let noInternetError = AFError.sessionInvalidated(error: URLError(.notConnectedToInternet))

        interactor.getUpdatesHandler = { _ in throw noInternetError }

        await viewModel.getUpdates(courseID: "")

        XCTAssertEqual(interactor.getUpdatesCallCount, 1)
        XCTAssertTrue(viewModel.updates.isEmpty)
        XCTAssertFalse(viewModel.isShowProgress)
    }

    func testGetUpdatesUnknownError() async throws {
        let interactor = CourseInteractorProtocolMock()
        let router = CourseRouterMock()
        let connectivity = ConnectivityProtocolMock()

        let viewModel = HandoutsViewModel(
            interactor: interactor,
            router: router,
            cssInjector: CSSInjectorMock(),
            connectivity: connectivity,
            courseID: "123",
            analytics: CourseAnalyticsMock())

        interactor.getUpdatesHandler = { _ in throw NSError(domain: "error", code: -1, userInfo: nil) }

        await viewModel.getUpdates(courseID: "")

        XCTAssertEqual(interactor.getUpdatesCallCount, 1)
        XCTAssertTrue(viewModel.updates.isEmpty)
        XCTAssertFalse(viewModel.isShowProgress)
    }
}

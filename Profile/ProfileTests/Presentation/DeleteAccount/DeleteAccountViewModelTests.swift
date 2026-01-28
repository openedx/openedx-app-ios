//
//  DeleteAccountViewModelTests.swift
//  ProfileTests
//
//  Created by  Stepanok Ivan on 07.03.2023.
//

import XCTest
@testable import Core
@testable import Profile
import OEXFoundation
import Alamofire
import SwiftUI

@MainActor
final class DeleteAccountViewModelTests: XCTestCase {

    func testDeletingAccountSuccess() async throws {
        let interactor = ProfileInteractorProtocolMock()
        let router = ProfileRouterMock()
        let connectivity = ConnectivityProtocolMock()
        let analytics = ProfileAnalyticsMock()

        interactor.deleteAccountHandler = { _ in true }
        router.showLoginScreenHandler = { _ in }

        let viewModel = DeleteAccountViewModel(
            interactor: interactor,
            router: router,
            connectivity: connectivity,
            analytics: analytics
        )

        try await viewModel.deleteAccount(password: "123")

        XCTAssertEqual(interactor.deleteAccountCallCount, 1)
        XCTAssertEqual(router.showLoginScreenCallCount, 1)
    }

    func testDeletingAccountWrongPassword() async throws {
        let interactor = ProfileInteractorProtocolMock()
        let router = ProfileRouterMock()
        let connectivity = ConnectivityProtocolMock()
        let analytics = ProfileAnalyticsMock()

        interactor.deleteAccountHandler = { _ in false }

        let viewModel = DeleteAccountViewModel(
            interactor: interactor,
            router: router,
            connectivity: connectivity,
            analytics: analytics
        )

        try await viewModel.deleteAccount(password: "123")

        XCTAssertEqual(interactor.deleteAccountCallCount, 1)
        XCTAssertEqual(router.showLoginScreenCallCount, 0)

        XCTAssertTrue(viewModel.incorrectPassword)
    }

    func testDeletingUserAccountNotActivatedError() async throws {
        let interactor = ProfileInteractorProtocolMock()
        let router = ProfileRouterMock()
        let connectivity = ConnectivityProtocolMock()
        let analytics = ProfileAnalyticsMock()

        let validationError = CustomValidationError(statusCode: 401, data: ["error_code": "user_not_active"])
        let error = AFError.responseValidationFailed(
            reason: AFError.ResponseValidationFailureReason.customValidationFailed(error: validationError)
        )

        interactor.deleteAccountHandler = { _ in throw error }

        let viewModel = DeleteAccountViewModel(
            interactor: interactor,
            router: router,
            connectivity: connectivity,
            analytics: analytics
        )

        try await viewModel.deleteAccount(password: "123")

        XCTAssertEqual(interactor.deleteAccountCallCount, 1)
        XCTAssertEqual(router.showLoginScreenCallCount, 0)

        XCTAssertFalse(viewModel.incorrectPassword)
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.userNotActive)
    }

    func testDeletingUserUnknownError() async throws {
        let interactor = ProfileInteractorProtocolMock()
        let router = ProfileRouterMock()
        let connectivity = ConnectivityProtocolMock()
        let analytics = ProfileAnalyticsMock()

        interactor.deleteAccountHandler = { _ in throw NSError(domain: "error", code: -1, userInfo: nil) }

        let viewModel = DeleteAccountViewModel(
            interactor: interactor,
            router: router,
            connectivity: connectivity,
            analytics: analytics
        )

        try await viewModel.deleteAccount(password: "123")

        XCTAssertEqual(interactor.deleteAccountCallCount, 1)
        XCTAssertEqual(router.showLoginScreenCallCount, 0)

        XCTAssertFalse(viewModel.incorrectPassword)
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.unknownError)
    }

    func testDeletingUserNoInternetError() async throws {
        let interactor = ProfileInteractorProtocolMock()
        let router = ProfileRouterMock()
        let connectivity = ConnectivityProtocolMock()
        let analytics = ProfileAnalyticsMock()

        let noInternetError = AFError.sessionInvalidated(error: URLError(.notConnectedToInternet))

        interactor.deleteAccountHandler = { _ in throw noInternetError }

        let viewModel = DeleteAccountViewModel(
            interactor: interactor,
            router: router,
            connectivity: connectivity,
            analytics: analytics
        )

        try await viewModel.deleteAccount(password: "123")

        XCTAssertEqual(interactor.deleteAccountCallCount, 1)
        XCTAssertEqual(router.showLoginScreenCallCount, 0)

        XCTAssertFalse(viewModel.incorrectPassword)
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.slowOrNoInternetConnection)
    }
}

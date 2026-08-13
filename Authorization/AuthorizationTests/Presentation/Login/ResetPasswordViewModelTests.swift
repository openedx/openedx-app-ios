//
//  ResetPasswordViewModelTests.swift
//  AuthorizationTests
//
//  Created by  Stepanok Ivan on 04.04.2023.
//

import XCTest
@testable import Core
@testable import Authorization
import OEXFoundation
import Alamofire
import SwiftUI

@MainActor
final class ResetPasswordViewModelTests: XCTestCase {

    func testResetPasswordValidationEmailError() async throws {
        let interactor = AuthInteractorProtocolMock()
        let router = AuthorizationRouterMock()
        let validator = Validator()
        let analytics = AuthorizationAnalyticsMock()
        let viewModel = ResetPasswordViewModel(interactor: interactor,
                                               router: router,
                                               analytics: analytics,
                                               validator: validator)

        var isRecoveryPassword = true
        let binding = Binding(get: {
            return isRecoveryPassword
        }, set: { value in
            isRecoveryPassword = value
        })

        await viewModel.resetPassword(email: "e", isRecovered: binding)

        XCTAssertEqual(interactor.resetPasswordCallCount, 0)

        XCTAssertEqual(viewModel.errorMessage, AuthLocalization.Error.invalidEmailAddress)
        XCTAssertEqual(viewModel.isShowProgress, false)
        XCTAssertEqual(isRecoveryPassword, true)
    }

    func testResetPasswordSuccess() async throws {
        let interactor = AuthInteractorProtocolMock()
        let router = AuthorizationRouterMock()
        let validator = Validator()
        let analytics = AuthorizationAnalyticsMock()
        let viewModel = ResetPasswordViewModel(interactor: interactor,
                                               router: router,
                                               analytics: analytics,
                                               validator: validator)

        var isRecoveryPassword = true
        let binding = Binding(get: {
            return isRecoveryPassword
        }, set: { value in
            isRecoveryPassword = value
        })

        let data = ResetPassword(success: true, responseText: "Success")
        interactor.resetPasswordHandler = { _ in data }

        await viewModel.resetPassword(email: "edxUser@edx.com", isRecovered: binding)

        XCTAssertEqual(interactor.resetPasswordCallCount, 1)

        XCTAssertFalse(isRecoveryPassword)
        XCTAssertEqual(viewModel.errorMessage, nil)
        XCTAssertEqual(viewModel.isShowProgress, false)
        XCTAssertEqual(isRecoveryPassword, false)
    }

    func testResetPasswordErrorValidation() async throws {
        let interactor = AuthInteractorProtocolMock()
        let router = AuthorizationRouterMock()
        let validator = Validator()
        let analytics = AuthorizationAnalyticsMock()
        let viewModel = ResetPasswordViewModel(interactor: interactor,
                                               router: router,
                                               analytics: analytics,
                                               validator: validator)

        let validationErrorMessage = "Some error"
        let validationError = CustomValidationError(statusCode: 400, data: ["value": validationErrorMessage])
        let error = AFError.responseValidationFailed(reason: AFError.ResponseValidationFailureReason.customValidationFailed(error: validationError))

        interactor.resetPasswordHandler = { _ in throw error }

        var isRecoveryPassword = true
        let binding = Binding(get: {
            return isRecoveryPassword
        }, set: { value in
            isRecoveryPassword = value
        })

        await viewModel.resetPassword(email: "edxUser@edx.com", isRecovered: binding)

        XCTAssertEqual(interactor.resetPasswordCallCount, 1)

        XCTAssertEqual(viewModel.errorMessage, validationErrorMessage)
        XCTAssertEqual(viewModel.isShowProgress, false)
        XCTAssertEqual(isRecoveryPassword, true)
    }

    func testResetPasswordErrorInvalidGrant() async throws {
        let interactor = AuthInteractorProtocolMock()
        let router = AuthorizationRouterMock()
        let validator = Validator()
        let analytics = AuthorizationAnalyticsMock()
        let viewModel = ResetPasswordViewModel(interactor: interactor,
                                               router: router,
                                               analytics: analytics,
                                               validator: validator)

        interactor.resetPasswordHandler = { _ in throw APIError.invalidGrant }

        var isRecoveryPassword = true
        let binding = Binding(get: {
            return isRecoveryPassword
        }, set: { value in
            isRecoveryPassword = value
        })

        await viewModel.resetPassword(email: "edxUser@edx.com", isRecovered: binding)

        XCTAssertEqual(interactor.resetPasswordCallCount, 1)

        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.invalidCredentials)
        XCTAssertEqual(viewModel.isShowProgress, false)
        XCTAssertEqual(isRecoveryPassword, true)
    }

    func testResetPasswordErrorUnknown() async throws {
        let interactor = AuthInteractorProtocolMock()
        let router = AuthorizationRouterMock()
        let validator = Validator()
        let analytics = AuthorizationAnalyticsMock()
        let viewModel = ResetPasswordViewModel(interactor: interactor,
                                               router: router,
                                               analytics: analytics,
                                               validator: validator)

        interactor.resetPasswordHandler = { _ in throw NSError(domain: "error", code: -1, userInfo: nil) }

        var isRecoveryPassword = true
        let binding = Binding(get: {
            return isRecoveryPassword
        }, set: { value in
            isRecoveryPassword = value
        })

        await viewModel.resetPassword(email: "edxUser@edx.com", isRecovered: binding)

        XCTAssertEqual(interactor.resetPasswordCallCount, 1)

        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.unknownError)
        XCTAssertEqual(viewModel.isShowProgress, false)
        XCTAssertEqual(isRecoveryPassword, true)
    }

    func testResetPasswordNoInternetError() async throws {
        let interactor = AuthInteractorProtocolMock()
        let router = AuthorizationRouterMock()
        let validator = Validator()
        let analytics = AuthorizationAnalyticsMock()
        let viewModel = ResetPasswordViewModel(interactor: interactor,
                                               router: router,
                                               analytics: analytics,
                                               validator: validator)

        let noInternetError = AFError.sessionInvalidated(error: URLError(.notConnectedToInternet))

        interactor.resetPasswordHandler = { _ in throw noInternetError }

        var isRecoveryPassword = true
        let binding = Binding(get: {
            return isRecoveryPassword
        }, set: { value in
            isRecoveryPassword = value
        })

        await viewModel.resetPassword(email: "edxUser@edx.com", isRecovered: binding)

        XCTAssertEqual(interactor.resetPasswordCallCount, 1)

        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.slowOrNoInternetConnection)
        XCTAssertEqual(viewModel.isShowProgress, false)
        XCTAssertEqual(isRecoveryPassword, true)
    }

}

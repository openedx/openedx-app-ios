//
//  ResetPasswordViewModelTests.swift
//  AuthorizationTests
//
//  Created by  Stepanok Ivan on 04.04.2023.
//

import SwiftyMocky
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

        Verify(interactor, 0, .resetPassword(email: .any))

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
        Given(interactor, .resetPassword(email: .any, willReturn: data))

        await viewModel.resetPassword(email: "edxUser@edx.com", isRecovered: binding)

        Verify(interactor, 1, .resetPassword(email: .any))

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

        Given(interactor, .resetPassword(email: .any, willThrow: error))

        var isRecoveryPassword = true
        let binding = Binding(get: {
            return isRecoveryPassword
        }, set: { value in
            isRecoveryPassword = value
        })

        await viewModel.resetPassword(email: "edxUser@edx.com", isRecovered: binding)

        Verify(interactor, 1, .resetPassword(email: .any))

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

        Given(interactor, .resetPassword(email: .any, willThrow: APIError.invalidGrant))

        var isRecoveryPassword = true
        let binding = Binding(get: {
            return isRecoveryPassword
        }, set: { value in
            isRecoveryPassword = value
        })

        await viewModel.resetPassword(email: "edxUser@edx.com", isRecovered: binding)

        Verify(interactor, 1, .resetPassword(email: .any))

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

        Given(interactor, .resetPassword(email: .any, willThrow: NSError()))

        var isRecoveryPassword = true
        let binding = Binding(get: {
            return isRecoveryPassword
        }, set: { value in
            isRecoveryPassword = value
        })

        await viewModel.resetPassword(email: "edxUser@edx.com", isRecovered: binding)

        Verify(interactor, 1, .resetPassword(email: .any))

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

        Given(interactor, .resetPassword(email: .any, willThrow: noInternetError))

        var isRecoveryPassword = true
        let binding = Binding(get: {
            return isRecoveryPassword
        }, set: { value in
            isRecoveryPassword = value
        })

        await viewModel.resetPassword(email: "edxUser@edx.com", isRecovered: binding)

        Verify(interactor, 1, .resetPassword(email: .any))

        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.slowOrNoInternetConnection)
        XCTAssertEqual(viewModel.isShowProgress, false)
        XCTAssertEqual(isRecoveryPassword, true)
    }

}

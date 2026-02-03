//
//  SignInViewModelTests.swift
//  AuthorizationTests
//
//  Created by Vladimir Chekyrta on 10.01.2023.
//

import XCTest
@testable import Core
@testable import Authorization
import OEXFoundation
import Alamofire
import SwiftUI

@MainActor
final class SignInViewModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLoginValidationEmailError() async throws {
        let interactor = AuthInteractorProtocolMock()
        let router = AuthorizationRouterMock()
        let validator = Validator()
        let analytics = AuthorizationAnalyticsMock()
        let viewModel = SignInViewModel(
            interactor: interactor,
            router: router,
            config: ConfigMock(),
            analytics: analytics,
            validator: validator,
            storage: CoreStorageMock(),
            sourceScreen: .default
        )

        await viewModel.login(username: "", password: "")

        XCTAssertEqual(interactor.loginCallCount, 0)
        XCTAssertEqual(router.showMainOrWhatsNewScreenCallCount, 0)

        XCTAssertEqual(viewModel.errorMessage, AuthLocalization.Error.invalidEmailAddressOrUsername)
        XCTAssertEqual(viewModel.isShowProgress, false)
    }

    func testLoginValidationPasswordError() async throws {
        let interactor = AuthInteractorProtocolMock()
        let router = AuthorizationRouterMock()
        let validator = Validator()
        let analytics = AuthorizationAnalyticsMock()
        let viewModel = SignInViewModel(
            interactor: interactor,
            router: router,
            config: ConfigMock(),
            analytics: analytics,
            validator: validator,
            storage: CoreStorageMock(),
            sourceScreen: .default
        )
        await viewModel.login(username: "edxUser@edx.com", password: "")

        XCTAssertEqual(interactor.loginCallCount, 0)
        XCTAssertEqual(router.showMainOrWhatsNewScreenCallCount, 0)

        XCTAssertEqual(viewModel.errorMessage, AuthLocalization.Error.invalidPasswordLenght)
        XCTAssertEqual(viewModel.isShowProgress, false)
    }

    func testLoginSuccess() async throws {
        let interactor = AuthInteractorProtocolMock()
        let router = AuthorizationRouterMock()
        let validator = Validator()
        let analytics = AuthorizationAnalyticsMock()
        let viewModel = SignInViewModel(
            interactor: interactor,
            router: router,
            config: ConfigMock(),
            analytics: analytics,
            validator: validator,
            storage: CoreStorageMock(),
            sourceScreen: .default
        )
        let user = User(id: 1, username: "username", email: "edxUser@edx.com", name: "Name", userAvatar: "")

        interactor.loginHandler = { _, _ in user }

        await viewModel.login(username: "edxUser@edx.com", password: "password123")

        XCTAssertEqual(interactor.loginCallCount, 1)
        XCTAssertEqual(analytics.userLoginCallCount, 1)
        XCTAssertEqual(router.showMainOrWhatsNewScreenCallCount, 1)

        XCTAssertEqual(viewModel.errorMessage, nil)
        XCTAssertEqual(viewModel.isShowProgress, true)
    }

    func testSSOLoginSuccess() async throws {
        let interactor = AuthInteractorProtocolMock()
        let router = AuthorizationRouterMock()
        let validator = Validator()
        let analytics = AuthorizationAnalyticsMock()
        let viewModel = SignInViewModel(
            interactor: interactor,
            router: router,
            config: ConfigMock(),
            analytics: analytics,
            validator: validator,
            storage: CoreStorageMock(),
            sourceScreen: .default
        )
        let user = User(id: 1, username: "username", email: "edxUser@edx.com", name: "Name", userAvatar: "")

        interactor.loginSsoTokenHandler = { _ in user }

        await viewModel.ssoLogin(title: "Riyadah")

        XCTAssertEqual(interactor.loginSsoTokenCallCount, 1)
        XCTAssertEqual(router.showMainOrWhatsNewScreenCallCount, 1)

        XCTAssertEqual(viewModel.errorMessage, nil)
        XCTAssertEqual(viewModel.isShowProgress, true)
    }

    func testSocialLoginSuccess() async throws {
        let interactor = AuthInteractorProtocolMock()
        let router = AuthorizationRouterMock()
        let validator = Validator()
        let analytics = AuthorizationAnalyticsMock()
        let viewModel = SignInViewModel(
            interactor: interactor,
            router: router,
            config: ConfigMock(),
            analytics: analytics,
            validator: validator,
            storage: CoreStorageMock(),
            sourceScreen: .default
        )

        let result: Result<SocialAuthDetails, Error> = .success(.apple(
            .init(name: "name", email: "email", token: "239i2oi3jrf2jflkj23lf2f"))
        )
        let user = User(id: 1, username: "username", email: "edxUser@edx.com", name: "Name", userAvatar: "")

        interactor.loginExternalTokenHandler = { _, _ in user }

        await viewModel.login(with: result)

        XCTAssertEqual(interactor.loginExternalTokenCallCount, 1)
        XCTAssertEqual(analytics.userLoginCallCount, 1)
        XCTAssertEqual(router.showMainOrWhatsNewScreenCallCount, 1)

        XCTAssertEqual(viewModel.errorMessage, nil)
        XCTAssertEqual(viewModel.isShowProgress, true)
    }

    func testSocialLoginErrorValidation() async throws {
        let interactor = AuthInteractorProtocolMock()
        let router = AuthorizationRouterMock()
        let validator = Validator()
        let analytics = AuthorizationAnalyticsMock()
        let viewModel = SignInViewModel(
            interactor: interactor,
            router: router,
            config: ConfigMock(),
            analytics: analytics,
            validator: validator,
            storage: CoreStorageMock(),
            sourceScreen: .default
        )

        let result: Result<SocialAuthDetails, Error> = .success(
            .apple(.init(name: "name", email: "email", token: "239i2oi3jrf2jflkj23lf2f"))
        )
        let validationErrorMessage = AuthLocalization.Error.accountNotRegistered(
            AuthMethod.socialAuth(.apple).analyticsValue,
            viewModel.config.platformName
        )
        let validationError = CustomValidationError(statusCode: 400, data: ["error_description": validationErrorMessage])
        let error = AFError.responseValidationFailed(reason: AFError.ResponseValidationFailureReason.customValidationFailed(error: validationError))

        interactor.loginExternalTokenHandler = { _, _ in throw error }

        await viewModel.login(with: result)

        XCTAssertEqual(interactor.loginExternalTokenCallCount, 1)
        XCTAssertEqual(router.showMainOrWhatsNewScreenCallCount, 0)

        XCTAssertEqual(viewModel.errorMessage, validationErrorMessage)
        XCTAssertEqual(viewModel.isShowProgress, false)
    }

    func testLoginErrorValidation() async throws {
        let interactor = AuthInteractorProtocolMock()
        let router = AuthorizationRouterMock()
        let validator = Validator()
        let analytics = AuthorizationAnalyticsMock()
        let viewModel = SignInViewModel(
            interactor: interactor,
            router: router,
            config: ConfigMock(),
            analytics: analytics,
            validator: validator,
            storage: CoreStorageMock(),
            sourceScreen: .default
        )

        let validationErrorMessage = "Some error"
        let validationError = CustomValidationError(statusCode: 400, data: ["error_description": validationErrorMessage])
        let error = AFError.responseValidationFailed(reason: AFError.ResponseValidationFailureReason.customValidationFailed(error: validationError))

        interactor.loginHandler = { _, _ in throw error }

        await viewModel.login(username: "edxUser@edx.com", password: "password123")

        XCTAssertEqual(interactor.loginCallCount, 1)
        XCTAssertEqual(router.showMainOrWhatsNewScreenCallCount, 0)

        XCTAssertEqual(viewModel.errorMessage, validationErrorMessage)
        XCTAssertEqual(viewModel.isShowProgress, false)
    }

    func testLoginErrorInvalidGrant() async throws {
        let interactor = AuthInteractorProtocolMock()
        let router = AuthorizationRouterMock()
        let validator = Validator()
        let analytics = AuthorizationAnalyticsMock()
        let viewModel = SignInViewModel(
            interactor: interactor,
            router: router,
            config: ConfigMock(),
            analytics: analytics,
            validator: validator,
            storage: CoreStorageMock(),
            sourceScreen: .default
        )

        interactor.loginHandler = { _, _ in throw APIError.invalidGrant }

        await viewModel.login(username: "edxUser@edx.com", password: "password123")

        XCTAssertEqual(interactor.loginCallCount, 1)
        XCTAssertEqual(router.showMainOrWhatsNewScreenCallCount, 0)

        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.invalidCredentials)
        XCTAssertEqual(viewModel.isShowProgress, false)
    }

    func testLoginErrorUnknown() async throws {
        let interactor = AuthInteractorProtocolMock()
        let router = AuthorizationRouterMock()
        let validator = Validator()
        let analytics = AuthorizationAnalyticsMock()
        let viewModel = SignInViewModel(
            interactor: interactor,
            router: router,
            config: ConfigMock(),
            analytics: analytics,
            validator: validator,
            storage: CoreStorageMock(),
            sourceScreen: .default
        )

        interactor.loginHandler = { _, _ in throw NSError(domain: "error", code: -1, userInfo: nil) }

        await viewModel.login(username: "edxUser@edx.com", password: "password123")

        XCTAssertEqual(interactor.loginCallCount, 1)
        XCTAssertEqual(router.showMainOrWhatsNewScreenCallCount, 0)

        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.unknownError)
        XCTAssertEqual(viewModel.isShowProgress, false)
    }

    func testLoginNoInternetError() async throws {
        let interactor = AuthInteractorProtocolMock()
        let router = AuthorizationRouterMock()
        let validator = Validator()
        let analytics = AuthorizationAnalyticsMock()
        let viewModel = SignInViewModel(
            interactor: interactor,
            router: router,
            config: ConfigMock(),
            analytics: analytics,
            validator: validator,
            storage: CoreStorageMock(),
            sourceScreen: .default
        )

        let noInternetError = AFError.sessionInvalidated(error: URLError(.notConnectedToInternet))

        interactor.loginHandler = { _, _ in throw noInternetError }

        await viewModel.login(username: "edxUser@edx.com", password: "password123")

        XCTAssertEqual(interactor.loginCallCount, 1)
        XCTAssertEqual(router.showMainOrWhatsNewScreenCallCount, 0)

        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.slowOrNoInternetConnection)
        XCTAssertEqual(viewModel.isShowProgress, false)
    }

    func testTrackForgotPasswordClicked() {
        let interactor = AuthInteractorProtocolMock()
        let router = AuthorizationRouterMock()
        let validator = Validator()
        let analytics = AuthorizationAnalyticsMock()
        let viewModel = SignInViewModel(
            interactor: interactor,
            router: router,
            config: ConfigMock(),
            analytics: analytics,
            validator: validator,
            storage: CoreStorageMock(),
            sourceScreen: .default
        )

        viewModel.trackForgotPasswordClicked()

        XCTAssertEqual(analytics.forgotPasswordClickedCallCount, 1)
    }

}

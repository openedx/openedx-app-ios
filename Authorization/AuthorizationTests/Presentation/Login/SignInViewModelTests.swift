//
//  SignInViewModelTests.swift
//  AuthorizationTests
//
//  Created by Vladimir Chekyrta on 10.01.2023.
//

import SwiftyMocky
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
            sourceScreen: .default
        )
        
        await viewModel.login(username: "", password: "")
        
        Verify(interactor, 0, .login(username: .any, password: .any))
        Verify(router, 0, .showMainOrWhatsNewScreen(sourceScreen: .any))
        
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
            sourceScreen: .default
        )
        await viewModel.login(username: "edxUser@edx.com", password: "")
        
        Verify(interactor, 0, .login(username: .any, password: .any))
        Verify(router, 0, .showMainOrWhatsNewScreen(sourceScreen: .any))
        
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
            sourceScreen: .default
        )
        let user = User(id: 1, username: "username", email: "edxUser@edx.com", name: "Name", userAvatar: "")
        
        Given(interactor, .login(username: .any, password: .any, willReturn: user))
        
        await viewModel.login(username: "edxUser@edx.com", password: "password123")
        
        Verify(interactor, 1, .login(username: .any, password: .any))
        Verify(analytics, .userLogin(method: .any))
        Verify(router, 1, .showMainOrWhatsNewScreen(sourceScreen: .any))
        
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
            sourceScreen: .default
        )
        let user = User(id: 1, username: "username", email: "edxUser@edx.com", name: "Name", userAvatar: "")
        
        Given(interactor, .login(ssoToken: .any, willReturn: user))
        
        await viewModel.ssoLogin(title: "Riyadah")
        
        Verify(interactor, 1, .login(ssoToken: .any))
        Verify(router, 1, .showMainOrWhatsNewScreen(sourceScreen: .any))
        
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
            sourceScreen: .default
        )

        let result: Result<SocialAuthDetails, Error> = .success(.apple(
            .init(name: "name", email: "email", token: "239i2oi3jrf2jflkj23lf2f"))
        )
        let user = User(id: 1, username: "username", email: "edxUser@edx.com", name: "Name", userAvatar: "")

        Given(interactor, .login(externalToken: .any, backend: .any, willReturn: user))

        await viewModel.login(with: result)

        Verify(interactor, 1, .login(externalToken: .any, backend: .any))
        Verify(analytics, .userLogin(method: .any))
        Verify(router, 1, .showMainOrWhatsNewScreen(sourceScreen: .any))

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
            sourceScreen: .default
        )

        let result: Result<SocialAuthDetails, Error> = .success(
            .apple(.init(name: "name", email: "email", token: "239i2oi3jrf2jflkj23lf2f"))
        )
        let validationErrorMessage = AuthLocalization.Error.accountNotRegistered(
            AuthMethod.socailAuth(.apple).analyticsValue,
            viewModel.config.platformName
        )
        let validationError = CustomValidationError(statusCode: 400, data: ["error_description": validationErrorMessage])
        let error = AFError.responseValidationFailed(reason: AFError.ResponseValidationFailureReason.customValidationFailed(error: validationError))

        Given(interactor, .login(externalToken: .any, backend: .any, willThrow: error))

        await viewModel.login(with: result)

        Verify(interactor, 1, .login(externalToken: .any, backend: .any))
        Verify(router, 0, .showMainOrWhatsNewScreen(sourceScreen: .any))

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
            sourceScreen: .default
        )
        
        let validationErrorMessage = "Some error"
        let validationError = CustomValidationError(statusCode: 400, data: ["error_description": validationErrorMessage])
        let error = AFError.responseValidationFailed(reason: AFError.ResponseValidationFailureReason.customValidationFailed(error: validationError))
        
        Given(interactor, .login(username: .any, password: .any, willThrow: error))
        
        await viewModel.login(username: "edxUser@edx.com", password: "password123")
        
        Verify(interactor, 1, .login(username: .any, password: .any))
        Verify(router, 0, .showMainOrWhatsNewScreen(sourceScreen: .any))
        
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
            sourceScreen: .default
        )
        
        Given(interactor, .login(username: .any, password: .any, willThrow: APIError.invalidGrant))
        
        await viewModel.login(username: "edxUser@edx.com", password: "password123")
        
        Verify(interactor, 1, .login(username: .any, password: .any))
        Verify(router, 0, .showMainOrWhatsNewScreen(sourceScreen: .any))
        
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
            sourceScreen: .default
        )
        
        Given(interactor, .login(username: .any, password: .any, willThrow: NSError()))
        
        await viewModel.login(username: "edxUser@edx.com", password: "password123")
        
        Verify(interactor, 1, .login(username: .any, password: .any))
        Verify(router, 0, .showMainOrWhatsNewScreen(sourceScreen: .any))
        
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
            sourceScreen: .default
        )
        
        let noInternetError = AFError.sessionInvalidated(error: URLError(.notConnectedToInternet))
        
        Given(interactor, .login(username: .any, password: .any, willThrow: noInternetError))
        
        await viewModel.login(username: "edxUser@edx.com", password: "password123")
        
        Verify(interactor, 1, .login(username: .any, password: .any))
        Verify(router, 0, .showMainOrWhatsNewScreen(sourceScreen: .any))
        
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
            sourceScreen: .default
        )
        
        viewModel.trackForgotPasswordClicked()
        
        Verify(analytics, 1, .forgotPasswordClicked())
    }
    
}

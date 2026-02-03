//
//  RegisterViewModelTests.swift
//  AuthorizationTests
//
//  Created by  Stepanok Ivan on 15.01.2023.
//

import XCTest
@testable import Core
@testable import Authorization
import OEXFoundation
import Alamofire
import SwiftUI

@MainActor
final class SignUpViewModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetRegistrationFieldsSuccess() async throws {
        let interactor = AuthInteractorProtocolMock()
        let router = AuthorizationRouterMock()
        let validator = Validator()
        let analytics = AuthorizationAnalyticsMock()
        let viewModel = SignUpViewModel(
            interactor: interactor,
            router: router,
            analytics: analytics,
            config: ConfigMock(),
            cssInjector: CSSInjectorMock(),
            validator: validator,
            storage: CoreStorageMock(),
            sourceScreen: .default
        )

        let fields = [
            PickerFields(type: .email, label: "", required: true, name: "email", instructions: "", options: []),
            PickerFields(type: .password, label: "", required: true, name: "password", instructions: "", options: []),
            PickerFields(type: .plaintext, label: "", required: true, name: "name", instructions: "", options: [])
        ]

        interactor.getRegistrationFieldsHandler = { fields }

        await viewModel.getRegistrationFields()

        XCTAssertEqual(interactor.getRegistrationFieldsCallCount, 1)
        XCTAssertEqual(viewModel.isShowProgress, false)
        XCTAssertEqual(viewModel.showError, false)
        XCTAssertEqual(viewModel.errorMessage, nil)

    }

    func testGetRegistrationFieldsNoInternetError() async throws {
        let interactor = AuthInteractorProtocolMock()
        let router = AuthorizationRouterMock()
        let validator = Validator()
        let analytics = AuthorizationAnalyticsMock()
        let viewModel = SignUpViewModel(
            interactor: interactor,
            router: router,
            analytics: analytics,
            config: ConfigMock(),
            cssInjector: CSSInjectorMock(),
            validator: validator,
            storage: CoreStorageMock(),
            sourceScreen: .default
        )

        let noInternetError = AFError.sessionInvalidated(error: URLError(.notConnectedToInternet))

        interactor.getRegistrationFieldsHandler = { throw noInternetError }

        await viewModel.getRegistrationFields()

        XCTAssertEqual(interactor.getRegistrationFieldsCallCount, 1)
        XCTAssertEqual(viewModel.isShowProgress, false)
        XCTAssertEqual(viewModel.showError, true)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.slowOrNoInternetConnection)
    }

    func testGetRegistrationFieldsUnknownError() async throws {
        let interactor = AuthInteractorProtocolMock()
        let router = AuthorizationRouterMock()
        let validator = Validator()
        let analytics = AuthorizationAnalyticsMock()
        let viewModel = SignUpViewModel(
            interactor: interactor,
            router: router,
            analytics: analytics,
            config: ConfigMock(),
            cssInjector: CSSInjectorMock(),
            validator: validator,
            storage: CoreStorageMock(),
            sourceScreen: .default
        )

        interactor.getRegistrationFieldsHandler = { throw NSError(domain: "error", code: -1, userInfo: nil) }

        await viewModel.getRegistrationFields()

        XCTAssertEqual(interactor.getRegistrationFieldsCallCount, 1)
        XCTAssertEqual(viewModel.isShowProgress, false)
        XCTAssertEqual(viewModel.showError, true)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.unknownError)
    }

    func testRegisterUserSuccess() async throws {
        let interactor = AuthInteractorProtocolMock()
        let router = AuthorizationRouterMock()
        let validator = Validator()
        let analytics = AuthorizationAnalyticsMock()
        let viewModel = SignUpViewModel(
            interactor: interactor,
            router: router,
            analytics: analytics,
            config: ConfigMock(),
            cssInjector: CSSInjectorMock(),
            validator: validator,
            storage: CoreStorageMock(),
            sourceScreen: .default
        )

        interactor.registerUserHandler = { _, _ in
            User(id: 1, username: "Name", email: "mail", name: "name", userAvatar: "avatar")
        }
        interactor.validateRegistrationFieldsHandler = { _ in [:] }

        await viewModel.registerUser()

        XCTAssertEqual(interactor.validateRegistrationFieldsCallCount, 1)
        XCTAssertEqual(interactor.registerUserCallCount, 1)
        XCTAssertEqual(router.showMainOrWhatsNewScreenCallCount, 1)

        XCTAssertEqual(viewModel.isShowProgress, false)
        XCTAssertEqual(viewModel.showError, false)
    }

    func testRegisterUserValidationFailure() async throws {
        let interactor = AuthInteractorProtocolMock()
        let router = AuthorizationRouterMock()
        let validator = Validator()
        let analytics = AuthorizationAnalyticsMock()
        let viewModel = SignUpViewModel(
            interactor: interactor,
            router: router,
            analytics: analytics,
            config: ConfigMock(),
            cssInjector: CSSInjectorMock(),
            validator: validator,
            storage: CoreStorageMock(),
            sourceScreen: .default
        )

        viewModel.fields = [
            FieldConfiguration(field: .init(type: .email,
                                            label: "email",
                                            required: true,
                                            name: "email",
                                            instructions: "",
                                            options: []))
        ]

        interactor.validateRegistrationFieldsHandler = { _ in ["email": "invalid email"] }

        await viewModel.registerUser()

        XCTAssertEqual(interactor.validateRegistrationFieldsCallCount, 1)
        XCTAssertEqual(interactor.registerUserCallCount, 0)
        XCTAssertEqual(router.showMainOrWhatsNewScreenCallCount, 0)

        XCTAssertEqual(viewModel.isShowProgress, false)
        XCTAssertEqual(viewModel.showError, false)
        XCTAssertFalse(viewModel.fields.first!.error.isEmpty)
    }

    func testRegisterUserInvalidCredentials() async throws {
        let interactor = AuthInteractorProtocolMock()
        let router = AuthorizationRouterMock()
        let validator = Validator()
        let analytics = AuthorizationAnalyticsMock()
        let viewModel = SignUpViewModel(
            interactor: interactor,
            router: router,
            analytics: analytics,
            config: ConfigMock(),
            cssInjector: CSSInjectorMock(),
            validator: validator,
            storage: CoreStorageMock(),
            sourceScreen: .default
        )

        interactor.validateRegistrationFieldsHandler = { _ in [:] }
        interactor.registerUserHandler = { _, _ in throw APIError.invalidGrant }

        await viewModel.registerUser()

        XCTAssertEqual(interactor.validateRegistrationFieldsCallCount, 1)
        XCTAssertEqual(interactor.registerUserCallCount, 1)
        XCTAssertEqual(router.showMainOrWhatsNewScreenCallCount, 0)

        XCTAssertEqual(viewModel.isShowProgress, false)
        XCTAssertEqual(viewModel.showError, true)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.invalidCredentials)
    }

    func testRegisterUserUnknownError() async throws {
        let interactor = AuthInteractorProtocolMock()
        let router = AuthorizationRouterMock()
        let validator = Validator()
        let analytics = AuthorizationAnalyticsMock()
        let viewModel = SignUpViewModel(
            interactor: interactor,
            router: router,
            analytics: analytics,
            config: ConfigMock(),
            cssInjector: CSSInjectorMock(),
            validator: validator,
            storage: CoreStorageMock(),
            sourceScreen: .default
        )

        interactor.validateRegistrationFieldsHandler = { _ in [:] }
        interactor.registerUserHandler = { _, _ in throw NSError(domain: "error", code: -1, userInfo: nil) }

        await viewModel.registerUser()

        XCTAssertEqual(interactor.validateRegistrationFieldsCallCount, 1)
        XCTAssertEqual(interactor.registerUserCallCount, 1)
        XCTAssertEqual(router.showMainOrWhatsNewScreenCallCount, 0)

        XCTAssertEqual(viewModel.isShowProgress, false)
        XCTAssertEqual(viewModel.showError, true)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.unknownError)
    }

    func testRegisterUserNoInternetError() async throws {
        let interactor = AuthInteractorProtocolMock()
        let router = AuthorizationRouterMock()
        let validator = Validator()
        let analytics = AuthorizationAnalyticsMock()
        let viewModel = SignUpViewModel(
            interactor: interactor,
            router: router,
            analytics: analytics,
            config: ConfigMock(),
            cssInjector: CSSInjectorMock(),
            validator: validator,
            storage: CoreStorageMock(),
            sourceScreen: .default
        )

        let noInternetError = AFError.sessionInvalidated(error: URLError(.notConnectedToInternet))

        interactor.registerUserHandler = { _, _ in throw noInternetError }
        interactor.validateRegistrationFieldsHandler = { _ in [:] }

        await viewModel.registerUser()

        XCTAssertEqual(interactor.validateRegistrationFieldsCallCount, 1)
        XCTAssertEqual(interactor.registerUserCallCount, 1)
        XCTAssertEqual(router.showMainOrWhatsNewScreenCallCount, 0)

        XCTAssertEqual(viewModel.isShowProgress, false)
        XCTAssertEqual(viewModel.showError, true)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.slowOrNoInternetConnection)
    }

    func testTrackCreateAccountClicked() {
        let interactor = AuthInteractorProtocolMock()
        let router = AuthorizationRouterMock()
        let validator = Validator()
        let analytics = AuthorizationAnalyticsMock()
        let viewModel = SignUpViewModel(
            interactor: interactor,
            router: router,
            analytics: analytics,
            config: ConfigMock(),
            cssInjector: CSSInjectorMock(),
            validator: validator,
            storage: CoreStorageMock(),
            sourceScreen: .default
        )

        viewModel.trackCreateAccountClicked()

        XCTAssertEqual(analytics.createAccountClickedCallCount, 1)
    }
}

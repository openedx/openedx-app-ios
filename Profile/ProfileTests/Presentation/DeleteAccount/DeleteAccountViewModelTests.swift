//
//  DeleteAccountViewModelTests.swift
//  ProfileTests
//
//  Created by  Stepanok Ivan on 07.03.2023.
//

import SwiftyMocky
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
        let viewModel = DeleteAccountViewModel(
            interactor: interactor,
            router: router,
            connectivity: connectivity,
            analytics: ProfileAnalyticsMock()
        )
        
        Given(interactor, .deleteAccount(password: .any, willReturn: true))
        
        try await viewModel.deleteAccount(password: "123")
        
        Verify(interactor, 1, .deleteAccount(password: .any))
        Verify(router, .showLoginScreen(sourceScreen: .any))
    }
    
    func testDeletingAccountWrongPassword() async throws {
        let interactor = ProfileInteractorProtocolMock()
        let router = ProfileRouterMock()
        let connectivity = ConnectivityProtocolMock()
        let viewModel = DeleteAccountViewModel(
            interactor: interactor,
            router: router,
            connectivity: connectivity,
            analytics: ProfileAnalyticsMock()
        )
        
        Given(interactor, .deleteAccount(password: .any, willReturn: false))
        
        try await viewModel.deleteAccount(password: "123")
        
        Verify(interactor, 1, .deleteAccount(password: .any))
        Verify(router, 0, .showLoginScreen(sourceScreen: .any))
        
        XCTAssertTrue(viewModel.incorrectPassword)
    }
    
    func testDeletingUserAccountNotActivatedError() async throws {
        let interactor = ProfileInteractorProtocolMock()
        let router = ProfileRouterMock()
        let connectivity = ConnectivityProtocolMock()
        let viewModel = DeleteAccountViewModel(
            interactor: interactor,
            router: router,
            connectivity: connectivity,
            analytics: ProfileAnalyticsMock()
        )
        
        let validationError = CustomValidationError(statusCode: 401, data: ["error_code": "user_not_active"])
        let error = AFError.responseValidationFailed(
            reason: AFError.ResponseValidationFailureReason.customValidationFailed(error: validationError)
        )
        
        Given(interactor, .deleteAccount(password: .any, willThrow: error))
        
        try await viewModel.deleteAccount(password: "123")
        
        Verify(interactor, 1, .deleteAccount(password: .any))
        Verify(router, 0, .showLoginScreen(sourceScreen: .any))
        
        XCTAssertFalse(viewModel.incorrectPassword)
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.userNotActive)
    }
    
    func testDeletingUserUnknownError() async throws {
        let interactor = ProfileInteractorProtocolMock()
        let router = ProfileRouterMock()
        let connectivity = ConnectivityProtocolMock()
        let viewModel = DeleteAccountViewModel(
            interactor: interactor,
            router: router,
            connectivity: connectivity,
            analytics: ProfileAnalyticsMock()
        )
        
        Given(interactor, .deleteAccount(password: .any, willThrow: NSError()))
        
        try await viewModel.deleteAccount(password: "123")
        
        Verify(interactor, 1, .deleteAccount(password: .any))
        Verify(router, 0, .showLoginScreen(sourceScreen: .any))
        
        XCTAssertFalse(viewModel.incorrectPassword)
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.unknownError)
    }
    
    func testDeletingUserNoInternetError() async throws {
        let interactor = ProfileInteractorProtocolMock()
        let router = ProfileRouterMock()
        let connectivity = ConnectivityProtocolMock()
        let viewModel = DeleteAccountViewModel(
            interactor: interactor,
            router: router,
            connectivity: connectivity,
            analytics: ProfileAnalyticsMock()
        )
        
        let noInternetError = AFError.sessionInvalidated(error: URLError(.notConnectedToInternet))
        
        Given(interactor, .deleteAccount(password: .any, willThrow: noInternetError))
        
        try await viewModel.deleteAccount(password: "123")
        
        Verify(interactor, 1, .deleteAccount(password: .any))
        Verify(router, 0, .showLoginScreen(sourceScreen: .any))
        
        XCTAssertFalse(viewModel.incorrectPassword)
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.slowOrNoInternetConnection)
    }
}

//
//  SignInViewModel.swift
//  Authorization
//
//  Created by Vladimir Chekyrta on 14.09.2022.
//

import Foundation
import Core
import SwiftUI
import Alamofire

public class SignInViewModel: ObservableObject {
    
    @Published private(set) var isShowProgress = false
    @Published private(set) var showError: Bool = false
    @Published private(set) var showAlert: Bool = false
    var errorMessage: String? {
        didSet {
            withAnimation {
                showError = errorMessage != nil
            }
        }
    }
    var alertMessage: String? {
        didSet {
            withAnimation {
                showAlert = alertMessage != nil
            }
        }
    }
    
    let router: AuthorizationRouter
    
    private let interactor: AuthInteractorProtocol
    private let analytics: AuthorizationAnalytics
    private let validator: Validator
    
    public init(
        interactor: AuthInteractorProtocol,
        router: AuthorizationRouter,
        analytics: AuthorizationAnalytics,
        validator: Validator
    ) {
        self.interactor = interactor
        self.router = router
        self.analytics = analytics
        self.validator = validator
    }
    
    @MainActor
    func login(username: String, password: String) async {
        guard validator.isValidEmail(username) else {
            errorMessage = AuthLocalization.Error.invalidEmailAddress
            return
        }
        guard validator.isValidPassword(password) else {
            errorMessage = AuthLocalization.Error.invalidPasswordLenght
            return
        }
        
        isShowProgress = true
        do {
            let user = try await interactor.login(username: username, password: password)
            analytics.setUserID("\(user.id)")
            analytics.userLogin(method: .password)
            router.showMainScreen()
        } catch let error {
            isShowProgress = false
            if let validationError = error.validationError,
               let value = validationError.data?["error_description"] as? String {
                errorMessage = value
            } else if case APIError.invalidGrant = error {
                errorMessage = CoreLocalization.Error.invalidCredentials
            } else if error.isInternetError {
                errorMessage = CoreLocalization.Error.slowOrNoInternetConnection
            } else {
                errorMessage = CoreLocalization.Error.unknownError
            }
        }
    }

    func sign(with result: Result<Socials, Error>) {
        result.success { social in
            debugLog(social)
        }
        result.failure { error in
            errorMessage = error.localizedDescription
        }
    }

    func trackSignUpClicked() {
        analytics.signUpClicked()
    }
    
    func trackForgotPasswordClicked() {
        analytics.forgotPasswordClicked()
    }
}

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
import AuthenticationServices
import FacebookLogin
import GoogleSignIn
import MSAL

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
    let config: ConfigProtocol
    private let interactor: AuthInteractorProtocol
    private let analytics: AuthorizationAnalytics
    private let validator: Validator

    public init(
        interactor: AuthInteractorProtocol,
        router: AuthorizationRouter,
        config: ConfigProtocol,
        analytics: AuthorizationAnalytics,
        validator: Validator
    ) {
        self.interactor = interactor
        self.router = router
        self.config = config
        self.analytics = analytics
        self.validator = validator
    }

    var socialLoginEnabled: Bool {
        config.socialLoginEnabled
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
            router.showMainOrWhatsNewScreen()
        } catch let error {
            isShowProgress = false
            if error.isUpdateRequeiredError {
                router.showUpdateRequiredView(showAccountLink: false)
            } else if let validationError = error.validationError,
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

    @MainActor
    func sign(with result: Result<SocialResult, Error>) {
        result.success { social(result: $0) }
        result.failure { error in
            errorMessage = error.localizedDescription
        }
    }

    @MainActor
    private func social(result: SocialResult) {
        switch result {
        case .apple(let appleCredentials):
            appleLogin(appleCredentials, backend: result.backend)
        case .facebook:
            facebookLogin(backend: result.backend)
        case .google(let gIDSignInResult):
            googleLogin(gIDSignInResult, backend: result.backend)
        case .microsoft(_, let token):
            microsoftLogin(token, backend: result.backend)
        }
    }

    @MainActor
    private func appleLogin(_ credentials: AppleCredentials, backend: String) {
        socialLogin(
            externalToken: credentials.token,
            backend: backend,
            loginMethod: .apple
        )
    }

    @MainActor
    private func facebookLogin(backend: String) {
        guard let currentAccessToken = AccessToken.current?.tokenString else {
            return
        }
        socialLogin(
            externalToken: currentAccessToken,
            backend: backend,
            loginMethod: .facebook
        )
    }

    @MainActor
    private func googleLogin(_ result: GIDSignInResult, backend: String) {
        socialLogin(
            externalToken: result.user.accessToken.tokenString,
            backend: backend,
            loginMethod: .google
        )
    }

    @MainActor
    private func microsoftLogin(_ token: String, backend: String) {
        socialLogin(
            externalToken: token,
            backend: backend,
            loginMethod: .microsoft
        )
    }

    @MainActor
    private func socialLogin(externalToken: String, backend: String, loginMethod: LoginMethod) {
        Task { 
            isShowProgress = true
            do {
                let user = try await interactor.login(externalToken: externalToken, backend: backend)
                analytics.setUserID("\(user.id)")
                analytics.userLogin(method: loginMethod)
                router.showMainOrWhatsNewScreen()
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
    }

    func trackSignUpClicked() {
        analytics.signUpClicked()
    }

    func trackForgotPasswordClicked() {
        analytics.forgotPasswordClicked()
    }

}

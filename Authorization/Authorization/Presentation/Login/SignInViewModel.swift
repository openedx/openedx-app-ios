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
        config.appleSignIn.enabled ||
        config.facebook.enabled ||
        config.microsoft.enabled ||
        config.google.enabled
    }

    @MainActor
    func login(username: String, password: String) async {
        guard validator.isValidUsername(username) else {
            errorMessage = AuthLocalization.Error.invalidEmailAddressOrUsername
            return
        }
        guard !password.isEmpty else {
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
            failure(error)
        }
    }

    @MainActor
    func login(with result: Result<SocialAuthDetails, Error>) {
        result.success { socialAuth(result: $0) }
        result.failure { error in
            errorMessage = error.localizedDescription
        }
    }

    @MainActor
    private func socialAuth(result: SocialAuthDetails) {
        switch result {
        case .apple(let response):
            appleLogin(response, backend: result.backend)
        case .facebook(let response):
            facebookLogin(response, backend: result.backend)
        case .google(let response):
            googleLogin(response, backend: result.backend)
        case .microsoft(let response):
            microsoftLogin(response, backend: result.backend)
        }
    }

    @MainActor
    private func appleLogin(_ response: SocialAuthResponse, backend: String) {
        socialLogin(
            externalToken: response.token,
            backend: backend,
            loginMethod: .socailAuth(.apple)
        )
    }

    @MainActor
    private func facebookLogin(_ response: SocialAuthResponse, backend: String) {
        guard let currentAccessToken = AccessToken.current?.tokenString else {
            return
        }
        socialLogin(
            externalToken: response.token,
            backend: backend,
            loginMethod: .socailAuth(.facebook)
        )
    }

    @MainActor
    private func googleLogin(_ response: SocialAuthResponse, backend: String) {
        socialLogin(
            externalToken: response.token,
            backend: backend,
            loginMethod: .socailAuth(.google)
        )
    }

    @MainActor
    private func microsoftLogin(_ response: SocialAuthResponse, backend: String) {
        socialLogin(
            externalToken: response.token,
            backend: backend,
            loginMethod: .socailAuth(.microsoft)
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
                failure(error, loginMethod: loginMethod)
            }
        }
    }

    @MainActor
    private func failure(_ error: Error, loginMethod: LoginMethod? = nil) {
        isShowProgress = false
        if let validationError = error.validationError,
           let value = validationError.data?["error_description"] as? String {
            if loginMethod != .password, validationError.statusCode == 400, let loginMethod = loginMethod {
                errorMessage = AuthLocalization.Error.accountNotRegistered(
                    loginMethod.analyticsValue,
                    config.platformName
                )
            } else if validationError.statusCode == 403 {
                errorMessage = AuthLocalization.Error.disabledAccount
            } else {
                errorMessage = value
            }
        } else if case APIError.invalidGrant = error {
            errorMessage = CoreLocalization.Error.invalidCredentials
        } else if error.isInternetError {
            errorMessage = CoreLocalization.Error.slowOrNoInternetConnection
        } else {
            errorMessage = CoreLocalization.Error.unknownError
        }
    }

    func trackSignUpClicked() {
        analytics.signUpClicked()
    }

    func trackForgotPasswordClicked() {
        analytics.forgotPasswordClicked()
    }

}

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
        result.success(social)
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

    private func social(result: Socials) {
        switch result {
        case .apple(let credential):
            appleLogin(credential)
        case .facebook(let loginManagerLoginResult):
            facebookLogin(loginManagerLoginResult)
        case .google(let gIDSignInResult):
            googleLogin(gIDSignInResult)
        case .microsoft(let account, let token):
            microsoftLogin(account, token)
        }
    }

    private func appleLogin(_ credentials: AppleCredentials) {
        //credentials.email
        //credentials.name
        //credentials.token
    }

    private func facebookLogin(_ managerLoginResult: LoginManagerLoginResult) {
        //let currentAccessToken = AccessToken.current?.tokenString
    }

    private func googleLogin(_ gIDSignInResult: GIDSignInResult) {
//        gIDSignInResult.user.accessToken
//        gIDSignInResult.user.profile?.email
//        gIDSignInResult.user.profile?.name
    }

    private func microsoftLogin(_ account: MSALAccount, _ token: String) {
        
    }

}

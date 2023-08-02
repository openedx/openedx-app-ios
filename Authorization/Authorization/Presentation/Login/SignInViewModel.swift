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
import Auth0

public class SignInViewModel: ObservableObject {
    
    @Published private(set) var isShowProgress = false
    @Published private(set) var showError: Bool = false
    @Published private(set) var showAlert: Bool = false
    @Published private(set) var showAuth0Login: Bool = false
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
    
    private let interactor: AuthInteractorProtocol
    let config: Config
    let router: AuthorizationRouter
    let analytics: AuthorizationAnalytics
    private let validator: Validator
    
    public init(interactor: AuthInteractorProtocol,
                router: AuthorizationRouter,
                config: Config,
                analytics: AuthorizationAnalytics,
                validator: Validator) {
        self.interactor = interactor
        self.config = config
        self.router = router
        self.analytics = analytics
        self.validator = validator
        self.showAuth0Login = config.auth0ClientId != ""
    }
    
    @MainActor
    func login() async {
        Auth0
            .webAuth(clientId: config.auth0ClientId, domain: config.auth0Domain)
            .start { result in
                // This is a callback, rather than an awaitable.
                switch result {
                case .success(let auth0Credentials):
                    Task {
                        await self.postAuth0Login(token: auth0Credentials.idToken)
                    }
                case .failure(let authError):
                    self.errorMessage = "\(authError)"
                }
            }
    }
    
    private func postAuth0Login(token: String) async {
        isShowProgress = true
        do {
            let user = try await interactor.login(token: token)
            analytics.setUserID("\(user.id)")
            analytics.userLogin(method: .auth0)
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
}

//
//  SignInViewModel.swift
//  Authorization
//
//  Created by Vladimir Chekyrta on 14.09.2022.
//

import Foundation
import Core
import OEXFoundation
import SwiftUI
import Alamofire
import AuthenticationServices
import FacebookLogin
import GoogleSignIn
import MSAL

@MainActor
public class SignInViewModel: ObservableObject {

    @Published private(set) var isShowProgress = false
    @Published private(set) var showError: Bool = false
    @Published private(set) var showAlert: Bool = false
    let sourceScreen: LogistrationSourceScreen
    
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
        validator: Validator,
        sourceScreen: LogistrationSourceScreen
    ) {
        self.interactor = interactor
        self.router = router
        self.config = config
        self.analytics = analytics
        self.validator = validator
        self.sourceScreen = sourceScreen
    }

    var socialAuthEnabled: Bool {
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
        analytics.userSignInClicked()
        isShowProgress = true
        do {
            let user = try await interactor.login(username: username, password: password)
            analytics.identify(id: "\(user.id)", username: user.username, email: user.email)
            analytics.userLogin(method: .password)
            router.showMainOrWhatsNewScreen(sourceScreen: sourceScreen)
            NotificationCenter.default.post(name: .userAuthorized, object: nil)
        } catch let error {
            failure(error)
        }
    }

    @MainActor
    func ssoLogin(title: String) async {
        analytics.userSignInClicked()
        isShowProgress = true
        do {
            let user = try await interactor.login(ssoToken: "")
            analytics.identify(id: "\(user.id)", username: user.username, email: user.email)
            analytics.userLogin(method: .password)
            router.showMainOrWhatsNewScreen(sourceScreen: sourceScreen)
        } catch let error {
            failure(error)
        }
    }
    
    @MainActor
    func login(with result: Result<SocialAuthDetails, Error>) async {
        switch result {
        case .success(let result):
            await socialLogin(
                externalToken: result.response.token,
                backend: result.backend,
                authMethod: result.authMethod
            )
        case .failure(let error):
            errorMessage = error.localizedDescription
        }
    }

    @MainActor
    private func socialLogin(
        externalToken: String,
        backend: String,
        authMethod: AuthMethod
    ) async {
        isShowProgress = true
        do {
            let user = try await interactor.login(externalToken: externalToken, backend: backend)
            analytics.identify(id: "\(user.id)", username: user.username, email: user.email)
            analytics.userLogin(method: authMethod)
            router.showMainOrWhatsNewScreen(sourceScreen: sourceScreen)
            NotificationCenter.default.post(name: .userAuthorized, object: nil)
        } catch let error {
            failure(error, authMethod: authMethod)
        }
    }

    @MainActor
    private func failure(_ error: Error, authMethod: AuthMethod? = nil) {
        isShowProgress = false
        if let validationError = error.validationError,
           let value = validationError.data?["error_description"] as? String {
            if authMethod != .password, validationError.statusCode == 400, let authMethod = authMethod {
                errorMessage = AuthLocalization.Error.accountNotRegistered(
                    authMethod.analyticsValue,
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

    func trackForgotPasswordClicked() {
        analytics.forgotPasswordClicked()
    }
    
    func trackScreenEvent() {
        analytics.authTrackScreenEvent(
            .logistrationSignIn,
            biValue: .logistrationSignIn
        )
    }
}

//
//  SSOWebViewModel.swift
//  Authorization
//
//  Created by Rawan Matar on 02/06/2024.
//

import Foundation
import SwiftUI
import OEXFoundation
import Core
import Alamofire
import AuthenticationServices
import FacebookLogin
import GoogleSignIn
import MSAL

@MainActor
public class SSOWebViewModel: ObservableObject {

    @Published private(set) var isShowProgress = false
    @Published private(set) var showError: Bool = false
    @Published private(set) var showAlert: Bool = false
    let sourceScreen: LogistrationSourceScreen = .default
    
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
    let ssoHelper: SSOHelper
    
    public init(
        interactor: AuthInteractorProtocol,
        router: AuthorizationRouter,
        config: ConfigProtocol,
        analytics: AuthorizationAnalytics,
        ssoHelper: SSOHelper
    ) {
        self.interactor = interactor
        self.router = router
        self.config = config
        self.analytics = analytics
        self.ssoHelper = ssoHelper
    }

    @MainActor
    func SSOLogin(cookies: [HTTPCookie]) async {
        guard !cookies.isEmpty else {
            errorMessage = "COOKIES EMPTY"
            return
        }
        
        isShowProgress = true
        for cookie in cookies {
            /// Store cookies in UserDefaults
            if cookie.name == SSOHelper.SSOHelperKeys.cookiePayload.description {
                self.ssoHelper.cookiePayload = cookie.value
            }
            
            if cookie.name == SSOHelper.SSOHelperKeys.cookieSignature.description {
                self.ssoHelper.cookieSignature = cookie.value
            }
            if let signature = self.ssoHelper.cookieSignature,
               let payload = self.ssoHelper.cookiePayload {
                isShowProgress = true
                do {
                    let user = try await interactor.login(ssoToken: "\(payload).\(signature)")
                    analytics.identify(id: "\(user.id)", username: user.username, email: user.email)
                    analytics.userLogin(method: .SSO)
                    router.showMainOrWhatsNewScreen(sourceScreen: sourceScreen)
                } catch let error {
                    failure(error, authMethod: .SSO)
                }
            }
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

}

//
//  AuthorizationAnalytics.swift
//  Authorization
//
//  Created by  Stepanok Ivan on 27.06.2023.
//

import Foundation
import FirebaseAnalytics

public enum LoginMethod: String {
    case password
    case facebook
    case google
    case microsoft
}

public enum LoginProvider: String {
    case googleOauth2 = "google-oauth2"
    case facebook
    case azureadOauth2 = "azuread-oauth2"
}

public protocol AuthorizationAnalytics {
    func userLogin(method: LoginMethod)
    func signUpClicked()
    func createAccountClicked(provider: LoginProvider)
    func registrationSuccess(provider: LoginProvider)
    func forgotPasswordClicked()
    func resetPasswordClicked(success: Bool)
}

class AuthorizationAnalyticsMock: AuthorizationAnalytics {
    public func userLogin(method: LoginMethod) {}
    public func signUpClicked() {}
    public func createAccountClicked(provider: LoginProvider) {}
    public func registrationSuccess(provider: LoginProvider) {}
    public func forgotPasswordClicked() {}
    public func resetPasswordClicked(success: Bool) {}
}

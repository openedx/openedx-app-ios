//
//  AuthorizationAnalytics.swift
//  Authorization
//
//  Created by  Stepanok Ivan on 27.06.2023.
//

import Foundation

public enum LoginMethod: String {
    case password
    case facebook
    case google
    case microsoft
}

public protocol AuthorizationAnalytics {
    func setUserID(_ id: String)
    func userLogin(method: LoginMethod)
    func signUpClicked()
    func createAccountClicked()
    func registrationSuccess()
    func forgotPasswordClicked()
    func resetPasswordClicked(success: Bool)
}

#if DEBUG
class AuthorizationAnalyticsMock: AuthorizationAnalytics {
    public func setUserID(_ id: String) {}
    public func userLogin(method: LoginMethod) {}
    public func signUpClicked() {}
    public func createAccountClicked() {}
    public func registrationSuccess() {}
    public func forgotPasswordClicked() {}
    public func resetPasswordClicked(success: Bool) {}
}
#endif

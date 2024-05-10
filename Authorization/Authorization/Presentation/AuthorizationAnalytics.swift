//
//  AuthorizationAnalytics.swift
//  Authorization
//
//  Created by  Stepanok Ivan on 27.06.2023.
//

import Foundation

public enum AuthMethod: Equatable {
    case password
    case socailAuth(SocialAuthMethod)

    public var analyticsValue: String {
        switch self {
        case .password:
            "password"
        case .socailAuth(let socialAuthMethod):
            socialAuthMethod.rawValue
        }
    }
}

public enum SocialAuthMethod: String {
    case facebook
    case google
    case microsoft
    case apple
}

//sourcery: AutoMockable
public protocol AuthorizationAnalytics {
    func identify(id: String, username: String, email: String)
    func userLogin(method: AuthMethod)
    func registerClicked()
    func signInClicked()
    func userSignInClicked()
    func createAccountClicked()
    func registrationSuccess(method: String)
    func forgotPasswordClicked()
    func resetPasswordClicked()
    func resetPassword(success: Bool)
}

#if DEBUG
class AuthorizationAnalyticsMock: AuthorizationAnalytics {
    func identify(id: String, username: String, email: String) {}
    public func userLogin(method: AuthMethod) {}
    public func registerClicked() {}
    public func signInClicked() {}
    public func userSignInClicked() {}
    public func createAccountClicked() {}
    public func registrationSuccess(method: String) {}
    public func forgotPasswordClicked() {}
    public func resetPasswordClicked() {}
    public func resetPassword(success: Bool) {}
}
#endif

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
            "Password"
        case .socailAuth(let socialAuthMethod):
            socialAuthMethod.rawValue
        }
    }
}

public enum SocialAuthMethod: String {
    case facebook = "Facebook"
    case google = "Google"
    case microsoft = "Microsoft"
    case apple = "Apple"
}

//sourcery: AutoMockable
public protocol AuthorizationAnalytics {
    func identify(id: String, username: String, email: String)
    func userLogin(method: AuthMethod)
    func signUpClicked()
    func signInClicked()
    func userSignInClicked()
    func createAccountClicked()
    func registrationSuccess()
    func forgotPasswordClicked()
    func resetPasswordClicked()
    func resetPassword(success: Bool)
}

#if DEBUG
class AuthorizationAnalyticsMock: AuthorizationAnalytics {
    func identify(id: String, username: String, email: String) {}
    public func userLogin(method: AuthMethod) {}
    public func signUpClicked() {}
    public func signInClicked() {}
    public func userSignInClicked() {}
    public func createAccountClicked() {}
    public func registrationSuccess() {}
    public func forgotPasswordClicked() {}
    public func resetPasswordClicked() {}
    public func resetPassword(success: Bool) {}
}
#endif

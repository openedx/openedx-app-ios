//
//  SocialSignViewModel.swift
//  Authorization
//
//  Created by Eugene Yatsenko on 11.10.2023.
//

import SwiftUI
import Core
import AuthenticationServices
import FacebookLogin
import GoogleSignIn
import MSAL
import Swinject

enum SocialResult {
    case apple(AppleCredentials)
    case facebook(LoginManagerLoginResult)
    case google(GIDSignInResult)
    case microsoft(MSALAccount, String)

    var backend: String {
        switch self {
        case .apple:
            return "apple-id"
        case .facebook:
            return "facebook"
        case .google:
            return "google-oauth2"
        case .microsoft:
            return "azuread-oauth2"
        }
    }
}

final public class SocialSignViewModel: ObservableObject {

    // MARK: - Properties

    private var completion: ((Result<SocialResult, Error>) -> Void)

    init(
        config: ConfigProtocol,
        completion: @escaping (Result<SocialResult, Error>) -> Void
    ) {
        self.config = config
        self.completion = completion
    }

    let config: ConfigProtocol

    private let appleSingInProvider: AppleSingInProvider  = .init()
    private let googleSingInProvider: GoogleSingInProvider = .init()
    private let facebookSingInProvider: FacebookSingInProvider = .init()
    private let microsoftSingInProvider: MicrosoftSingInProvider = .init()

    private var topViewController: UIViewController? {
        UIApplication.topViewController()
    }

    // MARK: - Public Intens

    func signInWithApple() {
        appleSingInProvider.request { [weak self] result in
            guard let self = self else {
                return
            }
            result.success { self.success(with: .apple($0)) }
            result.failure(self.failure)
        }
    }

    func signInWithGoogle() {
        topViewController.flatMap {
            googleSingInProvider.signIn(
                withPresenting: $0
            ) { [weak self] result, error in
                guard let self = self else {
                    return
                }
                result.flatMap { self.success(with: .google($0)) }
                error.flatMap(self.failure)
            }
        }
    }

    func signInWithFacebook() {
        topViewController.flatMap {
            facebookSingInProvider.signIn(
                withPresenting: $0,
                completion: { [weak self] result, error in
                    guard let self = self else {
                        return
                    }
                    result.flatMap { self.success(with: .facebook($0)) }
                    error.flatMap(self.failure)
                }
            )
        }
    }

    func signInWithMicrosoft() {
        topViewController.flatMap {
            microsoftSingInProvider.signIn(
                withPresenting: $0
            ) { [weak self] account, token, error in
                guard let self = self else {
                    return
                }
                if let account = account, let token = token {
                    self.success(with: .microsoft(account, token))
                }
                if let error = error {
                    self.failure(error)
                }
            }
        }
    }

    private func success(with social: SocialResult) {
        completion(.success(social))
    }

    private func failure(_ error: Error) {
        completion(.failure(error))
    }

}

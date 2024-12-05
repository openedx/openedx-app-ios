//
//  SocialAuthViewModel.swift
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

enum SocialAuthDetails {
    case apple(SocialAuthResponse)
    case facebook(SocialAuthResponse)
    case google(SocialAuthResponse)
    case microsoft(SocialAuthResponse)

    var backend: String {
        switch self {
        case .apple:
           "apple-id"
        case .facebook:
            "facebook"
        case .google:
            "google-oauth2"
        case .microsoft:
            "azuread-oauth2"
        }
    }
    
    var authMethod: AuthMethod {
        switch self {
        case .apple:
            .socailAuth(.apple)
        case .facebook:
            .socailAuth(.facebook)
        case .google:
            .socailAuth(.google)
        case .microsoft:
            .socailAuth(.microsoft)
        }
    }

    var response: SocialAuthResponse {
        switch self {
        case .apple(let response),
             .facebook(let response),
             .google(let response),
             .microsoft(let response):
            return response
        }
    }
}

@MainActor
final public class SocialAuthViewModel: ObservableObject {

    // MARK: - Properties

    private var completion: ((Result<SocialAuthDetails, Error>) -> Void)
    private let config: ConfigProtocol

    init(
        config: ConfigProtocol,
        completion: @escaping (Result<SocialAuthDetails, Error>) -> Void
    ) {
        self.config = config
        self.completion = completion
    }

    private lazy var appleAuthProvider: AppleAuthProvider  = .init(config: config)
    private lazy var googleAuthProvider: GoogleAuthProvider = .init()
    private lazy var facebookAuthProvider: FacebookAuthProvider = .init()
    private lazy var microsoftAuthProvider: MicrosoftAuthProvider = .init()

    private var topViewController: UIViewController? {
        UIApplication.topViewController()
    }

    // MARK: - Public Properties

    var faceboolEnabled: Bool {
        config.facebook.enabled
    }

    var googleEnabled: Bool {
        config.google.enabled
    }

    var microsoftEnabled: Bool {
        config.microsoft.enabled
    }

    var appleSignInEnabled: Bool {
        if faceboolEnabled ||
            googleEnabled ||
            microsoftEnabled {
            /// Apps that use a third-party or social login service (such as Facebook Login, Google Sign-In...)
            /// to set up or authenticate the user's primary account with the app
            /// must also offer Sign in with Apple as an equivalent option
            return true
        }
        return config.appleSignIn.enabled
    }

    // MARK: - Public Intens

    func signInWithApple() {
        appleAuthProvider.request { [weak self] result in
            guard let self else { return }
            result.success { self.success(with: .apple($0)) }
            result.failure(self.failure)
        }
    }

    @MainActor
    func signInWithGoogle() async {
        guard let vc = topViewController else {
            return
        }
        let result = await googleAuthProvider.signIn(withPresenting: vc)
        result.success { success(with: .google($0)) }
        result.failure(failure)
    }

    @MainActor
    func signInWithFacebook() async {
        guard let vc = topViewController else {
            return
        }
        let result = await facebookAuthProvider.signIn(withPresenting: vc)
        result.success { success(with: .facebook($0)) }
        result.failure(failure)
    }

    @MainActor
    func signInWithMicrosoft() async {
        guard let vc = topViewController else {
            return
        }
        let result = await microsoftAuthProvider.signIn(withPresenting: vc)
        result.success { success(with: .microsoft($0)) }
        result.failure(failure)
    }

    private func success(with social: SocialAuthDetails) {
        completion(.success(social))
    }

    private func failure(_ error: Error) {
        completion(.failure(error))
    }

}

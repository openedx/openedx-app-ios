//
//  AppleAuthProvider.swift
//  Core
//
//  Created by Eugene Yatsenko on 10.10.2023.
//

import Foundation
import AuthenticationServices
import Swinject

public final class AppleAuthProvider: NSObject, ASAuthorizationControllerDelegate {

    private let config: ConfigProtocol

    public init(config: ConfigProtocol) {
        self.config = config
        super.init()
    }

    private var completion: ((Result<SocialAuthResponse, Error>) -> Void)?
    private let appleIDProvider = ASAuthorizationAppleIDProvider()

    public func request(completion: ((Result<SocialAuthResponse, Error>) -> Void)?) {
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()

        self.completion = completion
    }

    public func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        guard let credentials = authorization.credential as? ASAuthorizationAppleIDCredential else {
            completion?(.failure(SocialAuthError.unknownError))
            return
        }

        var storage = Container.shared.resolve(CoreStorage.self)
        let pncf = PersonNameComponentsFormatter()

        var name = storage?.appleSignFullName ?? ""
        if let fullName = credentials.fullName {
            name = pncf.string(from: fullName)
        }

        let email = credentials.email ?? storage?.appleSignEmail ?? ""

        if !name.isEmpty {
            storage?.appleSignFullName = name
        }

        if storage?.appleSignEmail == nil, !email.isEmpty {
            storage?.appleSignEmail = email
        }

        guard let data = credentials.identityToken,
            let code = String(data: data, encoding: .utf8) else {
            completion?(.failure(SocialAuthError.unknownError))
            return
        }

        debugLog("User id is \(data) \n Full Name is \(name) \n Email id is \(email)")

        let appleCredentials = SocialAuthResponse(
            name: name,
            email: email,
            token: code
        )

        completion?(.success(appleCredentials))
    }

    public func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        debugLog(error)
        completion?(.failure(failure(ASAuthorizationError(_nsError: error as NSError))))
    }

    private func failure(_ error: ASAuthorizationError) -> Error {
        switch error.code {
        case .canceled:
            return SocialAuthError.socialAuthCanceled
        case .failed:
            return SocialAuthError.error(text: CoreLocalization.Error.authorizationFailed)
        default:
            return error
        }
    }
}

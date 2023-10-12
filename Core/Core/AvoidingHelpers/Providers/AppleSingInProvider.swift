//
//  AppleSingInProvider.swift
//  Core
//
//  Created by Eugene Yatsenko on 10.10.2023.
//

import Foundation
import AuthenticationServices

public final class AppleSingInProvider: NSObject, ASAuthorizationControllerDelegate {

    public override init() {}

    private var completion: ((Result<ASAuthorizationAppleIDCredential, Error>) -> Void)?
    private let appleIDProvider = ASAuthorizationAppleIDProvider()

    public func request(completion: ((Result<ASAuthorizationAppleIDCredential, Error>) -> Void)?) {
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
        guard let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential else {
            completion?(.failure(CustomError.error(text: "ASAuthorizationAppleIDCredential is nil")))
            return
        }

        let userIdentifier = appleIDCredential.user
        let fullName = appleIDCredential.fullName
        let email = appleIDCredential.email

        debugLog("User id is \(userIdentifier) \n Full Name is \(String(describing: fullName)) \n Email id is \(String(describing: email))")

        completion?(.success(appleIDCredential))
    }

    public func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        debugLog(error)
        completion?(.failure(error))
    }
}

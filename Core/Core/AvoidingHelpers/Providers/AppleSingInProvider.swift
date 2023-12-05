//
//  AppleSingInProvider.swift
//  Core
//
//  Created by Eugene Yatsenko on 10.10.2023.
//

import Foundation
import AuthenticationServices
import Swinject

public struct AppleCredentials: Codable {
    public var name: String
    public var email: String
    public var birthYear: String? = nil
    public var token: String
}

public final class AppleSingInProvider: NSObject, ASAuthorizationControllerDelegate {

    public override init() {}

    private var completion: ((Result<AppleCredentials, Error>) -> Void)?
    private let appleIDProvider = ASAuthorizationAppleIDProvider()

    public func request(completion: ((Result<AppleCredentials, Error>) -> Void)?) {
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
            completion?(.failure(CustomError.unknownError))
            return
        }

        var storage = Container.shared.resolve(CoreStorage.self)

        let givenName = credentials.fullName?.givenName ?? storage?.appleSignGivenName ?? ""
        let familyName = credentials.fullName?.familyName ?? storage?.appleSignFamilyName ?? ""

        let email = credentials.email ?? storage?.appleSignEmail ?? ""
        var name: String =  "\(givenName) \(familyName)"

        if storage?.appleSignFamilyName == nil, !familyName.isEmpty {
            storage?.appleSignFamilyName = familyName
        }

        if storage?.appleSignGivenName == nil, !givenName.isEmpty {
            storage?.appleSignGivenName = givenName
        }

        if storage?.appleSignEmail == nil {
            storage?.appleSignEmail = email
        }

        guard let data = credentials.identityToken,
            let code = String(data: data, encoding: .utf8) else {
            completion?(.failure(CustomError.unknownError))
            return
        }

        debugLog("User id is \(data) \n Full Name is \(name) \n Email id is \(email)")

        let appleCredentials = AppleCredentials(
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
            return CustomError.socialSignCanceled
        case .failed:
            return CustomError.error(text: CoreLocalization.Error.authorizationFailed)
        default:
            return error
        }
    }
}

//
//  FacebookSingInProvider.swift
//  Core
//
//  Created by Eugene Yatsenko on 10.10.2023.
//

import Foundation
import FacebookLogin

public protocol FacebookAuth {
    func signIn(withPresenting: UIViewController, completion: @escaping ((LoginManagerLoginResult?, Error?) -> Void))
}

public final class FacebookAuthProvider {

    private  let loginManager = LoginManager()

    public init() {}

    @MainActor
    public func signIn(
        withPresenting: UIViewController
    ) async -> Result<LoginManagerLoginResult, Error> {
        await withCheckedContinuation { continuation in
            loginManager.logIn(
                permissions: [],
                from: withPresenting
            ) { result, error in
                if let error = error {
                    continuation.resume(returning: .failure(error))
                    return
                }

                guard let result = result, let _ = result.authenticationToken else {
                    continuation.resume(
                        returning: .failure(SocialAuthError.unknownError)
                    )
                    return
                }

                if result.isCancelled {
                    continuation.resume(returning: .failure(SocialAuthError.socialAuthCanceled))
                    return
                }

                continuation.resume(returning: .success(result))
            }
        }
    }

    public func signOut() {
        loginManager.logOut()
    }

    private func failure(_ error: Error?) -> Error {
        if let error = error as? NSError,
           let description = error.userInfo[ErrorLocalizedDescriptionKey] as? String {
            return SocialAuthError.error(text: description)
        }
        return error ?? SocialAuthError.unknownError
    }
}

//
//  FacebookAuthProvider.swift
//  Core
//
//  Created by Eugene Yatsenko on 10.10.2023.
//

import Foundation
import FacebookLogin

public final class FacebookAuthProvider {

    private  let loginManager = LoginManager()

    public init() {}

    @MainActor
    public func signIn(
        withPresenting: UIViewController
    ) async -> Result<SocialAuthResponse, Error> {
        await withCheckedContinuation { continuation in
            loginManager.logIn(
                permissions: [],
                from: withPresenting
            ) { result, error in
                if let error = error {
                    continuation.resume(returning: .failure(error))
                    return
                }

                guard let result = result,
                      let tokenString = AccessToken.current?.tokenString else {
                    continuation.resume(
                        returning: .failure(SocialAuthError.unknownError)
                    )
                    return
                }

                if result.isCancelled {
                    continuation.resume(returning: .failure(SocialAuthError.socialAuthCanceled))
                    return
                }

                GraphRequest(
                    graphPath: "me",
                    parameters: ["fields": "name, email"]
                ).start { [weak self] _, result, _ in
                    guard let self else { return }
                    guard let userInfo = result as? [String: Any] else {
                        continuation.resume(
                            returning: .success(
                                SocialAuthResponse(
                                    name: "",
                                    email: "",
                                    token: tokenString
                                )
                            )
                        )
                        return
                    }
                    continuation.resume(
                        returning: .success(
                            SocialAuthResponse(
                                name: userInfo["name"] as? String ?? "",
                                email: userInfo["email"] as? String ?? "",
                                token: tokenString
                            )
                        )
                    )
                }
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

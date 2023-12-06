//
//  GoogleSingInProvider.swift
//  Core
//
//  Created by Eugene Yatsenko on 10.10.2023.
//

import GoogleSignIn
import Foundation

public final class GoogleAuthProvider {

    public init() {}

    @MainActor
    public func signIn(
        withPresenting: UIViewController
    ) async -> Result<GIDSignInResult, Error> {
        await withCheckedContinuation { continuation in
            GIDSignIn.sharedInstance.signIn(
                withPresenting: withPresenting,
                completion: { result, error in
                    if let error = error as? NSError, error.code == GIDSignInError.canceled.rawValue {
                        continuation.resume(returning: .failure(SocialAuthError.socialAuthCanceled))
                        return
                    }
                    guard let result = result else {
                        continuation.resume(
                            returning: .failure(
                                SocialAuthError.error(text: CoreLocalization.Error.unknownError)
                            )
                        )
                        return
                    }
                    continuation.resume(returning: .success(result))
                }
            )
        }
    }

    public func signOut() {
        GIDSignIn.sharedInstance.signOut()
    }
}

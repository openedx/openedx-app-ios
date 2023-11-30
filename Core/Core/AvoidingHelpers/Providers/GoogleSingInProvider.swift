//
//  GoogleSingInProvider.swift
//  Core
//
//  Created by Eugene Yatsenko on 10.10.2023.
//

import GoogleSignIn

public final class GoogleSingInProvider {

    public init() {}

    public func signIn(
        withPresenting: UIViewController,
        completion: @escaping ((GIDSignInResult?, Error?) -> Void)
    ) {
        GIDSignIn.sharedInstance.signIn(
            withPresenting: withPresenting,
            completion: { result, error in
                completion(result, error)
            }
        )
    }

    public func signOut() {
        GIDSignIn.sharedInstance.signOut()
    }
}

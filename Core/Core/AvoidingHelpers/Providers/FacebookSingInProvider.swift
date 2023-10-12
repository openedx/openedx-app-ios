//
//  FacebookSingInProvider.swift
//  Core
//
//  Created by Eugene Yatsenko on 10.10.2023.
//

import Foundation
import FacebookLogin

public final class FacebookSingInProvider {

    private  let loginManager = LoginManager()

    public init() {}

    public func signIn(
        withPresenting: UIViewController,
        completion: @escaping ((LoginManagerLoginResult?, Error?) -> Void)
    ) {
        loginManager.logIn(
            permissions: ["public_profile"],
            from: withPresenting,
            handler: completion
        )
    }

    public func signOut() {
        loginManager.logOut()
    }
}

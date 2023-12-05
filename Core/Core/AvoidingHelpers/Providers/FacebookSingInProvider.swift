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
            permissions: [],
            from: withPresenting,
            handler: { [weak self] result, error in

                if result?.isCancelled == true {
                    completion(nil, CustomError.socialSignCanceled)
                    return
                }

                if let error = error {
                    completion(nil, self?.failure(error))
                    return
                }

                if result?.authenticationToken == nil {
                    completion(nil, CustomError.error(text: CoreLocalization.Error.unknownError))
                    return
                }
                
                completion(result, nil)
            }
        )
    }

    public func signOut() {
        loginManager.logOut()
    }

    private func failure(_ error: Error?) -> Error {
        if let error = error as? NSError,
           let description = error.userInfo[ErrorLocalizedDescriptionKey] as? String {
            return CustomError.error(text: description)
        }
        return error ?? CustomError.error(text: CoreLocalization.Error.unknownError)
    }
}

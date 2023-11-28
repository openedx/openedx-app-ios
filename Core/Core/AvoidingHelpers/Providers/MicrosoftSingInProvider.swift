//
//  MicrosoftSingInProvider.swift
//  Core
//
//  Created by Eugene Yatsenko on 10.10.2023.
//

import Foundation
import MSAL
import Swinject

public typealias MSLoginCompletionHandler = (MSALAccount?, String?, Error?) -> Void

public final class MicrosoftSingInProvider {

    private let scopes = ["User.Read", "email"]
    private var result: MSALResult?

    public init() {}

    public func signIn(
        withPresenting: UIViewController,
        completion: @escaping MSLoginCompletionHandler
    ) {
        do {
            let clientApplication = try createClientApplication()

            let webParameters = MSALWebviewParameters(authPresentationViewController: withPresenting)
            let parameters = MSALInteractiveTokenParameters(scopes: scopes, webviewParameters: webParameters)
            clientApplication.acquireToken(with: parameters) { [weak self] result, error in
                guard let self = self else { return }

                guard let result = result, error == nil else {
                    completion(nil, nil, error)
                    return
                }

                self.result = result
                let account = result.account
                completion(account, result.accessToken, nil)
            }
        } catch let createApplicationError {
            completion(nil, nil, createApplicationError)
        }
    }

    public func signOut() {
        do {
            let account = try? currentAccount()

            if let account = account {
                let application = try createClientApplication()
                try application.remove(account)
            }
        } catch let error {
            debugLog("Logout", "Received error signing user out: \(error)")
        }
    }

    private func createClientApplication() throws -> MSALPublicClientApplication {
        guard let config = Container.shared.resolve(ConfigProtocol.self), let appID =  config.microsoft.appID else {
            throw CustomError.error(text: "Configuration error")
        }
        let configuration = MSALPublicClientApplicationConfig(clientId: appID)

        do {
            return try MSALPublicClientApplication(configuration: configuration)
        } catch {
            throw CustomError.error(text: error.localizedDescription)
        }
    }

    @discardableResult
    private func currentAccount() throws -> MSALAccount {
        let clientApplication = try createClientApplication()

        guard let account = try clientApplication.allAccounts().first else {
            throw CustomError.error(text: "Account not found")
        }

        return account
    }

    func getUser(completion: (MSALAccount) -> Void) {
        guard let user = result?.account else { return }
        completion(user)
    }

}

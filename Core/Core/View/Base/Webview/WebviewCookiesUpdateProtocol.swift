//
//  WebviewCookiesUpdateProtocol.swift
//  Core
//
//  Created by Saeed Bashir on 2/7/24.
//

import Foundation

//sourcery: AutoMockable

@MainActor
public protocol WebviewCookiesUpdateProtocol: AnyObject {
    var authInteractor: AuthInteractorProtocol { get }
    var cookiesReady: Bool { get set }
    var updatingCookies: Bool { get set }
    var errorMessage: String? { get set }
    func updateCookies(force: Bool, retryCount: Int) async
}

public extension WebviewCookiesUpdateProtocol {
    @MainActor
    func updateCookies(force: Bool = false, retryCount: Int = 1) async {
        guard !updatingCookies else { return }
        do {
            updatingCookies = true
            try await authInteractor.getCookies(force: force)
            cookiesReady = true
            updatingCookies = false
            errorMessage = nil
        } catch {
            if error.isInternetError {
                errorMessage = CoreLocalization.Error.slowOrNoInternetConnection
            } else if retryCount > 0 {
                await updateCookies(force: force, retryCount: retryCount - 1)
            } else {
                errorMessage = CoreLocalization.Error.unknownError
            }
            updatingCookies = false
        }
    }
}

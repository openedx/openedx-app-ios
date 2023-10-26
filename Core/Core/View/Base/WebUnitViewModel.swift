//
//  WebUnitViewModel.swift
//  Core
//
//  Created by  Stepanok Ivan on 17.10.2022.
//

import Foundation
import SwiftUI

public class WebUnitViewModel: ObservableObject {
    
    let authInteractor: AuthInteractorProtocol
    let config: Configurable

    @Published var updatingCookies: Bool = false
    @Published var cookiesReady: Bool = false
    @Published var showError: Bool = false
    private var retryCount = 1
    
    var errorMessage: String? {
        didSet {
            withAnimation {
                showError = errorMessage != nil
            }
        }
    }
    
    public init(authInteractor: AuthInteractorProtocol, config: Configurable) {
        self.authInteractor = authInteractor
        self.config = config
    }
    
    @MainActor
    func updateCookies(force: Bool = false) async {
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
                retryCount -= 1
                await updateCookies(force: force)
            } else {
                errorMessage = CoreLocalization.Error.unknownError
            }
            updatingCookies = false
        }
    }
}

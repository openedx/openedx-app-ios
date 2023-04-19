//
//  ResetPasswordViewModel.swift
//  Authorization
//
//  Created by  Stepanok Ivan on 28.03.2023.
//

import SwiftUI
import Core

public class ResetPasswordViewModel: ObservableObject {
    
    @Published private(set) var isShowProgress = false
    @Published private(set) var showError: Bool = false
    @Published private(set) var showAlert: Bool = false
    var errorMessage: String? {
        didSet {
            withAnimation {
                showError = errorMessage != nil
            }
        }
    }
    var alertMessage: String? {
        didSet {
            withAnimation {
                showAlert = alertMessage != nil
            }
        }
    }
    
    private let interactor: AuthInteractorProtocol
    let router: AuthorizationRouter
    private let validator: Validator
    
    public init(interactor: AuthInteractorProtocol, router: AuthorizationRouter, validator: Validator) {
        self.interactor = interactor
        self.router = router
        self.validator = validator
    }
    
    @MainActor
    func resetPassword(email: String, isRecovered: Binding<Bool>) async {
        guard validator.isValidEmail(email) else {
            errorMessage = AuthLocalization.Error.invalidEmailAddress
            return
        }
        isShowProgress = true
        do {
            _ = try await interactor.resetPassword(email: email).responseText.hideHtmlTagsAndUrls()
            isRecovered.wrappedValue.toggle()
            isShowProgress = false
        } catch {
            isShowProgress = false
            if let validationError = error.validationError,
               let value = validationError.data?["value"] as? String {
                errorMessage = value
            } else if case APIError.invalidGrant = error {
                errorMessage = CoreLocalization.Error.invalidCredentials
            } else if error.isInternetError {
                errorMessage = CoreLocalization.Error.slowOrNoInternetConnection
            } else {
                errorMessage = CoreLocalization.Error.unknownError
            }
        }
    }
}


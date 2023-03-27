//
//  SignInViewModel.swift
//  Authorization
//
//  Created by Vladimir Chekyrta on 14.09.2022.
//

import Foundation
import Core
import SwiftUI
import Alamofire

public class SignInViewModel: ObservableObject {
    
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
    func login(username: String, password: String) async {
        guard validator.isValidEmail(username) else {
            errorMessage = AuthLocalization.Error.invalidEmailAddress
            return
        }
        guard validator.isValidPassword(password) else {
            errorMessage = AuthLocalization.Error.invalidPasswordLenght
            return
        }
        
        isShowProgress = true
        do {
            try await interactor.login(username: username, password: password)
            router.showMainScreen()
        } catch let error {
            isShowProgress = false
            if let validationError = error.validationError,
               let value = validationError.data?["error_description"] as? String {
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

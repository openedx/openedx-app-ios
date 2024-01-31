//
//  SignUpViewModel.swift
//  Authorization
//
//  Created by  Stepanok Ivan on 24.10.2022.
//

import Foundation
import Core
import SwiftUI
import AuthenticationServices
import FacebookLogin
import GoogleSignIn
import MSAL

public class SignUpViewModel: ObservableObject {
    
    @Published var isShowProgress = false
    @Published var scrollTo: Int?
    @Published var showError: Bool = false
    @Published var thirdPartyAuthSuccess: Bool = false
    let sourceScreen: LogistrationSourceScreen
    
    var errorMessage: String? {
        didSet {
            withAnimation {
                showError = errorMessage != nil
            }
        }
    }
    
    @Published var fields: [FieldConfiguration] = []
    var requiredFields: [FieldConfiguration] {
        var fields = fields.filter { $0.field.required }
        if config.agreement.eulaURL != nil,
           !fields.contains(where: { $0.field.type == .checkbox }),
           let ckeckbox = self.fields.first(where: { $0.field.type == .checkbox }) {
            fields.append(ckeckbox)
        }
        return fields
    }
    var nonRequiredFields: [FieldConfiguration] {
        fields.filter { !$0.field.required }
    }

    let router: AuthorizationRouter
    let config: ConfigProtocol
    let cssInjector: CSSInjector
    
    private let interactor: AuthInteractorProtocol
    private let analytics: AuthorizationAnalytics
    private let validator: Validator

    public init(
        interactor: AuthInteractorProtocol,
        router: AuthorizationRouter,
        analytics: AuthorizationAnalytics,
        config: ConfigProtocol,
        cssInjector: CSSInjector,
        validator: Validator,
        sourceScreen: LogistrationSourceScreen
    ) {
        self.interactor = interactor
        self.router = router
        self.analytics = analytics
        self.config = config
        self.cssInjector = cssInjector
        self.validator = validator
        self.sourceScreen = sourceScreen
    }

    var socialAuthEnabled: Bool {
        let socialLoginEnabled = config.appleSignIn.enabled ||
        config.facebook.enabled ||
        config.microsoft.enabled ||
        config.google.enabled
        return socialLoginEnabled && !thirdPartyAuthSuccess && !isShowProgress
    }

    private func showErrors(errors: [String: String]) -> Bool {
        if thirdPartyAuthSuccess, !errors.map({ $0.value }).filter({ !$0.isEmpty }).isEmpty {
            scrollTo = 1
            return true
        }

        var containsError = false
        errors.forEach { key, value in
            if let index = fields.firstIndex(where: { $0.field.name == key }) {
                fields[index].error = value
                if value.count > 0 { containsError = true }
            }
        }
        scrollTo = fields.firstIndex(where: {$0.error != ""})
        return containsError
    }
    
    @MainActor
    public func getRegistrationFields() async {
        isShowProgress = true
        do {
            let fields = try await interactor.getRegistrationFields()
            self.fields = fields.map { FieldConfiguration(field: $0) }
            isShowProgress = false
        } catch let error {
            isShowProgress = false
            if error.isInternetError {
                errorMessage = CoreLocalization.Error.slowOrNoInternetConnection
            } else if error.isUpdateRequeiredError {
                router.showUpdateRequiredView(showAccountLink: false)
            } else {
                errorMessage = CoreLocalization.Error.unknownError
            }
        }
    }

    private var externalToken: String?
    private var backend: String?

    @MainActor
    func registerUser() async {
        do {
            let validateFields = configureFields()
            let errors = try await interactor.validateRegistrationFields(fields: validateFields)
            guard !showErrors(errors: errors) else { return }
            isShowProgress = true
            let user = try await interactor.registerUser(
                fields: validateFields,
                isSocial: externalToken != nil
            )
            analytics.setUserID("\(user.id)")
            analytics.registrationSuccess()
            isShowProgress = false
            router.showMainOrWhatsNewScreen(sourceScreen: sourceScreen)
            
        } catch let error {
            isShowProgress = false
            if case APIError.invalidGrant = error {
                errorMessage = CoreLocalization.Error.invalidCredentials
            } else if error.isInternetError {
                errorMessage = CoreLocalization.Error.slowOrNoInternetConnection
            } else {
                errorMessage = CoreLocalization.Error.unknownError
            }
        }
    }

    private func configureFields() -> [String: String] {
        var validateFields: [String: String] = [:]
        fields.forEach { validateFields[$0.field.name] = $0.text }
        validateFields["honor_code"] = "true"
        validateFields["terms_of_service"] = "true"
        if let externalToken = externalToken, let backend = backend {
            validateFields["access_token"] = externalToken
            validateFields["provider"] = backend
            validateFields["client_id"] = config.oAuthClientId
            if validateFields.contains(where: {$0.key == "password"}) {
                validateFields.removeValue(forKey: "password")
            }
            fields.removeAll { $0.field.type == .password }
        }
        return validateFields
    }

    @MainActor
    func register(with result: Result<SocialAuthDetails, Error>) async {
        switch result {
        case .success(let result):
            await loginOrRegister(
                result.response,
                backend: result.backend,
                authMethod: result.authMethod
            )
        case .failure(let error):
            errorMessage = error.localizedDescription
        }
    }

    @MainActor
    private func loginOrRegister(
        _ response: SocialAuthResponse,
        backend: String,
        authMethod: AuthMethod
    ) async {
        do {
            isShowProgress = true
            let user = try await interactor.login(externalToken: response.token, backend: backend)
            analytics.setUserID("\(user.id)")
            analytics.userLogin(method: authMethod)
            isShowProgress = false
            router.showMainOrWhatsNewScreen(sourceScreen: sourceScreen)
        } catch {
            update(fullName: response.name, email: response.email)
            self.externalToken = response.token
            self.backend = backend
            thirdPartyAuthSuccess = true
            isShowProgress = false
            await registerUser()
        }
    }

    private func update(fullName: String?, email: String?) {
        fields.first(where: { $0.field.type == .email })?.text = email ?? ""
        fields.first(where: { $0.field.name == "name" })?.text = fullName ?? ""
    }

    func trackCreateAccountClicked() {
        analytics.createAccountClicked()
    }
}

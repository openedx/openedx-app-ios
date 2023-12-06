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
    @Published var isThirdPartyAuthSuccess: Bool = false
    var errorMessage: String? {
        didSet {
            withAnimation {
                showError = errorMessage != nil
            }
        }
    }
    
    @Published var fields: [FieldConfiguration] = []
    
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
        validator: Validator
    ) {
        self.interactor = interactor
        self.router = router
        self.analytics = analytics
        self.config = config
        self.cssInjector = cssInjector
        self.validator = validator
    }

    var socialLoginEnabled: Bool {
        let socialLoginEnabled = config.appleSignIn.enabled ||
        config.facebook.enabled ||
        config.microsoft.enabled ||
        config.google.enabled
        return socialLoginEnabled && !isThirdPartyAuthSuccess && !isShowProgress
    }

    private func showErrors(errors: [String: String]) -> Bool {
        if isThirdPartyAuthSuccess, !errors.map({ $0.value }).filter({ !$0.isEmpty }).isEmpty {
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
            router.showMainOrWhatsNewScreen()
            
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
    func register(with result: Result<SocialAuthDetails, Error>) {
        result.success(socialAuth)
        result.failure { error in
            errorMessage = error.localizedDescription
        }
    }

    @MainActor
    private func socialAuth(result: SocialAuthDetails) {
        switch result {
        case .apple(let appleCredentials):
            appleRegister(appleCredentials, backend: result.backend, loginMethod: .socailAuth(.apple))
        case .facebook(let account):
            facebookRegister(backend: result.backend, account: account, loginMethod: .socailAuth(.facebook))
        case .google(let gIDSignInResult):
            googleRegister(gIDSignInResult, backend: result.backend, loginMethod: .socailAuth(.google))
        case .microsoft(let account, let token):
            microsoftRegister(token, backend: result.backend, account: account, loginMethod: .socailAuth(.microsoft))
        }
    }

    @MainActor
    private func appleRegister(
        _ credentials: AppleCredentials,
        backend: String,
        loginMethod: LoginMethod
    ) {
        update(
            fullName: credentials.name,
            email: credentials.email
        )
        registerSocial(
            externalToken: credentials.token,
            backend: backend,
            loginMethod: loginMethod
        )
    }

    @MainActor
    private func facebookRegister(
        backend: String,
        account: LoginManagerLoginResult,
        loginMethod: LoginMethod
    ) {
        guard let currentAccessToken = AccessToken.current?.tokenString else {
            return
        }

        GraphRequest(
            graphPath: "me",
            parameters: ["fields": "name, email"]
        ).start { [weak self] _, result, _ in
            guard let self = self, let userInfo = result as? [String: Any] else {
                return
            }
            self.update(
                fullName: userInfo["name"] as? String,
                email: userInfo["email"] as? String
            )
        }

        registerSocial(
            externalToken: currentAccessToken,
            backend: backend,
            loginMethod: loginMethod
        )

    }

    @MainActor
    private func googleRegister(
        _ result: GIDSignInResult,
        backend: String,
        loginMethod: LoginMethod
    ) {
        update(
            fullName: result.user.profile?.name,
            email: result.user.profile?.email
        )

        registerSocial(
            externalToken: result.user.accessToken.tokenString,
            backend: backend,
            loginMethod: loginMethod
        )
    }

    @MainActor
    private func microsoftRegister(
        _ token: String,
        backend: String,
        account: MSALAccount,
        loginMethod: LoginMethod
    ) {
        update(
            fullName: account.accountClaims?["name"] as? String,
            email: account.accountClaims?["email"] as? String
        )

        registerSocial(
            externalToken: token,
            backend: backend, 
            loginMethod: loginMethod
        )
    }

    @MainActor
    private func registerSocial(
        externalToken: String,
        backend: String,
        loginMethod: LoginMethod
    ) {
        Task {
            await loginOrRegister(
                externalToken: externalToken,
                backend: backend,
                loginMethod: loginMethod
            )
        }
    }

    @MainActor
    private func loginOrRegister(
        externalToken: String,
        backend: String,
        loginMethod: LoginMethod
    ) async {
        do {
            isShowProgress = true
            let validateFields = configureFields().filter { !$0.value.isEmpty }
            let user = try await interactor.login(externalToken: externalToken, backend: backend)
            analytics.setUserID("\(user.id)")
            analytics.userLogin(method: loginMethod)
            isShowProgress = false
            router.showMainOrWhatsNewScreen()
        } catch {
            self.externalToken = externalToken
            self.backend = backend
            isThirdPartyAuthSuccess = true
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

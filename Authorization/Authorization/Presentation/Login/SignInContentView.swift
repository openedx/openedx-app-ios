//
//  SignInContentView.swift
//  Authorization
//
//  Created by Eugene Yatsenko on 27.10.2023.
//

import SwiftUI
import Core

struct SignInContentView: View {

    @State private var email: String = ""
    @State private var password: String = ""

    @ObservedObject
    private var viewModel: SignInViewModel

    public init(viewModel: SignInViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(alignment: .center) {
            AuthLogoView(image: CoreAssets.appLogo.swiftUIImage)
            ScrollView {
                VStack(alignment: .leading) {
                    AuthWelcomeBackView(
                        title: AuthLocalization.SignIn.logInTitle,
                        text: AuthLocalization.SignIn.welcomeBack
                    )
                    VStack(spacing: 18) {
                        TitleTextField(
                            title: AuthLocalization.SignIn.email,
                            placeholder: AuthLocalization.SignIn.email,
                            keyboardType: .emailAddress,
                            textContentType: .emailAddress,
                            style: .none,
                            text: $email
                        )
                        TitleTextField(
                            title: AuthLocalization.SignIn.password,
                            placeholder: AuthLocalization.SignIn.password,
                            isSecure: true,
                            text: $password
                        )
                    }
                    ForgotRegisterButtonView(
                        onRegister: {
                            viewModel.trackSignUpClicked()
                            viewModel.router.showRegisterScreen()
                        },
                        onForgot: {
                            viewModel.trackForgotPasswordClicked()
                            viewModel.router.showForgotPasswordScreen()
                        }
                    ).padding(.top, 10)
                    ProgressStyledButton(isShowProgress: viewModel.state == .loading) {
                        Task {
                            await viewModel.login(username: email, password: password)
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 50)
            }
            .roundedBackground(Theme.Colors.background)
            .scrollAvoidKeyboard(dismissKeyboardByTap: true)
        }
    }
}

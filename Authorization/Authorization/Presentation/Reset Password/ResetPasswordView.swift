//
//  ResetPasswordView.swift
//  Authorization
//
//  Created by  Stepanok Ivan on 27.03.2023.
//

import SwiftUI
import Core
import OEXFoundation
import Theme

public struct ResetPasswordView: View {
    
    @State private var email: String = ""
    
    @State private var isRecovered: Bool = false
    
    @Environment(\.isHorizontal) private var isHorizontal
    
    @ObservedObject
    private var viewModel: ResetPasswordViewModel
    
    public init(viewModel: ResetPasswordViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .top) {
                VStack {
                    #if TENANTS
                    ThemeAssets.headerBackground.swiftUIImage
                        .resizable()
                        .edgesIgnoringSafeArea(.top)
                    #else
                    ThemeAssets.headerBackground.swiftUIImage
                        .resizable()
                        .edgesIgnoringSafeArea(.top)
                    #endif
                }
                .frame(maxWidth: .infinity, maxHeight: 200)
                .accessibilityIdentifier("auth_bg_image")

                VStack(alignment: .center) {
                    NavigationBar(title: AuthLocalization.Forgot.title,
                                  titleColor: Theme.Colors.loginNavigationText,
                                  leftButtonColor: Theme.Colors.loginNavigationText,
                                  leftButtonAction: {
                        viewModel.router.back()
                    }).padding(.leading, isHorizontal ? 48 : 0)

                    ScrollView {
                        VStack {
                            if isRecovered {
                                ZStack {
                                    VStack {
                                        CoreAssets.checkEmail.swiftUIImage
                                            .resizable()
                                            .frame(width: 100, height: 100)
                                            .padding(.bottom, 40)
                                            .padding(.top, 100)
                                            .accessibilityIdentifier("check_email_image")

                                        Text(AuthLocalization.Forgot.checkTitle)
                                            .font(Theme.Fonts.titleLarge)
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(Theme.Colors.textPrimary)
                                            .padding(.bottom, 4)
                                            .accessibilityIdentifier("recover_title_text")
                                        Text(AuthLocalization.Forgot.checkDescription + email)
                                            .font(Theme.Fonts.bodyMedium)
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(Theme.Colors.textPrimary)
                                            .padding(.bottom, 20)
                                            .accessibilityIdentifier("recover_description_text")
                                        StyledButton(CoreLocalization.SignIn.logInBtn) {
                                            viewModel.router.backToRoot(animated: true)
                                        }
                                        .padding(.top, 30)
                                        .frame(maxWidth: .infinity)
                                        .accessibilityIdentifier("signin_button")
                                    }
                                }

                            } else {
                                VStack(alignment: .leading) {
                                    Text(AuthLocalization.Forgot.title)
                                        .font(Theme.Fonts.displaySmall)
                                        .foregroundColor(Theme.Colors.textPrimary)
                                        .padding(.bottom, 4)
                                        .accessibilityIdentifier("forgot_title_text")
                                    Text(AuthLocalization.Forgot.description)
                                        .font(Theme.Fonts.titleSmall)
                                        .foregroundColor(Theme.Colors.textPrimary)
                                        .padding(.bottom, 20)
                                        .accessibilityIdentifier("forgot_description_text")
                                    Text(AuthLocalization.SignIn.email)
                                        .font(Theme.Fonts.labelLarge)
                                        .foregroundColor(Theme.Colors.textPrimary)
                                        .accessibilityIdentifier("email_text")
                                    TextField("", text: $email)
                                        .font(Theme.Fonts.bodyLarge)
                                        .foregroundColor(Theme.Colors.textInputTextColor)
                                        .keyboardType(.emailAddress)
                                        .textContentType(.emailAddress)
                                        .autocapitalization(.none)
                                        .autocorrectionDisabled()
                                        .padding(.all, 14)
                                        .background(
                                            Theme.InputFieldBackground(
                                                placeHolder: AuthLocalization.SignIn.email,
                                                text: email,
                                                padding: 15
                                            )
                                        )
                                        .overlay(
                                            Theme.Shapes.textInputShape
                                                .stroke(lineWidth: 1)
                                                .fill(Theme.Colors.textInputStroke)
                                        )
                                        .accessibilityIdentifier("email_textfield")
                                    if viewModel.isShowProgress {
                                        HStack(alignment: .center) {
                                            ProgressBar(size: 40, lineWidth: 8)
                                                .padding(20)
                                                .accessibilityIdentifier("progress_bar")
                                        }.frame(maxWidth: .infinity)
                                    } else {
                                        StyledButton(AuthLocalization.Forgot.request) {
                                            Task {
                                                await viewModel.resetPassword(email: email, isRecovered: $isRecovered)
                                            }
                                        }
                                        .padding(.top, 30)
                                        .frame(maxWidth: .infinity)
                                        .accessibilityIdentifier("reset_password_button")
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 50)
                        .frameLimit(width: proxy.size.width)
                    }.roundedBackground(Theme.Colors.background)
                        .scrollAvoidKeyboard(dismissKeyboardByTap: true)

                }

                // MARK: - Alert
                if viewModel.showAlert {
                    VStack {
                        Text(viewModel.alertMessage ?? "")
                            .shadowCardStyle(bgColor: Theme.Colors.accentColor,
                                             textColor: Theme.Colors.white)
                            .padding(.top, 80)
                            .accessibilityIdentifier("show_alert_text")
                        Spacer()

                    }
                    .transition(.move(edge: .top))
                    .onAppear {
                        doAfter(Theme.Timeout.snackbarMessageLongTimeout) {
                            viewModel.alertMessage = nil
                        }
                    }
                }

                // MARK: - Show error
                if viewModel.showError {
                    VStack {
                        Spacer()
                        SnackBarView(message: viewModel.errorMessage)
                    }.transition(.move(edge: .bottom))
                        .onAppear {
                            doAfter(Theme.Timeout.snackbarMessageLongTimeout) {
                                viewModel.errorMessage = nil
                            }
                        }
                }
            }
            .ignoresSafeArea(.all, edges: .horizontal)

            .background(Theme.Colors.background.ignoresSafeArea(.all))

            .navigationBarHidden(true)
        }
    }
}

#if DEBUG
struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = ResetPasswordViewModel(
            interactor: AuthInteractor.mock,
            router: AuthorizationRouterMock(),
            analytics: AuthorizationAnalyticsMock(),
            validator: Validator()
        )
        ResetPasswordView(viewModel: vm)
    }
}
#endif

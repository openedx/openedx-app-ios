//
//  ResetPasswordView.swift
//  Authorization
//
//  Created by  Stepanok Ivan on 27.03.2023.
//

import SwiftUI
import Core

public struct ResetPasswordView: View {
    
    @State private var email: String = ""
    
    @State private var isRecovered: Bool = false
    
    @ObservedObject
    private var viewModel: ResetPasswordViewModel
    
    public init(viewModel: ResetPasswordViewModel) {
        self.viewModel = viewModel
        UINavigationBar.appearance().tintColor = UIColor.white
    }
    
    public var body: some View {
        ZStack(alignment: .top) {
            VStack {
                CoreAssets.authBackground.swiftUIImage
                    .resizable()
                    .edgesIgnoringSafeArea(.top)
            }.frame(maxWidth: .infinity, maxHeight: 200)
            
            VStack(alignment: .center) {
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
                                    
                                    Text(AuthLocalization.Forgot.checkTitle)
                                        .font(Theme.Fonts.titleLarge)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Theme.Colors.textPrimary)
                                        .padding(.bottom, 4)
                                    Text(AuthLocalization.Forgot.checkDescription + email)
                                        .font(Theme.Fonts.bodyMedium)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Theme.Colors.textPrimary)
                                        .padding(.bottom, 20)
                                    StyledButton(AuthLocalization.SignIn.logInBtn) {
                                        viewModel.router.backToRoot(animated: true)
                                    }
                                    .padding(.top, 30)
                                    .frame(maxWidth: .infinity)
                                }
                            }
                            
                        } else {
                            VStack(alignment: .leading) {
                                Text(AuthLocalization.Forgot.title)
                                    .font(Theme.Fonts.displaySmall)
                                    .foregroundColor(Theme.Colors.textPrimary)
                                    .padding(.bottom, 4)
                                Text(AuthLocalization.Forgot.description)
                                    .font(Theme.Fonts.titleSmall)
                                    .foregroundColor(Theme.Colors.textPrimary)
                                    .padding(.bottom, 20)
                                Text(AuthLocalization.SignIn.email)
                                    .font(Theme.Fonts.labelLarge)
                                    .foregroundColor(Theme.Colors.textPrimary)
                                TextField(AuthLocalization.SignIn.email, text: $email)
                                    .keyboardType(.emailAddress)
                                    .textContentType(.emailAddress)
                                    .autocapitalization(.none)
                                    .autocorrectionDisabled()
                                    .padding(.all, 14)
                                    .background(
                                        Theme.Shapes.textInputShape
                                            .fill(Theme.Colors.textInputBackground)
                                    )
                                    .overlay(
                                        Theme.Shapes.textInputShape
                                            .stroke(lineWidth: 1)
                                            .fill(Theme.Colors.textInputStroke)
                                    )
                                if viewModel.isShowProgress {
                                    HStack(alignment: .center) {
                                        ProgressBar(size: 40, lineWidth: 8)
                                            .padding(20)
                                    }.frame(maxWidth: .infinity)
                                } else {
                                    StyledButton(AuthLocalization.Forgot.request) {
                                        Task {
                                            await viewModel.resetPassword(email: email, isRecovered: $isRecovered)
                                        }
                                    }
                                    .padding(.top, 30)
                                    .frame(maxWidth: .infinity)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 50)
                }.roundedBackground(Theme.Colors.background)
                    .scrollAvoidKeyboard(dismissKeyboardByTap: true)
                
            }
            .navigationBarHidden(false)
            .navigationBarBackButtonHidden(false)
            .navigationTitle(AuthLocalization.Forgot.title)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(AuthLocalization.Forgot.title)
                        .foregroundColor(.white)
                        .font(Theme.Fonts.titleMedium)
                }
            }
            .onDisappear {
                UINavigationBar.appearance().tintColor = CoreAssets.accentColor.color
            }
            
            // MARK: - Alert
            if viewModel.showAlert {
                VStack {
                    Text(viewModel.alertMessage ?? "")
                        .shadowCardStyle(bgColor: Theme.Colors.accentColor,
                                         textColor: .white)
                        .padding(.top, 80)
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
        .background(Theme.Colors.background.ignoresSafeArea(.all))
        .accentColor(.white)
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

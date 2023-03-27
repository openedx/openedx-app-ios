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
    private var viewModel: SignInViewModel
    
    public init(viewModel: SignInViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ZStack(alignment: .top) {
            VStack {
                CoreAssets.authBackground.swiftUIImage
                    .resizable()
                    .edgesIgnoringSafeArea(.top)
            }.frame(maxWidth: .infinity, maxHeight: 200)
            
            VStack(alignment: .center) {
                NavigationBar(title: AuthLocalization.Forgot.title,
                             titleColor: .white,
                             leftButtonColor: .white,
                             leftButtonAction: {
                   viewModel.router.back()
               })
                
                ScrollView {
                    VStack {
                        if !isRecovered {
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
                                        .foregroundColor(CoreAssets.textPrimary.swiftUIColor)
                                        .padding(.bottom, 4)
                                    Text(AuthLocalization.Forgot.checkDescription + email)
                                        .font(Theme.Fonts.bodyMedium)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(CoreAssets.textPrimary.swiftUIColor)
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
                                    .foregroundColor(CoreAssets.textPrimary.swiftUIColor)
                                    .padding(.bottom, 4)
                                Text(AuthLocalization.Forgot.description)
                                    .font(Theme.Fonts.titleSmall)
                                    .foregroundColor(CoreAssets.textPrimary.swiftUIColor)
                                    .padding(.bottom, 20)
                                Text(AuthLocalization.SignIn.email)
                                    .font(Theme.Fonts.labelLarge)
                                    .foregroundColor(CoreAssets.textPrimary.swiftUIColor)
                                TextField(AuthLocalization.SignIn.email, text: $email)
                                    .keyboardType(.emailAddress)
                                    .textContentType(.emailAddress)
                                    .autocapitalization(.none)
                                    .autocorrectionDisabled()
                                    .padding(.all, 14)
                                    .background(
                                        Theme.Shapes.textInputShape
                                            .fill(CoreAssets.textInputBackground.swiftUIColor)
                                    )
                                    .overlay(
                                        Theme.Shapes.textInputShape
                                            .stroke(lineWidth: 1)
                                            .fill(CoreAssets.textInputStroke.swiftUIColor)
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
                }.roundedBackground(CoreAssets.background.swiftUIColor)
                    .scrollAvoidKeyboard(dismissKeyboardByTap: true)
                
            }
            
            // MARK: - Alert
            if viewModel.showAlert {
                VStack {
                    Text(viewModel.alertMessage ?? "")
                        .shadowCardStyle(bgColor: CoreAssets.accentColor.swiftUIColor,
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
        .background(CoreAssets.background.swiftUIColor.ignoresSafeArea(.all))
    }
}

#if DEBUG
struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = SignInViewModel(
            interactor: AuthInteractor.mock,
            router: AuthorizationRouterMock(),
            validator: Validator()
        )
        ResetPasswordView(viewModel: vm)
    }
}
#endif

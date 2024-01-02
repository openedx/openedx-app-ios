//
//  SignInView.swift
//  Authorization
//
//  Created by Vladimir Chekyrta on 13.09.2022.
//

import SwiftUI
import Core
import Theme
import Swinject

public struct SignInView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    @Environment (\.isHorizontal) private var isHorizontal
    
    @ObservedObject
    private var viewModel: SignInViewModel
    
    public init(viewModel: SignInViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ZStack(alignment: .top) {
            VStack {
                ThemeAssets.authBackground.swiftUIImage
                    .resizable()
                    .edgesIgnoringSafeArea(.top)
            }.frame(maxWidth: .infinity, maxHeight: 200)
            if viewModel.config.features.startupScreenEnabled {
                VStack {
                    Button(action: { viewModel.router.back() }, label: {
                        CoreAssets.arrowLeft.swiftUIImage.renderingMode(.template)
                            .backButtonStyle(color: .white)
                    })
                    .foregroundColor(Theme.Colors.styledButtonText)
                    .padding(.leading, isHorizontal ? 48 : 0)
                    .padding(.top, 11)
                    
                }.frame(maxWidth: .infinity, alignment: .topLeading)
                    .padding(.top, isHorizontal ? 20 : 0)
            }
            
            VStack(alignment: .center) {
                ThemeAssets.appLogo.swiftUIImage
                    .resizable()
                    .frame(maxWidth: 189, maxHeight: 54)
                    .padding(.top, isHorizontal ? 20 : 40)
                    .padding(.bottom, isHorizontal ? 10 : 40)
                
                ScrollView {
                    VStack {
                        VStack(alignment: .leading) {
                            Text(AuthLocalization.SignIn.logInTitle)
                                .font(Theme.Fonts.displaySmall)
                                .foregroundColor(Theme.Colors.textPrimary)
                                .padding(.bottom, 4)
                            Text(AuthLocalization.SignIn.welcomeBack)
                                .font(Theme.Fonts.titleSmall)
                                .foregroundColor(Theme.Colors.textPrimary)
                                .padding(.bottom, 20)
                            
                            Text(AuthLocalization.SignIn.emailOrUsername)
                                .font(Theme.Fonts.labelLarge)
                                .foregroundColor(Theme.Colors.textPrimary)
                            TextField(AuthLocalization.SignIn.emailOrUsername, text: $email)
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
                            
                            Text(AuthLocalization.SignIn.password)
                                .font(Theme.Fonts.labelLarge)
                                .foregroundColor(Theme.Colors.textPrimary)
                                .padding(.top, 18)
                            SecureField(AuthLocalization.SignIn.password, text: $password)
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
                            HStack {
                                if !viewModel.config.features.startupScreenEnabled {
                                    Button(CoreLocalization.SignIn.registerBtn) {
                                        viewModel.router.showRegisterScreen(sourceScreen: viewModel.sourceScreen)
                                    }.foregroundColor(Theme.Colors.accentColor)
                                    
                                    Spacer()
                                }
                                    
                                Button(AuthLocalization.SignIn.forgotPassBtn) {
                                    viewModel.trackForgotPasswordClicked()
                                    viewModel.router.showForgotPasswordScreen()
                                }.foregroundColor(Theme.Colors.accentColor)
                                    .padding(.top, 0)
                            }
                            
                            if viewModel.isShowProgress {
                                HStack(alignment: .center) {
                                    ProgressBar(size: 40, lineWidth: 8)
                                        .padding(20)
                                }.frame(maxWidth: .infinity)
                            } else {
                                StyledButton(CoreLocalization.SignIn.logInBtn) {
                                    Task {
                                        await viewModel.login(username: email, password: password)
                                    }
                                }.frame(maxWidth: .infinity)
                                    .padding(.top, 40)
                            }
                        }
                        if viewModel.socialAuthEnabled {
                            SocialAuthView(
                                viewModel: .init(
                                    config: viewModel.config
                                ) { result in
                                    Task { await viewModel.login(with: result) }
                                }
                            )
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 50)
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
        .hideNavigationBar()
        .ignoresSafeArea(.all, edges: .horizontal)
        .background(Theme.Colors.background.ignoresSafeArea(.all))
    }
}

#if DEBUG
struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = SignInViewModel(
            interactor: AuthInteractor.mock,
            router: AuthorizationRouterMock(),
            config: ConfigMock(),
            analytics: AuthorizationAnalyticsMock(),
            validator: Validator(),
            sourceScreen: .default
        )
        
        SignInView(viewModel: vm)
            .preferredColorScheme(.light)
            .previewDisplayName("SignInView Light")
            .loadFonts()
        
        SignInView(viewModel: vm)
            .preferredColorScheme(.dark)
            .previewDisplayName("SignInView Dark")
            .loadFonts()
    }
}
#endif

//
//  SignInView.swift
//  Authorization
//
//  Created by Vladimir Chekyrta on 13.09.2022.
//

import SwiftUI
import Core

public struct SignInView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isRecoveryPassword = false
    
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
                CoreAssets.appLogo.swiftUIImage
                    .resizable()
                    .frame(maxWidth: 189, maxHeight: 54)
                    .padding(.vertical, 40)
                
                ScrollView {
                    VStack {
                        if isRecoveryPassword {
                            VStack(alignment: .leading) {
                                Text(AuthLocalization.Forgot.forgotPassword)
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
                                            await viewModel.resetPassword(email: email,
                                                                          isRecoveryPassord: $isRecoveryPassword)
                                        }
                                    }
                                    .padding(.top, 30)
                                    .frame(maxWidth: .infinity)
                                    HStack(alignment: .center) {
                                        Button(AuthLocalization.Forgot.back) {
                                            isRecoveryPassword = false
                                        }.foregroundColor(CoreAssets.accentColor.swiftUIColor)
                                    }.frame(maxWidth: .infinity)
                                        .padding(.top, 10)
                                    
                                }
                            }.rotation3DEffect(Angle(degrees: 180), axis: (x: CGFloat(0), y: CGFloat(100), z: CGFloat(0)))
                        } else {
                            VStack(alignment: .leading) {
                                Text(AuthLocalization.SignIn.logInTitle)
                                    .font(Theme.Fonts.displaySmall)
                                    .foregroundColor(CoreAssets.textPrimary.swiftUIColor)
                                    .padding(.bottom, 4)
                                Text(AuthLocalization.SignIn.welcomeBack)
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
                                
                                Text(AuthLocalization.SignIn.password)
                                    .font(Theme.Fonts.labelLarge)
                                    .foregroundColor(CoreAssets.textPrimary.swiftUIColor)
                                    .padding(.top, 18)
                                SecureField(AuthLocalization.SignIn.password, text: $password)
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
                                
                                HStack {
                                    Button(AuthLocalization.SignIn.registerBtn) {
                                        viewModel.router.showRegisterScreen()
                                    }.foregroundColor(CoreAssets.accentColor.swiftUIColor)
                                    
                                    Spacer()
                                    
                                    Button(AuthLocalization.SignIn.forgotPassBtn) {
                                        isRecoveryPassword = true
                                    }.foregroundColor(CoreAssets.accentColor.swiftUIColor)
                                }
                                .padding(.top, 10)
                                if viewModel.isShowProgress {
                                    HStack(alignment: .center) {
                                        ProgressBar(size: 40, lineWidth: 8)
                                            .padding(20)
                                    }.frame(maxWidth: .infinity)
                                } else {
                                    StyledButton(AuthLocalization.SignIn.logInBtn) {
                                        Task {
                                            await viewModel.login(username: email, password: password)
                                        }
                                    }.frame(maxWidth: .infinity)
                                        .padding(.top, 40)
                                }
                            }
                            Spacer()
                        }
                        
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 50)
                    .rotation3DEffect( isRecoveryPassword ? Angle(degrees: 180):
                                        Angle(degrees: 0), axis: (x: CGFloat(0),
                                                                  y: CGFloat(100),
                                                                  z: CGFloat(0)))
                    .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/)
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
struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = SignInViewModel(
            interactor: AuthInteractor.mock,
            router: AuthorizationRouterMock(),
            validator: Validator()
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

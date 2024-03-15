//
//  DeleteAccountView.swift
//  Profile
//
//  Created by  Stepanok Ivan on 28.02.2023.
//

import SwiftUI
import Core
import Theme

public struct DeleteAccountView: View {
    
    @ObservedObject
    private var viewModel: DeleteAccountViewModel
    
    public init(viewModel: DeleteAccountViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .top) {
                // MARK: - Page Body
                ScrollView {
                    VStack {
                        Group {
                            ZStack {
                                CoreAssets.bgDelete.swiftUIImage
                                CoreAssets.deleteChar.swiftUIImage
                                    .foregroundColor(Theme.Colors.accentXColor)
                                    .offset(y: -31)
                                CoreAssets.deleteEyes.swiftUIImage
                                    .offset(x: -7, y: -27)
                                    .accessibilityIdentifier("delete_account_image")
                            }.padding(.top, 50)
                            
                            HStack {
                                Text(ProfileLocalization.DeleteAccount.areYouSure)
                                    .foregroundColor(Theme.Colors.navigationBarTintColor)
                                + Text(ProfileLocalization.DeleteAccount.wantToDelete)
                                    .foregroundColor(Theme.Colors.alert)
                            }
                            .accessibilityIdentifier("are_you_sure_text")
                            
                        }.multilineTextAlignment(.center)
                            .font(Theme.Fonts.headlineSmall)
                        
                        Text(ProfileLocalization.DeleteAccount.description)
                            .foregroundColor(Theme.Colors.textSecondary)
                            .font(Theme.Fonts.labelLarge)
                            .multilineTextAlignment(.center)
                            .padding(.top, 16)
                            .accessibilityIdentifier("delete_account_description_text")
                        
                        // MARK: Password
                        Group {
                            Text(ProfileLocalization.DeleteAccount.password)
                                .foregroundColor(Theme.Colors.textSecondary)
                                .font(Theme.Fonts.labelLarge)
                                .multilineTextAlignment(.leading)
                                .padding(.top, 16)
                                .accessibilityIdentifier("password_text")
                            
                            HStack(spacing: 11) {
                                SecureField(ProfileLocalization.DeleteAccount.passwordDescription,
                                            text: $viewModel.password)
                                .font(Theme.Fonts.labelLarge)
                                .foregroundColor(Theme.Colors.textPrimary)
                                .accessibilityIdentifier("password_textfield")
                            }
                            .padding(.horizontal, 14)
                            .frame(minHeight: 48)
                            .frame(maxWidth: .infinity)
                            .background(
                                Theme.Shapes.textInputShape
                                    .fill(Theme.Colors.textInputBackground)
                            )
                            .overlay(
                                Theme.Shapes.textInputShape
                                    .stroke(lineWidth: 1)
                                    .fill(Theme.Colors.textInputUnfocusedStroke)
                            )
                            Text(viewModel.incorrectPassword
                                 ? ProfileLocalization.DeleteAccount.incorrectPassword
                                 : " ")
                            .foregroundColor(Theme.Colors.alert)
                            .font(Theme.Fonts.labelLarge)
                            .multilineTextAlignment(.leading)
                            .padding(.top, 0)
                            .shake($viewModel.incorrectPassword,
                                   onCompletion: { viewModel.incorrectPassword.toggle() })
                            .accessibilityIdentifier("incorrect_password_text")
                            
                        }.frame(minWidth: 0,
                                maxWidth: .infinity,
                                alignment: .topLeading)
                        
                        // MARK: Comfirmation button
                        if viewModel.isShowProgress {
                            ProgressBar(size: 40, lineWidth: 8)
                                .padding(.top, 20)
                                .padding(.horizontal)
                                .accessibilityIdentifier("progressbar")
                        } else {
                            StyledButton(
                                ProfileLocalization.DeleteAccount.comfirm,
                                action: {
                                    Task {
                                        try await viewModel.deleteAccount(password: viewModel.password)
                                    }
                                },
                                color: .clear,
                                textColor: Theme.Colors.alert,
                                borderColor: Theme.Colors.alert,
                                isActive: viewModel.password.count >= 2
                            )
                            .padding(.top, 18)
                            .accessibilityIdentifier("delete_account_button")
                        }
                        
                        // MARK: Back to profile
                        StyledButton(
                            ProfileLocalization.DeleteAccount.backToProfile,
                            action: {
                                viewModel.router.back()
                            },
                            color: Theme.Colors.accentColor,
                            textColor: Theme.Colors.primaryButtonTextColor,
                            iconImage: CoreAssets.arrowLeft.swiftUIImage,
                            iconPosition: .left
                        )
                        .padding(.top, 35)
                        .accessibilityIdentifier("back_button")
                    }
                    .frameLimit(width: proxy.size.width)
                }
                .padding(.horizontal, 24)
                .frame(minHeight: 0,
                       maxHeight: .infinity,
                       alignment: .top)
                .padding(.top, 8)
                .navigationBarHidden(false)
                .navigationBarBackButtonHidden(false)
                .navigationTitle(ProfileLocalization.DeleteAccount.title)
                
                // MARK: - Error Alert
                if viewModel.showError {
                    VStack {
                        Spacer()
                        SnackBarView(message: viewModel.errorMessage)
                    }
                    .padding(.bottom, viewModel.connectivity.isInternetAvaliable
                             ? 0 : OfflineSnackBarView.height)
                    .transition(.move(edge: .bottom))
                    .onAppear {
                        doAfter(Theme.Timeout.snackbarMessageLongTimeout) {
                            viewModel.errorMessage = nil
                        }
                    }
                }
            }
            .background(
                Theme.Colors.background
                    .ignoresSafeArea()
            )
        }
    }
}

#if DEBUG
struct DeleteAccountView_Previews: PreviewProvider {
    static var previews: some View {
        let router = ProfileRouterMock()
        let vm = DeleteAccountViewModel(
            interactor: ProfileInteractor.mock,
            router: router,
            connectivity: Connectivity()
        )
        
        DeleteAccountView(viewModel: vm)
    }
}
#endif

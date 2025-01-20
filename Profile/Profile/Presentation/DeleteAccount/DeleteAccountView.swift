//
//  DeleteAccountView.swift
//  Profile
//
//  Created by  Stepanok Ivan on 28.02.2023.
//

import SwiftUI
import Core
import OEXFoundation
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
                                Circle()
                                    .foregroundColor(Theme.Colors.deleteAccountBG)
                                    .frame(width: 104, height: 104)
                                CoreAssets.deleteChar.swiftUIImage.renderingMode(.template)
                                    .resizable()
                                    .foregroundColor(Theme.Colors.white)
                                    .frame(width: 60, height: 60)
                                    .offset(y: -5)
                                    .accessibilityIdentifier("delete_account_image")
                            }.padding(.top, 50)
                            
                            HStack {
                                Text(ProfileLocalization.DeleteAccount.areYouSure)
                                    .foregroundColor(Theme.Colors.navigationBarTintColor)
                                + Text(ProfileLocalization.DeleteAccount.wantToDelete)
                                    .foregroundColor(Theme.Colors.irreversibleAlert)
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
                                SecureField("",
                                            text: $viewModel.password)
                                .font(Theme.Fonts.labelLarge)
                                .foregroundColor(Theme.Colors.textInputTextColor)
                                .accessibilityIdentifier("password_textfield")
                            }
                            .padding(.horizontal, 14)
                            .frame(minHeight: 48)
                            .frame(maxWidth: .infinity)
                            .background(
                                Theme.InputFieldBackground(
                                    placeHolder: ProfileLocalization.DeleteAccount.passwordDescription,
                                    text: viewModel.password,
                                    padding: 15
                                )
                            )
                            .overlay(
                                Theme.Shapes.textInputShape
                                    .stroke(lineWidth: 1)
                                    .fill(Theme.Colors.textInputUnfocusedStroke)
                            )
                            Text(viewModel.incorrectPassword
                                 ? ProfileLocalization.DeleteAccount.incorrectPassword
                                 : " ")
                            .foregroundColor(Theme.Colors.irreversibleAlert)
                            .font(Theme.Fonts.labelLarge)
                            .multilineTextAlignment(.leading)
                            .padding(.top, 0)
                            .shake($viewModel.incorrectPassword,
                                   onCompletion: { viewModel.incorrectPassword.toggle() })
                            .accessibilityIdentifier("incorrect_password_text")
                            
                        }.frame(minWidth: 0,
                                maxWidth: .infinity,
                                alignment: .topLeading)
                        
                        // MARK: Confirmation button
                        if viewModel.isShowProgress {
                            ProgressBar(size: 40, lineWidth: 8)
                                .padding(.top, 20)
                                .padding(.horizontal)
                                .accessibilityIdentifier("progress_bar")
                        } else {
                            StyledButton(
                                ProfileLocalization.DeleteAccount.confirm,
                                action: {
                                    Task {
                                        try await viewModel.deleteAccount(password: viewModel.password)
                                    }
                                },
                                color: .clear,
                                textColor: Theme.Colors.irreversibleAlert,
                                borderColor: Theme.Colors.irreversibleAlert,
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
                .navigationBarBackButtonHidden(true)
                .navigationTitle(ProfileLocalization.DeleteAccount.title)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        BackNavigationButton(color: Theme.Colors.accentColor) {
                            viewModel.router.back()
                        }
                        .offset(x: -8, y: -1.5)
                    }
                }
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
            connectivity: Connectivity(),
            analytics: ProfileAnalyticsMock()
        )
        
        DeleteAccountView(viewModel: vm)
    }
}
#endif

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
    @EnvironmentObject var themeManager: ThemeManager
    
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
                                    .foregroundColor(themeManager.theme.colors.deleteAccountBG)
                                    .frame(width: 104, height: 104)
                                CoreAssets.deleteChar.swiftUIImage.renderingMode(.template)
                                    .resizable()
                                    .foregroundColor(themeManager.theme.colors.white)
                                    .frame(width: 60, height: 60)
                                    .offset(y: -5)
                                    .accessibilityIdentifier("delete_account_image")
                            }.padding(.top, 50)
                            
                            HStack {
                                Text(ProfileLocalization.DeleteAccount.areYouSure)
                                    .foregroundColor(themeManager.theme.colors.navigationBarTintColor)
                                + Text(ProfileLocalization.DeleteAccount.wantToDelete)
                                    .foregroundColor(themeManager.theme.colors.irreversibleAlert)
                            }
                            .accessibilityIdentifier("are_you_sure_text")
                            
                        }.multilineTextAlignment(.center)
                            .font(Theme.Fonts.headlineSmall)
                        
                        Text(ProfileLocalization.DeleteAccount.description)
                            .foregroundColor(themeManager.theme.colors.textSecondary)
                            .font(Theme.Fonts.labelLarge)
                            .multilineTextAlignment(.center)
                            .padding(.top, 16)
                            .accessibilityIdentifier("delete_account_description_text")
                        
                        // MARK: Password
                        Group {
                            Text(ProfileLocalization.DeleteAccount.password)
                                .foregroundColor(themeManager.theme.colors.textSecondary)
                                .font(Theme.Fonts.labelLarge)
                                .multilineTextAlignment(.leading)
                                .padding(.top, 16)
                                .accessibilityIdentifier("password_text")
                            
                            HStack(spacing: 11) {
                                SecureField("",
                                            text: $viewModel.password)
                                .font(Theme.Fonts.labelLarge)
                                .foregroundColor(themeManager.theme.colors.textInputTextColor)
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
                                    .fill(themeManager.theme.colors.textInputUnfocusedStroke)
                            )
                            Text(viewModel.incorrectPassword
                                 ? ProfileLocalization.DeleteAccount.incorrectPassword
                                 : " ")
                            .foregroundColor(themeManager.theme.colors.irreversibleAlert)
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
                                textColor: themeManager.theme.colors.irreversibleAlert,
                                borderColor: themeManager.theme.colors.irreversibleAlert,
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
                            color: themeManager.theme.colors.accentColor,
                            textColor: themeManager.theme.colors.primaryButtonTextColor,
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
                .onAppear {
                    NavigationAppearanceManager.shared.updateAppearance(
                        backgroundColor: themeManager.theme.colors.navigationBarColor.uiColor(),
                        titleColor: .white
                    )
                }
                .navigationBarHidden(false)
                .navigationBarBackButtonHidden(true)
                .navigationTitle(ProfileLocalization.DeleteAccount.title)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        BackNavigationButton(color: themeManager.theme.colors.accentColor) {
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
                themeManager.theme.colors.background
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

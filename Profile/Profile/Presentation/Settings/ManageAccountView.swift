//
//  ManageAccountView.swift
//  Profile
//
//  Created by  Stepanok Ivan on 10.04.2024.
//

import SwiftUI
import Core
import OEXFoundation
import Theme

public struct ManageAccountView: View {
    
    @ObservedObject
    private var viewModel: ManageAccountViewModel
    
    @Environment(\.isHorizontal) private var isHorizontal
    @EnvironmentObject var themeManager: ThemeManager
    
    public init(viewModel: ManageAccountViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .top) {
                VStack {
                    ThemeAssets.headerBackground.swiftUIImage
                        .resizable()
                        .edgesIgnoringSafeArea(.top)
                }
                .frame(maxWidth: .infinity, maxHeight: 200)
                .accessibilityIdentifier("auth_bg_image")
                
                // MARK: - Page name
                VStack(alignment: .center) {
                    ZStack {
                        HStack {
                            Text(ProfileLocalization.manageAccount)
                                .titleSettings(color: themeManager.theme.colors.loginNavigationText)
                                .accessibilityIdentifier("manage_account_text")
                        }
                        VStack {
                            BackNavigationButton(
                                color: themeManager.theme.colors.loginNavigationText,
                                action: {
                                    viewModel.router.back()
                                }
                            )
                            .backViewStyle()
                            .padding(.leading, isHorizontal ? 48 : 0)
                            .accessibilityIdentifier("back_button")
                            
                        }.frame(minWidth: 0,
                                maxWidth: .infinity,
                                alignment: .topLeading)
                    }
                    
                    // MARK: - Page Body
                    ScrollView {
                        VStack(alignment: .leading, spacing: 12) {
                            if viewModel.isShowProgress {
                                ProgressBar(size: 40, lineWidth: 8)
                                    .padding(.top, 200)
                                    .padding(.horizontal)
                                    .accessibilityIdentifier("progress_bar")
                            } else {
                                userAvatar
                                editProfileButton
                                deleteAccount
                            }
                        }
                    }
                    .refreshable {
                        Task {
                            await viewModel.getMyProfile(withProgress: false)
                        }
                    }
                    .frameLimit(width: proxy.size.width)
                    .padding(.top, 24)
                    .padding(.horizontal, isHorizontal ? 24 : 0)
                    .roundedBackground(themeManager.theme.colors.background)
                }
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
                .navigationTitle(ProfileLocalization.manageAccount)
                
                // MARK: - Offline mode SnackBar
                OfflineSnackBarView(
                    connectivity: viewModel.connectivity,
                    reloadAction: {
                        await viewModel.getMyProfile(withProgress: false)
                    }
                ).environmentObject(ThemeManager.shared)
                
                // MARK: - Error Alert
                if viewModel.showError {
                    VStack {
                        Spacer()
                        SnackBarView(message: viewModel.errorMessage)
                    }
                    .transition(.move(edge: .bottom))
                    .onAppear {
                        doAfter(Theme.Timeout.snackbarMessageLongTimeout) {
                            viewModel.errorMessage = nil
                        }
                    }
                }
            }
        }
        .background(
            themeManager.theme.colors.background
                .ignoresSafeArea()
        )
        .ignoresSafeArea(.all, edges: .horizontal)
        .onFirstAppear {
            Task {
                await viewModel.getMyProfile()
            }
        }
    }
    
    private var userAvatar: some View {
        HStack(alignment: .center, spacing: 12) {
            UserAvatar(url: viewModel.userModel?.avatarUrl ?? "", image: $viewModel.updatedAvatar)
                .accessibilityIdentifier("user_avatar_image")
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.userModel?.name ?? "")
                    .font(Theme.Fonts.headlineSmall)
                    .foregroundColor(themeManager.theme.colors.textPrimary)
                    .accessibilityIdentifier("user_name_text")
                Text("\(viewModel.userModel?.email ?? "")")
                    .font(Theme.Fonts.labelLarge)
                    .foregroundColor(themeManager.theme.colors.textSecondary)
                    .accessibilityIdentifier("user_username_text")
            }
            Spacer()
        }.padding(.all, 24)
            .frame(
                minWidth: 0,
                maxWidth: .infinity,
                alignment: .center
            )
    }
    
    private var deleteAccount: some View {
        Button(action: {
            viewModel.trackProfileDeleteAccountClicked()
            viewModel.router.showDeleteProfileView()
        }, label: {
            HStack {
                CoreAssets.deleteAccount.swiftUIImage
                Text(ProfileLocalization.Edit.deleteAccount)
            }
        })
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            alignment: .center
        )
        .font(Theme.Fonts.labelLarge)
        .foregroundColor(themeManager.theme.colors.alert)
        .padding(.top, 12)
        .accessibilityIdentifier("delete_account_button")
    }
    
    private var editProfileButton: some View {
        HStack(alignment: .center) {
            StyledButton(
                ProfileLocalization.editProfile,
                action: {
                    let userModel = viewModel.userModel ?? UserProfile()
                    viewModel.trackProfileEditClicked()
                    viewModel.router.showEditProfile(
                        userModel: userModel,
                        avatar: viewModel.updatedAvatar,
                        profileDidEdit: { updatedProfile, updatedImage in
                            if let updatedProfile {
                                self.viewModel.userModel = updatedProfile
                            }
                            if let updatedImage {
                                self.viewModel.updatedAvatar = updatedImage
                            }
                        }
                    )
                },
                color: themeManager.theme.colors.background,
                textColor: themeManager.theme.colors.accentColor,
                borderColor: themeManager.theme.colors.accentColor
            ).padding(.horizontal, 24)
        }
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            alignment: .center
        )
    }
}

#if DEBUG
struct ManageAccountView_Previews: PreviewProvider {
    static var previews: some View {
        let router = ProfileRouterMock()
        let vm = ManageAccountViewModel(
            router: router,
            analytics: ProfileAnalyticsMock(),
            config: ConfigMock(),
            connectivity: Connectivity(),
            interactor: ProfileInteractor.mock
        )
        
        ManageAccountView(viewModel: vm)
            .loadFonts()
    }
}
#endif

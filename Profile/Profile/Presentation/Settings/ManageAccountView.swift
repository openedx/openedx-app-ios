//
//  ManageAccountView.swift
//  Profile
//
//  Created by  Stepanok Ivan on 10.04.2024.
//

import SwiftUI
import Core
import Theme

public struct ManageAccountView: View {
    
    @ObservedObject
    private var viewModel: ManageAccountViewModel
    
    @Environment (\.isHorizontal) private var isHorizontal
    
    public init(viewModel: ManageAccountViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .top) {
                    // MARK: - Page Body
                    RefreshableScrollViewCompat(
                        action: {
                            await viewModel.getMyProfile(withProgress: false)
                        },
                        content: {
                            VStack(alignment: .leading, spacing: 12) {
                                if viewModel.isShowProgress {
                                    ProgressBar(size: 40, lineWidth: 8)
                                        .padding(.top, 200)
                                        .padding(.horizontal)
                                        .accessibilityIdentifier("progressbar")
                                } else {
                                    userAvatar
                                    editProfileButton
                                    deleteAccount
                                }
                            }
                            .padding(.top, 24)
                        })
                    .frameLimit(width: proxy.size.width)
                    .background(
                        Theme.Colors.background
                            .ignoresSafeArea()
                    )
                .navigationBarHidden(false)
                .navigationBarBackButtonHidden(false)
                .navigationTitle(ProfileLocalization.manageAccount)
                
                // MARK: - Offline mode SnackBar
                OfflineSnackBarView(
                    connectivity: viewModel.connectivity,
                    reloadAction: {
                        await viewModel.getMyProfile(withProgress: false)
                    }
                )
                
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
            .ignoresSafeArea(.all, edges: .horizontal)
            .onFirstAppear {
                Task {
                    await viewModel.getMyProfile()
                }
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
                    .foregroundColor(Theme.Colors.textPrimary)
                    .accessibilityIdentifier("user_name_text")
                Text("\(viewModel.userModel?.email ?? "")")
                    .font(Theme.Fonts.labelLarge)
                    .foregroundColor(Theme.Colors.textSecondary)
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
        .foregroundColor(Theme.Colors.alert)
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
                color: .clear,
                textColor: Theme.Colors.accentColor,
                borderColor: Theme.Colors.accentColor
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

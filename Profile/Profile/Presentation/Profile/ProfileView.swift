//
//  ProfileView.swift
//  Profile
//
//  Created by  Stepanok Ivan on 22.09.2022.
//

import SwiftUI
import Core
import Kingfisher

public struct ProfileView: View {
    
    @ObservedObject private var viewModel: ProfileViewModel
    
    public init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        Task {
            await viewModel.getMyProfile()
        }
    }
    
    public var body: some View {
        ZStack(alignment: .top) {
            
            // MARK: - Page name
            VStack(alignment: .center) {
                NavigationBar(title: ProfileLocalization.title,
                                     rightButtonType: .edit,
                rightButtonAction: {
                    if let userModel = viewModel.userModel {
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
                    }
                }, rightButtonIsActive: .constant(viewModel.connectivity.isInternetAvaliable))

                // MARK: - Page Body
                
                RefreshableScrollViewCompat(action: {
                    await viewModel.getMyProfile(withProgress: isIOS14)
                }) {
                    VStack {
                        if viewModel.isShowProgress {
                            ProgressBar(size: 40, lineWidth: 8)
                                .padding(.top, 200)
                                .padding(.horizontal)
                        } else {
                            UserAvatar(url: viewModel.userModel?.avatarUrl ?? "", image: $viewModel.updatedAvatar)
                                .padding(.top, 30)
                            Text(viewModel.userModel?.name ?? "")
                                .font(Theme.Fonts.headlineSmall)
                                .padding(.top, 20)
                            
                            Text("@\(viewModel.userModel?.username ?? "")")
                                .font(Theme.Fonts.labelLarge)
                                .padding(.top, 4)
                                .foregroundColor(CoreAssets.textSecondary.swiftUIColor)
                                .padding(.bottom, 10)
                            
                            // MARK: - Profile Info
                            if viewModel.userModel?.yearOfBirth != 0 || viewModel.userModel?.shortBiography != "" {
                                VStack(alignment: .leading, spacing: 14) {
                                    Text(ProfileLocalization.info)
                                        .padding(.horizontal, 24)
                                        .font(Theme.Fonts.labelLarge)
                                    
                                    VStack(alignment: .leading, spacing: 16) {
                                        if viewModel.userModel?.yearOfBirth != 0 {
                                            HStack {
                                                Text(ProfileLocalization.Edit.Fields.yearOfBirth)
                                                    .foregroundColor(CoreAssets.textSecondary.swiftUIColor)
                                                Text(String(viewModel.userModel?.yearOfBirth ?? 0))
                                            }
                                        }
                                        if let bio = viewModel.userModel?.shortBiography, bio != "" {
                                            HStack(alignment: .top) {
                                                Text(ProfileLocalization.bio + " ")
                                                    .foregroundColor(CoreAssets.textSecondary.swiftUIColor)
                                                + Text(bio)
                                            }
                                        }
                                    }
                                    .cardStyle(bgColor: CoreAssets.textInputUnfocusedBackground.swiftUIColor,
                                               strokeColor: .clear)
                                }.padding(.bottom, 16)
                            }
                            
                            VStack(alignment: .leading, spacing: 14) {
                                // MARK: - Settings
                                Text(ProfileLocalization.settings)
                                    .padding(.horizontal, 24)
                                    .font(Theme.Fonts.labelLarge)
                                VStack(alignment: .leading, spacing: 27) {
                                    HStack {
                                     Button(action: {
                                         viewModel.router.showSettings()
                                     }, label: {
                                            Text(ProfileLocalization.settingsVideo)
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                        })
                                    }
                                }.cardStyle(bgColor: CoreAssets.textInputUnfocusedBackground.swiftUIColor,
                                            strokeColor: .clear)
                                
                                // MARK: - Support info
                                Text(ProfileLocalization.supportInfo)
                                    .padding(.horizontal, 24)
                                    .font(Theme.Fonts.labelLarge)
                                VStack(alignment: .leading, spacing: 24) {
                                    if let support = viewModel.contactSupport() {
                                    HStack {
                                            Link(destination: support, label: {
                                                Text(ProfileLocalization.contact)
                                                Spacer()
                                                Image(systemName: "chevron.right")
                                            })
                                        }
                                        Rectangle()
                                            .frame(height: 1)
                                            .foregroundColor(CoreAssets.textSecondary.swiftUIColor)
                                    }
                                    if let tos = viewModel.config.termsOfUse {
                                        HStack {
                                            Link(destination: tos, label: {
                                                Text(ProfileLocalization.terms)
                                                Spacer()
                                                Image(systemName: "chevron.right")
                                            })
                                        }
                                        Rectangle()
                                            .frame(height: 1)
                                            .foregroundColor(CoreAssets.textSecondary.swiftUIColor)
                                    }
                                    if let privacy = viewModel.config.privacyPolicy {
                                        HStack {
                                            Link(destination: privacy, label: {
                                                Text(ProfileLocalization.privacy)
                                                Spacer()
                                                Image(systemName: "chevron.right")
                                            })
                                        }
                                    }
                                }.cardStyle(bgColor: CoreAssets.textInputUnfocusedBackground.swiftUIColor,
                                            strokeColor: .clear)
                                
                                // MARK: - Log out
                                VStack {
                                    HStack {
                                        Button(action: {
                                            viewModel.router.presentView(transitionStyle: .crossDissolve) {
                                                AlertView(
                                                    alertTitle: ProfileLocalization.LogoutAlert.title,
                                                    alertMessage: ProfileLocalization.LogoutAlert.text,
                                                    positiveAction: CoreLocalization.Alert.accept,
                                                    onCloseTapped: {
                                                        viewModel.router.dismiss(animated: true)
                                                    },
                                                    okTapped: {
                                                        Task {
                                                            await viewModel.logOut()
                                                        }
                                                        viewModel.router.dismiss(animated: true)
                                                    }, type: .logOut
                                                )
                                            }
                                        }, label: {
                                            Text(ProfileLocalization.logout)
                                            Spacer()
                                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                        })
                                    }
                                }.foregroundColor(CoreAssets.alert.swiftUIColor)
                                    .cardStyle(bgColor: CoreAssets.textInputUnfocusedBackground.swiftUIColor,
                                               strokeColor: .clear)
                                    .padding(.top, 24)
                                    .padding(.bottom, 60)
                            }
                            Spacer()
                        }
                    }
                }.frameLimit(sizePortrait: 420)
                
            }
            
            // MARK: - Offline mode SnackBar
            OfflineSnackBarView(connectivity: viewModel.connectivity,
                                reloadAction: {
                await viewModel.getMyProfile(withProgress: isIOS14)
            })
            
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
            CoreAssets.background.swiftUIColor
                .ignoresSafeArea()
        )
    }
}

#if DEBUG
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let router = ProfileRouterMock()
        let vm = ProfileViewModel(interactor: ProfileInteractor.mock,
                                  router: router,
                                  config: ConfigMock(),
                                  connectivity: Connectivity())
        
        ProfileView(viewModel: vm)
            .preferredColorScheme(.light)
            .previewDisplayName("DiscoveryView Light")
            .loadFonts()
        
        ProfileView(viewModel: vm)
            .preferredColorScheme(.dark)
            .previewDisplayName("DiscoveryView Dark")
            .loadFonts()
    }
}
#endif

struct UserAvatar: View {
    
    private var url: URL?
    @Binding private var image: UIImage?
    
    init(url: String, image: Binding<UIImage?>) {
        if let rightUrl = URL(string: url) {
            self.url = rightUrl
        } else {
            self.url = nil
        }
        self._image = image
    }
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(CoreAssets.avatarStroke.swiftUIColor)
                .frame(width: 104, height: 104)
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .cornerRadius(50)
            } else {
                KFImage(url)
                    .onFailureImage(CoreAssets.noCourseImage.image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .cornerRadius(50)
            }
        }
    }
}

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
    
    @StateObject private var viewModel: ProfileViewModel
    @Binding var settingsTapped: Bool
    
    public init(viewModel: ProfileViewModel, settingsTapped: Binding<Bool>) {
        self._viewModel = StateObject(wrappedValue: { viewModel }())
        self._settingsTapped = settingsTapped
    }

    public var body: some View {
        ZStack(alignment: .top) {
            // MARK: - Page Body
            RefreshableScrollViewCompat(action: {
                await viewModel.getMyProfile(withProgress: false)
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
                            .foregroundColor(Theme.Colors.textSecondary)
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
                                                .foregroundColor(Theme.Colors.textSecondary)
                                            Text(String(viewModel.userModel?.yearOfBirth ?? 0))
                                        }
                                    }
                                    if let bio = viewModel.userModel?.shortBiography, bio != "" {
                                        HStack(alignment: .top) {
                                            Text(ProfileLocalization.bio + " ")
                                                .foregroundColor(Theme.Colors.textSecondary)
                                            + Text(bio)
                                        }
                                    }
                                }
                                .cardStyle(
                                    bgColor: Theme.Colors.textInputUnfocusedBackground,
                                    strokeColor: .clear
                                )
                            }.padding(.bottom, 16)
                        }
                        
                        VStack(alignment: .leading, spacing: 14) {
                            // MARK: - Settings
                            Text(ProfileLocalization.settings)
                                .padding(.horizontal, 24)
                                .font(Theme.Fonts.labelLarge)
                            VStack(alignment: .leading, spacing: 27) {
                                Button(action: {
                                    viewModel.trackProfileVideoSettingsClicked()
                                    viewModel.router.showSettings()
                                }, label: {
                                    HStack {
                                        Text(ProfileLocalization.settingsVideo)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                    }
                                })
                                
                            }.cardStyle(
                                bgColor: Theme.Colors.textInputUnfocusedBackground,
                                strokeColor: .clear
                            )
                            
                            // MARK: - Support info
                            Text(ProfileLocalization.supportInfo)
                                .padding(.horizontal, 24)
                                .font(Theme.Fonts.labelLarge)
                            VStack(alignment: .leading, spacing: 24) {
                                if let support = viewModel.contactSupport() {
                                    Button(action: {
                                        viewModel.trackEmailSupportClicked()
                                        UIApplication.shared.open(support)
                                    }, label: {
                                        HStack {
                                            Text(ProfileLocalization.contact)
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                        }
                                    })
                                    .buttonStyle(PlainButtonStyle())
                                    .foregroundColor(.primary)
                                    Rectangle()
                                        .frame(height: 1)
                                        .foregroundColor(Theme.Colors.textSecondary)
                                }
                                
                                if let tos = viewModel.config.agreement.tosURL {
                                    Button(action: {
                                        viewModel.trackCookiePolicyClicked()
                                        UIApplication.shared.open(tos)
                                    }, label: {
                                        HStack {
                                            Text(ProfileLocalization.terms)
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                        }
                                    })
                                    .buttonStyle(PlainButtonStyle())
                                    .foregroundColor(.primary)
                                    Rectangle()
                                        .frame(height: 1)
                                        .foregroundColor(Theme.Colors.textSecondary)
                                }
                                
                                if let privacy = viewModel.config.agreement.privacyPolicyURL {
                                    Button(action: {
                                        viewModel.trackPrivacyPolicyClicked()
                                        UIApplication.shared.open(privacy)
                                    }, label: {
                                        HStack {
                                            Text(ProfileLocalization.privacy)
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                        }
                                    })
                                    .buttonStyle(PlainButtonStyle())
                                    .foregroundColor(.primary)
                                }
                                
                                // MARK: Version
                                    Rectangle()
                                        .frame(height: 1)
                                        .foregroundColor(Theme.Colors.textSecondary)
                                    Button(action: {
                                        viewModel.openAppStore()
                                    }, label: {
                                        HStack {
                                            VStack(alignment: .leading, spacing: 0) {
                                                HStack {
                                                    if viewModel.versionState == .updateRequired {
                                                        CoreAssets.warningFilled.swiftUIImage
                                                            .resizable()
                                                            .frame(width: 24, height: 24)
                                                    }
                                                    Text("\(ProfileLocalization.Settings.version) \(viewModel.currentVersion)")
                                                }
                                                switch viewModel.versionState {
                                                case .actual:
                                                    HStack {
                                                        CoreAssets.checkmark.swiftUIImage
                                                            .renderingMode(.template)
                                                            .foregroundColor(.green)
                                                        Text(ProfileLocalization.Settings.upToDate)
                                                            .font(Theme.Fonts.labelMedium)
                                                            .foregroundStyle(Theme.Colors.textSecondary)
                                                    }
                                                case .updateNeeded:
                                                    Text("\(ProfileLocalization.Settings.tapToUpdate) \(viewModel.latestVersion)")
                                                        .font(Theme.Fonts.labelMedium)
                                                        .foregroundStyle(Theme.Colors.accentColor)
                                                case .updateRequired:
                                                    Text(ProfileLocalization.Settings.tapToInstall)
                                                        .font(Theme.Fonts.labelMedium)
                                                        .foregroundStyle(Theme.Colors.accentColor)
                                                }
                                            }
                                            Spacer()
                                            if viewModel.versionState != .actual {
                                                Image(systemName: "arrow.up.circle")
                                                    .resizable()
                                                    .frame(width: 24, height: 24)
                                                    .foregroundStyle(Theme.Colors.accentColor)
                                            }
                                            
                                        }
                                    }).disabled(viewModel.versionState == .actual)
                                
                            }.cardStyle(
                                bgColor: Theme.Colors.textInputUnfocusedBackground,
                                strokeColor: .clear
                            )
                            
                            // MARK: - Log out
                            VStack {
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
                                                viewModel.router.dismiss(animated: true)
                                                Task {
                                                    await viewModel.logOut()
                                                }
                                            }, type: .logOut
                                        )
                                    }
                                }, label: {
                                    HStack {
                                        Text(ProfileLocalization.logout)
                                        Spacer()
                                        Image(systemName: "rectangle.portrait.and.arrow.right")
                                    }
                                })
                                
                            }
                            .foregroundColor(Theme.Colors.alert)
                            .cardStyle(bgColor: Theme.Colors.textInputUnfocusedBackground,
                                       strokeColor: .clear)
                            .padding(.top, 24)
                            .padding(.bottom, 60)
                        }
                        Spacer()
                    }
                }
            }.frameLimit(sizePortrait: 420)
                .padding(.top, 8)
                .onChange(of: settingsTapped, perform: { _ in
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
                })
                .navigationBarHidden(false)
                .navigationBarBackButtonHidden(false)
            
            // MARK: - Offline mode SnackBar
            OfflineSnackBarView(connectivity: viewModel.connectivity,
                                reloadAction: {
                await viewModel.getMyProfile(withProgress: false)
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
        .onFirstAppear {
            Task {
                await viewModel.getMyProfile()
            }
        }
        .background(
            Theme.Colors.background
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
                                  analytics: ProfileAnalyticsMock(),
                                  config: ConfigMock(),
                                  connectivity: Connectivity())
        
        ProfileView(viewModel: vm, settingsTapped: .constant(false))
            .preferredColorScheme(.light)
            .previewDisplayName("DiscoveryView Light")
            .loadFonts()
        
        ProfileView(viewModel: vm, settingsTapped: .constant(false))
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
                .foregroundColor(Theme.Colors.avatarStroke)
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

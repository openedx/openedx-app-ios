//
//  ProfileView.swift
//  Profile
//
//  Created by  Stepanok Ivan on 22.09.2022.
//

import SwiftUI
import Core
import Kingfisher
import Theme

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
            RefreshableScrollViewCompat(
                action: {
                    await viewModel.getMyProfile(withProgress: false)
                },
                content: content
            )
            .accessibilityAction {}
            .frameLimit(sizePortrait: 420)
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
                .padding(
                    .bottom,
                    viewModel.connectivity.isInternetAvaliable
                    ? 0 : OfflineSnackBarView.height
                )
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

    private var progressBar: some View {
        ProgressBar(size: 40, lineWidth: 8)
            .padding(.top, 200)
            .padding(.horizontal)
    }

    private func content() -> some View {
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
                profileInfo
                VStack(alignment: .leading, spacing: 14) {
                   settings
                   ProfileSupportInfoView(viewModel: viewModel)
                   logOutButton
                }
                Spacer()
            }
        }
    }

    // MARK: - Profile Info

    @ViewBuilder
    private var profileInfo: some View {
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
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(
                    (viewModel.userModel?.yearOfBirth != 0 ?
                     ProfileLocalization.Edit.Fields.yearOfBirth + String(viewModel.userModel?.yearOfBirth ?? 0) :
                        "") +
                    (viewModel.userModel?.shortBiography != nil ?
                     ProfileLocalization.bio + (viewModel.userModel?.shortBiography ?? "") :
                        "")
                )
                .cardStyle(
                    bgColor: Theme.Colors.textInputUnfocusedBackground,
                    strokeColor: .clear
                )
            }.padding(.bottom, 16)
        }
    }

    // MARK: - Settings

    @ViewBuilder
    private var settings: some View {
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

        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(ProfileLocalization.settingsVideo)
        .cardStyle(
            bgColor: Theme.Colors.textInputUnfocusedBackground,
            strokeColor: .clear
        )
    }

    // MARK: - Log out

    private var logOutButton: some View {
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
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(ProfileLocalization.logout)
        }
        .foregroundColor(Theme.Colors.alert)
        .cardStyle(bgColor: Theme.Colors.textInputUnfocusedBackground,
                   strokeColor: .clear)
        .padding(.top, 24)
        .padding(.bottom, 60)
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

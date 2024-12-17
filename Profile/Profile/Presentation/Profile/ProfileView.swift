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
import OEXFoundation

public struct ProfileView: View {
    
    @StateObject private var viewModel: ProfileViewModel
    
    public init(viewModel: ProfileViewModel) {
        self._viewModel = StateObject(wrappedValue: { viewModel }())
    }
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .top) {
                // MARK: - Page Body
                ScrollView {
                        content
                            .frameLimit(width: proxy.size.width)
                    }
                .refreshable {
                    Task {
                        await viewModel.getMyProfile(withProgress: false)
                    }

                }
                .accessibilityAction {}
                .padding(.top, 8)
                .navigationBarHidden(false)
                .navigationBarBackButtonHidden(false)
                .navigationTitle(ProfileLocalization.title)
                
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
            .onAppear {
                Task {
                    await viewModel.getMyProfile()
                }
            }
            .background(
                Theme.Colors.background
                    .ignoresSafeArea()
            )
            .onReceive(NotificationCenter.default.publisher(for: .profileUpdated)) { _ in
                Task {
                    await viewModel.getMyProfile()
                }
            }
        }
    }
    
    private var progressBar: some View {
        ProgressBar(size: 40, lineWidth: 8)
            .padding(.top, 200)
            .padding(.horizontal)
    }
    
    private var editProfileButton: some View {
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
            color: Theme.Colors.background,
            textColor: Theme.Colors.accentColor,
            borderColor: Theme.Colors.accentColor
        ).padding(.all, 24)
    }
    
    private var content: some View {
        VStack {
            if viewModel.isShowProgress {
                ProgressBar(size: 40, lineWidth: 8)
                    .padding(.top, 200)
                    .padding(.horizontal)
                    .accessibilityIdentifier("progress_bar")
            } else {
                HStack(alignment: .center, spacing: 12) {
                    UserAvatar(url: viewModel.userModel?.avatarUrl ?? "", image: $viewModel.updatedAvatar)
                        .accessibilityIdentifier("user_avatar_image")
                    VStack(alignment: .leading, spacing: 4) {
                        Text(viewModel.userModel?.name ?? "")
                            .font(Theme.Fonts.headlineSmall)
                            .foregroundColor(Theme.Colors.textPrimary)
                            .accessibilityIdentifier("user_name_text")
                        Text("@\(viewModel.userModel?.username ?? "")")
                            .font(Theme.Fonts.labelLarge)
                            .foregroundColor(Theme.Colors.textSecondary)
                            .accessibilityIdentifier("user_username_text")
                    }
                    Spacer()
                }.padding(.all, 24)
                profileInfo
                editProfileButton
                Spacer()
            }
        }
    }

    // MARK: - Profile Info
    @ViewBuilder
    private var profileInfo: some View {
        if let bio = viewModel.userModel?.shortBiography, bio != "" {
            VStack(alignment: .leading, spacing: 6) {
                Text(ProfileLocalization.about)
                    .font(Theme.Fonts.titleSmall)
                    .foregroundColor(Theme.Colors.textPrimary)
                    .accessibilityIdentifier("profile_info_text")
                Text(bio)
                    .font(Theme.Fonts.bodyMedium)
                    .foregroundColor(Theme.Colors.textPrimary)
                    .accessibilityIdentifier("bio_text")
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
        }
    }
}

#if DEBUG
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let router = ProfileRouterMock()
        let vm = ProfileViewModel(
            interactor: ProfileInteractor.mock,
            router: router,
            analytics: ProfileAnalyticsMock(),
            config: ConfigMock(),
            connectivity: Connectivity()
        )
        
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
    private var borderColor: Color
    @Binding private var image: UIImage?
    init(url: String, image: Binding<UIImage?>, borderColor: Color = Theme.Colors.avatarStroke) {
        if let rightUrl = URL(string: url) {
            self.url = rightUrl
        } else {
            self.url = nil
        }
        self._image = image
        self.borderColor = borderColor
    }
    var body: some View {
        ZStack {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .cornerRadius(40)
                    .overlay {
                        Circle()
                            .stroke(borderColor, lineWidth: 1)
                    }
            } else {
                KFImage(url)
                    .onFailureImage(CoreAssets.noCourseImage.image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .cornerRadius(40)
                    .overlay {
                        Circle()
                            .stroke(borderColor, lineWidth: 1)
                    }
            }
        }
    }
}

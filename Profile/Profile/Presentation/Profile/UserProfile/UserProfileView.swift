//
//  UserProfileView.swift
//  Profile
//
//  Created by  Stepanok Ivan on 10.10.2023.
//

import SwiftUI
import Core
import OEXFoundation
import Kingfisher
import Theme

public struct UserProfileView: View {
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var viewModel: UserProfileViewModel
    @EnvironmentObject var themeManager: ThemeManager
    
    public var isSheet: Bool

    public init(viewModel: UserProfileViewModel, isSheet: Bool = false) {
        self.viewModel = viewModel
        self.isSheet = isSheet
    }
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .top) {
                themeManager.theme.colors.background
                    .ignoresSafeArea()
                // MARK: - Page Body
                ScrollView {
                    VStack {
                        if viewModel.isShowProgress {
                            ProgressBar(size: 40, lineWidth: 8)
                                .padding(.top, 200)
                                .padding(.horizontal)
                        } else {
                            ProfileAvatar(url: viewModel.userModel?.avatarUrl ?? "")
                            if let name = viewModel.userModel?.name, name != "" {
                                Text(name)
                                    .font(Theme.Fonts.headlineSmall)
                                    .padding(.top, 20)
                            }
                            Text("@\(viewModel.userModel?.username ?? "")")
                                .font(Theme.Fonts.labelLarge)
                                .padding(.top, 4)
                                .foregroundColor(themeManager.theme.colors.textSecondary)
                                .padding(.bottom, 10)
                            
                            // MARK: - Profile Info
                            if viewModel.userModel?.yearOfBirth != 0 || viewModel.userModel?.shortBiography != "" {
                                VStack(alignment: .leading, spacing: 14) {
                                    Text(ProfileLocalization.info)
                                        .padding(.horizontal, 24)
                                        .font(Theme.Fonts.labelLarge)
                                        .foregroundColor(themeManager.theme.colors.textSecondary)
                                    
                                    VStack(alignment: .leading, spacing: 16) {
                                        if viewModel.userModel?.yearOfBirth != 0 {
                                            HStack {
                                                Text(ProfileLocalization.Edit.Fields.yearOfBirth)
                                                    .foregroundColor(themeManager.theme.colors.textSecondary)
                                                Text(String(viewModel.userModel?.yearOfBirth ?? 0))
                                            }
                                        }
                                        if let bio = viewModel.userModel?.shortBiography, bio != "" {
                                            HStack(alignment: .top) {
                                                Text(ProfileLocalization.bio + " ")
                                                    .foregroundColor(themeManager.theme.colors.textSecondary)
                                                + Text(bio)
                                            }
                                        }
                                    }
                                    .cardStyle(
                                        bgColor: themeManager.theme.colors.textInputUnfocusedBackground,
                                        strokeColor: .clear
                                    )
                                }.padding(.bottom, 16)
                            }
                        }
                        Spacer()
                    }
                    .frameLimit(width: proxy.size.width)
                }
                .refreshable {
                    Task {
                        await viewModel.getUserProfile(withProgress: false)
                    }
                }
                .padding(.top, 8)
                .navigationBarHidden(false)
                .navigationBarBackButtonHidden(false)
                
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
            .onAppear {
                NavigationAppearanceManager.shared.updateAppearance(
                    backgroundColor: themeManager.theme.colors.navigationBarColor.uiColor(),
                                    titleColor: .white
                                )
            }
            .onFirstAppear {
                Task {
                    await viewModel.getUserProfile()
                }
            }
        }
        .sheetNavigation(isSheet: isSheet) {
            dismiss()
        }

    }
}

struct ProfileAvatar: View {
    
    private var url: URL?
    @EnvironmentObject var themeManager: ThemeManager
    
    init(url: String) {
        if let rightUrl = URL(string: url) {
            self.url = rightUrl
        } else {
            self.url = nil
        }
    }
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(themeManager.theme.colors.avatarStroke)
                .frame(width: 104, height: 104)
            KFImage(url)
                .onFailureImage(CoreAssets.noCourseImage.image)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .cornerRadius(50)
        }
    }
}

#if DEBUG
struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        
        let vm = UserProfileViewModel(
            interactor: ProfileInteractor.mock,
            username: "demo"
        )
        
        return UserProfileView(viewModel: vm)
    }
}
#endif

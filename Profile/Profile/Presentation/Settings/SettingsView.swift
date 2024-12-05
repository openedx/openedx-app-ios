//
//  SettingsView.swift
//  Profile
//
//  Created by  Stepanok Ivan on 16.03.2023.
//

import SwiftUI
import Core
import OEXFoundation
import Kingfisher
import Theme

public struct SettingsView: View {
    
    @ObservedObject
    private var viewModel: SettingsViewModel
    
    @Environment(\.isHorizontal) private var isHorizontal
    
    public init(viewModel: SettingsViewModel) {
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
                .frame(maxWidth: .infinity, maxHeight: 50)
                .accessibilityIdentifier("auth_bg_image")
                
                // MARK: - Page name
                VStack(alignment: .center) {
                    ZStack {
                        HStack {
                            Text(ProfileLocalization.settings)
                                .titleSettings(color: Theme.Colors.loginNavigationText)
                                .accessibilityIdentifier("register_text")
                        }
                        VStack {
                            BackNavigationButton(
                                color: Theme.Colors.loginNavigationText,
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
                                manageAccount
                                settings
                                datesAndCalendar
                                ProfileSupportInfoView(viewModel: viewModel)
                                logOutButton
                            }
                        }
                        .frame(
                            minWidth: 0,
                            maxWidth: .infinity,
                            alignment: .topLeading
                        )
                        .frameLimit(width: proxy.size.width)
                        .padding(.top, 24)
                        .padding(.horizontal, isHorizontal ? 24 : 0)
                    }
                    .roundedBackground(Theme.Colors.background)
                }
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
                .navigationTitle(ProfileLocalization.settings)
                
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
            Theme.Colors.background
                .ignoresSafeArea()
        )
        .ignoresSafeArea(.all, edges: .horizontal)
    }
    
    // MARK: - Dates & Calendar
    
    @ViewBuilder
    private var datesAndCalendar: some View {

        VStack(alignment: .leading, spacing: 27) {
            Button(action: {
//                viewModel.trackProfileVideoSettingsClicked()
                viewModel.router.showDatesAndCalendar()
            }, label: {
                HStack {
                    Text(ProfileLocalization.datesAndCalendar)
                        .font(Theme.Fonts.titleMedium)
                    Spacer()
                    Image(systemName: "chevron.right")
                }
            })
            .accessibilityIdentifier("dates_and_calendar_cell")

        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(ProfileLocalization.datesAndCalendar)
        .cardStyle(
            bgColor: Theme.Colors.textInputUnfocusedBackground,
            strokeColor: .clear
        )
    }
    
    // MARK: - Manage Account
    @ViewBuilder
    private var manageAccount: some View {
        VStack(alignment: .leading, spacing: 27) {
            Button(action: {
                viewModel.trackProfileVideoSettingsClicked()
                viewModel.router.showManageAccount()
            }, label: {
                HStack {
                    Text(ProfileLocalization.manageAccount)
                        .font(Theme.Fonts.titleMedium)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .flipsForRightToLeftLayoutDirection(true)
                }
            })
            .accessibilityIdentifier("video_settings_button")
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(ProfileLocalization.manageAccount)
        .cardStyle(
            bgColor: Theme.Colors.textInputUnfocusedBackground,
            strokeColor: .clear
        )
    }
    
    // MARK: - Settings
    
    @ViewBuilder
    private var settings: some View {
        Text(ProfileLocalization.settings)
            .padding(.horizontal, 24)
            .font(Theme.Fonts.labelLarge)
            .foregroundColor(Theme.Colors.textSecondary)
            .accessibilityIdentifier("settings_text")
            .padding(.top, 12)
        
        VStack(alignment: .leading, spacing: 27) {
            Button(action: {
                viewModel.trackProfileVideoSettingsClicked()
                viewModel.router.showVideoSettings()
            }, label: {
                HStack {
                    Text(ProfileLocalization.settingsVideo)
                        .font(Theme.Fonts.titleMedium)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .flipsForRightToLeftLayoutDirection(true)
                }
            })
            .accessibilityIdentifier("video_settings_button")
            
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
                viewModel.trackLogoutClickedClicked()
                viewModel.router.presentView(
                    transitionStyle: .crossDissolve,
                    animated: true
                ) {
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
                        },
                        type: .logOut
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
            .accessibilityIdentifier("logout_button")
        }
        .foregroundColor(Theme.Colors.alert)
        .cardStyle(bgColor: Theme.Colors.textInputUnfocusedBackground, strokeColor: .clear)
        .padding(.top, 24)
        .padding(.bottom, 60)
    }
}

#if DEBUG
#Preview {
    let router = ProfileRouterMock()
    let vm = SettingsViewModel(
        interactor: ProfileInteractor.mock,
        downloadManager: DownloadManagerMock(),
        router: router,
        analytics: ProfileAnalyticsMock(),
        coreAnalytics: CoreAnalyticsMock(),
        config: ConfigMock(),
        corePersistence: CorePersistenceMock(),
        connectivity: Connectivity()
    )
    
    SettingsView(viewModel: vm)
}
#endif

public struct SettingsCell: View {
    
    private var title: String
    private var description: String?
    
    public init(title: String, description: String?) {
        self.title = title
        self.description = description
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(Theme.Fonts.titleMedium)
                .accessibilityIdentifier("video_settings_text")
            if let description {
                Text(description)
                    .font(Theme.Fonts.bodySmall)
                    .foregroundColor(Theme.Colors.textSecondary)
                    .accessibilityIdentifier("video_settings_sub_text")
            }
        }.foregroundColor(Theme.Colors.textPrimary)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

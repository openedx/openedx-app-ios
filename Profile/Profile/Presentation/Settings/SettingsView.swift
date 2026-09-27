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
    
    private var viewModel: SettingsViewModel
    
    @Environment(\.isHorizontal) private var isHorizontal
    
    public init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .top) {
                VStack {
                    InstanceThemedImage(
                        source: viewModel.currentInstance?.headerBackgroundURLString,
                        fallback: ThemeAssets.headerBackground.swiftUIImage
                    )
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
                                currentLearningSite
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
    
    // MARK: - Current Learning Site

    // One card: the site row (opens the site-switch screen) plus Log Out folded in below it.
    @ViewBuilder
    private var currentLearningSite: some View {
        if let instance = viewModel.currentInstance {
            // Single-instance deployments have nothing to switch between -- only Log Out applies.
            if viewModel.hasMultipleInstances {
                Text(ProfileLocalization.currentLearningSite)
                    .padding(.horizontal, 24)
                    .font(Theme.Fonts.labelLarge)
                    .foregroundColor(Theme.Colors.textSecondary)
                    .accessibilityIdentifier("current_learning_site_text")
                    .padding(.top, 12)
            }

            VStack(alignment: .leading, spacing: 0) {
                if viewModel.hasMultipleInstances {
                    Button(action: { viewModel.router.showLearningSites() }, label: {
                        HStack(spacing: 12) {
                            InstanceThemedImage(
                                source: instance.logoURLString,
                                allowsBundledAsset: true,
                                fallback: ThemeAssets.appLogo.swiftUIImage
                            )
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)

                            VStack(alignment: .leading, spacing: 2) {
                                Text(instance.baseURL.host ?? instance.baseURL.absoluteString)
                                    .font(Theme.Fonts.labelMedium)
                                    .foregroundColor(Theme.Colors.textSecondary)
                                Text(instance.name)
                                    .font(Theme.Fonts.titleSmall)
                                    .foregroundColor(Theme.Colors.textPrimary)
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .flipsForRightToLeftLayoutDirection(true)
                                .foregroundColor(Theme.Colors.textPrimary)
                        }
                        .frame(minHeight: 60)
                        // Balances cardStyle's top inset so the row centers between the card's
                        // top edge and the divider, instead of hugging the divider.
                        .padding(.bottom, 26)
                    })
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(instance.name)
                    .accessibilityIdentifier("current_learning_site_button")

                    Divider()
                }

                Button(action: { presentLogOutConfirm() }, label: {
                    HStack {
                        Text(ProfileLocalization.logout)
                        Spacer()
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                    }
                })
                .foregroundColor(Theme.Colors.alert)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(ProfileLocalization.logout)
                .accessibilityIdentifier("logout_button")
                .padding(.top, 27)
            }
            .cardStyle(bgColor: Theme.Colors.textInputUnfocusedBackground, strokeColor: .clear)
            .padding(.bottom, 60)
        }
    }

    // MARK: - Log out

    private func presentLogOutConfirm() {
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
                firstButtonTapped: {
                    viewModel.router.dismiss(animated: true)
                    Task {
                        await viewModel.logOut()
                    }
                },
                type: .logOut
            )
        }
    }
}

#if DEBUG
#Preview {
    let router = ProfileRouterPreview()
    let vm = SettingsViewModel(
        interactor: ProfileInteractor.mock,
        sessionManager: InstanceSessionManagerProtocolMock(),
        instanceStore: InstanceStore(),
        router: router,
        analytics: ProfileAnalyticsPreview(),
        coreAnalytics: CoreAnalyticsMock(),
        config: ConfigMock(),
        corePersistence: CorePersistenceMock(),
        connectivity: Connectivity(config: ConfigMock()),
        coreStorage: CoreStorageMock()
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

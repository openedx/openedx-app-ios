//
//  VideoSettingsView.swift
//  Profile
//
//  Created by  Stepanok Ivan on 09.04.2024.
//

import SwiftUI
import Core
import Theme

public struct VideoSettingsView: View {
    
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
                .frame(maxWidth: .infinity, maxHeight: 200)
                .accessibilityIdentifier("auth_bg_image")
                
                // MARK: - Page name
                VStack(alignment: .center) {
                    ZStack {
                        HStack {
                            Text(ProfileLocalization.Settings.videoSettingsTitle)
                                .titleSettings(color: Theme.Colors.loginNavigationText)
                                .accessibilityIdentifier("manage_account_text")
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
                        VStack(alignment: .leading, spacing: 24) {
                            // MARK: Wi-fi
                            HStack {
                                SettingsCell(
                                    title: ProfileLocalization.Settings.wifiTitle,
                                    description: ProfileLocalization.Settings.wifiDescription
                                )
                                Toggle(isOn: $viewModel.wifiOnly, label: {})
                                    .toggleStyle(SwitchToggleStyle(tint: Theme.Colors.toggleSwitchColor))
                                    .frame(width: 50)
                                    .accessibilityIdentifier("download_agreement_switch")
                            }.foregroundColor(Theme.Colors.textPrimary)
                            Divider()
                            
                            // MARK: Streaming Quality
                            HStack {
                                Button(action: {
                                    viewModel.router.showVideoQualityView(viewModel: viewModel)
                                }, label: {
                                    SettingsCell(title: ProfileLocalization.Settings.videoQualityTitle,
                                                 description: viewModel.selectedQuality.settingsDescription())
                                })
                                .accessibilityIdentifier("video_stream_quality_button")
                                Image(systemName: "chevron.right")
                                    .padding(.trailing, 12)
                                    .frame(width: 10)
                                    .accessibilityIdentifier("video_stream_quality_image")
                            }
                            Divider()
                            
                            // MARK: Download Quality
                            HStack {
                                Button {
                                    viewModel.router.showVideoDownloadQualityView(
                                        downloadQuality: viewModel.userSettings.downloadQuality,
                                        didSelect: { quality in
                                            Task {
                                                await viewModel.update(downloadQuality: quality)
                                            }
                                        },
                                        analytics: viewModel.coreAnalytics
                                    )
                                } label: {
                                    SettingsCell(
                                        title: CoreLocalization.Settings.videoDownloadQualityTitle,
                                        description: viewModel.userSettings.downloadQuality.settingsDescription
                                    )
                                }
                                .accessibilityIdentifier("video_download_quality_button")
                                Image(systemName: "chevron.right")
                                    .padding(.trailing, 12)
                                    .frame(width: 10)
                                    .accessibilityIdentifier("video_download_quality_image")
                            }
                            Divider()
                        }
                        .frameLimit(width: proxy.size.width)
                        .padding(.horizontal, 24)
                        .padding(.top, 24)
                    }
                    .roundedBackground(Theme.Colors.background)
                }
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .navigationTitle(ProfileLocalization.Settings.videoSettingsTitle)
        .ignoresSafeArea(.all, edges: .horizontal)
        .background(
            Theme.Colors.background
                .ignoresSafeArea()
        )
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
        
        VideoSettingsView(viewModel: vm)
            .loadFonts()
    }
#endif

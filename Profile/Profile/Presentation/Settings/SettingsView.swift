//
//  SettingsView.swift
//  Profile
//
//  Created by  Stepanok Ivan on 16.03.2023.
//

import SwiftUI
import Core
import Kingfisher
import Theme

public struct SettingsView: View {
    
    @ObservedObject
    private var viewModel: SettingsViewModel
    
    public init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .top) {
                
                // MARK: - Page Body
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        if viewModel.isShowProgress {
                            ProgressBar(size: 40, lineWidth: 8)
                                .padding(.top, 200)
                                .padding(.horizontal)
                                .accessibilityIdentifier("progressbar")
                        } else {
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
                                //                                Spacer()
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
                                        didSelect: viewModel.update(downloadQuality:),
                                        analytics: viewModel.analytics
                                    )
                                } label: {
                                    SettingsCell(
                                        title: CoreLocalization.Settings.videoDownloadQualityTitle,
                                        description: viewModel.userSettings.downloadQuality.settingsDescription
                                    )
                                }
                                .accessibilityIdentifier("video_download_quality_button")
                                //                                Spacer()
                                Image(systemName: "chevron.right")
                                    .padding(.trailing, 12)
                                    .frame(width: 10)
                                    .accessibilityIdentifier("video_download_quality_image")
                            }
                            Divider()
                        }
                    }
                    .frame(
                        minWidth: 0,
                        maxWidth: .infinity,
                        alignment: .topLeading
                    )
                    .padding(.horizontal, 24)
                    .frameLimit(width: proxy.size.width)
                }
                .padding(.top, 8)
                
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
            .navigationBarHidden(false)
            .navigationBarBackButtonHidden(false)
            .navigationTitle(ProfileLocalization.Settings.videoSettingsTitle)
            .background(
                Theme.Colors.background
                    .ignoresSafeArea()
            )
        }
    }
}

#if DEBUG
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        let router = ProfileRouterMock()
        let vm = SettingsViewModel(
            interactor: ProfileInteractor.mock,
            router: router,
            analytics: CoreAnalyticsMock()
        )
        
        SettingsView(viewModel: vm)
            .preferredColorScheme(.light)
            .previewDisplayName("SettingsView Light")
            .loadFonts()
        
        SettingsView(viewModel: vm)
            .preferredColorScheme(.dark)
            .previewDisplayName("SettingsView Dark")
            .loadFonts()
    }
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

//
//  VideoQualityView.swift
//  Profile
//
//  Created by  Stepanok Ivan on 16.03.2023.
//

import SwiftUI
import Core
import OEXFoundation
import Kingfisher
import Theme

public struct VideoQualityView: View {
    
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
                            Text(ProfileLocalization.Settings.videoQualityTitle)
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
                            if viewModel.isShowProgress {
                                ProgressBar(size: 40, lineWidth: 8)
                                    .padding(.top, 200)
                                    .padding(.horizontal)
                                    .accessibilityIdentifier("progress_bar")
                            } else {
                                ForEach(viewModel.quality, id: \.offset) { _, quality in
                                    Button(action: {
                                        viewModel.coreAnalytics.videoQualityChanged(
                                            .videoStreamQualityChanged,
                                            bivalue: .videoStreamQualityChanged,
                                            value: quality.value ?? "",
                                            oldValue: viewModel.selectedQuality.value ?? ""
                                        )
                                        viewModel.selectedQuality = quality
                                    }, label: {
                                        HStack {
                                            SettingsCell(
                                                title: quality.title(),
                                                description: quality.description()
                                            )
                                            Spacer()
                                            CoreAssets.checkmark.swiftUIImage
                                                .renderingMode(.template)
                                                .foregroundColor(Theme.Colors.accentXColor)
                                                .opacity(quality == viewModel.selectedQuality ? 1 : 0)
                                        }.foregroundColor(Theme.Colors.textPrimary)
                                    })
                                    .accessibilityIdentifier("select_quality_button")
                                    Divider()
                                }
                            }
                        }.frameLimit(width: proxy.size.width)
                            .padding(.horizontal, 24)
                            .padding(.top, 24)
                    }
                    .roundedBackground(Theme.Colors.background)
                    
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
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .navigationTitle(ProfileLocalization.Settings.videoQualityTitle)
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

    VideoQualityView(viewModel: vm)
        .loadFonts()
}
#endif

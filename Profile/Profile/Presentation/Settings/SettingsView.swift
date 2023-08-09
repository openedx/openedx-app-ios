//
//  SettingsView.swift
//  Profile
//
//  Created by  Stepanok Ivan on 16.03.2023.
//

import SwiftUI
import Core
import Kingfisher

public struct SettingsView: View {
    
    @ObservedObject
    private var viewModel: SettingsViewModel
    
    public init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ZStack(alignment: .top) {
            
            // MARK: - Page name
            VStack(alignment: .center) {
                Spacer(minLength: 12)
                // MARK: - Page Body
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        if viewModel.isShowProgress {
                            ProgressBar(size: 40, lineWidth: 8)
                                .padding(.top, 200)
                                .padding(.horizontal)
                        } else {
                            // MARK: Wi-fi
                            HStack {
                                SettingsCell(
                                    title: ProfileLocalization.Settings.wifiTitle,
                                    description: ProfileLocalization.Settings.wifiDescription
                                )
                                Toggle(isOn: $viewModel.wifiOnly, label: {})
                                    .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                                    .frame(width: 50)
                            }.foregroundColor(Theme.Colors.textPrimary)
                            Divider()
                            
                            // MARK: Download Quality
                            HStack {
                                Button(action: {
                                    viewModel.router.showVideoQualityView(viewModel: viewModel)
                                }, label: {
                                    SettingsCell(title: ProfileLocalization.Settings.videoQualityTitle,
                                                 description: viewModel.selectedQuality.settingsDescription())
                                })
                                //                                Spacer()
                                Image(systemName: "chevron.right")
                                    .padding(.trailing, 12)
                                    .frame(width: 10)
                            }
                            Divider()
                        }
                    }.frame(minWidth: 0,
                            maxWidth: .infinity,
                            alignment: .topLeading)
                    .padding(.horizontal, 24)
                }.frameLimit(sizePortrait: 420)
            }
            
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

#if DEBUG
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        let router = ProfileRouterMock()
        let vm = SettingsViewModel(
            interactor: ProfileInteractor.mock,
            router: router
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
            if let description {
                Text(description)
                    .font(Theme.Fonts.labelMedium)
                    .foregroundColor(Theme.Colors.textSecondary)
            }
        }.foregroundColor(Theme.Colors.textPrimary)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

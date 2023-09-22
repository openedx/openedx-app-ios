//
//  VideoQualityView.swift
//  Profile
//
//  Created by  Stepanok Ivan on 16.03.2023.
//

import SwiftUI
import Core
import Kingfisher

public struct VideoQualityView: View {
    
    @ObservedObject
    private var viewModel: SettingsViewModel
    
    public init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ZStack(alignment: .top) {
            
            // MARK: - Page name
            VStack(alignment: .center) {
                NavigationBar(title: ProfileLocalization.Settings.videoQualityTitle,
                              leftButtonAction: { viewModel.router.back() })
                
                // MARK: - Page Body
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        if viewModel.isShowProgress {
                            ProgressBar(size: 40, lineWidth: 8)
                                .padding(.top, 200)
                                .padding(.horizontal)
                        } else {
                            
                            ForEach(viewModel.quality, id: \.offset) { _, quality in
                                Button(action: {
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
                                            .foregroundColor(.accentColor)
                                            .opacity(quality == viewModel.selectedQuality ? 1 : 0)
                                        
                                    }.foregroundColor(CoreAssets.textPrimary.swiftUIColor)
                                })
                                Divider()
                            }
                            
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
        .background(
            CoreAssets.background.swiftUIColor
                .ignoresSafeArea()
        )
    }
}

#if DEBUG
struct VideoQualityView_Previews: PreviewProvider {
    static var previews: some View {
        let router = ProfileRouterMock()
        let vm = SettingsViewModel(interactor: ProfileInteractor.mock,
                                   router: router)
        
        VideoQualityView(viewModel: vm)
            .preferredColorScheme(.light)
            .previewDisplayName("VideoQualityView Light")
            .loadFonts()
        
        VideoQualityView(viewModel: vm)
            .preferredColorScheme(.dark)
            .previewDisplayName("VideoQualityView Dark")
            .loadFonts()
    }
}
#endif

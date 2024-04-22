//
//  VideoDownloadQualityView.swift
//  Core
//
//  Created by Eugene Yatsenko on 19.01.2024.
//

import SwiftUI
import Kingfisher
import Theme

public final class VideoDownloadQualityViewModel: ObservableObject {

    var didSelect: ((DownloadQuality) -> Void)?
    let downloadQuality = DownloadQuality.allCases
    
    @Published var selectedDownloadQuality: DownloadQuality {
        willSet {
            if newValue != selectedDownloadQuality {
                didSelect?(newValue)
            }
        }
    }

    public init(downloadQuality: DownloadQuality, didSelect: ((DownloadQuality) -> Void)?) {
        self.selectedDownloadQuality = downloadQuality
        self.didSelect = didSelect
    }
}

public struct VideoDownloadQualityView: View {

    @StateObject
    private var viewModel: VideoDownloadQualityViewModel
    private var analytics: CoreAnalytics
    private var router: BaseRouter
    @Environment (\.isHorizontal) private var isHorizontal

    public init(
        downloadQuality: DownloadQuality,
        didSelect: ((DownloadQuality) -> Void)?,
        analytics: CoreAnalytics,
        router: BaseRouter
    ) {
        self._viewModel = StateObject(
            wrappedValue: .init(
                downloadQuality: downloadQuality,
                didSelect: didSelect
            )
        )
        self.analytics = analytics
        self.router = router
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
                            Text(CoreLocalization.Settings.videoDownloadQualityTitle)
                                .titleSettings(color: Theme.Colors.loginNavigationText)
                                .accessibilityIdentifier("manage_account_text")
                        }
                        VStack {
                            Button(action: { router.back() }, label: {
                                CoreAssets.arrowLeft.swiftUIImage.renderingMode(.template)
                                    .backButtonStyle(color: Theme.Colors.loginNavigationText)
                            })
                            .foregroundColor(Theme.Colors.styledButtonText)
                            .padding(.leading, isHorizontal ? 48 : 0)
                            .accessibilityIdentifier("back_button")
                            
                        }.frame(minWidth: 0,
                                maxWidth: .infinity,
                                alignment: .topLeading)
                    }
                    // MARK: - Page Body
                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            ForEach(viewModel.downloadQuality, id: \.self) { quality in
                                Button(action: {
                                    analytics.videoQualityChanged(
                                        .videoDownloadQualityChanged,
                                        bivalue: .videoDownloadQualityChanged,
                                        value: quality.value ?? "",
                                        oldValue: viewModel.selectedDownloadQuality.value ?? ""
                                    )
                                    
                                    viewModel.selectedDownloadQuality = quality
                                }, label: {
                                    HStack {
                                        SettingsCell(
                                            title: quality.title,
                                            description: quality.description
                                        )
                                        .accessibilityElement(children: .ignore)
                                        .accessibilityLabel("\(quality.title) \(quality.description ?? "")")
                                        Spacer()
                                        CoreAssets.checkmark.swiftUIImage
                                            .renderingMode(.template)
                                            .foregroundColor(Theme.Colors.accentXColor)
                                            .opacity(quality == viewModel.selectedDownloadQuality ? 1 : 0)
                                            .accessibilityIdentifier("checkmark_image")
                                        
                                    }
                                    .foregroundColor(Theme.Colors.textPrimary)
                                })
                                .accessibilityIdentifier("select_quality_button")
                                Divider()
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 24)
                        .frameLimit(width: proxy.size.width)
                    }
                    .roundedBackground(Theme.Colors.background)
                }
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .background(
                Theme.Colors.background
                    .ignoresSafeArea()
            )
        }
    }
}

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
                .accessibilityIdentifier("video_quality_title_text")
            if let description {
                Text(description)
                    .font(Theme.Fonts.bodySmall)
                    .foregroundColor(Theme.Colors.textSecondary)
                    .accessibilityIdentifier("video_quality_des_text")
            }
        }.foregroundColor(Theme.Colors.textPrimary)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

public extension DownloadQuality {

    var title: String {
        switch self {
        case .auto:
            return CoreLocalization.Settings.downloadQualityAutoTitle
        case .low:
            return CoreLocalization.Settings.downloadQuality360Title
        case .medium:
            return CoreLocalization.Settings.downloadQuality540Title
        case .high:
            return CoreLocalization.Settings.downloadQuality720Title
        }
    }

    var description: String? {
        switch self {
        case .auto:
            return CoreLocalization.Settings.downloadQualityAutoDescription
        case .low:
            return CoreLocalization.Settings.downloadQuality360Description
        case .medium:
            return nil
        case .high:
            return CoreLocalization.Settings.downloadQuality720Description
        }
    }

    var settingsDescription: String {
        switch self {
        case .auto:
            return CoreLocalization.Settings.downloadQualityAutoTitle + " ("
            + CoreLocalization.Settings.downloadQualityAutoDescription + ")"
        case .low:
            return CoreLocalization.Settings.downloadQuality360Title + " ("
            + CoreLocalization.Settings.downloadQuality360Description + ")"
        case .medium:
            return CoreLocalization.Settings.downloadQuality540Title
        case .high:
            return CoreLocalization.Settings.downloadQuality720Title + " ("
            + CoreLocalization.Settings.downloadQuality720Description + ")"
        }
    }
}

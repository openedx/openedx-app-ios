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

    public init(
        downloadQuality: DownloadQuality,
        didSelect: ((DownloadQuality) -> Void)?,
        analytics: CoreAnalytics
    ) {
        self._viewModel = StateObject(
            wrappedValue: .init(
                downloadQuality: downloadQuality,
                didSelect: didSelect
            )
        )
        self.analytics = analytics
    }

    public var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .top) {
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
                    .frame(
                        minWidth: 0,
                        maxWidth: .infinity,
                        alignment: .topLeading
                    )
                    .padding(.horizontal, 24)
                    .frameLimit(width: proxy.size.width)
                }
                .padding(.top, 8)
            }
            .navigationBarHidden(false)
            .navigationBarBackButtonHidden(false)
            .navigationTitle(CoreLocalization.Settings.videoDownloadQualityTitle)
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

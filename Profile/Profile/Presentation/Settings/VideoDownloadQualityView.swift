//
//  VideoDownloadQualityView.swift
//  Profile
//
//  Created by Eugene Yatsenko on 04.01.2024.
//

import SwiftUI
import Core
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

    public init(
        downloadQuality: DownloadQuality,
        didSelect: ((DownloadQuality) -> Void)?
    ) {
        self._viewModel = StateObject(
            wrappedValue: .init(
                downloadQuality: downloadQuality,
                didSelect: didSelect
            )
        )
    }

    public var body: some View {
        ZStack(alignment: .top) {
            // MARK: - Page Body
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    ForEach(viewModel.downloadQuality, id: \.self) { quality in
                        Button {
                            viewModel.selectedDownloadQuality = quality
                        } label: {
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
                                    .foregroundColor(.accentColor)
                                    .opacity(quality == viewModel.selectedDownloadQuality ? 1 : 0)
                                    .accessibilityIdentifier("checkmark_image")

                            }
                            .foregroundColor(Theme.Colors.textPrimary)
                        }
                        .accessibilityIdentifier("quality_button_cell")
                        Divider()
                    }
                }
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    alignment: .topLeading
                )
                .padding(.horizontal, 24)
            }
            .frameLimit(sizePortrait: 420)
            .padding(.top, 8)
        }
        .navigationBarHidden(false)
        .navigationBarBackButtonHidden(false)
        .navigationTitle(ProfileLocalization.Settings.videoDownloadQualityTitle)
        .background(
            Theme.Colors.background
                .ignoresSafeArea()
        )
    }
}

public extension DownloadQuality {

    var title: String {
        switch self {
        case .auto:
            return ProfileLocalization.Settings.downloadQualityAutoTitle
        case .low_360:
            return ProfileLocalization.Settings.downloadQuality360Title
        case .medium_540:
            return ProfileLocalization.Settings.downloadQuality540Title
        case .high_720:
            return ProfileLocalization.Settings.downloadQuality720Title
        }
    }

    var description: String? {
        switch self {
        case .auto:
            return ProfileLocalization.Settings.downloadQualityAutoDescription
        case .low_360:
            return ProfileLocalization.Settings.downloadQuality360Description
        case .medium_540:
            return nil
        case .high_720:
            return ProfileLocalization.Settings.downloadQuality720Description
        }
    }

    var settingsDescription: String {
        switch self {
        case .auto:
            return ProfileLocalization.Settings.downloadQualityAutoTitle + " ("
            + ProfileLocalization.Settings.downloadQualityAutoDescription + ")"
        case .low_360:
            return ProfileLocalization.Settings.downloadQuality360Title + " ("
            + ProfileLocalization.Settings.downloadQuality360Description + ")"
        case .medium_540:
            return ProfileLocalization.Settings.downloadQuality540Title
        case .high_720:
            return ProfileLocalization.Settings.downloadQuality720Title + " ("
            + ProfileLocalization.Settings.downloadQuality720Description + ")"
        }
    }
}

#if DEBUG
struct VideoDownloadQualityView_Previews: PreviewProvider {
    static var previews: some View {
        let router = ProfileRouterMock()
        let vm = SettingsViewModel(interactor: ProfileInteractor.mock,
                                   router: router)

        VideoDownloadQualityView(downloadQuality: vm.userSettings.downloadQuality) { _ in }
            .preferredColorScheme(.light)
            .previewDisplayName("VideoQualityView Light")
            .loadFonts()

        VideoDownloadQualityView(downloadQuality: vm.userSettings.downloadQuality) { _ in }
            .preferredColorScheme(.dark)
            .previewDisplayName("VideoQualityView Dark")
            .loadFonts()
    }
}
#endif

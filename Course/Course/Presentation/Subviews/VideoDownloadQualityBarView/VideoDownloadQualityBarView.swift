//
//  VideoDownloadQualityBarView.swift
//  Course
//
//  Created by Eugene Yatsenko on 04.01.2024.
//

import SwiftUI
import Core
import Theme
import Combine
import Profile

struct VideoDownloadQualityBarView: View {

    private var downloadQuality: DownloadQuality
    private var onTap: (() -> Void)?

    init(downloadQuality: DownloadQuality, onTap: (() -> Void)? = nil) {
        self.downloadQuality = downloadQuality
        self.onTap = onTap
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                VStack {
                    Image(systemName: "gearshape")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .font(.system(size: 25, weight: .medium))
                        .frame(width: 25, height: 25)
                        .accessibilityIdentifier("gearshape_image")

                }
                .frame(width: 40, height: 40)
                .padding(.leading, 15)
                titles
                Spacer()
            }
            .padding(.vertical, 10)
            Divider()
        }
        .contentShape(Rectangle())
        .onTapGesture { onTap?() }
        .accessibilityIdentifier("video_download_quality_bar")
    }

    @ViewBuilder
    private var titles: some View {
        VStack(alignment: .leading) {
            let videoDownloadQualityTitle = ProfileLocalization.Settings.videoDownloadQualityTitle
            Text(videoDownloadQualityTitle)
            .lineLimit(1)
            .font(Theme.Fonts.titleMedium)
            .foregroundColor(Theme.Colors.textPrimary)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(videoDownloadQualityTitle)
            .accessibilityIdentifier("video_quality_title_text")
            let settingsDescription = downloadQuality.settingsDescription
            Text(settingsDescription)
                .font(Theme.Fonts.labelLarge)
                .foregroundColor(Theme.Colors.textSecondary)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(settingsDescription)
                .accessibilityIdentifier("video_quality_description_text")
        }
        .padding(.horizontal, 10)
    }
}

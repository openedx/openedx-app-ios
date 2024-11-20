//
//  CourseVideoDownloadBarView.swift
//  Course
//
//  Created by Eugene Yatsenko on 15.12.2023.
//

import SwiftUI
import Core
import Theme
import Combine

struct CourseVideoDownloadBarView: View {

    // MARK: - Properties

    @StateObject var viewModel: CourseVideoDownloadBarViewModel
    private var onTap: (() -> Void)?
    private var onNotInternetAvaliable: (() -> Void)?

    init(
        courseStructure: CourseStructure,
        courseViewModel: CourseContainerViewModel,
        onNotInternetAvaliable: (() -> Void)?,
        onTap: (() -> Void)? = nil,
        analytics: CourseAnalytics
    ) {
        self._viewModel = .init(
            wrappedValue: .init(
                courseStructure: courseStructure,
                courseViewModel: courseViewModel,
                analytics: analytics
            )
        )
        self.onNotInternetAvaliable = onNotInternetAvaliable
        self.onTap = onTap
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            Divider()
            HStack(spacing: 0) {
                image
                titles
                toggle
            }
            .padding(.vertical, 10)
            if viewModel.isOn, !viewModel.allVideosDownloaded {
                ProgressView(value: viewModel.progress, total: 1)
                    .tint(Theme.Colors.accentColor)
                    .accessibilityIdentifier("progress_line_view")
            }
            Divider()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            Task {
                let downloads = await viewModel.allActiveDownloads()
                if !downloads.isEmpty {
                    onTap?()
                }
            }
        }
        .accessibilityIdentifier("videos_download_bar")
    }

    // MARK: - Views

    private var image: some View {
        VStack {
            if viewModel.isOn, !viewModel.allVideosDownloaded {
                ProgressView()
                    .accessibilityIdentifier("progress_view")
            } else {
                CoreAssets.video.swiftUIImage
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .accessibilityIdentifier("video_image")
            }
        }
        .frame(width: 40, height: 40)
        .padding(.leading, 15)
    }

    @ViewBuilder
    private var titles: some View {
        HStack {
            VStack(alignment: .leading) {
                let title = viewModel.title
                Text(title)
                    .lineLimit(1)
                    .font(Theme.Fonts.titleMedium)
                    .foregroundColor(Theme.Colors.textPrimary)
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(title)
                    .accessibilityIdentifier("bar_title_text")
                HStack(spacing: 0) {
                    Group {
                        if viewModel.remainingVideos == 0 {
                            let text = "\(CourseLocalization.Download.videos) \(viewModel.totalFinishedVideos)"
                            Text(text)
                                .accessibilityElement(children: .ignore)
                                .accessibilityLabel(text)
                                .accessibilityIdentifier("videos_total_finished_text")
                        } else {
                            let text = "\(CourseLocalization.Download.remaining) \(viewModel.remainingVideos)"
                            Text(text)
                                .accessibilityElement(children: .ignore)
                                .accessibilityLabel(text)
                                .accessibilityIdentifier("remaining_videos_text")
                        }
                        if let totalSize = viewModel.totalSize {
                            let text = ", \(totalSize) \(CourseLocalization.Download.total)"
                            Text(text)
                                .accessibilityElement(children: .ignore)
                                .accessibilityLabel(text)
                                .accessibilityIdentifier("total_size_text")
                        }
                    }
                    .font(Theme.Fonts.labelLarge)
                    .foregroundColor(Theme.Colors.textSecondary)
                }
            }
            Spacer()
        }
        .padding(.horizontal, 10)
        .layoutPriority(1)
    }

    private var toggle: some View {
        Toggle("", isOn: .constant(viewModel.isOn))
            .toggleStyle(SwitchToggleStyle(tint: Theme.Colors.toggleSwitchColor))
            .padding(.trailing, 15)
            .onTapGesture {
                if !viewModel.isInternetAvaliable {
                    onNotInternetAvaliable?()
                    return
                }
                Task { await viewModel.onToggle()  }
            }
            .accessibilityIdentifier("download_toggle")
    }
}

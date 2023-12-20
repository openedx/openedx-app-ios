//
//  DownloadToDeviceBarView.swift
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

    init(
        courseStructure: CourseStructure,
        courseViewModel: CourseContainerViewModel
    ) {
        self._viewModel = .init(
            wrappedValue: .init(
                courseStructure: courseStructure,
                courseViewModel: courseViewModel
            )
        )
    }

    // MARK: - Body

    var body: some View {
        let isAllDownloaded = viewModel.isAllDownloaded
        VStack(spacing: 0) {
            Divider()
            HStack(spacing: 0) {
                image
                titles
                toggle
            }
            .padding(.vertical, 10)
            if viewModel.isOn, !isAllDownloaded {
                ProgressView(value: viewModel.currentDownload?.progress ?? 0, total: 100)
            }
            Divider()
        }
        .contentShape(Rectangle())
    }

    // MARK: - Views

    private var image: some View {
        VStack {
            if viewModel.isOn, !viewModel.isAllDownloaded {
                ProgressView()
            } else {
                CoreAssets.video.swiftUIImage
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
            }
        }
        .frame(width: 40, height: 40)
        .padding(.leading, 15)
    }

    @ViewBuilder
    private var titles: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(viewModel.title)
                .lineLimit(1)
                .font(Theme.Fonts.titleMedium)
                .foregroundColor(Theme.Colors.textPrimary)
                HStack(spacing: 0) {
                    Group {
                        if viewModel.remainingCount == 0 {
                            Text("\(CourseLocalization.Download.videos) \(viewModel.totalFinishedCount)")
                        } else {
                            Text("\(CourseLocalization.Download.remaining) \(viewModel.remainingCount)")
                        }
                        viewModel.totalSize.map {
                            Text(", \($0)MB Total")
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
            .toggleStyle(SwitchToggleStyle(tint: Theme.Colors.accentColor))
            .padding(.trailing, 15)
            .onTapGesture {
                viewModel.downloadAll()
            }
    }

}

//
//  DownloadToDeviceBarView.swift
//  Course
//
//  Created by Eugene Yatsenko on 15.12.2023.
//

import SwiftUI
import Core
import Theme

struct DownloadToDeviceBarView: View {

    // MARK: - Properties

    var courseStructure: CourseStructure
    @ObservedObject var viewModel: CourseContainerViewModel
    var onTap: (() -> Void)?

    @State private var isOn: Bool = false

    init(
        courseStructure: CourseStructure,
        viewModel: CourseContainerViewModel,
        onTap: (() -> Void)? = nil
    ) {
        self.onTap = onTap
        self.courseStructure = courseStructure
        self.viewModel = viewModel
    }

    // MARK: - Body

    var body: some View {
        let isAllDownloaded = isAllDownloaded
        VStack(spacing: 0) {
            Divider()
            HStack {
                if toggleStateIsOn, !isAllDownloaded {
                    ProgressView()
                        .padding(.leading, 15)
                } else {
                    CoreAssets.video.swiftUIImage.renderingMode(.template)
                        .padding(.leading, 15)
                }
                titles
                toggle
            }
            .padding(.vertical, 10)
            if toggleStateIsOn, !isAllDownloaded { ProgressView(value: 20, total: 100) }
            Divider()
        }
        .contentShape(Rectangle())
        .onTapGesture { onTap?() }
    }

    // MARK: - Views

    @ViewBuilder
    private var titles: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(toggleStateIsOn ?
                     (remainingCount == 0 ? "All videos downloaded" : "Downloading videos...")
                     : "Download to device"
                )
                .font(Theme.Fonts.titleMedium)
                .foregroundColor(Theme.Colors.textPrimary)
                HStack(spacing: 0) {
                    Group {
                        if remainingCount == 0 {
                            Text("Videos \(totalFinishedCount)")
                        } else {
                            Text("Remaining \(remainingCount)")
                        }
                        totalSize.map {
                            Text(", \($0)MB Total")
                        }
                    }
                    .font(Theme.Fonts.labelLarge)
                    .foregroundColor(Theme.Colors.textSecondary)
                }
            }
            Spacer()
        }
        .padding(.horizontal, 15)
        .layoutPriority(1)
    }

    private var toggle: some View {
        Toggle("", isOn: .constant(toggleStateIsOn))
            .toggleStyle(SwitchToggleStyle(tint: Theme.Colors.accentColor))
            .padding(.trailing, 15)
            .onTapGesture {
                viewModel.downloadAll(
                    courseStructure: courseStructure,
                    isOn: toggleStateIsOn ? false : true
                )
            }
    }

    // MARK: - Private properties

    private var totalSize: String? {
        let mb = courseStructure.blocksTotalSizeInMb
        if mb == 0.0 {
            return nil
        }
        return String(format: "%.2f", mb)
    }

    private var isAllDownloaded: Bool {
        totalFinishedCount == viewModel.verticalsDownloadState.count
    }

    private var remainingCount: Int {
        // Verticals
        viewModel.verticalsDownloadState.filter { $0.value != .finished }.count
    }

    private var downloadingCount: Int {
        // Verticals
        viewModel.verticalsDownloadState.filter { $0.value == .downloading }.count
    }

    private var totalFinishedCount: Int {
        // Verticals
        viewModel.verticalsDownloadState.filter { $0.value == .finished }.count
    }

    var toggleStateIsOn: Bool {
        let totalCount = viewModel.sequentialsDownloadState.count
        let availableCount = viewModel.sequentialsDownloadState.filter { $0.value == .available }.count
        let finishedCount = viewModel.sequentialsDownloadState.filter { $0.value == .finished }.count
        let downloadingCount = viewModel.sequentialsDownloadState.filter { $0.value == .downloading }.count
        if downloadingCount == totalCount {
            return true
        }
        if totalCount == finishedCount {
            return true
        }
        if availableCount > 0 {
            return false
        }
        if downloadingCount == 0 {
            return false
        }

        let isOn = totalCount - finishedCount == downloadingCount
        return isOn
    }

}

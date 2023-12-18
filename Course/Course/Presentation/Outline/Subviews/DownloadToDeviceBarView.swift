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
    var onTap: (([DownloadData]) -> Void)?

    @State private var isOn: Bool = false

    private var allDownloadData: [DownloadData] = []
    private var currentDownloadData: DownloadData?

    init(
        courseStructure: CourseStructure,
        viewModel: CourseContainerViewModel,
        onTap: (([DownloadData]) -> Void)? = nil
    ) {
        self.onTap = onTap
        self.courseStructure = courseStructure
        self.viewModel = viewModel
        self.allDownloadData = viewModel.getDownloadsForCourse(courseId: courseStructure.id)
        self.currentDownloadData = allDownloadData.first(where: { $0.state == .inProgress })
    }

    // MARK: - Body

    var body: some View {
        let isAllDownloaded = isAllDownloaded
        VStack(spacing: 0) {
            Divider()
            HStack(spacing: 0) {
                image
                titles
                toggle
            }
            .padding(.vertical, 10)
            if toggleStateIsOn, !isAllDownloaded { ProgressView(value: totalProgress, total: 1.0) }
            Divider()
        }
        .contentShape(Rectangle())
        .onTapGesture { onTap?(allDownloadData) }
    }

    // MARK: - Views

    private var image: some View {
        VStack {
            if toggleStateIsOn, !isAllDownloaded {
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
                Text(title)
                .lineLimit(1)
                .font(Theme.Fonts.titleMedium)
                .foregroundColor(Theme.Colors.textPrimary)
                HStack(spacing: 0) {
                    Group {
                        if remainingCount == 0 {
                            Text("Videos \(totalFinishedCount)")
                        } else {
                            Text("Remaining \(remainingCount)")
                        }
                        totalSize.map { Text(", \($0)MB Total") }
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

    private var title: String {
        if toggleStateIsOn {
            if remainingCount == 0 {
                return "All videos downloaded"
            } else {
                return currentDownloadData?.displayName ?? "Downloading videos..."
            }
        } else {
            return "Download to device"
        }
    }

    private var totalSize: String? {
        let mb = courseStructure.blocksTotalSizeInMb
        if mb == 0.0 {
            return nil
        }
        return String(format: "%.2f", mb)
    }

    private var totalProgress: Double {
        if allDownloadData.count == 0 { return 0.0 }
        let progress = allDownloadData.map { $0.progress }
        return progress.reduce(.zero) { $0 + $1 } / Double(allDownloadData.count)
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

    private var toggleStateIsOn: Bool {
        // Sequentials
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

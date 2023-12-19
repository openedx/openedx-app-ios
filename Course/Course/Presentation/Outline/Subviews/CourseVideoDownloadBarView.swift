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

final class DownloadsViewModel: ObservableObject {

    @Published private(set) var downloads: [DownloadData]

    private let manager: DownloadManagerProtocol
    private var cancellables = Set<AnyCancellable>()

    init(
        downloads: [DownloadData] = [],
        manager: DownloadManagerProtocol
    ) {
        self.downloads = downloads
        self.manager = manager
        configure()
        observers()
    }

    func cancelDownloading(downloadData: DownloadData) {
        do {
            try manager.cancelDownloading(downloadData: downloadData)
            downloads.removeAll(where: { $0.id == downloadData.id })
        } catch {
            print(error)
        }
    }

    private func configure() {
        guard downloads.isEmpty else {
            sort()
            return
        }
        downloads = manager.getDownloads()
        sort()
    }

    private func observers() {
        manager.eventPublisher()
            .sink { [weak self] event in
                guard let self else { return }
                switch event {
                case .progress(let progress, let downloadData):
                    if let firstIndex = downloads.firstIndex(where: { $0.id == downloadData.id }) {
                        self.downloads[firstIndex].progress = progress
                        self.downloads[firstIndex].state = .inProgress
                    }
                case .finished(let downloadData):
                    if let firstIndex = downloads.firstIndex(where: { $0.id == downloadData.id }) {
                        self.downloads[firstIndex].state = .finished
                    }
                default:
                    break
                }
                self.sort()
            }
            .store(in: &cancellables)
    }

    private func sort() {
        downloads.sort(by: { $0.state.order < $1.state.order })
    }
}

struct DownloadsView: View {

    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: DownloadsViewModel

    init(viewModel: DownloadsViewModel) {
        self._viewModel = .init(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(
                        viewModel.downloads,
                        content: cell
                    )
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Downloads")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(Theme.Colors.accentColor)
                    }
                }
            }
        }.onReceive(viewModel.$downloads) { downloads in
            if downloads.isEmpty {
                dismiss()
            }
        }
    }

    @ViewBuilder
    func cell(downloadData: DownloadData) -> some View {
        VStack(spacing: 0) {
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text(downloadData.displayName)
                            .font(Theme.Fonts.titleMedium)
                            .multilineTextAlignment(.leading)
                            .lineLimit(1)
                        if downloadData.state != .finished {
                            ProgressView(value: downloadData.progress, total: 100.0)
                        }
                    }
                    Spacer()
                    Button {
                        viewModel.cancelDownloading(downloadData: downloadData)
                    } label: {
                        if downloadData.state == .finished {
                            DownloadFinishedView()
                                .foregroundColor(Theme.Colors.textPrimary)
                                .accessibilityElement(children: .ignore)
                                .accessibilityLabel(CourseLocalization.Accessibility.cancelDownload)
                        } else {
                            DownloadProgressView()
                                .accessibilityElement(children: .ignore)
                                .accessibilityLabel(CourseLocalization.Accessibility.cancelDownload)
                        }
                    }
                    .padding(.horizontal, 15)
                }
                .padding(.leading, 20)
                .padding(.vertical, 5)
                Divider()
            }
        }
    }
}

final class CourseVideoDownloadBarViewModel: ObservableObject {

    // MARK: - Properties

    private let courseStructure: CourseStructure
    private let courseViewModel: CourseContainerViewModel

    @Published private(set) var currentDownload: DownloadData?
    @Published private(set) var isOn: Bool = false

    private var cancellables = Set<AnyCancellable>()

    var title: String {
        if isOn {
            if remainingCount == 0 {
                return "All videos downloaded"
            } else {
                return currentDownload?.displayName ?? "Downloading videos..."
            }
        } else {
            return "Download to device"
        }
    }

    var isAllDownloaded: Bool {
        totalFinishedCount == courseViewModel.verticalsDownloadState.count
    }

    var remainingCount: Int {
        // Verticals
        courseViewModel.verticalsDownloadState.filter { $0.value != .finished }.count
    }

    var downloadingCount: Int {
        // Verticals
        courseViewModel.verticalsDownloadState.filter { $0.value == .downloading }.count
    }

    var totalFinishedCount: Int {
        // Verticals
        courseViewModel.verticalsDownloadState.filter { $0.value == .finished }.count
    }

    init(
        courseStructure: CourseStructure,
        courseViewModel: CourseContainerViewModel
    ) {
        self.courseStructure = courseStructure
        self.courseViewModel = courseViewModel
        observers()
    }

    func downloadAll() {
        courseViewModel.downloadAll(
            courseStructure: courseStructure,
            isOn: isOn ? false : true
        )
    }

    // MARK: -  Private intents

    private func toggleStateIsOn() {
        // Sequentials
        let totalCount = courseViewModel.sequentialsDownloadState.count
        let availableCount = courseViewModel.sequentialsDownloadState.filter { $0.value == .available }.count
        let finishedCount = courseViewModel.sequentialsDownloadState.filter { $0.value == .finished }.count
        let downloadingCount = courseViewModel.sequentialsDownloadState.filter { $0.value == .downloading }.count
        if downloadingCount == totalCount {
            self.isOn = true
            return
        }
        if totalCount == finishedCount {
            self.isOn = true
            return
        }
        if availableCount > 0 {
            self.isOn = false
            return
        }
        if downloadingCount == 0 {
            self.isOn = false
            return
        }

        let isOn = totalCount - finishedCount == downloadingCount
        self.isOn = isOn
    }

    private func observers() {
        currentDownload = courseViewModel.manager.currentDownload
        toggleStateIsOn()
        courseViewModel.manager.eventPublisher()
            .sink(receiveValue: { [weak self] _ in
                guard let self else { return }
                self.currentDownload = self.courseViewModel.manager.currentDownload
                self.toggleStateIsOn()
            })
            .store(in: &cancellables)
    }
}

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
                            Text("Videos \(viewModel.totalFinishedCount)")
                        } else {
                            Text("Remaining \(viewModel.remainingCount)")
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

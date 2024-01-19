//
//  CourseVideoDownloadBarViewModel.swift
//  Course
//
//  Created by Eugene Yatsenko on 20.12.2023.
//

import Foundation
import Core
import Combine

final class CourseVideoDownloadBarViewModel: ObservableObject {

    // MARK: - Properties

    private let courseStructure: CourseStructure
    private let courseViewModel: CourseContainerViewModel

    @Published private(set) var currentDownload: DownloadData?
    @Published private(set) var isOn: Bool = false

    private var cancellables = Set<AnyCancellable>()

    var title: String {
        if isOn {
            if remainingVideos == 0 {
                return CourseLocalization.Download.allVideosDownloaded
            } else {
                return CourseLocalization.Download.downloadingVideos
            }
        } else {
            return CourseLocalization.Download.downloadToDevice
        }
    }

    var progress: Double {
        guard let currentDownload = currentDownload else {
            return 0.0
        }
        guard let index = courseViewModel.courseDownloads.firstIndex(
            where: { $0.id == currentDownload.id }
        ) else {
            return 0.0
        }
        courseViewModel.courseDownloads[index].progress = currentDownload.progress
        return courseViewModel
            .courseDownloads
            .reduce(0) { $0 + $1.progress } / Double(courseViewModel.courseDownloads.count)
    }

    var downloadableVerticals: Set<VerticalsDownloadState> {
        courseViewModel.downloadableVerticals
    }

    var allVideosDownloaded: Bool {
        let totalFinishedCount = downloadableVerticals.filter { $0.state == .finished }.count
        return totalFinishedCount == downloadableVerticals.count
    }

    var remainingVideos: Int {
        let inProgress = downloadableVerticals.filter { $0.state != .finished }
        return inProgress.flatMap { $0.downloadableBlocks }.count
    }

    var downloadingVideos: Int {
        let downloading = downloadableVerticals.filter { $0.state == .downloading }
        return downloading.flatMap { $0.downloadableBlocks }.count
    }

    var totalFinishedVideos: Int {
        let finished = downloadableVerticals.filter { $0.state == .finished }
        return finished.flatMap { $0.downloadableBlocks }.count
    }

    var totalSize: String? {
        let quality = courseViewModel.userSettings?.downloadQuality ?? .auto
        let mb = courseStructure.totalVideosSizeInMb(
            quality: quality
        )

        if mb == 0 { return nil }

        if isOn {
            let size =  mb - calculateSize(value: mb, percentage: progress * 100)
            if size == 0 {
                return String(format: "%.2f", mb)
            }
            return String(format: "%.2f", size)
        }

        let size = blockToMB(
            data: Set(downloadableVerticals
                .filter { $0.state != .finished }
                .flatMap { $0.downloadableBlocks }
            ),
            quality: quality
        )

        return String(format: "%.2f", size)
    }

    init(
        courseStructure: CourseStructure,
        courseViewModel: CourseContainerViewModel
    ) {
        self.courseStructure = courseStructure
        self.courseViewModel = courseViewModel
        observers()
    }

    func allActiveDownloads() async -> [DownloadData] {
        await courseViewModel.manager.getDownloads()
            .filter { $0.state == .inProgress || $0.state == .waiting }
    }

    @MainActor
    func onToggle() async {
        await downloadAll(
            isOn: isOn ? false : true
        )
    }

    @MainActor
    private func downloadAll(isOn: Bool) async {
        let blocks = downloadableVerticals.flatMap { $0.vertical.childs }

        if isOn, courseViewModel.isShowedAllowLargeDownloadAlert(blocks: blocks) {
            return
        }

        if isOn {
            let blocks = downloadableVerticals.filter { $0.state != .finished }.flatMap { $0.vertical.childs }
            await courseViewModel.download(
                state: .available,
                blocks: blocks
            )
        } else {
            await courseViewModel.manager.cancelDownloading(courseId: courseStructure.id)
        }
    }

    // MARK: - Private intents

    private func toggleStateIsOn() {
        let totalCount = courseViewModel.downloadableVerticals.count
        let availableCount = courseViewModel.downloadableVerticals.filter { $0.state == .available }.count
        let finishedCount = courseViewModel.downloadableVerticals.filter { $0.state == .finished }.count
        let downloadingCount = courseViewModel.downloadableVerticals.filter { $0.state == .downloading }.count

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
        courseViewModel.$downloadableVerticals
            .sink { [weak self] _ in
                guard let self else { return }
                self.currentDownload = self.courseViewModel.manager.currentDownload
                self.toggleStateIsOn()
        }
        .store(in: &cancellables)
        courseViewModel.manager.eventPublisher()
            .sink { [weak self] state in
                guard let self else { return }
                if case .progress = state {
                    self.currentDownload = self.courseViewModel.manager.currentDownload
                }
                self.toggleStateIsOn()
            }
            .store(in: &cancellables)
    }

    private func calculateSize(value: Double, percentage: Double) -> Double {
        let val = value * percentage
        return val / 100.0
    }

    private func blockToMB(data: Set<CourseBlock>, quality: DownloadQuality) -> Double {
        data.reduce(0) { $0 + Double($1.video(quality: quality)?.fileSize ?? 0) } / 1024.0 / 1024.0
    }
}

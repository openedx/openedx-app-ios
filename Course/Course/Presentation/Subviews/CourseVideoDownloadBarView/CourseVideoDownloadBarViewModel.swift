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
    private let analytics: CourseAnalytics

    @Published private(set) var currentDownloadTask: DownloadDataTask?
    @Published private(set) var isOn: Bool = false

    private var cancellables = Set<AnyCancellable>()

    var isInternetAvaliable: Bool {
        courseViewModel.isInternetAvaliable
    }

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
        guard let currentDownloadTask = currentDownloadTask else {
            return 0.0
        }
        guard let index = courseViewModel.courseDownloadTasks.firstIndex(
            where: { $0.id == currentDownloadTask.id }
        ) else {
            return 0.0
        }
        courseViewModel.courseDownloadTasks[index].progress = currentDownloadTask.progress
        return courseViewModel
            .courseDownloadTasks
            .reduce(0) { $0 + $1.progress } / Double(courseViewModel.courseDownloadTasks.count)
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
        let downloadQuality = courseViewModel.userSettings?.downloadQuality ?? .auto
        let mb = courseStructure.totalVideosSizeInMb(
            downloadQuality: downloadQuality
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
            downloadQuality: downloadQuality
        )

        return String(format: "%.2f", size)
    }

    init(
        courseStructure: CourseStructure,
        courseViewModel: CourseContainerViewModel,
        analytics: CourseAnalytics
    ) {
        self.courseStructure = courseStructure
        self.courseViewModel = courseViewModel
        self.analytics = analytics
        observers()
    }

    func allActiveDownloads() async -> [DownloadDataTask] {
        await courseViewModel.manager.getDownloadTasks()
            .filter { $0.state == .inProgress || $0.state == .waiting }
    }

    @MainActor
    func onToggle() async {
        if allVideosDownloaded {
            courseViewModel.router.presentAlert(
                alertTitle: "Warning",
                alertMessage: "\(CourseLocalization.Alert.deleteAllVideos) \"\(courseStructure.displayName)\"?",
                positiveAction: CoreLocalization.Alert.delete,
                onCloseTapped: { [weak self] in
                    self?.courseViewModel.router.dismiss(animated: true)
                },
                okTapped: { [weak self] in
                    guard let self else { return }
                    Task {
                        await self.downloadAll(isOn: false)
                    }
                    analytics.bulkDownloadVideosToggle(courseID: courseStructure.id, action: false)
                    self.courseViewModel.router.dismiss(animated: true)
                },
                type: .deleteVideo
            )
            return
        }

        if isOn {
            courseViewModel.router.presentAlert(
                alertTitle: "Warning",
                alertMessage: "\(CourseLocalization.Alert.stopDownloading) \"\(courseStructure.displayName)\"",
                positiveAction: CoreLocalization.Alert.accept,
                onCloseTapped: { [weak self] in
                    self?.courseViewModel.router.dismiss(animated: true)
                },
                okTapped: { [weak self] in
                    guard let self else { return }
                    Task {
                        await self.downloadAll(isOn: false)
                    }
                    analytics.bulkDownloadVideosToggle(courseID: courseStructure.id, action: false)
                    self.courseViewModel.router.dismiss(animated: true)
                },
                type: .deleteVideo
            )
            return
        }
        
        analytics.bulkDownloadVideosToggle(courseID: courseStructure.id, action: true)
        await downloadAll(isOn: true)
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
            do {
                try await courseViewModel.manager.cancelDownloading(courseId: courseStructure.id)
            } catch {
                debugLog(error)
            }

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
        currentDownloadTask = courseViewModel.manager.currentDownloadTask
        toggleStateIsOn()
        courseViewModel.$downloadableVerticals
            .sink { [weak self] _ in
                guard let self else { return }
                self.currentDownloadTask = self.courseViewModel.manager.currentDownloadTask
                self.toggleStateIsOn()
        }
        .store(in: &cancellables)
        courseViewModel.manager.eventPublisher()
            .sink { [weak self] state in
                guard let self else { return }
                if case .progress = state {
                    self.currentDownloadTask = self.courseViewModel.manager.currentDownloadTask
                }
                self.toggleStateIsOn()
            }
            .store(in: &cancellables)
    }

    private func calculateSize(value: Double, percentage: Double) -> Double {
        let val = value * percentage
        return val / 100.0
    }

    private func blockToMB(data: Set<CourseBlock>, downloadQuality: DownloadQuality) -> Double {
        data.reduce(0) {
            $0 + Double($1.encodedVideo?.video(downloadQuality: downloadQuality)?.fileSize ?? 0)
        } / 1024.0 / 1024.0
    }
}

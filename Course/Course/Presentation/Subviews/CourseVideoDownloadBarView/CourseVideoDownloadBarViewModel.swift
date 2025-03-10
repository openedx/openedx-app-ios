//
//  CourseVideoDownloadBarViewModel.swift
//  Course
//
//  Created by Eugene Yatsenko on 20.12.2023.
//

import Foundation
import Core
import OEXFoundation
import Combine

@MainActor
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

    /// total progress of downloading video files
    var progress: Double = 0

    var downloadableVerticals: Set<VerticalsDownloadState> = [] {
        didSet {
            let downloading = downloadableVerticals.filter { $0.state == .downloading }
            downloadingVideos = downloading.flatMap { $0.downloadableBlocks }.count

            let finished = downloadableVerticals.filter { $0.state == .finished }
            totalFinishedVideos = finished.flatMap { $0.downloadableBlocks }.count
            
            let inProgress = downloadableVerticals.filter { $0.state != .finished }
            remainingVideos = inProgress.flatMap { $0.downloadableBlocks }.count
            
            let totalFinishedCount = finished.count
            isAllVideosDownloaded = totalFinishedCount == downloadableVerticals.count
        }
    }

    var isAllVideosDownloaded: Bool = false

    var remainingVideos: Int = 0

    var downloadingVideos: Int = 0

    var totalFinishedVideos: Int = 0

    var totalSize: String?

    private func sizeInMbOrGb(size: Double) -> String {
        if size >= 1024.0 {
            return String(format: "%.2fGB", size / 1024.0)
        } else {
            return String(format: "%.2fMB", size)
        }
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

    func allActiveDownloads() -> [DownloadDataTask] {
        (courseViewModel.courseHelper.value?.allDownloadTasks ?? [])
            .filter { $0.state == .inProgress || $0.state == .waiting }
    }

    @MainActor
    func onToggle() async {
        if isAllVideosDownloaded {
            courseViewModel.router.presentAlert(
                alertTitle: CourseLocalization.Alert.warning,
                alertMessage: "\(CourseLocalization.Alert.deleteAllVideos) \"\(courseStructure.displayName)\"?",
                positiveAction: CoreLocalization.Alert.delete,
                onCloseTapped: { [weak self] in
                    self?.courseViewModel.router.dismiss(animated: true)
                },
                firstButtonTapped: { [weak self] in
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
                alertTitle: CourseLocalization.Alert.warning,
                alertMessage: "\(CourseLocalization.Alert.stopDownloading) \"\(courseStructure.displayName)\"",
                positiveAction: CoreLocalization.Alert.accept,
                onCloseTapped: { [weak self] in
                    self?.courseViewModel.router.dismiss(animated: true)
                },
                firstButtonTapped: { [weak self] in
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

        if isOn, await courseViewModel.isShowedAllowLargeDownloadAlert(blocks: blocks) {
            return
        }

        if isOn {
            let blocks = downloadableVerticals.filter { $0.state != .finished }.flatMap { $0.vertical.childs }
            await courseViewModel.download(
                state: .available,
                blocks: blocks.filter { $0.type == .video }, sequentials: []
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

    private func toggleStateIsOn(downloadableVerticals: Set<VerticalsDownloadState>) {
        let totalCount = downloadableVerticals.count
        let availableCount = downloadableVerticals.filter { $0.state == .available }.count
        let finishedCount = downloadableVerticals.filter { $0.state == .finished }.count
        let downloadingCount = downloadableVerticals.filter { $0.state == .downloading }.count
        self.downloadableVerticals = downloadableVerticals.filter {
            $0.downloadableBlocks.contains { $0.type == .video }
        }
        
        if downloadingCount == totalCount, totalCount > 0 {
            self.isOn = true
            return
        }
        if totalCount == finishedCount, totalCount > 0 {
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

        let isOn = totalCount - finishedCount == downloadingCount && totalCount > 0
        self.isOn = isOn
    }

    private func observers() {
        currentDownloadTask = courseViewModel.courseHelper.value?.currentDownloadTask
        toggleStateIsOn(downloadableVerticals: courseViewModel.courseHelper.value?.downloadableVerticals ?? [])
        calculateProgress()
        calculateTotalSize()
        courseViewModel.courseHelper.progressPublisher()
            .sink {[weak self] task in
                self?.currentDownloadTask = task
                self?.calculateProgress()
                self?.calculateTotalSize()
            }
            .store(in: &cancellables)
        
        courseViewModel.courseHelper.publisher()
            .sink {[weak self] value in
                self?.currentDownloadTask = value.currentDownloadTask
                self?.calculateProgress()
                self?.toggleStateIsOn(downloadableVerticals: value.downloadableVerticals)
                self?.calculateTotalSize()
            }
            .store(in: &cancellables)
    }
    
    private func calculateTotalSize() {
        let downloadQuality = courseViewModel.userSettings?.downloadQuality ?? .auto
        let mb = courseStructure.totalVideosSizeInMb(
            downloadQuality: downloadQuality
        )

        if mb == 0 {
            totalSize = nil
            return
        }

        if isOn {
            let size =  mb - calculateSize(value: mb, percentage: progress * 100)
            if size == 0 {
                totalSize = sizeInMbOrGb(size: mb)
                return
            }
            totalSize = sizeInMbOrGb(size: size)
            return
        }

        let size = blockToMB(
            data: Set(downloadableVerticals
                .filter { $0.state != .finished }
                .flatMap { $0.downloadableBlocks }
            ),
            downloadQuality: downloadQuality
        )

        totalSize = sizeInMbOrGb(size: size)
    }

    private func calculateProgress() {
        guard let currentDownloadTask = currentDownloadTask else {
            progress = 0.0
            return
        }
        guard let index = courseViewModel.courseDownloadTasks.firstIndex(
            where: { $0.id == currentDownloadTask.id && $0.type == .video }
        ) else {
            progress = 0.0
            return
        }
        courseViewModel.courseDownloadTasks[index].progress = currentDownloadTask.progress
        let videoTasks = courseViewModel.courseDownloadTasks.filter { $0.type == .video }
        progress = videoTasks.reduce(0) {
            $0 + ($1.state == .finished ? 1 : $1.progress)
        } / Double(videoTasks.count)
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

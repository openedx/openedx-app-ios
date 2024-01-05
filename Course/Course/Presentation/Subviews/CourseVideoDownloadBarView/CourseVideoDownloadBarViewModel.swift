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
            if remainingCount == 0 {
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
            .map { $0.progress }
            .reduce(.zero, +) / Double(courseViewModel.courseDownloads.count)
    }

    var isAllDownloaded: Bool {
        totalFinishedCount == courseViewModel.verticalsDownloadState.count
    }

    var remainingCount: Int {
        courseViewModel.verticalsDownloadState.filter { $0.value != .finished }.count
    }

    var downloadingCount: Int {
        courseViewModel.verticalsDownloadState.filter { $0.value == .downloading }.count
    }

    var totalFinishedCount: Int {
        courseViewModel.verticalsDownloadState.filter { $0.value == .finished }.count
    }

    var totalSize: String? {
        let mb = courseStructure.blocksTotalSizeInMb(
            quality: courseViewModel.userSettings?.downloadQuality ?? .auto
        )
        if mb == 0 { return nil }
        let size =  mb - calculateSize(value: mb, percentage: progress * 100)
        if size == 0.0 { return String(format: "%.2f", mb) }
        return String(format: "%.2f", size)
    }

    func allActiveDownloads() async -> [DownloadData] {
        await courseViewModel.manager.getDownloads()
            .filter { $0.state == .inProgress || $0.state == .waiting }
    }

    init(
        courseStructure: CourseStructure,
        courseViewModel: CourseContainerViewModel
    ) {
        self.courseStructure = courseStructure
        self.courseViewModel = courseViewModel
        observers()
    }

    @MainActor
    func downloadAll() async {
        await courseViewModel.downloadAll(
            courseStructure: courseStructure,
            isOn: isOn ? false : true
        )
    }

    // MARK: - Private intents

    private func toggleStateIsOn() {
        let totalCount = courseViewModel.verticalsDownloadState.count
        let availableCount = courseViewModel.verticalsDownloadState.filter { $0.value == .available }.count
        let finishedCount = totalFinishedCount
        let downloadingCount = downloadingCount
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
        courseViewModel.$verticalsDownloadState
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
}

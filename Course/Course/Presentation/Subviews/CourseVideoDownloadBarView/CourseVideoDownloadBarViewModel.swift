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
        guard let index = courseViewModel.downloads.firstIndex(
            where: { $0.id == currentDownload.id }
        ) else {
            return 0.0
        }
        courseViewModel.downloads[index].progress = currentDownload.progress
        return courseViewModel
            .downloads
            .map { $0.progress }
            .reduce(.zero, +) / Double(courseViewModel.downloads.count)
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

    var totalSize: String? {
        let mb = courseStructure.blocksTotalSizeInMb
        if mb == 0.0 {
            return nil
        }
        return String(format: "%.2f", mb)
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

    // MARK: - Private intents

    private func toggleStateIsOn() {
        // Sequentials
        let totalCount = courseViewModel.verticalsDownloadState.count
        let availableCount = courseViewModel.verticalsDownloadState.filter { $0.value == .available }.count
        let finishedCount = courseViewModel.verticalsDownloadState.filter { $0.value == .finished }.count
        let downloadingCount = courseViewModel.verticalsDownloadState.filter { $0.value == .downloading }.count
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

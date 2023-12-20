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
                return currentDownload?.displayName ?? CourseLocalization.Download.downloadingVideos
            }
        } else {
            return CourseLocalization.Download.downloadToDevice
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

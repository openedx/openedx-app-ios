//
//  DownloadsViewModel.swift
//  Course
//
//  Created by Eugene Yatsenko on 20.12.2023.
//

import Foundation
import Core
import OEXFoundation
@preconcurrency import Combine

@MainActor
final class DownloadsViewModel: ObservableObject {

    // MARK: - Properties

    @Published private(set) var downloads: [DownloadDataTask] = []
    
    let router: CourseRouter

    private let helper: CourseDownloadHelper
    private var cancellables = Set<AnyCancellable>()

    init(
        router: CourseRouter,
        helper: CourseDownloadHelper
    ) {
        self.router = router
        self.helper = helper
        Task {
            await configure()
        }
        observers()
    }

    // MARK: - Intents

    func title(task: DownloadDataTask) -> String {
        task.displayName.isEmpty ?
        "(\(CourseLocalization.Download.untitled))" :
        task.displayName
    }

    @MainActor
    func cancelDownloading(task: DownloadDataTask) async {
        do {
            try await helper.cancelDownloading(task: task)
            downloads.removeAll(where: { $0.id == task.id })
        } catch {
            debugLog(error)
        }
    }

    @MainActor
    private func configure() async {
        defer {
            filter()
        }

        downloads = helper.value?.allDownloadTasks ?? []

    }

    private func observers() {
        helper.publisher()
            .sink {[weak self] value in
                self?.downloads = value.allDownloadTasks
            }
            .store(in: &cancellables)
        helper.progressPublisher()
            .sink {[weak self] task in
                if let firstIndex = self?.downloads.firstIndex(where: { $0.id == task.id }) {
                    self?.downloads[firstIndex].progress = task.progress
                }
            }
            .store(in: &cancellables)
    }

    private func filter() {
        downloads = downloads
            .filter { $0.state == .inProgress || $0.state == .waiting }
            .sorted(by: { $0.state.order < $1.state.order })
    }
}

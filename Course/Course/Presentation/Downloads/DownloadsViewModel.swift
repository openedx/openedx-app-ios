//
//  DownloadsViewModel.swift
//  Course
//
//  Created by Eugene Yatsenko on 20.12.2023.
//

import Foundation
import Core
import Combine

final class DownloadsViewModel: ObservableObject {

    // MARK: - Properties

    @Published private(set) var downloads: [DownloadDataTask] = []
    private let courseId: String?

    private let manager: DownloadManagerProtocol
    private var cancellables = Set<AnyCancellable>()

    init(
        courseId: String? = nil,
        manager: DownloadManagerProtocol
    ) {
        self.courseId = courseId
        self.manager = manager
        Task { await configure() }
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
            try await manager.cancelDownloading(task: task)
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
        if let courseId = courseId {
            downloads = await manager.getDownloadTasksForCourse(courseId)
            return
        }
        downloads = await manager.getDownloadTasks()

    }

    private func observers() {
        manager.eventPublisher()
            .sink { [weak self] event in
                guard let self else { return }
                switch event {
                case .progress(let progress, let downloadData):
                    if let firstIndex = downloads.firstIndex(where: { $0.id == downloadData.id }) {
                        self.downloads[firstIndex].progress = progress
                    }
                case .finished(let downloadData):
                    downloads.removeAll(where: { $0.id == downloadData.id })
                default:
                    break
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

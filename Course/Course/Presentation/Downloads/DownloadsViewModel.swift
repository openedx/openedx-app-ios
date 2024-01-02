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

    @Published private(set) var downloads: [DownloadData] = []
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

    @MainActor
    func cancelDownloading(downloadData: DownloadData) async {
        do {
            try await manager.cancelDownloading(downloadData: downloadData)
            downloads.removeAll(where: { $0.id == downloadData.id })
        } catch {
            print(error)
        }
    }

    @MainActor
    private func configure() async {
        defer {
            filter()
        }
        if let courseId = courseId {
            downloads = await manager.getDownloadsForCourse(courseId)
            return
        }
        downloads = await manager.getDownloads()

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
    }

    private func sort() {
        downloads.sort(by: { $0.state.order < $1.state.order })
    }
}

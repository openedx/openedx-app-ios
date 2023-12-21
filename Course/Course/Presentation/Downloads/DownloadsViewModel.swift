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
        defer {
            sort()
        }

        if let courseId = courseId {
            downloads = manager.getDownloadsForCourse(courseId)
            return
        }
        downloads =  manager.getDownloads()
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

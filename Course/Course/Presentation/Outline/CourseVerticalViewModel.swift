//
//  CourseVerticalViewModel.swift
//  Course
//
//  Created by  Stepanok Ivan on 14.03.2023.
//

import SwiftUI
import Core
import Combine

public class CourseVerticalViewModel: BaseCourseViewModel {
    let router: CourseRouter
    let connectivity: ConnectivityProtocol
    @Published var verticals: [CourseVertical]
    @Published var downloadState: [String: DownloadViewState] = [:]
    @Published var showError: Bool = false
    let chapters: [CourseChapter]
    let chapterIndex: Int
    let sequentialIndex: Int
    
    var errorMessage: String? {
        didSet {
            withAnimation {
                showError = errorMessage != nil
            }
        }
    }
    
    public init(
        chapters: [CourseChapter],
        chapterIndex: Int,
        sequentialIndex: Int,
        manager: DownloadManagerProtocol,
        router: CourseRouter,
        connectivity: ConnectivityProtocol
    ) {
        self.chapters = chapters
        self.chapterIndex = chapterIndex
        self.sequentialIndex = sequentialIndex
        self.router = router
        self.connectivity = connectivity
        self.verticals = chapters[chapterIndex].childs[sequentialIndex].childs
        super.init(manager: manager)
        
        manager.publisher()
            .sink(receiveValue: { [weak self] _ in
                guard let self else { return }
                DispatchQueue.main.async {
                    self.setDownloadsStates()
                }
            })
            .store(in: &cancellables)
        
        setDownloadsStates()
    }
    
    func onDownloadViewTap(blockId: String, state: DownloadViewState) {
        if let vertical = verticals.first(where: { $0.id == blockId }) {
            let blocks = vertical.childs.filter { $0.isDownloadable }
            do {
                switch state {
                case .available:
                    try manager.addToDownloadQueue(blocks: blocks)
                    downloadState[vertical.id] = .downloading
                case .downloading:
                    try manager.cancelDownloading(blocks: blocks)
                    downloadState[vertical.id] = .available
                case .finished:
                    manager.deleteFile(blocks: blocks)
                    downloadState[vertical.id] = .available
                }
            } catch let error {
                if error is NoWiFiError {
                    errorMessage = CoreLocalization.Error.wifi
                }
            }
        }
    }
    
    private func setDownloadsStates() {
        let downloads = manager.getAllDownloads()
        var states: [String: DownloadViewState] = [:]
        for vertical in verticals where vertical.isDownloadable {
            var childs: [DownloadViewState] = []
            for block in vertical.childs where block.isDownloadable {
                if let download = downloads.first(where: { $0.id == block.id }) {
                    switch download.state {
                    case .waiting, .inProgress:
                        childs.append(.downloading)
                    case .paused:
                        childs.append(.available)
                    case .finished:
                        childs.append(.finished)
                    }
                } else {
                    childs.append(.available)
                }
            }
            if childs.first(where: { $0 == .downloading }) != nil {
                states[vertical.id] = .downloading
            } else if childs.allSatisfy({ $0 == .finished }) {
                states[vertical.id] = .finished
            } else {
                states[vertical.id] = .available
            }
        }
        downloadState = states
    }
}

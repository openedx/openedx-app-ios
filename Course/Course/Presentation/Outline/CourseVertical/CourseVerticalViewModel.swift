//
//  CourseVerticalViewModel.swift
//  Course
//
//  Created by  Stepanok Ivan on 14.03.2023.
//

import SwiftUI
import Core
import Combine
import OEXFoundation

public final class CourseVerticalViewModel: BaseCourseViewModel {
    let router: CourseRouter
    let analytics: CourseAnalytics
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
        analytics: CourseAnalytics,
        connectivity: ConnectivityProtocol
    ) {
        self.chapters = chapters
        self.chapterIndex = chapterIndex
        self.sequentialIndex = sequentialIndex
        self.router = router
        self.analytics = analytics
        self.connectivity = connectivity
        self.verticals = chapters[chapterIndex].childs[sequentialIndex].childs
        super.init(manager: manager)
        
        do {
            try manager.publisher()
                .sink(receiveValue: { [weak self] _ in
                    guard let self else { return }
                    Task {
                        await self.setDownloadsStates()
                    }
                })
                .store(in: &cancellables)
            Task {
                await setDownloadsStates()
            }
        } catch {
            debugLog(error)
        }
    }
    
    @MainActor
    func onDownloadViewTap(blockId: String, state: DownloadViewState) async {
        if let vertical = verticals.first(where: { $0.id == blockId }) {
            let blocks = vertical.childs.filter { $0.isDownloadable }
            do {
                switch state {
                case .available:
                    try await manager.addToDownloadQueue(blocks: blocks)
                    downloadState[vertical.id] = .downloading
                case .downloading:
                    try await manager.cancelDownloading(courseId: vertical.courseId, blocks: blocks)
                    downloadState[vertical.id] = .available
                case .finished:
                    if let courseId = blocks.first?.courseId {
                        await manager.delete(blocks: blocks, courseId: courseId)
                    }
                    downloadState[vertical.id] = .available
                }
            } catch let error {
                if error is NoWiFiError {
                    errorMessage = CoreLocalization.Error.wifi
                }
            }
        }
    }
    
    @MainActor
    private func setDownloadsStates() async {
        guard let courseId = verticals.first?.courseId else { return }
        let downloadTasks = await manager.getDownloadTasksForCourse(courseId)
        var states: [String: DownloadViewState] = [:]
        for vertical in verticals where vertical.isDownloadable {
            var childs: [DownloadViewState] = []
            for block in vertical.childs where block.isDownloadable {
                if let download = downloadTasks.first(where: { $0.id == block.id }) {
                    switch download.state {
                    case .waiting, .inProgress:
                        childs.append(.downloading)
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

    func trackVerticalClicked(
        courseId: String,
        courseName: String,
        vertical: CourseVertical
    ) {
        analytics.verticalClicked(
            courseId: courseId,
            courseName: courseName,
            blockId: vertical.blockId,
            blockName: vertical.displayName
        )
    }
}

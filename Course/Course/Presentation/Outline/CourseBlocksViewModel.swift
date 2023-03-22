//
//  CourseBlocksViewModel.swift
//  Course
//
//  Created by  Stepanok Ivan on 14.03.2023.
//

import SwiftUI
import Core
import Combine

public class CourseBlocksViewModel: BaseCourseViewModel {
    let router: CourseRouter
    let connectivity: ConnectivityProtocol
    @Published var blocks: [CourseBlock]
    @Published var downloadState: [String: DownloadViewState] = [:]
    @Published var showError: Bool = false

    var errorMessage: String? {
        didSet {
            withAnimation {
                showError = errorMessage != nil
            }
        }
    }
    
    public init(blocks: [CourseBlock],
                manager: DownloadManagerProtocol,
                router: CourseRouter,
                connectivity: ConnectivityProtocol) {
        self.blocks = blocks
        self.router = router
        self.connectivity = connectivity
        
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
        if let block = blocks.first(where: { $0.id == blockId }) {
            do {
                switch state {
                case .available:
                    try manager.addToDownloadQueue(blocks: [block])
                    downloadState[block.id] = .downloading
                case .downloading:
                    try manager.cancelDownloading(blocks: [block])
                    downloadState[block.id] = .available
                case .finished:
                    manager.deleteFile(blocks: [block])
                    downloadState[block.id] = .available
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
        for block in blocks where block.isDownloadable {
            if let download = downloads.first(where: { $0.id == block.id }) {
                switch download.state {
                case .waiting, .inProgress:
                    states[download.id] = .downloading
                case .paused:
                    states[download.id] = .available
                case .finished:
                    states[download.id] = .finished
                }
            } else {
                states[block.id] = .available
            }
        }
        downloadState = states
    }
}

//
//  CourseScreensViewModel.swift
//  Course
//
//  Created by  Stepanok Ivan on 10.10.2022.
//

import Foundation
import SwiftUI
import Core
import Combine

public class CourseContainerViewModel: BaseCourseViewModel {
    
    @Published var courseStructure: CourseStructure?
    @Published var courseVideosStructure: CourseStructure?
    @Published private(set) var isShowProgress = false
    @Published var showError: Bool = false
    @Published var downloadState: [String: DownloadViewState] = [:]
    @Published var returnCourseUnit: CourseBlock?
    @Published var blocks: [CourseBlock] = []
    
    var errorMessage: String? {
        didSet {
            withAnimation {
                showError = errorMessage != nil
            }
        }
    }
    
    public let interactor: CourseInteractorProtocol
    public let router: CourseRouter
    public let config: Config
    public let connectivity: ConnectivityProtocol
    
    public let isActive: Bool?
    public let courseStart: Date?
    public let courseEnd: Date?
    public let enrollmentStart: Date?
    public let enrollmentEnd: Date?
    
    public init(interactor: CourseInteractorProtocol,
                router: CourseRouter,
                config: Config,
                connectivity: ConnectivityProtocol,
                manager: DownloadManagerProtocol,
                isActive: Bool?,
                courseStart: Date?,
                courseEnd: Date?,
                enrollmentStart: Date?,
                enrollmentEnd: Date?
    ) {
        self.interactor = interactor
        self.router = router
        self.config = config
        self.connectivity = connectivity
        self.isActive = isActive
        self.courseStart = courseStart
        self.courseEnd = courseEnd
        self.enrollmentStart = enrollmentStart
        self.enrollmentEnd = enrollmentEnd
        
        super.init(manager: manager)
        
        manager.publisher()
            .sink(receiveValue: { [weak self] _ in
                guard let self else { return }
                DispatchQueue.main.async {
                    self.setDownloadsStates()
                }
            })
            .store(in: &cancellables)
    }
    
    @MainActor
    private func getResumeBlock(courseID: String) async throws {
        let result = try await interactor.resumeBlock(courseID: courseID)
        if let courseStructure {
            self.returnCourseUnit = findCourseBlock(withBlockID: extractBlockID(from: result.blockID),
                                                    courseStructure: courseStructure)
        }
    }
    
    @MainActor
    public func getCourseBlocks(courseID: String, withProgress: Bool = true) async {
        if let courseStart {
            if courseStart < Date() {
                isShowProgress = withProgress
                do {
                    if connectivity.isInternetAvaliable {
                        courseStructure = try await interactor.getCourseBlocks(courseID: courseID)
                        try await getResumeBlock(courseID: courseID)
                    } else {
                        courseStructure = try await interactor.getCourseBlocksOffline(courseID: courseID)
                    }
                    courseVideosStructure = interactor.getCourseVideoBlocks(fullStructure: courseStructure!)
                    setDownloadsStates()
                    isShowProgress = false
                    
                } catch let error {
                    isShowProgress = false
                    if error.isInternetError || error is NoCachedDataError {
                        errorMessage = CoreLocalization.Error.slowOrNoInternetConnection
                    } else {
                        errorMessage = CoreLocalization.Error.unknownError
                    }
                }
            }
        }
    }
    
    func onDownloadViewTap(chapter: CourseChapter, blockId: String, state: DownloadViewState) {
        let blocks = chapter.childs
            .filter { $0.isDownloadable }
            .flatMap { $0.childs }
            .filter { $0.isDownloadable }
            .flatMap { $0.childs }
            .filter { $0.isDownloadable }
        
        do {
            switch state {
            case .available:
                try manager.addToDownloadQueue(blocks: blocks)
                downloadState[blockId] = .downloading
            case .downloading:
                try manager.cancelDownloading(blocks: blocks)
                downloadState[blockId] = .available
            case .finished:
                manager.deleteFile(blocks: blocks)
                downloadState[blockId] = .available
            }
        } catch let error {
            if error is NoWiFiError {
                errorMessage = CoreLocalization.Error.wifi
            }
        }
    }
    
    @MainActor
    private func setDownloadsStates() {
        guard let courseStructure else { return }
        let downloads = manager.getAllDownloads()
        var states: [String: DownloadViewState] = [:]
        for chapter in courseStructure.childs {
            for sequential in chapter.childs where sequential.isDownloadable {
                var childs: [DownloadViewState] = []
                for vertical in sequential.childs where vertical.isDownloadable {
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
                }
                if childs.first(where: { $0 == .downloading }) != nil {
                    states[sequential.id] = .downloading
                } else if childs.allSatisfy({ $0 == .finished }) {
                    states[sequential.id] = .finished
                } else {
                    states[sequential.id] = .available
                }
            }
            self.downloadState = states
        }
    }
    
    private func findCourseBlock(withBlockID blockID: String, courseStructure: CourseStructure) -> CourseBlock? {
        for chapter in courseStructure.childs {
            for sequential in chapter.childs {
                for vertical in sequential.childs {
                    if let block = vertical.childs.first(where: { $0.topicId == blockID }) {
                            self.blocks = vertical.childs
                        return block
                    }
                }
            }
        }
        return nil
    }
    
    private func extractBlockID(from input: String) -> String {
        guard let range = input.range(of: "block@") else {
            return input
        }
        let startIndex = range.upperBound
        let lastIndex = input.endIndex
        return String(input[startIndex..<lastIndex])
    }
}

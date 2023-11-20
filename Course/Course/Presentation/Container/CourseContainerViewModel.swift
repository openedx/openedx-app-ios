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
    @Published var sequentialsDownloadState: [String: DownloadViewState] = [:]
    @Published var verticalsDownloadState: [String: DownloadViewState] = [:]
    @Published var continueWith: ContinueWith?
    
    var errorMessage: String? {
        didSet {
            withAnimation {
                showError = errorMessage != nil
            }
        }
    }
    
    let router: CourseRouter
    let config: Config
    let connectivity: ConnectivityProtocol
    
    let isActive: Bool?
    let courseStart: Date?
    let courseEnd: Date?
    let enrollmentStart: Date?
    let enrollmentEnd: Date?
    
    private let interactor: CourseInteractorProtocol
    private let authInteractor: AuthInteractorProtocol
    private let analytics: CourseAnalytics
    
    public init(
        interactor: CourseInteractorProtocol,
        authInteractor: AuthInteractorProtocol,
        router: CourseRouter,
        analytics: CourseAnalytics,
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
        self.authInteractor = authInteractor
        self.router = router
        self.analytics = analytics
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
    func getCourseBlocks(courseID: String, withProgress: Bool = true) async {
        if let courseStart {
            if courseStart < Date() {
                isShowProgress = withProgress
                do {
                    if connectivity.isInternetAvaliable {
                        courseStructure = try await interactor.getCourseBlocks(courseID: courseID)
                        isShowProgress = false
                        if let courseStructure {
                            let continueWith = try await getResumeBlock(
                                courseID: courseID,
                                courseStructure: courseStructure
                            )
                            withAnimation {
                                self.continueWith = continueWith
                            }
                        }
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
    
    @MainActor
    func tryToRefreshCookies() async {
        try? await authInteractor.getCookies(force: false)
    }
    
    @MainActor
    private func getResumeBlock(courseID: String, courseStructure: CourseStructure) async throws -> ContinueWith? {
        let result = try await interactor.resumeBlock(courseID: courseID)
        return findContinueVertical(
            blockID: result.blockID,
            courseStructure: courseStructure
        )
    }

    func verticalsBlocksDownloadable(by courseSequential: CourseSequential) -> [String: DownloadViewState] {
        verticalsDownloadState.filter { dict in
            courseSequential.childs.contains(where: { item in
                let state = verticalsDownloadState[dict.key]
                return (state == .available || state == .downloading) && dict.key == item.id
            })
        }
    }

    func onDownloadViewTap(chapter: CourseChapter, blockId: String, state: DownloadViewState) {
        let blocks = chapter.childs
            .first(where: { $0.id == blockId })?.childs
            .flatMap { $0.childs }
            .filter { $0.isDownloadable } ?? []
        
        do {
            switch state {
            case .available:
                try manager.addToDownloadQueue(blocks: blocks)
                sequentialsDownloadState[blockId] = .downloading
            case .downloading:
                try manager.cancelDownloading(courseId: courseStructure?.id ?? "", blocks: blocks)
                sequentialsDownloadState[blockId] = .available
            case .finished:
                manager.deleteFile(blocks: blocks)
                sequentialsDownloadState[blockId] = .available
            }
        } catch let error {
            if error is NoWiFiError {
                errorMessage = CoreLocalization.Error.wifi
            }
        }
    }

    func onDownloadViewTap(courseVertical: CourseVertical, state: DownloadViewState) {
        let blocks = courseVertical.childs.filter { $0.isDownloadable }
        do {
            switch state {
            case .available:
                try manager.addToDownloadQueue(blocks: blocks)
                verticalsDownloadState[courseVertical.id] = .downloading
            case .downloading:
                try manager.cancelDownloading(courseId: courseVertical.courseId, blocks: blocks)
                verticalsDownloadState[courseVertical.id] = .available
            case .finished:
                manager.deleteFile(blocks: blocks)
                verticalsDownloadState[courseVertical.id] = .available
            }
        } catch let error {
            if error is NoWiFiError {
                errorMessage = CoreLocalization.Error.wifi
            }
        }
    }

    func trackSelectedTab(
        selection: CourseContainerView.CourseTab,
        courseId: String,
        courseName: String
    ) {
        switch selection {
        case .course:
            analytics.courseOutlineCourseTabClicked(courseId: courseId, courseName: courseName)
        case .videos:
            analytics.courseOutlineVideosTabClicked(courseId: courseId, courseName: courseName)
        case .dates:
            analytics.courseOutlineDatesTabClicked(courseId: courseId, courseName: courseName)
        case .discussion:
            analytics.courseOutlineDiscussionTabClicked(courseId: courseId, courseName: courseName)
        case .handounds:
            analytics.courseOutlineHandoutsTabClicked(courseId: courseId, courseName: courseName)
        }
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

    func trackSequentialClicked(_ sequential: CourseSequential) {
        guard let course = courseStructure else { return }
        analytics.sequentialClicked(
            courseId: course.id,
            courseName: course.displayName,
            blockId: sequential.blockId,
            blockName: sequential.displayName
        )
    }
    
    func trackResumeCourseTapped(blockId: String) {
        guard let course = courseStructure else { return }
        analytics.resumeCourseTapped(
            courseId: course.id,
            courseName: course.displayName,
            blockId: blockId
        )
    }
    
    @MainActor
    private func setDownloadsStates() {
        guard let course = courseStructure else { return }
        let downloads = manager.getDownloadsForCourse(course.id)
        var sequentialsStates: [String: DownloadViewState] = [:]
        var verticalsStates: [String: DownloadViewState] = [:]
        for chapter in course.childs {
            for sequential in chapter.childs where sequential.isDownloadable {
                var sequentialsChilds: [DownloadViewState] = []
                for vertical in sequential.childs where vertical.isDownloadable {
                    var verticalsChilds: [DownloadViewState] = []
                    for block in vertical.childs where block.isDownloadable {
                        if let download = downloads.first(where: { $0.id == block.id }) {
                            switch download.state {
                            case .waiting, .inProgress:
                                sequentialsChilds.append(.downloading)
                                verticalsChilds.append(.downloading)
                            case .paused:
                                sequentialsChilds.append(.available)
                                verticalsChilds.append(.available)
                            case .finished:
                                sequentialsChilds.append(.finished)
                                verticalsChilds.append(.finished)
                            }
                        } else {
                            sequentialsChilds.append(.available)
                            verticalsChilds.append(.available)
                        }
                    }
                    if verticalsChilds.first(where: { $0 == .downloading }) != nil {
                        verticalsStates[vertical.id] = .downloading
                    } else if verticalsChilds.allSatisfy({ $0 == .finished }) {
                        verticalsStates[vertical.id] = .finished
                    } else {
                        verticalsStates[vertical.id] = .available
                    }
                }
                if sequentialsChilds.first(where: { $0 == .downloading }) != nil {
                    sequentialsStates[sequential.id] = .downloading
                } else if sequentialsChilds.allSatisfy({ $0 == .finished }) {
                    sequentialsStates[sequential.id] = .finished
                } else {
                    sequentialsStates[sequential.id] = .available
                }
            }
            self.sequentialsDownloadState = sequentialsStates
            self.verticalsDownloadState = verticalsStates
        }
    }
    
    private func findContinueVertical(blockID: String, courseStructure: CourseStructure) -> ContinueWith? {
        for chapterIndex in courseStructure.childs.indices {
            let chapter = courseStructure.childs[chapterIndex]
            for sequentialIndex in chapter.childs.indices {
                let sequential = chapter.childs[sequentialIndex]
                for verticalIndex in sequential.childs.indices {
                    let vertical = sequential.childs[verticalIndex]
                    for block in vertical.childs where block.id == blockID {
                        return ContinueWith(
                            chapterIndex: chapterIndex,
                            sequentialIndex: sequentialIndex,
                            verticalIndex: verticalIndex
                        )
                    }
                }
            }
        }
        return nil
    }
}

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
    
    @Published private(set) var isShowProgress = false
    @Published var courseStructure: CourseStructure?
    @Published var courseVideosStructure: CourseStructure?
    @Published var showError: Bool = false
    @Published var showAllowLargeDownload: Bool = false
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
    let config: ConfigProtocol
    let connectivity: ConnectivityProtocol
    
    let isActive: Bool?
    let courseStart: Date?
    let courseEnd: Date?
    let enrollmentStart: Date?
    let enrollmentEnd: Date?

    var courseDownloads: [DownloadData] = []
    private(set) var waitingDownload: [CourseBlock]?
    var allowedDownloadLargeDownload: Bool = false

    private let interactor: CourseInteractorProtocol
    private let authInteractor: AuthInteractorProtocol
    private let analytics: CourseAnalytics
    private var storage: CourseStorage

    public init(
        interactor: CourseInteractorProtocol,
        authInteractor: AuthInteractorProtocol,
        router: CourseRouter,
        analytics: CourseAnalytics,
        config: ConfigProtocol,
        connectivity: ConnectivityProtocol,
        manager: DownloadManagerProtocol,
        storage: CourseStorage,
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
        self.storage = storage

        super.init(manager: manager)
        
        manager.eventPublisher()
            .sink { [weak self] state in
                guard let self else { return }
                if case .progress = state { return }
                Task {
                    await self.setDownloadsStates()
                }
            }
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
                        courseStructure = try await interactor.getLoadedCourseBlocks(courseID: courseID)
                    }
                    courseVideosStructure = interactor.getCourseVideoBlocks(fullStructure: courseStructure!)
                    await setDownloadsStates()
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

    @MainActor
    func onDownloadViewTap(chapter: CourseChapter, blockId: String, state: DownloadViewState) async {
        guard let sequential = chapter.childs
            .first(where: { $0.id == blockId }) else {
            return
        }

        let blocks =  sequential.childs.flatMap { $0.childs }
            .filter { $0.isDownloadable }

        if state == .available, isShowedAllowLargeDownloadAlert(blocks: blocks) {
            return
        }

        await download(state: state, blocks: blocks)
    }

    @MainActor
    func downloadAll(courseStructure: CourseStructure, isOn: Bool) async {
        let courseChapters = courseStructure.childs

        let blocks = courseChapters.flatMap { $0.childs }
            .filter { $0.isDownloadable }
            .flatMap { $0.childs }
            .flatMap { $0.childs }

        if isOn, isShowedAllowLargeDownloadAlert(blocks: blocks) {
            return
        }

        for courseChapter in courseChapters {
            let sequentials = courseChapter.childs
                .filter { $0.isDownloadable }
            for sequential in sequentials {
                guard let state = sequentialsDownloadState[sequential.id] else {
                   return
                }
                switch state {
                case .available:
                    await download(
                        state: state,
                        blocks: downloadableBlocks(from: sequential)
                    )
                case .downloading, .finished:
                    if isOn { break }
                    await download(
                        state: state,
                        blocks: downloadableBlocks(from: sequential)
                    )
                }
            }
        }
    }

    func verticalsBlocksDownloadable(by courseSequential: CourseSequential) -> [String: DownloadViewState] {
        verticalsDownloadState.filter { dict in
            courseSequential.childs.contains(where: { item in
                return dict.key == item.id
            })
        }
    }

    func continueDownload() {
        guard let blocks = waitingDownload else {
            return
        }
        storage.allowedDownloadLargeFile = true
        do {
            try manager.addToDownloadQueue(blocks: blocks)
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

    func hasVideoForDowbloads() -> Bool {
        guard let courseVideosStructure = courseVideosStructure else {
            return false
        }
        return courseVideosStructure.childs
            .flatMap { $0.childs }
            .contains(where: { $0.isDownloadable })
    }

    @MainActor
    private func isShowedAllowLargeDownloadAlert(blocks: [CourseBlock]) -> Bool {
        waitingDownload = nil
        if storage.allowedDownloadLargeFile == false, manager.isLarge(blocks: blocks) {
            waitingDownload = blocks
            showAllowLargeDownload = true
            return true
        }
        return false
    }

    @MainActor
    private func download(state: DownloadViewState, blocks: [CourseBlock]) async {
        do {
            switch state {
            case .available:
                try manager.addToDownloadQueue(blocks: blocks)
            case .downloading:
                try await manager.cancelDownloading(courseId: courseStructure?.id ?? "", blocks: blocks)
            case .finished:
                manager.deleteFile(blocks: blocks)
            }
        } catch let error {
            if error is NoWiFiError {
                errorMessage = CoreLocalization.Error.wifi
            }
        }
    }

    @MainActor
    func downloadableBlocks(from sequential: CourseSequential) -> [CourseBlock] {
        let verticals = sequential.childs
        let blocks = verticals
            .flatMap { $0.childs }
            .filter { $0.isDownloadable }
        return blocks
    }

    @MainActor
    private func setDownloadsStates() async {
        guard let course = courseStructure else { return }
        self.courseDownloads = await manager.getDownloadsForCourse(course.id)
        var sequentialsStates: [String: DownloadViewState] = [:]
        var verticalsStates: [String: DownloadViewState] = [:]
        for chapter in course.childs {
            for sequential in chapter.childs where sequential.isDownloadable {
                var sequentialsChilds: [DownloadViewState] = []
                for vertical in sequential.childs where vertical.isDownloadable {
                    var verticalsChilds: [DownloadViewState] = []
                    for block in vertical.childs where block.isDownloadable {
                        if let download = courseDownloads.first(where: { $0.id == block.id }) {
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

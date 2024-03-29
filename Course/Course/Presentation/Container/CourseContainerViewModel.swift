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
    @Published var sequentialsDownloadState: [String: DownloadViewState] = [:]
    @Published private(set) var downloadableVerticals: Set<VerticalsDownloadState> = []
    @Published var continueWith: ContinueWith?
    @Published var userSettings: UserSettings?
    @Published var isInternetAvaliable: Bool = true

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

    var courseDownloadTasks: [DownloadDataTask] = []
    private(set) var waitingDownloads: [CourseBlock]?

    private let interactor: CourseInteractorProtocol
    private let authInteractor: AuthInteractorProtocol
    private let analytics: CourseAnalytics
    private(set) var storage: CourseStorage

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
        self.userSettings = storage.userSettings
        self.isInternetAvaliable = connectivity.isInternetAvaliable

        super.init(manager: manager)

        addObservers()
    }
    
    @MainActor
    func getCourseBlocks(courseID: String, withProgress: Bool = true) async {
        if let courseStart {
            if courseStart < Date() {
                isShowProgress = withProgress
                do {
                    if isInternetAvaliable {
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

    func update(downloadQuality: DownloadQuality) {
        storage.userSettings?.downloadQuality = downloadQuality
        userSettings = storage.userSettings
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

    func verticalsBlocksDownloadable(by courseSequential: CourseSequential) -> [CourseBlock] {
        let verticals = downloadableVerticals.filter { verticalState in
            courseSequential.childs.contains(where: { item in
                return verticalState.vertical.id == item.id
            })
        }
        return verticals.flatMap { $0.vertical.childs.filter { $0.isDownloadable } }
    }

    func continueDownload() {
        guard let blocks = waitingDownloads else {
            return
        }
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

    func completeBlock(
        chapterID: String,
        sequentialID: String,
        verticalID: String,
        blockID: String
    ) {
        guard let chapterIndex = courseStructure?
            .childs.firstIndex(where: { $0.id == chapterID }) else {
            return
        }
        guard let sequentialIndex = courseStructure?
            .childs[chapterIndex]
            .childs.firstIndex(where: { $0.id == sequentialID }) else {
            return
        }

        guard let verticalIndex = courseStructure?
            .childs[chapterIndex]
            .childs[sequentialIndex]
            .childs.firstIndex(where: { $0.id == verticalID }) else {
            return
        }

        guard let blockIndex = courseStructure?
            .childs[chapterIndex]
            .childs[sequentialIndex]
            .childs[verticalIndex]
            .childs.firstIndex(where: { $0.id == blockID }) else {
            return
        }

        courseStructure?
            .childs[chapterIndex]
            .childs[sequentialIndex]
            .childs[verticalIndex]
            .childs[blockIndex].completion = 1
        courseStructure.map {
            courseVideosStructure = interactor.getCourseVideoBlocks(fullStructure: $0)
        }
    }

    func hasVideoForDowbloads() -> Bool {
        guard let courseVideosStructure = courseVideosStructure else {
            return false
        }
        return courseVideosStructure.childs
            .flatMap { $0.childs }
            .contains(where: { $0.isDownloadable })
    }

    func isAllDownloading() -> Bool {
        let totalCount = downloadableVerticals.count
        let downloadingCount = downloadableVerticals.filter { $0.state == .downloading }.count
        let finishedCount = downloadableVerticals.filter { $0.state == .finished }.count
        if finishedCount == totalCount { return false }
        return totalCount - finishedCount == downloadingCount
    }

    @MainActor
    func download(state: DownloadViewState, blocks: [CourseBlock]) async {
        do {
            switch state {
            case .available:
                try manager.addToDownloadQueue(blocks: blocks)
            case .downloading:
                try await manager.cancelDownloading(courseId: courseStructure?.id ?? "", blocks: blocks)
            case .finished:
                await manager.deleteFile(blocks: blocks)
            }
        } catch let error {
            if error is NoWiFiError {
                errorMessage = CoreLocalization.Error.wifi
            }
        }
    }

    @MainActor
    func isShowedAllowLargeDownloadAlert(blocks: [CourseBlock]) -> Bool {
        waitingDownloads = nil
        if storage.allowedDownloadLargeFile == false, manager.isLargeVideosSize(blocks: blocks) {
            waitingDownloads = blocks
            router.presentAlert(
                alertTitle: CourseLocalization.Download.download,
                alertMessage: CourseLocalization.Download.downloadLargeFileMessage,
                positiveAction: CourseLocalization.Alert.accept,
                onCloseTapped: {
                    self.router.dismiss(animated: true)
                },
                okTapped: {
                    self.continueDownload()
                    self.router.dismiss(animated: true)
                },
                type: .default(positiveAction: CourseLocalization.Alert.accept, image: nil)
            )
            return true
        }
        return false
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
    func setDownloadsStates() async {
        guard let course = courseStructure else { return }
        courseDownloadTasks = await manager.getDownloadTasksForCourse(course.id)
        downloadableVerticals = []
        var sequentialsStates: [String: DownloadViewState] = [:]
        for chapter in course.childs {
            for sequential in chapter.childs where sequential.isDownloadable {
                var sequentialsChilds: [DownloadViewState] = []
                for vertical in sequential.childs where vertical.isDownloadable {
                    var verticalsChilds: [DownloadViewState] = []
                    for block in vertical.childs where block.isDownloadable {
                        if let download = courseDownloadTasks.first(where: { $0.id == block.id }) {
                            switch download.state {
                            case .waiting, .inProgress:
                                sequentialsChilds.append(.downloading)
                                verticalsChilds.append(.downloading)
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
                        downloadableVerticals.insert(.init(vertical: vertical, state: .downloading))
                    } else if verticalsChilds.allSatisfy({ $0 == .finished }) {
                        downloadableVerticals.insert(.init(vertical: vertical, state: .finished))
                    } else {
                        downloadableVerticals.insert(.init(vertical: vertical, state: .available))
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
                            verticalIndex: verticalIndex,
                            lastVisitedBlockId: block.id
                        )
                    }
                }
            }
        }
        return nil
    }

    private func addObservers() {
        manager.eventPublisher()
            .sink { [weak self] state in
                guard let self else { return }
                if case .progress = state { return }
                Task(priority: .background) {
                    debugLog(state, "--- state ---")
                    await self.setDownloadsStates()
                }
            }
            .store(in: &cancellables)

        connectivity.internetReachableSubject
            .sink { [weak self] _ in
            guard let self else { return }
                self.isInternetAvaliable = self.connectivity.isInternetAvaliable
        }
        .store(in: &cancellables)
    }
}

struct VerticalsDownloadState: Hashable {
    let vertical: CourseVertical
    let state: DownloadViewState

    var downloadableBlocks: [CourseBlock] {
        vertical.childs.filter { $0.isDownloadable }
    }
}

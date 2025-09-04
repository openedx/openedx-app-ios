//
//  CourseContainerViewModel.swift
//  Course
//
//  Created by  Stepanok Ivan on 10.10.2022.
//

import Foundation
import SwiftUI
import Core
import OEXFoundation
import Combine

public enum CourseTab: Int, CaseIterable, Identifiable, Sendable {
    public var id: Int {
        rawValue
    }
    case course
    case content
    case progress
    case videos
    case dates
    case offline
    case discussion
    case handounds
}

extension CourseTab {
    public var title: String {
        switch self {
        case .course:
            return CourseLocalization.CourseContainer.home
        case .content:
            return CourseLocalization.CourseContainer.content
        case .progress:
            return CourseLocalization.CourseContainer.progress
        case .videos:
            return CourseLocalization.CourseContainer.videos
        case .dates:
            return CourseLocalization.CourseContainer.dates
        case .offline:
            return CourseLocalization.CourseContainer.offline
        case .discussion:
            return CourseLocalization.CourseContainer.discussions
        case .handounds:
            return CourseLocalization.CourseContainer.handouts
        }
    }
    
    public var image: Image {
        switch self {
        case .course:
            return CoreAssets.home.swiftUIImage.renderingMode(.template)
        case .content:
            return CoreAssets.content.swiftUIImage.renderingMode(.template)
        case .progress:
            return CoreAssets.progress.swiftUIImage.renderingMode(.template)
        case .videos:
            return CoreAssets.videos.swiftUIImage.renderingMode(.template)
        case .dates:
            return CoreAssets.dates.swiftUIImage.renderingMode(.template)
        case .offline:
            return CoreAssets.downloads.swiftUIImage.renderingMode(.template)
        case .discussion:
            return  CoreAssets.discussions.swiftUIImage.renderingMode(.template)
        case .handounds:
            return CoreAssets.more.swiftUIImage.renderingMode(.template)
        }
    }
}

//swiftlint:disable type_body_length file_length
@MainActor
public final class CourseContainerViewModel: BaseCourseViewModel {
    
    @Published public var selection: Int
    @Published var selectedTab: ContentTab = .all
    @Published var isShowProgress = false
    @Published var isShowRefresh = false
    @Published var courseStructure: CourseStructure?
    @Published var courseDeadlineInfo: CourseDateBanner?
    @Published var courseVideosStructure: CourseStructure?
    @Published var courseAssignmentsStructure: CourseStructure?
    @Published var courseProgressDetails: CourseProgressDetails?
    @Published var showError: Bool = false
    @Published var sequentialsDownloadState: [String: DownloadViewState] = [:]
    @Published private(set) var downloadableVerticals: Set<VerticalsDownloadState> = []
    @Published var continueWith: ContinueWith?
    @Published var userSettings: UserSettings?
    @Published var isInternetAvaliable = true
    @Published var dueDatesShifted: Bool = false
    @Published var updateCourseProgress: Bool = false
    @Published var totalFilesSize: Int = 1
    @Published var downloadedFilesSize: Int = 0
    @Published var largestDownloadBlocks: [CourseBlock] = []
    @Published var downloadAllButtonState: OfflineView.DownloadAllState = .start
    @Published var expandedSections: [String: Bool] = [:]
    @Published var courseDeadlines: CourseDates?
    @Published private(set) var assignmentSectionsData: [AssignmentSection] = []
    private(set) var realDownloadedFilesSize: Int = 0
    
    @Published var tabBarIndex = 0
    
    let completionPublisher = NotificationCenter.default.publisher(for: .onblockCompletionRequested)
    
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
    let lastVisitedBlockID: String?
    
    var courseDownloadTasks: [DownloadDataTask] = []
    private(set) var waitingDownloads: [CourseBlock]?
    
    private let interactor: CourseInteractorProtocol
    private let authInteractor: AuthInteractorProtocol
    let analytics: CourseAnalytics
    let coreAnalytics: CoreAnalytics
    private(set) var storage: CourseStorage
    
    private let cellularFileSizeLimit: Int = 100 * 1024 * 1024
    var courseHelper: CourseDownloadHelperProtocol
    
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
        enrollmentEnd: Date?,
        lastVisitedBlockID: String?,
        coreAnalytics: CoreAnalytics,
        selection: CourseTab = CourseTab.course,
        courseHelper: CourseDownloadHelperProtocol
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
        self.lastVisitedBlockID = lastVisitedBlockID
        self.coreAnalytics = coreAnalytics
        self.selection = selection.rawValue
        self.courseHelper = courseHelper
        self.courseHelper.videoQuality = storage.userSettings?.downloadQuality ?? .auto
        super.init(manager: manager)
        addObservers()
    }
    
    func updateCourseIfNeeded(courseID: String) async {
        guard !isShowRefresh, !isShowProgress else {
            return
        }
        if updateCourseProgress {
            await getCourseBlocks(courseID: courseID, withProgress: true)
            updateCourseProgress = false
        } else if courseStructure == nil {
            // Load course structure if not already loaded (important for offline mode)
            await getCourseBlocks(courseID: courseID, withProgress: true)
        }
    }
    
    func openLastVisitedBlock() {
        guard let continueWith = continueWith,
              let courseStructure = courseStructure else { return }
        let chapter = courseStructure.childs[continueWith.chapterIndex]
        let sequential = chapter.childs[continueWith.sequentialIndex]
        let continueUnit = sequential.childs[continueWith.verticalIndex]
        
        var continueBlock: CourseBlock?
        continueUnit.childs.forEach { block in
            if block.id == continueWith.lastVisitedBlockId {
                continueBlock = block
            }
        }
        
        trackResumeCourseClicked(
            blockId: continueBlock?.id ?? ""
        )
        
        router.showCourseUnit(
            courseName: courseStructure.displayName,
            blockId: continueBlock?.id ?? "",
            courseID: courseStructure.id,
            verticalIndex: continueWith.verticalIndex,
            chapters: courseStructure.childs,
            chapterIndex: continueWith.chapterIndex,
            sequentialIndex: continueWith.sequentialIndex
        )
    }
    
    @MainActor
    func getCourseStructure(courseID: String) async throws -> CourseStructure? {
        if isInternetAvaliable {
            return try await interactor.getCourseBlocks(courseID: courseID)
        } else {
            return try await interactor.getLoadedCourseBlocks(courseID: courseID)
        }
    }
    
    @MainActor
    func getCourseBlocks(courseID: String, withProgress: Bool = true) async {
        guard let courseStart, courseStart < Date() else { return }
        
        isShowProgress = withProgress
        isShowRefresh = !withProgress
        
        async let structureTask = getCourseStructure(courseID: courseID)
        async let progressTask: CourseProgressDetails? = {
            do {
                if await isInternetAvaliable {
                    return try await interactor.getCourseProgress(courseID: courseID)
                } else {
                    return try await interactor.getCourseProgressOffline(courseID: courseID)
                }
            } catch {
                debugLog("Failed to load course progress: \(error.localizedDescription)")
                return nil
            }
        }()
        
        do {
            guard let courseStructure = try await structureTask else {
                throw NSError(
                    domain: "GetCourseBlocks",
                    code: 0,
                    userInfo: [NSLocalizedDescriptionKey: "Course structure is nil"]
                )
            }
            
            self.courseStructure = courseStructure
            courseHelper.courseStructure = courseStructure
            await courseHelper.refreshValue()
            update(from: courseHelper.value ?? .empty)
            
            // progress may still be downloading; assign when ready
            self.courseProgressDetails = await progressTask
            
            async let videosTask = interactor.getCourseVideoBlocks(fullStructure: courseStructure)
            async let assignmentsTask = interactor.getCourseAssignmentBlocks(fullStructure: courseStructure)
            
            courseVideosStructure = await videosTask
            courseAssignmentsStructure = await assignmentsTask
            updateAssignmentSections()
            
            if isInternetAvaliable {
                NotificationCenter.default.post(name: .getCourseDates, object: courseID)
                try? await getResumeBlock(courseID: courseID, courseStructure: courseStructure)
            }
            
            if expandedSections.isEmpty {
                initializeExpandedSections()
            }
            
        } catch {
            // Critical failure (no structure) — wipe everything
            debugLog("Failed to load course blocks: \(error.localizedDescription)")
            courseStructure = nil
            courseVideosStructure = nil
            courseAssignmentsStructure = nil
            courseProgressDetails = nil
            assignmentSectionsData = []
        }
        isShowProgress = false
        isShowRefresh = false
    }
    
    @MainActor
    func getCourseDeadlineInfo(courseID: String, withProgress: Bool = true) async {
        do {
            let courseDeadlineInfo = try await interactor.getCourseDeadlineInfo(courseID: courseID)
            withAnimation {
                self.courseDeadlineInfo = courseDeadlineInfo
            }
        } catch let error {
            debugLog(error.localizedDescription)
        }
    }
    
    @MainActor
    func shiftDueDates(courseID: String, withProgress: Bool = true, screen: DatesStatusInfoScreen, type: String) async {
        isShowProgress = withProgress
        isShowRefresh = !withProgress
        
        do {
            try await interactor.shiftDueDates(courseID: courseID)
            NotificationCenter.default.post(name: .shiftCourseDates, object: courseID)
            isShowProgress = false
            isShowRefresh = false
            
            analytics.plsSuccessEvent(
                .plsShiftDatesSuccess,
                bivalue: .plsShiftDatesSuccess,
                courseID: courseID,
                screenName: screen.rawValue,
                type: type,
                success: true
            )
            
        } catch let error {
            isShowProgress = false
            isShowRefresh = false
            analytics.plsSuccessEvent(
                .plsShiftDatesSuccess,
                bivalue: .plsShiftDatesSuccess,
                courseID: courseID,
                screenName: screen.rawValue,
                type: type,
                success: false
            )
            if error.isInternetError || error is NoCachedDataError {
                errorMessage = CoreLocalization.Error.slowOrNoInternetConnection
            } else {
                errorMessage = CoreLocalization.Error.unknownError
            }
        }
    }
    
    func update(downloadQuality: DownloadQuality) {
        storage.userSettings?.downloadQuality = downloadQuality
        userSettings = storage.userSettings
        courseHelper.videoQuality = downloadQuality
        courseHelper.refreshValue()
    }
    
    @MainActor
    func tryToRefreshCookies() async {
        try? await authInteractor.getCookies(force: false)
    }
    
    @MainActor
    private func getResumeBlock(courseID: String, courseStructure: CourseStructure) async throws {
        if let lastVisitedBlockID {
            self.continueWith = findContinueVertical(
                blockID: lastVisitedBlockID,
                courseStructure: courseStructure
            )
            openLastVisitedBlock()
        } else {
            let result = try await interactor.resumeBlock(courseID: courseID)
            withAnimation {
                self.continueWith = findContinueVertical(
                    blockID: result.blockID,
                    courseStructure: courseStructure
                )
            }
        }
    }
    
    @MainActor
    func onDownloadViewTap(chapter: CourseChapter, state: DownloadViewState) async {
        let blocks = chapter.childs
            .flatMap { $0.childs }
            .flatMap { $0.childs }
            .filter { $0.isDownloadable }

        if state == .available, await isShowedAllowLargeDownloadAlert(blocks: blocks) {
            return
        }

        if state == .available {
            analytics.bulkDownloadVideosSection(
                courseID: courseStructure?.id ?? "",
                sectionID: chapter.id,
                videos: blocks.count
            )
        } else if state == .finished {
            analytics.bulkDeleteVideosSection(
                courseID: courseStructure?.id ?? "",
                sectionId: chapter.id,
                videos: blocks.count
            )
        }

        await download(state: state, blocks: blocks, sequentials: chapter.childs.filter({ $0.isDownloadable }))
    }
    
    func continueDownload() async {
        guard let blocks = waitingDownloads else {
            return
        }
        do {
            try await manager.addToDownloadQueue(blocks: blocks)
        } catch let error {
            if error is NoWiFiError {
                errorMessage = CoreLocalization.Error.wifi
            }
        }
    }
    
    func trackSelectedTab(
        selection: CourseTab,
        courseId: String,
        courseName: String
    ) {
        switch selection {
        case .course:
            analytics.courseOutlineCourseTabClicked(courseId: courseId, courseName: courseName)
        case .content:
            analytics.courseOutlineContentTabClicked(courseId: courseId, courseName: courseName)
        case .progress:
            analytics.courseOutlineProgressTabClicked(courseId: courseId, courseName: courseName)
        case .videos:
            analytics.courseOutlineVideosTabClicked(courseId: courseId, courseName: courseName)
        case .offline:
            analytics.courseOutlineOfflineTabClicked(courseId: courseId, courseName: courseName)
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
    
    func trackViewCertificateClicked(courseID: String) {
        analytics.trackCourseEvent(
            .courseViewCertificateClicked,
            biValue: .courseViewCertificateClicked,
            courseID: courseID
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
    
    func trackSectionClicked(_ chapter: CourseChapter) {
        guard let course = courseStructure else { return }
        analytics.contentPageSectionClicked(
            courseId: course.id,
            courseName: course.displayName,
            blockId: chapter.blockId,
            blockName: chapter.displayName
        )
    }
    
    func trackShowCompletedSubsectionClicked() {
        guard let course = courseStructure else { return }
        analytics.contentPageShowCompletedSubsectionClicked(
            courseId: course.id,
            courseName: course.displayName
        )
    }
    
    func trackAssignmentClicked(_ sequential: CourseSequential) {
        guard let course = courseStructure else { return }
        analytics.courseAssignmentClicked(
            courseId: course.id,
            courseName: course.displayName,
            blockId: sequential.blockId,
            blockName: sequential.displayName
        )
    }
    
    func trackResumeCourseClicked(blockId: String) {
        guard let course = courseStructure else { return }
        analytics.resumeCourseClicked(
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
    ) async {
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
        
        if let courseStructure {
            courseVideosStructure = await interactor.getCourseVideoBlocks(fullStructure: courseStructure)
            courseAssignmentsStructure = await interactor.getCourseAssignmentBlocks(fullStructure: courseStructure)
            updateAssignmentSections()
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
    func isAllDownloaded() -> Bool {
        guard let course = courseStructure else { return false }
        for chapter in course.childs {
            for sequential in chapter.childs where sequential.isDownloadable {
                let blocks = downloadableBlocks(from: sequential)
                for block in blocks {
                    if let task = courseDownloadTasks.first(where: { $0.blockId == block.id }) {
                        if task.state != .finished {
                            return false
                        }
                    } else {
                        return false
                    }
                }
            }
        }
        return true
    }
    
    @MainActor
    func download(state: DownloadViewState, blocks: [CourseBlock], sequentials: [CourseSequential]) async {
        do {
            switch state {
            case .available:
                try await manager.addToDownloadQueue(blocks: blocks)
            case .downloading:
                try await manager.cancelDownloading(courseId: courseStructure?.id ?? "", blocks: blocks)
            case .finished:
                await presentRemoveDownloadAlert(blocks: blocks, sequentials: sequentials)
            }
        } catch let error {
            if error is NoWiFiError {
                errorMessage = CoreLocalization.Error.wifi
            }
        }
    }
    
    private func presentNoInternetAlert(sequentials: [CourseSequential]) {
        router.presentView(
            transitionStyle: .coverVertical,
            view: DownloadErrorAlertView(
                errorType: .noInternetConnection,
                sequentials: sequentials,
                close: { [weak self] in
                    guard let self else { return }
                    self.router.dismiss(animated: true)
                }
            ),
            completion: {}
        )
    }
    
    private func presentWifiRequiredAlert(sequentials: [CourseSequential]) {
        router.presentView(
            transitionStyle: .coverVertical,
            view: DownloadErrorAlertView(
                errorType: .wifiRequired,
                sequentials: sequentials,
                close: { [weak self] in
                    guard let self else { return }
                    self.router.dismiss(animated: true)
                }
            ),
            completion: {}
        )
    }
    
    @MainActor
    private func presentConfirmDownloadCellularAlert(
        blocks: [CourseBlock],
        sequentials: [CourseSequential],
        totalFileSize: Int,
        action: @escaping () -> Void = {}
    ) async {
        router.presentView(
            transitionStyle: .coverVertical,
            view: DownloadActionView(
                actionType: .confirmDownloadCellular,
                sequentials: sequentials,
                downloadedSize: courseHelper.sizeFor(sequentials: sequentials),
                action: { [weak self] in
                    guard let self else { return }
                    if !self.isEnoughSpace(for: totalFileSize) {
                        self.presentStorageFullAlert(sequentials: sequentials)
                    } else {
                        Task {
                            try? await self.manager.addToDownloadQueue(blocks: blocks)
                        }
                        action()
                    }
                    self.router.dismiss(animated: true)
                },
                cancel: { [weak self] in
                    guard let self else { return }
                    self.router.dismiss(animated: true)
                }
            ),
            completion: {}
        )
    }
    
    private func presentStorageFullAlert(sequentials: [CourseSequential]) {
        router.presentView(
            transitionStyle: .coverVertical,
            view: DeviceStorageFullAlertView(
                sequentials: sequentials,
                usedSpace: getUsedDiskSpace() ?? 0,
                freeSpace: manager.getFreeDiskSpace() ?? 0,
                close: { [weak self] in
                    guard let self else { return }
                    self.router.dismiss(animated: true)
                }
            ),
            completion: {}
        )
    }
    
    @MainActor
    private func presentConfirmDownloadAlert(
        blocks: [CourseBlock],
        sequentials: [CourseSequential],
        totalFileSize: Int,
        action: @escaping () -> Void = {}
    ) {
        router.presentView(
            transitionStyle: .coverVertical,
            view: DownloadActionView(
                actionType: .confirmDownload,
                sequentials: sequentials,
                downloadedSize: courseHelper.sizeFor(sequentials: sequentials),
                action: { [weak self] in
                    guard let self else { return }
                    if !self.isEnoughSpace(for: totalFileSize) {
                        self.router.dismiss(animated: true)
                        self.presentStorageFullAlert(sequentials: sequentials)
                    } else {
                        Task {
                            try? await self.manager.addToDownloadQueue(blocks: blocks)
                        }
                        action()
                    }
                    self.router.dismiss(animated: true)
                },
                cancel: { [weak self] in
                    guard let self else { return }
                    self.router.dismiss(animated: true)
                }
            ),
            completion: {}
        )
    }
    
    private func presentRemoveDownloadAlert(blocks: [CourseBlock], sequentials: [CourseSequential]) async {
        router.presentView(
            transitionStyle: .coverVertical,
            view: DownloadActionView(
                actionType: .remove,
                sequentials: sequentials,
                downloadedSize: courseHelper.sizeFor(sequentials: sequentials),
                action: { [weak self] in
                    guard let self else { return }
                    if let courseID = self.courseStructure?.id {
                        Task {
                            await self.manager.delete(blocks: blocks, courseId: courseID)
                            self.router.dismiss(animated: true)
                        }
                    }
                },
                cancel: { [weak self] in
                    guard let self else { return }
                    self.router.dismiss(animated: true)
                }
            ),
            completion: {}
        )
    }
    
    @MainActor
    func collectBlocks(
        chapter: CourseChapter,
        blockId: String,
        state: DownloadViewState,
        videoOnly: Bool = false
    ) async -> [CourseBlock] {
        let sequentials = chapter.childs.filter { $0.id == blockId }
        guard !sequentials.isEmpty else { return [] }
        
        let blocks = sequentials.flatMap { $0.childs.flatMap { $0.childs } }
            .filter { $0.isDownloadable && (!videoOnly || $0.type == .video) }
        
        if state == .available, await isShowedAllowLargeDownloadAlert(blocks: blocks) {
            return []
        }
        
        guard let sequential = chapter.childs.first(where: { $0.id == blockId }) else {
            return []
        }
        
        if state == .available {
            analytics.bulkDownloadVideosSubsection(
                courseID: courseStructure?.id ?? "",
                sectionID: chapter.id,
                subSectionID: sequential.id,
                videos: blocks.count
            )
        } else if state == .finished {
            analytics.bulkDeleteVideosSubsection(
                courseID: courseStructure?.id ?? "",
                subSectionID: sequential.id,
                videos: blocks.count
            )
        }
        
        return blocks
    }
    
    @MainActor
    func isShowedAllowLargeDownloadAlert(blocks: [CourseBlock]) async -> Bool {
        waitingDownloads = nil
        if storage.allowedDownloadLargeFile == false, await manager.isLargeVideosSize(blocks: blocks) {
            waitingDownloads = blocks
            router.presentAlert(
                alertTitle: CoreLocalization.Download.download,
                alertMessage: CoreLocalization.Download.downloadLargeFileMessage,
                positiveAction: CoreLocalization.Alert.accept,
                onCloseTapped: {
                    self.router.dismiss(animated: true)
                },
                firstButtonTapped: {
                    Task {
                        await self.continueDownload()
                    }
                    self.router.dismiss(animated: true)
                },
                type: .default(positiveAction: CoreLocalization.Alert.accept, image: nil)
            )
            return true
        }
        return false
    }
    
    @MainActor
    func downloadAll() async {
        guard let course = courseStructure else { return }
        var blocksToDownload: [CourseBlock] = []
        var sequentialsToDownload: [CourseSequential] = []
        
        for chapter in course.childs {
            for sequential in chapter.childs where sequential.isDownloadable {
                let blocks = downloadableBlocks(from: sequential)
                let notDownloadedBlocks = blocks.filter { !isBlockDownloaded($0) }
                if !notDownloadedBlocks.isEmpty {
                    var updatedSequential = sequential
                    updatedSequential.childs = updatedSequential.childs.map { vertical in
                        var updatedVertical = vertical
                        updatedVertical.childs = vertical.childs.filter { block in
                            notDownloadedBlocks.contains { $0.id == block.id }
                        }
                        return updatedVertical
                    }
                    blocksToDownload.append(contentsOf: notDownloadedBlocks)
                    sequentialsToDownload.append(updatedSequential)
                }
            }
        }
        
        if !blocksToDownload.isEmpty {
            let totalFileSize = blocksToDownload.reduce(0) { $0 + ($1.fileSize ?? 0) }
            
            if !connectivity.isInternetAvaliable {
                presentNoInternetAlert(sequentials: sequentialsToDownload)
            } else if connectivity.isMobileData {
                if storage.userSettings?.wifiOnly == true {
                    presentWifiRequiredAlert(sequentials: sequentialsToDownload)
                } else {
                    await presentConfirmDownloadCellularAlert(
                        blocks: blocksToDownload,
                        sequentials: sequentialsToDownload,
                        totalFileSize: totalFileSize,
                        action: { [weak self] in
                            guard let self else { return }
                            self.downloadAllButtonState = .cancel
                        }
                    )
                }
            } else {
                if totalFileSize > 100 * 1024 * 1024 {
                    presentConfirmDownloadAlert(
                        blocks: blocksToDownload,
                        sequentials: sequentialsToDownload,
                        totalFileSize: totalFileSize,
                        action: { [weak self] in
                            guard let self else { return }
                            self.downloadAllButtonState = .cancel
                        }
                    )
                } else {
                    try? await self.manager.addToDownloadQueue(blocks: blocksToDownload)
                    self.downloadAllButtonState = .cancel
                }
            }
        }
    }
    
    @MainActor
    func isBlockDownloaded(_ block: CourseBlock) -> Bool {
        courseDownloadTasks.contains { $0.blockId == block.id && $0.state == .finished }
    }
    
    @MainActor
    func stopAllDownloads() async {
        do {
            try await manager.cancelAllDownloading()
            await courseHelper.refreshValue()
        } catch {
            errorMessage = CoreLocalization.Error.unknownError
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
    
    private func getFileSize(at url: URL) -> Int? {
        do {
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: url.path)
            if let fileSize = fileAttributes[.size] as? Int, fileSize > 0 {
                return fileSize
            }
        } catch {
            debugLog("Error getting file size: \(error.localizedDescription)")
        }
        return nil
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
    
    private func isEnoughSpace(for fileSize: Int) -> Bool {
        if let freeSpace = manager.getFreeDiskSpace() {
            return freeSpace > Int(Double(fileSize) * 1.2)
        }
        return false
    }
    
    private func getUsedDiskSpace() -> Int? {
        do {
            let attributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String)
            if let totalSpace = attributes[.systemSize] as? Int64,
                let freeSpace = attributes[.systemFreeSize] as? Int64 {
                return Int(totalSpace - freeSpace)
            }
        } catch {
            print("Error retrieving used disk space: \(error.localizedDescription)")
        }
        return nil
    }
    
    // MARK: Larges Downloads
    @MainActor
    func removeBlock(_ block: CourseBlock) async {
        router.presentView(
            transitionStyle: .coverVertical,
            view: DownloadActionView(
                actionType: .remove,
                courseBlocks: [block],
                downloadedSize: courseHelper.sizeFor(blocks: [block]),
                action: { [weak self] in
                    guard let self else { return }
                    withAnimation(.linear(duration: 0.3)) {
                        self.largestDownloadBlocks.removeAll { $0.id == block.id }
                    }
                    Task {
                        if let courseID = self.courseStructure?.id {
                            await self.manager.delete(blocks: [block], courseId: courseID)
                        }
                    }
                    self.router.dismiss(animated: true)
                },
                cancel: { [weak self] in
                    guard let self else { return }
                    self.router.dismiss(animated: true)
                }
            ),
            completion: {}
        )
    }
    
    @MainActor
    func removeAllBlocks() async {
        let totalSize = courseDownloadTasks.reduce(0, { $0 + $1.actualSize })
        let allBlocks = courseStructure?.childs.flatMap { $0.childs.flatMap { $0.childs.flatMap { $0.childs } } } ?? []
        let blocksToRemove = allBlocks.filter { block in
            if let task = courseDownloadTasks.first(where: { $0.blockId == block.id }) {
                return task.state == .finished
            }
            return false
        }
        
        router.presentView(
            transitionStyle: .coverVertical,
            view: DownloadActionView(
                actionType: .remove,
                courseBlocks: blocksToRemove,
                courseName: courseStructure?.displayName ?? "",
                downloadedSize: totalSize,
                action: { [weak self] in
                    guard let self else { return }
                    Task {
                        await self.stopAllDownloads()
                        if let courseID = self.courseStructure?.id {
                            await self.manager.delete(blocks: blocksToRemove, courseId: courseID)
                        }
                    }
                    self.router.dismiss(animated: true)
                },
                cancel: { [weak self] in
                    guard let self else { return }
                    self.router.dismiss(animated: true)
                }
            ),
            completion: {}
        )
    }
    
    private func update(from value: CourseDownloadValue) {
        downloadableVerticals = value.downloadableVerticals
        downloadAllButtonState = value.state
        courseDownloadTasks = value.courseDownloadTasks
        sequentialsDownloadState = value.sequentialsStates
        withAnimation(.linear(duration: 0.3)) {
            downloadedFilesSize = value.downloadedFilesSize
            totalFilesSize = value.totalFilesSize
            largestDownloadBlocks = value.largestBlocks
        }
    }

    private func initializeExpandedSections() {
        guard let courseStructure = courseStructure else { return }
        
        for chapter in courseStructure.childs {
            let progress = chapterProgress(for: chapter)
            let isNotCompleted = progress < 1.0
            expandedSections[chapter.id] = isNotCompleted
        }
    }
    
    func chapterProgress(for chapter: CourseChapter) -> Double {
        guard !chapter.childs.isEmpty else { return 0.0 }
        
        let totalProgress = chapter.childs.reduce(0.0) { $0 + $1.completion }
        let averageProgress = totalProgress / Double(chapter.childs.count)
        
        return max(0.0, min(1.0, averageProgress))
    }

    private func addObservers() {
        courseHelper
            .publisher()
            .sink {[weak self] value in
                self?.update(from: value)
            }
            .store(in: &cancellables)

        connectivity.internetReachableSubject
            .sink { [weak self] _ in
                guard let self else { return }
                self.isInternetAvaliable = self.connectivity.isInternetAvaliable
            }
            .store(in: &cancellables)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleShiftDueDates),
            name: .shiftCourseDates, object: nil
        )
        
        completionPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] notification in
                guard let self = self else { return }
                updateCourseProgress = true
                if let courseID = notification.object as? String {
                    Task { @MainActor in
                        await self.getCourseBlocks(courseID: courseID, withProgress: false)
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func handleVideoTap(video: CourseBlock, chapter: CourseChapter) {
        // Find indices for navigation using full course structure
        guard let chapterIndex = findChapterIndexInFullStructure(video: video),
              let sequentialIndex = findSequentialIndexInFullStructure(video: video),
              let verticalIndex = findVerticalIndexInFullStructure(video: video),
              let courseStructure = courseStructure else {
            return
        }
        
        // Track video click analytics
        analytics.courseVideoClicked(
            courseId: courseStructure.id,
            courseName: courseStructure.displayName,
            blockId: video.id,
            blockName: video.displayName
        )
        
        router.showCourseUnit(
            courseName: courseStructure.displayName,
            blockId: video.id,
            courseID: courseStructure.id,
            verticalIndex: verticalIndex,
            chapters: courseStructure.childs,
            chapterIndex: chapterIndex,
            sequentialIndex: sequentialIndex
        )
    }
    
    private func findChapterIndexInFullStructure(video: CourseBlock) -> Int? {
        guard let courseStructure = courseStructure else { return nil }
        
        // Find the chapter that contains this video in the full structure
        return courseStructure.childs.firstIndex { fullChapter in
            fullChapter.childs.contains { sequential in
                sequential.childs.contains { vertical in
                    vertical.childs.contains { $0.id == video.id }
                }
            }
        }
    }
    
    private func findSequentialIndexInFullStructure(video: CourseBlock) -> Int? {
        guard let courseStructure = courseStructure else { return nil }
        
        // Find the chapter and sequential that contains this video in the full structure
        for fullChapter in courseStructure.childs {
            if let sequentialIndex = fullChapter.childs.firstIndex(where: { sequential in
                sequential.childs.contains { vertical in
                    vertical.childs.contains { $0.id == video.id }
                }
            }) {
                return sequentialIndex
            }
        }
        return nil
    }
    
    private func findVerticalIndexInFullStructure(video: CourseBlock) -> Int? {
        guard let courseStructure = courseStructure else { return nil }
        
        // Find the vertical that contains this video in the full structure
        for fullChapter in courseStructure.childs {
            for sequential in fullChapter.childs {
                if let verticalIndex = sequential.childs.firstIndex(where: { vertical in
                    vertical.childs.contains { $0.id == video.id }
                }) {
                    return verticalIndex
                }
            }
        }
        return nil
    }

    @MainActor
    func updateVideoProgress(blockID: String, progress: Double) async {
        if let courseStructure = courseStructure {
            let updatedStructure = updateBlockProgress(in: courseStructure, blockID: blockID, progress: progress)
            self.courseStructure = updatedStructure
        }
        
        if let courseStructure = courseStructure {
            let videoStructure = await interactor.getCourseVideoBlocks(fullStructure: courseStructure)
            self.courseVideosStructure = videoStructure
            self.courseAssignmentsStructure = await interactor.getCourseAssignmentBlocks(fullStructure: courseStructure)
            updateAssignmentSections()
        }
        
        objectWillChange.send()
    }
    
    @MainActor
    func updateAssignmentProgress(blockID: String, progress: Double) async {
        if let courseStructure = courseStructure {
            let updatedStructure = updateBlockProgress(in: courseStructure, blockID: blockID, progress: progress)
            self.courseStructure = updatedStructure
        }
        
        if let courseStructure = courseStructure {
            let assignmentStructure = await interactor.getCourseAssignmentBlocks(fullStructure: courseStructure)
            self.courseAssignmentsStructure = assignmentStructure
            self.courseVideosStructure = await interactor.getCourseVideoBlocks(fullStructure: courseStructure)
            updateAssignmentSections()
        }
        
        objectWillChange.send()
    }
    
    private func updateBlockProgress(
        in structure: CourseStructure,
        blockID: String,
        progress: Double
    ) -> CourseStructure {
        var updatedStructure = structure
        
        for (chapterIndex, chapter) in structure.childs.enumerated() {
            for (sequentialIndex, sequential) in chapter.childs.enumerated() {
                for (verticalIndex, vertical) in sequential.childs.enumerated() {
                    for (blockIndex, block) in vertical.childs.enumerated() where block.id == blockID {
                        var updatedBlock = block
                        updatedBlock.localVideoProgress = progress
                        updatedStructure
                            .childs[chapterIndex]
                            .childs[sequentialIndex]
                            .childs[verticalIndex]
                            .childs[blockIndex] = updatedBlock
                        return updatedStructure
                    }
                }
            }
        }
        
        return updatedStructure
    }
    
    func courseProgress() -> CourseProgress? {
        guard let course = courseStructure else { return nil }
        let total = course.childs.count
        guard total > 0 else { return nil }
        let completed = course.childs.filter { chapterProgress(for: $0) >= 1.0 }.count
        return CourseProgress(totalAssignmentsCount: total, assignmentsCompleted: completed)
    }
    
    func assignmentTypeProgress(for assignmentType: String) -> AssignmentProgressData? {
        guard let progressDetails = courseProgressDetails else { return nil }
        
        let subsectionsOfType = progressDetails.sectionScores.flatMap { $0.subsections }
            .filter { $0.assignmentType == assignmentType }
        
        guard !subsectionsOfType.isEmpty else { return nil }
        
        let totalPoints = subsectionsOfType.reduce(0) { $0 + $1.numPointsPossible }
        let earnedPoints = subsectionsOfType.reduce(0) { $0 + $1.numPointsEarned }
        let completed = subsectionsOfType.filter { $0.numPointsEarned >= $0.numPointsPossible }.count
        
        return AssignmentProgressData(
            completed: completed,
            total: subsectionsOfType.count,
            earnedPoints: earnedPoints,
            possiblePoints: totalPoints
        )
    }
    
    func assignmentTypeWeight(for assignmentType: String) -> Double? {
        guard let progressDetails = courseProgressDetails else { return nil }
        
        return progressDetails.gradingPolicy.assignmentPolicies
            .first { $0.type == assignmentType }?
            .weight
    }
    
    func assignmentTypeLabel(for assignmentType: String) -> String? {
        guard let progressDetails = courseProgressDetails else { return nil }
        
        return progressDetails.gradingPolicy.assignmentPolicies
            .first { $0.type == assignmentType }?
            .type
    }
    
    func assignmentTypeColor(for assignmentType: String) -> String? {
        guard let progressDetails = courseProgressDetails else { return nil }
        
        if let index = progressDetails.gradingPolicy.assignmentPolicies
            .firstIndex(where: { $0.type == assignmentType }) {
            let colors = progressDetails.gradingPolicy.assignmentColors
            return index < colors.count ? colors[index] : nil
        }
        return nil
    }
    
    func getSequentialShortLabel(for blockKey: String) -> String? {
        guard let courseStructure = courseAssignmentsStructure ?? courseStructure else { return nil }
        
        for chapter in courseStructure.childs {
            for sequential in chapter.childs {
                if sequential.blockId == blockKey || sequential.id == blockKey {
                    return sequential.sequentialProgress?.shortLabel
                }
            }
        }
        return nil
    }
    
    func getSequentialAssignmentStatus(for blockKey: String) -> AssignmentCardStatus? {
        guard let courseStructure = courseAssignmentsStructure ?? courseStructure else { return nil }
        
        for chapter in courseStructure.childs {
            for sequential in chapter.childs {
                if sequential.blockId == blockKey || sequential.id == blockKey {
                    if sequential.completion >= 1.0 {
                        return .completed
                    }
                    
                    if let due = sequential.due, due < Date() {
                        return .pastDue
                    }
                    
                    return .incomplete
                }
            }
        }
        return nil
    }
    
    private func createUIModels(from subsections: [CourseProgressSubsection]) -> [CourseProgressSubsectionUI] {
        return subsections.map { subsection in
            let shortLabel = getSequentialShortLabel(for: subsection.blockKey) ?? ""
            let status = getSequentialAssignmentStatus(for: subsection.blockKey) ?? getAssignmentStatus(for: subsection)
            let statusText = computeStatusText(for: subsection, status: status, shortLabel: shortLabel)
            let statusTextForCarousel = computeStatusTextForCarousel(
                for: subsection,
                status: status,
                shortLabel: shortLabel
            )
            let sequenceName = getAssignmentSequenceName(for: subsection)

            let date = getAssignmentDueDate(for: subsection)

            return CourseProgressSubsectionUI(
                subsection: subsection,
                statusText: statusText,
                statusTextForCarousel: statusTextForCarousel,
                sequenceName: sequenceName,
                status: status,
                shortLabel: shortLabel,
                date: date
            )
        }
    }
        
    private func updateAssignmentSections() {
        guard let progressDetails = courseProgressDetails else {
            assignmentSectionsData = []
            return
        }
        
        let subsectionsByType = Dictionary(
            grouping: progressDetails.sectionScores.flatMap { $0.subsections }
        ) { subsection in
            subsection.assignmentType ?? "unknown"
        }

        assignmentSectionsData = progressDetails.gradingPolicy.assignmentPolicies.compactMap { policy in
            guard
                let subsections = subsectionsByType[policy.type],
                !subsections.isEmpty
            else { return nil }

            let uiSubsections = createUIModels(from: subsections)

            return AssignmentSection(
                assignmentType: policy.type,
                label: policy.type,
                weight: policy.weight,
                subsections: uiSubsections
            )
        }
                
    }
    
    func assignmentSections() -> [AssignmentSection] {
        return assignmentSectionsData
    }
    
    // MARK: - Assignment Deadline Methods
    
    func getAssignmentDeadline(for subsection: CourseProgressSubsection) -> CourseDateBlock? {
        guard let courseDeadlines = courseDeadlines else { return nil }
        
        // Trying to find deadline by Blockkey or other parameters
        return courseDeadlines.courseDateBlocks.first { dateBlock in
            // Binding by AssignmentType and name
            dateBlock.assignmentType == subsection.assignmentType &&
            dateBlock.firstComponentBlockID.contains(subsection.blockKey)
        }
    }
    
    func getAssignmentStatus(
      for subsection: CourseProgressSubsection
    ) -> AssignmentCardStatus {
      // 1. No access
      guard subsection.learnerHasAccess else {
        return .notAvailable
      }

      // 2. Completed
      if subsection.numPointsEarned >= subsection.numPointsPossible {
        return .completed
      }

      // 3. Past due?
      if isPastDue(subsection) {
        return .pastDue
      }

      // 4. All other cases
      return .incomplete
    }

    // Helper function to check if past due:
    private func isPastDue(
      _ subsection: CourseProgressSubsection
    ) -> Bool {
      guard
        let structure = courseAssignmentsStructure ?? courseStructure
      else {
        return false
      }

      // Flatten all sequentials into one array and find by key
      let allSequentials = structure.childs.flatMap { $0.childs }
      if let seq = allSequentials.first(
        where: { $0.blockId == subsection.blockKey || $0.id == subsection.blockKey }
      ),
         let due = seq.due,
         due < Date() {
        return true
      }

      return false
    }
    
    func getDaysUntilDeadline(for subsection: CourseProgressSubsection) -> Int? {
        guard let courseStructure = courseAssignmentsStructure ?? courseStructure else { return nil }
        
        for chapter in courseStructure.childs {
            for sequential in chapter.childs {
                if sequential.blockId == subsection.blockKey || sequential.id == subsection.blockKey {
                    if let due = sequential.due {
                        let calendar = Calendar.current
                        let now = Date()
                        let components = calendar.dateComponents([.day], from: now, to: due)
                        return components.day
                    }
                    break
                }
            }
        }
        return nil
    }
    
    func getAssignmentDueDate(for subsection: CourseProgressSubsection) -> Date? {
        guard let courseStructure = courseAssignmentsStructure ?? courseStructure else { return nil }
        
        for chapter in courseStructure.childs {
            for sequential in chapter.childs {
                if sequential.blockId == subsection.blockKey || sequential.id == subsection.blockKey {
                    return sequential.due
                }
            }
        }
        return nil
    }
    
    func clearShortLabel(_ text: String) -> String {
        let words = text.split(separator: " ")

        guard let last = words.last, last.allSatisfy(\.isNumber) else {
            let letters = text.filter { !$0.isNumber }
            return String(letters.prefix(3)).uppercased()
        }

        let rightRaw = String(last)
        let leftRaw  = words.dropLast().joined(separator: " ")
        let leftShort = String(leftRaw.filter { !$0.isNumber }.prefix(3)).uppercased()
        let rightClean = String(Int(rightRaw) ?? 0)

        return leftShort + rightClean
    }
    
    private func computeStatusText(
        for subsection: CourseProgressSubsection,
        status: AssignmentCardStatus,
        shortLabel: String?
    ) -> String {
        let cleanShortLabel = clearShortLabel(shortLabel ?? "")
                
        switch status {
        case .completed:
            return CourseLocalization.AssignmentStatus
                .complete(cleanShortLabel, Int(subsection.numPointsEarned), Int(subsection.numPointsPossible))
        case .pastDue:
            return CourseLocalization.AssignmentStatus
                .pastDue(cleanShortLabel, Int(subsection.numPointsEarned), Int(subsection.numPointsPossible))
        case .notAvailable:
            return CourseLocalization.AssignmentStatus.notYetAvailable(cleanShortLabel)
        case .incomplete:
            if let dueDate = getAssignmentDueDate(for: subsection) {
                return "\(cleanShortLabel) \(dueDate.timeAgoDisplay(dueIn: true))"
            } else {
                return CourseLocalization.AssignmentStatus
                    .inProgress(cleanShortLabel, Int(subsection.numPointsEarned), Int(subsection.numPointsPossible))
            }
        }
    }

    private func computeStatusTextForCarousel(
        for subsection: CourseProgressSubsection,
        status: AssignmentCardStatus,
        shortLabel: String?
    ) -> String {
        let cleanShortLabel = clearShortLabel(shortLabel ?? "")

        if let dueDate = getAssignmentDueDate(for: subsection) {
            switch status {
            case .pastDue:
                return "\(cleanShortLabel) \(dueDate.formattedDueStatus())"
            case .incomplete:
                return "\(cleanShortLabel) \(dueDate.formattedDueStatus())"
            default:
                break
            }
        } else {
            return ""
        }

        return ""
    }

    func getAssignmentStatusText(for subsection: CourseProgressSubsection) -> String {
        let status = getAssignmentStatus(for: subsection)
        
        let shortLabel = clearShortLabel(subsection.shortLabel ?? "")
        
        switch status {
        case .completed:
            return CourseLocalization.AssignmentStatus
                .complete(shortLabel, Int(subsection.numPointsEarned), Int(subsection.numPointsPossible))
        case .pastDue:
            return CourseLocalization.AssignmentStatus
                .pastDue(shortLabel, Int(subsection.numPointsEarned), Int(subsection.numPointsPossible))
        case .notAvailable:
            return CourseLocalization.AssignmentStatus.notYetAvailable(shortLabel)
        case .incomplete:
            if let dueDate = getAssignmentDueDate(for: subsection) {
                return "\(shortLabel) \(dueDate.timeAgoDisplay(dueIn: true))"
            } else {
                return CourseLocalization.AssignmentStatus
                    .inProgress(shortLabel, Int(subsection.numPointsEarned), Int(subsection.numPointsPossible))
            }
        }
    }
    
    func getAssignmentSequenceName(for subsection: CourseProgressSubsection) -> String {
        // Trying to find Sequence Name from Course Structure
        guard let courseStructure = courseStructure else {
            return CourseLocalization.Assignment.unknownSequence
        }
        
        // Looking for a block in the structure of the course
        for chapter in courseStructure.childs {
            for sequential in chapter.childs {
                for vertical in sequential.childs where vertical.childs
                    .contains(where: { $0.id == subsection.blockKey }) {
                    return sequential.displayName
                }
            }
        }
        
        return subsection.displayName
    }
    
    func navigateToAssignment(for subsection: CourseProgressSubsection) {
        guard let courseStructure = courseStructure else { return }

        for (chapterIndex, chapter) in courseStructure.childs.enumerated() {
            for (sequentialIndex, sequential) in chapter.childs.enumerated()
                where sequential.id == subsection.blockKey {
                guard let courseVertical = sequential.childs.first else { return }
                guard let firstBlock = courseVertical.childs.first else {
                    router.showGatedContentError(url: courseVertical.webUrl)
                    return
                }

                trackAssignmentClicked(sequential)

                if config.uiComponents.courseDropDownNavigationEnabled {
                    router.showCourseUnit(
                        courseName: courseStructure.displayName,
                        blockId: firstBlock.id,
                        courseID: courseStructure.id,
                        verticalIndex: 0,
                        chapters: courseStructure.childs,
                        chapterIndex: chapterIndex,
                        sequentialIndex: sequentialIndex
                    )
                } else {
                    router.showCourseVerticalView(
                        courseID: courseStructure.id,
                        courseName: courseStructure.displayName,
                        title: sequential.displayName,
                        chapters: courseStructure.childs,
                        chapterIndex: chapterIndex,
                        sequentialIndex: sequentialIndex
                    )
                }
                return
            }
        }
    }
}

extension CourseContainerViewModel {
    @objc private func handleShiftDueDates(_ notification: Notification) {
        if let courseID = notification.object as? String {
            Task {
                await withTaskGroup(of: Void.self) { group in
                    group.addTask {
                        await self.getCourseBlocks(courseID: courseID, withProgress: true)
                    }
                    group.addTask {
                        await self.getCourseDeadlineInfo(courseID: courseID, withProgress: true)
                    }
                    await MainActor.run { [weak self] in
                        self?.dueDatesShifted = true
                    }
                }
            }
        }
    }
    
    func resetDueDatesShiftedFlag() {
        dueDatesShifted = false
    }
}

public struct VerticalsDownloadState: Hashable, Sendable {
    public let vertical: CourseVertical
    public let state: DownloadViewState
    
    public  var downloadableBlocks: [CourseBlock] {
        vertical.childs.filter { $0.isDownloadable && $0.type == .video }
    }
}

#if DEBUG
extension CourseContainerViewModel {
    static var mock: CourseContainerViewModel {
        CourseContainerViewModel(
            interactor: CourseInteractor.mock,
            authInteractor: AuthInteractor.mock,
            router: CourseRouterMock(),
            analytics: CourseAnalyticsMock(),
            config: ConfigMock(),
            connectivity: Connectivity(),
            manager: DownloadManagerMock(),
            storage: CourseStorageMock(),
            isActive: true,
            courseStart: Date(),
            courseEnd: nil,
            enrollmentStart: Date(),
            enrollmentEnd: nil,
            lastVisitedBlockID: nil,
            coreAnalytics: CoreAnalyticsMock(),
            courseHelper: CourseDownloadHelper(courseStructure: nil, manager: DownloadManagerMock())
        )
    }
}
#endif
//swiftlint:enable type_body_length file_length

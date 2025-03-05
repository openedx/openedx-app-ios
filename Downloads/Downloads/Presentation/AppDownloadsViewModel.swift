//
//  AppDownloadsViewModel.swift
//  Downloads
//
//  Created by Ivan Stepanok on 25.02.2025.
//

import Foundation
import Combine
import Core
import SwiftUI

@MainActor
public final class AppDownloadsViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    private var downloadQueue = [String]()
    private var isProcessingQueue = false
    
    @Published var courses: [DownloadCoursePreview] = []
    @Published var downloadedSizes: [String: Int64] = [:]
    @Published var downloadStates: [String: DownloadState] = [:]
    @Published var showError: Bool = false
    @Published private(set) var fetchInProgress = false
    
    private var courseTasks: [String: [DownloadDataTask]] = [:]
    private var courseSizes: [String: Int64] = [:]
    private var finishedTaskIds: Set<String> = []
    private var waitingDownloads: [CourseBlock]?
    
    var errorMessage: String? {
        didSet {
            withAnimation {
                showError = errorMessage != nil
            }
        }
    }
    
    let connectivity: ConnectivityProtocol
    private let downloadsInteractor: DownloadsInteractorProtocol
    private let courseManager: CourseStructureManagerProtocol
    private let downloadManager: DownloadManagerProtocol
    private let downloadsHelper: DownloadsHelperProtocol
    let router: DownloadsRouter
    private let storage: DownloadsStorage
    private let analytics: DownloadsAnalytics
    
    public init(
        interactor: DownloadsInteractorProtocol,
        courseManager: CourseStructureManagerProtocol,
        downloadManager: DownloadManagerProtocol,
        connectivity: ConnectivityProtocol,
        downloadsHelper: DownloadsHelperProtocol,
        router: DownloadsRouter,
        storage: DownloadsStorage,
        analytics: DownloadsAnalytics
    ) {
        self.downloadsInteractor = interactor
        self.courseManager = courseManager
        self.downloadManager = downloadManager
        self.connectivity = connectivity
        self.downloadsHelper = downloadsHelper
        self.router = router
        self.storage = storage
        self.analytics = analytics
        self.observeDownloadEvents()
    }
    
    private func observeDownloadEvents() {
        downloadManager.eventPublisher()
            .receive(on: RunLoop.main)
            .sink { [weak self] event in
                guard let self = self else { return }
                Task {
                    switch event {
                    case .progress(let task):
                        await self.updateDownloadProgress(for: task)
                    case .finished(let task):
                        await self.updateDownloadProgress(for: task)
                    case .started(let task):
                        await self.updateDownloadProgress(for: task)
                    case .canceled, .courseCanceled, .allCanceled:
                        await self.refreshDownloadStates()
                    default:
                        break
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    private func updateDownloadProgress(for task: DownloadDataTask) async {
        let courseID = task.courseId
        let (downloaded, total) = await downloadsHelper.calculateDownloadProgress(courseID: courseID)
        let isFullyDownloaded = await downloadsHelper.isFullyDownloaded(courseID: courseID)
        
        await MainActor.run {
            downloadedSizes[courseID] = Int64(downloaded)
            courseSizes[courseID] = Int64(total)
            
            if isFullyDownloaded {
                let previousState = downloadStates[courseID]
                downloadStates[courseID] = .finished
                
                // If the state changed from in progress to finished, track download completion
                if previousState == .inProgress {
                    let course = courses.first(where: { $0.id == courseID })
                    let courseName = course?.name ?? ""
                    analytics.downloadCompleted(courseId: courseID, courseName: courseName, downloadSize: Int64(total))
                }
            } else if task.state == .inProgress {
                downloadStates[courseID] = .inProgress
            }
        }
    }
    
    private func refreshDownloadStates() async {
        for course in courses {
            let (downloaded, total) = await downloadsHelper.calculateDownloadProgress(courseID: course.id)
            let isDownloading = await downloadsHelper.isDownloading(courseID: course.id)
            let isPartiallyDownloaded = await downloadsHelper.isPartiallyDownloaded(courseID: course.id)
            let isFullyDownloaded = await downloadsHelper.isFullyDownloaded(courseID: course.id)
            
            await MainActor.run {
                downloadedSizes[course.id] = Int64(downloaded)
                courseSizes[course.id] = Int64(total)
                
                if isDownloading {
                    downloadStates[course.id] = .inProgress
                } else if isFullyDownloaded {
                    downloadStates[course.id] = .finished
                } else if isPartiallyDownloaded {
                    downloadStates[course.id] = .finished
                } else {
                    downloadStates[course.id] = nil
                }
            }
        }
    }
    
    @MainActor
    func getDownloadCourses(isRefresh: Bool = false) async {
        fetchInProgress = !isRefresh
        do {
            if connectivity.isInternetAvaliable {
                courses = try await downloadsInteractor.getDownloadCourses()
                fetchInProgress = false
                await refreshDownloadStates()
                analytics.downloadsScreenViewed()
            } else {
                courses = try await downloadsInteractor.getDownloadCoursesOffline()
                fetchInProgress = false
                await refreshDownloadStates()
                analytics.downloadsScreenViewed()
            }
        } catch let error {
            if error.isInternetError || error is NoCachedDataError {
                errorMessage = CoreLocalization.Error.slowOrNoInternetConnection
            } else {
                errorMessage = CoreLocalization.Error.unknownError
            }
        }
    }
    
    func downloadCourse(courseID: String) {
        Task {
            do {
                let course = courses.first(where: { $0.id == courseID })
                let courseName = course?.name ?? ""
                
                analytics.downloadCourseClicked(courseId: courseID, courseName: courseName)
                
                let courseStructure: CourseStructure
                do {
                    // First try to get course structure from cached data
                    courseStructure = try await courseManager.getLoadedCourseBlocks(courseID: courseID)
                } catch let error as NoCachedDataError {
                    // Set loading state before fetching course structure
                    await MainActor.run {
                        downloadStates[courseID] = .loadingStructure
                    }
                    // If no cached data, fetch from network
                    courseStructure = try await courseManager.getCourseBlocks(courseID: courseID)
                }
                
                // Reset state if we're not proceeding with download
                await MainActor.run {
                    downloadStates[courseID] = nil
                }
                
                let downloadableBlocks = courseStructure.childs.flatMap { chapter in
                    chapter.childs.flatMap { sequential in
                        sequential.childs.flatMap { vertical in
                            vertical.childs.filter { $0.isDownloadable }
                        }
                    }
                }
                
                if await isShowedAllowLargeDownloadAlert(blocks: downloadableBlocks) {
                    return
                }
                
                if !connectivity.isInternetAvaliable {
                    presentNoInternetAlert(sequentials: courseStructure.childs.flatMap { $0.childs })
                    analytics.downloadError(courseId: courseID, courseName: courseName, errorType: "no_internet")
                    return
                }
                
                let totalFileSize = downloadableBlocks.reduce(0) { $0 + ($1.fileSize ?? 0) }
                
                if connectivity.isMobileData {
                    // Check if wifi only setting is enabled
                    if storage.userSettings?.wifiOnly == true {
                        presentWifiRequiredAlert(sequentials: courseStructure.childs.flatMap { $0.childs })
                        analytics.downloadError(courseId: courseID, courseName: courseName, errorType: "wifi_required")
                        return
                    } else {
                        await presentConfirmDownloadCellularAlert(
                            blocks: downloadableBlocks,
                            sequentials: courseStructure.childs.flatMap { $0.childs },
                            totalFileSize: totalFileSize
                        )
                        return
                    }
                } else if totalFileSize > 100 * 1024 * 1024 {
                    // For large downloads over WiFi, show confirmation
                    await presentConfirmDownloadAlert(
                        blocks: downloadableBlocks,
                        sequentials: courseStructure.childs.flatMap { $0.childs },
                        totalFileSize: totalFileSize
                    )
                    return
                }
                
                // For direct download (no confirmation needed), set the state before starting
                await MainActor.run {
                    downloadStates[courseID] = .inProgress
                }
                
                try await downloadManager.addToDownloadQueue(blocks: downloadableBlocks)
                analytics.downloadStarted(
                    courseId: courseID,
                    courseName: courseName,
                    downloadSize: Int64(totalFileSize)
                )
                await refreshDownloadStates()
            } catch {
                let course = courses.first(where: { $0.id == courseID })
                let courseName = course?.name ?? ""
                
                if error is NoWiFiError {
                    errorMessage = CoreLocalization.Error.wifi
                    analytics.downloadError(courseId: courseID, courseName: courseName, errorType: "wifi_required")
                } else if error.isInternetError {
                    errorMessage = CoreLocalization.Error.slowOrNoInternetConnection
                    analytics.downloadError(courseId: courseID, courseName: courseName, errorType: "no_internet")
                } else {
                    errorMessage = CoreLocalization.Error.unknownError
                    analytics.downloadError(courseId: courseID, courseName: courseName, errorType: "unknown")
                }
            }
        }
    }
    
    func cancelDownload(courseID: String) {
        Task {
            let course = courses.first(where: { $0.id == courseID })
            let courseName = course?.name ?? ""
            
            analytics.cancelDownloadClicked(courseId: courseID, courseName: courseName)
            
            // Check if we're loading the course structure
            await MainActor.run {
                if downloadStates[courseID] == .loadingStructure {
                    downloadStates[courseID] = nil
                    return
                }
            }
            
            if let currentTask = await downloadManager.getCurrentDownloadTask(),
               currentTask.courseId == courseID {
                try? await downloadManager.cancelDownloading(task: currentTask)
            }
            
            let tasks = await downloadManager.getDownloadTasksForCourse(courseID)
            let inProgressTasks = tasks.filter { $0.state == .inProgress || $0.state == .waiting }
            
            for task in inProgressTasks {
                try? await downloadManager.cancelDownloading(task: task)
            }
            
            analytics.downloadCancelled(courseId: courseID, courseName: courseName)
            await refreshDownloadStates()
        }
    }
    
    func removeDownload(courseID: String) {
        Task {
            let course = courses.first(where: { $0.id == courseID })
            let courseName = course?.name ?? ""
            
            analytics.removeDownloadClicked(courseId: courseID, courseName: courseName)
            
            if let courseStructure = try? await courseManager.getLoadedCourseBlocks(courseID: courseID) {
                let blocks = courseStructure.childs.flatMap { chapter in
                    chapter.childs.flatMap { sequential in
                        sequential.childs.flatMap { vertical in
                            vertical.childs.filter { $0.isDownloadable }
                        }
                    }
                }
                
                await presentRemoveDownloadAlert(
                    blocks: blocks,
                    sequentials: courseStructure.childs.flatMap { $0.childs },
                    courseID: courseID
                )
            }
        }
    }
    
    // MARK: - Alert Presentation Methods
    
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
        // Get the course ID from the blocks
        let courseID = blocks.first?.courseId ?? ""
        // Find the course in the courses array
        let course = courses.first(where: { $0.id == courseID })
        let courseName = course?.name ?? ""
        
        // Use the course's totalSize property directly
        let sizeToDisplay = course?.totalSize ?? Int64(totalFileSize)
        
        router.presentView(
            transitionStyle: .coverVertical,
            view: DownloadActionView(
                actionType: .confirmDownloadCellular,
                sequentials: sequentials,
                downloadedSize: Int(sizeToDisplay),
                action: { [weak self] in
                    guard let self else { return }
                    if !self.isEnoughSpace(for: totalFileSize) {
                        self.presentStorageFullAlert(sequentials: sequentials)
                        self.analytics.downloadError(
                            courseId: courseID,
                            courseName: courseName,
                            errorType: "storage_full"
                        )
                    } else {
                        Task {
                            await MainActor.run {
                                self.downloadStates[courseID] = .inProgress
                            }
                            try? await self.downloadManager.addToDownloadQueue(blocks: blocks)
                            self.analytics.downloadConfirmed(
                                courseId: courseID,
                                courseName: courseName,
                                downloadSize: sizeToDisplay
                            )
                        }
                        action()
                    }
                    self.router.dismiss(animated: true)
                },
                cancel: { [weak self] in
                    guard let self else { return }
                    self.analytics.downloadCancelled(courseId: courseID, courseName: courseName)
                    self.router.dismiss(animated: true)
                }
            ),
            completion: {
            }
        )
    }
    
    private func presentStorageFullAlert(sequentials: [CourseSequential]) {
        router.presentView(
            transitionStyle: .coverVertical,
            view: DeviceStorageFullAlertView(
                sequentials: sequentials,
                usedSpace: getUsedDiskSpace() ?? 0,
                freeSpace: getFreeDiskSpace() ?? 0,
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
    ) async {
        let courseID = blocks.first?.courseId ?? ""
        let course = courses.first(where: { $0.id == courseID })
        let courseName = course?.name ?? ""
        let sizeToDisplay = course?.totalSize ?? Int64(totalFileSize)
        
        router.presentView(
            transitionStyle: .coverVertical,
            view: DownloadActionView(
                actionType: .confirmDownload,
                sequentials: sequentials,
                downloadedSize: Int(sizeToDisplay),
                action: { [weak self] in
                    guard let self else { return }
                    if !self.isEnoughSpace(for: totalFileSize) {
                        self.router.dismiss(animated: true)
                        self.presentStorageFullAlert(sequentials: sequentials)
                        self.analytics
                            .downloadError(
                                courseId: courseID,
                                courseName: courseName,
                                errorType: "storage_full"
                            )
                    } else {
                        Task {
                            await MainActor.run {
                                self.downloadStates[courseID] = .inProgress
                            }
                            try? await self.downloadManager.addToDownloadQueue(blocks: blocks)
                            self.analytics.downloadConfirmed(
                                courseId: courseID,
                                courseName: courseName,
                                downloadSize: sizeToDisplay
                            )
                        }
                        action()
                    }
                    self.router.dismiss(animated: true)
                },
                cancel: { [weak self] in
                    guard let self else { return }
                    self.analytics.downloadCancelled(courseId: courseID, courseName: courseName)
                    self.router.dismiss(animated: true)
                }
            ),
            completion: {
            }
        )
    }
    
    private func presentRemoveDownloadAlert(
        blocks: [CourseBlock],
        sequentials: [CourseSequential],
        courseID: String
    ) async {
        let downloadedSize = downloadedSizes[courseID] ?? 0
        let course = courses.first(where: { $0.id == courseID })
        let courseName = course?.name ?? ""
        
        router.presentView(
            transitionStyle: .coverVertical,
            view: DownloadActionView(
                actionType: .remove,
                sequentials: sequentials,
                downloadedSize: Int(downloadedSize),
                action: { [weak self] in
                    guard let self else { return }
                    Task {
                        await self.downloadManager.delete(blocks: blocks, courseId: courseID)
                        await MainActor.run {
                            self.downloadStates[courseID] = nil
                            self.downloadedSizes[courseID] = 0
                        }
                        
                        self.analytics.downloadRemoved(
                            courseId: courseID,
                            courseName: courseName,
                            downloadSize: downloadedSize
                        )
                        
                        await self.refreshDownloadStates()
                        await self.getDownloadCourses(isRefresh: true)
                        
                        self.router.dismiss(animated: true)
                    }
                },
                cancel: { [weak self] in
                    guard let self else { return }
                    self.router.dismiss(animated: true)
                }
            ),
            completion: {
            }
        )
    }
    
    @MainActor
    func isShowedAllowLargeDownloadAlert(blocks: [CourseBlock]) async -> Bool {
        waitingDownloads = nil
        if storage.allowedDownloadLargeFile == false, await downloadManager.isLargeVideosSize(blocks: blocks) {
            waitingDownloads = blocks
            router.presentAlert(
                alertTitle: CoreLocalization.Download.download,
                alertMessage: CoreLocalization.Download.downloadLargeFileMessage,
                positiveAction: CoreLocalization.Alert.accept,
                onCloseTapped: {
                    self.router.dismiss(animated: true)
                },
                okTapped: {
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
    
    func continueDownload() async {
        guard let blocks = waitingDownloads else {
            return
        }
        do {
            let courseID = blocks.first?.courseId ?? ""
            
            await MainActor.run {
                downloadStates[courseID] = .inProgress
            }
            
            try await downloadManager.addToDownloadQueue(blocks: blocks)
        } catch let error {
            if error is NoWiFiError {
                errorMessage = CoreLocalization.Error.wifi
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func isEnoughSpace(for fileSize: Int) -> Bool {
        if let freeSpace = getFreeDiskSpace() {
            return freeSpace > Int(Double(fileSize) * 1.2)
        }
        return false
    }
    
    private func getFreeDiskSpace() -> Int? {
        do {
            let attributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String)
            if let freeSpace = attributes[.systemFreeSize] as? Int64 {
                return Int(freeSpace)
            }
        } catch {
            print("Error retrieving free disk space: \(error.localizedDescription)")
        }
        return nil
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
    
    private func calculateDownloadSize(sequentials: [CourseSequential]) async -> (downloaded: Int, total: Int) {
        let courseIDs = sequentials.compactMap { $0.id }.unique()
        var downloadedSize = 0
        var totalSize = 0
        
        for courseID in courseIDs {
            let (downloaded, total) = await downloadsHelper.calculateDownloadProgress(courseID: courseID)
            downloadedSize += downloaded
            totalSize += total
        }
        
        return (downloadedSize, totalSize)
    }
}

// Mark - For testing and SwiftUI preview
#if DEBUG
public extension AppDownloadsViewModel {
    static let mock = AppDownloadsViewModel(
        interactor: DownloadsInteractor.mock,
        courseManager: CourseStructureManagerMock(),
        downloadManager: DownloadManagerMock(),
        connectivity: Connectivity(),
        downloadsHelper: DownloadsHelperMock(),
        router: DownloadsRouterMock(),
        storage: DownloadsStorageMock(),
        analytics: DownloadsAnalyticsMock()
    )
}
#endif

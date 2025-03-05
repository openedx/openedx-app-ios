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
    private var waitingDownloads: [CourseBlock]?
    private let cellularFileSizeLimit: Int = 100 * 1024 * 1024
    
    @Published var courses: [DownloadCoursePreview] = []
    @Published var downloadedSizes: [String: Int64] = [:]
    @Published var downloadStates: [String: DownloadState] = [:]
    @Published var showError: Bool = false
    @Published private(set) var fetchInProgress = false
    
    private var courseTasks: [String: [DownloadDataTask]] = [:]
    private var courseSizes: [String: Int64] = [:]
    private var finishedTaskIds: Set<String> = []
    
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
    private let storage: CoreStorage
    
    public init(
        interactor: DownloadsInteractorProtocol,
        courseManager: CourseStructureManagerProtocol,
        downloadManager: DownloadManagerProtocol,
        connectivity: ConnectivityProtocol,
        downloadsHelper: DownloadsHelperProtocol,
        router: DownloadsRouter,
        storage: CoreStorage
    ) {
        self.downloadsInteractor = interactor
        self.courseManager = courseManager
        self.downloadManager = downloadManager
        self.connectivity = connectivity
        self.downloadsHelper = downloadsHelper
        self.router = router
        self.storage = storage
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
                downloadStates[courseID] = .finished
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
            } else {
                courses = try await downloadsInteractor.getDownloadCoursesOffline()
                fetchInProgress = false
                await refreshDownloadStates()
            }
        } catch let error {
            if error.isInternetError || error is NoCachedDataError {
                errorMessage = DownloadsLocalization.Downloads.Error.slowOrNoInternetConnection
            } else {
                errorMessage = DownloadsLocalization.Downloads.Error.unknownError
            }
        }
    }
    
    func downloadCourse(courseID: String) {
        Task {
            do {
                await MainActor.run {
                    downloadStates[courseID] = .inProgress
                }
                
                let courseStructure: CourseStructure
                do {
                    // First try to get course structure from cached data
                    courseStructure = try await courseManager.getLoadedCourseBlocks(courseID: courseID)
                } catch let error as NoCachedDataError {
                    // If no cached data, fetch from network
                    courseStructure = try await courseManager.getCourseBlocks(courseID: courseID)
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
                
                let totalFileSize = downloadableBlocks.reduce(0) { $0 + ($1.fileSize ?? 0) }
                
                if !connectivity.isInternetAvaliable {
                    presentNoInternetAlert(courseName: courseStructure.displayName)
                    return
                } else if connectivity.isMobileData {
                    if storage.userSettings?.wifiOnly == true {
                        presentWifiRequiredAlert(courseName: courseStructure.displayName)
                        return
                    } else if totalFileSize > cellularFileSizeLimit {
                        await presentConfirmDownloadCellularAlert(
                            blocks: downloadableBlocks,
                            courseName: courseStructure.displayName,
                            totalFileSize: totalFileSize
                        )
                        return
                    }
                } else if totalFileSize > cellularFileSizeLimit {
                    await presentConfirmDownloadAlert(
                        blocks: downloadableBlocks,
                        courseName: courseStructure.displayName,
                        totalFileSize: totalFileSize
                    )
                    return
                }
                
                try await downloadManager.addToDownloadQueue(blocks: downloadableBlocks)
                await refreshDownloadStates()
            } catch {
                if error is NoWiFiError {
                    errorMessage = DownloadsLocalization.Downloads.Error.wifi
                } else if error.isInternetError {
                    errorMessage = DownloadsLocalization.Downloads.Error.slowOrNoInternetConnection
                } else {
                    errorMessage = DownloadsLocalization.Downloads.Error.unknownError
                }
            }
        }
    }
    
    func cancelDownload(courseID: String) {
        Task {
            if let currentTask = await downloadManager.getCurrentDownloadTask(),
               currentTask.courseId == courseID {
                try? await downloadManager.cancelDownloading(task: currentTask)
            }
            
            let tasks = await downloadManager.getDownloadTasksForCourse(courseID)
            let inProgressTasks = tasks.filter { $0.state == .inProgress || $0.state == .waiting }
            
            for task in inProgressTasks {
                try? await downloadManager.cancelDownloading(task: task)
            }
            
            await refreshDownloadStates()
        }
    }
    
    func removeDownload(courseID: String) {
        Task {
            do {
                let courseStructure = try await courseManager.getLoadedCourseBlocks(courseID: courseID)
                let blocks = courseStructure.childs.flatMap { chapter in
                    chapter.childs.flatMap { sequential in
                        sequential.childs.flatMap { vertical in
                            vertical.childs.filter { $0.isDownloadable }
                        }
                    }
                }
                
                await presentRemoveDownloadAlert(
                    blocks: blocks,
                    courseName: courseStructure.displayName,
                    courseID: courseID
                )
            } catch {
                // If we can't get the course structure, just try to remove by courseID
                let tasks = await downloadManager.getDownloadTasksForCourse(courseID)
                if !tasks.isEmpty {
                    let blocks = tasks.compactMap { task -> CourseBlock? in
                        CourseBlock(
                            blockId: task.blockId,
                            id: task.id,
                            courseId: task.courseId,
                            graded: false,
                            due: nil,
                            completion: 0,
                            type: .unknown,
                            displayName: task.displayName,
                            studentUrl: "",
                            webUrl: "",
                            encodedVideo: nil,
                            multiDevice: nil,
                            offlineDownload: nil
                        )
                    }
                    
                    await presentRemoveDownloadAlert(
                        blocks: blocks,
                        courseName: courses.first(where: { $0.id == courseID })?.name ?? "",
                        courseID: courseID
                    )
                }
            }
        }
    }
    
    // MARK: - Download Alert Methods
    
    private func presentNoInternetAlert(courseName: String) {
        router.presentAlert(
            alertTitle: DownloadsLocalization.Downloads.Error.noInternetConnectionTitle,
            alertMessage: DownloadsLocalization.Downloads.Error.noInternetConnectionDescription,
            positiveAction: DownloadsLocalization.Downloads.Alert.ok,
            onCloseTapped: { [weak self] in
                self?.router.dismiss(animated: true)
            },
            okTapped: { [weak self] in
                self?.router.dismiss(animated: true)
            },
            type: .default(positiveAction: DownloadsLocalization.Downloads.Alert.ok, image: nil)
        )
    }
    
    private func presentWifiRequiredAlert(courseName: String) {
        router.presentAlert(
            alertTitle: DownloadsLocalization.Downloads.Error.wifiRequiredTitle,
            alertMessage: DownloadsLocalization.Downloads.Error.wifiRequiredDescription,
            positiveAction: DownloadsLocalization.Downloads.Alert.ok,
            onCloseTapped: { [weak self] in
                self?.router.dismiss(animated: true)
            },
            okTapped: { [weak self] in
                self?.router.dismiss(animated: true)
            },
            type: .default(positiveAction: DownloadsLocalization.Downloads.Alert.ok, image: nil)
        )
    }
    
    @MainActor
    private func presentConfirmDownloadCellularAlert(
        blocks: [CourseBlock],
        courseName: String,
        totalFileSize: Int
    ) async {
        router.presentAlert(
            alertTitle: DownloadsLocalization.Downloads.Alert.confirmDownloadCellularTitle,
            alertMessage: DownloadsLocalization.Downloads.Alert
                .confirmDownloadCellularDescription(totalFileSize.formattedFileSize()),
            positiveAction: DownloadsLocalization.Downloads.Alert.download,
            onCloseTapped: { [weak self] in
                self?.router.dismiss(animated: true)
            },
            okTapped: { [weak self] in
                guard let self = self else { return }
                if !self.isEnoughSpace(for: totalFileSize) {
                    self.router.dismiss(animated: true)
                    self.presentStorageFullAlert(courseName: courseName)
                } else {
                    Task {
                        try? await self.downloadManager.addToDownloadQueue(blocks: blocks)
                    }
                }
                self.router.dismiss(animated: true)
            },
            type: .default(positiveAction: DownloadsLocalization.Downloads.Alert.download, image: nil)
        )
    }
    
    private func presentStorageFullAlert(courseName: String) {
        router.presentAlert(
            alertTitle: DownloadsLocalization.Downloads.Alert.storageAlertTitle,
            alertMessage: DownloadsLocalization.Downloads.Alert.storageAlertDescription,
            positiveAction: DownloadsLocalization.Downloads.Alert.ok,
            onCloseTapped: { [weak self] in
                self?.router.dismiss(animated: true)
            },
            okTapped: { [weak self] in
                self?.router.dismiss(animated: true)
            },
            type: .default(positiveAction: DownloadsLocalization.Downloads.Alert.ok, image: nil)
        )
    }
    
    @MainActor
    private func presentConfirmDownloadAlert(
        blocks: [CourseBlock],
        courseName: String,
        totalFileSize: Int
    ) async {
        router.presentAlert(
            alertTitle: DownloadsLocalization.Downloads.Alert.confirmDownloadTitle,
            alertMessage: DownloadsLocalization.Downloads.Alert
                .confirmDownloadDescription(totalFileSize.formattedFileSize()),
            positiveAction: DownloadsLocalization.Downloads.Alert.download,
            onCloseTapped: { [weak self] in
                self?.router.dismiss(animated: true)
            },
            okTapped: { [weak self] in
                guard let self = self else { return }
                if !self.isEnoughSpace(for: totalFileSize) {
                    self.router.dismiss(animated: true)
                    self.presentStorageFullAlert(courseName: courseName)
                } else {
                    Task {
                        try? await self.downloadManager.addToDownloadQueue(blocks: blocks)
                    }
                }
                self.router.dismiss(animated: true)
            },
            type: .default(positiveAction: DownloadsLocalization.Downloads.Alert.download, image: nil)
        )
    }
    
    @MainActor
    private func presentRemoveDownloadAlert(
        blocks: [CourseBlock],
        courseName: String,
        courseID: String
    ) async {
        let downloadedSize = await calculateDownloadedSize(blocks: blocks)
        
        router.presentAlert(
            alertTitle: DownloadsLocalization.Downloads.Alert.removeTitle,
            alertMessage: DownloadsLocalization.Downloads.Alert.removeDescription(downloadedSize.formattedFileSize()),
            positiveAction: DownloadsLocalization.Downloads.Alert.remove,
            onCloseTapped: { [weak self] in
                self?.router.dismiss(animated: true)
            },
            okTapped: { [weak self] in
                guard let self = self else { return }
                Task {
                    await self.downloadManager.delete(blocks: blocks, courseId: courseID)
                    await self.refreshDownloadStates()
                }
                self.router.dismiss(animated: true)
            },
            type: .default(positiveAction: DownloadsLocalization.Downloads.Alert.remove, image: nil)
        )
    }
    
    @MainActor
    func isShowedAllowLargeDownloadAlert(blocks: [CourseBlock]) async -> Bool {
        waitingDownloads = nil
        if storage.userSettings?.wifiOnly == true, await downloadManager.isLargeVideosSize(blocks: blocks) {
            waitingDownloads = blocks
            router.presentAlert(
                alertTitle: DownloadsLocalization.Downloads.Alert.download,
                alertMessage: DownloadsLocalization.Downloads.Alert.downloadLargeFileMessage,
                positiveAction: DownloadsLocalization.Downloads.Alert.accept,
                onCloseTapped: { [weak self] in
                    self?.router.dismiss(animated: true)
                },
                okTapped: { [weak self] in
                    guard let self = self else { return }
                    Task {
                        await self.continueDownload()
                    }
                    self.router.dismiss(animated: true)
                },
                type: .default(positiveAction: DownloadsLocalization.Downloads.Alert.accept, image: nil)
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
            try await downloadManager.addToDownloadQueue(blocks: blocks)
        } catch let error {
            if error is NoWiFiError {
                errorMessage = DownloadsLocalization.Downloads.Error.wifi
            }
        }
    }
    
    // MARK: - Storage Helper Methods
    
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
    
    private func calculateDownloadedSize(blocks: [CourseBlock]) async -> Int {
        var totalSize = 0
        for block in blocks {
            if let task = await downloadManager.downloadTask(for: block.id), task.state == .finished {
                totalSize += task.actualSize
            }
        }
        return totalSize
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
        storage: CoreStorageMock()
    )
}
#endif

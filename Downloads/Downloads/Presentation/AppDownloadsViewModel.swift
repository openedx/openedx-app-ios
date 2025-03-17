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
// swiftlint:disable type_body_length file_length
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
    private var courseStructureCache: [String: CourseStructure] = [:]
    private var structureLoadingTasks: [String: Task<Void, Never>] = [:]
    
    private let requiredFreeSpaceMultiplier: Double = 1.2
    
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
        
        let enrollmentPublisher = NotificationCenter.default.publisher(for: .onCourseEnrolled)
        
        enrollmentPublisher
            .sink { [weak self] _ in
                guard let self = self else { return }
                Task {
                    await self.getDownloadCourses(isRefresh: true)
                }
            }
            .store(in: &cancellables)
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
        let (downloaded, total) = await calculateAccurateDownloadProgress(courseID: courseID)
        let isFullyDownloaded = await downloadsHelper.isFullyDownloaded(courseID: courseID)
        let isDownloading = await downloadsHelper.isDownloading(courseID: courseID)
        
        downloadedSizes[courseID] = Int64(downloaded)
        courseSizes[courseID] = Int64(total)
        
        // Only set to .finished if it's fully downloaded
        if isFullyDownloaded && downloaded >= total * 95 / 100 {
            let previousState = downloadStates[courseID]
            downloadStates[courseID] = .finished
            
            // Track download completion when a task is finished
            if previousState == .inProgress || task.state == .finished {
                let course = courses.first(where: { $0.id == courseID })
                let courseName = course?.name ?? ""
                analytics.downloadCompleted(courseId: courseID, courseName: courseName, downloadSize: Int64(total))
            }
        } else if isDownloading {
            downloadStates[courseID] = .inProgress
        } else {
            // If not fully downloaded and not downloading, set to nil
            // This will allow the DownloadCourseCell to show the "Download Course" button
            // for partially downloaded courses based on the downloadedSize value
            downloadStates[courseID] = nil
        }
    }
    
    private func refreshDownloadStates() async {
        for course in courses {
            // Skip courses that are currently loading structure
            if structureLoadingTasks[course.id] != nil && downloadStates[course.id] == .loadingStructure {
                continue
            }
            
            let (downloaded, total) = await calculateAccurateDownloadProgress(courseID: course.id)
            let isDownloading = await downloadsHelper.isDownloading(courseID: course.id)
            let isFullyDownloaded = await downloadsHelper.isFullyDownloaded(courseID: course.id)
            
            downloadedSizes[course.id] = Int64(downloaded)
            courseSizes[course.id] = Int64(total)
            
            if isDownloading {
                downloadStates[course.id] = .inProgress
            } else if isFullyDownloaded && downloaded >= total * 95 / 100 {
                // Only set to .finished if it's fully downloaded (at least 95%)
                downloadStates[course.id] = .finished
            } else {
                // Set to nil for both not downloaded and partially downloaded
                // This allows the DownloadCourseCell to show the "Download Course" button
                // for partially downloaded courses based on the downloadedSize value
                downloadStates[course.id] = nil
            }
        }
    }
    
    private func calculateAccurateDownloadProgress(courseID: String) async -> (downloaded: Int, total: Int) {
        let (downloaded, _) = await downloadsHelper.calculateDownloadProgress(courseID: courseID)
        
        if let courseStructure = await getCourseStructureIfAvailable(courseID: courseID) {
            let totalSize = calculateTotalSizeFromStructure(courseStructure: courseStructure)
            return (downloaded, totalSize)
        } else {
            let (_, total) = await downloadsHelper.calculateDownloadProgress(courseID: courseID)
            let course = courses.first(where: { $0.id == courseID })
            return (downloaded, course?.totalSize != 0 ? Int(course?.totalSize ?? 0) : total)
        }
    }
    
    private func getCourseStructureIfAvailable(courseID: String) async -> CourseStructure? {
        if let cachedStructure = courseStructureCache[courseID] {
            return cachedStructure
        }
        
        do {
            let structure = try await courseManager.getLoadedCourseBlocks(courseID: courseID)
            courseStructureCache[courseID] = structure
            return structure
        } catch {
            return nil
        }
    }
    
    private func calculateTotalSizeFromStructure(courseStructure: CourseStructure) -> Int {
        let downloadableBlocks = courseStructure.childs.flatMap { chapter in
            chapter.childs.flatMap { sequential in
                sequential.childs.flatMap { vertical in
                    vertical.childs.filter { $0.isDownloadable }
                }
            }
        }
        
        return downloadableBlocks.reduce(0) { $0 + ($1.fileSize ?? 0) }
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
    
    func downloadCourse(courseID: String) async {
        let course = courses.first(where: { $0.id == courseID })
        let courseName = course?.name ?? ""
        analytics.downloadCourseClicked(courseId: courseID, courseName: courseName)
        
        // Get the total size of the course from our existing data
        let totalFileSize = Int(course?.totalSize ?? 0)
        
        if !connectivity.isInternetAvaliable {
            // No need to fetch structure just to show error, show it immediately
            let sequentials = await fetchCourseSequentialsIfAvailable(courseID: courseID)
            presentNoInternetAlert(sequentials: sequentials)
            analytics
                .downloadError(
                    courseId: courseID,
                    courseName: courseName,
                    errorType: AnalyticsError.noInternet.rawValue
                )
            return
        }
        
        if connectivity.isMobileData {
            if storage.userSettings?.wifiOnly == true {
                let sequentials = await fetchCourseSequentialsIfAvailable(courseID: courseID)
                presentWifiRequiredAlert(sequentials: sequentials)
                analytics
                    .downloadError(
                        courseId: courseID,
                        courseName: courseName,
                        errorType: AnalyticsError.wifiRequired.rawValue
                    )
                return
            } else {
                // Show cellular download confirmation with the size we already know
                let sequentials = await fetchCourseSequentialsIfAvailable(courseID: courseID)
                presentConfirmDownloadCellularAlert(
                    courseID: courseID,
                    blocks: [],
                    sequentials: sequentials,
                    totalFileSize: totalFileSize,
                    action: {
                        // After confirmation, fetch structure and download
                        Task {
                            await self.fetchStructureAndDownload(courseID: courseID)
                        }
                    }
                )
                return
            }
        } else if totalFileSize > 100 * 1024 * 1024 {
            // Show large download confirmation with the size we already know
            let sequentials = await fetchCourseSequentialsIfAvailable(courseID: courseID)
            presentConfirmDownloadAlert(
                courseID: courseID,
                blocks: [],
                sequentials: sequentials,
                totalFileSize: totalFileSize,
                action: {
                    // After confirmation, fetch structure and download
                    Task {
                        await self.fetchStructureAndDownload(courseID: courseID)
                    }
                }
            )
            return
        }
        
        // If no confirmation needed, proceed with fetching structure and downloading
        await fetchStructureAndDownload(courseID: courseID)
    }
    
    // swiftlint:disable function_body_length
    private func fetchStructureAndDownload(courseID: String) async {
        structureLoadingTasks[courseID]?.cancel()
        
        let structureTask = Task<Void, Never> {
            do {
                let course = courses.first(where: { $0.id == courseID })
                let courseName = course?.name ?? ""
                
                await MainActor.run {
                    downloadStates[courseID] = .loadingStructure
                }
                
                if Task.isCancelled {
                    await MainActor.run {
                        downloadStates[courseID] = nil
                    }
                    return
                }
                
                let courseStructure = try await courseManager.getCourseBlocks(courseID: courseID)
                
                if Task.isCancelled {
                    await MainActor.run {
                        downloadStates[courseID] = nil
                    }
                    return
                }
                
                courseStructureCache[courseID] = courseStructure
                
                await MainActor.run {
                    downloadStates[courseID] = .inProgress
                }
                
                let downloadableBlocks = courseStructure.childs.flatMap { chapter in
                    chapter.childs.flatMap { sequential in
                        sequential.childs.flatMap { vertical in
                            vertical.childs.filter { $0.isDownloadable }
                        }
                    }
                }
                
                let totalFileSize = downloadableBlocks.reduce(0) { $0 + ($1.fileSize ?? 0) }
                if let courseIndex = courses.firstIndex(where: { $0.id == courseID }) {
                    if totalFileSize > Int(courses[courseIndex].totalSize) {
                        courseSizes[courseID] = Int64(totalFileSize)
                    }
                }
                
                if Task.isCancelled {
                    await MainActor.run {
                        downloadStates[courseID] = nil
                    }
                    return
                }
                
                if await isShowedAllowLargeDownloadAlert(blocks: downloadableBlocks) { return }
                
                if Task.isCancelled {
                    await MainActor.run {
                        downloadStates[courseID] = nil
                    }
                    return
                }
                
                if !isEnoughSpace(for: totalFileSize) {
                    let sequentials = courseStructure.childs.flatMap { $0.childs }
                    presentStorageFullAlert(sequentials: sequentials)
                    analytics.downloadError(
                        courseId: courseID,
                        courseName: courseName,
                        errorType: AnalyticsError.storageFull.rawValue
                    )
                    return
                }
                
                if Task.isCancelled {
                    await MainActor.run {
                        downloadStates[courseID] = nil
                    }
                    return
                }
                
                try await downloadManager.addToDownloadQueue(blocks: downloadableBlocks)
                analytics.downloadStarted(
                    courseId: courseID,
                    courseName: courseName,
                    downloadSize: Int64(totalFileSize)
                )
                await refreshDownloadStates()
                
            } catch {
                if !Task.isCancelled {
                    let course = courses.first(where: { $0.id == courseID })
                    let courseName = course?.name ?? ""
                    
                    await MainActor.run {
                        downloadStates[courseID] = nil
                    }
                    
                    if error is NoWiFiError {
                        errorMessage = CoreLocalization.Error.wifi
                        analytics.downloadError(
                            courseId: courseID,
                            courseName: courseName,
                            errorType: AnalyticsError.wifiRequired.rawValue
                        )
                    } else if error.isInternetError {
                        errorMessage = CoreLocalization.Error.slowOrNoInternetConnection
                        analytics
                            .downloadError(
                                courseId: courseID,
                                courseName: courseName,
                                errorType: AnalyticsError.noInternet.rawValue
                            )
                    } else {
                        errorMessage = CoreLocalization.Error.unknownError
                        analytics
                            .downloadError(
                                courseId: courseID,
                                courseName: courseName,
                                errorType: AnalyticsError.unknown.rawValue
                            )
                    }
                }
            }
            _ = await MainActor.run {
                structureLoadingTasks.removeValue(forKey: courseID)
            }
        }
        // swiftlint:enable function_body_length
        
        // Store the task in the dictionary
        await MainActor.run {
            structureLoadingTasks[courseID] = structureTask
        }
        
        // Wait for the task to complete
        await structureTask.value
    }
    
    // Helper to get sequentials for UI alerts without fetching full structure when unavailable
    private func fetchCourseSequentialsIfAvailable(courseID: String) async -> [CourseSequential] {
        if let cachedStructure = courseStructureCache[courseID] {
            return cachedStructure.childs.flatMap { $0.childs }
        }
        
        do {
            // Try to get from local cache only, don't fetch from server for alerts
            let structure = try await courseManager.getLoadedCourseBlocks(courseID: courseID)
            courseStructureCache[courseID] = structure
            return structure.childs.flatMap { $0.childs }
        } catch {
            return []
        }
    }
    
    func cancelDownload(courseID: String) async {
        let course = courses.first(where: { $0.id == courseID })
        let courseName = course?.name ?? ""
        
        analytics.cancelDownloadClicked(courseId: courseID, courseName: courseName)
        
        // Check if we're loading the course structure and cancel the task
        if let structureTask = structureLoadingTasks[courseID] {
            structureTask.cancel()
            await MainActor.run {
                downloadStates[courseID] = nil
                structureLoadingTasks.removeValue(forKey: courseID)
            }
            
            analytics.downloadCancelled(courseId: courseID, courseName: courseName)
            return
        }
        
        // Keep track of the current task ID to avoid canceling it twice
        var currentTaskId: String?
        
        if let currentTask = await downloadManager.getCurrentDownloadTask(),
           currentTask.courseId == courseID {
            try? await downloadManager.cancelDownloading(task: currentTask)
            currentTaskId = currentTask.id
        }
        
        let tasks = await downloadManager.getDownloadTasksForCourse(courseID)
        let inProgressTasks = tasks.filter {
            ($0.state == .inProgress || $0.state == .waiting) &&
            $0.id != currentTaskId // Skip the current task if we already canceled it
        }
        
        for task in inProgressTasks {
            try? await downloadManager.cancelDownloading(task: task)
        }
        
        analytics.downloadCancelled(courseId: courseID, courseName: courseName)
        await refreshDownloadStates()
    }
    
    func removeDownload(courseID: String, skipConfirmation: Bool = false) async {
        let course = courses.first(where: { $0.id == courseID })
        let courseName = course?.name ?? ""
        
        analytics.removeDownloadClicked(courseId: courseID, courseName: courseName)
        
        if let courseStructure = try? await courseManager.getLoadedCourseBlocks(courseID: courseID) {
            // Cache the course structure for future use
            courseStructureCache[courseID] = courseStructure
            
            let blocks = courseStructure.childs.flatMap { chapter in
                chapter.childs.flatMap { sequential in
                    sequential.childs.flatMap { vertical in
                        vertical.childs.filter { $0.isDownloadable }
                    }
                }
            }
            
            // Update the total size based on the course structure
            let totalFileSize = blocks.reduce(0) { $0 + ($1.fileSize ?? 0) }
            if totalFileSize > Int(course?.totalSize ?? 0) {
                courseSizes[courseID] = Int64(totalFileSize)
            }
            
            if skipConfirmation {
                // Cancel any structure loading task for this course
                if let structureTask = structureLoadingTasks[courseID] {
                    structureTask.cancel()
                    await MainActor.run {
                        structureLoadingTasks.removeValue(forKey: courseID)
                    }
                }
                
                await downloadManager.delete(blocks: blocks, courseId: courseID)
                await MainActor.run {
                    downloadStates[courseID] = nil
                    downloadedSizes[courseID] = 0
                }
                
                analytics.downloadRemoved(
                    courseId: courseID,
                    courseName: courseName,
                    downloadSize: downloadedSizes[courseID] ?? 0
                )
                
                await refreshDownloadStates()
                await getDownloadCourses(isRefresh: true)
            } else {
                presentRemoveDownloadAlert(
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
        courseID: String,
        blocks: [CourseBlock],
        sequentials: [CourseSequential],
        totalFileSize: Int,
        action: @escaping () -> Void = {}
    ) {
        let course = courses.first(where: { $0.id == courseID })
        let courseName = course?.name ?? ""
        
        // Calculate the remaining size to download
        let downloadedSize = downloadedSizes[courseID] ?? 0
        // Use the cached size if available, otherwise use the course.totalSize or totalFileSize
        let totalSize = courseSizes[courseID] ?? course?.totalSize ?? Int64(totalFileSize)
        let remainingSize = max(0, totalSize - downloadedSize)
        
        // Use the remaining size instead of the total size
        let sizeToDisplay = remainingSize
        
        router.presentView(
            transitionStyle: .coverVertical,
            view: DownloadActionView(
                actionType: .confirmDownloadCellular,
                courseBlocks: [],
                courseName: courseName,
                downloadedSize: Int(sizeToDisplay),
                action: { [weak self] in
                    guard let self else { return }
                    if !self.isEnoughSpace(for: totalFileSize) {
                        self.router.dismiss(animated: true)
                        self.presentStorageFullAlert(sequentials: sequentials)
                        self.analytics.downloadError(
                            courseId: courseID,
                            courseName: courseName,
                            errorType: AnalyticsError.storageFull.rawValue
                        )
                    } else {
                        Task {
                            await MainActor.run {
                                self.downloadStates[courseID] = .inProgress
                            }
                            action()
                        }
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
                freeSpace: downloadManager.getFreeDiskSpace() ?? 0,
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
        courseID: String,
        blocks: [CourseBlock],
        sequentials: [CourseSequential],
        totalFileSize: Int,
        action: @escaping () -> Void = {}
    ) {
        let course = courses.first(where: { $0.id == courseID })
        let courseName = course?.name ?? ""
        
        // Calculate the remaining size to download
        let downloadedSize = downloadedSizes[courseID] ?? 0
        // Use the cached size if available, otherwise use the course.totalSize or totalFileSize
        let totalSize = courseSizes[courseID] ?? course?.totalSize ?? Int64(totalFileSize)
        let remainingSize = max(0, totalSize - downloadedSize)
        
        // Use the remaining size instead of the total size
        let sizeToDisplay = remainingSize
        
        router.presentView(
            transitionStyle: .coverVertical,
            view: DownloadActionView(
                actionType: .confirmDownload,
                courseBlocks: [],
                courseName: courseName,
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
                                errorType: AnalyticsError.storageFull.rawValue
                            )
                    } else {
                        Task {
                            await MainActor.run {
                                self.downloadStates[courseID] = .inProgress
                            }
                            action()
                        }
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
    ) {
        let downloadedSize = downloadedSizes[courseID] ?? 0
        let course = courses.first(where: { $0.id == courseID })
        let courseName = course?.name ?? ""
        
        // Calculate total size from blocks for more accuracy
        let totalSize = blocks.reduce(0) { $0 + ($1.fileSize ?? 0) }
        if totalSize > 0 {
            courseSizes[courseID] = Int64(totalSize)
        }
        
        router.presentView(
            transitionStyle: .coverVertical,
            view: DownloadActionView(
                actionType: .remove,
                courseBlocks: [],
                courseName: courseName,
                downloadedSize: Int(downloadedSize),
                action: { [weak self] in
                    guard let self else { return }
                    self.router.dismiss(animated: true)
                    Task {
                        // Cancel any structure loading task for this course
                        if let structureTask = self.structureLoadingTasks[courseID] {
                            structureTask.cancel()
                            _ = await MainActor.run {
                                self.structureLoadingTasks.removeValue(forKey: courseID)
                            }
                        }
                        
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
    
    @MainActor
    func continueDownload() async {
        guard let blocks = waitingDownloads else {
            return
        }
        do {
            let courseID = blocks.first?.courseId ?? ""
            downloadStates[courseID] = .inProgress
            
            try await downloadManager.addToDownloadQueue(blocks: blocks)
        } catch let error {
            if error is NoWiFiError {
                errorMessage = CoreLocalization.Error.wifi
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func isEnoughSpace(for fileSize: Int) -> Bool {
        if let freeSpace = downloadManager.getFreeDiskSpace() {
            return freeSpace > Int(Double(fileSize) * requiredFreeSpaceMultiplier)
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
// swiftlint:enable type_body_length file_length

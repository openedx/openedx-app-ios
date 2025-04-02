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

//swiftlint:disable type_body_length
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
    private var courseStructureCache: [String: CourseStructure] = [:]
    private var structureLoadingTasks: [String: Task<Void, Never>] = [:]
    
    private let requiredFreeSpaceMultiplier: Double = 1.2
    private let largeDownloadThreshold: Int = 100 * 1024 * 1024 // 100 MB
    private let downloadCompletionThreshold: Int = 95 // 95% of total to be considered complete
    
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
        self.observeEnrollmentEvents()
    }
    
    private func observeEnrollmentEvents() {
        NotificationCenter.default.publisher(for: .onCourseEnrolled)
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
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self = self else { return }
                Task {
                    switch event {
                    case .finished(let task), .started(let task):
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
        
        // Update TotalSize in the course model, if there is a more accurate value
        if let courseIndex = courses.firstIndex(where: { $0.id == courseID }) {
            if courses[courseIndex].totalSize != Int64(total) {
                courses[courseIndex].totalSize = Int64(total)
            }
        }
        
        if isFullyDownloaded && downloaded >= total * downloadCompletionThreshold / 100 {
            let previousState = downloadStates[courseID]
            downloadStates[courseID] = .finished
            
            // Track download completion when a task is finished
            if previousState == .inProgress || task.state == .finished {
                trackDownloadCompleted(courseID: courseID, size: Int64(total))
            }
        } else if isDownloading {
            downloadStates[courseID] = .inProgress
        } else {
            // If not fully downloaded and not downloading, set to nil
            downloadStates[courseID] = nil
        }
    }
    
    func refreshDownloadStates() async {
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
            
            if let courseIndex = courses.firstIndex(where: { $0.id == course.id }) {
                if courses[courseIndex].totalSize != Int64(total) {
                    courses[courseIndex].totalSize = Int64(total)
                }
            }
            
            if isDownloading {
                downloadStates[course.id] = .inProgress
            } else if isFullyDownloaded && downloaded >= total * downloadCompletionThreshold / 100 {
                downloadStates[course.id] = .finished
            } else {
                downloadStates[course.id] = nil
            }
        }
    }
    
    private func calculateAccurateDownloadProgress(courseID: String) async -> (downloaded: Int, total: Int) {
        let tasks = await downloadsHelper.getDownloadTasksForCourse(courseID: courseID)
        let downloadedSize = tasks.reduce(0) { $0 + ($1.state == .finished ? $1.actualSize : 0) }
        
        if let courseStructure = await getCourseStructureIfAvailable(courseID: courseID) {
            let totalSize = calculateTotalSizeFromStructure(courseStructure: courseStructure, downloadedTasks: tasks)
            return (downloadedSize, totalSize)
        } else {
            let (_, total) = await downloadsHelper.calculateDownloadProgress(courseID: courseID)
            let course = courses.first(where: { $0.id == courseID })
            let finalTotal = course?.totalSize != 0 ? Int(course?.totalSize ?? 0) : total
            return (downloadedSize, finalTotal)
        }
    }
    
    private func calculateTotalSizeFromStructure(
        courseStructure: CourseStructure,
        downloadedTasks: [DownloadDataTask]
    ) -> Int {
        let downloadableBlocks = getDownloadableBlocks(from: courseStructure)
        var totalSize = 0
        
        for block in downloadableBlocks {
            if let downloadTask = downloadedTasks.first(where: { $0.blockId == block.id }),
               downloadTask.state == .finished,
               downloadTask.actualSize > 0 {
                // Use actual size for finished downloads
                totalSize += downloadTask.actualSize
            } else {
                // Use file size for not-yet-downloaded blocks
                totalSize += block.fileSize ?? 0
            }
        }
        
        return totalSize
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
    
    private func getDownloadableBlocks(from courseStructure: CourseStructure) -> [CourseBlock] {
        courseStructure.childs.flatMap { chapter in
            chapter.childs.flatMap { sequential in
                sequential.childs.flatMap { vertical in
                    vertical.childs.filter { $0.isDownloadable }
                }
            }
        }
    }
    
    private func getSequentials(from courseStructure: CourseStructure) -> [CourseSequential] {
        courseStructure.childs.flatMap { $0.childs }
    }
    
    private func getCourseInfo(courseID: String) -> (name: String, id: String) {
        let course = courses.first(where: { $0.id == courseID })
        let courseName = course?.name ?? ""
        return (courseName, courseID)
    }
    
    private func trackDownloadStarted(courseID: String, courseName: String, size: Int64) {
        analytics.downloadStarted(courseId: courseID, courseName: courseName, downloadSize: size)
    }
    
    private func trackDownloadCancelled(courseID: String, courseName: String) {
        analytics.downloadCancelled(courseId: courseID, courseName: courseName)
    }
    
    private func trackDownloadCompleted(courseID: String, size: Int64) {
        let (name, id) = getCourseInfo(courseID: courseID)
        analytics.downloadCompleted(courseId: id, courseName: name, downloadSize: size)
    }
    
    private func trackDownloadError(courseID: String, courseName: String, error: AnalyticsError) {
        analytics.downloadError(courseId: courseID, courseName: courseName, errorType: error.rawValue)
    }
    
    // Compares server and local sizes and updates if there's a significant difference
    private func updateSizesFromServer(_ serverCourses: [DownloadCoursePreview]) {
        for serverCourse in serverCourses {
            let localSize = courseSizes[serverCourse.id] ?? 0
            
            if localSize == 0 {
                courseSizes[serverCourse.id] = serverCourse.totalSize
                continue
            }
            
            // Calculate difference percentage
            let difference = abs(Double(serverCourse.totalSize - localSize) / Double(localSize)) * 100
            
            if difference > 5 {
                courseSizes[serverCourse.id] = serverCourse.totalSize
                // Also update the course model if it exists
                if let courseIndex = courses.firstIndex(where: { $0.id == serverCourse.id }) {
                    courses[courseIndex].totalSize = serverCourse.totalSize
                }
            }
        }
    }

    @MainActor
    func getDownloadCourses(isRefresh: Bool = false) async {
        fetchInProgress = !isRefresh
        do {
            if connectivity.isInternetAvaliable {
                let serverCourses = try await downloadsInteractor.getDownloadCourses()
                                
                courses = serverCourses
                await refreshDownloadStates()
                updateSizesFromServer(serverCourses)
            } else {
                courses = try await downloadsInteractor.getDownloadCoursesOffline()
                await refreshDownloadStates()
            }
            fetchInProgress = false
            analytics.downloadsScreenViewed()
        } catch let error {
            handleError(error: error)
        }
    }
    
    private func handleError(error: Error, courseID: String? = nil) {
        if let courseID = courseID {
            let (name, id) = getCourseInfo(courseID: courseID)
            
            if error is NoWiFiError {
                errorMessage = CoreLocalization.Error.wifi
                trackDownloadError(courseID: id, courseName: name, error: .wifiRequired)
            } else if error.isInternetError {
                errorMessage = CoreLocalization.Error.slowOrNoInternetConnection
                trackDownloadError(courseID: id, courseName: name, error: .noInternet)
            } else {
                errorMessage = CoreLocalization.Error.unknownError
                trackDownloadError(courseID: id, courseName: name, error: .unknown)
            }
        } else {
            if error.isInternetError || error is NoCachedDataError {
                errorMessage = CoreLocalization.Error.slowOrNoInternetConnection
            } else {
                errorMessage = CoreLocalization.Error.unknownError
            }
        }
    }
    
    func downloadCourse(courseID: String) async {
        let (courseName, id) = getCourseInfo(courseID: courseID)
        analytics.downloadCourseClicked(courseId: id, courseName: courseName)
        
        // Get the total size of the course from our existing data
        let totalFileSize = Int(courses.first(where: { $0.id == courseID })?.totalSize ?? 0)
        
        // Calculate the remaining size to download
        let downloadedSize = Int(downloadedSizes[courseID] ?? 0)
        let remainingSize = max(0, totalFileSize - downloadedSize)
        
        if !connectivity.isInternetAvaliable {
            let sequentials = await fetchCourseSequentialsIfAvailable(courseID: courseID)
            presentNoInternetAlert(sequentials: sequentials)
            trackDownloadError(courseID: id, courseName: courseName, error: .noInternet)
            return
        }
        
        if connectivity.isMobileData {
            if storage.userSettings?.wifiOnly == true {
                let sequentials = await fetchCourseSequentialsIfAvailable(courseID: courseID)
                presentWifiRequiredAlert(sequentials: sequentials)
                trackDownloadError(courseID: id, courseName: courseName, error: .wifiRequired)
                return
            } else {
                // Show cellular download confirmation
                let sequentials = await fetchCourseSequentialsIfAvailable(courseID: courseID)
                presentDownloadConfirmationAlert(
                    courseID: courseID,
                    sequentials: sequentials,
                    totalFileSize: remainingSize,
                    type: .confirmDownloadCellular
                )
                return
            }
        } else if remainingSize > largeDownloadThreshold {
            // Show large download confirmation if the remaining size is above threshold
            let sequentials = await fetchCourseSequentialsIfAvailable(courseID: courseID)
            presentDownloadConfirmationAlert(
                courseID: courseID,
                sequentials: sequentials,
                totalFileSize: remainingSize,
                type: .confirmDownload
            )
            return
        }
        
        // If no confirmation needed, proceed with fetching structure and downloading
        await fetchStructureAndDownload(courseID: courseID)
    }
    
    private func fetchStructureAndDownload(courseID: String) async {
        await cancelStructureLoadingTask(courseID: courseID)
        
        let structureTask = Task<Void, Never> {
            do {
                let (courseName, id) = getCourseInfo(courseID: courseID)
                
                await MainActor.run {
                    downloadStates[courseID] = .loadingStructure
                }
                
                if await checkTaskCancellation(courseID: courseID) { return }
                
                let courseStructure = try await courseManager.getCourseBlocks(courseID: courseID)
                
                if await checkTaskCancellation(courseID: courseID) { return }
                
                courseStructureCache[courseID] = courseStructure
                
                await MainActor.run {
                    downloadStates[courseID] = .inProgress
                }
                
                let downloadableBlocks = getDownloadableBlocks(from: courseStructure)
                
                let totalFileSize = downloadableBlocks.reduce(0) { $0 + ($1.fileSize ?? 0) }
                if let courseIndex = courses.firstIndex(where: { $0.id == courseID }) {
                    if totalFileSize > Int(courses[courseIndex].totalSize) {
                        courseSizes[courseID] = Int64(totalFileSize)
                    }
                }
                
                if await checkTaskCancellation(courseID: courseID) { return }
                
                if await presentAllowLargeDownloadAlert(blocks: downloadableBlocks) { return }
                
                if await checkTaskCancellation(courseID: courseID) { return }
                
                if !isEnoughSpace(for: totalFileSize) {
                    let sequentials = getSequentials(from: courseStructure)
                    presentStorageFullAlert(sequentials: sequentials)
                    trackDownloadError(courseID: id, courseName: courseName, error: .storageFull)
                    return
                }
                
                if await checkTaskCancellation(courseID: courseID) { return }
                
                try await downloadManager.addToDownloadQueue(blocks: downloadableBlocks)
                trackDownloadStarted(courseID: id, courseName: courseName, size: Int64(totalFileSize))
                await refreshDownloadStates()
                
            } catch let error {
                if !Task.isCancelled {
                    await MainActor.run {
                        downloadStates[courseID] = nil
                    }
                    handleError(error: error, courseID: courseID)
                }
            }
            _ = await MainActor.run {
                structureLoadingTasks.removeValue(forKey: courseID)
            }
        }
        
        // Store the task in the dictionary
        await MainActor.run {
            structureLoadingTasks[courseID] = structureTask
        }
        
        // Wait for the task to complete
        await structureTask.value
    }
    
    private func checkTaskCancellation(courseID: String) async -> Bool {
        if Task.isCancelled {
            await MainActor.run {
                downloadStates[courseID] = nil
            }
            return true
        }
        return false
    }
    
    private func cancelStructureLoadingTask(courseID: String) async {
        structureLoadingTasks[courseID]?.cancel()
    }
    
    // Helper to get sequentials for UI alerts without fetching full structure when unavailable
    private func fetchCourseSequentialsIfAvailable(courseID: String) async -> [CourseSequential] {
        if let cachedStructure = courseStructureCache[courseID] {
            return getSequentials(from: cachedStructure)
        }
        
        do {
            // Try to get from local cache only, don't fetch from server for alerts
            let structure = try await courseManager.getLoadedCourseBlocks(courseID: courseID)
            courseStructureCache[courseID] = structure
            return getSequentials(from: structure)
        } catch {
            return []
        }
    }
    
    func cancelDownload(courseID: String) async {
        let (courseName, id) = getCourseInfo(courseID: courseID)
        analytics.cancelDownloadClicked(courseId: id, courseName: courseName)
        
        // Check if we're loading the course structure and cancel the task
        if let structureTask = structureLoadingTasks[courseID] {
            structureTask.cancel()
            await MainActor.run {
                downloadStates[courseID] = nil
                structureLoadingTasks.removeValue(forKey: courseID)
            }
            
            trackDownloadCancelled(courseID: id, courseName: courseName)
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
        
        trackDownloadCancelled(courseID: id, courseName: courseName)
        await refreshDownloadStates()
    }
    
    func removeDownload(courseID: String, skipConfirmation: Bool = false) async {
        let (courseName, id) = getCourseInfo(courseID: courseID)
        analytics.removeDownloadClicked(courseId: id, courseName: courseName)
        
        if let courseStructure = try? await courseManager.getLoadedCourseBlocks(courseID: courseID) {
            // Cache the course structure for future use
            courseStructureCache[courseID] = courseStructure
            
            let blocks = getDownloadableBlocks(from: courseStructure)
            
            // Update the total size based on the course structure
            let totalFileSize = blocks.reduce(0) { $0 + ($1.fileSize ?? 0) }
            if totalFileSize > Int(courses.first(where: { $0.id == courseID })?.totalSize ?? 0) {
                courseSizes[courseID] = Int64(totalFileSize)
            }
            
            if skipConfirmation {
                await performDownloadRemoval(courseID: courseID, blocks: blocks)
            } else {
                presentRemoveDownloadAlert(
                    blocks: blocks,
                    sequentials: getSequentials(from: courseStructure),
                    courseID: courseID
                )
            }
        }
    }
    
    private func performDownloadRemoval(courseID: String, blocks: [CourseBlock]) async {
        // Cancel any structure loading task for this course
        if let structureTask = structureLoadingTasks[courseID] {
            structureTask.cancel()
            _ = await MainActor.run {
                structureLoadingTasks.removeValue(forKey: courseID)
            }
        }
        
        let downloadedSize = downloadedSizes[courseID] ?? 0
        let (courseName, id) = getCourseInfo(courseID: courseID)
        
        await downloadManager.delete(blocks: blocks, courseId: courseID)
        await MainActor.run {
            downloadStates[courseID] = nil
            downloadedSizes[courseID] = 0
        }
        
        analytics.downloadRemoved(
            courseId: id,
            courseName: courseName,
            downloadSize: downloadedSize
        )
        
        await refreshDownloadStates()
        await getDownloadCourses(isRefresh: true)
    }
    
    // MARK: - Alert Presentation Methods
    
    private func presentAlertView<T: View>(
        view: T,
        transitionStyle: UIModalTransitionStyle = .coverVertical
    ) {
        router.presentView(
            transitionStyle: transitionStyle,
            view: view,
            completion: {}
        )
    }
    
    private func presentNoInternetAlert(sequentials: [CourseSequential]) {
        presentAlertView(
            view: DownloadErrorAlertView(
                errorType: .noInternetConnection,
                sequentials: sequentials,
                close: { [weak self] in
                    guard let self else { return }
                    self.router.dismiss(animated: true)
                }
            )
        )
    }
    
    private func presentWifiRequiredAlert(sequentials: [CourseSequential]) {
        presentAlertView(
            view: DownloadErrorAlertView(
                errorType: .wifiRequired,
                sequentials: sequentials,
                close: { [weak self] in
                    guard let self else { return }
                    self.router.dismiss(animated: true)
                }
            )
        )
    }
    
    @MainActor
    private func presentDownloadConfirmationAlert(
        courseID: String,
        sequentials: [CourseSequential],
        totalFileSize: Int,
        type: ContentActionType
    ) {
        let (courseName, id) = getCourseInfo(courseID: courseID)
        
        // Calculate the remaining size to download
        let downloadedSize = downloadedSizes[courseID] ?? 0
        // Use the cached size if available, otherwise use the course.totalSize or totalFileSize
        let totalSize = courseSizes[courseID] ?? courses.first(
            where: {
                $0.id == courseID
            })?.totalSize ?? Int64(totalFileSize)
        let remainingSize = max(0, totalSize - downloadedSize)
        
        presentAlertView(
            view: DownloadActionView(
                actionType: type,
                courseBlocks: [],
                courseName: courseName,
                downloadedSize: Int(remainingSize),
                action: { [weak self] in
                    guard let self else { return }
                    if !self.isEnoughSpace(for: totalFileSize) {
                        self.router.dismiss(animated: true)
                        self.presentStorageFullAlert(sequentials: sequentials)
                        self.trackDownloadError(courseID: id, courseName: courseName, error: .storageFull)
                    } else {
                        Task {
                            await MainActor.run {
                                self.downloadStates[courseID] = .inProgress
                            }
                            await self.fetchStructureAndDownload(courseID: courseID)
                        }
                    }
                    self.router.dismiss(animated: true)
                },
                cancel: { [weak self] in
                    guard let self else { return }
                    self.trackDownloadCancelled(courseID: id, courseName: courseName)
                    self.router.dismiss(animated: true)
                }
            )
        )
    }
    
    private func presentStorageFullAlert(sequentials: [CourseSequential]) {
        presentAlertView(
            view: DeviceStorageFullAlertView(
                sequentials: sequentials,
                usedSpace: getUsedDiskSpace() ?? 0,
                freeSpace: downloadManager.getFreeDiskSpace() ?? 0,
                close: { [weak self] in
                    guard let self else { return }
                    self.router.dismiss(animated: true)
                }
            )
        )
    }
    
    private func presentRemoveDownloadAlert(
        blocks: [CourseBlock],
        sequentials: [CourseSequential],
        courseID: String
    ) {
        let downloadedSize = downloadedSizes[courseID] ?? 0
        let (courseName, _) = getCourseInfo(courseID: courseID)
        
        // Calculate total size from blocks for more accuracy
        let totalSize = blocks.reduce(0) { $0 + ($1.fileSize ?? 0) }
        if totalSize > 0 {
            courseSizes[courseID] = Int64(totalSize)
        }
        
        presentAlertView(
            view: DownloadActionView(
                actionType: .remove,
                courseBlocks: [],
                courseName: courseName,
                downloadedSize: Int(downloadedSize),
                action: { [weak self] in
                    guard let self else { return }
                    self.router.dismiss(animated: true)
                    Task {
                        await self.performDownloadRemoval(courseID: courseID, blocks: blocks)
                    }
                },
                cancel: { [weak self] in
                    guard let self else { return }
                    self.router.dismiss(animated: true)
                }
            )
        )
    }
    
    @MainActor
    func presentAllowLargeDownloadAlert(blocks: [CourseBlock]) async -> Bool {
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
//swiftlint:enable type_body_length

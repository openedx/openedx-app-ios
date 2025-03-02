//
//  AppDownloadsViewModel.swift
//  Downloads
//
//  Created by Ivan Stepanok on 25.02.2025.
//

import Foundation
import Combine
import Core
import Course
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
    
    var errorMessage: String? {
        didSet {
            withAnimation {
                showError = errorMessage != nil
            }
        }
    }
    
    let connectivity: ConnectivityProtocol
    private let downloadsInteractor: DownloadsInteractorProtocol
    private let courseInteractor: CourseInteractorProtocol
    private let downloadManager: DownloadManagerProtocol
    let router: DownloadsRouter
    
    public init(
        interactor: DownloadsInteractorProtocol,
        courseInteractor: CourseInteractorProtocol,
        downloadManager: DownloadManagerProtocol,
        connectivity: ConnectivityProtocol,
        router: DownloadsRouter
    ) {
        self.downloadsInteractor = interactor
        self.courseInteractor = courseInteractor
        self.downloadManager = downloadManager
        self.connectivity = connectivity
        self.router = router
        self.observeDownloadEvents()
    }
    
    private func observeDownloadEvents() {
        downloadManager.eventPublisher()
            .receive(on: RunLoop.main)
            .sink { [weak self] event in
                guard let self = self else { return }
                switch event {
                    
                case .progress(let task):
                    guard !task.courseId.isEmpty else { return }
                    self.updateTask(task)
                    self.recalculateProgress(for: task.courseId)
                    
                case .finished(let task):
                    guard !task.courseId.isEmpty else { return }
                    self.finishedTaskIds.insert(task.id)
                    self.updateTask(task)
                    self.recalculateProgress(for: task.courseId)
                    
                case .added:
                    Task {
                        await self.refreshDownloadStates()
                    }
                    
                case .started(let task):
                    guard !task.courseId.isEmpty else { return }
                    self.updateTask(task)
                    if self.downloadStates[task.courseId] == nil {
                        self.downloadStates[task.courseId] = .inProgress
                    }
                    self.recalculateProgress(for: task.courseId)
                    
                case .canceled, .courseCanceled, .allCanceled, .clearedAll, .deletedFile:
                    Task {
                        await self.refreshDownloadStates()
                    }
                    
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
    
    private func updateTask(_ task: DownloadDataTask) {
        let courseId = task.courseId
        
        if courseTasks[courseId] == nil {
            courseTasks[courseId] = []
        }
        
        if let index = courseTasks[courseId]?.firstIndex(where: { $0.id == task.id }) {
            courseTasks[courseId]?[index] = task
        } else {
            courseTasks[courseId]?.append(task)
        }
    }
    
    private func recalculateProgress(for courseId: String) {
        guard let tasks = courseTasks[courseId], !tasks.isEmpty else { return }
        
        var totalSize: Int64 = 0
        if let index = courses.firstIndex(where: { $0.id == courseId }) {
            totalSize = courses[index].totalSize
            courseSizes[courseId] = totalSize
        } else if let cachedSize = courseSizes[courseId], cachedSize > 0 {
            totalSize = cachedSize
        } else {
            totalSize = Int64(tasks.reduce(0) { $0 + $1.fileSize })
            courseSizes[courseId] = totalSize
        }
        
        // Guard against zero total size
        if totalSize <= 0 {
            totalSize = 1 // Prevent division by zero
        }
        
        var downloadedSize: Int64 = 0
        var isDownloading = false
        var finishedTasks = 0
                
        for task in tasks {
            if task.state == .finished || finishedTaskIds.contains(task.id) {
                // Count the full size for finished tasks
                downloadedSize += Int64(task.fileSize)
                finishedTasks += 1
            } else if task.state == .inProgress {
                let partialSize = Int64(Double(task.fileSize) * task.progress)
                downloadedSize += partialSize
                isDownloading = true
            } else if task.state == .waiting {
                isDownloading = true
            }
        }
        let oldState = downloadStates[courseId]
        downloadedSizes[courseId] = downloadedSize
                        
        var newState: DownloadState?
        if finishedTasks == tasks.count {
            // All tasks finished
            newState = .finished
            downloadedSizes[courseId] = totalSize
        } else if isDownloading {
            newState = .inProgress
        } else {
            newState = .waiting
        }
        
        let stateChanged = oldState != newState
        
        if stateChanged {
            downloadStates[courseId] = newState
        }
    }
    
    @MainActor
    func getDownloadCourses(isRefresh: Bool = false) async {
        fetchInProgress = !isRefresh
        do {
            if connectivity.isInternetAvaliable {
                courses = try await downloadsInteractor.getDownloadCourses()
                fetchInProgress = false
                
                for course in courses {
                    courseSizes[course.id] = course.totalSize
                }
            } else {
                courses = try await downloadsInteractor.getDownloadCoursesOffline()
                fetchInProgress = false
                
                for course in courses {
                    courseSizes[course.id] = course.totalSize
                }
            }
            await refreshDownloadStates()
        } catch let error {
            if error.isInternetError || error is NoCachedDataError {
                errorMessage = CoreLocalization.Error.slowOrNoInternetConnection
            } else {
                errorMessage = CoreLocalization.Error.unknownError
            }
        }
    }
    
    private func refreshDownloadStates() async {
        finishedTaskIds.removeAll()
        
        var allCourseIds = Set(courses.map { $0.id })
        for (courseId, _) in courseTasks {
            allCourseIds.insert(courseId)
        }
        
        for courseId in allCourseIds {
            let tasks = await downloadManager.getDownloadTasksForCourse(courseId)
            courseTasks[courseId] = tasks
            
            for task in tasks where task.state == .finished {
                    finishedTaskIds.insert(task.id)
            }
            
            if tasks.isEmpty {
                if !downloadQueue.contains(courseId) {
                    downloadStates[courseId] = nil
                    downloadedSizes[courseId] = 0
                }
            } else {
                self.recalculateProgress(for: courseId)
            }
        }
    }
    
    func downloadCourse(courseID: String) {
        downloadQueue.append(courseID)
        downloadStates[courseID] = .waiting
        downloadedSizes[courseID] = 0
        
        if courseTasks[courseID] == nil {
            courseTasks[courseID] = []
        }
        
        if !isProcessingQueue {
            Task {
                await processDownloadQueue()
            }
        }
    }
    
    private func processDownloadQueue() async {
        if isProcessingQueue {
            return
        }
        
        isProcessingQueue = true
        
        while !downloadQueue.isEmpty {
            let courseID = downloadQueue.first!
            
            do {
                downloadStates[courseID] = .waiting
                let courseStructure = try await courseInteractor.getCourseBlocks(courseID: courseID)
                let downloadableBlocks = extractDownloadableBlocks(from: courseStructure)
                                
                if !downloadableBlocks.isEmpty {
                    if courseTasks[courseID] == nil {
                        courseTasks[courseID] = []
                    }
                    downloadStates[courseID] = .waiting
                    try await downloadManager.addToDownloadQueue(blocks: downloadableBlocks)
                }
                downloadQueue.removeFirst()
                
            } catch {
                if error is NoWiFiError {
                    errorMessage = CoreLocalization.Error.wifi
                } else if error.isInternetError {
                    errorMessage = CoreLocalization.Error.slowOrNoInternetConnection
                } else {
                    errorMessage = CoreLocalization.Error.unknownError
                }
                downloadStates[courseID] = nil
                downloadedSizes[courseID] = 0
                downloadQueue.removeFirst()
            }
        }
        
        isProcessingQueue = false
    }
    
    private func extractDownloadableBlocks(from courseStructure: CourseStructure) -> [CourseBlock] {
        var blocks: [CourseBlock] = []
        
        for chapter in courseStructure.childs {
            for sequential in chapter.childs {
                for vertical in sequential.childs {
                    for block in vertical.childs where block.isDownloadable {
                        blocks.append(block)
                    }
                }
            }
        }
        
        return blocks
    }
    
    func cancelDownload(courseID: String) {
        downloadQueue.removeAll(where: { $0 == courseID })
        Task {
            try? await downloadManager.cancelDownloading(courseId: courseID)
            await MainActor.run {
                downloadStates[courseID] = nil
                downloadedSizes[courseID] = 0
                courseTasks[courseID] = []
            }
        }
    }
    
    func removeDownload(courseID: String) {
        Task {
            if let courseStructure = try? await courseInteractor.getLoadedCourseBlocks(courseID: courseID) {
                let blocks = extractDownloadableBlocks(from: courseStructure)
                await downloadManager.delete(blocks: blocks, courseId: courseID)
                
                await MainActor.run {
                    downloadStates[courseID] = nil
                    downloadedSizes[courseID] = 0
                    courseTasks[courseID] = []
                }
            }
        }
    }
}

// Mark - For testing and SwiftUI preview
#if DEBUG
public extension AppDownloadsViewModel {
    static let mock = AppDownloadsViewModel(
        interactor: DownloadsInteractor.mock,
        courseInteractor: CourseInteractor.mock,
        downloadManager: DownloadManagerMock(),
        connectivity: Connectivity(),
        router: DownloadsRouterMock()
    )
}
#endif

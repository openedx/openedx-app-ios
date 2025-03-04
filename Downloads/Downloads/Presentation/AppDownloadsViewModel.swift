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
    
    public init(
        interactor: DownloadsInteractorProtocol,
        courseManager: CourseStructureManagerProtocol,
        downloadManager: DownloadManagerProtocol,
        connectivity: ConnectivityProtocol,
        downloadsHelper: DownloadsHelperProtocol,
        router: DownloadsRouter
    ) {
        self.downloadsInteractor = interactor
        self.courseManager = courseManager
        self.downloadManager = downloadManager
        self.connectivity = connectivity
        self.downloadsHelper = downloadsHelper
        self.router = router
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
        
        await MainActor.run {
            downloadedSizes[courseID] = Int64(downloaded)
            courseSizes[courseID] = Int64(total)
            
            if task.state == .finished {
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
            
            await MainActor.run {
                downloadedSizes[course.id] = Int64(downloaded)
                courseSizes[course.id] = Int64(total)
                
                if isDownloading {
                    downloadStates[course.id] = .inProgress
                } else if downloaded > 0 && (downloaded >= total * 95 / 100) {
                    // If at least 95% is downloaded, consider it finished
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
                errorMessage = CoreLocalization.Error.slowOrNoInternetConnection
            } else {
                errorMessage = CoreLocalization.Error.unknownError
            }
        }
    }
    
    func downloadCourse(courseID: String) {
        Task {
            do {
                let courseStructure: CourseStructure
                do {
                    // First try to get course structure from cached data
                    courseStructure = try await courseManager.getLoadedCourseBlocks(courseID: courseID)
                } catch let error as NoCachedDataError {
                    // If no cached data, fetch from network
                    downloadStates[courseID] = .inProgress
                    courseStructure = try await courseManager.getCourseBlocks(courseID: courseID)
                }
                
                let downloadableBlocks = courseStructure.childs.flatMap { chapter in
                    chapter.childs.flatMap { sequential in
                        sequential.childs.flatMap { vertical in
                            vertical.childs.filter { $0.isDownloadable }
                        }
                    }
                }
                
                try await downloadManager.addToDownloadQueue(blocks: downloadableBlocks)
                await refreshDownloadStates()
            } catch {
                if error is NoWiFiError {
                    errorMessage = CoreLocalization.Error.wifi
                } else if error.isInternetError {
                    errorMessage = CoreLocalization.Error.slowOrNoInternetConnection
                } else {
                    errorMessage = CoreLocalization.Error.unknownError
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
            if let courseStructure = try? await courseManager.getLoadedCourseBlocks(courseID: courseID) {
                let blocks = courseStructure.childs.flatMap { chapter in
                    chapter.childs.flatMap { sequential in
                        sequential.childs.flatMap { vertical in
                            vertical.childs.filter { $0.isDownloadable }
                        }
                    }
                }
                await downloadManager.delete(blocks: blocks, courseId: courseID)
                await refreshDownloadStates()
            }
        }
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
        router: DownloadsRouterMock()
    )
}
#endif

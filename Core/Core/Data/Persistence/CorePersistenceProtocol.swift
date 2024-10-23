//
//  CorePersistence.swift
//  Core
//
//  Created by  Stepanok Ivan on 08.03.2023.
//

import CoreData
import Combine

//sourcery: AutoMockable
public protocol CorePersistenceProtocol {
    func set(userId: Int)
    func getUserID() -> Int?
    func publisher() -> AnyPublisher<Int, Never>
    func addToDownloadQueue(tasks: [DownloadDataTask])
    func saveOfflineProgress(progress: OfflineProgress)
    func loadProgress(for blockID: String) -> OfflineProgress?
    func loadAllOfflineProgress() -> [OfflineProgress]
    func deleteProgress(for blockID: String)
    func deleteAllProgress()

    func addToDownloadQueue(blocks: [CourseBlock], downloadQuality: DownloadQuality) async
    func nextBlockForDownloading() async -> DownloadDataTask?
    func updateDownloadState(id: String, state: DownloadState, resumeData: Data?)
    func deleteDownloadDataTask(id: String) async throws
    func saveDownloadDataTask(_ task: DownloadDataTask)
    func downloadDataTask(for blockId: String) -> DownloadDataTask?
    func getDownloadDataTasks() async -> [DownloadDataTask]
    func getDownloadDataTasksForCourse(_ courseId: String) async -> [DownloadDataTask]
}

#if DEBUG
public class CorePersistenceMock: CorePersistenceProtocol {
    // Tracking method calls
    private var methodCalls: Set<String> = []
    
    // Mock data storage
    var mockDownloadTasks: [DownloadDataTask] = []
    var mockDownloadTask: DownloadDataTask?
    
    // Computed properties for checking method calls
    public var addToDownloadQueueCalled: Bool {
        methodCalls.contains("addToDownloadQueue")
    }
    
    public var deleteDownloadDataTaskCalled: Bool {
        methodCalls.contains("deleteDownloadDataTask")
    }
    
    // Methods to set mock data
    public func setMockDownloadTasks(_ tasks: [DownloadDataTask]) {
        mockDownloadTasks = tasks
    }
    
    public func setMockDownloadTask(_ task: DownloadDataTask?) {
        mockDownloadTask = task
    }
    
    public init() {}
    
    public func set(userId: Int) {
        methodCalls.insert("set")
    }
    
    public func getUserID() -> Int? {
        methodCalls.insert("getUserID")
        return 1
    }
    
    public func publisher() -> AnyPublisher<Int, Never> {
        methodCalls.insert("publisher")
        return Just(0).eraseToAnyPublisher()
    }
    
    public func addToDownloadQueue(blocks: [CourseBlock], downloadQuality: DownloadQuality) {
        methodCalls.insert("addToDownloadQueue")
    }
    
    public func addToDownloadQueue(tasks: [DownloadDataTask]) {
        methodCalls.insert("addToDownloadQueue")
    }
    
    @MainActor
    public func nextBlockForDownloading() async -> DownloadDataTask? {
        methodCalls.insert("nextBlockForDownloading")
        return mockDownloadTask
    }
    
    public func updateDownloadState(id: String, state: DownloadState, resumeData: Data?) {
        methodCalls.insert("updateDownloadState")
    }
    
    public func deleteDownloadDataTask(id: String) async throws {
        methodCalls.insert("deleteDownloadDataTask")
    }
    
    public func downloadDataTask(for blockId: String) -> DownloadDataTask? {
        methodCalls.insert("downloadDataTask")
        return mockDownloadTask
    }
    
    public func saveOfflineProgress(progress: OfflineProgress) {
        methodCalls.insert("saveOfflineProgress")
    }
    
    public func loadProgress(for blockID: String) -> OfflineProgress? {
        methodCalls.insert("loadProgress")
        return nil
    }
    
    public func loadAllOfflineProgress() -> [OfflineProgress] {
        methodCalls.insert("loadAllOfflineProgress")
        return []
    }
    
    public func deleteProgress(for blockID: String) {
        methodCalls.insert("deleteProgress")
    }
    
    public func deleteAllProgress() {
        methodCalls.insert("deleteAllProgress")
    }
    
    public func saveDownloadDataTask(_ task: DownloadDataTask) {
        methodCalls.insert("saveDownloadDataTask")
    }
    
    public func getDownloadDataTasks() async -> [DownloadDataTask] {
        methodCalls.insert("getDownloadDataTasks")
        return mockDownloadTasks
    }
    
    public func getDownloadDataTasksForCourse(_ courseId: String) async -> [DownloadDataTask] {
        methodCalls.insert("getDownloadDataTasksForCourse")
        return mockDownloadTasks
    }
    
    // Helper method to reset mock state
    public func reset() {
        methodCalls.removeAll()
        mockDownloadTasks.removeAll()
        mockDownloadTask = nil
    }
}
#endif

public final class CoreBundle {
    private init() {}
}

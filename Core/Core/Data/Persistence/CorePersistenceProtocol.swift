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
    
    public init() {}
    
    public func set(userId: Int) {}
    public func getUserID() -> Int? {1}
    public func publisher() -> AnyPublisher<Int, Never> { Just(0).eraseToAnyPublisher() }
    public func addToDownloadQueue(blocks: [CourseBlock], downloadQuality: DownloadQuality) {}
    public func addToDownloadQueue(tasks: [DownloadDataTask]) {}
    public func nextBlockForDownloading() -> DownloadDataTask? { nil }
    public func updateDownloadState(id: String, state: DownloadState, resumeData: Data?) {}
    public func deleteDownloadDataTask(id: String) throws {}
    public func downloadDataTask(for blockId: String) -> DownloadDataTask? { nil }
    public func saveOfflineProgress(progress: OfflineProgress) {}
    public func loadProgress(for blockID: String) -> OfflineProgress? { nil }
    public func loadAllOfflineProgress() -> [OfflineProgress] { [] }
    public func deleteProgress(for blockID: String) {}
    public func deleteAllProgress() {}
    public func saveDownloadDataTask(_ task: DownloadDataTask) {}
    public func getDownloadDataTasks() async -> [DownloadDataTask] {[]}
    public func getDownloadDataTasksForCourse(_ courseId: String) async -> [DownloadDataTask] {[]}
}
#endif

public final class CoreBundle {
    private init() {}
}

//
//  CorePersistence.swift
//  Core
//
//  Created by  Stepanok Ivan on 08.03.2023.
//

import CoreData
import Combine

public protocol CorePersistenceProtocol {
    func set(userId: Int)
    func getUserID() -> Int?
    func publisher() -> AnyPublisher<Int, Never>
    func addToDownloadQueue(blocks: [CourseBlock], downloadQuality: DownloadQuality)
    func addToDownloadQueue(tasks: [DownloadDataTask])
    func nextBlockForDownloading() -> DownloadDataTask?
    func updateDownloadState(id: String, state: DownloadState, resumeData: Data?)
    func deleteDownloadDataTask(id: String) throws
    func downloadDataTask(for blockId: String) -> DownloadDataTask?
    func downloadDataTask(for blockId: String, completion: @escaping (DownloadDataTask?) -> Void)
    func getDownloadDataTasks(completion: @escaping ([DownloadDataTask]) -> Void)
    func getDownloadDataTasksForCourse(_ courseId: String, completion: @escaping ([DownloadDataTask]) -> Void)
    func saveOfflineProgress(progress: OfflineProgress)
    func loadProgress(for blockID: String) -> OfflineProgress?
    func loadAllOfflineProgress() -> [OfflineProgress]
    func deleteProgress(for blockID: String)
    func deleteAllProgress()
}

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
    public func downloadDataTask(for blockId: String, completion: @escaping (DownloadDataTask?) -> Void) {}
    public func getDownloadDataTasks(completion: @escaping ([DownloadDataTask]) -> Void) {}
    public func getDownloadDataTasksForCourse(_ courseId: String, completion: @escaping ([DownloadDataTask]) -> Void) {}
    public func saveOfflineProgress(progress: OfflineProgress) {}
    public func loadProgress(for blockID: String) -> OfflineProgress? { nil }
    public func loadAllOfflineProgress() -> [OfflineProgress] { [] }
    public func deleteProgress(for blockID: String) {}
    public func deleteAllProgress() {}
}

public final class CoreBundle {
    private init() {}
}

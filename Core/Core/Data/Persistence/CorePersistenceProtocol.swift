//
//  CorePersistence.swift
//  Core
//
//  Created by  Stepanok Ivan on 08.03.2023.
//

import CoreData
import Combine

//sourcery: AutoMockable
public protocol CorePersistenceProtocol: Sendable {
    func set(userId: Int)
    func getUserID() -> Int?
    @MainActor func publisher() throws -> AnyPublisher<Int, Never>
    func addToDownloadQueue(tasks: [DownloadDataTask])
    func saveOfflineProgress(progress: OfflineProgress) async
    func loadProgress(for blockID: String) async -> OfflineProgress?
    func loadAllOfflineProgress() async -> [OfflineProgress]
    func deleteProgress(for blockID: String) async
    func deleteAllProgress() async

    func addToDownloadQueue(blocks: [CourseBlock], downloadQuality: DownloadQuality)
    func updateDownloadState(id: String, state: DownloadState, resumeData: Data?)
    func saveDownloadDataTask(_ task: DownloadDataTask) async
    func downloadDataTask(for blockId: String) async -> DownloadDataTask?
    func getDownloadDataTasks() async -> [DownloadDataTask]
    func getDownloadDataTasksForCourse(_ courseId: String) async -> [DownloadDataTask]
    func deleteDownloadDataTasks(ids: [String])
}

#if DEBUG
public final class CorePersistenceMock: CorePersistenceProtocol, @unchecked Sendable {
    public init() {}
    public func set(userId: Int) {}
    public func getUserID() -> Int? {1}
    public func publisher() -> AnyPublisher<Int, Never> { Just(0).eraseToAnyPublisher() }
    public func addToDownloadQueue(blocks: [CourseBlock], downloadQuality: DownloadQuality) {}
    public func addToDownloadQueue(tasks: [DownloadDataTask]) {}
    public func updateDownloadState(id: String, state: DownloadState, resumeData: Data?) {}
    public func downloadDataTask(for blockId: String) async -> DownloadDataTask? { nil }
    public func saveOfflineProgress(progress: OfflineProgress) async {}
    public func loadProgress(for blockID: String) async -> OfflineProgress? { nil }
    public func loadAllOfflineProgress() async -> [OfflineProgress] { [] }
    public func deleteProgress(for blockID: String) async {}
    public func deleteAllProgress() async {}
    public func saveDownloadDataTask(_ task: DownloadDataTask) async {}
    public func getDownloadDataTasks() async -> [DownloadDataTask] {[]}
    public func getDownloadDataTasksForCourse(_ courseId: String) async -> [DownloadDataTask] {[]}
    public func deleteDownloadDataTasks(ids: [String]) {}
}
#endif

public final class CoreBundle {
    private init() {}
}

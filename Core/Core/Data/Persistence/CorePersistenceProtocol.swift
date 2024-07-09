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
    func addToDownloadQueue(blocks: [CourseBlock], downloadQuality: DownloadQuality) async
    func nextBlockForDownloading() async -> DownloadDataTask?
    func updateDownloadState(id: String, state: DownloadState, resumeData: Data?)
    func deleteDownloadDataTask(id: String) async throws
    func saveDownloadDataTask(_ task: DownloadDataTask)
    func downloadDataTask(for blockId: String) -> DownloadDataTask?
    func getDownloadDataTasks() async -> [DownloadDataTask]
    func getDownloadDataTasksForCourse(_ courseId: String) async -> [DownloadDataTask]
}

public final class CoreBundle {
    private init() {}
}

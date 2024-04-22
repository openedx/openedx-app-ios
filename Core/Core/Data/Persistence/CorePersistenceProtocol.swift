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
    func nextBlockForDownloading() -> DownloadDataTask?
    func updateDownloadState(id: String, state: DownloadState, resumeData: Data?)
    func deleteDownloadDataTask(id: String) throws
    func saveDownloadDataTask(_ task: DownloadDataTask)
    func downloadDataTask(for blockId: String) -> DownloadDataTask?
    func downloadDataTask(for blockId: String, completion: @escaping (DownloadDataTask?) -> Void)
    func getDownloadDataTasks(completion: @escaping ([DownloadDataTask]) -> Void)
    func getDownloadDataTasksForCourse(_ courseId: String, completion: @escaping ([DownloadDataTask]) -> Void)
}

public final class CoreBundle {
    private init() {}
}

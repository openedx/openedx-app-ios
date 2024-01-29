//
//  CorePersistence.swift
//  Core
//
//  Created by  Stepanok Ivan on 08.03.2023.
//

import CoreData
import Combine

public protocol CorePersistenceProtocol {
    func publisher() -> AnyPublisher<Int, Never>
    func addToDownloadQueue(blocks: [CourseBlock], downloadQuality: DownloadQuality)
    func getNextBlockForDownloading() -> DownloadDataTask?
    func updateDownloadState(id: String, state: DownloadState, resumeData: Data?)
    func deleteDownloadDataTask(id: String) throws
    func saveDownloadDataTask(data: DownloadDataTask)
    func downloadDataTask(for blockId: String) -> DownloadDataTask?
    func downloadDataTask(for blockId: String, completion: @escaping (DownloadDataTask?) -> Void)
    func getDownloadDataTasks(completion: @escaping ([DownloadDataTask]) -> Void)
    func getDownloadDataTasksForCourse(_ courseId: String, completion: @escaping ([DownloadDataTask]) -> Void)
}

public final class CoreBundle {
    private init() {}
}

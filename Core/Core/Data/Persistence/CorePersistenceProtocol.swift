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
    func addToDownloadQueue(blocks: [CourseBlock])
    func getNextBlockForDownloading() -> DownloadData?
    func updateDownloadState(id: String, state: DownloadState, resumeData: Data?)
    func deleteDownloadData(id: String) throws
    func saveDownloadData(data: DownloadData)
    func downloadData(by blockId: String) -> DownloadData?
    func downloadData(by blockId: String, completion: @escaping (DownloadData?) -> Void)
    func getAllDownloadData(completion: @escaping ([DownloadData]) -> Void)
    func getDownloadsForCourse(_ courseId: String, completion: @escaping ([DownloadData]) -> Void)
}

public final class CoreBundle {
    private init() {}
}

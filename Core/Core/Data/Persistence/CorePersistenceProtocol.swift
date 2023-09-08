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
    func getAllDownloadData() -> [DownloadData]
    func addToDownloadQueue(blocks: [CourseBlock])
    func getNextBlockForDownloading() -> DownloadData?
    func getDownloadsForCourse(_ courseId: String) -> [DownloadData]
    func downloadData(by blockId: String) -> DownloadData?
    func updateDownloadState(id: String, state: DownloadState, path: String?, resumeData: Data?)
    func deleteDownloadData(id: String) throws
    func saveDownloadData(data: DownloadData)
}

public final class CoreBundle {
    private init() {}
}

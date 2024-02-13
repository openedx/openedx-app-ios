//
//  CorePersistence.swift
//  OpenEdX
//
//  Created by  Stepanok Ivan on 25.07.2023.
//

import Core
import Foundation
import CoreData
import Combine

public class CorePersistence: CorePersistenceProtocol {

    // MARK: - Predicate

    enum CDPredicate {
        case id(String)
        case courseId(String)
        case state(String)

        var predicate: NSPredicate {
            switch self {
            case let .id(args):
                NSPredicate(format: "id = %@", args)
            case .courseId(let args):
                NSPredicate(format: "courseId = %@", args)
            case .state(let args):
                NSPredicate(format: "state != %@", args)
            }
        }
    }

    // MARK: - Properties

    private var context: NSManagedObjectContext
    private var userId: Int?

    public init(context: NSManagedObjectContext) {
        self.context = context
    }

    public func set(userId: Int) {
        self.userId = userId
    }

    public func getUserID() -> Int? {
        userId
    }

    // MARK: - Public Intents

    public func addToDownloadQueue(
        blocks: [CourseBlock],
        downloadQuality: DownloadQuality
    ) {
        for block in blocks {
            let downloadDataId = downloadDataId(from: block.id)

            let data = try? fetchCDDownloadData(
                predicate: CDPredicate.id(downloadDataId)
            )
            guard data?.first == nil else { continue }

            guard let video = block.encodedVideo?.video(downloadQuality: downloadQuality),
                  let url = video.url,
                  let fileExtension = URL(string: url)?.pathExtension
            else { continue }

            let fileName = "\(block.id).\(fileExtension)"
            context.performAndWait {
                let newDownloadData = CDDownloadData(context: context)
                context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
                newDownloadData.id = downloadDataId
                newDownloadData.blockId = block.id
                newDownloadData.userId = getUserId32() ?? 0
                newDownloadData.courseId = block.courseId
                newDownloadData.url = url
                newDownloadData.fileName = fileName
                newDownloadData.displayName = block.displayName
                newDownloadData.progress = .zero
                newDownloadData.resumeData = nil
                newDownloadData.state = DownloadState.waiting.rawValue
                newDownloadData.type = DownloadType.video.rawValue
                newDownloadData.fileSize = Int32(video.fileSize ?? 0)
            }
        }
    }

    public func getDownloadDataTasks(completion: @escaping ([DownloadDataTask]) -> Void) {
        context.performAndWait {
            guard let data = try? fetchCDDownloadData() else {
                completion([])
                return
            }

            let downloads = data.downloadDataTasks()

            completion(downloads)
        }
    }

    public func getDownloadDataTasksForCourse(
        _ courseId: String,
        completion: @escaping ([DownloadDataTask]) -> Void
    ) {
        context.performAndWait {
            guard let data = try? fetchCDDownloadData(
                predicate: .courseId(courseId)
            ) else {
                completion([])
                return
            }

            if data.isEmpty {
                completion([])
                return
            }

            let downloads = data
                .downloadDataTasks()
                .filter(userId: userId)

            completion(downloads)
        }
    }

    public func downloadDataTask(
        for blockId: String,
        completion: @escaping (DownloadDataTask?) -> Void
    ) {
        context.performAndWait {
            let data = try? fetchCDDownloadData(
                predicate: .id(downloadDataId(from: blockId))
            )

            guard let downloadData = data?.first else {
                completion(nil)
                return
            }

            let downloadDataTask = DownloadDataTask(sourse: downloadData)

            completion(downloadDataTask)
        }
    }

    public func downloadDataTask(for blockId: String) -> DownloadDataTask? {
        let data = try? fetchCDDownloadData(
            predicate: .id(downloadDataId(from: blockId))
        )

        guard let downloadData = data?.first else { return nil }

        return DownloadDataTask(sourse: downloadData)
    }

    public func nextBlockForDownloading() -> DownloadDataTask? {
        let data = try? fetchCDDownloadData(
            predicate: .state(DownloadState.finished.rawValue),
            fetchLimit: 1
        )

        guard let downloadData = data?.first else {
            return nil
        }

        return DownloadDataTask(sourse: downloadData)
    }

    public func updateDownloadState(
        id: String,
        state: DownloadState,
        resumeData: Data?
    ) {
        context.performAndWait {
            guard let data = try? fetchCDDownloadData(
                predicate: .id(downloadDataId(from: id))
            ) else {
                return
            }

            guard let task = data.first else { return }

            task.state = state.rawValue
            if state == .finished { task.progress = 1 }
            task.resumeData = resumeData

            do {
                try context.save()
            } catch {
                debugLog("⛔️⛔️⛔️⛔️⛔️", error)
            }
        }
    }

    public func deleteDownloadDataTask(id: String) throws {
        context.performAndWait {
            do {
                let records = try fetchCDDownloadData(
                    predicate: .id(downloadDataId(from: id))
                )

                for record in records {
                    context.delete(record)
                    try context.save()
                    debugLog("File erased successfully")
                }

            } catch {
                debugLog("Error fetching records: \(error.localizedDescription)")
            }
        }
    }
    
    public func saveDownloadDataTask(_ task: DownloadDataTask) {
        context.performAndWait {
            let newDownloadData = CDDownloadData(context: context)
            context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            newDownloadData.id = task.id
            newDownloadData.blockId = task.blockId
            newDownloadData.userId = Int32(task.userId)
            newDownloadData.courseId = task.courseId
            newDownloadData.url = task.url
            newDownloadData.progress = task.progress
            newDownloadData.fileName = task.fileName
            newDownloadData.displayName = task.displayName
            newDownloadData.resumeData = task.resumeData
            newDownloadData.state = task.state.rawValue
            newDownloadData.type = task.type.rawValue
            newDownloadData.fileSize = Int32(task.fileSize)

            do {
                try context.save()
            } catch {
                debugLog("⛔️⛔️⛔️⛔️⛔️", error)
            }
        }
    }

    public func publisher() -> AnyPublisher<Int, Never> {
        let notification = NSManagedObjectContext.didChangeObjectsNotification
        return NotificationCenter.default.publisher(for: notification, object: context)
            .compactMap({ notification in
                guard let userInfo = notification.userInfo else { return nil }

                if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>, inserts.count > 0 {
                    return inserts.count
                }

                if let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject>, updates.count > 0 {
                    return updates.count
                }

                if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>, deletes.count > 0 {
                    return deletes.count
                }

                return nil
            })
            .eraseToAnyPublisher()
    }

    // MARK: - Private Intents

    private func fetchCDDownloadData(
        predicate: CDPredicate? = nil,
        fetchLimit: Int? = nil
    ) throws -> [CDDownloadData] {
        let request = CDDownloadData.fetchRequest()
        if let predicate = predicate {
            request.predicate = predicate.predicate
        }
        if let fetchLimit = fetchLimit {
            request.fetchLimit = fetchLimit
        }
        let data = try context.fetch(request).filter {
            guard let userId = getUserId32() else {
                return true
            }
            debugLog(userId, "-userId-")
            return $0.userId == userId
        }
        return data
    }

    private func getUserId32() -> Int32? {
        guard let userId else {
            return nil
        }
        return Int32(userId)
    }

    private func downloadDataId(from id: String) -> String {
        guard let userId else {
            return id
        }
        if id.contains(String(userId)) {
            return id
        }
        return "\(userId)_\(id)"
    }
}

extension Array where Element == DownloadDataTask {
    func filter(userId: Int?) -> [DownloadDataTask] {
        filter {
            guard let userId else {
                return true
            }
            return $0.userId == userId
        }
    }
}

extension Array where Element == CDDownloadData {
    func downloadDataTasks() -> [DownloadDataTask] {
        compactMap { DownloadDataTask(sourse: $0) }
    }
}

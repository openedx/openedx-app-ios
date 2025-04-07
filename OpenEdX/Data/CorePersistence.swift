//
//  CorePersistence.swift
//  OpenEdX
//
//  Created by  Stepanok Ivan on 25.07.2023.
//

import Core
import OEXFoundation
import Foundation
@preconcurrency import CoreData
@preconcurrency import Combine

public final class CorePersistence: CorePersistenceProtocol {
    
    struct CorePersistenceHelper {
        static func fetchCDDownloadData(
            predicate: CDPredicate? = nil,
            fetchLimit: Int? = nil,
            context: NSManagedObjectContext,
            userId: Int32?
        ) throws -> [CDDownloadData] {
            let request = CDDownloadData.fetchRequest()
            if let predicate = predicate {
                request.predicate = predicate.predicate
            }
            if let fetchLimit = fetchLimit {
                request.fetchLimit = fetchLimit
            }
            let data = try context.fetch(request).filter {
                guard let userId = userId else {
                    return true
                }
                debugLog(userId, "-userId-")
                return $0.userId == userId
            }
            return data
        }
    }
    // MARK: - Predicate

    enum CDPredicate {
        case id(String)
        case courseId(String)
        case state(String)

        var predicate: NSPredicate {
            switch self {
            case .id(let id):
                NSPredicate(format: "id = %@", id)
            case .courseId(let courseId):
                NSPredicate(format: "courseId = %@", courseId)
            case .state(let state):
                NSPredicate(format: "state != %@", state)
            }
        }
    }

    // MARK: - Properties

    private nonisolated(unsafe) var userId: Int?

    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    public init(container: NSPersistentContainer) {
        self.container = container
        self.context = container.newBackgroundContext()
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
        let userId = getUserId32() ?? 0
        let objects: [[String: Any]] = blocks.compactMap { block -> [String: Any]? in
            let downloadDataId = downloadDataId(from: block.id)
            var fileExtension: String?
            let url: String
            var fileSize: Int32?
            var fileName: String?
            
            if let html = block.offlineDownload {
                let fileUrl = html.fileUrl
                url = fileUrl
                fileSize = Int32(html.fileSize)
                fileExtension = URL(string: fileUrl)?.pathExtension
                if let folderName = URL(string: fileUrl)?.lastPathComponent,
                   let folderUrl = URL(string: folderName)?.deletingPathExtension() {
                    fileName = folderUrl.absoluteString
                }
            } else if let encodedVideo = block.encodedVideo,
                      let video = encodedVideo.video(downloadQuality: downloadQuality),
                      let videoUrl = video.url {
                url = videoUrl
                if let videoFileSize = video.fileSize {
                    fileSize = Int32(videoFileSize)
                }
                fileExtension = URL(string: videoUrl)?.pathExtension
                fileName = "\(block.id).\(fileExtension ?? "")"
            } else { return nil }
            
            var dictionary = [
                "id": downloadDataId,
                "blockId": block.id,
                "userId": userId,
                "courseId": block.courseId,
                "url": url,
                "fileName": fileName ?? "",
                "displayName": block.displayName,
                "progress": Double.zero,
                "state": DownloadState.waiting.rawValue,
                "type": block.offlineDownload != nil ? DownloadType.html.rawValue : DownloadType.video.rawValue,
                "fileSize": fileSize ?? 0,
                "actualSize": 0
            ]
            if let lastModified = block.offlineDownload?.lastModified {
                dictionary["lastModified"] = lastModified
            }
            return dictionary
        }
        
        insertDownloadData(objects: objects)
    }
    
    public func addToDownloadQueue(tasks: [DownloadDataTask]) {
        let objects: [[String: Any]] = tasks.map { task in
            [
                "id": downloadDataId(from: task.id),
                "blockId": task.blockId,
                "userId": task.userId,
                "courseId": task.courseId,
                "url": task.url,
                "fileName": task.fileName,
                "displayName": task.displayName,
                "progress": task.progress,
                "state": task.state,
                "type": task.type,
                "fileSize": task.fileSize,
                "actualSize": task.actualSize
            ]
        }
        insertDownloadData(objects: objects)
    }
    
    func insertDownloadData(objects: [[String: Any]]) {
        let batchInsertRequest = NSBatchInsertRequest(entityName: "CDDownloadData", objects: objects)
        batchInsertRequest.resultType = .objectIDs
        context.perform { [context] in
            do {
                let batchInsertResult = try context.execute(batchInsertRequest) as? NSBatchInsertResult
                if let objectIDs = batchInsertResult?.result as? [NSManagedObjectID] {
                    NSManagedObjectContext.mergeChanges(
                        fromRemoteContextSave: [NSInsertedObjectsKey: objectIDs],
                        into: [context]
                    )
                }
            } catch {
                debugLog("⛔️⛔️⛔️⛔️⛔️", error)
            }
        }
    }
    
    private func perform<T>(block: @escaping () -> T) async -> T {
        await withCheckedContinuation { continuation in
            context.perform {
                let result = block()
                continuation.resume(returning: result)
            }
        }
    }

    public func getDownloadDataTasks() async -> [DownloadDataTask] {
        let userId = getUserId32() ?? 0
        return await perform {[context] in
            guard let data = try? CorePersistenceHelper.fetchCDDownloadData(
                context: context,
                userId: userId
            ) else {
                return []
            }

            let downloads = data.downloadDataTasks()

            return downloads
        }
    }

    public func getDownloadDataTasksForCourse(
        _ courseId: String
    ) async -> [DownloadDataTask] {
        let uID = userId
        let int32Id = getUserId32()
        return await perform { [context] in
            guard let data = try? CorePersistenceHelper.fetchCDDownloadData(
                predicate: .courseId(courseId),
                context: context,
                userId: int32Id
            ) else {
                return []
            }

            if data.isEmpty {
                return []
            }

            let downloads = data
                .downloadDataTasks()
                .filter(userId: uID)

            return downloads
        }
    }

    public func downloadDataTask(for blockId: String) async -> DownloadDataTask? {
        let dataId = downloadDataId(from: blockId)
        let userId = getUserId32()
        return await perform { [context] in
            let data = try? CorePersistenceHelper.fetchCDDownloadData(
                predicate: .id(dataId),
                context: context,
                userId: userId
            )

            guard let downloadData = data?.first else {
                return nil
            }

            return DownloadDataTask(sourse: downloadData)
        }
    }

    public func updateTask(task: DownloadDataTask) {
        let dataId = downloadDataId(from: task.id)
        let userId = getUserId32()

        context.perform { [context] in
            guard let data = try? CorePersistenceHelper.fetchCDDownloadData(
                predicate: .id(dataId),
                context: context,
                userId: userId
            ) else {
                return
            }

            guard let dataTask = data.first else { return }

            dataTask.state = task.state.rawValue
            dataTask.resumeData = task.resumeData
            dataTask.url = task.url
            dataTask.fileName = task.fileName
            dataTask.progress = task.progress
            dataTask.type = task.type.rawValue
            dataTask.fileSize = Int64(task.fileSize)
            dataTask.actualSize = Int64(task.actualSize)
            
            if task.state == .finished { dataTask.progress = 1 }

            do {
                try context.save()
            } catch {
                debugLog("⛔️⛔️⛔️⛔️⛔️", error)
            }
        }
    }
    public func deleteDownloadDataTasks(ids: [String]) {
        context.perform { [context] in
            let request: NSFetchRequest<any NSFetchRequestResult> = CDDownloadData.fetchRequest()
            request.predicate = NSPredicate(format: "id IN %@", ids)
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: request)
            batchDeleteRequest.resultType = .resultTypeObjectIDs
            
            do {
                let deleteResult = try context.execute(batchDeleteRequest) as? NSBatchDeleteResult
                
                if let objectIDs = deleteResult?.result as? [NSManagedObjectID] {
                    NSManagedObjectContext.mergeChanges(
                        fromRemoteContextSave: [NSDeletedObjectsKey: objectIDs],
                        into: [context]
                    )
                }
                debugLog("Tasks erased successfully")
            } catch {
                debugLog("Error deleting tasks: \(error.localizedDescription)")
            }
        }
    }

    public func publisher() throws -> AnyPublisher<Int, Never> {
        let notification = NSManagedObjectContext.didChangeObjectsNotification
        return NotificationCenter.default.publisher(for: notification, object: container.viewContext)
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
    
    // MARK: - Offline Progress
    public func saveOfflineProgress(progress: OfflineProgress) async {
        await perform { [context] in
            let progressForSaving = CDOfflineProgress(context: context)
            context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            progressForSaving.blockID = progress.blockID
            progressForSaving.progressJson = progress.progressJson
            
            do {
                try context.save()
            } catch {
                debugLog("⛔️⛔️⛔️⛔️⛔️", error)
            }
        }
    }
    
    public func loadProgress(for blockID: String) async -> OfflineProgress? {
        await perform { [context] in
            let request = CDOfflineProgress.fetchRequest()
            request.predicate = NSPredicate(format: "blockID = %@", blockID)
            guard let progress = try? context.fetch(request).first,
                  let savedBlockID = progress.blockID,
                  let progressJson = progress.progressJson,
                  blockID == savedBlockID else { return nil }
            
            return OfflineProgress(
                progressJson: progressJson
            )
        }
    }
    
    public func loadAllOfflineProgress() async -> [OfflineProgress] {
        await perform { [context] in
            let result = try? context.fetch(CDOfflineProgress.fetchRequest())
                .map {
                    OfflineProgress(
                        progressJson: $0.progressJson ?? ""
                    )}
            if let result, !result.isEmpty {
                return result
            } else {
                return []
            }
        }
    }
    
    public func deleteProgress(for blockID: String) async {
        await perform { [context] in
            let request = CDOfflineProgress.fetchRequest()
            request.predicate = NSPredicate(format: "blockID = %@", blockID)
            guard let progress = try? context.fetch(request).first else { return }
            
            do {
                context.delete(progress)
                try context.save()
                debugLog("File erased successfully")
            } catch {
                debugLog("Error deleteing progress: \(error.localizedDescription)")
            }
        }
    }
    
    public func deleteAllProgress() async {
        await perform { [context] in
            let request = CDOfflineProgress.fetchRequest()
            guard let allProgress = try? context.fetch(request) else { return }
            
            do {
                for progress in allProgress {
                    context.delete(progress)
                    try context.save()
                    debugLog("File erased successfully")
                }
            } catch {
                debugLog("Error deleteing progress: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Private Intents

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
        if id.contains(String("\(userId)_")) {
            return id
        }
        return "\(userId)_\(id)"
    }
}

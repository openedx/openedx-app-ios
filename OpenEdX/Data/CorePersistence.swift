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
            var fileExtension: String?
            var url: String?
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
                saveDownloadData()
            } else if let encodedVideo = block.encodedVideo,
                      let video = encodedVideo.video(downloadQuality: downloadQuality),
                      let videoUrl = video.url {
                url = videoUrl
                if let videoFileSize = video.fileSize {
                    fileSize = Int32(videoFileSize)
                }
                fileExtension = URL(string: videoUrl)?.pathExtension
                fileName = "\(block.id).\(fileExtension ?? "")"
                saveDownloadData()
            } else {
                continue
            }
            
            func saveDownloadData() {
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
                    if let lastModified = block.offlineDownload?.lastModified {
                        newDownloadData.lastModified = lastModified
                    }
                    newDownloadData.progress = .zero
                    newDownloadData.resumeData = nil
                    newDownloadData.state = DownloadState.waiting.rawValue
                    newDownloadData.type = block.offlineDownload != nil
                    ? DownloadType.html.rawValue
                    : DownloadType.video.rawValue
                    newDownloadData.fileSize = Int32(fileSize ?? 0)
                }
            }
        }
    }
    
    public func addToDownloadQueue(tasks: [DownloadDataTask]) {
        for task in tasks {
            context.performAndWait {
                let newDownloadData = CDDownloadData(context: context)
                context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
                newDownloadData.id = task.id
                newDownloadData.blockId = task.blockId
                newDownloadData.userId = Int32(task.userId)
                newDownloadData.courseId = task.courseId
                newDownloadData.url = task.url
                newDownloadData.fileName = task.fileName
                newDownloadData.displayName = task.displayName
                newDownloadData.lastModified = task.lastModified
                newDownloadData.progress = .zero
                newDownloadData.resumeData = nil
                newDownloadData.state = DownloadState.waiting.rawValue
                newDownloadData.type = task.type.rawValue
                newDownloadData.fileSize = Int32(task.fileSize)
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
    
    // MARK: - Offline Progress
    public func saveOfflineProgress(progress: OfflineProgress) {
        context.performAndWait {
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
    
    public func loadProgress(for blockID: String) -> OfflineProgress? {
        context.performAndWait {
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
    
    public func loadAllOfflineProgress() -> [OfflineProgress] {
        context.performAndWait {
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
    
    public func deleteProgress(for blockID: String) {
        context.performAndWait {
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
    
    public func deleteAllProgress() {
        context.performAndWait {
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

    private func fetchCDDownloadData(
        predicate: CDPredicate? = nil,
        fetchLimit: Int? = nil
    ) throws -> [CDDownloadData] {
        let request = CDDownloadData.fetchRequest()
        
        var predicates = [NSPredicate]()
        
        if let predicate = predicate {
            predicates.append(predicate.predicate)
        }
        
        if let userId = getUserId32() {
            let userIdNumber = NSNumber(value: userId)
            let userIdPredicate = NSPredicate(format: "userId == %@", userIdNumber)
            predicates.append(userIdPredicate)
        }
        
        if !predicates.isEmpty {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        }
        
        if let fetchLimit = fetchLimit {
            request.fetchLimit = fetchLimit
        }
        
        return try context.fetch(request)
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

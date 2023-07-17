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
    func getDownloadsForCourse(_ courseId: String) -> [DownloadData]
    func downloadData(by blockId: String) -> DownloadData?
    func updateDownloadState(id: String, state: DownloadState, resumeData: Data?)
    func deleteDownloadData(id: String) throws
    func saveDownloadData(data: DownloadData)
}

public class CorePersistence: CorePersistenceProtocol {
    
    public init() {}
    
    private let model = "CoreDataModel"
    
    private lazy var persistentContainer: NSPersistentContainer = {
      return createContainer()
    }()
    
    private lazy var context: NSManagedObjectContext = {
        return createContext()
    }()
    
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
    
    public func addToDownloadQueue(blocks: [CourseBlock]) {
        for block in blocks {
            let request = CDDownloadData.fetchRequest()
            request.predicate = NSPredicate(format: "id = %@", block.id)
            guard (try? context.fetch(request).first) == nil else { continue }
            guard let url = block.videoUrl,
                  let fileName = URL(string: url)?.lastPathComponent else { continue }
            context.performAndWait {
                let newDownloadData = CDDownloadData(context: context)
                context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
                newDownloadData.id = block.id
                newDownloadData.courseId = block.courseId
                newDownloadData.url = url
                newDownloadData.fileName = fileName
                newDownloadData.progress = .zero
                newDownloadData.resumeData = nil
                newDownloadData.state = DownloadState.waiting.rawValue
                newDownloadData.type = DownloadType.video.rawValue
            }
        }
    }
    
    public func getNextBlockForDownloading() -> DownloadData? {
        let request = CDDownloadData.fetchRequest()
        request.predicate = NSPredicate(format: "state != %@", DownloadState.finished.rawValue)
        request.fetchLimit = 1
        guard let data = try? context.fetch(request).first else { return nil }
        return DownloadData(
            id: data.id ?? "",
            courseId: data.courseId ?? "",
            url: data.url ?? "",
            fileName: data.fileName ?? "",
            progress: data.progress,
            resumeData: data.resumeData,
            state: DownloadState(rawValue: data.state ?? "") ?? .waiting,
            type: DownloadType(rawValue: data.type ?? "" ) ?? .video
        )
    }
    
    public func getDownloadsForCourse(_ courseId: String) -> [DownloadData] {
        let request = CDDownloadData.fetchRequest()
        request.predicate = NSPredicate(format: "courseId = %@", courseId)
        guard let downloadData = try? context.fetch(request) else { return [] }
        return downloadData.map {
            DownloadData(
                id: $0.id ?? "",
                courseId: $0.courseId ?? "",
                url: $0.url ?? "",
                fileName: $0.fileName ?? "",
                progress: $0.progress,
                resumeData: $0.resumeData,
                state: DownloadState(rawValue: $0.state ?? "") ?? .waiting,
                type: DownloadType(rawValue: $0.type ?? "") ?? .video
            )
        }
    }
    
    public func downloadData(by blockId: String) -> DownloadData? {
        let request = CDDownloadData.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", blockId)
        guard let downloadData = try? context.fetch(request).first else { return nil }
        return DownloadData(
            id: downloadData.id ?? "",
            courseId: downloadData.courseId ?? "",
            url: downloadData.url ?? "",
            fileName: downloadData.fileName ?? "",
            progress: downloadData.progress,
            resumeData: downloadData.resumeData,
            state: DownloadState(rawValue: downloadData.state ?? "") ?? .paused,
            type: DownloadType(rawValue: downloadData.type ?? "" ) ?? .video
        )
    }
    
    public func updateDownloadState(id: String, state: DownloadState, resumeData: Data?) {
        context.performAndWait {
            let request = CDDownloadData.fetchRequest()
            request.predicate = NSPredicate(format: "id = %@", id)
            guard let downloadData = try? context.fetch(request).first else { return }
            downloadData.state = state.rawValue
            downloadData.resumeData = resumeData
            do {
                try context.save()
            } catch {
                print("⛔️⛔️⛔️⛔️⛔️", error)
            }
        }
    }
    
    public func deleteDownloadData(id: String) throws {
        let request = CDDownloadData.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id)
        do {
            let records = try context.fetch(request)
            for record in records {
                context.delete(record)
                try context.save()
                print("File erased successfully")
            }
        } catch {
            print("Error fetching records: \(error.localizedDescription)")
        }
    }
    
    public func saveDownloadData(data: DownloadData) {
        context.performAndWait {
            let newDownloadData = CDDownloadData(context: context)
            context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            newDownloadData.id = data.id
            newDownloadData.courseId = data.courseId
            newDownloadData.url = data.url
            newDownloadData.progress = data.progress
            newDownloadData.fileName = data.fileName
            newDownloadData.resumeData = data.resumeData
            newDownloadData.state = data.state.rawValue
            
            do {
                try context.save()
            } catch {
                print("⛔️⛔️⛔️⛔️⛔️", error)
            }
        }
    }
    
    private func createContainer() -> NSPersistentContainer {
        let bundle = Bundle(for: Self.self)
        let url = bundle.url(forResource: model, withExtension: "momd")
        let managedObjectModel = NSManagedObjectModel(contentsOf: url!)
        let container = NSPersistentContainer(name: model, managedObjectModel: managedObjectModel!)
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        let description = NSPersistentStoreDescription()
        description.shouldInferMappingModelAutomatically = true
        description.shouldMigrateStoreAutomatically = true
        container.persistentStoreDescriptions = [description]
        
        return container
    }
    
    private func createContext() -> NSManagedObjectContext {
        let context = persistentContainer.newBackgroundContext()
        context.automaticallyMergesChangesFromParent = true
        return context
    }
}

//
//  DiscoveryPersistence.swift
//  Discovery
//
//  Created by  Stepanok Ivan on 14.12.2022.
//

import CoreData
import Core

public protocol DiscoveryPersistenceProtocol {
    func loadDiscovery() throws -> [CourseItem]
    func saveDiscovery(items: [CourseItem])
    func clear()
}

public class DiscoveryPersistence: DiscoveryPersistenceProtocol {
    
    private let model = "DiscoveryCoreModel"
    
    private lazy var persistentContainer: NSPersistentContainer = {
        return createContainer()
    }()
    
    private lazy var context: NSManagedObjectContext = {
        return createContext()
    }()
    
    public init() {}
    
    public func loadDiscovery() throws -> [CourseItem] {
        let result = try? context.fetch(CDCourseItem.fetchRequest())
            .map { CourseItem(name: $0.name ?? "",
                              org: $0.org ?? "",
                              shortDescription: $0.desc ?? "",
                              imageURL: $0.imageURL ?? "",
                              isActive: $0.isActive,
                              courseStart: $0.courseStart,
                              courseEnd: $0.courseEnd,
                              enrollmentStart: $0.enrollmentStart,
                              enrollmentEnd: $0.enrollmentEnd,
                              courseID: $0.courseID ?? "",
                              certificate: Certificate(url: $0.certificate  ?? ""),
                              numPages: Int($0.numPages),
                              coursesCount: Int($0.courseCount))}
        if let result, !result.isEmpty {
            return result
        } else {
            throw NoCachedDataError()
        }
    }
    
    public func saveDiscovery(items: [CourseItem]) {
        for item in items {
            context.performAndWait {
                let newItem = CDCourseItem(context: context)
                context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
                newItem.name = item.name
                newItem.org = item.org
                newItem.desc = item.shortDescription
                newItem.imageURL = item.imageURL
                if let isActive = item.isActive {
                    newItem.isActive = isActive
                }
                newItem.courseStart = item.courseStart
                newItem.courseEnd = item.courseEnd
                newItem.enrollmentStart = item.enrollmentStart
                newItem.enrollmentEnd = item.enrollmentEnd
                newItem.certificate = item.certificate?.url
                newItem.numPages = Int32(item.numPages)
                newItem.courseID = item.courseID
                
                do {
                    try context.save()
                } catch {
                    print("⛔️⛔️⛔️⛔️⛔️", error)
                }
            }
        }
    }
    
    public func clear() {
        let storeContainer = persistentContainer.persistentStoreCoordinator
        for store in storeContainer.persistentStores {
            do {
                try storeContainer.destroyPersistentStore(
                    at: store.url!,
                    ofType: store.type,
                    options: nil
                )
            } catch {
                print("⛔️⛔️⛔️⛔️⛔️", error)
            }
        }
        
        // Re-create the persistent container
        persistentContainer = createContainer()
        context = createContext()
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
        return container
    }
    
    private func createContext() -> NSManagedObjectContext {
        let context = persistentContainer.newBackgroundContext()
        context.automaticallyMergesChangesFromParent = true
        return context
    }
}

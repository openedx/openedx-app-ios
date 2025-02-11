//
//  Persistence.swift
//  OpenEdX
//
//  Created by  Stepanok Ivan on 25.07.2023.
//

import Foundation
@preconcurrency import CoreData
import Core
import Discovery
import Dashboard
import Course
import Profile

final class DatabaseManager: CoreDataHandlerProtocol {
    
    private let databaseName: String
        
    private let bundles: [Bundle] = [
        Bundle(for: CoreBundle.self),
        Bundle(for: DiscoveryBundle.self),
        Bundle(for: DashboardBundle.self),
        Bundle(for: CourseBundle.self),
        Bundle(for: ProfileBundle.self)
    ]
        
    private nonisolated(unsafe) var persistentContainer: NSPersistentContainer?
    
    public func getPersistentContainer() -> NSPersistentContainer {
        if persistentContainer == nil {
           persistentContainer = createContainer()
        }
        return persistentContainer!
    }
    
    init(databaseName: String) {
        self.databaseName = databaseName
    }
    
    private func createContainer() -> NSPersistentContainer {
        let model = NSManagedObjectModel.mergedModel(from: bundles)!
        let container = NSPersistentContainer(name: databaseName, managedObjectModel: model)
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Unresolved error \(error)")
                fatalError()
            }
        }

        let description = NSPersistentStoreDescription()
        description.shouldInferMappingModelAutomatically = true
        description.shouldMigrateStoreAutomatically = true
        container.persistentStoreDescriptions = [description]
        
        return container
    }
    
    private func createContext() -> NSManagedObjectContext {
        let context = getPersistentContainer().newBackgroundContext()
        context.automaticallyMergesChangesFromParent = true
        return context
    }
    
    public func clear() {
        let storeContainer = getPersistentContainer().persistentStoreCoordinator
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
        getPersistentContainer().loadPersistentStores { _, error in
            if let error = error {
                print("Unresolved error \(error)")
                fatalError()
            }
        }
    }
}

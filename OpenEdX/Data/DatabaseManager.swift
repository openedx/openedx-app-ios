//
//  Persistence.swift
//  OpenEdX
//
//  Created by  Stepanok Ivan on 25.07.2023.
//

import Foundation
import CoreData
import Core
import Discovery
import Dashboard
import Course

class DatabaseManager: CoreDataHandlerProtocol {
    
    private let databaseName: String
        
    private let bundles: [Bundle] = [
        Bundle(for: CoreBundle.self),
        Bundle(for: DiscoveryBundle.self),
        Bundle(for: DashboardBundle.self),
        Bundle(for: CourseBundle.self)
    ]
            
    private lazy var persistentContainer: NSPersistentContainer = {
      return createContainer()
    }()
    
    public lazy var context: NSManagedObjectContext = {
        return createContext()
    }()
    
    init(databaseName: String) {
        self.databaseName = databaseName
    }
    
    public func saveCourseDetails() {
        context.performAndWait {
            let newCourseDetails = CDCourseDetails(context: context)
            newCourseDetails.courseID = UUID().uuidString
            newCourseDetails.org = "course.org"
            newCourseDetails.courseTitle = "course.courseTitle"
            newCourseDetails.courseDescription = "course.courseDescription"
            newCourseDetails.courseStart = Date()
            newCourseDetails.courseEnd = Date()
            newCourseDetails.enrollmentStart = Date()
            newCourseDetails.enrollmentEnd = Date()
            newCourseDetails.isEnrolled = false
            newCourseDetails.overviewHTML = "course.overviewHTML"
            newCourseDetails.courseBannerURL = "course.courseBannerURL"
            
            do {
                try context.save()
            } catch {
                print("⛔️⛔️⛔️⛔️⛔️", error)
            }
        }
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
        let context = persistentContainer.newBackgroundContext()
        context.automaticallyMergesChangesFromParent = true
        return context
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
}

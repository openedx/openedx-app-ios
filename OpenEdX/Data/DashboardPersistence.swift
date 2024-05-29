//
//  DashboardPersistence.swift
//  OpenEdX
//
//  Created by  Stepanok Ivan on 25.07.2023.
//

import Dashboard
import Core
import Foundation
import CoreData

public class DashboardPersistence: DashboardPersistenceProtocol {
    
    private var context: NSManagedObjectContext
    
    public init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    public func loadMyCourses() throws -> [CourseItem] {
        let result = try? context.fetch(CDDashboardCourse.fetchRequest())
            .map { CourseItem(name: $0.name ?? "",
                              org: $0.org ?? "",
                              shortDescription: $0.desc ?? "",
                              imageURL: $0.imageURL ?? "",
                              isActive: nil,
                              courseStart: $0.courseStart,
                              courseEnd: $0.courseEnd,
                              enrollmentStart: $0.enrollmentStart,
                              enrollmentEnd: $0.enrollmentEnd,
                              courseID: $0.courseID ?? "",
                              numPages: Int($0.numPages),
                              coursesCount: Int($0.courseCount),
                              sku: $0.courseSku ?? "",
                              dynamicUpgradeDeadline: $0.dynamicUpgradeDeadline,
                              mode: DataLayer.Mode(rawValue: $0.mode ?? "") ?? .unknown,
                              isSelfPaced: $0.isSelfPaced)
            }
        if let result, !result.isEmpty {
            return result
        } else {
            throw NoCachedDataError()
        }
    }
    
    public func saveMyCourses(items: [CourseItem]) {
        for item in items {
            context.performAndWait {
                let newItem = CDDashboardCourse(context: context)
                context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
                newItem.name = item.name
                newItem.org = item.org
                newItem.desc = item.shortDescription
                newItem.imageURL = item.imageURL
                newItem.courseStart = item.courseStart
                newItem.courseEnd = item.courseEnd
                newItem.enrollmentStart = item.enrollmentStart
                newItem.enrollmentEnd = item.enrollmentEnd
                newItem.numPages = Int32(item.numPages)
                newItem.courseID = item.courseID
                newItem.courseSku = item.sku
                newItem.dynamicUpgradeDeadline = item.dynamicUpgradeDeadline
                newItem.mode = item.mode.rawValue
                do {
                    try context.save()
                } catch {
                    print("⛔️⛔️⛔️⛔️⛔️", error)
                }
            }
        }
    }
    
    public func loadServerConfig() throws -> DataLayer.ServerConfigs? {
        let result = try? context.fetch(CDServerConfigs.fetchRequest())
            .map { DataLayer.ServerConfigs(config: $0.config ?? "")}
        
        if let result, !result.isEmpty {
            return result.first
        } else {
            throw NoCachedDataError()
        }
    }
    
    public func saveServerConfig(configs: DataLayer.ServerConfigs) {
        context.performAndWait {
            let result = try? context.fetch(CDServerConfigs.fetchRequest())
            var item: CDServerConfigs?
            
            if let result, !result.isEmpty {
                item = result.first
                item?.config = configs.config
            } else {
                item = CDServerConfigs(context: context)
            }
            
            context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            item?.config = configs.config
            do {
                try context.save()
            } catch {
                print("⛔️⛔️⛔️⛔️⛔️", error)
            }
        }
    }
}

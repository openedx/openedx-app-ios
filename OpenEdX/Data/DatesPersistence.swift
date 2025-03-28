//
//  DatesPersistence.swift
//  OpenEdX
//
//  Created by Ivan Stepanok on 15.02.2025.
//

import Foundation
import Core
import AppDates
@preconcurrency import CoreData
import OEXFoundation

public final class DatesPersistence: DatesPersistenceProtocol {
    
    private let container: NSPersistentContainer
    
    public init(container: NSPersistentContainer) {
        self.container = container
    }
    
    public func loadCourseDates(page: Int? = nil) async throws -> [CourseDate] {
        return try await container.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<CDDate> = CDDate.fetchRequest()
            if let page = page {
                fetchRequest.predicate = NSPredicate(format: "page == %d", page)
            }
            let cdDates = try context.fetch(fetchRequest)
            let result = cdDates.map { cd in
                CourseDate(
                    location: cd.location ?? "",
                    date: cd.date ?? Date(),
                    title: cd.title ?? "",
                    courseName: cd.courseName ?? "",
                    courseId: cd.courseId,
                    blockId: cd.blockId,
                    hasAccess: cd.hasAccess
                )
            }
            return result
        }
    }
    
    public func saveCourseDates(dates: [CourseDate], page: Int) async {
        await container.performBackgroundTask { context in
            for date in dates {
                let newItem = CDDate(context: context)
                context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
                newItem.page = Int64(page)
                newItem.location = date.location
                newItem.date = date.date
                newItem.title = date.title
                newItem.courseName = date.courseName
                newItem.courseId = date.courseId
                newItem.blockId = date.blockId
                newItem.hasAccess = date.hasAccess
            }
            
            do {
                try context.save()
            } catch {
                debugLog(error)
            }
        }
    }
    
    public func clearAllCourseDates() async {
        await container.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDDate.fetchRequest()
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try context.execute(batchDeleteRequest)
                try context.save()
            } catch {
                debugLog(error)
            }
        }
    }
}

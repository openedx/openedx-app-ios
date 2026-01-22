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
    
    public func loadCourseDates(limit: Int? = nil, offset: Int? = nil) async throws -> [CourseDate] {
        return try await container.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<CDDate> = CDDate.fetchRequest()
            
            // Sort by index to ensure consistent order
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "index", ascending: true)]
            
            // Apply limit and offset if provided
            if let limit = limit {
                fetchRequest.fetchLimit = limit
            }
            if let offset = offset {
                fetchRequest.fetchOffset = offset
            }
            
            let cdDates = try context.fetch(fetchRequest)
            let result = cdDates.map { cd -> CourseDate in
                let storedIndex = cd.value(forKey: "index") as? NSNumber
                return CourseDate(
                    date: cd.date ?? Date(),
                    title: cd.title ?? "",
                    courseName: cd.courseName ?? "",
                    courseId: cd.courseId,
                    blockId: cd.blockId,
                    hasAccess: cd.hasAccess,
                    order: storedIndex?.intValue
                )
            }
            return result
        }
    }
    
    public func saveCourseDates(dates: [CourseDate], startIndex: Int) async {
        await container.performBackgroundTask { context in
            context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            for (index, date) in dates.enumerated() {
                let newItem = CDDate(context: context)
                let resolvedIndex = date.order ?? (startIndex + index)
                newItem.index = Int64(resolvedIndex)
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

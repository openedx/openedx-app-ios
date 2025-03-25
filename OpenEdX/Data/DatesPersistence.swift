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
    
    public func loadCourseDates() async throws -> [CourseDate] {
        return try await container.performBackgroundTask { context in
            let result = try? context.fetch(CDDate.fetchRequest())
                .map { CourseDate(
                    location: $0.location ?? "",
                    date: $0.date ?? Date(),
                    title: $0.title ?? "",
                    courseName: $0.courseName ?? "",
                    courseId: $0.courseId,
                    blockId: $0.blockId,
                    hasAccess: $0.hasAccess
                )}
            
            if let result, !result.isEmpty {
                return result
            } else {
                throw NoCachedDataError()
            }
        }
    }
    
    public func saveCourseDates(dates: [CourseDate]) async {
        await container.performBackgroundTask { context in
            for date in dates {
                let newItem = CDDate(context: context)
                context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
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
}

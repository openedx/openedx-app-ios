//
//  DownloadsPersistence.swift
//  OpenEdX
//
//  Created by Ivan Stepanok on 25.02.2025.
//

import Downloads
import Core
import Foundation
@preconcurrency import CoreData

public final class DownloadsPersistence: DownloadsPersistenceProtocol {
    
    private let container: NSPersistentContainer
    
    public init(container: NSPersistentContainer) {
        self.container = container
    }
    
    public func loadDownloadCourses() async throws -> [Downloads.DownloadCoursePreview] {
        return try await container.performBackgroundTask { context in
            let result = try? context.fetch(CDDownloadCoursePreview.fetchRequest())
                .map { Downloads.DownloadCoursePreview(
                    id: $0.id ?? "",
                    name: $0.name ?? "",
                    image: $0.image,
                    totalSize: $0.totalSize
                )
                }
            if let result, !result.isEmpty {
                return result
            } else {
                throw NoCachedDataError()
            }
        }
    }

    public func saveDownloadCourses(courses: [Downloads.DownloadCoursePreview]) async {
        await container.performBackgroundTask { context in
            for course in courses {
                let newCourse = CDDownloadCoursePreview(context: context)
                context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
                newCourse.id = course.id
                newCourse.name = course.name
                newCourse.image = course.image
                newCourse.totalSize = course.totalSize
            }
            do {
                try context.save()
            } catch {
                print("⛔️⛔️⛔️⛔️⛔️", error)
            }
        }
    }
}

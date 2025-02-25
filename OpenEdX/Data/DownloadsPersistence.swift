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
    public func loadDownloadCourses() async throws -> [Downloads.DownloadCoursePreview] {
        return []
    }

    public func saveDownloadCourses(courses: [Downloads.DownloadCoursePreview]) async {
        
    }

    public func getDownloadCourse(courseID: String) async throws -> Downloads.DownloadCoursePreview? {
        return nil
    }
    
    private let container: NSPersistentContainer
    
    public init(container: NSPersistentContainer) {
        self.container = container
    }
    
}

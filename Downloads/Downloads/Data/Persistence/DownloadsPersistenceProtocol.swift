//
//  DownloadsPersistenceProtocol.swift
//  Downloads
//
//  Created by Ivan Stepanok on 25.02.2025.
//

import Foundation
import CoreData
import Core

public protocol DownloadsPersistenceProtocol: Sendable {
    func loadDownloadCourses() async throws -> [DownloadCoursePreview]
    func saveDownloadCourses(courses: [DownloadCoursePreview]) async
    func getDownloadCourse(courseID: String) async throws -> DownloadCoursePreview?
}

public final class DownloadsBundle {
    private init() {}
}

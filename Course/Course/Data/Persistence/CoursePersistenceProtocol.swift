//
//  CoursePersistence.swift
//  Course
//
//  Created by  Stepanok Ivan on 15.12.2022.
//

import CoreData
import Core

public protocol CoursePersistenceProtocol: Sendable {
    func loadEnrollments() async throws -> [Core.CourseItem]
    func saveEnrollments(items: [Core.CourseItem]) async
    func loadCourseStructure(courseID: String) async throws -> DataLayer.CourseStructure
    func saveCourseStructure(structure: DataLayer.CourseStructure) async
    func saveSubtitles(url: String, subtitlesString: String) async
    func loadSubtitles(url: String) async -> String?
    func saveCourseDates(courseID: String, courseDates: CourseDates) async
    func loadCourseDates(courseID: String) async throws -> CourseDates
}

public final class CourseBundle {
    private init() {}
}
    

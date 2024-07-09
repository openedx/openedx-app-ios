//
//  DiscoveryPersistence.swift
//  Discovery
//
//  Created by  Stepanok Ivan on 14.12.2022.
//

import CoreData
import Core

public protocol DiscoveryPersistenceProtocol {
    func loadDiscovery() async throws -> [CourseItem]
    func saveDiscovery(items: [CourseItem])
    func loadCourseDetails(courseID: String) async throws -> CourseDetails
    func saveCourseDetails(course: CourseDetails)
}

public final class DiscoveryBundle {
    private init() {}
}

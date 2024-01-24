//
//  DiscoveryPersistence.swift
//  Discovery
//
//  Created by  Stepanok Ivan on 14.12.2022.
//

import CoreData
import Core

public protocol DiscoveryPersistenceProtocol {
    func loadDiscovery() throws -> [CourseItem]
    func saveDiscovery(items: [CourseItem])
    func loadCourseDetails(courseID: String) throws -> CourseDetails
    func saveCourseDetails(course: CourseDetails)
}

public final class DiscoveryBundle {
    private init() {}
}

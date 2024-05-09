//
//  DashboardPersistence.swift
//  Dashboard
//
//  Created by  Stepanok Ivan on 27.12.2022.
//

import CoreData
import Core

public protocol DashboardPersistenceProtocol {
    func loadMyCourses() throws -> [CourseItem]
    func saveMyCourses(items: [CourseItem])
    func loadMyEnrollments() throws -> PrimaryEnrollment
    func saveMyEnrollments(enrollments: PrimaryEnrollment)
}

public final class DashboardBundle {
    private init() {}
}

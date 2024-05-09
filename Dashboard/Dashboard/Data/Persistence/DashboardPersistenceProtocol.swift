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
    func loadMyEnrollments() throws -> MyEnrollments
    func saveMyEnrollments(enrollments: MyEnrollments)
}

public final class DashboardBundle {
    private init() {}
}

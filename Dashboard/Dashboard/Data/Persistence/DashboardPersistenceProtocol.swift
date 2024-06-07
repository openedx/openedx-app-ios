//
//  DashboardPersistence.swift
//  Dashboard
//
//  Created by  Stepanok Ivan on 27.12.2022.
//

import CoreData
import Core

public protocol DashboardPersistenceProtocol {
    func loadServerConfig() throws -> DataLayer.ServerConfigs?
    func saveServerConfig(configs: DataLayer.ServerConfigs)
    func loadEnrollments() throws -> [CourseItem]
    func saveEnrollments(items: [CourseItem])
    func loadPrimaryEnrollment() throws -> PrimaryEnrollment
    func savePrimaryEnrollment(enrollments: PrimaryEnrollment)
}

public final class DashboardBundle {
    private init() {}
}

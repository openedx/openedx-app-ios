//
//  DashboardRepository.swift
//  Dashboard
//
//  Created by  Stepanok Ivan on 19.09.2022.
//

import Foundation
import Core

public protocol DashboardRepositoryProtocol {
    func getMyCourses(page: Int) async throws -> [CourseItem]
    func getMyCoursesOffline() throws -> [CourseItem]
}

public class DashboardRepository: DashboardRepositoryProtocol {
    
    private let api: API
    private let storage: CoreStorage
    private let config: Config
    private let persistence: DashboardPersistenceProtocol
    
    public init(api: API, storage: CoreStorage, config: Config, persistence: DashboardPersistenceProtocol) {
        self.api = api
        self.storage = storage
        self.config = config
        self.persistence = persistence
    }
    
    public func getMyCourses(page: Int) async throws -> [CourseItem] {
        let result = try await api.requestData(
            DashboardEndpoint.getMyCourses(username: storage.user?.username ?? "", page: page)
        )
            .mapResponse(DataLayer.CourseEnrollments.self)
            .domain(baseURL: config.baseURL.absoluteString)
        persistence.saveMyCourses(items: result)
        return result
        
    }
    
    public func getMyCoursesOffline() throws -> [CourseItem] {
        return try persistence.loadMyCourses()
    }
    
}

// Mark - For testing and SwiftUI preview
#if DEBUG
class DashboardRepositoryMock: DashboardRepositoryProtocol {
    func getMyCourses(page: Int) async throws -> [CourseItem] {
        var models: [CourseItem] = []
        for i in 0...10 {
            models.append(
                CourseItem(
                    name: "Course name \(i)",
                    org: "Organization",
                    shortDescription: "shortDescription",
                    imageURL: "",
                    isActive: true,
                    courseStart: nil,
                    courseEnd: nil,
                    enrollmentStart: nil,
                    enrollmentEnd: nil,
                    courseID: "course_id_\(i)",
                    numPages: 1,
                    coursesCount: 0
                )
            )
        }
        return models
    }
    
    func getMyCoursesOffline() throws -> [CourseItem] { return [] }
}
#endif

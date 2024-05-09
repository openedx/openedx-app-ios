//
//  DashboardInteractor.swift
//  Dashboard
//
//  Created by  Stepanok Ivan on 19.09.2022.
//

import Foundation
import Core

//sourcery: AutoMockable
public protocol DashboardInteractorProtocol {
    func getMyCourses(page: Int) async throws -> [CourseItem]
    func discoveryOffline() throws -> [CourseItem]
    func getMyLearnCourses(pageSize: Int) async throws -> MyEnrollments
    func getMyLearnCoursesOffline() async throws -> MyEnrollments
    func getAllCourses(filteredBy: String, page: Int) async throws -> MyEnrollments
    func getAllCoursesOffline() async throws -> MyEnrollments
}

public class DashboardInteractor: DashboardInteractorProtocol {
    
    private let repository: DashboardRepositoryProtocol
    
    public init(repository: DashboardRepositoryProtocol) {
        self.repository = repository
    }
    
    @discardableResult
    public func getMyCourses(page: Int) async throws -> [CourseItem] {
        return try await repository.getMyCourses(page: page)
    }
    
    public func discoveryOffline() throws -> [CourseItem] {
        return try repository.getMyCoursesOffline()
    }
    
    public func getMyLearnCourses(pageSize: Int) async throws -> MyEnrollments {
        return try await repository.getMyLearnCourses(pageSize: pageSize)
    }
    
    public func getMyLearnCoursesOffline() async throws -> MyEnrollments {
        return try await repository.getMyLearnCoursesOffline()
    }
    
    public func getAllCourses(filteredBy: String, page: Int) async throws -> MyEnrollments {
        return try await repository.getAllCourses(filteredBy: filteredBy, page: page)
    }
    
    public func getAllCoursesOffline() async throws -> MyEnrollments {
        return try await repository.getAllCoursesOffline()
    }
}

// Mark - For testing and SwiftUI preview
#if DEBUG
public extension DashboardInteractor {
    static let mock = DashboardInteractor(repository: DashboardRepositoryMock())
}
#endif

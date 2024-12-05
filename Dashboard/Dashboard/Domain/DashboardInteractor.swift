//
//  DashboardInteractor.swift
//  Dashboard
//
//  Created by  Stepanok Ivan on 19.09.2022.
//

import Foundation
import Core

//sourcery: AutoMockable
public protocol DashboardInteractorProtocol: Sendable {
    func getEnrollments(page: Int) async throws -> [CourseItem]
    func getEnrollmentsOffline() async throws -> [CourseItem]
    func getPrimaryEnrollment(pageSize: Int) async throws -> PrimaryEnrollment
    func getPrimaryEnrollmentOffline() async throws -> PrimaryEnrollment
    func getAllCourses(filteredBy: String, page: Int) async throws -> PrimaryEnrollment
}

public actor DashboardInteractor: DashboardInteractorProtocol {
    
    private let repository: DashboardRepositoryProtocol
    
    public init(repository: DashboardRepositoryProtocol) {
        self.repository = repository
    }
    
    @discardableResult
    public func getEnrollments(page: Int) async throws -> [CourseItem] {
        return try await repository.getEnrollments(page: page)
    }
    
    public func getEnrollmentsOffline() async throws -> [CourseItem] {
        return try await repository.getEnrollmentsOffline()
    }
    
    public func getPrimaryEnrollment(pageSize: Int) async throws -> PrimaryEnrollment {
        return try await repository.getPrimaryEnrollment(pageSize: pageSize)
    }
    
    public func getPrimaryEnrollmentOffline() async throws -> PrimaryEnrollment {
        return try await repository.getPrimaryEnrollmentOffline()
    }
    
    public func getAllCourses(filteredBy: String, page: Int) async throws -> PrimaryEnrollment {
        return try await repository.getAllCourses(filteredBy: filteredBy, page: page)
    }
}

// Mark - For testing and SwiftUI preview
#if DEBUG
public extension DashboardInteractor {
    static let mock = DashboardInteractor(repository: DashboardRepositoryMock())
}
#endif

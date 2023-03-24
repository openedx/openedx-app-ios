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
}

// Mark - For testing and SwiftUI preview
#if DEBUG
public extension DashboardInteractor {
    static let mock = DashboardInteractor(repository: DashboardRepositoryMock())
}
#endif

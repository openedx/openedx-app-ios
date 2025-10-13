//
//  DatesInteractor.swift
//  AppDates
//
//  Created by Ivan Stepanok on 15.02.2025.
//

import Foundation
import Core

//sourcery: AutoMockable
public protocol DatesInteractorProtocol: Sendable {
    func getCourseDates(page: Int) async throws -> ([CourseDate], String?)
    func getCourseDatesOffline(limit: Int?, offset: Int?) async throws -> [CourseDate]
    func resetAllRelativeCourseDeadlines() async throws
}

public actor DatesInteractor: DatesInteractorProtocol {
    
    private let repository: DatesRepositoryProtocol
    
    public init(repository: DatesRepositoryProtocol) {
        self.repository = repository
    }
    
    public func getCourseDates(page: Int) async throws -> ([CourseDate], String?) {
        return try await repository.getCourseDates(page: page)
    }
    
    public func getCourseDatesOffline(limit: Int?, offset: Int?) async throws -> [CourseDate] {
        return try await repository.getCourseDatesOffline(limit: limit, offset: offset)
    }
    
    public func resetAllRelativeCourseDeadlines() async throws {
        try await repository.resetAllRelativeCourseDeadlines()
    }
}

// Mark - For testing and SwiftUI preview
#if DEBUG
public extension DatesInteractor {
    static let mock = DatesInteractor(repository: DatesRepositoryMock())
}
#endif

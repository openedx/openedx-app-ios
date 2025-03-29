//
//  DatesViewInteractor.swift
//  AppDates
//
//  Created by Ivan Stepanok on 15.02.2025.
//

import Foundation
import Core

//sourcery: AutoMockable
public protocol DatesViewInteractorProtocol: Sendable {
    func getCourseDates(page: Int) async throws -> ([CourseDate], String?)
    func getCourseDatesOffline(limit: Int?, offset: Int?) async throws -> [CourseDate]
    func resetAllRelativeCourseDeadlines() async throws
    func clearAllCourseDates() async
}

public actor DatesViewInteractor: DatesViewInteractorProtocol {
    
    private let repository: DatesViewRepositoryProtocol
    
    public init(repository: DatesViewRepositoryProtocol) {
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
    
    public func clearAllCourseDates() async {
        await repository.clearAllCourseDates()
    }
}

// Mark - For testing and SwiftUI preview
#if DEBUG
public extension DatesViewInteractor {
    static let mock = DatesViewInteractor(repository: DatesViewRepositoryMock())
}
#endif

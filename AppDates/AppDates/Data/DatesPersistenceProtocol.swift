//
//  DatesPersistenceProtocol.swift
//  AppDates
//
//  Created by Ivan Stepanok on 15.02.2025.
//

import Foundation
import Core

//sourcery: AutoMockable
public protocol DatesPersistenceProtocol: Sendable {
    func loadCourseDates(page: Int?) async throws -> [CourseDate]
    func saveCourseDates(dates: [CourseDate], page: Int) async
    func clearAllCourseDates() async
}

#if DEBUG
public struct DatesPersistenceMock: DatesPersistenceProtocol {
    public func loadCourseDates(page: Int?) async throws -> [CourseDate] {[]}
    public func saveCourseDates(dates: [CourseDate], page: Int) async {}
    public func clearAllCourseDates() async {}
}
#endif

public final class AppDatesBundle {
    private init() {}
}

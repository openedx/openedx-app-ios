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
    func loadCourseDates() async throws -> [CourseDate]
    func saveCourseDates(dates: [CourseDate]) async
}

#if DEBUG
public struct DatesPersistenceMock: DatesPersistenceProtocol {
    public func loadCourseDates() async throws -> [CourseDate] {[]}
    public func saveCourseDates(dates: [CourseDate]) async {}
}
#endif

public final class AppDatesBundle {
    private init() {}
}

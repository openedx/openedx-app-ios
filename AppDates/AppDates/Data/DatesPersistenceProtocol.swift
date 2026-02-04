//
//  DatesPersistenceProtocol.swift
//  AppDates
//
//  Created by Ivan Stepanok on 15.02.2025.
//

import Foundation
import Core

/// @mockable
public protocol DatesPersistenceProtocol: Sendable {
    func loadCourseDates(limit: Int?, offset: Int?) async throws -> [CourseDate]
    func saveCourseDates(dates: [CourseDate], startIndex: Int) async
    func clearAllCourseDates() async
}

#if DEBUG
public struct DatesPersistencePreviewMock: DatesPersistenceProtocol {
    public func loadCourseDates(limit: Int?, offset: Int?) async throws -> [CourseDate] {[]}
    public func saveCourseDates(dates: [CourseDate], startIndex: Int) async {}
    public func clearAllCourseDates() async {}
}
#endif

public final class AppDatesBundle {
    private init() {}
}

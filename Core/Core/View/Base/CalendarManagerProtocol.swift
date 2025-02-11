//
//  CalendarManagerProtocol.swift
//  Core
//
//  Created by  Stepanok Ivan on 12.06.2024.
//

import Foundation

//sourcery: AutoMockable
@MainActor
public protocol CalendarManagerProtocol: Sendable {
    func createCalendarIfNeeded()
    func filterCoursesBySelected(fetchedCourses: [CourseForSync]) async -> [CourseForSync]
    func removeOldCalendar()
    func removeOutdatedEvents(courseID: String) async
    func syncCourse(courseID: String, courseName: String, dates: CourseDates) async
    func requestAccess() async -> Bool
    func courseStatus(courseID: String) async -> SyncStatus
    func clearAllData(removeCalendar: Bool) async
    func isDatesChanged(courseID: String, checksum: String) async -> Bool
}

#if DEBUG
public struct CalendarManagerMock: CalendarManagerProtocol {
    public func createCalendarIfNeeded() {}
    public func filterCoursesBySelected(fetchedCourses: [CourseForSync]) async -> [CourseForSync] {[]}
    public func removeOldCalendar() {}
    public func removeOutdatedEvents(courseID: String) async {}
    public func syncCourse(courseID: String, courseName: String, dates: CourseDates) async {}
    public func requestAccess() async -> Bool { true }
    public func courseStatus(courseID: String) -> SyncStatus { .synced }
    public func clearAllData(removeCalendar: Bool) {}
    public func isDatesChanged(courseID: String, checksum: String) async -> Bool {false}
    
    public init() {}
}
#endif

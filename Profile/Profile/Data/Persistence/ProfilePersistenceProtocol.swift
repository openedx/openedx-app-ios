//
//  ProfilePersistenceProtocol.swift
//  Profile
//
//  Created by  Stepanok Ivan on 03.06.2024.
//

import CoreData
import Core

public protocol ProfilePersistenceProtocol {
    func getCourseState(courseID: String) -> CourseCalendarState?
    func getAllCourseStates() -> [CourseCalendarState]
    func saveCourseState(state: CourseCalendarState)
    func removeCourseState(courseID: String)
    func deleteAllCourseStatesAndEvents()
    func saveCourseCalendarEvent(_ event: CourseCalendarEvent)
    func removeCourseCalendarEvents(for courseId: String)
    func removeAllCourseCalendarEvents()
    func getCourseCalendarEvents(for courseId: String) -> [CourseCalendarEvent]
}

#if DEBUG
public struct ProfilePersistenceMock: ProfilePersistenceProtocol {
    public func getCourseState(courseID: String) -> CourseCalendarState? { nil }
    public func getAllCourseStates() -> [CourseCalendarState] {[]}
    public func saveCourseState(state: CourseCalendarState) {}
    public func removeCourseState(courseID: String) {}
    public func deleteAllCourseStatesAndEvents() {}
    public func saveCourseCalendarEvent(_ event: CourseCalendarEvent) {}
    public func removeCourseCalendarEvents(for courseId: String) {}
    public func removeAllCourseCalendarEvents() {}
    public func getCourseCalendarEvents(for courseId: String) -> [CourseCalendarEvent] { [] }
}
#endif

public final class ProfileBundle {
    private init() {}
}

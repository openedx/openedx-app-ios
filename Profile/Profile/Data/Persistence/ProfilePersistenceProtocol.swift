//
//  ProfilePersistenceProtocol.swift
//  Profile
//
//  Created by  Stepanok Ivan on 03.06.2024.
//

import CoreData
import Core

//sourcery: AutoMockable
public protocol ProfilePersistenceProtocol: Sendable {
    func getCourseState(courseID: String) async -> CourseCalendarState?
    func getAllCourseStates() async -> [CourseCalendarState]
    func saveCourseState(state: CourseCalendarState) async
    func removeCourseState(courseID: String) async
    func deleteAllCourseStatesAndEvents() async
    func saveCourseCalendarEvent(_ event: CourseCalendarEvent) async
    func removeCourseCalendarEvents(for courseId: String) async
    func removeAllCourseCalendarEvents() async
    func getCourseCalendarEvents(for courseId: String) async -> [CourseCalendarEvent]
}

#if DEBUG
public struct ProfilePersistenceMock: ProfilePersistenceProtocol {
    public func getCourseState(courseID: String) async -> CourseCalendarState? { nil }
    public func getAllCourseStates() async -> [CourseCalendarState] {[]}
    public func saveCourseState(state: CourseCalendarState) async {}
    public func removeCourseState(courseID: String) async {}
    public func deleteAllCourseStatesAndEvents() async {}
    public func saveCourseCalendarEvent(_ event: CourseCalendarEvent) async {}
    public func removeCourseCalendarEvents(for courseId: String) async {}
    public func removeAllCourseCalendarEvents() async {}
    public func getCourseCalendarEvents(for courseId: String) async -> [CourseCalendarEvent] { [] }
}
#endif

public final class ProfileBundle {
    private init() {}
}

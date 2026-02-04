//
//  CalendarManagerTests.swift
//  Profile
//
//  Created by Ivan Stepanok on 29.10.2024.
//


import XCTest
import EventKit
@testable import Profile
@testable import Core
import Theme
import SwiftUI

@MainActor
final class CalendarManagerTests: XCTestCase {

    func testCourseStatusSynced() async {
        let persistence = ProfilePersistenceProtocolMock()
        let interactor = ProfileInteractorProtocolMock()
        let profileStorage = ProfileStorageMock()

        let manager = CalendarManager(
            persistence: persistence,
            interactor: interactor,
            profileStorage: profileStorage
        )

        let states = [CourseCalendarState(courseID: "course-1", checksum: "checksum-1")]
        persistence.getAllCourseStatesHandler = { states }

        let status = await manager.courseStatus(courseID: "course-1")

        XCTAssertEqual(persistence.getAllCourseStatesCallCount, 1)
        XCTAssertEqual(status, .synced)
    }

    func testCourseStatusOffline() async {
        let persistence = ProfilePersistenceProtocolMock()
        let interactor = ProfileInteractorProtocolMock()
        let profileStorage = ProfileStorageMock()

        let manager = CalendarManager(
            persistence: persistence,
            interactor: interactor,
            profileStorage: profileStorage
        )

        let states = [CourseCalendarState(courseID: "course-2", checksum: "checksum-2")]
        persistence.getAllCourseStatesHandler = { states }

        let status = await manager.courseStatus(courseID: "course-1")

        XCTAssertEqual(persistence.getAllCourseStatesCallCount, 1)
        XCTAssertEqual(status, .offline)
    }

    func testIsDatesChanged() async {
        let persistence = ProfilePersistenceProtocolMock()
        let interactor = ProfileInteractorProtocolMock()
        let profileStorage = ProfileStorageMock()

        let manager = CalendarManager(
            persistence: persistence,
            interactor: interactor,
            profileStorage: profileStorage
        )

        let state = CourseCalendarState(courseID: "course-1", checksum: "old-checksum")
        persistence.getCourseStateHandler = { courseID in
            return courseID == "course-1" ? state : nil
        }

        let changed = await manager.isDatesChanged(courseID: "course-1", checksum: "new-checksum")

        XCTAssertEqual(persistence.getCourseStateCallCount, 1)
        XCTAssertTrue(changed)
    }

    func testIsDatesNotChanged() async {
        let persistence = ProfilePersistenceProtocolMock()
        let interactor = ProfileInteractorProtocolMock()
        let profileStorage = ProfileStorageMock()

        let manager = CalendarManager(
            persistence: persistence,
            interactor: interactor,
            profileStorage: profileStorage
        )

        let state = CourseCalendarState(courseID: "course-1", checksum: "same-checksum")
        persistence.getCourseStateHandler = { courseID in
            return courseID == "course-1" ? state : nil
        }

        let changed = await manager.isDatesChanged(courseID: "course-1", checksum: "same-checksum")

        XCTAssertEqual(persistence.getCourseStateCallCount, 1)
        XCTAssertFalse(changed)
    }

    func testClearAllData() async {
        let persistence = ProfilePersistenceProtocolMock()
        let interactor = ProfileInteractorProtocolMock()
        let profileStorage = ProfileStorageMock()

        // Setup initial values
        profileStorage.firstCalendarUpdate = true
        profileStorage.hideInactiveCourses = true
        profileStorage.lastCalendarName = "Test Calendar"
        profileStorage.calendarSettings = CalendarSettings(
            colorSelection: "accent",
            calendarName: "Test Calendar",
            accountSelection: "iCloud",
            courseCalendarSync: true
        )
        profileStorage.lastCalendarUpdateDate = Date()

        // Verify initial values are set
        XCTAssertTrue(profileStorage.firstCalendarUpdate ?? false)
        XCTAssertTrue(profileStorage.hideInactiveCourses ?? false)
        XCTAssertNotNil(profileStorage.lastCalendarName)
        XCTAssertNotNil(profileStorage.calendarSettings)
        XCTAssertNotNil(profileStorage.lastCalendarUpdateDate)

        let manager = CalendarManager(
            persistence: persistence,
            interactor: interactor,
            profileStorage: profileStorage
        )

        persistence.deleteAllCourseStatesAndEventsHandler = { }

        await manager.clearAllData(removeCalendar: true)

        // Verify persistence method was called
        XCTAssertEqual(persistence.deleteAllCourseStatesAndEventsCallCount, 1)

        // Verify all values were cleared
        XCTAssertEqual(profileStorage.firstCalendarUpdate, false)
        XCTAssertNil(profileStorage.hideInactiveCourses)
        XCTAssertNil(profileStorage.lastCalendarName)
        XCTAssertNil(profileStorage.calendarSettings)
        XCTAssertNil(profileStorage.lastCalendarUpdateDate)
    }

    func testFilterCoursesBySelected() async throws {
        let persistence = ProfilePersistenceProtocolMock()
        let interactor = ProfileInteractorProtocolMock()
        let profileStorage = ProfileStorageMock()

        let manager = CalendarManager(
            persistence: persistence,
            interactor: interactor,
            profileStorage: profileStorage
        )

        let states = [
            CourseCalendarState(courseID: "course-1", checksum: "checksum-1"),
            CourseCalendarState(courseID: "course-2", checksum: "checksum-2"),
            CourseCalendarState(courseID: "course-3", checksum: "checksum-3")
        ]

        let fetchedCourses = [
            CourseForSync(
                id: UUID(),
                courseID: "course-1",
                name: "Course 1",
                synced: true,
                recentlyActive: true
            ),
            CourseForSync(
                id: UUID(),
                courseID: "course-2",
                name: "Course 2",
                synced: true,
                recentlyActive: false
            ),
            CourseForSync(
                id: UUID(),
                courseID: "course-4",
                name: "Course 4",
                synced: false,
                recentlyActive: true
            )
        ]

        // Setup mocks
        persistence.getAllCourseStatesHandler = { states }
        persistence.getCourseCalendarEventsHandler = { _ in [] }
        persistence.getCourseStateHandler = { _ in nil }
        persistence.removeCourseCalendarEventsHandler = { _ in }
        persistence.saveCourseStateHandler = { _ in }

        // Execute filtering
        let filteredCourses = await manager.filterCoursesBySelected(fetchedCourses: fetchedCourses)

        // Verify calls
        XCTAssertEqual(persistence.getAllCourseStatesCallCount, 1)

        // Verify course-3 was removed (exists in states but not in fetched)
        XCTAssertGreaterThanOrEqual(persistence.getCourseCalendarEventsCallCount, 1)
        XCTAssertGreaterThanOrEqual(persistence.removeCourseCalendarEventsCallCount, 1)

        // Verify results
        XCTAssertEqual(filteredCourses.count, 1)
        XCTAssertEqual(filteredCourses.first?.courseID, "course-1")
        XCTAssertEqual(filteredCourses.first?.name, "Course 1")
        XCTAssertTrue(filteredCourses.first?.synced ?? false)
        XCTAssertTrue(filteredCourses.first?.recentlyActive ?? false)
    }

    func testFilterCoursesBySelectedEmptyStates() async {
        let persistence = ProfilePersistenceProtocolMock()
        let interactor = ProfileInteractorProtocolMock()
        let profileStorage = ProfileStorageMock()

        let manager = CalendarManager(
            persistence: persistence,
            interactor: interactor,
            profileStorage: profileStorage
        )

        persistence.getAllCourseStatesHandler = { [] }

        let fetchedCourses = [
            CourseForSync(
                id: UUID(),
                courseID: "course-1",
                name: "Course 1",
                synced: true,
                recentlyActive: true
            ),
            CourseForSync(
                id: UUID(),
                courseID: "course-2",
                name: "Course 2",
                synced: true,
                recentlyActive: false
            )
        ]

        let filteredCourses = await manager.filterCoursesBySelected(fetchedCourses: fetchedCourses)

        XCTAssertEqual(persistence.getAllCourseStatesCallCount, 1)
        XCTAssertEqual(filteredCourses, fetchedCourses)
    }

    func testCalendarNameFromSettings() {
        let persistence = ProfilePersistenceProtocolMock()
        let interactor = ProfileInteractorProtocolMock()
        let profileStorage = ProfileStorageMock()

        let settings = CalendarSettings(
            colorSelection: "accent",
            calendarName: "Test Calendar",
            accountSelection: "iCloud",
            courseCalendarSync: true
        )
        profileStorage.calendarSettings = settings

        let manager = CalendarManager(
            persistence: persistence,
            interactor: interactor,
            profileStorage: profileStorage
        )

        XCTAssertEqual(manager.calendarName, "Test Calendar")
    }

    func testColorSelectionFromSettings() {
        let persistence = ProfilePersistenceProtocolMock()
        let interactor = ProfileInteractorProtocolMock()
        let profileStorage = ProfileStorageMock()

        let settings = CalendarSettings(
            colorSelection: "accent",
            calendarName: "Test Calendar",
            accountSelection: "iCloud",
            courseCalendarSync: true
        )
        profileStorage.calendarSettings = settings

        let manager = CalendarManager(
            persistence: persistence,
            interactor: interactor,
            profileStorage: profileStorage
        )

        XCTAssertEqual(manager.colorSelection?.color, Color.accentColor)
    }
}

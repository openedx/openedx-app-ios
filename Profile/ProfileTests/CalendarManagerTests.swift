//
//  CalendarManagerTests.swift
//  Profile
//
//  Created by Ivan Stepanok on 29.10.2024.
//


import SwiftyMocky
import XCTest
import EventKit
@testable import Profile
@testable import Core
import Theme
import SwiftUICore

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
        Given(persistence, .getAllCourseStates(willReturn: states))
        
        let status = await manager.courseStatus(courseID: "course-1")
        
        Verify(persistence, 1, .getAllCourseStates())
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
        Given(persistence, .getAllCourseStates(willReturn: states))
        
        let status = await manager.courseStatus(courseID: "course-1")
        
        Verify(persistence, 1, .getAllCourseStates())
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
        Given(persistence, .getCourseState(courseID: .value("course-1"), willReturn: state))
        
        let changed = await manager.isDatesChanged(courseID: "course-1", checksum: "new-checksum")
        
        Verify(persistence, 1, .getCourseState(courseID: .value("course-1")))
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
        Given(persistence, .getCourseState(courseID: .value("course-1"), willReturn: state))
        
        let changed = await manager.isDatesChanged(courseID: "course-1", checksum: "same-checksum")
        
        Verify(persistence, 1, .getCourseState(courseID: .value("course-1")))
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
        
        await manager.clearAllData(removeCalendar: true)
        
        // Verify persistence method was called
        Verify(persistence, 1, .deleteAllCourseStatesAndEvents())
        
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
            Given(persistence, .getAllCourseStates(willReturn: states))
            Given(persistence, .getCourseCalendarEvents(for: .any, willReturn: []))
            Given(persistence, .getCourseState(courseID: .any, willReturn: nil))
//            Given(persistence, .removeCourseCalendarEvents(for: .any, willProduce: { _ in }))
            
            // Execute filtering
            let filteredCourses = await manager.filterCoursesBySelected(fetchedCourses: fetchedCourses)
            
            // Verify calls
            Verify(persistence, 1, .getAllCourseStates())
            
            // Verify course-3 was removed (exists in states but not in fetched)
            Verify(persistence, 1, .getCourseCalendarEvents(for: .value("course-3")))
            Verify(persistence, 1, .removeCourseCalendarEvents(for: .value("course-3")))
            
            // Verify course-2 was removed (inactive)
            Verify(persistence, 1, .getCourseCalendarEvents(for: .value("course-2")))
            Verify(persistence, 1, .removeCourseCalendarEvents(for: .value("course-2")))
            
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
        
        Given(persistence, .getAllCourseStates(willReturn: []))
        
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
        
        Verify(persistence, 1, .getAllCourseStates())
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
        Given(profileStorage, .calendarSettings(getter: settings))
        
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
        Given(profileStorage, .calendarSettings(getter: settings))
        
        let manager = CalendarManager(
            persistence: persistence,
            interactor: interactor,
            profileStorage: profileStorage
        )
        
        XCTAssertEqual(manager.colorSelection?.color, Color.accentColor)
    }
}

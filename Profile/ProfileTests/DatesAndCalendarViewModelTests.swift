//
//  DatesAndCalendarViewModelTests.swift
//  Profile
//
//  Created by Ivan Stepanok on 30.10.2024.
//

import XCTest
import EventKit
@testable import Profile
@testable import Core
import Theme
import SwiftUI
import Combine

@MainActor
final class DatesAndCalendarViewModelTests: XCTestCase {

    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        cancellables = []
    }

    func testLoadCalendarOptions() {
        // Given
        let router = ProfileRouterMock()
        let interactor = ProfileInteractorProtocolMock()
        let persistence = ProfilePersistenceProtocolMock()
        let calendarManager = CalendarManagerProtocolMock()
        let connectivity = ConnectivityProtocolMock()
        let profileStorage = ProfileStorageMock()

        let settings = CalendarSettings(
            colorSelection: "accent",
            calendarName: "Test Calendar",
            accountSelection: "iCloud",
            courseCalendarSync: true
        )
        profileStorage.calendarSettings = settings
        profileStorage.lastCalendarName = "Old Calendar"
        profileStorage.hideInactiveCourses = true

        let viewModel = DatesAndCalendarViewModel(
            router: router,
            interactor: interactor,
            profileStorage: profileStorage,
            persistence: persistence,
            calendarManager: calendarManager,
            connectivity: connectivity
        )

        // When
        viewModel.loadCalendarOptions()

        // Then
        XCTAssertEqual(viewModel.colorSelection?.colorString, "accent")
        XCTAssertEqual(viewModel.accountSelection?.title, "iCloud")
        XCTAssertEqual(viewModel.calendarName, "Test Calendar")
        XCTAssertEqual(viewModel.oldCalendarName, "Old Calendar")
        XCTAssertTrue(viewModel.courseCalendarSync)
        XCTAssertTrue(viewModel.hideInactiveCourses)
    }

    func testClearAllData() async {
        // Given
        let router = ProfileRouterMock()
        let interactor = ProfileInteractorProtocolMock()
        let persistence = ProfilePersistenceProtocolMock()
        let calendarManager = CalendarManagerProtocolMock()
        let connectivity = ConnectivityProtocolMock()
        let profileStorage = ProfileStorageMock()

        calendarManager.clearAllDataHandler = { _ in }
        router.backHandler = { _ in }
        router.showDatesAndCalendarHandler = { }

        let viewModel = DatesAndCalendarViewModel(
            router: router,
            interactor: interactor,
            profileStorage: profileStorage,
            persistence: persistence,
            calendarManager: calendarManager,
            connectivity: connectivity
        )

        // When
        await viewModel.clearAllData()

        // Then
        XCTAssertEqual(calendarManager.clearAllDataCallCount, 1)
        XCTAssertEqual(router.backCallCount, 1)
        XCTAssertEqual(router.showDatesAndCalendarCallCount, 1)
        XCTAssertTrue(viewModel.courseCalendarSync)
        XCTAssertFalse(viewModel.showDisableCalendarSync)
        XCTAssertFalse(viewModel.openNewCalendarView)
    }

    func testSaveCalendarOptions() {
        // Given
        let router = ProfileRouterMock()
        let interactor = ProfileInteractorProtocolMock()
        let persistence = ProfilePersistenceProtocolMock()
        let calendarManager = CalendarManagerProtocolMock()
        let connectivity = ConnectivityProtocolMock()
        let profileStorage = ProfileStorageMock()

        let settings = CalendarSettings(
            colorSelection: "accent",
            calendarName: "Old Calendar",
            accountSelection: "iCloud",
            courseCalendarSync: true
        )
        profileStorage.calendarSettings = settings

        let viewModel = DatesAndCalendarViewModel(
            router: router,
            interactor: interactor,
            profileStorage: profileStorage,
            persistence: persistence,
            calendarManager: calendarManager,
            connectivity: connectivity
        )

        // When
        viewModel.calendarName = "New Calendar"
        viewModel.colorSelection = .init(color: .red)
        viewModel.accountSelection = .init(title: "Local")
        viewModel.courseCalendarSync = false
        viewModel.saveCalendarOptions()

        // Then
        XCTAssertEqual(profileStorage.calendarSettings?.calendarName, "New Calendar")
        XCTAssertEqual(profileStorage.calendarSettings?.colorSelection, "red")
        XCTAssertEqual(profileStorage.calendarSettings?.accountSelection, "Local")
        XCTAssertFalse(profileStorage.calendarSettings?.courseCalendarSync ?? true)
        XCTAssertEqual(profileStorage.lastCalendarName, "New Calendar")
    }

    func testFetchCoursesSuccess() async {
        // Given
        let router = ProfileRouterMock()
        let interactor = ProfileInteractorProtocolMock()
        let persistence = ProfilePersistenceProtocolMock()
        let calendarManager = CalendarManagerProtocolMock()
        let connectivity = ConnectivityProtocolMock()
        let profileStorage = ProfileStorageMock()

        connectivity.isInternetAvaliable = true
        calendarManager.requestAccessHandler = { true }
        calendarManager.createCalendarIfNeededHandler = { }
        calendarManager.filterCoursesBySelectedHandler = { $0 }

        let courses = [
            CourseForSync(
                id: UUID(),
                courseID: "course-1",
                name: "Course 1",
                synced: true,
                recentlyActive: true
            )
        ]
        interactor.enrollmentsStatusHandler = { courses }
        persistence.getAllCourseStatesHandler = { [] }

        let viewModel = DatesAndCalendarViewModel(
            router: router,
            interactor: interactor,
            profileStorage: profileStorage,
            persistence: persistence,
            calendarManager: calendarManager,
            connectivity: connectivity
        )

        // When
        await viewModel.fetchCourses()

        // Then
        XCTAssertEqual(viewModel.assignmentStatus, .synced)
        XCTAssertEqual(viewModel.coursesForSync.count, 1)
        XCTAssertEqual(viewModel.coursesForSync.first?.courseID, "course-1")
        XCTAssertEqual(calendarManager.createCalendarIfNeededCallCount, 1)
        XCTAssertEqual(interactor.enrollmentsStatusCallCount, 1)
    }

    func testRequestCalendarPermissionSuccess() async {
        // Given
        let router = ProfileRouterMock()
        let interactor = ProfileInteractorProtocolMock()
        let persistence = ProfilePersistenceProtocolMock()
        let calendarManager = CalendarManagerProtocolMock()
        let connectivity = ConnectivityProtocolMock()
        let profileStorage = ProfileStorageMock()

        calendarManager.requestAccessHandler = { true }

        let viewModel = DatesAndCalendarViewModel(
            router: router,
            interactor: interactor,
            profileStorage: profileStorage,
            persistence: persistence,
            calendarManager: calendarManager,
            connectivity: connectivity
        )

        // When
        await viewModel.requestCalendarPermission()

        // Then
        XCTAssertTrue(viewModel.openNewCalendarView)
        XCTAssertFalse(viewModel.showCalendaAccessDenied)
    }

    func testRequestCalendarPermissionDenied() async {
        // Given
        let router = ProfileRouterMock()
        let interactor = ProfileInteractorProtocolMock()
        let persistence = ProfilePersistenceProtocolMock()
        let calendarManager = CalendarManagerProtocolMock()
        let connectivity = ConnectivityProtocolMock()
        let profileStorage = ProfileStorageMock()

        calendarManager.requestAccessHandler = { false }

        let viewModel = DatesAndCalendarViewModel(
            router: router,
            interactor: interactor,
            profileStorage: profileStorage,
            persistence: persistence,
            calendarManager: calendarManager,
            connectivity: connectivity
        )

        // When
        await viewModel.requestCalendarPermission()

        // Then
        XCTAssertTrue(viewModel.showCalendaAccessDenied)
        XCTAssertFalse(viewModel.openNewCalendarView)
    }

    func testToggleSyncForCourse() {
        // Given
        let router = ProfileRouterMock()
        let interactor = ProfileInteractorProtocolMock()
        let persistence = ProfilePersistenceProtocolMock()
        let calendarManager = CalendarManagerProtocolMock()
        let connectivity = ConnectivityProtocolMock()
        let profileStorage = ProfileStorageMock()

        let course = CourseForSync(
            id: UUID(),
            courseID: "course-1",
            name: "Course 1",
            synced: false,
            recentlyActive: true
        )

        let viewModel = DatesAndCalendarViewModel(
            router: router,
            interactor: interactor,
            profileStorage: profileStorage,
            persistence: persistence,
            calendarManager: calendarManager,
            connectivity: connectivity
        )
        viewModel.coursesForSync = [course]

        // When
        viewModel.toggleSync(for: course)

        // Then
        XCTAssertTrue(viewModel.coursesForSync.first?.synced ?? false)
        XCTAssertEqual(viewModel.coursesForAdding.count, 1)
        XCTAssertEqual(viewModel.coursesForAdding.first?.courseID, "course-1")
    }

    func testDeleteOldCalendarIfNeeded() async {
        // Given
        let router = ProfileRouterMock()
        let interactor = ProfileInteractorProtocolMock()
        let persistence = ProfilePersistenceProtocolMock()
        let calendarManager = CalendarManagerProtocolMock()
        let connectivity = ConnectivityProtocolMock()
        let profileStorage = ProfileStorageMock()

        let settings = CalendarSettings(
            colorSelection: "accent",
            calendarName: "Old Calendar",
            accountSelection: "iCloud",
            courseCalendarSync: true
        )

        let states = [
            CourseCalendarState(courseID: "123", checksum: "checksum"),
            CourseCalendarState(courseID: "124", checksum: "checksum2")
        ]

        persistence.getAllCourseStatesHandler = { states }
        profileStorage.calendarSettings = settings
        connectivity.isInternetAvaliable = true
        calendarManager.requestAccessHandler = { true }
        calendarManager.removeOldCalendarHandler = { }
        persistence.removeAllCourseCalendarEventsHandler = { }

        let courses = [
            CourseForSync(
                id: UUID(),
                courseID: "course-1",
                name: "Course 1",
                synced: true,
                recentlyActive: true
            )
        ]
        interactor.enrollmentsStatusHandler = { courses }

        let viewModel = DatesAndCalendarViewModel(
            router: router,
            interactor: interactor,
            profileStorage: profileStorage,
            persistence: persistence,
            calendarManager: calendarManager,
            connectivity: connectivity
        )
        viewModel.calendarName = "New Calendar"

        // When
        await viewModel.deleteOldCalendarIfNeeded()

        // Then
        XCTAssertEqual(calendarManager.removeOldCalendarCallCount, 1)
        XCTAssertEqual(persistence.removeAllCourseCalendarEventsCallCount, 1)
    }
}

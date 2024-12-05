//
//  DatesAndCalendarViewModelTests.swift
//  Profile
//
//  Created by Ivan Stepanok on 30.10.2024.
//


import SwiftyMocky
import XCTest
import EventKit
@testable import Profile
@testable import Core
import Theme
import SwiftUICore
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
        Given(profileStorage, .calendarSettings(getter: settings))
        Given(profileStorage, .lastCalendarName(getter: "Old Calendar"))
        Given(profileStorage, .hideInactiveCourses(getter: true))
        
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
        Verify(calendarManager, 1, .clearAllData(removeCalendar: .value(true)))
        Verify(router, 1, .back(animated: .value(false)))
        Verify(router, 1, .showDatesAndCalendar())
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
        
        var settings = CalendarSettings(
            colorSelection: "accent",
            calendarName: "Old Calendar",
            accountSelection: "iCloud",
            courseCalendarSync: true
        )
        Given(profileStorage, .calendarSettings(getter: settings))
        
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
        
        Given(connectivity, .isInternetAvaliable(getter: true))
        Given(calendarManager, .requestAccess(willReturn: true))
        
        let courses = [
            CourseForSync(
                id: UUID(),
                courseID: "course-1",
                name: "Course 1",
                synced: true,
                recentlyActive: true
            )
        ]
        Given(interactor, .enrollmentsStatus(willReturn: courses))
        Given(persistence, .getAllCourseStates(willReturn: []))
        
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
        Verify(calendarManager, 1, .createCalendarIfNeeded())
        Verify(interactor, 1, .enrollmentsStatus())
    }
    
    func testRequestCalendarPermissionSuccess() async {
        // Given
        let router = ProfileRouterMock()
        let interactor = ProfileInteractorProtocolMock()
        let persistence = ProfilePersistenceProtocolMock()
        let calendarManager = CalendarManagerProtocolMock()
        let connectivity = ConnectivityProtocolMock()
        let profileStorage = ProfileStorageMock()
        
        Given(calendarManager, .requestAccess(willReturn: true))
        
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
        
        Given(calendarManager, .requestAccess(willReturn: false))
        
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
        
        Given(persistence, .getAllCourseStates(willReturn: states))
        Given(profileStorage, .calendarSettings(getter: settings))
        Given(connectivity, .isInternetAvaliable(getter: true))
        Given(calendarManager, .requestAccess(willReturn: true))
        
        let courses = [
            CourseForSync(
                id: UUID(),
                courseID: "course-1",
                name: "Course 1",
                synced: true,
                recentlyActive: true
            )
        ]
        Given(interactor, .enrollmentsStatus(willReturn: courses))
        
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
        Verify(calendarManager, 1, .removeOldCalendar())
        Verify(persistence, 1, .removeAllCourseCalendarEvents())
    }
}

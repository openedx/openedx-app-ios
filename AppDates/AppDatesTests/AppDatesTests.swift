//
//  AppDatesTests.swift
//  AppDatesTests
//
//  Created by Ivan Stepanok on 15.02.2025.
//

import XCTest
@testable import AppDates
@testable import Core
import SwiftUI

@MainActor
final class DatesViewModelTests: XCTestCase {

    func testLoadDatesSuccess() async throws {
        // Arrange
        let interactor = DatesInteractorProtocolMock()
        let connectivity = ConnectivityProtocolMock()
        let analytics = AppDatesAnalyticsMock()
        let courseManager = CourseStructureManagerProtocolMock()
        let router = AppDatesRouterMock()

        let viewModel = DatesViewModel(
            interactor: interactor,
            connectivity: connectivity,
            courseManager: courseManager,
            analytics: analytics,
            router: router
        )

        let date = Date()
        let courseDate1 = CourseDate(
            date: date.addingTimeInterval(60 * 60 * 24), // tomorrow
            title: "Test title 1",
            courseName: "Test Course 1",
            courseId: "course-123",
            blockId: "block-123",
            hasAccess: true
        )

        let courseDate2 = CourseDate(
            date: date.addingTimeInterval(60 * 60 * 24 * 7), // next week
            title: "Test title 2",
            courseName: "Test Course 2",
            courseId: "course-456",
            blockId: "block-456",
            hasAccess: true
        )

        connectivity.isInternetAvaliable = true
        interactor.getCourseDatesOfflineHandler = { _, _ in [courseDate1, courseDate2] }
        interactor.getCourseDatesHandler = { _ in ([courseDate1, courseDate2], nil) }

        // Act
        await viewModel.loadDates()

        // Assert
        XCTAssertEqual(interactor.getCourseDatesOfflineCallCount, 1)
        XCTAssertEqual(interactor.getCourseDatesCallCount, 1)

        XCTAssertEqual(viewModel.coursesDates.count, 2)
        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertFalse(viewModel.noDates)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.showError)
    }

    func testLoadDatesOfflineSuccess() async throws {
        // Arrange
        let interactor = DatesInteractorProtocolMock()
        let connectivity = ConnectivityProtocolMock()
        let analytics = AppDatesAnalyticsMock()
        let courseManager = CourseStructureManagerProtocolMock()
        let router = AppDatesRouterMock()

        let viewModel = DatesViewModel(
            interactor: interactor,
            connectivity: connectivity,
            courseManager: courseManager,
            analytics: analytics,
            router: router
        )

        let date = Date()
        let courseDate1 = CourseDate(
            date: date.addingTimeInterval(-60 * 60 * 24), // yesterday (pastDue)
            title: "Test title 1",
            courseName: "Test Course 1",
            courseId: "course-123",
            blockId: "block-123",
            hasAccess: true
        )

        let courseDate2 = CourseDate(
            date: date.addingTimeInterval(60 * 60), // later today (not past due)
            title: "Test title 2",
            courseName: "Test Course 2",
            courseId: "course-456",
            blockId: "block-456",
            hasAccess: true
        )

        connectivity.isInternetAvaliable = false
        interactor.getCourseDatesOfflineHandler = { _, _ in [courseDate1, courseDate2] }

        // Act
        await viewModel.loadDates()

        // Assert
        XCTAssertEqual(interactor.getCourseDatesOfflineCallCount, 1)

        XCTAssertEqual(viewModel.coursesDates.count, 2)
        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertFalse(viewModel.noDates)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.showError)
        XCTAssertTrue(viewModel.showShiftDueDatesView)
    }

    func testLoadDatesNoCachedDataError() async throws {
        // Arrange
        let interactor = DatesInteractorProtocolMock()
        let connectivity = ConnectivityProtocolMock()
        let analytics = AppDatesAnalyticsMock()
        let courseManager = CourseStructureManagerProtocolMock()
        let router = AppDatesRouterMock()

        let viewModel = DatesViewModel(
            interactor: interactor,
            connectivity: connectivity,
            courseManager: courseManager,
            analytics: analytics,
            router: router
        )

        connectivity.isInternetAvaliable = true
        interactor.getCourseDatesOfflineHandler = { _, _ in throw NoCachedDataError() }

        // Act
        await viewModel.loadDates()

        // Assert
        XCTAssertEqual(interactor.getCourseDatesOfflineCallCount, 1)

        XCTAssertTrue(viewModel.coursesDates.isEmpty)
        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.slowOrNoInternetConnection)
        XCTAssertTrue(viewModel.showError)
    }

    func testLoadDatesUnknownError() async throws {
        // Arrange
        let interactor = DatesInteractorProtocolMock()
        let connectivity = ConnectivityProtocolMock()
        let analytics = AppDatesAnalyticsMock()
        let courseManager = CourseStructureManagerProtocolMock()
        let router = AppDatesRouterMock()

        let viewModel = DatesViewModel(
            interactor: interactor,
            connectivity: connectivity,
            courseManager: courseManager,
            analytics: analytics,
            router: router
        )

        connectivity.isInternetAvaliable = true
        interactor.getCourseDatesOfflineHandler = { _, _ in
            throw NSError(domain: "error", code: -1, userInfo: nil)
        }

        // Act
        await viewModel.loadDates()

        // Assert
        XCTAssertEqual(interactor.getCourseDatesOfflineCallCount, 1)

        XCTAssertTrue(viewModel.coursesDates.isEmpty)
        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.unknownError)
        XCTAssertTrue(viewModel.showError)
    }

    func testLoadNextPage() async throws {
        // Arrange
        let interactor = DatesInteractorProtocolMock()
        let connectivity = ConnectivityProtocolMock()
        let analytics = AppDatesAnalyticsMock()
        let courseManager = CourseStructureManagerProtocolMock()
        let router = AppDatesRouterMock()

        let viewModel = DatesViewModel(
            interactor: interactor,
            connectivity: connectivity,
            courseManager: courseManager,
            analytics: analytics,
            router: router
        )

        let date = Date()
        let dates = (0...22).map { i in
            CourseDate(
                date: date.addingTimeInterval(Double(i) * 60 * 60 * 24),
                title: "Test title \(i)",
                courseName: "Test Course \(i)",
                courseId: "course-\(i)",
                blockId: "block-\(i)",
                hasAccess: true
            )
        }

        connectivity.isInternetAvaliable = true
        interactor.getCourseDatesOfflineHandler = { _, _ in Array(dates.prefix(20)) }
        interactor.getCourseDatesHandler = { _ in (dates, "next-page") }

        // Act
        await viewModel.loadDates()
        await viewModel.loadNextPageIfNeeded(for: dates[17])

        // Assert
        XCTAssertEqual(interactor.getCourseDatesOfflineCallCount, 1)
        XCTAssertEqual(interactor.getCourseDatesCallCount, 1)

        XCTAssertFalse(viewModel.isLoadingNextPage)
        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertFalse(viewModel.delayedLoadSecondPage)
    }

    func testLoadNextPageDelayedLoad() async throws {
        // Arrange
        let interactor = DatesInteractorProtocolMock()
        let connectivity = ConnectivityProtocolMock()
        let analytics = AppDatesAnalyticsMock()
        let courseManager = CourseStructureManagerProtocolMock()
        let router = AppDatesRouterMock()

        let viewModel = DatesViewModel(
            interactor: interactor,
            connectivity: connectivity,
            courseManager: courseManager,
            analytics: analytics,
            router: router
        )

        let date = Date()
        let dates = (0...22).map { i in
            CourseDate(
                date: date.addingTimeInterval(Double(i) * 60 * 60 * 24),
                title: "Test title \(i)",
                courseName: "Test Course \(i)",
                courseId: "course-\(i)",
                blockId: "block-\(i)",
                hasAccess: true
            )
        }

        connectivity.isInternetAvaliable = true
        interactor.getCourseDatesOfflineHandler = { _, _ in Array(dates.prefix(20)) }
        interactor.getCourseDatesHandler = { _ in (dates, "next-page") }

        // Act
        await viewModel.loadDates()
        await viewModel.loadNextPageIfNeeded(for: dates[17])
        XCTAssertFalse(viewModel.fetchInProgress)
    }

    func testShiftDueDates() async throws {
        // Arrange
        let interactor = DatesInteractorProtocolMock()
        let connectivity = ConnectivityProtocolMock()
        let analytics = AppDatesAnalyticsMock()
        let courseManager = CourseStructureManagerProtocolMock()
        let router = AppDatesRouterMock()

        let viewModel = DatesViewModel(
            interactor: interactor,
            connectivity: connectivity,
            courseManager: courseManager,
            analytics: analytics,
            router: router
        )

        // Setup past due date
        let date = Date()
        let pastDueDate = CourseDate(
            date: date.addingTimeInterval(-60 * 60 * 24), // yesterday
            title: "Past Due",
            courseName: "Test Course",
            courseId: "course-123",
            blockId: "block-123",
            hasAccess: true
        )

        connectivity.isInternetAvaliable = true
        interactor.resetAllRelativeCourseDeadlinesHandler = { }
        interactor.getCourseDatesHandler = { _ in ([], nil) }
        interactor.getCourseDatesOfflineHandler = { _, _ in [] }

        // Setup coursesDates with a pastDue group
        viewModel.coursesDates = [DateGroup(type: .pastDue, dates: [pastDueDate])]

        // Act
        await viewModel.shiftDueDates()

        // Assert
        XCTAssertEqual(interactor.resetAllRelativeCourseDeadlinesCallCount, 1)

        XCTAssertFalse(viewModel.isShowProgressForDueDates)
        XCTAssertFalse(viewModel.showShiftDueDatesView)
    }

    func testShiftDueDatesWithError() async throws {
        // Arrange
        let interactor = DatesInteractorProtocolMock()
        let connectivity = ConnectivityProtocolMock()
        let analytics = AppDatesAnalyticsMock()
        let courseManager = CourseStructureManagerProtocolMock()
        let router = AppDatesRouterMock()

        let viewModel = DatesViewModel(
            interactor: interactor,
            connectivity: connectivity,
            courseManager: courseManager,
            analytics: analytics,
            router: router
        )

        // Setup past due date
        let date = Date()
        let pastDueDate = CourseDate(
            date: date.addingTimeInterval(-60 * 60 * 24), // yesterday
            title: "Past Due",
            courseName: "Test Course",
            courseId: "course-123",
            blockId: "block-123",
            hasAccess: true
        )

        // Setup coursesDates with a pastDue group
        viewModel.coursesDates = [DateGroup(type: .pastDue, dates: [pastDueDate])]

        // Test internet error
        connectivity.isInternetAvaliable = true
        interactor.resetAllRelativeCourseDeadlinesHandler = { throw NoCachedDataError() }

        // Act
        await viewModel.shiftDueDates()

        // Assert
        XCTAssertEqual(interactor.resetAllRelativeCourseDeadlinesCallCount, 1)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.slowOrNoInternetConnection)
        XCTAssertTrue(viewModel.showError)
        XCTAssertFalse(viewModel.isShowProgressForDueDates)

        // Reset state
        viewModel.errorMessage = nil
        viewModel.showError = false

        // Test unknown error
        interactor.resetAllRelativeCourseDeadlinesHandler = {
            throw NSError(domain: "error", code: -1, userInfo: nil)
        }

        // Act
        await viewModel.shiftDueDates()

        // Assert
        XCTAssertEqual(interactor.resetAllRelativeCourseDeadlinesCallCount, 2)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.unknownError)
        XCTAssertTrue(viewModel.showError)
        XCTAssertFalse(viewModel.isShowProgressForDueDates)
    }
}

//
//  AppDatesTests.swift
//  AppDatesTests
//
//  Created by Ivan Stepanok on 15.02.2025.
//

import XCTest
import SwiftyMocky
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
        
        Given(connectivity, .isInternetAvaliable(getter: true))
        Given(interactor, .getCourseDatesOffline(limit: .value(20), offset: .value(0), willReturn: [courseDate1, courseDate2]))
        Given(interactor, .getCourseDates(page: .value(1), willReturn: ([courseDate1, courseDate2], nil)))
        
        // Act
        await viewModel.loadDates()
        
        // Assert
        Verify(interactor, 1, .getCourseDatesOffline(limit: .value(20), offset: .value(0)))
        Verify(interactor, 1, .getCourseDates(page: .value(1)))
        
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
            date: date, // today
            title: "Test title 2",
            courseName: "Test Course 2",
            courseId: "course-456",
            blockId: "block-456",
            hasAccess: true
        )
        
        Given(connectivity, .isInternetAvaliable(getter: false))
        Given(interactor, .getCourseDatesOffline(limit: .value(nil), offset: .value(nil), willReturn: [courseDate1, courseDate2]))
        
        // Act
        await viewModel.loadDates()
        
        // Assert
        Verify(interactor, 1, .getCourseDatesOffline(limit: .value(nil), offset: .value(nil)))
        
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
        
        Given(connectivity, .isInternetAvaliable(getter: true))
        Given(interactor, .getCourseDatesOffline(limit: .any, offset: .any, willThrow: NoCachedDataError()))
        
        // Act
        await viewModel.loadDates()
        
        // Assert
        Verify(interactor, 1, .getCourseDatesOffline(limit: .value(20), offset: .value(0)))
        
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
        
        Given(connectivity, .isInternetAvaliable(getter: true))
        Given(interactor, .getCourseDatesOffline(limit: .any, offset: .any, willThrow: NSError()))
        
        // Act
        await viewModel.loadDates()
        
        // Assert
        Verify(interactor, 1, .getCourseDatesOffline(limit: .value(20), offset: .value(0)))
        
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
        
        Given(connectivity, .isInternetAvaliable(getter: true))
        Given(interactor, .getCourseDatesOffline(limit: .value(20), offset: .value(0), willReturn: Array(dates.prefix(20))))
        Given(interactor, .getCourseDates(page: .any, willReturn: (dates, "next-page")))
        
        // Act
        await viewModel.loadDates()
        await viewModel.loadNextPageIfNeeded(for: dates[17])
        
        // Assert
        Verify(interactor, 1, .getCourseDatesOffline(limit: .value(20), offset: .value(0)))
        Verify(interactor, 1, .getCourseDates(page: .value(1)))
        
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
        
        Given(connectivity, .isInternetAvaliable(getter: true))
        Given(interactor, .getCourseDatesOffline(limit: .value(20), offset: .value(0), willReturn: Array(dates.prefix(20))))
        Given(interactor, .getCourseDates(page: .any, willReturn: (dates, "next-page")))
        
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
        
        Given(connectivity, .isInternetAvaliable(getter: true))
        Given(interactor, .resetAllRelativeCourseDeadlines(willProduce: {_ in }))
        Given(interactor, .getCourseDates(page: .value(1), willReturn: ([], nil)))
        Given(interactor, .getCourseDatesOffline(limit: .value(20), offset: .value(0), willReturn: []))
        
        // Setup coursesDates with a pastDue group
        viewModel.coursesDates = [DateGroup(type: .pastDue, dates: [pastDueDate])]
        
        // Act
        await viewModel.shiftDueDates()
        
        // Assert
        Verify(interactor, 1, .resetAllRelativeCourseDeadlines())
        
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
        Given(connectivity, .isInternetAvaliable(getter: true))
        Given(interactor, .resetAllRelativeCourseDeadlines(willThrow: NoCachedDataError()))
        
        // Act
        await viewModel.shiftDueDates()
        
        // Assert
        Verify(interactor, 1, .resetAllRelativeCourseDeadlines())
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.slowOrNoInternetConnection)
        XCTAssertTrue(viewModel.showError)
        XCTAssertFalse(viewModel.isShowProgressForDueDates)
        
        // Reset state
        viewModel.errorMessage = nil
        viewModel.showError = false
        
        // Test unknown error
        Given(interactor, .resetAllRelativeCourseDeadlines(willThrow: NSError()))
        
        // Act
        await viewModel.shiftDueDates()
        
        // Assert
        Verify(interactor, 2, .resetAllRelativeCourseDeadlines())
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.unknownError)
        XCTAssertTrue(viewModel.showError)
        XCTAssertFalse(viewModel.isShowProgressForDueDates)
    }
}

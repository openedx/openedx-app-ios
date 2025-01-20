//
//  CourseDateViewModelTests.swift
//  CourseTests
//
//  Created by Muhammad Umer on 10/24/23.
//

import XCTest
import Alamofire
import SwiftyMocky
@testable import Core
@testable import Course

@MainActor
final class CourseDateViewModelTests: XCTestCase {
    func testGetCourseDatesSuccess() async throws {
        let interactor = CourseInteractorProtocolMock()
        let router = CourseRouterMock()
        let cssInjector = CSSInjectorMock()
        let connectivity = ConnectivityProtocolMock()
        let config = ConfigMock()
        
        let courseDates = CourseDates(
            datesBannerInfo:
                DatesBannerInfo(
                    missedDeadlines: false,
                    contentTypeGatingEnabled: false,
                    missedGatedContent: false,
                    verifiedUpgradeLink: "",
                    status: .resetDatesBanner),
            courseDateBlocks: [],
            hasEnded: false,
            learnerIsFullAccess: false,
            userTimezone: nil)
        
        let courseStructure = CourseStructure(
            id: "123",
            graded: true,
            completion: 0,
            viewYouTubeUrl: "",
            encodedVideo: "",
            displayName: "",
            topicID: nil,
            childs: [],
            media: CourseMedia(
                image: CourseImage(
                    raw: "",
                    small: "",
                    large: ""
                )
            ),
            certificate: nil,
            org: "",
            isSelfPaced: true,
            courseProgress: nil
        )
        
        Given(interactor, .getCourseDates(courseID: .any, willReturn: courseDates))
        Given(interactor, .getLoadedCourseBlocks(courseID: .any, willReturn: courseStructure))
        
        let viewModel = CourseDatesViewModel(
            interactor: interactor,
            router: router,
            cssInjector: cssInjector,
            connectivity: connectivity,
            config: config,
            courseID: "1",
            courseName: "a",
            analytics: CourseAnalyticsMock(), 
            calendarManager: CalendarManagerMock()
        )
        
        await viewModel.getCourseDates(courseID: "1")
        
        Verify(interactor, .getCourseDates(courseID: .any))
        
        XCTAssert((viewModel.courseDates != nil))
        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.showError)
    }
    
    func testGetCourseDatesUnknownError() async throws {
        let interactor = CourseInteractorProtocolMock()
        let router = CourseRouterMock()
        let cssInjector = CSSInjectorMock()
        let connectivity = ConnectivityProtocolMock()
        let config = ConfigMock()
        
        Given(interactor, .getCourseDates(courseID: .any, willThrow: NSError()))
        
        let viewModel = CourseDatesViewModel(
            interactor: interactor,
            router: router,
            cssInjector: cssInjector,
            connectivity: connectivity,
            config: config,
            courseID: "1",
            courseName: "a",
            analytics: CourseAnalyticsMock(),
            calendarManager: CalendarManagerMock()
        )
        
        await viewModel.getCourseDates(courseID: "1")
        
        Verify(interactor, .getCourseDates(courseID: .any))
        
        XCTAssertNil(viewModel.courseDates)
        XCTAssertFalse(viewModel.isShowProgress)
    }
    
    func testNoInternetConnectionError() async throws {
        let interactor = CourseInteractorProtocolMock()
        let router = CourseRouterMock()
        let cssInjector = CSSInjectorMock()
        let connectivity = ConnectivityProtocolMock()
        let config = ConfigMock()
        
        let noInternetError = AFError.sessionInvalidated(error: URLError(.notConnectedToInternet))
        
        Given(interactor, .getCourseDates(courseID: .any, willThrow: noInternetError))
        
        let viewModel = CourseDatesViewModel(
            interactor: interactor,
            router: router,
            cssInjector: cssInjector,
            connectivity: connectivity,
            config: config,
            courseID: "1",
            courseName: "a",
            analytics: CourseAnalyticsMock(),
            calendarManager: CalendarManagerMock()
        )
        
        await viewModel.getCourseDates(courseID: "1")
        
        Verify(interactor, .getCourseDates(courseID: .any))
        
        XCTAssertNil(viewModel.courseDates)
        XCTAssertFalse(viewModel.isShowProgress)
    }
    
    func testSortedDateTodayToCourseDateBlockDict() {
        let block1 = CourseDateBlock(
            assignmentType: nil,
            complete: nil,
            date: Date.today.addingTimeInterval(86400),
            dateType: "event",
            description: "",
            learnerHasAccess: true,
            link: "www.example.com",
            linkText: nil,
            title: "TestBlock",
            extraInfo: nil,
            firstComponentBlockID: "blockID1",
            useRelativeDates: true
        )
        
        let block2 = CourseDateBlock(
            assignmentType: nil,
            complete: true,
            date: Date.today,
            dateType: "event",
            description: "",
            learnerHasAccess: true,
            link: "www.example.com",
            linkText: nil,
            title: "TestBlock",
            extraInfo: nil,
            firstComponentBlockID: "blockID1",
            useRelativeDates: true
        )
        
        let courseDates = CourseDates(
            datesBannerInfo: DatesBannerInfo(
                missedDeadlines: false,
                contentTypeGatingEnabled: false,
                missedGatedContent: false,
                verifiedUpgradeLink: nil,
                status: .resetDatesBanner
            ),
            courseDateBlocks: [block1, block2],
            hasEnded: false,
            learnerIsFullAccess: true,
            userTimezone: nil
        )
        
        let sortedDict = courseDates.statusDatesBlocks[.completed]
        
        XCTAssertEqual(sortedDict?.keys.sorted().first, Date.today)
    }
    
    func testMultipleBlocksForSameDate() {
        let block1 = CourseDateBlock(
            assignmentType: nil,
            complete: true,
            date: Date.today,
            dateType: "event",
            description: "",
            learnerHasAccess: true,
            link: "www.example.com",
            linkText: nil,
            title: "TestBlock",
            extraInfo: nil,
            firstComponentBlockID: "blockID1", 
            useRelativeDates: true
        )
        
        let block2 = CourseDateBlock(
            assignmentType: nil,
            complete: true,
            date: Date.today,
            dateType: "event",
            description: "",
            learnerHasAccess: true,
            link: "www.example.com",
            linkText: nil,
            title: "TestBlock",
            extraInfo: nil,
            firstComponentBlockID: "blockID1",
            useRelativeDates: true
        )
        
        let courseDates = CourseDates(
            datesBannerInfo: DatesBannerInfo(
                missedDeadlines: false,
                contentTypeGatingEnabled: false,
                missedGatedContent: false,
                verifiedUpgradeLink: nil,
                status: .resetDatesBanner
            ),
            courseDateBlocks: [block1, block2],
            hasEnded: false,
            learnerIsFullAccess: true,
            userTimezone: nil
        )
        
        let sortedDict = courseDates.statusDatesBlocks[.completed]
        XCTAssertEqual(sortedDict?[block1.date]?.count, 2, "There should be two blocks for the given date.")
    }
    
    func testBlockStatusForAssignmentType() {
        let block = CourseDateBlock(
            assignmentType: nil,
            complete: nil,
            date: Date.today,
            dateType: "assignment-due-date",
            description: "",
            learnerHasAccess: true,
            link: "www.example.com",
            linkText: nil,
            title: "TestAssignment",
            extraInfo: nil,
            firstComponentBlockID: "blockID3",
            useRelativeDates: true
        )
                
        XCTAssertEqual(block.blockStatus, .dueNext)
    }
        
    func testBadgeLogicForToday() {
        let block = CourseDateBlock(
            assignmentType: nil,
            complete: false,
            date: Date.today,
            dateType: "",
            description: "",
            learnerHasAccess: false,
            link: "www.example.com",
            linkText: nil,
            title: CourseLocalization.CourseDates.today,
            extraInfo: nil,
            firstComponentBlockID: "blockIDTest",
            useRelativeDates: true
        )
        
        XCTAssertEqual(block.title, "Today", "Block title for 'today' should be 'Today'")
    }
    
    func testBadgeLogicForCompleted() {
        let block = CourseDateBlock(
            assignmentType: nil,
            complete: true,
            date: Date.today,
            dateType: "assignment-due-date",
            description: "",
            learnerHasAccess: true,
            link: "www.example.com",
            linkText: nil,
            title: "TestBlock",
            extraInfo: nil,
            firstComponentBlockID: "blockIDTest",
            useRelativeDates: true
        )
        XCTAssertEqual(block.blockStatus, .completed, "Block status for a completed assignment should be 'completed'")
    }
    
    func testBadgeLogicForVerifiedOnly() {
        let block = CourseDateBlock(
            assignmentType: nil,
            complete: false,
            date: Date.today,
            dateType: "assignment-due-date",
            description: "",
            learnerHasAccess: false,
            link: "www.example.com",
            linkText: nil,
            title: "TestBlock",
            extraInfo: nil,
            firstComponentBlockID: "blockIDTest",
            useRelativeDates: true
        )
        
        XCTAssertEqual(block.blockStatus, .verifiedOnly, "Block status for a block without learner access should be 'verifiedOnly'")
    }
    
    func testBadgeLogicForPastDue() {
        let block = CourseDateBlock(
            assignmentType: nil,
            complete: false,
            date: Date.today.addingTimeInterval(-86400),
            dateType: "assignment-due-date",
            description: "",
            learnerHasAccess: true,
            link: "www.example.com",
            linkText: nil,
            title: "TestBlock",
            extraInfo: nil,
            firstComponentBlockID: "blockIDTest",
            useRelativeDates: true
        )
        
        XCTAssertEqual(block.blockStatus, .pastDue, "Block status for a past due assignment should be 'pastDue'")
    }
    
    func testLinkForAvailableAssignment() {
        let availableAssignment = CourseDateBlock(
            assignmentType: nil,
            complete: true,
            date: Date.today,
            dateType: "assignment-due-date",
            description: "",
            learnerHasAccess: true,
            link: "www.example.com",
            linkText: nil,
            title: "TestBlock",
            extraInfo: nil,
            firstComponentBlockID: "blockIDTest",
            useRelativeDates: true
        )
        XCTAssertTrue(availableAssignment.canShowLink, "Available assignments should be hyperlinked.")
    }
    
    func testIsAssignment() {
        let block = CourseDateBlock(
            assignmentType: nil,
            complete: false,
            date: Date.today.addingTimeInterval(86400),
            dateType: "assignment-due-date",
            description: "",
            learnerHasAccess: false,
            link: "www.example.com",
            linkText: nil,
            title: "TestBlock",
            extraInfo: nil,
            firstComponentBlockID: "blockIDTest",
            useRelativeDates: true
        )
        
        XCTAssertTrue(block.isAssignment)
    }
    
    func testIsCourseStartDate() {
        let block = CourseDateBlock(
            assignmentType: nil,
            complete: nil,
            date: Date.today.addingTimeInterval(-86400),
            dateType: "course-start-date",
            description: "",
            learnerHasAccess: true,
            link: "www.example.com",
            linkText: nil,
            title: "TestBlock",
            extraInfo: nil,
            firstComponentBlockID: "blockIDTest",
            useRelativeDates: true
        )
                
        XCTAssertEqual(block.blockStatus, BlockStatus.courseStartDate)
    }
    
    func testIsCourseEndDate() {
        let block = CourseDateBlock(
            assignmentType: nil,
            complete: nil,
            date: Date.today.addingTimeInterval(86400),
            dateType: "course-end-date",
            description: "",
            learnerHasAccess: true,
            link: "www.example.com",
            linkText: nil,
            title: "TestBlock",
            extraInfo: nil,
            firstComponentBlockID: "blockIDTest",
            useRelativeDates: true
        )
        
        XCTAssertEqual(block.blockStatus, BlockStatus.courseEndDate)
    }
    
    func testVerifiedOnly() {
        let block = CourseDateBlock(
            assignmentType: nil,
            complete: false,
            date: Date.today.addingTimeInterval(86400),
            dateType: "assignment-due-date",
            description: "",
            learnerHasAccess: false,
            link: "www.example.com",
            linkText: nil,
            title: "TestBlock",
            extraInfo: nil,
            firstComponentBlockID: "blockIDTest",
            useRelativeDates: true
        )
        
        XCTAssertTrue(block.isVerifiedOnly, "Block should be identified as 'verified only' when the learner has no access.")
    }
    
    func testIsCompleted() {
        let block = CourseDateBlock(
            assignmentType: nil,
            complete: true,
            date: Date.today,
            dateType: "assignment-due-date",
            description: "",
            learnerHasAccess: false,
            link: "www.example.com",
            linkText: nil,
            title: "TestBlock",
            extraInfo: nil,
            firstComponentBlockID: "blockIDTest",
            useRelativeDates: true
        )
        
        XCTAssertTrue(block.isComplete, "Block should be marked as completed.")
    }
    
    func testBadgeLogicForUnreleasedAssignment() {
        let block = CourseDateBlock(
            assignmentType: nil,
            complete: false,
            date: Date.today.addingTimeInterval(86400),
            dateType: "assignment-due-date",
            description: "",
            learnerHasAccess: true,
            link: "",
            linkText: nil,
            title: "TestBlock",
            extraInfo: nil,
            firstComponentBlockID: "blockIDTest",
            useRelativeDates: true
        )
        
        XCTAssertEqual(block.blockStatus, .unreleased, "Block status should be set to 'unreleased' for unreleased assignments.")
    }
        
    func testNoLinkForUnavailableAssignment() {
        let block = CourseDateBlock(
            assignmentType: nil,
            complete: false,
            date: Date.today.addingTimeInterval(86400),
            dateType: "assignment-due-date",
            description: "",
            learnerHasAccess: false,
            link: "www.example.com",
            linkText: nil,
            title: "TestBlock",
            extraInfo: nil,
            firstComponentBlockID: "blockIDTest",
            useRelativeDates: true
        )
        
        XCTAssertEqual(block.blockStatus, .verifiedOnly)
        XCTAssertFalse(block.canShowLink, "Block should not show a link if the assignment is unavailable.")
    }
    
    func testNoLinkAvailableForUnreleasedAssignment() {
        let block = CourseDateBlock(
            assignmentType: nil,
            complete: false,
            date: Date.today,
            dateType: "assignment-due-date",
            description: "",
            learnerHasAccess: true,
            link: "",
            linkText: nil,
            title: "TestBlock",
            extraInfo: nil,
            firstComponentBlockID: "blockIDTest",
            useRelativeDates: true
        )
        
        XCTAssertEqual(block.blockStatus, .unreleased)
        XCTAssertFalse(block.canShowLink, "Block should not show a link if the assignment is unreleased.")
    }
    
    func testTodayProperty() {
        let today = Date.today
        let currentDay = Calendar.current.startOfDay(for: Date())
        XCTAssertTrue(today.isToday, "The today property should return true for isToday.")
        XCTAssertEqual(today, currentDay, "The today property should equal the start of the current day.")
    }
    
    func testDateIsInPastProperty() {
        let pastDate = Date().addingTimeInterval(-100000)
        XCTAssertTrue(pastDate.isInPast, "The past date should return true for isInPast.")
        XCTAssertFalse(pastDate.isToday, "The past date should return false for isInPast.")
    }
    
    func testDateIsInFutureProperty() {
        let futureDate = Date().addingTimeInterval(100000)
        XCTAssertTrue(futureDate.isInFuture, "The future date should return false for isInFuture.")
        XCTAssertFalse(futureDate.isToday, "The future date should return false for isInFuture.")
    }
    
    func testBlockStatusMapping() {
        XCTAssertEqual(BlockStatus.status(of: "course-start-date"), .courseStartDate, "Incorrect mapping for 'course-start-date'")
        XCTAssertEqual(BlockStatus.status(of: "course-end-date"), .courseEndDate, "Incorrect mapping for 'course-end-date'")
        XCTAssertEqual(BlockStatus.status(of: "certificate-available-date"), .certificateAvailbleDate, "Incorrect mapping for 'certificate-available-date'")
        XCTAssertEqual(BlockStatus.status(of: "verification-deadline-date"), .verificationDeadlineDate, "Incorrect mapping for 'verification-deadline-date'")
        XCTAssertEqual(BlockStatus.status(of: "verified-upgrade-deadline"), .verifiedUpgradeDeadline, "Incorrect mapping for 'verified-upgrade-deadline'")
        XCTAssertEqual(BlockStatus.status(of: "assignment-due-date"), .assignment, "Incorrect mapping for 'assignment-due-date'")
        XCTAssertEqual(BlockStatus.status(of: ""), .event, "Incorrect mapping for 'event'")
    }
}

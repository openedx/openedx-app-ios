// Generated using Sourcery 2.1.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


// Generated with SwiftyMocky 4.2.0
// Required Sourcery: 1.8.0


import SwiftyMocky
import XCTest
import Core
import Course
import Foundation
import SwiftUI
import Combine
import OEXFoundation


// MARK: - CourseAnalytics

open class CourseAnalyticsMock: CourseAnalytics, Mock {
    public init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
        SwiftyMockyTestObserver.setup()
        self.sequencingPolicy = sequencingPolicy
        self.stubbingPolicy = stubbingPolicy
        self.file = file
        self.line = line
    }

    var matcher: Matcher = Matcher.default
    var stubbingPolicy: StubbingPolicy = .wrap
    var sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst

    private var queue = DispatchQueue(label: "com.swiftymocky.invocations", qos: .userInteractive)
    private var invocations: [MethodType] = []
    private var methodReturnValues: [Given] = []
    private var methodPerformValues: [Perform] = []
    private var file: StaticString?
    private var line: UInt?

    public typealias PropertyStub = Given
    public typealias MethodStub = Given
    public typealias SubscriptStub = Given

    /// Convenience method - call setupMock() to extend debug information when failure occurs
    public func setupMock(file: StaticString = #file, line: UInt = #line) {
        self.file = file
        self.line = line
    }

    /// Clear mock internals. You can specify what to reset (invocations aka verify, givens or performs) or leave it empty to clear all mock internals
    public func resetMock(_ scopes: MockScope...) {
        let scopes: [MockScope] = scopes.isEmpty ? [.invocation, .given, .perform] : scopes
        if scopes.contains(.invocation) { invocations = [] }
        if scopes.contains(.given) { methodReturnValues = [] }
        if scopes.contains(.perform) { methodPerformValues = [] }
    }





    open func resumeCourseClicked(courseId: String, courseName: String, blockId: String) {
        addInvocation(.m_resumeCourseClicked__courseId_courseIdcourseName_courseNameblockId_blockId(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`), Parameter<String>.value(`blockId`)))
		let perform = methodPerformValue(.m_resumeCourseClicked__courseId_courseIdcourseName_courseNameblockId_blockId(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`), Parameter<String>.value(`blockId`))) as? (String, String, String) -> Void
		perform?(`courseId`, `courseName`, `blockId`)
    }

    open func sequentialClicked(courseId: String, courseName: String, blockId: String, blockName: String) {
        addInvocation(.m_sequentialClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`), Parameter<String>.value(`blockId`), Parameter<String>.value(`blockName`)))
		let perform = methodPerformValue(.m_sequentialClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`), Parameter<String>.value(`blockId`), Parameter<String>.value(`blockName`))) as? (String, String, String, String) -> Void
		perform?(`courseId`, `courseName`, `blockId`, `blockName`)
    }

    open func verticalClicked(courseId: String, courseName: String, blockId: String, blockName: String) {
        addInvocation(.m_verticalClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`), Parameter<String>.value(`blockId`), Parameter<String>.value(`blockName`)))
		let perform = methodPerformValue(.m_verticalClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`), Parameter<String>.value(`blockId`), Parameter<String>.value(`blockName`))) as? (String, String, String, String) -> Void
		perform?(`courseId`, `courseName`, `blockId`, `blockName`)
    }

    open func nextBlockClicked(courseId: String, courseName: String, blockId: String, blockName: String) {
        addInvocation(.m_nextBlockClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`), Parameter<String>.value(`blockId`), Parameter<String>.value(`blockName`)))
		let perform = methodPerformValue(.m_nextBlockClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`), Parameter<String>.value(`blockId`), Parameter<String>.value(`blockName`))) as? (String, String, String, String) -> Void
		perform?(`courseId`, `courseName`, `blockId`, `blockName`)
    }

    open func prevBlockClicked(courseId: String, courseName: String, blockId: String, blockName: String) {
        addInvocation(.m_prevBlockClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`), Parameter<String>.value(`blockId`), Parameter<String>.value(`blockName`)))
		let perform = methodPerformValue(.m_prevBlockClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`), Parameter<String>.value(`blockId`), Parameter<String>.value(`blockName`))) as? (String, String, String, String) -> Void
		perform?(`courseId`, `courseName`, `blockId`, `blockName`)
    }

    open func finishVerticalClicked(courseId: String, courseName: String, blockId: String, blockName: String) {
        addInvocation(.m_finishVerticalClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`), Parameter<String>.value(`blockId`), Parameter<String>.value(`blockName`)))
		let perform = methodPerformValue(.m_finishVerticalClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`), Parameter<String>.value(`blockId`), Parameter<String>.value(`blockName`))) as? (String, String, String, String) -> Void
		perform?(`courseId`, `courseName`, `blockId`, `blockName`)
    }

    open func finishVerticalNextSectionClicked(courseId: String, courseName: String, blockId: String, blockName: String) {
        addInvocation(.m_finishVerticalNextSectionClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`), Parameter<String>.value(`blockId`), Parameter<String>.value(`blockName`)))
		let perform = methodPerformValue(.m_finishVerticalNextSectionClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`), Parameter<String>.value(`blockId`), Parameter<String>.value(`blockName`))) as? (String, String, String, String) -> Void
		perform?(`courseId`, `courseName`, `blockId`, `blockName`)
    }

    open func finishVerticalBackToOutlineClicked(courseId: String, courseName: String) {
        addInvocation(.m_finishVerticalBackToOutlineClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`)))
		let perform = methodPerformValue(.m_finishVerticalBackToOutlineClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`))) as? (String, String) -> Void
		perform?(`courseId`, `courseName`)
    }

    open func courseOutlineCourseTabClicked(courseId: String, courseName: String) {
        addInvocation(.m_courseOutlineCourseTabClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`)))
		let perform = methodPerformValue(.m_courseOutlineCourseTabClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`))) as? (String, String) -> Void
		perform?(`courseId`, `courseName`)
    }

    open func courseOutlineContentTabClicked(courseId: String, courseName: String) {
        addInvocation(.m_courseOutlineContentTabClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`)))
		let perform = methodPerformValue(.m_courseOutlineContentTabClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`))) as? (String, String) -> Void
		perform?(`courseId`, `courseName`)
    }

    open func courseOutlineProgressTabClicked(courseId: String, courseName: String) {
        addInvocation(.m_courseOutlineProgressTabClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`)))
		let perform = methodPerformValue(.m_courseOutlineProgressTabClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`))) as? (String, String) -> Void
		perform?(`courseId`, `courseName`)
    }

    open func courseOutlineVideosTabClicked(courseId: String, courseName: String) {
        addInvocation(.m_courseOutlineVideosTabClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`)))
		let perform = methodPerformValue(.m_courseOutlineVideosTabClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`))) as? (String, String) -> Void
		perform?(`courseId`, `courseName`)
    }

    open func courseOutlineOfflineTabClicked(courseId: String, courseName: String) {
        addInvocation(.m_courseOutlineOfflineTabClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`)))
		let perform = methodPerformValue(.m_courseOutlineOfflineTabClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`))) as? (String, String) -> Void
		perform?(`courseId`, `courseName`)
    }

    open func courseOutlineDatesTabClicked(courseId: String, courseName: String) {
        addInvocation(.m_courseOutlineDatesTabClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`)))
		let perform = methodPerformValue(.m_courseOutlineDatesTabClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`))) as? (String, String) -> Void
		perform?(`courseId`, `courseName`)
    }

    open func courseOutlineDiscussionTabClicked(courseId: String, courseName: String) {
        addInvocation(.m_courseOutlineDiscussionTabClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`)))
		let perform = methodPerformValue(.m_courseOutlineDiscussionTabClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`))) as? (String, String) -> Void
		perform?(`courseId`, `courseName`)
    }

    open func courseOutlineHandoutsTabClicked(courseId: String, courseName: String) {
        addInvocation(.m_courseOutlineHandoutsTabClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`)))
		let perform = methodPerformValue(.m_courseOutlineHandoutsTabClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`))) as? (String, String) -> Void
		perform?(`courseId`, `courseName`)
    }

    open func courseOutlineAssignmentsTabClicked(courseId: String, courseName: String) {
        addInvocation(.m_courseOutlineAssignmentsTabClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`)))
		let perform = methodPerformValue(.m_courseOutlineAssignmentsTabClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`))) as? (String, String) -> Void
		perform?(`courseId`, `courseName`)
    }

    open func courseContentAllTabClicked(courseId: String, courseName: String) {
        addInvocation(.m_courseContentAllTabClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`)))
		let perform = methodPerformValue(.m_courseContentAllTabClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`))) as? (String, String) -> Void
		perform?(`courseId`, `courseName`)
    }

    open func courseContentVideosTabClicked(courseId: String, courseName: String) {
        addInvocation(.m_courseContentVideosTabClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`)))
		let perform = methodPerformValue(.m_courseContentVideosTabClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`))) as? (String, String) -> Void
		perform?(`courseId`, `courseName`)
    }

    open func courseContentAssignmentsTabClicked(courseId: String, courseName: String) {
        addInvocation(.m_courseContentAssignmentsTabClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`)))
		let perform = methodPerformValue(.m_courseContentAssignmentsTabClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`))) as? (String, String) -> Void
		perform?(`courseId`, `courseName`)
    }

    open func courseVideoClicked(courseId: String, courseName: String, blockId: String, blockName: String) {
        addInvocation(.m_courseVideoClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`), Parameter<String>.value(`blockId`), Parameter<String>.value(`blockName`)))
		let perform = methodPerformValue(.m_courseVideoClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`), Parameter<String>.value(`blockId`), Parameter<String>.value(`blockName`))) as? (String, String, String, String) -> Void
		perform?(`courseId`, `courseName`, `blockId`, `blockName`)
    }

    open func courseAssignmentClicked(courseId: String, courseName: String, blockId: String, blockName: String) {
        addInvocation(.m_courseAssignmentClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`), Parameter<String>.value(`blockId`), Parameter<String>.value(`blockName`)))
		let perform = methodPerformValue(.m_courseAssignmentClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`), Parameter<String>.value(`blockId`), Parameter<String>.value(`blockName`))) as? (String, String, String, String) -> Void
		perform?(`courseId`, `courseName`, `blockId`, `blockName`)
    }

    open func contentPageSectionClicked(courseId: String, courseName: String, blockId: String, blockName: String) {
        addInvocation(.m_contentPageSectionClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`), Parameter<String>.value(`blockId`), Parameter<String>.value(`blockName`)))
		let perform = methodPerformValue(.m_contentPageSectionClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`), Parameter<String>.value(`blockId`), Parameter<String>.value(`blockName`))) as? (String, String, String, String) -> Void
		perform?(`courseId`, `courseName`, `blockId`, `blockName`)
    }

    open func contentPageShowCompletedSubsectionClicked(courseId: String, courseName: String) {
        addInvocation(.m_contentPageShowCompletedSubsectionClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`)))
		let perform = methodPerformValue(.m_contentPageShowCompletedSubsectionClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`))) as? (String, String) -> Void
		perform?(`courseId`, `courseName`)
    }

    open func progressTabClicked(courseId: String, courseName: String) {
        addInvocation(.m_progressTabClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`)))
		let perform = methodPerformValue(.m_progressTabClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`))) as? (String, String) -> Void
		perform?(`courseId`, `courseName`)
    }

    open func courseHomeViewAllContentClicked(courseId: String, courseName: String) {
        addInvocation(.m_courseHomeViewAllContentClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`)))
		let perform = methodPerformValue(.m_courseHomeViewAllContentClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`))) as? (String, String) -> Void
		perform?(`courseId`, `courseName`)
    }

    open func courseHomeVideoClicked(courseId: String, courseName: String, blockId: String, blockName: String) {
        addInvocation(.m_courseHomeVideoClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`), Parameter<String>.value(`blockId`), Parameter<String>.value(`blockName`)))
		let perform = methodPerformValue(.m_courseHomeVideoClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`), Parameter<String>.value(`blockId`), Parameter<String>.value(`blockName`))) as? (String, String, String, String) -> Void
		perform?(`courseId`, `courseName`, `blockId`, `blockName`)
    }

    open func courseHomeViewAllVideosClicked(courseId: String, courseName: String) {
        addInvocation(.m_courseHomeViewAllVideosClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`)))
		let perform = methodPerformValue(.m_courseHomeViewAllVideosClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`))) as? (String, String) -> Void
		perform?(`courseId`, `courseName`)
    }

    open func courseHomeAssignmentClicked(courseId: String, courseName: String, blockId: String, blockName: String) {
        addInvocation(.m_courseHomeAssignmentClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`), Parameter<String>.value(`blockId`), Parameter<String>.value(`blockName`)))
		let perform = methodPerformValue(.m_courseHomeAssignmentClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`), Parameter<String>.value(`blockId`), Parameter<String>.value(`blockName`))) as? (String, String, String, String) -> Void
		perform?(`courseId`, `courseName`, `blockId`, `blockName`)
    }

    open func courseHomeViewAllAssignmentsClicked(courseId: String, courseName: String) {
        addInvocation(.m_courseHomeViewAllAssignmentsClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`)))
		let perform = methodPerformValue(.m_courseHomeViewAllAssignmentsClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`))) as? (String, String) -> Void
		perform?(`courseId`, `courseName`)
    }

    open func courseHomeGradesViewProgressClicked(courseId: String, courseName: String) {
        addInvocation(.m_courseHomeGradesViewProgressClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`)))
		let perform = methodPerformValue(.m_courseHomeGradesViewProgressClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`))) as? (String, String) -> Void
		perform?(`courseId`, `courseName`)
    }

    open func courseHomeSectionSubsectionClick(courseId: String, courseName: String, courseSection: String, courseSubsection: String) {
        addInvocation(.m_courseHomeSectionSubsectionClick__courseId_courseIdcourseName_courseNamecourseSection_courseSectioncourseSubsection_courseSubsection(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`), Parameter<String>.value(`courseSection`), Parameter<String>.value(`courseSubsection`)))
		let perform = methodPerformValue(.m_courseHomeSectionSubsectionClick__courseId_courseIdcourseName_courseNamecourseSection_courseSectioncourseSubsection_courseSubsection(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`), Parameter<String>.value(`courseSection`), Parameter<String>.value(`courseSubsection`))) as? (String, String, String, String) -> Void
		perform?(`courseId`, `courseName`, `courseSection`, `courseSubsection`)
    }

    open func datesComponentTapped(courseId: String, blockId: String, link: String, supported: Bool) {
        addInvocation(.m_datesComponentTapped__courseId_courseIdblockId_blockIdlink_linksupported_supported(Parameter<String>.value(`courseId`), Parameter<String>.value(`blockId`), Parameter<String>.value(`link`), Parameter<Bool>.value(`supported`)))
		let perform = methodPerformValue(.m_datesComponentTapped__courseId_courseIdblockId_blockIdlink_linksupported_supported(Parameter<String>.value(`courseId`), Parameter<String>.value(`blockId`), Parameter<String>.value(`link`), Parameter<Bool>.value(`supported`))) as? (String, String, String, Bool) -> Void
		perform?(`courseId`, `blockId`, `link`, `supported`)
    }

    open func calendarSyncToggle(enrollmentMode: EnrollmentMode, pacing: CoursePacing, courseId: String, action: CalendarDialogueAction) {
        addInvocation(.m_calendarSyncToggle__enrollmentMode_enrollmentModepacing_pacingcourseId_courseIdaction_action(Parameter<EnrollmentMode>.value(`enrollmentMode`), Parameter<CoursePacing>.value(`pacing`), Parameter<String>.value(`courseId`), Parameter<CalendarDialogueAction>.value(`action`)))
		let perform = methodPerformValue(.m_calendarSyncToggle__enrollmentMode_enrollmentModepacing_pacingcourseId_courseIdaction_action(Parameter<EnrollmentMode>.value(`enrollmentMode`), Parameter<CoursePacing>.value(`pacing`), Parameter<String>.value(`courseId`), Parameter<CalendarDialogueAction>.value(`action`))) as? (EnrollmentMode, CoursePacing, String, CalendarDialogueAction) -> Void
		perform?(`enrollmentMode`, `pacing`, `courseId`, `action`)
    }

    open func calendarSyncDialogAction(enrollmentMode: EnrollmentMode, pacing: CoursePacing, courseId: String, dialog: CalendarDialogueType, action: CalendarDialogueAction) {
        addInvocation(.m_calendarSyncDialogAction__enrollmentMode_enrollmentModepacing_pacingcourseId_courseIddialog_dialogaction_action(Parameter<EnrollmentMode>.value(`enrollmentMode`), Parameter<CoursePacing>.value(`pacing`), Parameter<String>.value(`courseId`), Parameter<CalendarDialogueType>.value(`dialog`), Parameter<CalendarDialogueAction>.value(`action`)))
		let perform = methodPerformValue(.m_calendarSyncDialogAction__enrollmentMode_enrollmentModepacing_pacingcourseId_courseIddialog_dialogaction_action(Parameter<EnrollmentMode>.value(`enrollmentMode`), Parameter<CoursePacing>.value(`pacing`), Parameter<String>.value(`courseId`), Parameter<CalendarDialogueType>.value(`dialog`), Parameter<CalendarDialogueAction>.value(`action`))) as? (EnrollmentMode, CoursePacing, String, CalendarDialogueType, CalendarDialogueAction) -> Void
		perform?(`enrollmentMode`, `pacing`, `courseId`, `dialog`, `action`)
    }

    open func calendarSyncSnackbar(enrollmentMode: EnrollmentMode, pacing: CoursePacing, courseId: String, snackbar: SnackbarType) {
        addInvocation(.m_calendarSyncSnackbar__enrollmentMode_enrollmentModepacing_pacingcourseId_courseIdsnackbar_snackbar(Parameter<EnrollmentMode>.value(`enrollmentMode`), Parameter<CoursePacing>.value(`pacing`), Parameter<String>.value(`courseId`), Parameter<SnackbarType>.value(`snackbar`)))
		let perform = methodPerformValue(.m_calendarSyncSnackbar__enrollmentMode_enrollmentModepacing_pacingcourseId_courseIdsnackbar_snackbar(Parameter<EnrollmentMode>.value(`enrollmentMode`), Parameter<CoursePacing>.value(`pacing`), Parameter<String>.value(`courseId`), Parameter<SnackbarType>.value(`snackbar`))) as? (EnrollmentMode, CoursePacing, String, SnackbarType) -> Void
		perform?(`enrollmentMode`, `pacing`, `courseId`, `snackbar`)
    }

    open func trackCourseEvent(_ event: AnalyticsEvent, biValue: EventBIValue, courseID: String) {
        addInvocation(.m_trackCourseEvent__eventbiValue_biValuecourseID_courseID(Parameter<AnalyticsEvent>.value(`event`), Parameter<EventBIValue>.value(`biValue`), Parameter<String>.value(`courseID`)))
		let perform = methodPerformValue(.m_trackCourseEvent__eventbiValue_biValuecourseID_courseID(Parameter<AnalyticsEvent>.value(`event`), Parameter<EventBIValue>.value(`biValue`), Parameter<String>.value(`courseID`))) as? (AnalyticsEvent, EventBIValue, String) -> Void
		perform?(`event`, `biValue`, `courseID`)
    }

    open func trackCourseScreenEvent(_ event: AnalyticsEvent, biValue: EventBIValue, courseID: String) {
        addInvocation(.m_trackCourseScreenEvent__eventbiValue_biValuecourseID_courseID(Parameter<AnalyticsEvent>.value(`event`), Parameter<EventBIValue>.value(`biValue`), Parameter<String>.value(`courseID`)))
		let perform = methodPerformValue(.m_trackCourseScreenEvent__eventbiValue_biValuecourseID_courseID(Parameter<AnalyticsEvent>.value(`event`), Parameter<EventBIValue>.value(`biValue`), Parameter<String>.value(`courseID`))) as? (AnalyticsEvent, EventBIValue, String) -> Void
		perform?(`event`, `biValue`, `courseID`)
    }

    open func plsEvent(_ event: AnalyticsEvent, bivalue: EventBIValue, courseID: String, screenName: String, type: String) {
        addInvocation(.m_plsEvent__eventbivalue_bivaluecourseID_courseIDscreenName_screenNametype_type(Parameter<AnalyticsEvent>.value(`event`), Parameter<EventBIValue>.value(`bivalue`), Parameter<String>.value(`courseID`), Parameter<String>.value(`screenName`), Parameter<String>.value(`type`)))
		let perform = methodPerformValue(.m_plsEvent__eventbivalue_bivaluecourseID_courseIDscreenName_screenNametype_type(Parameter<AnalyticsEvent>.value(`event`), Parameter<EventBIValue>.value(`bivalue`), Parameter<String>.value(`courseID`), Parameter<String>.value(`screenName`), Parameter<String>.value(`type`))) as? (AnalyticsEvent, EventBIValue, String, String, String) -> Void
		perform?(`event`, `bivalue`, `courseID`, `screenName`, `type`)
    }

    open func plsSuccessEvent(_ event: AnalyticsEvent, bivalue: EventBIValue, courseID: String, screenName: String, type: String, success: Bool) {
        addInvocation(.m_plsSuccessEvent__eventbivalue_bivaluecourseID_courseIDscreenName_screenNametype_typesuccess_success(Parameter<AnalyticsEvent>.value(`event`), Parameter<EventBIValue>.value(`bivalue`), Parameter<String>.value(`courseID`), Parameter<String>.value(`screenName`), Parameter<String>.value(`type`), Parameter<Bool>.value(`success`)))
		let perform = methodPerformValue(.m_plsSuccessEvent__eventbivalue_bivaluecourseID_courseIDscreenName_screenNametype_typesuccess_success(Parameter<AnalyticsEvent>.value(`event`), Parameter<EventBIValue>.value(`bivalue`), Parameter<String>.value(`courseID`), Parameter<String>.value(`screenName`), Parameter<String>.value(`type`), Parameter<Bool>.value(`success`))) as? (AnalyticsEvent, EventBIValue, String, String, String, Bool) -> Void
		perform?(`event`, `bivalue`, `courseID`, `screenName`, `type`, `success`)
    }

    open func bulkDownloadVideosToggle(courseID: String, action: Bool) {
        addInvocation(.m_bulkDownloadVideosToggle__courseID_courseIDaction_action(Parameter<String>.value(`courseID`), Parameter<Bool>.value(`action`)))
		let perform = methodPerformValue(.m_bulkDownloadVideosToggle__courseID_courseIDaction_action(Parameter<String>.value(`courseID`), Parameter<Bool>.value(`action`))) as? (String, Bool) -> Void
		perform?(`courseID`, `action`)
    }

    open func bulkDownloadVideosSubsection(courseID: String, sectionID: String, subSectionID: String, videos: Int) {
        addInvocation(.m_bulkDownloadVideosSubsection__courseID_courseIDsectionID_sectionIDsubSectionID_subSectionIDvideos_videos(Parameter<String>.value(`courseID`), Parameter<String>.value(`sectionID`), Parameter<String>.value(`subSectionID`), Parameter<Int>.value(`videos`)))
		let perform = methodPerformValue(.m_bulkDownloadVideosSubsection__courseID_courseIDsectionID_sectionIDsubSectionID_subSectionIDvideos_videos(Parameter<String>.value(`courseID`), Parameter<String>.value(`sectionID`), Parameter<String>.value(`subSectionID`), Parameter<Int>.value(`videos`))) as? (String, String, String, Int) -> Void
		perform?(`courseID`, `sectionID`, `subSectionID`, `videos`)
    }

    open func bulkDeleteVideosSubsection(courseID: String, subSectionID: String, videos: Int) {
        addInvocation(.m_bulkDeleteVideosSubsection__courseID_courseIDsubSectionID_subSectionIDvideos_videos(Parameter<String>.value(`courseID`), Parameter<String>.value(`subSectionID`), Parameter<Int>.value(`videos`)))
		let perform = methodPerformValue(.m_bulkDeleteVideosSubsection__courseID_courseIDsubSectionID_subSectionIDvideos_videos(Parameter<String>.value(`courseID`), Parameter<String>.value(`subSectionID`), Parameter<Int>.value(`videos`))) as? (String, String, Int) -> Void
		perform?(`courseID`, `subSectionID`, `videos`)
    }

    open func bulkDownloadVideosSection(courseID: String, sectionID: String, videos: Int) {
        addInvocation(.m_bulkDownloadVideosSection__courseID_courseIDsectionID_sectionIDvideos_videos(Parameter<String>.value(`courseID`), Parameter<String>.value(`sectionID`), Parameter<Int>.value(`videos`)))
		let perform = methodPerformValue(.m_bulkDownloadVideosSection__courseID_courseIDsectionID_sectionIDvideos_videos(Parameter<String>.value(`courseID`), Parameter<String>.value(`sectionID`), Parameter<Int>.value(`videos`))) as? (String, String, Int) -> Void
		perform?(`courseID`, `sectionID`, `videos`)
    }

    open func bulkDeleteVideosSection(courseID: String, sectionId: String, videos: Int) {
        addInvocation(.m_bulkDeleteVideosSection__courseID_courseIDsectionId_sectionIdvideos_videos(Parameter<String>.value(`courseID`), Parameter<String>.value(`sectionId`), Parameter<Int>.value(`videos`)))
		let perform = methodPerformValue(.m_bulkDeleteVideosSection__courseID_courseIDsectionId_sectionIdvideos_videos(Parameter<String>.value(`courseID`), Parameter<String>.value(`sectionId`), Parameter<Int>.value(`videos`))) as? (String, String, Int) -> Void
		perform?(`courseID`, `sectionId`, `videos`)
    }

    open func videoLoaded(courseID: String, blockID: String, videoURL: String) {
        addInvocation(.m_videoLoaded__courseID_courseIDblockID_blockIDvideoURL_videoURL(Parameter<String>.value(`courseID`), Parameter<String>.value(`blockID`), Parameter<String>.value(`videoURL`)))
		let perform = methodPerformValue(.m_videoLoaded__courseID_courseIDblockID_blockIDvideoURL_videoURL(Parameter<String>.value(`courseID`), Parameter<String>.value(`blockID`), Parameter<String>.value(`videoURL`))) as? (String, String, String) -> Void
		perform?(`courseID`, `blockID`, `videoURL`)
    }

    open func videoPlayed(courseID: String, blockID: String, videoURL: String) {
        addInvocation(.m_videoPlayed__courseID_courseIDblockID_blockIDvideoURL_videoURL(Parameter<String>.value(`courseID`), Parameter<String>.value(`blockID`), Parameter<String>.value(`videoURL`)))
		let perform = methodPerformValue(.m_videoPlayed__courseID_courseIDblockID_blockIDvideoURL_videoURL(Parameter<String>.value(`courseID`), Parameter<String>.value(`blockID`), Parameter<String>.value(`videoURL`))) as? (String, String, String) -> Void
		perform?(`courseID`, `blockID`, `videoURL`)
    }

    open func videoSpeedChange(courseID: String, blockID: String, videoURL: String, oldSpeed: Float, newSpeed: Float, currentTime: Double, duration: Double) {
        addInvocation(.m_videoSpeedChange__courseID_courseIDblockID_blockIDvideoURL_videoURLoldSpeed_oldSpeednewSpeed_newSpeedcurrentTime_currentTimeduration_duration(Parameter<String>.value(`courseID`), Parameter<String>.value(`blockID`), Parameter<String>.value(`videoURL`), Parameter<Float>.value(`oldSpeed`), Parameter<Float>.value(`newSpeed`), Parameter<Double>.value(`currentTime`), Parameter<Double>.value(`duration`)))
		let perform = methodPerformValue(.m_videoSpeedChange__courseID_courseIDblockID_blockIDvideoURL_videoURLoldSpeed_oldSpeednewSpeed_newSpeedcurrentTime_currentTimeduration_duration(Parameter<String>.value(`courseID`), Parameter<String>.value(`blockID`), Parameter<String>.value(`videoURL`), Parameter<Float>.value(`oldSpeed`), Parameter<Float>.value(`newSpeed`), Parameter<Double>.value(`currentTime`), Parameter<Double>.value(`duration`))) as? (String, String, String, Float, Float, Double, Double) -> Void
		perform?(`courseID`, `blockID`, `videoURL`, `oldSpeed`, `newSpeed`, `currentTime`, `duration`)
    }

    open func videoPaused(courseID: String, blockID: String, videoURL: String, currentTime: Double, duration: Double) {
        addInvocation(.m_videoPaused__courseID_courseIDblockID_blockIDvideoURL_videoURLcurrentTime_currentTimeduration_duration(Parameter<String>.value(`courseID`), Parameter<String>.value(`blockID`), Parameter<String>.value(`videoURL`), Parameter<Double>.value(`currentTime`), Parameter<Double>.value(`duration`)))
		let perform = methodPerformValue(.m_videoPaused__courseID_courseIDblockID_blockIDvideoURL_videoURLcurrentTime_currentTimeduration_duration(Parameter<String>.value(`courseID`), Parameter<String>.value(`blockID`), Parameter<String>.value(`videoURL`), Parameter<Double>.value(`currentTime`), Parameter<Double>.value(`duration`))) as? (String, String, String, Double, Double) -> Void
		perform?(`courseID`, `blockID`, `videoURL`, `currentTime`, `duration`)
    }

    open func videoCompleted(courseID: String, blockID: String, videoURL: String, currentTime: Double, duration: Double) {
        addInvocation(.m_videoCompleted__courseID_courseIDblockID_blockIDvideoURL_videoURLcurrentTime_currentTimeduration_duration(Parameter<String>.value(`courseID`), Parameter<String>.value(`blockID`), Parameter<String>.value(`videoURL`), Parameter<Double>.value(`currentTime`), Parameter<Double>.value(`duration`)))
		let perform = methodPerformValue(.m_videoCompleted__courseID_courseIDblockID_blockIDvideoURL_videoURLcurrentTime_currentTimeduration_duration(Parameter<String>.value(`courseID`), Parameter<String>.value(`blockID`), Parameter<String>.value(`videoURL`), Parameter<Double>.value(`currentTime`), Parameter<Double>.value(`duration`))) as? (String, String, String, Double, Double) -> Void
		perform?(`courseID`, `blockID`, `videoURL`, `currentTime`, `duration`)
    }


    fileprivate enum MethodType {
        case m_resumeCourseClicked__courseId_courseIdcourseName_courseNameblockId_blockId(Parameter<String>, Parameter<String>, Parameter<String>)
        case m_sequentialClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(Parameter<String>, Parameter<String>, Parameter<String>, Parameter<String>)
        case m_verticalClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(Parameter<String>, Parameter<String>, Parameter<String>, Parameter<String>)
        case m_nextBlockClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(Parameter<String>, Parameter<String>, Parameter<String>, Parameter<String>)
        case m_prevBlockClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(Parameter<String>, Parameter<String>, Parameter<String>, Parameter<String>)
        case m_finishVerticalClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(Parameter<String>, Parameter<String>, Parameter<String>, Parameter<String>)
        case m_finishVerticalNextSectionClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(Parameter<String>, Parameter<String>, Parameter<String>, Parameter<String>)
        case m_finishVerticalBackToOutlineClicked__courseId_courseIdcourseName_courseName(Parameter<String>, Parameter<String>)
        case m_courseOutlineCourseTabClicked__courseId_courseIdcourseName_courseName(Parameter<String>, Parameter<String>)
        case m_courseOutlineContentTabClicked__courseId_courseIdcourseName_courseName(Parameter<String>, Parameter<String>)
        case m_courseOutlineProgressTabClicked__courseId_courseIdcourseName_courseName(Parameter<String>, Parameter<String>)
        case m_courseOutlineVideosTabClicked__courseId_courseIdcourseName_courseName(Parameter<String>, Parameter<String>)
        case m_courseOutlineOfflineTabClicked__courseId_courseIdcourseName_courseName(Parameter<String>, Parameter<String>)
        case m_courseOutlineDatesTabClicked__courseId_courseIdcourseName_courseName(Parameter<String>, Parameter<String>)
        case m_courseOutlineDiscussionTabClicked__courseId_courseIdcourseName_courseName(Parameter<String>, Parameter<String>)
        case m_courseOutlineHandoutsTabClicked__courseId_courseIdcourseName_courseName(Parameter<String>, Parameter<String>)
        case m_courseOutlineAssignmentsTabClicked__courseId_courseIdcourseName_courseName(Parameter<String>, Parameter<String>)
        case m_courseContentAllTabClicked__courseId_courseIdcourseName_courseName(Parameter<String>, Parameter<String>)
        case m_courseContentVideosTabClicked__courseId_courseIdcourseName_courseName(Parameter<String>, Parameter<String>)
        case m_courseContentAssignmentsTabClicked__courseId_courseIdcourseName_courseName(Parameter<String>, Parameter<String>)
        case m_courseVideoClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(Parameter<String>, Parameter<String>, Parameter<String>, Parameter<String>)
        case m_courseAssignmentClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(Parameter<String>, Parameter<String>, Parameter<String>, Parameter<String>)
        case m_contentPageSectionClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(Parameter<String>, Parameter<String>, Parameter<String>, Parameter<String>)
        case m_contentPageShowCompletedSubsectionClicked__courseId_courseIdcourseName_courseName(Parameter<String>, Parameter<String>)
        case m_progressTabClicked__courseId_courseIdcourseName_courseName(Parameter<String>, Parameter<String>)
        case m_courseHomeViewAllContentClicked__courseId_courseIdcourseName_courseName(Parameter<String>, Parameter<String>)
        case m_courseHomeVideoClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(Parameter<String>, Parameter<String>, Parameter<String>, Parameter<String>)
        case m_courseHomeViewAllVideosClicked__courseId_courseIdcourseName_courseName(Parameter<String>, Parameter<String>)
        case m_courseHomeAssignmentClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(Parameter<String>, Parameter<String>, Parameter<String>, Parameter<String>)
        case m_courseHomeViewAllAssignmentsClicked__courseId_courseIdcourseName_courseName(Parameter<String>, Parameter<String>)
        case m_courseHomeGradesViewProgressClicked__courseId_courseIdcourseName_courseName(Parameter<String>, Parameter<String>)
        case m_courseHomeSectionSubsectionClick__courseId_courseIdcourseName_courseNamecourseSection_courseSectioncourseSubsection_courseSubsection(Parameter<String>, Parameter<String>, Parameter<String>, Parameter<String>)
        case m_datesComponentTapped__courseId_courseIdblockId_blockIdlink_linksupported_supported(Parameter<String>, Parameter<String>, Parameter<String>, Parameter<Bool>)
        case m_calendarSyncToggle__enrollmentMode_enrollmentModepacing_pacingcourseId_courseIdaction_action(Parameter<EnrollmentMode>, Parameter<CoursePacing>, Parameter<String>, Parameter<CalendarDialogueAction>)
        case m_calendarSyncDialogAction__enrollmentMode_enrollmentModepacing_pacingcourseId_courseIddialog_dialogaction_action(Parameter<EnrollmentMode>, Parameter<CoursePacing>, Parameter<String>, Parameter<CalendarDialogueType>, Parameter<CalendarDialogueAction>)
        case m_calendarSyncSnackbar__enrollmentMode_enrollmentModepacing_pacingcourseId_courseIdsnackbar_snackbar(Parameter<EnrollmentMode>, Parameter<CoursePacing>, Parameter<String>, Parameter<SnackbarType>)
        case m_trackCourseEvent__eventbiValue_biValuecourseID_courseID(Parameter<AnalyticsEvent>, Parameter<EventBIValue>, Parameter<String>)
        case m_trackCourseScreenEvent__eventbiValue_biValuecourseID_courseID(Parameter<AnalyticsEvent>, Parameter<EventBIValue>, Parameter<String>)
        case m_plsEvent__eventbivalue_bivaluecourseID_courseIDscreenName_screenNametype_type(Parameter<AnalyticsEvent>, Parameter<EventBIValue>, Parameter<String>, Parameter<String>, Parameter<String>)
        case m_plsSuccessEvent__eventbivalue_bivaluecourseID_courseIDscreenName_screenNametype_typesuccess_success(Parameter<AnalyticsEvent>, Parameter<EventBIValue>, Parameter<String>, Parameter<String>, Parameter<String>, Parameter<Bool>)
        case m_bulkDownloadVideosToggle__courseID_courseIDaction_action(Parameter<String>, Parameter<Bool>)
        case m_bulkDownloadVideosSubsection__courseID_courseIDsectionID_sectionIDsubSectionID_subSectionIDvideos_videos(Parameter<String>, Parameter<String>, Parameter<String>, Parameter<Int>)
        case m_bulkDeleteVideosSubsection__courseID_courseIDsubSectionID_subSectionIDvideos_videos(Parameter<String>, Parameter<String>, Parameter<Int>)
        case m_bulkDownloadVideosSection__courseID_courseIDsectionID_sectionIDvideos_videos(Parameter<String>, Parameter<String>, Parameter<Int>)
        case m_bulkDeleteVideosSection__courseID_courseIDsectionId_sectionIdvideos_videos(Parameter<String>, Parameter<String>, Parameter<Int>)
        case m_videoLoaded__courseID_courseIDblockID_blockIDvideoURL_videoURL(Parameter<String>, Parameter<String>, Parameter<String>)
        case m_videoPlayed__courseID_courseIDblockID_blockIDvideoURL_videoURL(Parameter<String>, Parameter<String>, Parameter<String>)
        case m_videoSpeedChange__courseID_courseIDblockID_blockIDvideoURL_videoURLoldSpeed_oldSpeednewSpeed_newSpeedcurrentTime_currentTimeduration_duration(Parameter<String>, Parameter<String>, Parameter<String>, Parameter<Float>, Parameter<Float>, Parameter<Double>, Parameter<Double>)
        case m_videoPaused__courseID_courseIDblockID_blockIDvideoURL_videoURLcurrentTime_currentTimeduration_duration(Parameter<String>, Parameter<String>, Parameter<String>, Parameter<Double>, Parameter<Double>)
        case m_videoCompleted__courseID_courseIDblockID_blockIDvideoURL_videoURLcurrentTime_currentTimeduration_duration(Parameter<String>, Parameter<String>, Parameter<String>, Parameter<Double>, Parameter<Double>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_resumeCourseClicked__courseId_courseIdcourseName_courseNameblockId_blockId(let lhsCourseid, let lhsCoursename, let lhsBlockid), .m_resumeCourseClicked__courseId_courseIdcourseName_courseNameblockId_blockId(let rhsCourseid, let rhsCoursename, let rhsBlockid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlockid, rhs: rhsBlockid, with: matcher), lhsBlockid, rhsBlockid, "blockId"))
				return Matcher.ComparisonResult(results)

            case (.m_sequentialClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(let lhsCourseid, let lhsCoursename, let lhsBlockid, let lhsBlockname), .m_sequentialClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(let rhsCourseid, let rhsCoursename, let rhsBlockid, let rhsBlockname)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlockid, rhs: rhsBlockid, with: matcher), lhsBlockid, rhsBlockid, "blockId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlockname, rhs: rhsBlockname, with: matcher), lhsBlockname, rhsBlockname, "blockName"))
				return Matcher.ComparisonResult(results)

            case (.m_verticalClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(let lhsCourseid, let lhsCoursename, let lhsBlockid, let lhsBlockname), .m_verticalClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(let rhsCourseid, let rhsCoursename, let rhsBlockid, let rhsBlockname)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlockid, rhs: rhsBlockid, with: matcher), lhsBlockid, rhsBlockid, "blockId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlockname, rhs: rhsBlockname, with: matcher), lhsBlockname, rhsBlockname, "blockName"))
				return Matcher.ComparisonResult(results)

            case (.m_nextBlockClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(let lhsCourseid, let lhsCoursename, let lhsBlockid, let lhsBlockname), .m_nextBlockClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(let rhsCourseid, let rhsCoursename, let rhsBlockid, let rhsBlockname)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlockid, rhs: rhsBlockid, with: matcher), lhsBlockid, rhsBlockid, "blockId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlockname, rhs: rhsBlockname, with: matcher), lhsBlockname, rhsBlockname, "blockName"))
				return Matcher.ComparisonResult(results)

            case (.m_prevBlockClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(let lhsCourseid, let lhsCoursename, let lhsBlockid, let lhsBlockname), .m_prevBlockClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(let rhsCourseid, let rhsCoursename, let rhsBlockid, let rhsBlockname)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlockid, rhs: rhsBlockid, with: matcher), lhsBlockid, rhsBlockid, "blockId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlockname, rhs: rhsBlockname, with: matcher), lhsBlockname, rhsBlockname, "blockName"))
				return Matcher.ComparisonResult(results)

            case (.m_finishVerticalClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(let lhsCourseid, let lhsCoursename, let lhsBlockid, let lhsBlockname), .m_finishVerticalClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(let rhsCourseid, let rhsCoursename, let rhsBlockid, let rhsBlockname)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlockid, rhs: rhsBlockid, with: matcher), lhsBlockid, rhsBlockid, "blockId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlockname, rhs: rhsBlockname, with: matcher), lhsBlockname, rhsBlockname, "blockName"))
				return Matcher.ComparisonResult(results)

            case (.m_finishVerticalNextSectionClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(let lhsCourseid, let lhsCoursename, let lhsBlockid, let lhsBlockname), .m_finishVerticalNextSectionClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(let rhsCourseid, let rhsCoursename, let rhsBlockid, let rhsBlockname)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlockid, rhs: rhsBlockid, with: matcher), lhsBlockid, rhsBlockid, "blockId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlockname, rhs: rhsBlockname, with: matcher), lhsBlockname, rhsBlockname, "blockName"))
				return Matcher.ComparisonResult(results)

            case (.m_finishVerticalBackToOutlineClicked__courseId_courseIdcourseName_courseName(let lhsCourseid, let lhsCoursename), .m_finishVerticalBackToOutlineClicked__courseId_courseIdcourseName_courseName(let rhsCourseid, let rhsCoursename)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				return Matcher.ComparisonResult(results)

            case (.m_courseOutlineCourseTabClicked__courseId_courseIdcourseName_courseName(let lhsCourseid, let lhsCoursename), .m_courseOutlineCourseTabClicked__courseId_courseIdcourseName_courseName(let rhsCourseid, let rhsCoursename)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				return Matcher.ComparisonResult(results)

            case (.m_courseOutlineContentTabClicked__courseId_courseIdcourseName_courseName(let lhsCourseid, let lhsCoursename), .m_courseOutlineContentTabClicked__courseId_courseIdcourseName_courseName(let rhsCourseid, let rhsCoursename)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				return Matcher.ComparisonResult(results)

            case (.m_courseOutlineProgressTabClicked__courseId_courseIdcourseName_courseName(let lhsCourseid, let lhsCoursename), .m_courseOutlineProgressTabClicked__courseId_courseIdcourseName_courseName(let rhsCourseid, let rhsCoursename)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				return Matcher.ComparisonResult(results)

            case (.m_courseOutlineVideosTabClicked__courseId_courseIdcourseName_courseName(let lhsCourseid, let lhsCoursename), .m_courseOutlineVideosTabClicked__courseId_courseIdcourseName_courseName(let rhsCourseid, let rhsCoursename)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				return Matcher.ComparisonResult(results)

            case (.m_courseOutlineOfflineTabClicked__courseId_courseIdcourseName_courseName(let lhsCourseid, let lhsCoursename), .m_courseOutlineOfflineTabClicked__courseId_courseIdcourseName_courseName(let rhsCourseid, let rhsCoursename)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				return Matcher.ComparisonResult(results)

            case (.m_courseOutlineDatesTabClicked__courseId_courseIdcourseName_courseName(let lhsCourseid, let lhsCoursename), .m_courseOutlineDatesTabClicked__courseId_courseIdcourseName_courseName(let rhsCourseid, let rhsCoursename)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				return Matcher.ComparisonResult(results)

            case (.m_courseOutlineDiscussionTabClicked__courseId_courseIdcourseName_courseName(let lhsCourseid, let lhsCoursename), .m_courseOutlineDiscussionTabClicked__courseId_courseIdcourseName_courseName(let rhsCourseid, let rhsCoursename)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				return Matcher.ComparisonResult(results)

            case (.m_courseOutlineHandoutsTabClicked__courseId_courseIdcourseName_courseName(let lhsCourseid, let lhsCoursename), .m_courseOutlineHandoutsTabClicked__courseId_courseIdcourseName_courseName(let rhsCourseid, let rhsCoursename)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				return Matcher.ComparisonResult(results)

            case (.m_courseOutlineAssignmentsTabClicked__courseId_courseIdcourseName_courseName(let lhsCourseid, let lhsCoursename), .m_courseOutlineAssignmentsTabClicked__courseId_courseIdcourseName_courseName(let rhsCourseid, let rhsCoursename)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				return Matcher.ComparisonResult(results)

            case (.m_courseContentAllTabClicked__courseId_courseIdcourseName_courseName(let lhsCourseid, let lhsCoursename), .m_courseContentAllTabClicked__courseId_courseIdcourseName_courseName(let rhsCourseid, let rhsCoursename)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				return Matcher.ComparisonResult(results)

            case (.m_courseContentVideosTabClicked__courseId_courseIdcourseName_courseName(let lhsCourseid, let lhsCoursename), .m_courseContentVideosTabClicked__courseId_courseIdcourseName_courseName(let rhsCourseid, let rhsCoursename)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				return Matcher.ComparisonResult(results)

            case (.m_courseContentAssignmentsTabClicked__courseId_courseIdcourseName_courseName(let lhsCourseid, let lhsCoursename), .m_courseContentAssignmentsTabClicked__courseId_courseIdcourseName_courseName(let rhsCourseid, let rhsCoursename)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				return Matcher.ComparisonResult(results)

            case (.m_courseVideoClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(let lhsCourseid, let lhsCoursename, let lhsBlockid, let lhsBlockname), .m_courseVideoClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(let rhsCourseid, let rhsCoursename, let rhsBlockid, let rhsBlockname)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlockid, rhs: rhsBlockid, with: matcher), lhsBlockid, rhsBlockid, "blockId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlockname, rhs: rhsBlockname, with: matcher), lhsBlockname, rhsBlockname, "blockName"))
				return Matcher.ComparisonResult(results)

            case (.m_courseAssignmentClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(let lhsCourseid, let lhsCoursename, let lhsBlockid, let lhsBlockname), .m_courseAssignmentClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(let rhsCourseid, let rhsCoursename, let rhsBlockid, let rhsBlockname)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlockid, rhs: rhsBlockid, with: matcher), lhsBlockid, rhsBlockid, "blockId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlockname, rhs: rhsBlockname, with: matcher), lhsBlockname, rhsBlockname, "blockName"))
				return Matcher.ComparisonResult(results)

            case (.m_contentPageSectionClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(let lhsCourseid, let lhsCoursename, let lhsBlockid, let lhsBlockname), .m_contentPageSectionClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(let rhsCourseid, let rhsCoursename, let rhsBlockid, let rhsBlockname)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlockid, rhs: rhsBlockid, with: matcher), lhsBlockid, rhsBlockid, "blockId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlockname, rhs: rhsBlockname, with: matcher), lhsBlockname, rhsBlockname, "blockName"))
				return Matcher.ComparisonResult(results)

            case (.m_contentPageShowCompletedSubsectionClicked__courseId_courseIdcourseName_courseName(let lhsCourseid, let lhsCoursename), .m_contentPageShowCompletedSubsectionClicked__courseId_courseIdcourseName_courseName(let rhsCourseid, let rhsCoursename)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				return Matcher.ComparisonResult(results)

            case (.m_progressTabClicked__courseId_courseIdcourseName_courseName(let lhsCourseid, let lhsCoursename), .m_progressTabClicked__courseId_courseIdcourseName_courseName(let rhsCourseid, let rhsCoursename)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				return Matcher.ComparisonResult(results)

            case (.m_courseHomeViewAllContentClicked__courseId_courseIdcourseName_courseName(let lhsCourseid, let lhsCoursename), .m_courseHomeViewAllContentClicked__courseId_courseIdcourseName_courseName(let rhsCourseid, let rhsCoursename)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				return Matcher.ComparisonResult(results)

            case (.m_courseHomeVideoClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(let lhsCourseid, let lhsCoursename, let lhsBlockid, let lhsBlockname), .m_courseHomeVideoClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(let rhsCourseid, let rhsCoursename, let rhsBlockid, let rhsBlockname)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlockid, rhs: rhsBlockid, with: matcher), lhsBlockid, rhsBlockid, "blockId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlockname, rhs: rhsBlockname, with: matcher), lhsBlockname, rhsBlockname, "blockName"))
				return Matcher.ComparisonResult(results)

            case (.m_courseHomeViewAllVideosClicked__courseId_courseIdcourseName_courseName(let lhsCourseid, let lhsCoursename), .m_courseHomeViewAllVideosClicked__courseId_courseIdcourseName_courseName(let rhsCourseid, let rhsCoursename)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				return Matcher.ComparisonResult(results)

            case (.m_courseHomeAssignmentClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(let lhsCourseid, let lhsCoursename, let lhsBlockid, let lhsBlockname), .m_courseHomeAssignmentClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(let rhsCourseid, let rhsCoursename, let rhsBlockid, let rhsBlockname)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlockid, rhs: rhsBlockid, with: matcher), lhsBlockid, rhsBlockid, "blockId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlockname, rhs: rhsBlockname, with: matcher), lhsBlockname, rhsBlockname, "blockName"))
				return Matcher.ComparisonResult(results)

            case (.m_courseHomeViewAllAssignmentsClicked__courseId_courseIdcourseName_courseName(let lhsCourseid, let lhsCoursename), .m_courseHomeViewAllAssignmentsClicked__courseId_courseIdcourseName_courseName(let rhsCourseid, let rhsCoursename)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				return Matcher.ComparisonResult(results)

            case (.m_courseHomeGradesViewProgressClicked__courseId_courseIdcourseName_courseName(let lhsCourseid, let lhsCoursename), .m_courseHomeGradesViewProgressClicked__courseId_courseIdcourseName_courseName(let rhsCourseid, let rhsCoursename)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				return Matcher.ComparisonResult(results)

            case (.m_courseHomeSectionSubsectionClick__courseId_courseIdcourseName_courseNamecourseSection_courseSectioncourseSubsection_courseSubsection(let lhsCourseid, let lhsCoursename, let lhsCoursesection, let lhsCoursesubsection), .m_courseHomeSectionSubsectionClick__courseId_courseIdcourseName_courseNamecourseSection_courseSectioncourseSubsection_courseSubsection(let rhsCourseid, let rhsCoursename, let rhsCoursesection, let rhsCoursesubsection)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursesection, rhs: rhsCoursesection, with: matcher), lhsCoursesection, rhsCoursesection, "courseSection"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursesubsection, rhs: rhsCoursesubsection, with: matcher), lhsCoursesubsection, rhsCoursesubsection, "courseSubsection"))
				return Matcher.ComparisonResult(results)

            case (.m_datesComponentTapped__courseId_courseIdblockId_blockIdlink_linksupported_supported(let lhsCourseid, let lhsBlockid, let lhsLink, let lhsSupported), .m_datesComponentTapped__courseId_courseIdblockId_blockIdlink_linksupported_supported(let rhsCourseid, let rhsBlockid, let rhsLink, let rhsSupported)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlockid, rhs: rhsBlockid, with: matcher), lhsBlockid, rhsBlockid, "blockId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsLink, rhs: rhsLink, with: matcher), lhsLink, rhsLink, "link"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsSupported, rhs: rhsSupported, with: matcher), lhsSupported, rhsSupported, "supported"))
				return Matcher.ComparisonResult(results)

            case (.m_calendarSyncToggle__enrollmentMode_enrollmentModepacing_pacingcourseId_courseIdaction_action(let lhsEnrollmentmode, let lhsPacing, let lhsCourseid, let lhsAction), .m_calendarSyncToggle__enrollmentMode_enrollmentModepacing_pacingcourseId_courseIdaction_action(let rhsEnrollmentmode, let rhsPacing, let rhsCourseid, let rhsAction)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsEnrollmentmode, rhs: rhsEnrollmentmode, with: matcher), lhsEnrollmentmode, rhsEnrollmentmode, "enrollmentMode"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsPacing, rhs: rhsPacing, with: matcher), lhsPacing, rhsPacing, "pacing"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsAction, rhs: rhsAction, with: matcher), lhsAction, rhsAction, "action"))
				return Matcher.ComparisonResult(results)

            case (.m_calendarSyncDialogAction__enrollmentMode_enrollmentModepacing_pacingcourseId_courseIddialog_dialogaction_action(let lhsEnrollmentmode, let lhsPacing, let lhsCourseid, let lhsDialog, let lhsAction), .m_calendarSyncDialogAction__enrollmentMode_enrollmentModepacing_pacingcourseId_courseIddialog_dialogaction_action(let rhsEnrollmentmode, let rhsPacing, let rhsCourseid, let rhsDialog, let rhsAction)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsEnrollmentmode, rhs: rhsEnrollmentmode, with: matcher), lhsEnrollmentmode, rhsEnrollmentmode, "enrollmentMode"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsPacing, rhs: rhsPacing, with: matcher), lhsPacing, rhsPacing, "pacing"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsDialog, rhs: rhsDialog, with: matcher), lhsDialog, rhsDialog, "dialog"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsAction, rhs: rhsAction, with: matcher), lhsAction, rhsAction, "action"))
				return Matcher.ComparisonResult(results)

            case (.m_calendarSyncSnackbar__enrollmentMode_enrollmentModepacing_pacingcourseId_courseIdsnackbar_snackbar(let lhsEnrollmentmode, let lhsPacing, let lhsCourseid, let lhsSnackbar), .m_calendarSyncSnackbar__enrollmentMode_enrollmentModepacing_pacingcourseId_courseIdsnackbar_snackbar(let rhsEnrollmentmode, let rhsPacing, let rhsCourseid, let rhsSnackbar)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsEnrollmentmode, rhs: rhsEnrollmentmode, with: matcher), lhsEnrollmentmode, rhsEnrollmentmode, "enrollmentMode"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsPacing, rhs: rhsPacing, with: matcher), lhsPacing, rhsPacing, "pacing"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsSnackbar, rhs: rhsSnackbar, with: matcher), lhsSnackbar, rhsSnackbar, "snackbar"))
				return Matcher.ComparisonResult(results)

            case (.m_trackCourseEvent__eventbiValue_biValuecourseID_courseID(let lhsEvent, let lhsBivalue, let lhsCourseid), .m_trackCourseEvent__eventbiValue_biValuecourseID_courseID(let rhsEvent, let rhsBivalue, let rhsCourseid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsEvent, rhs: rhsEvent, with: matcher), lhsEvent, rhsEvent, "_ event"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBivalue, rhs: rhsBivalue, with: matcher), lhsBivalue, rhsBivalue, "biValue"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				return Matcher.ComparisonResult(results)

            case (.m_trackCourseScreenEvent__eventbiValue_biValuecourseID_courseID(let lhsEvent, let lhsBivalue, let lhsCourseid), .m_trackCourseScreenEvent__eventbiValue_biValuecourseID_courseID(let rhsEvent, let rhsBivalue, let rhsCourseid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsEvent, rhs: rhsEvent, with: matcher), lhsEvent, rhsEvent, "_ event"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBivalue, rhs: rhsBivalue, with: matcher), lhsBivalue, rhsBivalue, "biValue"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				return Matcher.ComparisonResult(results)

            case (.m_plsEvent__eventbivalue_bivaluecourseID_courseIDscreenName_screenNametype_type(let lhsEvent, let lhsBivalue, let lhsCourseid, let lhsScreenname, let lhsType), .m_plsEvent__eventbivalue_bivaluecourseID_courseIDscreenName_screenNametype_type(let rhsEvent, let rhsBivalue, let rhsCourseid, let rhsScreenname, let rhsType)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsEvent, rhs: rhsEvent, with: matcher), lhsEvent, rhsEvent, "_ event"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBivalue, rhs: rhsBivalue, with: matcher), lhsBivalue, rhsBivalue, "bivalue"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsScreenname, rhs: rhsScreenname, with: matcher), lhsScreenname, rhsScreenname, "screenName"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsType, rhs: rhsType, with: matcher), lhsType, rhsType, "type"))
				return Matcher.ComparisonResult(results)

            case (.m_plsSuccessEvent__eventbivalue_bivaluecourseID_courseIDscreenName_screenNametype_typesuccess_success(let lhsEvent, let lhsBivalue, let lhsCourseid, let lhsScreenname, let lhsType, let lhsSuccess), .m_plsSuccessEvent__eventbivalue_bivaluecourseID_courseIDscreenName_screenNametype_typesuccess_success(let rhsEvent, let rhsBivalue, let rhsCourseid, let rhsScreenname, let rhsType, let rhsSuccess)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsEvent, rhs: rhsEvent, with: matcher), lhsEvent, rhsEvent, "_ event"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBivalue, rhs: rhsBivalue, with: matcher), lhsBivalue, rhsBivalue, "bivalue"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsScreenname, rhs: rhsScreenname, with: matcher), lhsScreenname, rhsScreenname, "screenName"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsType, rhs: rhsType, with: matcher), lhsType, rhsType, "type"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsSuccess, rhs: rhsSuccess, with: matcher), lhsSuccess, rhsSuccess, "success"))
				return Matcher.ComparisonResult(results)

            case (.m_bulkDownloadVideosToggle__courseID_courseIDaction_action(let lhsCourseid, let lhsAction), .m_bulkDownloadVideosToggle__courseID_courseIDaction_action(let rhsCourseid, let rhsAction)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsAction, rhs: rhsAction, with: matcher), lhsAction, rhsAction, "action"))
				return Matcher.ComparisonResult(results)

            case (.m_bulkDownloadVideosSubsection__courseID_courseIDsectionID_sectionIDsubSectionID_subSectionIDvideos_videos(let lhsCourseid, let lhsSectionid, let lhsSubsectionid, let lhsVideos), .m_bulkDownloadVideosSubsection__courseID_courseIDsectionID_sectionIDsubSectionID_subSectionIDvideos_videos(let rhsCourseid, let rhsSectionid, let rhsSubsectionid, let rhsVideos)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsSectionid, rhs: rhsSectionid, with: matcher), lhsSectionid, rhsSectionid, "sectionID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsSubsectionid, rhs: rhsSubsectionid, with: matcher), lhsSubsectionid, rhsSubsectionid, "subSectionID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsVideos, rhs: rhsVideos, with: matcher), lhsVideos, rhsVideos, "videos"))
				return Matcher.ComparisonResult(results)

            case (.m_bulkDeleteVideosSubsection__courseID_courseIDsubSectionID_subSectionIDvideos_videos(let lhsCourseid, let lhsSubsectionid, let lhsVideos), .m_bulkDeleteVideosSubsection__courseID_courseIDsubSectionID_subSectionIDvideos_videos(let rhsCourseid, let rhsSubsectionid, let rhsVideos)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsSubsectionid, rhs: rhsSubsectionid, with: matcher), lhsSubsectionid, rhsSubsectionid, "subSectionID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsVideos, rhs: rhsVideos, with: matcher), lhsVideos, rhsVideos, "videos"))
				return Matcher.ComparisonResult(results)

            case (.m_bulkDownloadVideosSection__courseID_courseIDsectionID_sectionIDvideos_videos(let lhsCourseid, let lhsSectionid, let lhsVideos), .m_bulkDownloadVideosSection__courseID_courseIDsectionID_sectionIDvideos_videos(let rhsCourseid, let rhsSectionid, let rhsVideos)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsSectionid, rhs: rhsSectionid, with: matcher), lhsSectionid, rhsSectionid, "sectionID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsVideos, rhs: rhsVideos, with: matcher), lhsVideos, rhsVideos, "videos"))
				return Matcher.ComparisonResult(results)

            case (.m_bulkDeleteVideosSection__courseID_courseIDsectionId_sectionIdvideos_videos(let lhsCourseid, let lhsSectionid, let lhsVideos), .m_bulkDeleteVideosSection__courseID_courseIDsectionId_sectionIdvideos_videos(let rhsCourseid, let rhsSectionid, let rhsVideos)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsSectionid, rhs: rhsSectionid, with: matcher), lhsSectionid, rhsSectionid, "sectionId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsVideos, rhs: rhsVideos, with: matcher), lhsVideos, rhsVideos, "videos"))
				return Matcher.ComparisonResult(results)

            case (.m_videoLoaded__courseID_courseIDblockID_blockIDvideoURL_videoURL(let lhsCourseid, let lhsBlockid, let lhsVideourl), .m_videoLoaded__courseID_courseIDblockID_blockIDvideoURL_videoURL(let rhsCourseid, let rhsBlockid, let rhsVideourl)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlockid, rhs: rhsBlockid, with: matcher), lhsBlockid, rhsBlockid, "blockID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsVideourl, rhs: rhsVideourl, with: matcher), lhsVideourl, rhsVideourl, "videoURL"))
				return Matcher.ComparisonResult(results)

            case (.m_videoPlayed__courseID_courseIDblockID_blockIDvideoURL_videoURL(let lhsCourseid, let lhsBlockid, let lhsVideourl), .m_videoPlayed__courseID_courseIDblockID_blockIDvideoURL_videoURL(let rhsCourseid, let rhsBlockid, let rhsVideourl)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlockid, rhs: rhsBlockid, with: matcher), lhsBlockid, rhsBlockid, "blockID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsVideourl, rhs: rhsVideourl, with: matcher), lhsVideourl, rhsVideourl, "videoURL"))
				return Matcher.ComparisonResult(results)

            case (.m_videoSpeedChange__courseID_courseIDblockID_blockIDvideoURL_videoURLoldSpeed_oldSpeednewSpeed_newSpeedcurrentTime_currentTimeduration_duration(let lhsCourseid, let lhsBlockid, let lhsVideourl, let lhsOldspeed, let lhsNewspeed, let lhsCurrenttime, let lhsDuration), .m_videoSpeedChange__courseID_courseIDblockID_blockIDvideoURL_videoURLoldSpeed_oldSpeednewSpeed_newSpeedcurrentTime_currentTimeduration_duration(let rhsCourseid, let rhsBlockid, let rhsVideourl, let rhsOldspeed, let rhsNewspeed, let rhsCurrenttime, let rhsDuration)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlockid, rhs: rhsBlockid, with: matcher), lhsBlockid, rhsBlockid, "blockID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsVideourl, rhs: rhsVideourl, with: matcher), lhsVideourl, rhsVideourl, "videoURL"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsOldspeed, rhs: rhsOldspeed, with: matcher), lhsOldspeed, rhsOldspeed, "oldSpeed"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsNewspeed, rhs: rhsNewspeed, with: matcher), lhsNewspeed, rhsNewspeed, "newSpeed"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCurrenttime, rhs: rhsCurrenttime, with: matcher), lhsCurrenttime, rhsCurrenttime, "currentTime"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsDuration, rhs: rhsDuration, with: matcher), lhsDuration, rhsDuration, "duration"))
				return Matcher.ComparisonResult(results)

            case (.m_videoPaused__courseID_courseIDblockID_blockIDvideoURL_videoURLcurrentTime_currentTimeduration_duration(let lhsCourseid, let lhsBlockid, let lhsVideourl, let lhsCurrenttime, let lhsDuration), .m_videoPaused__courseID_courseIDblockID_blockIDvideoURL_videoURLcurrentTime_currentTimeduration_duration(let rhsCourseid, let rhsBlockid, let rhsVideourl, let rhsCurrenttime, let rhsDuration)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlockid, rhs: rhsBlockid, with: matcher), lhsBlockid, rhsBlockid, "blockID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsVideourl, rhs: rhsVideourl, with: matcher), lhsVideourl, rhsVideourl, "videoURL"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCurrenttime, rhs: rhsCurrenttime, with: matcher), lhsCurrenttime, rhsCurrenttime, "currentTime"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsDuration, rhs: rhsDuration, with: matcher), lhsDuration, rhsDuration, "duration"))
				return Matcher.ComparisonResult(results)

            case (.m_videoCompleted__courseID_courseIDblockID_blockIDvideoURL_videoURLcurrentTime_currentTimeduration_duration(let lhsCourseid, let lhsBlockid, let lhsVideourl, let lhsCurrenttime, let lhsDuration), .m_videoCompleted__courseID_courseIDblockID_blockIDvideoURL_videoURLcurrentTime_currentTimeduration_duration(let rhsCourseid, let rhsBlockid, let rhsVideourl, let rhsCurrenttime, let rhsDuration)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlockid, rhs: rhsBlockid, with: matcher), lhsBlockid, rhsBlockid, "blockID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsVideourl, rhs: rhsVideourl, with: matcher), lhsVideourl, rhsVideourl, "videoURL"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCurrenttime, rhs: rhsCurrenttime, with: matcher), lhsCurrenttime, rhsCurrenttime, "currentTime"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsDuration, rhs: rhsDuration, with: matcher), lhsDuration, rhsDuration, "duration"))
				return Matcher.ComparisonResult(results)
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_resumeCourseClicked__courseId_courseIdcourseName_courseNameblockId_blockId(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_sequentialClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(p0, p1, p2, p3): return p0.intValue + p1.intValue + p2.intValue + p3.intValue
            case let .m_verticalClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(p0, p1, p2, p3): return p0.intValue + p1.intValue + p2.intValue + p3.intValue
            case let .m_nextBlockClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(p0, p1, p2, p3): return p0.intValue + p1.intValue + p2.intValue + p3.intValue
            case let .m_prevBlockClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(p0, p1, p2, p3): return p0.intValue + p1.intValue + p2.intValue + p3.intValue
            case let .m_finishVerticalClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(p0, p1, p2, p3): return p0.intValue + p1.intValue + p2.intValue + p3.intValue
            case let .m_finishVerticalNextSectionClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(p0, p1, p2, p3): return p0.intValue + p1.intValue + p2.intValue + p3.intValue
            case let .m_finishVerticalBackToOutlineClicked__courseId_courseIdcourseName_courseName(p0, p1): return p0.intValue + p1.intValue
            case let .m_courseOutlineCourseTabClicked__courseId_courseIdcourseName_courseName(p0, p1): return p0.intValue + p1.intValue
            case let .m_courseOutlineContentTabClicked__courseId_courseIdcourseName_courseName(p0, p1): return p0.intValue + p1.intValue
            case let .m_courseOutlineProgressTabClicked__courseId_courseIdcourseName_courseName(p0, p1): return p0.intValue + p1.intValue
            case let .m_courseOutlineVideosTabClicked__courseId_courseIdcourseName_courseName(p0, p1): return p0.intValue + p1.intValue
            case let .m_courseOutlineOfflineTabClicked__courseId_courseIdcourseName_courseName(p0, p1): return p0.intValue + p1.intValue
            case let .m_courseOutlineDatesTabClicked__courseId_courseIdcourseName_courseName(p0, p1): return p0.intValue + p1.intValue
            case let .m_courseOutlineDiscussionTabClicked__courseId_courseIdcourseName_courseName(p0, p1): return p0.intValue + p1.intValue
            case let .m_courseOutlineHandoutsTabClicked__courseId_courseIdcourseName_courseName(p0, p1): return p0.intValue + p1.intValue
            case let .m_courseOutlineAssignmentsTabClicked__courseId_courseIdcourseName_courseName(p0, p1): return p0.intValue + p1.intValue
            case let .m_courseContentAllTabClicked__courseId_courseIdcourseName_courseName(p0, p1): return p0.intValue + p1.intValue
            case let .m_courseContentVideosTabClicked__courseId_courseIdcourseName_courseName(p0, p1): return p0.intValue + p1.intValue
            case let .m_courseContentAssignmentsTabClicked__courseId_courseIdcourseName_courseName(p0, p1): return p0.intValue + p1.intValue
            case let .m_courseVideoClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(p0, p1, p2, p3): return p0.intValue + p1.intValue + p2.intValue + p3.intValue
            case let .m_courseAssignmentClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(p0, p1, p2, p3): return p0.intValue + p1.intValue + p2.intValue + p3.intValue
            case let .m_contentPageSectionClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(p0, p1, p2, p3): return p0.intValue + p1.intValue + p2.intValue + p3.intValue
            case let .m_contentPageShowCompletedSubsectionClicked__courseId_courseIdcourseName_courseName(p0, p1): return p0.intValue + p1.intValue
            case let .m_progressTabClicked__courseId_courseIdcourseName_courseName(p0, p1): return p0.intValue + p1.intValue
            case let .m_courseHomeViewAllContentClicked__courseId_courseIdcourseName_courseName(p0, p1): return p0.intValue + p1.intValue
            case let .m_courseHomeVideoClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(p0, p1, p2, p3): return p0.intValue + p1.intValue + p2.intValue + p3.intValue
            case let .m_courseHomeViewAllVideosClicked__courseId_courseIdcourseName_courseName(p0, p1): return p0.intValue + p1.intValue
            case let .m_courseHomeAssignmentClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(p0, p1, p2, p3): return p0.intValue + p1.intValue + p2.intValue + p3.intValue
            case let .m_courseHomeViewAllAssignmentsClicked__courseId_courseIdcourseName_courseName(p0, p1): return p0.intValue + p1.intValue
            case let .m_courseHomeGradesViewProgressClicked__courseId_courseIdcourseName_courseName(p0, p1): return p0.intValue + p1.intValue
            case let .m_courseHomeSectionSubsectionClick__courseId_courseIdcourseName_courseNamecourseSection_courseSectioncourseSubsection_courseSubsection(p0, p1, p2, p3): return p0.intValue + p1.intValue + p2.intValue + p3.intValue
            case let .m_datesComponentTapped__courseId_courseIdblockId_blockIdlink_linksupported_supported(p0, p1, p2, p3): return p0.intValue + p1.intValue + p2.intValue + p3.intValue
            case let .m_calendarSyncToggle__enrollmentMode_enrollmentModepacing_pacingcourseId_courseIdaction_action(p0, p1, p2, p3): return p0.intValue + p1.intValue + p2.intValue + p3.intValue
            case let .m_calendarSyncDialogAction__enrollmentMode_enrollmentModepacing_pacingcourseId_courseIddialog_dialogaction_action(p0, p1, p2, p3, p4): return p0.intValue + p1.intValue + p2.intValue + p3.intValue + p4.intValue
            case let .m_calendarSyncSnackbar__enrollmentMode_enrollmentModepacing_pacingcourseId_courseIdsnackbar_snackbar(p0, p1, p2, p3): return p0.intValue + p1.intValue + p2.intValue + p3.intValue
            case let .m_trackCourseEvent__eventbiValue_biValuecourseID_courseID(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_trackCourseScreenEvent__eventbiValue_biValuecourseID_courseID(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_plsEvent__eventbivalue_bivaluecourseID_courseIDscreenName_screenNametype_type(p0, p1, p2, p3, p4): return p0.intValue + p1.intValue + p2.intValue + p3.intValue + p4.intValue
            case let .m_plsSuccessEvent__eventbivalue_bivaluecourseID_courseIDscreenName_screenNametype_typesuccess_success(p0, p1, p2, p3, p4, p5): return p0.intValue + p1.intValue + p2.intValue + p3.intValue + p4.intValue + p5.intValue
            case let .m_bulkDownloadVideosToggle__courseID_courseIDaction_action(p0, p1): return p0.intValue + p1.intValue
            case let .m_bulkDownloadVideosSubsection__courseID_courseIDsectionID_sectionIDsubSectionID_subSectionIDvideos_videos(p0, p1, p2, p3): return p0.intValue + p1.intValue + p2.intValue + p3.intValue
            case let .m_bulkDeleteVideosSubsection__courseID_courseIDsubSectionID_subSectionIDvideos_videos(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_bulkDownloadVideosSection__courseID_courseIDsectionID_sectionIDvideos_videos(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_bulkDeleteVideosSection__courseID_courseIDsectionId_sectionIdvideos_videos(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_videoLoaded__courseID_courseIDblockID_blockIDvideoURL_videoURL(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_videoPlayed__courseID_courseIDblockID_blockIDvideoURL_videoURL(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_videoSpeedChange__courseID_courseIDblockID_blockIDvideoURL_videoURLoldSpeed_oldSpeednewSpeed_newSpeedcurrentTime_currentTimeduration_duration(p0, p1, p2, p3, p4, p5, p6): return p0.intValue + p1.intValue + p2.intValue + p3.intValue + p4.intValue + p5.intValue + p6.intValue
            case let .m_videoPaused__courseID_courseIDblockID_blockIDvideoURL_videoURLcurrentTime_currentTimeduration_duration(p0, p1, p2, p3, p4): return p0.intValue + p1.intValue + p2.intValue + p3.intValue + p4.intValue
            case let .m_videoCompleted__courseID_courseIDblockID_blockIDvideoURL_videoURLcurrentTime_currentTimeduration_duration(p0, p1, p2, p3, p4): return p0.intValue + p1.intValue + p2.intValue + p3.intValue + p4.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_resumeCourseClicked__courseId_courseIdcourseName_courseNameblockId_blockId: return ".resumeCourseClicked(courseId:courseName:blockId:)"
            case .m_sequentialClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName: return ".sequentialClicked(courseId:courseName:blockId:blockName:)"
            case .m_verticalClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName: return ".verticalClicked(courseId:courseName:blockId:blockName:)"
            case .m_nextBlockClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName: return ".nextBlockClicked(courseId:courseName:blockId:blockName:)"
            case .m_prevBlockClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName: return ".prevBlockClicked(courseId:courseName:blockId:blockName:)"
            case .m_finishVerticalClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName: return ".finishVerticalClicked(courseId:courseName:blockId:blockName:)"
            case .m_finishVerticalNextSectionClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName: return ".finishVerticalNextSectionClicked(courseId:courseName:blockId:blockName:)"
            case .m_finishVerticalBackToOutlineClicked__courseId_courseIdcourseName_courseName: return ".finishVerticalBackToOutlineClicked(courseId:courseName:)"
            case .m_courseOutlineCourseTabClicked__courseId_courseIdcourseName_courseName: return ".courseOutlineCourseTabClicked(courseId:courseName:)"
            case .m_courseOutlineContentTabClicked__courseId_courseIdcourseName_courseName: return ".courseOutlineContentTabClicked(courseId:courseName:)"
            case .m_courseOutlineProgressTabClicked__courseId_courseIdcourseName_courseName: return ".courseOutlineProgressTabClicked(courseId:courseName:)"
            case .m_courseOutlineVideosTabClicked__courseId_courseIdcourseName_courseName: return ".courseOutlineVideosTabClicked(courseId:courseName:)"
            case .m_courseOutlineOfflineTabClicked__courseId_courseIdcourseName_courseName: return ".courseOutlineOfflineTabClicked(courseId:courseName:)"
            case .m_courseOutlineDatesTabClicked__courseId_courseIdcourseName_courseName: return ".courseOutlineDatesTabClicked(courseId:courseName:)"
            case .m_courseOutlineDiscussionTabClicked__courseId_courseIdcourseName_courseName: return ".courseOutlineDiscussionTabClicked(courseId:courseName:)"
            case .m_courseOutlineHandoutsTabClicked__courseId_courseIdcourseName_courseName: return ".courseOutlineHandoutsTabClicked(courseId:courseName:)"
            case .m_courseOutlineAssignmentsTabClicked__courseId_courseIdcourseName_courseName: return ".courseOutlineAssignmentsTabClicked(courseId:courseName:)"
            case .m_courseContentAllTabClicked__courseId_courseIdcourseName_courseName: return ".courseContentAllTabClicked(courseId:courseName:)"
            case .m_courseContentVideosTabClicked__courseId_courseIdcourseName_courseName: return ".courseContentVideosTabClicked(courseId:courseName:)"
            case .m_courseContentAssignmentsTabClicked__courseId_courseIdcourseName_courseName: return ".courseContentAssignmentsTabClicked(courseId:courseName:)"
            case .m_courseVideoClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName: return ".courseVideoClicked(courseId:courseName:blockId:blockName:)"
            case .m_courseAssignmentClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName: return ".courseAssignmentClicked(courseId:courseName:blockId:blockName:)"
            case .m_contentPageSectionClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName: return ".contentPageSectionClicked(courseId:courseName:blockId:blockName:)"
            case .m_contentPageShowCompletedSubsectionClicked__courseId_courseIdcourseName_courseName: return ".contentPageShowCompletedSubsectionClicked(courseId:courseName:)"
            case .m_progressTabClicked__courseId_courseIdcourseName_courseName: return ".progressTabClicked(courseId:courseName:)"
            case .m_courseHomeViewAllContentClicked__courseId_courseIdcourseName_courseName: return ".courseHomeViewAllContentClicked(courseId:courseName:)"
            case .m_courseHomeVideoClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName: return ".courseHomeVideoClicked(courseId:courseName:blockId:blockName:)"
            case .m_courseHomeViewAllVideosClicked__courseId_courseIdcourseName_courseName: return ".courseHomeViewAllVideosClicked(courseId:courseName:)"
            case .m_courseHomeAssignmentClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName: return ".courseHomeAssignmentClicked(courseId:courseName:blockId:blockName:)"
            case .m_courseHomeViewAllAssignmentsClicked__courseId_courseIdcourseName_courseName: return ".courseHomeViewAllAssignmentsClicked(courseId:courseName:)"
            case .m_courseHomeGradesViewProgressClicked__courseId_courseIdcourseName_courseName: return ".courseHomeGradesViewProgressClicked(courseId:courseName:)"
            case .m_courseHomeSectionSubsectionClick__courseId_courseIdcourseName_courseNamecourseSection_courseSectioncourseSubsection_courseSubsection: return ".courseHomeSectionSubsectionClick(courseId:courseName:courseSection:courseSubsection:)"
            case .m_datesComponentTapped__courseId_courseIdblockId_blockIdlink_linksupported_supported: return ".datesComponentTapped(courseId:blockId:link:supported:)"
            case .m_calendarSyncToggle__enrollmentMode_enrollmentModepacing_pacingcourseId_courseIdaction_action: return ".calendarSyncToggle(enrollmentMode:pacing:courseId:action:)"
            case .m_calendarSyncDialogAction__enrollmentMode_enrollmentModepacing_pacingcourseId_courseIddialog_dialogaction_action: return ".calendarSyncDialogAction(enrollmentMode:pacing:courseId:dialog:action:)"
            case .m_calendarSyncSnackbar__enrollmentMode_enrollmentModepacing_pacingcourseId_courseIdsnackbar_snackbar: return ".calendarSyncSnackbar(enrollmentMode:pacing:courseId:snackbar:)"
            case .m_trackCourseEvent__eventbiValue_biValuecourseID_courseID: return ".trackCourseEvent(_:biValue:courseID:)"
            case .m_trackCourseScreenEvent__eventbiValue_biValuecourseID_courseID: return ".trackCourseScreenEvent(_:biValue:courseID:)"
            case .m_plsEvent__eventbivalue_bivaluecourseID_courseIDscreenName_screenNametype_type: return ".plsEvent(_:bivalue:courseID:screenName:type:)"
            case .m_plsSuccessEvent__eventbivalue_bivaluecourseID_courseIDscreenName_screenNametype_typesuccess_success: return ".plsSuccessEvent(_:bivalue:courseID:screenName:type:success:)"
            case .m_bulkDownloadVideosToggle__courseID_courseIDaction_action: return ".bulkDownloadVideosToggle(courseID:action:)"
            case .m_bulkDownloadVideosSubsection__courseID_courseIDsectionID_sectionIDsubSectionID_subSectionIDvideos_videos: return ".bulkDownloadVideosSubsection(courseID:sectionID:subSectionID:videos:)"
            case .m_bulkDeleteVideosSubsection__courseID_courseIDsubSectionID_subSectionIDvideos_videos: return ".bulkDeleteVideosSubsection(courseID:subSectionID:videos:)"
            case .m_bulkDownloadVideosSection__courseID_courseIDsectionID_sectionIDvideos_videos: return ".bulkDownloadVideosSection(courseID:sectionID:videos:)"
            case .m_bulkDeleteVideosSection__courseID_courseIDsectionId_sectionIdvideos_videos: return ".bulkDeleteVideosSection(courseID:sectionId:videos:)"
            case .m_videoLoaded__courseID_courseIDblockID_blockIDvideoURL_videoURL: return ".videoLoaded(courseID:blockID:videoURL:)"
            case .m_videoPlayed__courseID_courseIDblockID_blockIDvideoURL_videoURL: return ".videoPlayed(courseID:blockID:videoURL:)"
            case .m_videoSpeedChange__courseID_courseIDblockID_blockIDvideoURL_videoURLoldSpeed_oldSpeednewSpeed_newSpeedcurrentTime_currentTimeduration_duration: return ".videoSpeedChange(courseID:blockID:videoURL:oldSpeed:newSpeed:currentTime:duration:)"
            case .m_videoPaused__courseID_courseIDblockID_blockIDvideoURL_videoURLcurrentTime_currentTimeduration_duration: return ".videoPaused(courseID:blockID:videoURL:currentTime:duration:)"
            case .m_videoCompleted__courseID_courseIDblockID_blockIDvideoURL_videoURLcurrentTime_currentTimeduration_duration: return ".videoCompleted(courseID:blockID:videoURL:currentTime:duration:)"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func resumeCourseClicked(courseId: Parameter<String>, courseName: Parameter<String>, blockId: Parameter<String>) -> Verify { return Verify(method: .m_resumeCourseClicked__courseId_courseIdcourseName_courseNameblockId_blockId(`courseId`, `courseName`, `blockId`))}
        public static func sequentialClicked(courseId: Parameter<String>, courseName: Parameter<String>, blockId: Parameter<String>, blockName: Parameter<String>) -> Verify { return Verify(method: .m_sequentialClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(`courseId`, `courseName`, `blockId`, `blockName`))}
        public static func verticalClicked(courseId: Parameter<String>, courseName: Parameter<String>, blockId: Parameter<String>, blockName: Parameter<String>) -> Verify { return Verify(method: .m_verticalClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(`courseId`, `courseName`, `blockId`, `blockName`))}
        public static func nextBlockClicked(courseId: Parameter<String>, courseName: Parameter<String>, blockId: Parameter<String>, blockName: Parameter<String>) -> Verify { return Verify(method: .m_nextBlockClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(`courseId`, `courseName`, `blockId`, `blockName`))}
        public static func prevBlockClicked(courseId: Parameter<String>, courseName: Parameter<String>, blockId: Parameter<String>, blockName: Parameter<String>) -> Verify { return Verify(method: .m_prevBlockClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(`courseId`, `courseName`, `blockId`, `blockName`))}
        public static func finishVerticalClicked(courseId: Parameter<String>, courseName: Parameter<String>, blockId: Parameter<String>, blockName: Parameter<String>) -> Verify { return Verify(method: .m_finishVerticalClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(`courseId`, `courseName`, `blockId`, `blockName`))}
        public static func finishVerticalNextSectionClicked(courseId: Parameter<String>, courseName: Parameter<String>, blockId: Parameter<String>, blockName: Parameter<String>) -> Verify { return Verify(method: .m_finishVerticalNextSectionClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(`courseId`, `courseName`, `blockId`, `blockName`))}
        public static func finishVerticalBackToOutlineClicked(courseId: Parameter<String>, courseName: Parameter<String>) -> Verify { return Verify(method: .m_finishVerticalBackToOutlineClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`))}
        public static func courseOutlineCourseTabClicked(courseId: Parameter<String>, courseName: Parameter<String>) -> Verify { return Verify(method: .m_courseOutlineCourseTabClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`))}
        public static func courseOutlineContentTabClicked(courseId: Parameter<String>, courseName: Parameter<String>) -> Verify { return Verify(method: .m_courseOutlineContentTabClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`))}
        public static func courseOutlineProgressTabClicked(courseId: Parameter<String>, courseName: Parameter<String>) -> Verify { return Verify(method: .m_courseOutlineProgressTabClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`))}
        public static func courseOutlineVideosTabClicked(courseId: Parameter<String>, courseName: Parameter<String>) -> Verify { return Verify(method: .m_courseOutlineVideosTabClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`))}
        public static func courseOutlineOfflineTabClicked(courseId: Parameter<String>, courseName: Parameter<String>) -> Verify { return Verify(method: .m_courseOutlineOfflineTabClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`))}
        public static func courseOutlineDatesTabClicked(courseId: Parameter<String>, courseName: Parameter<String>) -> Verify { return Verify(method: .m_courseOutlineDatesTabClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`))}
        public static func courseOutlineDiscussionTabClicked(courseId: Parameter<String>, courseName: Parameter<String>) -> Verify { return Verify(method: .m_courseOutlineDiscussionTabClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`))}
        public static func courseOutlineHandoutsTabClicked(courseId: Parameter<String>, courseName: Parameter<String>) -> Verify { return Verify(method: .m_courseOutlineHandoutsTabClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`))}
        public static func courseOutlineAssignmentsTabClicked(courseId: Parameter<String>, courseName: Parameter<String>) -> Verify { return Verify(method: .m_courseOutlineAssignmentsTabClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`))}
        public static func courseContentAllTabClicked(courseId: Parameter<String>, courseName: Parameter<String>) -> Verify { return Verify(method: .m_courseContentAllTabClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`))}
        public static func courseContentVideosTabClicked(courseId: Parameter<String>, courseName: Parameter<String>) -> Verify { return Verify(method: .m_courseContentVideosTabClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`))}
        public static func courseContentAssignmentsTabClicked(courseId: Parameter<String>, courseName: Parameter<String>) -> Verify { return Verify(method: .m_courseContentAssignmentsTabClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`))}
        public static func courseVideoClicked(courseId: Parameter<String>, courseName: Parameter<String>, blockId: Parameter<String>, blockName: Parameter<String>) -> Verify { return Verify(method: .m_courseVideoClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(`courseId`, `courseName`, `blockId`, `blockName`))}
        public static func courseAssignmentClicked(courseId: Parameter<String>, courseName: Parameter<String>, blockId: Parameter<String>, blockName: Parameter<String>) -> Verify { return Verify(method: .m_courseAssignmentClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(`courseId`, `courseName`, `blockId`, `blockName`))}
        public static func contentPageSectionClicked(courseId: Parameter<String>, courseName: Parameter<String>, blockId: Parameter<String>, blockName: Parameter<String>) -> Verify { return Verify(method: .m_contentPageSectionClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(`courseId`, `courseName`, `blockId`, `blockName`))}
        public static func contentPageShowCompletedSubsectionClicked(courseId: Parameter<String>, courseName: Parameter<String>) -> Verify { return Verify(method: .m_contentPageShowCompletedSubsectionClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`))}
        public static func progressTabClicked(courseId: Parameter<String>, courseName: Parameter<String>) -> Verify { return Verify(method: .m_progressTabClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`))}
        public static func courseHomeViewAllContentClicked(courseId: Parameter<String>, courseName: Parameter<String>) -> Verify { return Verify(method: .m_courseHomeViewAllContentClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`))}
        public static func courseHomeVideoClicked(courseId: Parameter<String>, courseName: Parameter<String>, blockId: Parameter<String>, blockName: Parameter<String>) -> Verify { return Verify(method: .m_courseHomeVideoClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(`courseId`, `courseName`, `blockId`, `blockName`))}
        public static func courseHomeViewAllVideosClicked(courseId: Parameter<String>, courseName: Parameter<String>) -> Verify { return Verify(method: .m_courseHomeViewAllVideosClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`))}
        public static func courseHomeAssignmentClicked(courseId: Parameter<String>, courseName: Parameter<String>, blockId: Parameter<String>, blockName: Parameter<String>) -> Verify { return Verify(method: .m_courseHomeAssignmentClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(`courseId`, `courseName`, `blockId`, `blockName`))}
        public static func courseHomeViewAllAssignmentsClicked(courseId: Parameter<String>, courseName: Parameter<String>) -> Verify { return Verify(method: .m_courseHomeViewAllAssignmentsClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`))}
        public static func courseHomeGradesViewProgressClicked(courseId: Parameter<String>, courseName: Parameter<String>) -> Verify { return Verify(method: .m_courseHomeGradesViewProgressClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`))}
        public static func courseHomeSectionSubsectionClick(courseId: Parameter<String>, courseName: Parameter<String>, courseSection: Parameter<String>, courseSubsection: Parameter<String>) -> Verify { return Verify(method: .m_courseHomeSectionSubsectionClick__courseId_courseIdcourseName_courseNamecourseSection_courseSectioncourseSubsection_courseSubsection(`courseId`, `courseName`, `courseSection`, `courseSubsection`))}
        public static func datesComponentTapped(courseId: Parameter<String>, blockId: Parameter<String>, link: Parameter<String>, supported: Parameter<Bool>) -> Verify { return Verify(method: .m_datesComponentTapped__courseId_courseIdblockId_blockIdlink_linksupported_supported(`courseId`, `blockId`, `link`, `supported`))}
        public static func calendarSyncToggle(enrollmentMode: Parameter<EnrollmentMode>, pacing: Parameter<CoursePacing>, courseId: Parameter<String>, action: Parameter<CalendarDialogueAction>) -> Verify { return Verify(method: .m_calendarSyncToggle__enrollmentMode_enrollmentModepacing_pacingcourseId_courseIdaction_action(`enrollmentMode`, `pacing`, `courseId`, `action`))}
        public static func calendarSyncDialogAction(enrollmentMode: Parameter<EnrollmentMode>, pacing: Parameter<CoursePacing>, courseId: Parameter<String>, dialog: Parameter<CalendarDialogueType>, action: Parameter<CalendarDialogueAction>) -> Verify { return Verify(method: .m_calendarSyncDialogAction__enrollmentMode_enrollmentModepacing_pacingcourseId_courseIddialog_dialogaction_action(`enrollmentMode`, `pacing`, `courseId`, `dialog`, `action`))}
        public static func calendarSyncSnackbar(enrollmentMode: Parameter<EnrollmentMode>, pacing: Parameter<CoursePacing>, courseId: Parameter<String>, snackbar: Parameter<SnackbarType>) -> Verify { return Verify(method: .m_calendarSyncSnackbar__enrollmentMode_enrollmentModepacing_pacingcourseId_courseIdsnackbar_snackbar(`enrollmentMode`, `pacing`, `courseId`, `snackbar`))}
        public static func trackCourseEvent(_ event: Parameter<AnalyticsEvent>, biValue: Parameter<EventBIValue>, courseID: Parameter<String>) -> Verify { return Verify(method: .m_trackCourseEvent__eventbiValue_biValuecourseID_courseID(`event`, `biValue`, `courseID`))}
        public static func trackCourseScreenEvent(_ event: Parameter<AnalyticsEvent>, biValue: Parameter<EventBIValue>, courseID: Parameter<String>) -> Verify { return Verify(method: .m_trackCourseScreenEvent__eventbiValue_biValuecourseID_courseID(`event`, `biValue`, `courseID`))}
        public static func plsEvent(_ event: Parameter<AnalyticsEvent>, bivalue: Parameter<EventBIValue>, courseID: Parameter<String>, screenName: Parameter<String>, type: Parameter<String>) -> Verify { return Verify(method: .m_plsEvent__eventbivalue_bivaluecourseID_courseIDscreenName_screenNametype_type(`event`, `bivalue`, `courseID`, `screenName`, `type`))}
        public static func plsSuccessEvent(_ event: Parameter<AnalyticsEvent>, bivalue: Parameter<EventBIValue>, courseID: Parameter<String>, screenName: Parameter<String>, type: Parameter<String>, success: Parameter<Bool>) -> Verify { return Verify(method: .m_plsSuccessEvent__eventbivalue_bivaluecourseID_courseIDscreenName_screenNametype_typesuccess_success(`event`, `bivalue`, `courseID`, `screenName`, `type`, `success`))}
        public static func bulkDownloadVideosToggle(courseID: Parameter<String>, action: Parameter<Bool>) -> Verify { return Verify(method: .m_bulkDownloadVideosToggle__courseID_courseIDaction_action(`courseID`, `action`))}
        public static func bulkDownloadVideosSubsection(courseID: Parameter<String>, sectionID: Parameter<String>, subSectionID: Parameter<String>, videos: Parameter<Int>) -> Verify { return Verify(method: .m_bulkDownloadVideosSubsection__courseID_courseIDsectionID_sectionIDsubSectionID_subSectionIDvideos_videos(`courseID`, `sectionID`, `subSectionID`, `videos`))}
        public static func bulkDeleteVideosSubsection(courseID: Parameter<String>, subSectionID: Parameter<String>, videos: Parameter<Int>) -> Verify { return Verify(method: .m_bulkDeleteVideosSubsection__courseID_courseIDsubSectionID_subSectionIDvideos_videos(`courseID`, `subSectionID`, `videos`))}
        public static func bulkDownloadVideosSection(courseID: Parameter<String>, sectionID: Parameter<String>, videos: Parameter<Int>) -> Verify { return Verify(method: .m_bulkDownloadVideosSection__courseID_courseIDsectionID_sectionIDvideos_videos(`courseID`, `sectionID`, `videos`))}
        public static func bulkDeleteVideosSection(courseID: Parameter<String>, sectionId: Parameter<String>, videos: Parameter<Int>) -> Verify { return Verify(method: .m_bulkDeleteVideosSection__courseID_courseIDsectionId_sectionIdvideos_videos(`courseID`, `sectionId`, `videos`))}
        public static func videoLoaded(courseID: Parameter<String>, blockID: Parameter<String>, videoURL: Parameter<String>) -> Verify { return Verify(method: .m_videoLoaded__courseID_courseIDblockID_blockIDvideoURL_videoURL(`courseID`, `blockID`, `videoURL`))}
        public static func videoPlayed(courseID: Parameter<String>, blockID: Parameter<String>, videoURL: Parameter<String>) -> Verify { return Verify(method: .m_videoPlayed__courseID_courseIDblockID_blockIDvideoURL_videoURL(`courseID`, `blockID`, `videoURL`))}
        public static func videoSpeedChange(courseID: Parameter<String>, blockID: Parameter<String>, videoURL: Parameter<String>, oldSpeed: Parameter<Float>, newSpeed: Parameter<Float>, currentTime: Parameter<Double>, duration: Parameter<Double>) -> Verify { return Verify(method: .m_videoSpeedChange__courseID_courseIDblockID_blockIDvideoURL_videoURLoldSpeed_oldSpeednewSpeed_newSpeedcurrentTime_currentTimeduration_duration(`courseID`, `blockID`, `videoURL`, `oldSpeed`, `newSpeed`, `currentTime`, `duration`))}
        public static func videoPaused(courseID: Parameter<String>, blockID: Parameter<String>, videoURL: Parameter<String>, currentTime: Parameter<Double>, duration: Parameter<Double>) -> Verify { return Verify(method: .m_videoPaused__courseID_courseIDblockID_blockIDvideoURL_videoURLcurrentTime_currentTimeduration_duration(`courseID`, `blockID`, `videoURL`, `currentTime`, `duration`))}
        public static func videoCompleted(courseID: Parameter<String>, blockID: Parameter<String>, videoURL: Parameter<String>, currentTime: Parameter<Double>, duration: Parameter<Double>) -> Verify { return Verify(method: .m_videoCompleted__courseID_courseIDblockID_blockIDvideoURL_videoURLcurrentTime_currentTimeduration_duration(`courseID`, `blockID`, `videoURL`, `currentTime`, `duration`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func resumeCourseClicked(courseId: Parameter<String>, courseName: Parameter<String>, blockId: Parameter<String>, perform: @escaping (String, String, String) -> Void) -> Perform {
            return Perform(method: .m_resumeCourseClicked__courseId_courseIdcourseName_courseNameblockId_blockId(`courseId`, `courseName`, `blockId`), performs: perform)
        }
        public static func sequentialClicked(courseId: Parameter<String>, courseName: Parameter<String>, blockId: Parameter<String>, blockName: Parameter<String>, perform: @escaping (String, String, String, String) -> Void) -> Perform {
            return Perform(method: .m_sequentialClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(`courseId`, `courseName`, `blockId`, `blockName`), performs: perform)
        }
        public static func verticalClicked(courseId: Parameter<String>, courseName: Parameter<String>, blockId: Parameter<String>, blockName: Parameter<String>, perform: @escaping (String, String, String, String) -> Void) -> Perform {
            return Perform(method: .m_verticalClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(`courseId`, `courseName`, `blockId`, `blockName`), performs: perform)
        }
        public static func nextBlockClicked(courseId: Parameter<String>, courseName: Parameter<String>, blockId: Parameter<String>, blockName: Parameter<String>, perform: @escaping (String, String, String, String) -> Void) -> Perform {
            return Perform(method: .m_nextBlockClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(`courseId`, `courseName`, `blockId`, `blockName`), performs: perform)
        }
        public static func prevBlockClicked(courseId: Parameter<String>, courseName: Parameter<String>, blockId: Parameter<String>, blockName: Parameter<String>, perform: @escaping (String, String, String, String) -> Void) -> Perform {
            return Perform(method: .m_prevBlockClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(`courseId`, `courseName`, `blockId`, `blockName`), performs: perform)
        }
        public static func finishVerticalClicked(courseId: Parameter<String>, courseName: Parameter<String>, blockId: Parameter<String>, blockName: Parameter<String>, perform: @escaping (String, String, String, String) -> Void) -> Perform {
            return Perform(method: .m_finishVerticalClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(`courseId`, `courseName`, `blockId`, `blockName`), performs: perform)
        }
        public static func finishVerticalNextSectionClicked(courseId: Parameter<String>, courseName: Parameter<String>, blockId: Parameter<String>, blockName: Parameter<String>, perform: @escaping (String, String, String, String) -> Void) -> Perform {
            return Perform(method: .m_finishVerticalNextSectionClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(`courseId`, `courseName`, `blockId`, `blockName`), performs: perform)
        }
        public static func finishVerticalBackToOutlineClicked(courseId: Parameter<String>, courseName: Parameter<String>, perform: @escaping (String, String) -> Void) -> Perform {
            return Perform(method: .m_finishVerticalBackToOutlineClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`), performs: perform)
        }
        public static func courseOutlineCourseTabClicked(courseId: Parameter<String>, courseName: Parameter<String>, perform: @escaping (String, String) -> Void) -> Perform {
            return Perform(method: .m_courseOutlineCourseTabClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`), performs: perform)
        }
        public static func courseOutlineContentTabClicked(courseId: Parameter<String>, courseName: Parameter<String>, perform: @escaping (String, String) -> Void) -> Perform {
            return Perform(method: .m_courseOutlineContentTabClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`), performs: perform)
        }
        public static func courseOutlineProgressTabClicked(courseId: Parameter<String>, courseName: Parameter<String>, perform: @escaping (String, String) -> Void) -> Perform {
            return Perform(method: .m_courseOutlineProgressTabClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`), performs: perform)
        }
        public static func courseOutlineVideosTabClicked(courseId: Parameter<String>, courseName: Parameter<String>, perform: @escaping (String, String) -> Void) -> Perform {
            return Perform(method: .m_courseOutlineVideosTabClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`), performs: perform)
        }
        public static func courseOutlineOfflineTabClicked(courseId: Parameter<String>, courseName: Parameter<String>, perform: @escaping (String, String) -> Void) -> Perform {
            return Perform(method: .m_courseOutlineOfflineTabClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`), performs: perform)
        }
        public static func courseOutlineDatesTabClicked(courseId: Parameter<String>, courseName: Parameter<String>, perform: @escaping (String, String) -> Void) -> Perform {
            return Perform(method: .m_courseOutlineDatesTabClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`), performs: perform)
        }
        public static func courseOutlineDiscussionTabClicked(courseId: Parameter<String>, courseName: Parameter<String>, perform: @escaping (String, String) -> Void) -> Perform {
            return Perform(method: .m_courseOutlineDiscussionTabClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`), performs: perform)
        }
        public static func courseOutlineHandoutsTabClicked(courseId: Parameter<String>, courseName: Parameter<String>, perform: @escaping (String, String) -> Void) -> Perform {
            return Perform(method: .m_courseOutlineHandoutsTabClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`), performs: perform)
        }
        public static func courseOutlineAssignmentsTabClicked(courseId: Parameter<String>, courseName: Parameter<String>, perform: @escaping (String, String) -> Void) -> Perform {
            return Perform(method: .m_courseOutlineAssignmentsTabClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`), performs: perform)
        }
        public static func courseContentAllTabClicked(courseId: Parameter<String>, courseName: Parameter<String>, perform: @escaping (String, String) -> Void) -> Perform {
            return Perform(method: .m_courseContentAllTabClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`), performs: perform)
        }
        public static func courseContentVideosTabClicked(courseId: Parameter<String>, courseName: Parameter<String>, perform: @escaping (String, String) -> Void) -> Perform {
            return Perform(method: .m_courseContentVideosTabClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`), performs: perform)
        }
        public static func courseContentAssignmentsTabClicked(courseId: Parameter<String>, courseName: Parameter<String>, perform: @escaping (String, String) -> Void) -> Perform {
            return Perform(method: .m_courseContentAssignmentsTabClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`), performs: perform)
        }
        public static func courseVideoClicked(courseId: Parameter<String>, courseName: Parameter<String>, blockId: Parameter<String>, blockName: Parameter<String>, perform: @escaping (String, String, String, String) -> Void) -> Perform {
            return Perform(method: .m_courseVideoClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(`courseId`, `courseName`, `blockId`, `blockName`), performs: perform)
        }
        public static func courseAssignmentClicked(courseId: Parameter<String>, courseName: Parameter<String>, blockId: Parameter<String>, blockName: Parameter<String>, perform: @escaping (String, String, String, String) -> Void) -> Perform {
            return Perform(method: .m_courseAssignmentClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(`courseId`, `courseName`, `blockId`, `blockName`), performs: perform)
        }
        public static func contentPageSectionClicked(courseId: Parameter<String>, courseName: Parameter<String>, blockId: Parameter<String>, blockName: Parameter<String>, perform: @escaping (String, String, String, String) -> Void) -> Perform {
            return Perform(method: .m_contentPageSectionClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(`courseId`, `courseName`, `blockId`, `blockName`), performs: perform)
        }
        public static func contentPageShowCompletedSubsectionClicked(courseId: Parameter<String>, courseName: Parameter<String>, perform: @escaping (String, String) -> Void) -> Perform {
            return Perform(method: .m_contentPageShowCompletedSubsectionClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`), performs: perform)
        }
        public static func progressTabClicked(courseId: Parameter<String>, courseName: Parameter<String>, perform: @escaping (String, String) -> Void) -> Perform {
            return Perform(method: .m_progressTabClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`), performs: perform)
        }
        public static func courseHomeViewAllContentClicked(courseId: Parameter<String>, courseName: Parameter<String>, perform: @escaping (String, String) -> Void) -> Perform {
            return Perform(method: .m_courseHomeViewAllContentClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`), performs: perform)
        }
        public static func courseHomeVideoClicked(courseId: Parameter<String>, courseName: Parameter<String>, blockId: Parameter<String>, blockName: Parameter<String>, perform: @escaping (String, String, String, String) -> Void) -> Perform {
            return Perform(method: .m_courseHomeVideoClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(`courseId`, `courseName`, `blockId`, `blockName`), performs: perform)
        }
        public static func courseHomeViewAllVideosClicked(courseId: Parameter<String>, courseName: Parameter<String>, perform: @escaping (String, String) -> Void) -> Perform {
            return Perform(method: .m_courseHomeViewAllVideosClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`), performs: perform)
        }
        public static func courseHomeAssignmentClicked(courseId: Parameter<String>, courseName: Parameter<String>, blockId: Parameter<String>, blockName: Parameter<String>, perform: @escaping (String, String, String, String) -> Void) -> Perform {
            return Perform(method: .m_courseHomeAssignmentClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(`courseId`, `courseName`, `blockId`, `blockName`), performs: perform)
        }
        public static func courseHomeViewAllAssignmentsClicked(courseId: Parameter<String>, courseName: Parameter<String>, perform: @escaping (String, String) -> Void) -> Perform {
            return Perform(method: .m_courseHomeViewAllAssignmentsClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`), performs: perform)
        }
        public static func courseHomeGradesViewProgressClicked(courseId: Parameter<String>, courseName: Parameter<String>, perform: @escaping (String, String) -> Void) -> Perform {
            return Perform(method: .m_courseHomeGradesViewProgressClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`), performs: perform)
        }
        public static func courseHomeSectionSubsectionClick(courseId: Parameter<String>, courseName: Parameter<String>, courseSection: Parameter<String>, courseSubsection: Parameter<String>, perform: @escaping (String, String, String, String) -> Void) -> Perform {
            return Perform(method: .m_courseHomeSectionSubsectionClick__courseId_courseIdcourseName_courseNamecourseSection_courseSectioncourseSubsection_courseSubsection(`courseId`, `courseName`, `courseSection`, `courseSubsection`), performs: perform)
        }
        public static func datesComponentTapped(courseId: Parameter<String>, blockId: Parameter<String>, link: Parameter<String>, supported: Parameter<Bool>, perform: @escaping (String, String, String, Bool) -> Void) -> Perform {
            return Perform(method: .m_datesComponentTapped__courseId_courseIdblockId_blockIdlink_linksupported_supported(`courseId`, `blockId`, `link`, `supported`), performs: perform)
        }
        public static func calendarSyncToggle(enrollmentMode: Parameter<EnrollmentMode>, pacing: Parameter<CoursePacing>, courseId: Parameter<String>, action: Parameter<CalendarDialogueAction>, perform: @escaping (EnrollmentMode, CoursePacing, String, CalendarDialogueAction) -> Void) -> Perform {
            return Perform(method: .m_calendarSyncToggle__enrollmentMode_enrollmentModepacing_pacingcourseId_courseIdaction_action(`enrollmentMode`, `pacing`, `courseId`, `action`), performs: perform)
        }
        public static func calendarSyncDialogAction(enrollmentMode: Parameter<EnrollmentMode>, pacing: Parameter<CoursePacing>, courseId: Parameter<String>, dialog: Parameter<CalendarDialogueType>, action: Parameter<CalendarDialogueAction>, perform: @escaping (EnrollmentMode, CoursePacing, String, CalendarDialogueType, CalendarDialogueAction) -> Void) -> Perform {
            return Perform(method: .m_calendarSyncDialogAction__enrollmentMode_enrollmentModepacing_pacingcourseId_courseIddialog_dialogaction_action(`enrollmentMode`, `pacing`, `courseId`, `dialog`, `action`), performs: perform)
        }
        public static func calendarSyncSnackbar(enrollmentMode: Parameter<EnrollmentMode>, pacing: Parameter<CoursePacing>, courseId: Parameter<String>, snackbar: Parameter<SnackbarType>, perform: @escaping (EnrollmentMode, CoursePacing, String, SnackbarType) -> Void) -> Perform {
            return Perform(method: .m_calendarSyncSnackbar__enrollmentMode_enrollmentModepacing_pacingcourseId_courseIdsnackbar_snackbar(`enrollmentMode`, `pacing`, `courseId`, `snackbar`), performs: perform)
        }
        public static func trackCourseEvent(_ event: Parameter<AnalyticsEvent>, biValue: Parameter<EventBIValue>, courseID: Parameter<String>, perform: @escaping (AnalyticsEvent, EventBIValue, String) -> Void) -> Perform {
            return Perform(method: .m_trackCourseEvent__eventbiValue_biValuecourseID_courseID(`event`, `biValue`, `courseID`), performs: perform)
        }
        public static func trackCourseScreenEvent(_ event: Parameter<AnalyticsEvent>, biValue: Parameter<EventBIValue>, courseID: Parameter<String>, perform: @escaping (AnalyticsEvent, EventBIValue, String) -> Void) -> Perform {
            return Perform(method: .m_trackCourseScreenEvent__eventbiValue_biValuecourseID_courseID(`event`, `biValue`, `courseID`), performs: perform)
        }
        public static func plsEvent(_ event: Parameter<AnalyticsEvent>, bivalue: Parameter<EventBIValue>, courseID: Parameter<String>, screenName: Parameter<String>, type: Parameter<String>, perform: @escaping (AnalyticsEvent, EventBIValue, String, String, String) -> Void) -> Perform {
            return Perform(method: .m_plsEvent__eventbivalue_bivaluecourseID_courseIDscreenName_screenNametype_type(`event`, `bivalue`, `courseID`, `screenName`, `type`), performs: perform)
        }
        public static func plsSuccessEvent(_ event: Parameter<AnalyticsEvent>, bivalue: Parameter<EventBIValue>, courseID: Parameter<String>, screenName: Parameter<String>, type: Parameter<String>, success: Parameter<Bool>, perform: @escaping (AnalyticsEvent, EventBIValue, String, String, String, Bool) -> Void) -> Perform {
            return Perform(method: .m_plsSuccessEvent__eventbivalue_bivaluecourseID_courseIDscreenName_screenNametype_typesuccess_success(`event`, `bivalue`, `courseID`, `screenName`, `type`, `success`), performs: perform)
        }
        public static func bulkDownloadVideosToggle(courseID: Parameter<String>, action: Parameter<Bool>, perform: @escaping (String, Bool) -> Void) -> Perform {
            return Perform(method: .m_bulkDownloadVideosToggle__courseID_courseIDaction_action(`courseID`, `action`), performs: perform)
        }
        public static func bulkDownloadVideosSubsection(courseID: Parameter<String>, sectionID: Parameter<String>, subSectionID: Parameter<String>, videos: Parameter<Int>, perform: @escaping (String, String, String, Int) -> Void) -> Perform {
            return Perform(method: .m_bulkDownloadVideosSubsection__courseID_courseIDsectionID_sectionIDsubSectionID_subSectionIDvideos_videos(`courseID`, `sectionID`, `subSectionID`, `videos`), performs: perform)
        }
        public static func bulkDeleteVideosSubsection(courseID: Parameter<String>, subSectionID: Parameter<String>, videos: Parameter<Int>, perform: @escaping (String, String, Int) -> Void) -> Perform {
            return Perform(method: .m_bulkDeleteVideosSubsection__courseID_courseIDsubSectionID_subSectionIDvideos_videos(`courseID`, `subSectionID`, `videos`), performs: perform)
        }
        public static func bulkDownloadVideosSection(courseID: Parameter<String>, sectionID: Parameter<String>, videos: Parameter<Int>, perform: @escaping (String, String, Int) -> Void) -> Perform {
            return Perform(method: .m_bulkDownloadVideosSection__courseID_courseIDsectionID_sectionIDvideos_videos(`courseID`, `sectionID`, `videos`), performs: perform)
        }
        public static func bulkDeleteVideosSection(courseID: Parameter<String>, sectionId: Parameter<String>, videos: Parameter<Int>, perform: @escaping (String, String, Int) -> Void) -> Perform {
            return Perform(method: .m_bulkDeleteVideosSection__courseID_courseIDsectionId_sectionIdvideos_videos(`courseID`, `sectionId`, `videos`), performs: perform)
        }
        public static func videoLoaded(courseID: Parameter<String>, blockID: Parameter<String>, videoURL: Parameter<String>, perform: @escaping (String, String, String) -> Void) -> Perform {
            return Perform(method: .m_videoLoaded__courseID_courseIDblockID_blockIDvideoURL_videoURL(`courseID`, `blockID`, `videoURL`), performs: perform)
        }
        public static func videoPlayed(courseID: Parameter<String>, blockID: Parameter<String>, videoURL: Parameter<String>, perform: @escaping (String, String, String) -> Void) -> Perform {
            return Perform(method: .m_videoPlayed__courseID_courseIDblockID_blockIDvideoURL_videoURL(`courseID`, `blockID`, `videoURL`), performs: perform)
        }
        public static func videoSpeedChange(courseID: Parameter<String>, blockID: Parameter<String>, videoURL: Parameter<String>, oldSpeed: Parameter<Float>, newSpeed: Parameter<Float>, currentTime: Parameter<Double>, duration: Parameter<Double>, perform: @escaping (String, String, String, Float, Float, Double, Double) -> Void) -> Perform {
            return Perform(method: .m_videoSpeedChange__courseID_courseIDblockID_blockIDvideoURL_videoURLoldSpeed_oldSpeednewSpeed_newSpeedcurrentTime_currentTimeduration_duration(`courseID`, `blockID`, `videoURL`, `oldSpeed`, `newSpeed`, `currentTime`, `duration`), performs: perform)
        }
        public static func videoPaused(courseID: Parameter<String>, blockID: Parameter<String>, videoURL: Parameter<String>, currentTime: Parameter<Double>, duration: Parameter<Double>, perform: @escaping (String, String, String, Double, Double) -> Void) -> Perform {
            return Perform(method: .m_videoPaused__courseID_courseIDblockID_blockIDvideoURL_videoURLcurrentTime_currentTimeduration_duration(`courseID`, `blockID`, `videoURL`, `currentTime`, `duration`), performs: perform)
        }
        public static func videoCompleted(courseID: Parameter<String>, blockID: Parameter<String>, videoURL: Parameter<String>, currentTime: Parameter<Double>, duration: Parameter<Double>, perform: @escaping (String, String, String, Double, Double) -> Void) -> Perform {
            return Perform(method: .m_videoCompleted__courseID_courseIDblockID_blockIDvideoURL_videoURLcurrentTime_currentTimeduration_duration(`courseID`, `blockID`, `videoURL`, `currentTime`, `duration`), performs: perform)
        }
    }

    public func given(_ method: Given) {
        methodReturnValues.append(method)
    }

    public func perform(_ method: Perform) {
        methodPerformValues.append(method)
        methodPerformValues.sort { $0.method.intValue() < $1.method.intValue() }
    }

    public func verify(_ method: Verify, count: Count = Count.moreOrEqual(to: 1), file: StaticString = #file, line: UInt = #line) {
        let fullMatches = matchingCalls(method, file: file, line: line)
        let success = count.matches(fullMatches)
        let assertionName = method.method.assertionName()
        let feedback: String = {
            guard !success else { return "" }
            return Utils.closestCallsMessage(
                for: self.invocations.map { invocation in
                    matcher.set(file: file, line: line)
                    defer { matcher.clearFileAndLine() }
                    return MethodType.compareParameters(lhs: invocation, rhs: method.method, matcher: matcher)
                },
                name: assertionName
            )
        }()
        MockyAssert(success, "Expected: \(count) invocations of `\(assertionName)`, but was: \(fullMatches).\(feedback)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        self.queue.sync { invocations.append(call) }
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType, file: StaticString?, line: UInt?) -> [MethodType] {
        matcher.set(file: file ?? self.file, line: line ?? self.line)
        defer { matcher.clearFileAndLine() }
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher).isFullMatch }
    }
    private func matchingCalls(_ method: Verify, file: StaticString?, line: UInt?) -> Int {
        return matchingCalls(method.method, file: file, line: line).count
    }
    private func givenGetterValue<T>(_ method: MethodType, _ message: String) -> T {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            onFatalFailure(message)
            Failure(message)
        }
    }
    private func optionalGivenGetterValue<T>(_ method: MethodType, _ message: String) -> T? {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            return nil
        }
    }
    private func onFatalFailure(_ message: String) {
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleFatalError(message: message, file: file, line: line)
    }
}

// MARK: - CourseDownloadHelperProtocol

open class CourseDownloadHelperProtocolMock: CourseDownloadHelperProtocol, Mock {
    public init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
        SwiftyMockyTestObserver.setup()
        self.sequencingPolicy = sequencingPolicy
        self.stubbingPolicy = stubbingPolicy
        self.file = file
        self.line = line
    }

    var matcher: Matcher = Matcher.default
    var stubbingPolicy: StubbingPolicy = .wrap
    var sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst

    private var queue = DispatchQueue(label: "com.swiftymocky.invocations", qos: .userInteractive)
    private var invocations: [MethodType] = []
    private var methodReturnValues: [Given] = []
    private var methodPerformValues: [Perform] = []
    private var file: StaticString?
    private var line: UInt?

    public typealias PropertyStub = Given
    public typealias MethodStub = Given
    public typealias SubscriptStub = Given

    /// Convenience method - call setupMock() to extend debug information when failure occurs
    public func setupMock(file: StaticString = #file, line: UInt = #line) {
        self.file = file
        self.line = line
    }

    /// Clear mock internals. You can specify what to reset (invocations aka verify, givens or performs) or leave it empty to clear all mock internals
    public func resetMock(_ scopes: MockScope...) {
        let scopes: [MockScope] = scopes.isEmpty ? [.invocation, .given, .perform] : scopes
        if scopes.contains(.invocation) { invocations = [] }
        if scopes.contains(.given) { methodReturnValues = [] }
        if scopes.contains(.perform) { methodPerformValues = [] }
    }

    public var value: CourseDownloadValue? {
		get {	invocations.append(.p_value_get); return __p_value ?? optionalGivenGetterValue(.p_value_get, "CourseDownloadHelperProtocolMock - stub value for value was not defined") }
	}
	private var __p_value: (CourseDownloadValue)?

    public var courseStructure: CourseStructure? {
		get {	invocations.append(.p_courseStructure_get); return __p_courseStructure ?? optionalGivenGetterValue(.p_courseStructure_get, "CourseDownloadHelperProtocolMock - stub value for courseStructure was not defined") }
		set {	invocations.append(.p_courseStructure_set(.value(newValue))); __p_courseStructure = newValue }
	}
	private var __p_courseStructure: (CourseStructure)?

    public var videoQuality: DownloadQuality {
		get {	invocations.append(.p_videoQuality_get); return __p_videoQuality ?? givenGetterValue(.p_videoQuality_get, "CourseDownloadHelperProtocolMock - stub value for videoQuality was not defined") }
		set {	invocations.append(.p_videoQuality_set(.value(newValue))); __p_videoQuality = newValue }
	}
	private var __p_videoQuality: (DownloadQuality)?





    open func publisher() -> AnyPublisher<CourseDownloadValue, Never> {
        addInvocation(.m_publisher)
		let perform = methodPerformValue(.m_publisher) as? () -> Void
		perform?()
		var __value: AnyPublisher<CourseDownloadValue, Never>
		do {
		    __value = try methodReturnValue(.m_publisher).casted()
		} catch {
			onFatalFailure("Stub return value not specified for publisher(). Use given")
			Failure("Stub return value not specified for publisher(). Use given")
		}
		return __value
    }

    open func progressPublisher() -> AnyPublisher<DownloadDataTask, Never> {
        addInvocation(.m_progressPublisher)
		let perform = methodPerformValue(.m_progressPublisher) as? () -> Void
		perform?()
		var __value: AnyPublisher<DownloadDataTask, Never>
		do {
		    __value = try methodReturnValue(.m_progressPublisher).casted()
		} catch {
			onFatalFailure("Stub return value not specified for progressPublisher(). Use given")
			Failure("Stub return value not specified for progressPublisher(). Use given")
		}
		return __value
    }

    open func refreshValue() {
        addInvocation(.m_refreshValue)
		let perform = methodPerformValue(.m_refreshValue) as? () -> Void
		perform?()
    }

    open func sizeFor(block: CourseBlock) -> Int? {
        addInvocation(.m_sizeFor__block_block(Parameter<CourseBlock>.value(`block`)))
		let perform = methodPerformValue(.m_sizeFor__block_block(Parameter<CourseBlock>.value(`block`))) as? (CourseBlock) -> Void
		perform?(`block`)
		var __value: Int? = nil
		do {
		    __value = try methodReturnValue(.m_sizeFor__block_block(Parameter<CourseBlock>.value(`block`))).casted()
		} catch {
			// do nothing
		}
		return __value
    }

    open func sizeFor(blocks: [CourseBlock]) -> Int {
        addInvocation(.m_sizeFor__blocks_blocks(Parameter<[CourseBlock]>.value(`blocks`)))
		let perform = methodPerformValue(.m_sizeFor__blocks_blocks(Parameter<[CourseBlock]>.value(`blocks`))) as? ([CourseBlock]) -> Void
		perform?(`blocks`)
		var __value: Int
		do {
		    __value = try methodReturnValue(.m_sizeFor__blocks_blocks(Parameter<[CourseBlock]>.value(`blocks`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for sizeFor(blocks: [CourseBlock]). Use given")
			Failure("Stub return value not specified for sizeFor(blocks: [CourseBlock]). Use given")
		}
		return __value
    }

    open func sizeFor(sequential: CourseSequential) -> Int {
        addInvocation(.m_sizeFor__sequential_sequential(Parameter<CourseSequential>.value(`sequential`)))
		let perform = methodPerformValue(.m_sizeFor__sequential_sequential(Parameter<CourseSequential>.value(`sequential`))) as? (CourseSequential) -> Void
		perform?(`sequential`)
		var __value: Int
		do {
		    __value = try methodReturnValue(.m_sizeFor__sequential_sequential(Parameter<CourseSequential>.value(`sequential`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for sizeFor(sequential: CourseSequential). Use given")
			Failure("Stub return value not specified for sizeFor(sequential: CourseSequential). Use given")
		}
		return __value
    }

    open func sizeFor(sequentials: [CourseSequential]) -> Int {
        addInvocation(.m_sizeFor__sequentials_sequentials(Parameter<[CourseSequential]>.value(`sequentials`)))
		let perform = methodPerformValue(.m_sizeFor__sequentials_sequentials(Parameter<[CourseSequential]>.value(`sequentials`))) as? ([CourseSequential]) -> Void
		perform?(`sequentials`)
		var __value: Int
		do {
		    __value = try methodReturnValue(.m_sizeFor__sequentials_sequentials(Parameter<[CourseSequential]>.value(`sequentials`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for sizeFor(sequentials: [CourseSequential]). Use given")
			Failure("Stub return value not specified for sizeFor(sequentials: [CourseSequential]). Use given")
		}
		return __value
    }

    open func cancelDownloading(task: DownloadDataTask) throws {
        addInvocation(.m_cancelDownloading__task_task(Parameter<DownloadDataTask>.value(`task`)))
		let perform = methodPerformValue(.m_cancelDownloading__task_task(Parameter<DownloadDataTask>.value(`task`))) as? (DownloadDataTask) -> Void
		perform?(`task`)
		do {
		    _ = try methodReturnValue(.m_cancelDownloading__task_task(Parameter<DownloadDataTask>.value(`task`))).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }


    fileprivate enum MethodType {
        case m_publisher
        case m_progressPublisher
        case m_refreshValue
        case m_sizeFor__block_block(Parameter<CourseBlock>)
        case m_sizeFor__blocks_blocks(Parameter<[CourseBlock]>)
        case m_sizeFor__sequential_sequential(Parameter<CourseSequential>)
        case m_sizeFor__sequentials_sequentials(Parameter<[CourseSequential]>)
        case m_cancelDownloading__task_task(Parameter<DownloadDataTask>)
        case p_value_get
        case p_courseStructure_get
		case p_courseStructure_set(Parameter<CourseStructure?>)
        case p_videoQuality_get
		case p_videoQuality_set(Parameter<DownloadQuality>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_publisher, .m_publisher): return .match

            case (.m_progressPublisher, .m_progressPublisher): return .match

            case (.m_refreshValue, .m_refreshValue): return .match

            case (.m_sizeFor__block_block(let lhsBlock), .m_sizeFor__block_block(let rhsBlock)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlock, rhs: rhsBlock, with: matcher), lhsBlock, rhsBlock, "block"))
				return Matcher.ComparisonResult(results)

            case (.m_sizeFor__blocks_blocks(let lhsBlocks), .m_sizeFor__blocks_blocks(let rhsBlocks)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlocks, rhs: rhsBlocks, with: matcher), lhsBlocks, rhsBlocks, "blocks"))
				return Matcher.ComparisonResult(results)

            case (.m_sizeFor__sequential_sequential(let lhsSequential), .m_sizeFor__sequential_sequential(let rhsSequential)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsSequential, rhs: rhsSequential, with: matcher), lhsSequential, rhsSequential, "sequential"))
				return Matcher.ComparisonResult(results)

            case (.m_sizeFor__sequentials_sequentials(let lhsSequentials), .m_sizeFor__sequentials_sequentials(let rhsSequentials)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsSequentials, rhs: rhsSequentials, with: matcher), lhsSequentials, rhsSequentials, "sequentials"))
				return Matcher.ComparisonResult(results)

            case (.m_cancelDownloading__task_task(let lhsTask), .m_cancelDownloading__task_task(let rhsTask)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsTask, rhs: rhsTask, with: matcher), lhsTask, rhsTask, "task"))
				return Matcher.ComparisonResult(results)
            case (.p_value_get,.p_value_get): return Matcher.ComparisonResult.match
            case (.p_courseStructure_get,.p_courseStructure_get): return Matcher.ComparisonResult.match
			case (.p_courseStructure_set(let left),.p_courseStructure_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<CourseStructure?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_videoQuality_get,.p_videoQuality_get): return Matcher.ComparisonResult.match
			case (.p_videoQuality_set(let left),.p_videoQuality_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<DownloadQuality>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case .m_publisher: return 0
            case .m_progressPublisher: return 0
            case .m_refreshValue: return 0
            case let .m_sizeFor__block_block(p0): return p0.intValue
            case let .m_sizeFor__blocks_blocks(p0): return p0.intValue
            case let .m_sizeFor__sequential_sequential(p0): return p0.intValue
            case let .m_sizeFor__sequentials_sequentials(p0): return p0.intValue
            case let .m_cancelDownloading__task_task(p0): return p0.intValue
            case .p_value_get: return 0
            case .p_courseStructure_get: return 0
			case .p_courseStructure_set(let newValue): return newValue.intValue
            case .p_videoQuality_get: return 0
			case .p_videoQuality_set(let newValue): return newValue.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_publisher: return ".publisher()"
            case .m_progressPublisher: return ".progressPublisher()"
            case .m_refreshValue: return ".refreshValue()"
            case .m_sizeFor__block_block: return ".sizeFor(block:)"
            case .m_sizeFor__blocks_blocks: return ".sizeFor(blocks:)"
            case .m_sizeFor__sequential_sequential: return ".sizeFor(sequential:)"
            case .m_sizeFor__sequentials_sequentials: return ".sizeFor(sequentials:)"
            case .m_cancelDownloading__task_task: return ".cancelDownloading(task:)"
            case .p_value_get: return "[get] .value"
            case .p_courseStructure_get: return "[get] .courseStructure"
			case .p_courseStructure_set: return "[set] .courseStructure"
            case .p_videoQuality_get: return "[get] .videoQuality"
			case .p_videoQuality_set: return "[set] .videoQuality"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }

        public static func value(getter defaultValue: CourseDownloadValue?...) -> PropertyStub {
            return Given(method: .p_value_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func courseStructure(getter defaultValue: CourseStructure?...) -> PropertyStub {
            return Given(method: .p_courseStructure_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func videoQuality(getter defaultValue: DownloadQuality...) -> PropertyStub {
            return Given(method: .p_videoQuality_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }

        public static func publisher(willReturn: AnyPublisher<CourseDownloadValue, Never>...) -> MethodStub {
            return Given(method: .m_publisher, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func progressPublisher(willReturn: AnyPublisher<DownloadDataTask, Never>...) -> MethodStub {
            return Given(method: .m_progressPublisher, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func sizeFor(block: Parameter<CourseBlock>, willReturn: Int?...) -> MethodStub {
            return Given(method: .m_sizeFor__block_block(`block`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func sizeFor(blocks: Parameter<[CourseBlock]>, willReturn: Int...) -> MethodStub {
            return Given(method: .m_sizeFor__blocks_blocks(`blocks`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func sizeFor(sequential: Parameter<CourseSequential>, willReturn: Int...) -> MethodStub {
            return Given(method: .m_sizeFor__sequential_sequential(`sequential`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func sizeFor(sequentials: Parameter<[CourseSequential]>, willReturn: Int...) -> MethodStub {
            return Given(method: .m_sizeFor__sequentials_sequentials(`sequentials`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func publisher(willProduce: (Stubber<AnyPublisher<CourseDownloadValue, Never>>) -> Void) -> MethodStub {
            let willReturn: [AnyPublisher<CourseDownloadValue, Never>] = []
			let given: Given = { return Given(method: .m_publisher, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (AnyPublisher<CourseDownloadValue, Never>).self)
			willProduce(stubber)
			return given
        }
        public static func progressPublisher(willProduce: (Stubber<AnyPublisher<DownloadDataTask, Never>>) -> Void) -> MethodStub {
            let willReturn: [AnyPublisher<DownloadDataTask, Never>] = []
			let given: Given = { return Given(method: .m_progressPublisher, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (AnyPublisher<DownloadDataTask, Never>).self)
			willProduce(stubber)
			return given
        }
        public static func sizeFor(block: Parameter<CourseBlock>, willProduce: (Stubber<Int?>) -> Void) -> MethodStub {
            let willReturn: [Int?] = []
			let given: Given = { return Given(method: .m_sizeFor__block_block(`block`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Int?).self)
			willProduce(stubber)
			return given
        }
        public static func sizeFor(blocks: Parameter<[CourseBlock]>, willProduce: (Stubber<Int>) -> Void) -> MethodStub {
            let willReturn: [Int] = []
			let given: Given = { return Given(method: .m_sizeFor__blocks_blocks(`blocks`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Int).self)
			willProduce(stubber)
			return given
        }
        public static func sizeFor(sequential: Parameter<CourseSequential>, willProduce: (Stubber<Int>) -> Void) -> MethodStub {
            let willReturn: [Int] = []
			let given: Given = { return Given(method: .m_sizeFor__sequential_sequential(`sequential`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Int).self)
			willProduce(stubber)
			return given
        }
        public static func sizeFor(sequentials: Parameter<[CourseSequential]>, willProduce: (Stubber<Int>) -> Void) -> MethodStub {
            let willReturn: [Int] = []
			let given: Given = { return Given(method: .m_sizeFor__sequentials_sequentials(`sequentials`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Int).self)
			willProduce(stubber)
			return given
        }
        public static func cancelDownloading(task: Parameter<DownloadDataTask>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_cancelDownloading__task_task(`task`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func cancelDownloading(task: Parameter<DownloadDataTask>, willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_cancelDownloading__task_task(`task`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func publisher() -> Verify { return Verify(method: .m_publisher)}
        public static func progressPublisher() -> Verify { return Verify(method: .m_progressPublisher)}
        public static func refreshValue() -> Verify { return Verify(method: .m_refreshValue)}
        public static func sizeFor(block: Parameter<CourseBlock>) -> Verify { return Verify(method: .m_sizeFor__block_block(`block`))}
        public static func sizeFor(blocks: Parameter<[CourseBlock]>) -> Verify { return Verify(method: .m_sizeFor__blocks_blocks(`blocks`))}
        public static func sizeFor(sequential: Parameter<CourseSequential>) -> Verify { return Verify(method: .m_sizeFor__sequential_sequential(`sequential`))}
        public static func sizeFor(sequentials: Parameter<[CourseSequential]>) -> Verify { return Verify(method: .m_sizeFor__sequentials_sequentials(`sequentials`))}
        public static func cancelDownloading(task: Parameter<DownloadDataTask>) -> Verify { return Verify(method: .m_cancelDownloading__task_task(`task`))}
        public static var value: Verify { return Verify(method: .p_value_get) }
        public static var courseStructure: Verify { return Verify(method: .p_courseStructure_get) }
		public static func courseStructure(set newValue: Parameter<CourseStructure?>) -> Verify { return Verify(method: .p_courseStructure_set(newValue)) }
        public static var videoQuality: Verify { return Verify(method: .p_videoQuality_get) }
		public static func videoQuality(set newValue: Parameter<DownloadQuality>) -> Verify { return Verify(method: .p_videoQuality_set(newValue)) }
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func publisher(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_publisher, performs: perform)
        }
        public static func progressPublisher(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_progressPublisher, performs: perform)
        }
        public static func refreshValue(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_refreshValue, performs: perform)
        }
        public static func sizeFor(block: Parameter<CourseBlock>, perform: @escaping (CourseBlock) -> Void) -> Perform {
            return Perform(method: .m_sizeFor__block_block(`block`), performs: perform)
        }
        public static func sizeFor(blocks: Parameter<[CourseBlock]>, perform: @escaping ([CourseBlock]) -> Void) -> Perform {
            return Perform(method: .m_sizeFor__blocks_blocks(`blocks`), performs: perform)
        }
        public static func sizeFor(sequential: Parameter<CourseSequential>, perform: @escaping (CourseSequential) -> Void) -> Perform {
            return Perform(method: .m_sizeFor__sequential_sequential(`sequential`), performs: perform)
        }
        public static func sizeFor(sequentials: Parameter<[CourseSequential]>, perform: @escaping ([CourseSequential]) -> Void) -> Perform {
            return Perform(method: .m_sizeFor__sequentials_sequentials(`sequentials`), performs: perform)
        }
        public static func cancelDownloading(task: Parameter<DownloadDataTask>, perform: @escaping (DownloadDataTask) -> Void) -> Perform {
            return Perform(method: .m_cancelDownloading__task_task(`task`), performs: perform)
        }
    }

    public func given(_ method: Given) {
        methodReturnValues.append(method)
    }

    public func perform(_ method: Perform) {
        methodPerformValues.append(method)
        methodPerformValues.sort { $0.method.intValue() < $1.method.intValue() }
    }

    public func verify(_ method: Verify, count: Count = Count.moreOrEqual(to: 1), file: StaticString = #file, line: UInt = #line) {
        let fullMatches = matchingCalls(method, file: file, line: line)
        let success = count.matches(fullMatches)
        let assertionName = method.method.assertionName()
        let feedback: String = {
            guard !success else { return "" }
            return Utils.closestCallsMessage(
                for: self.invocations.map { invocation in
                    matcher.set(file: file, line: line)
                    defer { matcher.clearFileAndLine() }
                    return MethodType.compareParameters(lhs: invocation, rhs: method.method, matcher: matcher)
                },
                name: assertionName
            )
        }()
        MockyAssert(success, "Expected: \(count) invocations of `\(assertionName)`, but was: \(fullMatches).\(feedback)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        self.queue.sync { invocations.append(call) }
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType, file: StaticString?, line: UInt?) -> [MethodType] {
        matcher.set(file: file ?? self.file, line: line ?? self.line)
        defer { matcher.clearFileAndLine() }
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher).isFullMatch }
    }
    private func matchingCalls(_ method: Verify, file: StaticString?, line: UInt?) -> Int {
        return matchingCalls(method.method, file: file, line: line).count
    }
    private func givenGetterValue<T>(_ method: MethodType, _ message: String) -> T {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            onFatalFailure(message)
            Failure(message)
        }
    }
    private func optionalGivenGetterValue<T>(_ method: MethodType, _ message: String) -> T? {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            return nil
        }
    }
    private func onFatalFailure(_ message: String) {
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleFatalError(message: message, file: file, line: line)
    }
}

// MARK: - CourseInteractorProtocol

open class CourseInteractorProtocolMock: CourseInteractorProtocol, Mock {
    public init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
        SwiftyMockyTestObserver.setup()
        self.sequencingPolicy = sequencingPolicy
        self.stubbingPolicy = stubbingPolicy
        self.file = file
        self.line = line
    }

    var matcher: Matcher = Matcher.default
    var stubbingPolicy: StubbingPolicy = .wrap
    var sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst

    private var queue = DispatchQueue(label: "com.swiftymocky.invocations", qos: .userInteractive)
    private var invocations: [MethodType] = []
    private var methodReturnValues: [Given] = []
    private var methodPerformValues: [Perform] = []
    private var file: StaticString?
    private var line: UInt?

    public typealias PropertyStub = Given
    public typealias MethodStub = Given
    public typealias SubscriptStub = Given

    /// Convenience method - call setupMock() to extend debug information when failure occurs
    public func setupMock(file: StaticString = #file, line: UInt = #line) {
        self.file = file
        self.line = line
    }

    /// Clear mock internals. You can specify what to reset (invocations aka verify, givens or performs) or leave it empty to clear all mock internals
    public func resetMock(_ scopes: MockScope...) {
        let scopes: [MockScope] = scopes.isEmpty ? [.invocation, .given, .perform] : scopes
        if scopes.contains(.invocation) { invocations = [] }
        if scopes.contains(.given) { methodReturnValues = [] }
        if scopes.contains(.perform) { methodPerformValues = [] }
    }





    open func getCourseBlocks(courseID: String) throws -> CourseStructure {
        addInvocation(.m_getCourseBlocks__courseID_courseID(Parameter<String>.value(`courseID`)))
		let perform = methodPerformValue(.m_getCourseBlocks__courseID_courseID(Parameter<String>.value(`courseID`))) as? (String) -> Void
		perform?(`courseID`)
		var __value: CourseStructure
		do {
		    __value = try methodReturnValue(.m_getCourseBlocks__courseID_courseID(Parameter<String>.value(`courseID`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for getCourseBlocks(courseID: String). Use given")
			Failure("Stub return value not specified for getCourseBlocks(courseID: String). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func getCourseVideoBlocks(fullStructure: CourseStructure) -> CourseStructure {
        addInvocation(.m_getCourseVideoBlocks__fullStructure_fullStructure(Parameter<CourseStructure>.value(`fullStructure`)))
		let perform = methodPerformValue(.m_getCourseVideoBlocks__fullStructure_fullStructure(Parameter<CourseStructure>.value(`fullStructure`))) as? (CourseStructure) -> Void
		perform?(`fullStructure`)
		var __value: CourseStructure
		do {
		    __value = try methodReturnValue(.m_getCourseVideoBlocks__fullStructure_fullStructure(Parameter<CourseStructure>.value(`fullStructure`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for getCourseVideoBlocks(fullStructure: CourseStructure). Use given")
			Failure("Stub return value not specified for getCourseVideoBlocks(fullStructure: CourseStructure). Use given")
		}
		return __value
    }

    open func getCourseAssignmentBlocks(fullStructure: CourseStructure) -> CourseStructure {
        addInvocation(.m_getCourseAssignmentBlocks__fullStructure_fullStructure(Parameter<CourseStructure>.value(`fullStructure`)))
		let perform = methodPerformValue(.m_getCourseAssignmentBlocks__fullStructure_fullStructure(Parameter<CourseStructure>.value(`fullStructure`))) as? (CourseStructure) -> Void
		perform?(`fullStructure`)
		var __value: CourseStructure
		do {
		    __value = try methodReturnValue(.m_getCourseAssignmentBlocks__fullStructure_fullStructure(Parameter<CourseStructure>.value(`fullStructure`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for getCourseAssignmentBlocks(fullStructure: CourseStructure). Use given")
			Failure("Stub return value not specified for getCourseAssignmentBlocks(fullStructure: CourseStructure). Use given")
		}
		return __value
    }

    open func getLoadedCourseBlocks(courseID: String) throws -> CourseStructure {
        addInvocation(.m_getLoadedCourseBlocks__courseID_courseID(Parameter<String>.value(`courseID`)))
		let perform = methodPerformValue(.m_getLoadedCourseBlocks__courseID_courseID(Parameter<String>.value(`courseID`))) as? (String) -> Void
		perform?(`courseID`)
		var __value: CourseStructure
		do {
		    __value = try methodReturnValue(.m_getLoadedCourseBlocks__courseID_courseID(Parameter<String>.value(`courseID`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for getLoadedCourseBlocks(courseID: String). Use given")
			Failure("Stub return value not specified for getLoadedCourseBlocks(courseID: String). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func getSequentialsContainsBlocks(blockIds: [String], courseID: String) throws -> [CourseSequential] {
        addInvocation(.m_getSequentialsContainsBlocks__blockIds_blockIdscourseID_courseID(Parameter<[String]>.value(`blockIds`), Parameter<String>.value(`courseID`)))
		let perform = methodPerformValue(.m_getSequentialsContainsBlocks__blockIds_blockIdscourseID_courseID(Parameter<[String]>.value(`blockIds`), Parameter<String>.value(`courseID`))) as? ([String], String) -> Void
		perform?(`blockIds`, `courseID`)
		var __value: [CourseSequential]
		do {
		    __value = try methodReturnValue(.m_getSequentialsContainsBlocks__blockIds_blockIdscourseID_courseID(Parameter<[String]>.value(`blockIds`), Parameter<String>.value(`courseID`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for getSequentialsContainsBlocks(blockIds: [String], courseID: String). Use given")
			Failure("Stub return value not specified for getSequentialsContainsBlocks(blockIds: [String], courseID: String). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func blockCompletionRequest(courseID: String, blockID: String) throws {
        addInvocation(.m_blockCompletionRequest__courseID_courseIDblockID_blockID(Parameter<String>.value(`courseID`), Parameter<String>.value(`blockID`)))
		let perform = methodPerformValue(.m_blockCompletionRequest__courseID_courseIDblockID_blockID(Parameter<String>.value(`courseID`), Parameter<String>.value(`blockID`))) as? (String, String) -> Void
		perform?(`courseID`, `blockID`)
		do {
		    _ = try methodReturnValue(.m_blockCompletionRequest__courseID_courseIDblockID_blockID(Parameter<String>.value(`courseID`), Parameter<String>.value(`blockID`))).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func getHandouts(courseID: String) throws -> String? {
        addInvocation(.m_getHandouts__courseID_courseID(Parameter<String>.value(`courseID`)))
		let perform = methodPerformValue(.m_getHandouts__courseID_courseID(Parameter<String>.value(`courseID`))) as? (String) -> Void
		perform?(`courseID`)
		var __value: String? = nil
		do {
		    __value = try methodReturnValue(.m_getHandouts__courseID_courseID(Parameter<String>.value(`courseID`))).casted()
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
		return __value
    }

    open func getUpdates(courseID: String) throws -> [CourseUpdate] {
        addInvocation(.m_getUpdates__courseID_courseID(Parameter<String>.value(`courseID`)))
		let perform = methodPerformValue(.m_getUpdates__courseID_courseID(Parameter<String>.value(`courseID`))) as? (String) -> Void
		perform?(`courseID`)
		var __value: [CourseUpdate]
		do {
		    __value = try methodReturnValue(.m_getUpdates__courseID_courseID(Parameter<String>.value(`courseID`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for getUpdates(courseID: String). Use given")
			Failure("Stub return value not specified for getUpdates(courseID: String). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func resumeBlock(courseID: String) throws -> ResumeBlock {
        addInvocation(.m_resumeBlock__courseID_courseID(Parameter<String>.value(`courseID`)))
		let perform = methodPerformValue(.m_resumeBlock__courseID_courseID(Parameter<String>.value(`courseID`))) as? (String) -> Void
		perform?(`courseID`)
		var __value: ResumeBlock
		do {
		    __value = try methodReturnValue(.m_resumeBlock__courseID_courseID(Parameter<String>.value(`courseID`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for resumeBlock(courseID: String). Use given")
			Failure("Stub return value not specified for resumeBlock(courseID: String). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func getSubtitles(url: String, selectedLanguage: String) throws -> [Subtitle] {
        addInvocation(.m_getSubtitles__url_urlselectedLanguage_selectedLanguage(Parameter<String>.value(`url`), Parameter<String>.value(`selectedLanguage`)))
		let perform = methodPerformValue(.m_getSubtitles__url_urlselectedLanguage_selectedLanguage(Parameter<String>.value(`url`), Parameter<String>.value(`selectedLanguage`))) as? (String, String) -> Void
		perform?(`url`, `selectedLanguage`)
		var __value: [Subtitle]
		do {
		    __value = try methodReturnValue(.m_getSubtitles__url_urlselectedLanguage_selectedLanguage(Parameter<String>.value(`url`), Parameter<String>.value(`selectedLanguage`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for getSubtitles(url: String, selectedLanguage: String). Use given")
			Failure("Stub return value not specified for getSubtitles(url: String, selectedLanguage: String). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func getCourseDates(courseID: String) throws -> CourseDates {
        addInvocation(.m_getCourseDates__courseID_courseID(Parameter<String>.value(`courseID`)))
		let perform = methodPerformValue(.m_getCourseDates__courseID_courseID(Parameter<String>.value(`courseID`))) as? (String) -> Void
		perform?(`courseID`)
		var __value: CourseDates
		do {
		    __value = try methodReturnValue(.m_getCourseDates__courseID_courseID(Parameter<String>.value(`courseID`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for getCourseDates(courseID: String). Use given")
			Failure("Stub return value not specified for getCourseDates(courseID: String). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func getCourseDeadlineInfo(courseID: String) throws -> CourseDateBanner {
        addInvocation(.m_getCourseDeadlineInfo__courseID_courseID(Parameter<String>.value(`courseID`)))
		let perform = methodPerformValue(.m_getCourseDeadlineInfo__courseID_courseID(Parameter<String>.value(`courseID`))) as? (String) -> Void
		perform?(`courseID`)
		var __value: CourseDateBanner
		do {
		    __value = try methodReturnValue(.m_getCourseDeadlineInfo__courseID_courseID(Parameter<String>.value(`courseID`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for getCourseDeadlineInfo(courseID: String). Use given")
			Failure("Stub return value not specified for getCourseDeadlineInfo(courseID: String). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func shiftDueDates(courseID: String) throws {
        addInvocation(.m_shiftDueDates__courseID_courseID(Parameter<String>.value(`courseID`)))
		let perform = methodPerformValue(.m_shiftDueDates__courseID_courseID(Parameter<String>.value(`courseID`))) as? (String) -> Void
		perform?(`courseID`)
		do {
		    _ = try methodReturnValue(.m_shiftDueDates__courseID_courseID(Parameter<String>.value(`courseID`))).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func updateLocalVideoProgress(blockID: String, progress: Double) {
        addInvocation(.m_updateLocalVideoProgress__blockID_blockIDprogress_progress(Parameter<String>.value(`blockID`), Parameter<Double>.value(`progress`)))
		let perform = methodPerformValue(.m_updateLocalVideoProgress__blockID_blockIDprogress_progress(Parameter<String>.value(`blockID`), Parameter<Double>.value(`progress`))) as? (String, Double) -> Void
		perform?(`blockID`, `progress`)
    }

    open func loadLocalVideoProgress(blockID: String) -> Double? {
        addInvocation(.m_loadLocalVideoProgress__blockID_blockID(Parameter<String>.value(`blockID`)))
		let perform = methodPerformValue(.m_loadLocalVideoProgress__blockID_blockID(Parameter<String>.value(`blockID`))) as? (String) -> Void
		perform?(`blockID`)
		var __value: Double? = nil
		do {
		    __value = try methodReturnValue(.m_loadLocalVideoProgress__blockID_blockID(Parameter<String>.value(`blockID`))).casted()
		} catch {
			// do nothing
		}
		return __value
    }

    open func enrichCourseStructureWithLocalProgress(_ structure: CourseStructure) -> CourseStructure {
        addInvocation(.m_enrichCourseStructureWithLocalProgress__structure(Parameter<CourseStructure>.value(`structure`)))
		let perform = methodPerformValue(.m_enrichCourseStructureWithLocalProgress__structure(Parameter<CourseStructure>.value(`structure`))) as? (CourseStructure) -> Void
		perform?(`structure`)
		var __value: CourseStructure
		do {
		    __value = try methodReturnValue(.m_enrichCourseStructureWithLocalProgress__structure(Parameter<CourseStructure>.value(`structure`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for enrichCourseStructureWithLocalProgress(_ structure: CourseStructure). Use given")
			Failure("Stub return value not specified for enrichCourseStructureWithLocalProgress(_ structure: CourseStructure). Use given")
		}
		return __value
    }

    open func getCourseProgress(courseID: String) throws -> CourseProgressDetails {
        addInvocation(.m_getCourseProgress__courseID_courseID(Parameter<String>.value(`courseID`)))
		let perform = methodPerformValue(.m_getCourseProgress__courseID_courseID(Parameter<String>.value(`courseID`))) as? (String) -> Void
		perform?(`courseID`)
		var __value: CourseProgressDetails
		do {
		    __value = try methodReturnValue(.m_getCourseProgress__courseID_courseID(Parameter<String>.value(`courseID`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for getCourseProgress(courseID: String). Use given")
			Failure("Stub return value not specified for getCourseProgress(courseID: String). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func getCourseProgressOffline(courseID: String) throws -> CourseProgressDetails {
        addInvocation(.m_getCourseProgressOffline__courseID_courseID(Parameter<String>.value(`courseID`)))
		let perform = methodPerformValue(.m_getCourseProgressOffline__courseID_courseID(Parameter<String>.value(`courseID`))) as? (String) -> Void
		perform?(`courseID`)
		var __value: CourseProgressDetails
		do {
		    __value = try methodReturnValue(.m_getCourseProgressOffline__courseID_courseID(Parameter<String>.value(`courseID`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for getCourseProgressOffline(courseID: String). Use given")
			Failure("Stub return value not specified for getCourseProgressOffline(courseID: String). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func getAllVideosForNavigation(structure course: CourseStructure) throws -> [CourseBlock] {
        addInvocation(.m_getAllVideosForNavigation__structure_course(Parameter<CourseStructure>.value(`course`)))
		let perform = methodPerformValue(.m_getAllVideosForNavigation__structure_course(Parameter<CourseStructure>.value(`course`))) as? (CourseStructure) -> Void
		perform?(`course`)
		var __value: [CourseBlock]
		do {
		    __value = try methodReturnValue(.m_getAllVideosForNavigation__structure_course(Parameter<CourseStructure>.value(`course`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for getAllVideosForNavigation(structure course: CourseStructure). Use given")
			Failure("Stub return value not specified for getAllVideosForNavigation(structure course: CourseStructure). Use given")
		} catch {
		    throw error
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_getCourseBlocks__courseID_courseID(Parameter<String>)
        case m_getCourseVideoBlocks__fullStructure_fullStructure(Parameter<CourseStructure>)
        case m_getCourseAssignmentBlocks__fullStructure_fullStructure(Parameter<CourseStructure>)
        case m_getLoadedCourseBlocks__courseID_courseID(Parameter<String>)
        case m_getSequentialsContainsBlocks__blockIds_blockIdscourseID_courseID(Parameter<[String]>, Parameter<String>)
        case m_blockCompletionRequest__courseID_courseIDblockID_blockID(Parameter<String>, Parameter<String>)
        case m_getHandouts__courseID_courseID(Parameter<String>)
        case m_getUpdates__courseID_courseID(Parameter<String>)
        case m_resumeBlock__courseID_courseID(Parameter<String>)
        case m_getSubtitles__url_urlselectedLanguage_selectedLanguage(Parameter<String>, Parameter<String>)
        case m_getCourseDates__courseID_courseID(Parameter<String>)
        case m_getCourseDeadlineInfo__courseID_courseID(Parameter<String>)
        case m_shiftDueDates__courseID_courseID(Parameter<String>)
        case m_updateLocalVideoProgress__blockID_blockIDprogress_progress(Parameter<String>, Parameter<Double>)
        case m_loadLocalVideoProgress__blockID_blockID(Parameter<String>)
        case m_enrichCourseStructureWithLocalProgress__structure(Parameter<CourseStructure>)
        case m_getCourseProgress__courseID_courseID(Parameter<String>)
        case m_getCourseProgressOffline__courseID_courseID(Parameter<String>)
        case m_getAllVideosForNavigation__structure_course(Parameter<CourseStructure>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_getCourseBlocks__courseID_courseID(let lhsCourseid), .m_getCourseBlocks__courseID_courseID(let rhsCourseid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				return Matcher.ComparisonResult(results)

            case (.m_getCourseVideoBlocks__fullStructure_fullStructure(let lhsFullstructure), .m_getCourseVideoBlocks__fullStructure_fullStructure(let rhsFullstructure)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsFullstructure, rhs: rhsFullstructure, with: matcher), lhsFullstructure, rhsFullstructure, "fullStructure"))
				return Matcher.ComparisonResult(results)

            case (.m_getCourseAssignmentBlocks__fullStructure_fullStructure(let lhsFullstructure), .m_getCourseAssignmentBlocks__fullStructure_fullStructure(let rhsFullstructure)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsFullstructure, rhs: rhsFullstructure, with: matcher), lhsFullstructure, rhsFullstructure, "fullStructure"))
				return Matcher.ComparisonResult(results)

            case (.m_getLoadedCourseBlocks__courseID_courseID(let lhsCourseid), .m_getLoadedCourseBlocks__courseID_courseID(let rhsCourseid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				return Matcher.ComparisonResult(results)

            case (.m_getSequentialsContainsBlocks__blockIds_blockIdscourseID_courseID(let lhsBlockids, let lhsCourseid), .m_getSequentialsContainsBlocks__blockIds_blockIdscourseID_courseID(let rhsBlockids, let rhsCourseid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlockids, rhs: rhsBlockids, with: matcher), lhsBlockids, rhsBlockids, "blockIds"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				return Matcher.ComparisonResult(results)

            case (.m_blockCompletionRequest__courseID_courseIDblockID_blockID(let lhsCourseid, let lhsBlockid), .m_blockCompletionRequest__courseID_courseIDblockID_blockID(let rhsCourseid, let rhsBlockid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlockid, rhs: rhsBlockid, with: matcher), lhsBlockid, rhsBlockid, "blockID"))
				return Matcher.ComparisonResult(results)

            case (.m_getHandouts__courseID_courseID(let lhsCourseid), .m_getHandouts__courseID_courseID(let rhsCourseid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				return Matcher.ComparisonResult(results)

            case (.m_getUpdates__courseID_courseID(let lhsCourseid), .m_getUpdates__courseID_courseID(let rhsCourseid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				return Matcher.ComparisonResult(results)

            case (.m_resumeBlock__courseID_courseID(let lhsCourseid), .m_resumeBlock__courseID_courseID(let rhsCourseid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				return Matcher.ComparisonResult(results)

            case (.m_getSubtitles__url_urlselectedLanguage_selectedLanguage(let lhsUrl, let lhsSelectedlanguage), .m_getSubtitles__url_urlselectedLanguage_selectedLanguage(let rhsUrl, let rhsSelectedlanguage)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsUrl, rhs: rhsUrl, with: matcher), lhsUrl, rhsUrl, "url"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsSelectedlanguage, rhs: rhsSelectedlanguage, with: matcher), lhsSelectedlanguage, rhsSelectedlanguage, "selectedLanguage"))
				return Matcher.ComparisonResult(results)

            case (.m_getCourseDates__courseID_courseID(let lhsCourseid), .m_getCourseDates__courseID_courseID(let rhsCourseid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				return Matcher.ComparisonResult(results)

            case (.m_getCourseDeadlineInfo__courseID_courseID(let lhsCourseid), .m_getCourseDeadlineInfo__courseID_courseID(let rhsCourseid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				return Matcher.ComparisonResult(results)

            case (.m_shiftDueDates__courseID_courseID(let lhsCourseid), .m_shiftDueDates__courseID_courseID(let rhsCourseid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				return Matcher.ComparisonResult(results)

            case (.m_updateLocalVideoProgress__blockID_blockIDprogress_progress(let lhsBlockid, let lhsProgress), .m_updateLocalVideoProgress__blockID_blockIDprogress_progress(let rhsBlockid, let rhsProgress)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlockid, rhs: rhsBlockid, with: matcher), lhsBlockid, rhsBlockid, "blockID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsProgress, rhs: rhsProgress, with: matcher), lhsProgress, rhsProgress, "progress"))
				return Matcher.ComparisonResult(results)

            case (.m_loadLocalVideoProgress__blockID_blockID(let lhsBlockid), .m_loadLocalVideoProgress__blockID_blockID(let rhsBlockid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlockid, rhs: rhsBlockid, with: matcher), lhsBlockid, rhsBlockid, "blockID"))
				return Matcher.ComparisonResult(results)

            case (.m_enrichCourseStructureWithLocalProgress__structure(let lhsStructure), .m_enrichCourseStructureWithLocalProgress__structure(let rhsStructure)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsStructure, rhs: rhsStructure, with: matcher), lhsStructure, rhsStructure, "_ structure"))
				return Matcher.ComparisonResult(results)

            case (.m_getCourseProgress__courseID_courseID(let lhsCourseid), .m_getCourseProgress__courseID_courseID(let rhsCourseid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				return Matcher.ComparisonResult(results)

            case (.m_getCourseProgressOffline__courseID_courseID(let lhsCourseid), .m_getCourseProgressOffline__courseID_courseID(let rhsCourseid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				return Matcher.ComparisonResult(results)

            case (.m_getAllVideosForNavigation__structure_course(let lhsCourse), .m_getAllVideosForNavigation__structure_course(let rhsCourse)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourse, rhs: rhsCourse, with: matcher), lhsCourse, rhsCourse, "structure course"))
				return Matcher.ComparisonResult(results)
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_getCourseBlocks__courseID_courseID(p0): return p0.intValue
            case let .m_getCourseVideoBlocks__fullStructure_fullStructure(p0): return p0.intValue
            case let .m_getCourseAssignmentBlocks__fullStructure_fullStructure(p0): return p0.intValue
            case let .m_getLoadedCourseBlocks__courseID_courseID(p0): return p0.intValue
            case let .m_getSequentialsContainsBlocks__blockIds_blockIdscourseID_courseID(p0, p1): return p0.intValue + p1.intValue
            case let .m_blockCompletionRequest__courseID_courseIDblockID_blockID(p0, p1): return p0.intValue + p1.intValue
            case let .m_getHandouts__courseID_courseID(p0): return p0.intValue
            case let .m_getUpdates__courseID_courseID(p0): return p0.intValue
            case let .m_resumeBlock__courseID_courseID(p0): return p0.intValue
            case let .m_getSubtitles__url_urlselectedLanguage_selectedLanguage(p0, p1): return p0.intValue + p1.intValue
            case let .m_getCourseDates__courseID_courseID(p0): return p0.intValue
            case let .m_getCourseDeadlineInfo__courseID_courseID(p0): return p0.intValue
            case let .m_shiftDueDates__courseID_courseID(p0): return p0.intValue
            case let .m_updateLocalVideoProgress__blockID_blockIDprogress_progress(p0, p1): return p0.intValue + p1.intValue
            case let .m_loadLocalVideoProgress__blockID_blockID(p0): return p0.intValue
            case let .m_enrichCourseStructureWithLocalProgress__structure(p0): return p0.intValue
            case let .m_getCourseProgress__courseID_courseID(p0): return p0.intValue
            case let .m_getCourseProgressOffline__courseID_courseID(p0): return p0.intValue
            case let .m_getAllVideosForNavigation__structure_course(p0): return p0.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_getCourseBlocks__courseID_courseID: return ".getCourseBlocks(courseID:)"
            case .m_getCourseVideoBlocks__fullStructure_fullStructure: return ".getCourseVideoBlocks(fullStructure:)"
            case .m_getCourseAssignmentBlocks__fullStructure_fullStructure: return ".getCourseAssignmentBlocks(fullStructure:)"
            case .m_getLoadedCourseBlocks__courseID_courseID: return ".getLoadedCourseBlocks(courseID:)"
            case .m_getSequentialsContainsBlocks__blockIds_blockIdscourseID_courseID: return ".getSequentialsContainsBlocks(blockIds:courseID:)"
            case .m_blockCompletionRequest__courseID_courseIDblockID_blockID: return ".blockCompletionRequest(courseID:blockID:)"
            case .m_getHandouts__courseID_courseID: return ".getHandouts(courseID:)"
            case .m_getUpdates__courseID_courseID: return ".getUpdates(courseID:)"
            case .m_resumeBlock__courseID_courseID: return ".resumeBlock(courseID:)"
            case .m_getSubtitles__url_urlselectedLanguage_selectedLanguage: return ".getSubtitles(url:selectedLanguage:)"
            case .m_getCourseDates__courseID_courseID: return ".getCourseDates(courseID:)"
            case .m_getCourseDeadlineInfo__courseID_courseID: return ".getCourseDeadlineInfo(courseID:)"
            case .m_shiftDueDates__courseID_courseID: return ".shiftDueDates(courseID:)"
            case .m_updateLocalVideoProgress__blockID_blockIDprogress_progress: return ".updateLocalVideoProgress(blockID:progress:)"
            case .m_loadLocalVideoProgress__blockID_blockID: return ".loadLocalVideoProgress(blockID:)"
            case .m_enrichCourseStructureWithLocalProgress__structure: return ".enrichCourseStructureWithLocalProgress(_:)"
            case .m_getCourseProgress__courseID_courseID: return ".getCourseProgress(courseID:)"
            case .m_getCourseProgressOffline__courseID_courseID: return ".getCourseProgressOffline(courseID:)"
            case .m_getAllVideosForNavigation__structure_course: return ".getAllVideosForNavigation(structure:)"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func getCourseBlocks(courseID: Parameter<String>, willReturn: CourseStructure...) -> MethodStub {
            return Given(method: .m_getCourseBlocks__courseID_courseID(`courseID`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getCourseVideoBlocks(fullStructure: Parameter<CourseStructure>, willReturn: CourseStructure...) -> MethodStub {
            return Given(method: .m_getCourseVideoBlocks__fullStructure_fullStructure(`fullStructure`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getCourseAssignmentBlocks(fullStructure: Parameter<CourseStructure>, willReturn: CourseStructure...) -> MethodStub {
            return Given(method: .m_getCourseAssignmentBlocks__fullStructure_fullStructure(`fullStructure`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getLoadedCourseBlocks(courseID: Parameter<String>, willReturn: CourseStructure...) -> MethodStub {
            return Given(method: .m_getLoadedCourseBlocks__courseID_courseID(`courseID`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getSequentialsContainsBlocks(blockIds: Parameter<[String]>, courseID: Parameter<String>, willReturn: [CourseSequential]...) -> MethodStub {
            return Given(method: .m_getSequentialsContainsBlocks__blockIds_blockIdscourseID_courseID(`blockIds`, `courseID`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getHandouts(courseID: Parameter<String>, willReturn: String?...) -> MethodStub {
            return Given(method: .m_getHandouts__courseID_courseID(`courseID`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getUpdates(courseID: Parameter<String>, willReturn: [CourseUpdate]...) -> MethodStub {
            return Given(method: .m_getUpdates__courseID_courseID(`courseID`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func resumeBlock(courseID: Parameter<String>, willReturn: ResumeBlock...) -> MethodStub {
            return Given(method: .m_resumeBlock__courseID_courseID(`courseID`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getSubtitles(url: Parameter<String>, selectedLanguage: Parameter<String>, willReturn: [Subtitle]...) -> MethodStub {
            return Given(method: .m_getSubtitles__url_urlselectedLanguage_selectedLanguage(`url`, `selectedLanguage`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getCourseDates(courseID: Parameter<String>, willReturn: CourseDates...) -> MethodStub {
            return Given(method: .m_getCourseDates__courseID_courseID(`courseID`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getCourseDeadlineInfo(courseID: Parameter<String>, willReturn: CourseDateBanner...) -> MethodStub {
            return Given(method: .m_getCourseDeadlineInfo__courseID_courseID(`courseID`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func loadLocalVideoProgress(blockID: Parameter<String>, willReturn: Double?...) -> MethodStub {
            return Given(method: .m_loadLocalVideoProgress__blockID_blockID(`blockID`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func enrichCourseStructureWithLocalProgress(_ structure: Parameter<CourseStructure>, willReturn: CourseStructure...) -> MethodStub {
            return Given(method: .m_enrichCourseStructureWithLocalProgress__structure(`structure`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getCourseProgress(courseID: Parameter<String>, willReturn: CourseProgressDetails...) -> MethodStub {
            return Given(method: .m_getCourseProgress__courseID_courseID(`courseID`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getCourseProgressOffline(courseID: Parameter<String>, willReturn: CourseProgressDetails...) -> MethodStub {
            return Given(method: .m_getCourseProgressOffline__courseID_courseID(`courseID`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getAllVideosForNavigation(structure course: Parameter<CourseStructure>, willReturn: [CourseBlock]...) -> MethodStub {
            return Given(method: .m_getAllVideosForNavigation__structure_course(`course`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getCourseVideoBlocks(fullStructure: Parameter<CourseStructure>, willProduce: (Stubber<CourseStructure>) -> Void) -> MethodStub {
            let willReturn: [CourseStructure] = []
			let given: Given = { return Given(method: .m_getCourseVideoBlocks__fullStructure_fullStructure(`fullStructure`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (CourseStructure).self)
			willProduce(stubber)
			return given
        }
        public static func getCourseAssignmentBlocks(fullStructure: Parameter<CourseStructure>, willProduce: (Stubber<CourseStructure>) -> Void) -> MethodStub {
            let willReturn: [CourseStructure] = []
			let given: Given = { return Given(method: .m_getCourseAssignmentBlocks__fullStructure_fullStructure(`fullStructure`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (CourseStructure).self)
			willProduce(stubber)
			return given
        }
        public static func loadLocalVideoProgress(blockID: Parameter<String>, willProduce: (Stubber<Double?>) -> Void) -> MethodStub {
            let willReturn: [Double?] = []
			let given: Given = { return Given(method: .m_loadLocalVideoProgress__blockID_blockID(`blockID`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Double?).self)
			willProduce(stubber)
			return given
        }
        public static func enrichCourseStructureWithLocalProgress(_ structure: Parameter<CourseStructure>, willProduce: (Stubber<CourseStructure>) -> Void) -> MethodStub {
            let willReturn: [CourseStructure] = []
			let given: Given = { return Given(method: .m_enrichCourseStructureWithLocalProgress__structure(`structure`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (CourseStructure).self)
			willProduce(stubber)
			return given
        }
        public static func getCourseBlocks(courseID: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_getCourseBlocks__courseID_courseID(`courseID`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getCourseBlocks(courseID: Parameter<String>, willProduce: (StubberThrows<CourseStructure>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getCourseBlocks__courseID_courseID(`courseID`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (CourseStructure).self)
			willProduce(stubber)
			return given
        }
        public static func getLoadedCourseBlocks(courseID: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_getLoadedCourseBlocks__courseID_courseID(`courseID`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getLoadedCourseBlocks(courseID: Parameter<String>, willProduce: (StubberThrows<CourseStructure>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getLoadedCourseBlocks__courseID_courseID(`courseID`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (CourseStructure).self)
			willProduce(stubber)
			return given
        }
        public static func getSequentialsContainsBlocks(blockIds: Parameter<[String]>, courseID: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_getSequentialsContainsBlocks__blockIds_blockIdscourseID_courseID(`blockIds`, `courseID`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getSequentialsContainsBlocks(blockIds: Parameter<[String]>, courseID: Parameter<String>, willProduce: (StubberThrows<[CourseSequential]>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getSequentialsContainsBlocks__blockIds_blockIdscourseID_courseID(`blockIds`, `courseID`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: ([CourseSequential]).self)
			willProduce(stubber)
			return given
        }
        public static func blockCompletionRequest(courseID: Parameter<String>, blockID: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_blockCompletionRequest__courseID_courseIDblockID_blockID(`courseID`, `blockID`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func blockCompletionRequest(courseID: Parameter<String>, blockID: Parameter<String>, willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_blockCompletionRequest__courseID_courseIDblockID_blockID(`courseID`, `blockID`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
        public static func getHandouts(courseID: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_getHandouts__courseID_courseID(`courseID`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getHandouts(courseID: Parameter<String>, willProduce: (StubberThrows<String?>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getHandouts__courseID_courseID(`courseID`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (String?).self)
			willProduce(stubber)
			return given
        }
        public static func getUpdates(courseID: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_getUpdates__courseID_courseID(`courseID`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getUpdates(courseID: Parameter<String>, willProduce: (StubberThrows<[CourseUpdate]>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getUpdates__courseID_courseID(`courseID`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: ([CourseUpdate]).self)
			willProduce(stubber)
			return given
        }
        public static func resumeBlock(courseID: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_resumeBlock__courseID_courseID(`courseID`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func resumeBlock(courseID: Parameter<String>, willProduce: (StubberThrows<ResumeBlock>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_resumeBlock__courseID_courseID(`courseID`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (ResumeBlock).self)
			willProduce(stubber)
			return given
        }
        public static func getSubtitles(url: Parameter<String>, selectedLanguage: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_getSubtitles__url_urlselectedLanguage_selectedLanguage(`url`, `selectedLanguage`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getSubtitles(url: Parameter<String>, selectedLanguage: Parameter<String>, willProduce: (StubberThrows<[Subtitle]>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getSubtitles__url_urlselectedLanguage_selectedLanguage(`url`, `selectedLanguage`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: ([Subtitle]).self)
			willProduce(stubber)
			return given
        }
        public static func getCourseDates(courseID: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_getCourseDates__courseID_courseID(`courseID`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getCourseDates(courseID: Parameter<String>, willProduce: (StubberThrows<CourseDates>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getCourseDates__courseID_courseID(`courseID`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (CourseDates).self)
			willProduce(stubber)
			return given
        }
        public static func getCourseDeadlineInfo(courseID: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_getCourseDeadlineInfo__courseID_courseID(`courseID`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getCourseDeadlineInfo(courseID: Parameter<String>, willProduce: (StubberThrows<CourseDateBanner>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getCourseDeadlineInfo__courseID_courseID(`courseID`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (CourseDateBanner).self)
			willProduce(stubber)
			return given
        }
        public static func shiftDueDates(courseID: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_shiftDueDates__courseID_courseID(`courseID`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func shiftDueDates(courseID: Parameter<String>, willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_shiftDueDates__courseID_courseID(`courseID`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
        public static func getCourseProgress(courseID: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_getCourseProgress__courseID_courseID(`courseID`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getCourseProgress(courseID: Parameter<String>, willProduce: (StubberThrows<CourseProgressDetails>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getCourseProgress__courseID_courseID(`courseID`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (CourseProgressDetails).self)
			willProduce(stubber)
			return given
        }
        public static func getCourseProgressOffline(courseID: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_getCourseProgressOffline__courseID_courseID(`courseID`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getCourseProgressOffline(courseID: Parameter<String>, willProduce: (StubberThrows<CourseProgressDetails>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getCourseProgressOffline__courseID_courseID(`courseID`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (CourseProgressDetails).self)
			willProduce(stubber)
			return given
        }
        public static func getAllVideosForNavigation(structure course: Parameter<CourseStructure>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_getAllVideosForNavigation__structure_course(`course`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getAllVideosForNavigation(structure course: Parameter<CourseStructure>, willProduce: (StubberThrows<[CourseBlock]>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getAllVideosForNavigation__structure_course(`course`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: ([CourseBlock]).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func getCourseBlocks(courseID: Parameter<String>) -> Verify { return Verify(method: .m_getCourseBlocks__courseID_courseID(`courseID`))}
        public static func getCourseVideoBlocks(fullStructure: Parameter<CourseStructure>) -> Verify { return Verify(method: .m_getCourseVideoBlocks__fullStructure_fullStructure(`fullStructure`))}
        public static func getCourseAssignmentBlocks(fullStructure: Parameter<CourseStructure>) -> Verify { return Verify(method: .m_getCourseAssignmentBlocks__fullStructure_fullStructure(`fullStructure`))}
        public static func getLoadedCourseBlocks(courseID: Parameter<String>) -> Verify { return Verify(method: .m_getLoadedCourseBlocks__courseID_courseID(`courseID`))}
        public static func getSequentialsContainsBlocks(blockIds: Parameter<[String]>, courseID: Parameter<String>) -> Verify { return Verify(method: .m_getSequentialsContainsBlocks__blockIds_blockIdscourseID_courseID(`blockIds`, `courseID`))}
        public static func blockCompletionRequest(courseID: Parameter<String>, blockID: Parameter<String>) -> Verify { return Verify(method: .m_blockCompletionRequest__courseID_courseIDblockID_blockID(`courseID`, `blockID`))}
        public static func getHandouts(courseID: Parameter<String>) -> Verify { return Verify(method: .m_getHandouts__courseID_courseID(`courseID`))}
        public static func getUpdates(courseID: Parameter<String>) -> Verify { return Verify(method: .m_getUpdates__courseID_courseID(`courseID`))}
        public static func resumeBlock(courseID: Parameter<String>) -> Verify { return Verify(method: .m_resumeBlock__courseID_courseID(`courseID`))}
        public static func getSubtitles(url: Parameter<String>, selectedLanguage: Parameter<String>) -> Verify { return Verify(method: .m_getSubtitles__url_urlselectedLanguage_selectedLanguage(`url`, `selectedLanguage`))}
        public static func getCourseDates(courseID: Parameter<String>) -> Verify { return Verify(method: .m_getCourseDates__courseID_courseID(`courseID`))}
        public static func getCourseDeadlineInfo(courseID: Parameter<String>) -> Verify { return Verify(method: .m_getCourseDeadlineInfo__courseID_courseID(`courseID`))}
        public static func shiftDueDates(courseID: Parameter<String>) -> Verify { return Verify(method: .m_shiftDueDates__courseID_courseID(`courseID`))}
        public static func updateLocalVideoProgress(blockID: Parameter<String>, progress: Parameter<Double>) -> Verify { return Verify(method: .m_updateLocalVideoProgress__blockID_blockIDprogress_progress(`blockID`, `progress`))}
        public static func loadLocalVideoProgress(blockID: Parameter<String>) -> Verify { return Verify(method: .m_loadLocalVideoProgress__blockID_blockID(`blockID`))}
        public static func enrichCourseStructureWithLocalProgress(_ structure: Parameter<CourseStructure>) -> Verify { return Verify(method: .m_enrichCourseStructureWithLocalProgress__structure(`structure`))}
        public static func getCourseProgress(courseID: Parameter<String>) -> Verify { return Verify(method: .m_getCourseProgress__courseID_courseID(`courseID`))}
        public static func getCourseProgressOffline(courseID: Parameter<String>) -> Verify { return Verify(method: .m_getCourseProgressOffline__courseID_courseID(`courseID`))}
        public static func getAllVideosForNavigation(structure course: Parameter<CourseStructure>) -> Verify { return Verify(method: .m_getAllVideosForNavigation__structure_course(`course`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func getCourseBlocks(courseID: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_getCourseBlocks__courseID_courseID(`courseID`), performs: perform)
        }
        public static func getCourseVideoBlocks(fullStructure: Parameter<CourseStructure>, perform: @escaping (CourseStructure) -> Void) -> Perform {
            return Perform(method: .m_getCourseVideoBlocks__fullStructure_fullStructure(`fullStructure`), performs: perform)
        }
        public static func getCourseAssignmentBlocks(fullStructure: Parameter<CourseStructure>, perform: @escaping (CourseStructure) -> Void) -> Perform {
            return Perform(method: .m_getCourseAssignmentBlocks__fullStructure_fullStructure(`fullStructure`), performs: perform)
        }
        public static func getLoadedCourseBlocks(courseID: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_getLoadedCourseBlocks__courseID_courseID(`courseID`), performs: perform)
        }
        public static func getSequentialsContainsBlocks(blockIds: Parameter<[String]>, courseID: Parameter<String>, perform: @escaping ([String], String) -> Void) -> Perform {
            return Perform(method: .m_getSequentialsContainsBlocks__blockIds_blockIdscourseID_courseID(`blockIds`, `courseID`), performs: perform)
        }
        public static func blockCompletionRequest(courseID: Parameter<String>, blockID: Parameter<String>, perform: @escaping (String, String) -> Void) -> Perform {
            return Perform(method: .m_blockCompletionRequest__courseID_courseIDblockID_blockID(`courseID`, `blockID`), performs: perform)
        }
        public static func getHandouts(courseID: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_getHandouts__courseID_courseID(`courseID`), performs: perform)
        }
        public static func getUpdates(courseID: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_getUpdates__courseID_courseID(`courseID`), performs: perform)
        }
        public static func resumeBlock(courseID: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_resumeBlock__courseID_courseID(`courseID`), performs: perform)
        }
        public static func getSubtitles(url: Parameter<String>, selectedLanguage: Parameter<String>, perform: @escaping (String, String) -> Void) -> Perform {
            return Perform(method: .m_getSubtitles__url_urlselectedLanguage_selectedLanguage(`url`, `selectedLanguage`), performs: perform)
        }
        public static func getCourseDates(courseID: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_getCourseDates__courseID_courseID(`courseID`), performs: perform)
        }
        public static func getCourseDeadlineInfo(courseID: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_getCourseDeadlineInfo__courseID_courseID(`courseID`), performs: perform)
        }
        public static func shiftDueDates(courseID: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_shiftDueDates__courseID_courseID(`courseID`), performs: perform)
        }
        public static func updateLocalVideoProgress(blockID: Parameter<String>, progress: Parameter<Double>, perform: @escaping (String, Double) -> Void) -> Perform {
            return Perform(method: .m_updateLocalVideoProgress__blockID_blockIDprogress_progress(`blockID`, `progress`), performs: perform)
        }
        public static func loadLocalVideoProgress(blockID: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_loadLocalVideoProgress__blockID_blockID(`blockID`), performs: perform)
        }
        public static func enrichCourseStructureWithLocalProgress(_ structure: Parameter<CourseStructure>, perform: @escaping (CourseStructure) -> Void) -> Perform {
            return Perform(method: .m_enrichCourseStructureWithLocalProgress__structure(`structure`), performs: perform)
        }
        public static func getCourseProgress(courseID: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_getCourseProgress__courseID_courseID(`courseID`), performs: perform)
        }
        public static func getCourseProgressOffline(courseID: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_getCourseProgressOffline__courseID_courseID(`courseID`), performs: perform)
        }
        public static func getAllVideosForNavigation(structure course: Parameter<CourseStructure>, perform: @escaping (CourseStructure) -> Void) -> Perform {
            return Perform(method: .m_getAllVideosForNavigation__structure_course(`course`), performs: perform)
        }
    }

    public func given(_ method: Given) {
        methodReturnValues.append(method)
    }

    public func perform(_ method: Perform) {
        methodPerformValues.append(method)
        methodPerformValues.sort { $0.method.intValue() < $1.method.intValue() }
    }

    public func verify(_ method: Verify, count: Count = Count.moreOrEqual(to: 1), file: StaticString = #file, line: UInt = #line) {
        let fullMatches = matchingCalls(method, file: file, line: line)
        let success = count.matches(fullMatches)
        let assertionName = method.method.assertionName()
        let feedback: String = {
            guard !success else { return "" }
            return Utils.closestCallsMessage(
                for: self.invocations.map { invocation in
                    matcher.set(file: file, line: line)
                    defer { matcher.clearFileAndLine() }
                    return MethodType.compareParameters(lhs: invocation, rhs: method.method, matcher: matcher)
                },
                name: assertionName
            )
        }()
        MockyAssert(success, "Expected: \(count) invocations of `\(assertionName)`, but was: \(fullMatches).\(feedback)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        self.queue.sync { invocations.append(call) }
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType, file: StaticString?, line: UInt?) -> [MethodType] {
        matcher.set(file: file ?? self.file, line: line ?? self.line)
        defer { matcher.clearFileAndLine() }
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher).isFullMatch }
    }
    private func matchingCalls(_ method: Verify, file: StaticString?, line: UInt?) -> Int {
        return matchingCalls(method.method, file: file, line: line).count
    }
    private func givenGetterValue<T>(_ method: MethodType, _ message: String) -> T {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            onFatalFailure(message)
            Failure(message)
        }
    }
    private func optionalGivenGetterValue<T>(_ method: MethodType, _ message: String) -> T? {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            return nil
        }
    }
    private func onFatalFailure(_ message: String) {
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleFatalError(message: message, file: file, line: line)
    }
}


//
//  CourseAnalytics.swift
//  Course
//
//  Created by  Stepanok Ivan on 29.06.2023.
//

import Foundation
import Core
import OEXFoundation

public enum EnrollmentMode: String {
    case audit
    case verified
    case none
}

public enum CoursePacing: String {
    case `self` = "self"
    case instructor = "instructor"
}

public enum CalendarDialogueAction: String {
    case on = "on"
    case off = "off"
    case allow = "allow"
    case doNotAllow = "donot_allow"
    case add = "add"
    case cancel = "cancel"
    case remove = "remove"
    case update = "update"
    case done = "done"
    case viewEvent = "view_event"
}

public enum CalendarDialogueType: String {
    case devicePermission = "device_permission"
    case addCalendar = "add_calendar"
    case removeCalendar = "remove_calendar"
    case updateCalendar = "update_calendar"
    case eventsAdded = "events_added"
}

public enum SnackbarType: String {
    case added
    case removed
    case updated
}

//sourcery: AutoMockable
public protocol CourseAnalytics {
    func resumeCourseClicked(courseId: String, courseName: String, blockId: String)
    func sequentialClicked(courseId: String, courseName: String, blockId: String, blockName: String)
    func verticalClicked(courseId: String, courseName: String, blockId: String, blockName: String)
    func nextBlockClicked(courseId: String, courseName: String, blockId: String, blockName: String)
    func prevBlockClicked(courseId: String, courseName: String, blockId: String, blockName: String)
    func finishVerticalClicked(courseId: String, courseName: String, blockId: String, blockName: String)
    func finishVerticalNextSectionClicked(courseId: String, courseName: String, blockId: String, blockName: String)
    func finishVerticalBackToOutlineClicked(courseId: String, courseName: String)
    func courseOutlineCourseTabClicked(courseId: String, courseName: String)
    func courseOutlineVideosTabClicked(courseId: String, courseName: String)
    func courseOutlineOfflineTabClicked(courseId: String, courseName: String)
    func courseOutlineDatesTabClicked(courseId: String, courseName: String)
    func courseOutlineDiscussionTabClicked(courseId: String, courseName: String)
    func courseOutlineHandoutsTabClicked(courseId: String, courseName: String)
    func datesComponentTapped(
        courseId: String,
        blockId: String,
        link: String,
        supported: Bool
    )
    func calendarSyncToggle(
        enrollmentMode: EnrollmentMode,
        pacing: CoursePacing,
        courseId: String,
        action: CalendarDialogueAction
    )
    func calendarSyncDialogAction(
        enrollmentMode: EnrollmentMode,
        pacing: CoursePacing,
        courseId: String,
        dialog: CalendarDialogueType,
        action: CalendarDialogueAction
    )
    func calendarSyncSnackbar(
        enrollmentMode: EnrollmentMode,
        pacing: CoursePacing,
        courseId: String,
        snackbar: SnackbarType
    )
    func trackCourseEvent(_ event: AnalyticsEvent, biValue: EventBIValue, courseID: String)
    func trackCourseScreenEvent(_ event: AnalyticsEvent, biValue: EventBIValue, courseID: String)
    
    func plsEvent(
        _ event: AnalyticsEvent,
        bivalue: EventBIValue,
        courseID: String,
        screenName: String,
        type: String
    )
    
    func plsSuccessEvent(
        _ event: AnalyticsEvent,
        bivalue: EventBIValue,
        courseID: String,
        screenName: String,
        type: String,
        success: Bool
    )
    
    func bulkDownloadVideosToggle(courseID: String, action: Bool)
    func bulkDownloadVideosSubsection(
        courseID: String,
        sectionID: String,
        subSectionID: String,
        videos: Int
    )
    func bulkDeleteVideosSubsection(
        courseID: String,
        subSectionID: String,
        videos: Int
    )
    
    func bulkDownloadVideosSection(
        courseID: String,
        sectionID: String,
        videos: Int
    )
    
    func bulkDeleteVideosSection(
        courseID: String,
        sectionId: String,
        videos: Int
    )
}

#if DEBUG
class CourseAnalyticsMock: CourseAnalytics {
    public func resumeCourseClicked(courseId: String, courseName: String, blockId: String) {}
    public func sequentialClicked(courseId: String, courseName: String, blockId: String, blockName: String) {}
    public func verticalClicked(courseId: String, courseName: String, blockId: String, blockName: String) {}
    public func nextBlockClicked(courseId: String, courseName: String, blockId: String, blockName: String) {}
    public func prevBlockClicked(courseId: String, courseName: String, blockId: String, blockName: String) {}
    public func finishVerticalClicked(courseId: String, courseName: String, blockId: String, blockName: String) {}
    public func finishVerticalNextSectionClicked(
        courseId: String,
        courseName: String,
        blockId: String,
        blockName: String
    ) {}
    public func finishVerticalBackToOutlineClicked(courseId: String, courseName: String) {}
    public func courseOutlineCourseTabClicked(courseId: String, courseName: String) {}
    public func courseOutlineVideosTabClicked(courseId: String, courseName: String) {}
    public func courseOutlineOfflineTabClicked(courseId: String, courseName: String) {}
    public func courseOutlineDatesTabClicked(courseId: String, courseName: String) {}
    public func courseOutlineDiscussionTabClicked(courseId: String, courseName: String) {}
    public func courseOutlineHandoutsTabClicked(courseId: String, courseName: String) {}
    public func datesComponentTapped(
        courseId: String,
        blockId: String,
        link: String,
        supported: Bool
    ) {}
    func calendarSyncToggle(
        enrollmentMode: EnrollmentMode,
        pacing: CoursePacing,
        courseId: String,
        action: CalendarDialogueAction
    ) {}
    func calendarSyncDialogAction(
        enrollmentMode: EnrollmentMode,
        pacing: CoursePacing,
        courseId: String,
        dialog: CalendarDialogueType,
        action: CalendarDialogueAction
    ) {}
    func calendarSyncSnackbar(
        enrollmentMode: EnrollmentMode,
        pacing: CoursePacing,
        courseId: String,
        snackbar: SnackbarType
    ) {}
    public func trackCourseEvent(_ event: AnalyticsEvent, biValue: EventBIValue, courseID: String) {}
    public func trackCourseScreenEvent(_ event: AnalyticsEvent, biValue: EventBIValue, courseID: String) {}
    public func plsEvent(
        _ event: AnalyticsEvent,
        bivalue: EventBIValue,
        courseID: String,
        screenName: String,
        type: String
    ) {}
    
    public func plsSuccessEvent(
        _ event: AnalyticsEvent,
        bivalue: EventBIValue,
        courseID: String,
        screenName: String,
        type: String,
        success: Bool
    ) {}
    public func bulkDownloadVideosToggle(courseID: String, action: Bool) {}
    public func bulkDownloadVideosSubsection(
        courseID: String,
        sectionID: String,
        subSectionID: String,
        videos: Int
    ) {}
    
    public func bulkDeleteVideosSubsection(
        courseID: String,
        subSectionID: String,
        videos: Int
    ) {}
    
    public func bulkDownloadVideosSection(
        courseID: String,
        sectionID: String,
        videos: Int
    ) {}
    
    public func bulkDeleteVideosSection(
        courseID: String,
        sectionId: String,
        videos: Int
    ) {}
}
#endif

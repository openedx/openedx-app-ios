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
    func courseOutlineContentTabClicked(courseId: String, courseName: String)
    func courseOutlineProgressTabClicked(courseId: String, courseName: String)
    func courseOutlineVideosTabClicked(courseId: String, courseName: String)
    func courseOutlineOfflineTabClicked(courseId: String, courseName: String)
    func courseOutlineDatesTabClicked(courseId: String, courseName: String)
    func courseOutlineDiscussionTabClicked(courseId: String, courseName: String)
    func courseOutlineHandoutsTabClicked(courseId: String, courseName: String)
    func courseOutlineAssignmentsTabClicked(courseId: String, courseName: String)
    func courseContentAllTabClicked(courseId: String, courseName: String)
    func courseContentVideosTabClicked(courseId: String, courseName: String)
    func courseContentAssignmentsTabClicked(courseId: String, courseName: String)
    func courseVideoClicked(courseId: String, courseName: String, blockId: String, blockName: String)
    func courseAssignmentClicked(courseId: String, courseName: String, blockId: String, blockName: String)
    func contentPageSectionClicked(courseId: String, courseName: String, blockId: String, blockName: String)
    func contentPageShowCompletedSubsectionClicked(courseId: String, courseName: String)
    func progressTabClicked(courseId: String, courseName: String)
    func courseHomeViewAllContentClicked(courseId: String, courseName: String)
    func courseHomeVideoClicked(courseId: String, courseName: String, blockId: String, blockName: String)
    func courseHomeViewAllVideosClicked(courseId: String, courseName: String)
    func courseHomeAssignmentClicked(courseId: String, courseName: String, blockId: String, blockName: String)
    func courseHomeViewAllAssignmentsClicked(courseId: String, courseName: String)
    func courseHomeGradesViewProgressClicked(courseId: String, courseName: String)
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
        videos: Int)
    
    func videoLoaded(courseID: String, blockID: String, videoURL: String)
    
    func videoPlayed(courseID: String, blockID: String, videoURL: String)
    
    func videoSpeedChange(
        courseID: String,
        blockID: String,
        videoURL: String,
        oldSpeed: Float,
        newSpeed: Float,
        currentTime: Double,
        duration: Double
    )
    
    func videoPaused(
        courseID: String,
        blockID: String,
        videoURL: String,
        currentTime: Double,
        duration: Double
    )
    
    func videoCompleted(
        courseID: String,
        blockID: String,
        videoURL: String,
        currentTime: Double,
        duration: Double
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
    public func courseOutlineContentTabClicked(courseId: String, courseName: String) {}
    public func courseOutlineProgressTabClicked(courseId: String, courseName: String) {}
    public func courseOutlineVideosTabClicked(courseId: String, courseName: String) {}
    public func courseOutlineOfflineTabClicked(courseId: String, courseName: String) {}
    public func courseOutlineDatesTabClicked(courseId: String, courseName: String) {}
    public func courseOutlineDiscussionTabClicked(courseId: String, courseName: String) {}
    public func courseOutlineHandoutsTabClicked(courseId: String, courseName: String) {}
    public func courseOutlineAssignmentsTabClicked(courseId: String, courseName: String) {}
    public func courseContentAllTabClicked(courseId: String, courseName: String) {}
    public func courseContentVideosTabClicked(courseId: String, courseName: String) {}
    public func courseContentAssignmentsTabClicked(courseId: String, courseName: String) {}
    public func courseVideoClicked(courseId: String, courseName: String, blockId: String, blockName: String) {}
    public func courseAssignmentClicked(courseId: String, courseName: String, blockId: String, blockName: String) {}
    public func contentPageSectionClicked(courseId: String, courseName: String, blockId: String, blockName: String) {}
    public func contentPageShowCompletedSubsectionClicked(courseId: String, courseName: String) {}
    public func progressTabClicked(courseId: String, courseName: String) {}
    public func courseHomeViewAllContentClicked(courseId: String, courseName: String) {}
    public func courseHomeVideoClicked(courseId: String, courseName: String, blockId: String, blockName: String) {}
    public func courseHomeViewAllVideosClicked(courseId: String, courseName: String) {}
    public func courseHomeAssignmentClicked(courseId: String, courseName: String, blockId: String, blockName: String) {}
    public func courseHomeViewAllAssignmentsClicked(courseId: String, courseName: String) {}
    public func courseHomeGradesViewProgressClicked(courseId: String, courseName: String) {}
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
        videos: Int) {}
    
    public func videoLoaded(courseID: String, blockID: String, videoURL: String) {}
    
    public func videoPlayed(courseID: String, blockID: String, videoURL: String) {}
    
    public func videoSpeedChange(
        courseID: String,
        blockID: String,
        videoURL: String,
        oldSpeed: Float,
        newSpeed: Float,
        currentTime: Double,
        duration: Double
    ) {}
    
    public func videoPaused(
        courseID: String,
        blockID: String,
        videoURL: String,
        currentTime: Double,
        duration: Double
    ) {}
    
    public func videoCompleted(
        courseID: String,
        blockID: String,
        videoURL: String,
        currentTime: Double,
        duration: Double
    ) {}
}
#endif

//
//  CourseAnalytics.swift
//  Course
//
//  Created by  Stepanok Ivan on 29.06.2023.
//

import Foundation

//sourcery: AutoMockable
public protocol CourseAnalytics {
    func resumeCourseTapped(courseId: String, courseName: String, blockId: String)
    func sequentialClicked(courseId: String, courseName: String, blockId: String, blockName: String)
    func verticalClicked(courseId: String, courseName: String, blockId: String, blockName: String)
    func nextBlockClicked(courseId: String, courseName: String, blockId: String, blockName: String)
    func prevBlockClicked(courseId: String, courseName: String, blockId: String, blockName: String)
    func finishVerticalClicked(courseId: String, courseName: String, blockId: String, blockName: String)
    func finishVerticalNextSectionClicked(courseId: String, courseName: String, blockId: String, blockName: String)
    func finishVerticalBackToOutlineClicked(courseId: String, courseName: String)
    func courseOutlineCourseTabClicked(courseId: String, courseName: String)
    func courseOutlineVideosTabClicked(courseId: String, courseName: String)
    func courseOutlineDatesTabClicked(courseId: String, courseName: String)
    func courseOutlineDiscussionTabClicked(courseId: String, courseName: String)
    func courseOutlineHandoutsTabClicked(courseId: String, courseName: String)
}

#if DEBUG
class CourseAnalyticsMock: CourseAnalytics {
    public func resumeCourseTapped(courseId: String, courseName: String, blockId: String) {}
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
    public func courseOutlineDatesTabClicked(courseId: String, courseName: String) {}
    public func courseOutlineDiscussionTabClicked(courseId: String, courseName: String) {}
    public func courseOutlineHandoutsTabClicked(courseId: String, courseName: String) {}
}
#endif

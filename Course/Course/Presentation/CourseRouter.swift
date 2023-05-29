//
//  CourseRouter.swift
//  Course
//
//  Created by  Stepanok Ivan on 16.11.2022.
//

import Foundation
import Core

public protocol CourseRouter: BaseRouter {
    
    func showCourseScreens(courseID: String,
                           isActive: Bool?,
                           courseStart: Date?,
                           courseEnd: Date?,
                           enrollmentStart: Date?,
                           enrollmentEnd: Date?,
                           title: String)
    
    func showCourseUnit(blockId: String,
                        courseID: String,
                        sectionName: String,
                        selectedVertical: Int,
                        verticals: [CourseVertical])
    
    func replaceCourseUnit(blockId: String,
                           courseID: String,
                           sectionName: String,
                           selectedVertical: Int,
                           verticals: [CourseVertical])
    
    func showCourseVerticalView(title: String,
                                verticals: [CourseVertical])
    
    func showHandoutsUpdatesView(handouts: String?,
                                 announcements: [CourseUpdate]?,
                                 router: Course.CourseRouter,
                                 cssInjector: CSSInjector)
}

// Mark - For testing and SwiftUI preview
#if DEBUG
public class CourseRouterMock: BaseRouterMock, CourseRouter {
    
    public override init() {}
    
    public func showCourseScreens(courseID: String,
                                  isActive: Bool?,
                                  courseStart: Date?,
                                  courseEnd: Date?,
                                  enrollmentStart: Date?,
                                  enrollmentEnd: Date?,
                                  title: String) {}
    
    public func showCourseUnit(blockId: String,
                               courseID: String,
                               sectionName: String,
                               selectedVertical: Int,
                               verticals: [CourseVertical]) {}
    
    public func replaceCourseUnit(blockId: String,
                           courseID: String,
                           sectionName: String,
                           selectedVertical: Int,
                           verticals: [CourseVertical]) {}
    
    public func showCourseVerticalView(title: String,
                                       verticals: [CourseVertical]) {}
    
    public func showHandoutsUpdatesView(handouts: String?,
                                        announcements: [CourseUpdate]?,
                                        router: Course.CourseRouter,
                                        cssInjector: CSSInjector) {}
    
}
#endif

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
                        blocks: [CourseBlock])
    
    func showCourseVerticalView(title: String,
                                verticals: [CourseVertical])
    
    func showCourseBlocksView(title: String,
                              blocks: [CourseBlock])
    
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
                               blocks: [CourseBlock]) {}
    
    public func showCourseVerticalView(title: String,
                                       verticals: [CourseVertical]) {}
    
    public func showCourseBlocksView(title: String,
                                     blocks: [CourseBlock]) {}
    
    public func showHandoutsUpdatesView(handouts: String?,
                                        announcements: [CourseUpdate]?,
                                        router: Course.CourseRouter,
                                        cssInjector: CSSInjector) {}
    
}
#endif

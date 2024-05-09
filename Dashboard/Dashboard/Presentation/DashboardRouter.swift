//
//  DashboardRouter.swift
//  Dashboard
//
//  Created by  Stepanok Ivan on 16.11.2022.
//

import Foundation
import Core

public protocol DashboardRouter: BaseRouter {
    
    func showCourseScreens(courseID: String,
                           isActive: Bool?,
                           courseStart: Date?,
                           courseEnd: Date?,
                           enrollmentStart: Date?,
                           enrollmentEnd: Date?,
                           title: String,
                           selection: CourseTab,
                           lastVisitedBlockID: String?)
    
    func showAllCourses(courses: [CourseItem])
    
    func showDiscoverySearch(searchQuery: String?)
    
}

// Mark - For testing and SwiftUI preview
#if DEBUG
public class DashboardRouterMock: BaseRouterMock, DashboardRouter {
    
    public override init() {}
    
    public func showCourseScreens(courseID: String,
                                  isActive: Bool?,
                                  courseStart: Date?,
                                  courseEnd: Date?,
                                  enrollmentStart: Date?,
                                  enrollmentEnd: Date?,
                                  title: String,
                                  selection: CourseTab,
                                  lastVisitedBlockID: String?) {}
    
    public func showAllCourses(courses: [CourseItem]) {}
    
    public func showDiscoverySearch(searchQuery: String?) {}
    
}
#endif

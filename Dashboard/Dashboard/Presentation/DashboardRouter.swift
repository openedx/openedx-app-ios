//
//  DashboardRouter.swift
//  Dashboard
//
//  Created by  Stepanok Ivan on 16.11.2022.
//

import Foundation
import Core

@MainActor
public protocol DashboardRouter: BaseRouter {
    
    func showCourseScreens(courseID: String,
                           hasAccess: Bool?,
                           courseStart: Date?,
                           courseEnd: Date?,
                           enrollmentStart: Date?,
                           enrollmentEnd: Date?,
                           title: String,
                           courseRawImage: String?,
                           showDates: Bool,
                           lastVisitedBlockID: String?)
    
    func showAllCourses(courses: [CourseItem])
    
    func showDiscoverySearch(searchQuery: String?)
    
    func showSettings()
    
    func showUpdateRecomendedView()
    
    func showUpdateRequiredView(showAccountLink: Bool)
}

// Mark - For testing and SwiftUI preview
#if DEBUG
public class DashboardRouterMock: BaseRouterMock, DashboardRouter {
    
    public override init() {}
    
    public func showCourseScreens(courseID: String,
                                  hasAccess: Bool?,
                                  courseStart: Date?,
                                  courseEnd: Date?,
                                  enrollmentStart: Date?,
                                  enrollmentEnd: Date?,
                                  title: String,
                                  courseRawImage: String?,
                                  showDates: Bool,
                                  lastVisitedBlockID: String?) {}
    
    public func showAllCourses(courses: [CourseItem]) {}
    
    public func showDiscoverySearch(searchQuery: String?) {}
    
    public func showSettings() {}
    
    public func showUpdateRecomendedView() {}
    
    public func showUpdateRequiredView(showAccountLink: Bool) {}

}
#endif

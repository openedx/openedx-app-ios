//
//  DiscoveryAnalytics.swift
//  Discovery
//
//  Created by  Stepanok Ivan on 29.06.2023.
//

import Foundation

//sourcery: AutoMockable
public protocol DiscoveryAnalytics {
    func discoverySearchBarClicked()
    func discoveryCoursesSearch(label: String, coursesCount: Int)
    func discoveryCourseClicked(courseID: String, courseName: String)
    func viewCourseClicked(courseId: String, courseName: String)
    func courseEnrollClicked(courseId: String, courseName: String)
    func courseEnrollSuccess(courseId: String, courseName: String)
}

#if DEBUG
class DiscoveryAnalyticsMock: DiscoveryAnalytics {
    public func discoverySearchBarClicked() {}
    public func discoveryCoursesSearch(label: String, coursesCount: Int) {}
    public func discoveryCourseClicked(courseID: String, courseName: String) {}
    public func viewCourseClicked(courseId: String, courseName: String) {}
    public func courseEnrollClicked(courseId: String, courseName: String) {}
    public func courseEnrollSuccess(courseId: String, courseName: String) {}
}
#endif

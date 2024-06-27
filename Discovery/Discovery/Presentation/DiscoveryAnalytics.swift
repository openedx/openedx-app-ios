//
//  DiscoveryAnalytics.swift
//  Discovery
//
//  Created by  Stepanok Ivan on 29.06.2023.
//

import Foundation
import Core

//sourcery: AutoMockable
public protocol DiscoveryAnalytics {
    func discoverySearchBarClicked()
    func discoveryCoursesSearch(label: String, coursesCount: Int)
    func discoveryCourseClicked(courseID: String, courseName: String)
    func viewCourseClicked(courseId: String, courseName: String)
    func courseEnrollClicked(courseId: String, courseName: String)
    func courseEnrollSuccess(courseId: String, courseName: String)
    func externalLinkOpen(url: String, screen: String)
    func externalLinkOpenAction(url: String, screen: String, action: String)
    func discoveryScreenEvent(event: AnalyticsEvent, biValue: EventBIValue)
}

#if DEBUG
class DiscoveryAnalyticsMock: DiscoveryAnalytics {
    public func discoverySearchBarClicked() {}
    public func discoveryCoursesSearch(label: String, coursesCount: Int) {}
    public func discoveryCourseClicked(courseID: String, courseName: String) {}
    public func viewCourseClicked(courseId: String, courseName: String) {}
    public func courseEnrollClicked(courseId: String, courseName: String) {}
    public func courseEnrollSuccess(courseId: String, courseName: String) {}
    public func externalLinkOpen(url: String, screen: String) {}
    public func externalLinkOpenAction(url: String, screen: String, action: String) {}
    public func discoveryScreenEvent(event: AnalyticsEvent, biValue: EventBIValue) {}
}
#endif

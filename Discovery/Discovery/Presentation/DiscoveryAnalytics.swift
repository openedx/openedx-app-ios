//
//  DiscoveryAnalytics.swift
//  Discovery
//
//  Created by  Stepanok Ivan on 29.06.2023.
//

import Foundation

public protocol DiscoveryAnalytics {
    func discoverySearchBarClicked()
    func discoveryCoursesSearch(label: String, coursesCount: Int)
    func discoveryCourseClicked(courseID: String, courseName: String)
}

#if DEBUG
class DiscoveryAnalyticsMock: DiscoveryAnalytics {
    public func discoverySearchBarClicked() {}
    public func discoveryCoursesSearch(label: String, coursesCount: Int) {}
    public func discoveryCourseClicked(courseID: String, courseName: String) {}
}
#endif

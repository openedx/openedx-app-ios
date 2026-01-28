//
//  AppDatesAnalytics.swift
//  AppDates
//
//  Created by Ivan Stepanok on 17.03.2025.
//

import Foundation

/// @mockable
public protocol AppDatesAnalytics: Sendable {
    func mainDatesScreenViewed()
    func datesCourseClicked(courseId: String, courseName: String)
    func datesSettingsClicked()
    func datesRefreshPulled()
}

#if DEBUG
public final class `AppDatesAnalyticsPreviewMock`: AppDatesAnalytics {
    public func mainDatesScreenViewed() {}
    public func datesCourseClicked(courseId: String, courseName: String) {}
    public func datesSettingsClicked() {}
    public func datesRefreshPulled() {}
}
#endif

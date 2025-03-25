//
//  AppDatesAnalytics.swift
//  AppDates
//
//  Created by Ivan Stepanok on 17.03.2025.
//

import Foundation

//sourcery: AutoMockable
public protocol AppDatesAnalytics {
    func datesScreenViewed()
    func datesCourseClicked(courseId: String, courseName: String)
    func datesSettingsClicked()
    func datesRefreshPulled()
}

#if DEBUG
class AppDatesAnalyticsMock: AppDatesAnalytics {
    public func datesScreenViewed() {}
    public func datesCourseClicked(courseId: String, courseName: String) {}
    public func datesSettingsClicked() {}
    public func datesRefreshPulled() {}
}
#endif

//
//  MainScreenAnalytics.swift
//  OpenEdX
//
//  Created by  Stepanok Ivan on 29.06.2023.
//

import Foundation

public protocol MainScreenAnalytics: Sendable {
    func mainDiscoveryTabClicked()
    func mainLearnTabClicked()
    func mainDownloadsTabClicked()
    func mainProfileTabClicked()
    func mainProgramsTabClicked()
    func mainCoursesClicked()
    func mainDatesScreenViewed()
    func mainProgramsClicked()
    func notificationPermissionStatus(status: String)
}

#if DEBUG
final public class MainScreenAnalyticsPreviewMock: MainScreenAnalytics {
    public func mainDiscoveryTabClicked() {}
    public func mainLearnTabClicked() {}
    public func mainDownloadsTabClicked() {}
    public func mainProfileTabClicked() {}
    public func mainProgramsTabClicked() {}
    public func mainDatesScreenViewed() {}
    public func mainProgramsClicked() {}
    public func mainCoursesClicked() {}
    public func notificationPermissionStatus(status: String) {}
}
#endif

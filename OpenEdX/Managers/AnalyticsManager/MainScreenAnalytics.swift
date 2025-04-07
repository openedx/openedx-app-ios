//
//  MainScreenAnalytics.swift
//  OpenEdX
//
//  Created by  Stepanok Ivan on 29.06.2023.
//

import Foundation

//sourcery: AutoMockable
public protocol MainScreenAnalytics: Sendable {
    func mainDiscoveryTabClicked()
    func mainLearnTabClicked()
    func mainDownloadsTabClicked()
    func mainProfileTabClicked()
    func mainProgramsTabClicked()
    func mainCoursesClicked()
    func mainProgramsClicked()
    func notificationPermissionStatus(status: String)
}

#if DEBUG
final public class MainScreenAnalyticsMock: MainScreenAnalytics {
    public func mainDiscoveryTabClicked() {}
    public func mainLearnTabClicked() {}
    public func mainDownloadsTabClicked() {}
    public func mainProfileTabClicked() {}
    public func mainProgramsTabClicked() {}
    public func mainProgramsClicked() {}
    public func mainCoursesClicked() {}
    public func notificationPermissionStatus(status: String) {}
}
#endif

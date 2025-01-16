//
//  MainScreenAnalytics.swift
//  OpenEdX
//
//  Created by  Stepanok Ivan on 29.06.2023.
//

import Foundation

//sourcery: AutoMockable
public protocol MainScreenAnalytics {
    func mainDiscoveryTabClicked()
    func mainLearnTabClicked()
    func mainProfileTabClicked()
    func mainProgramsTabClicked()
    func mainCoursesClicked()
    func mainProgramsClicked()
    func notificationPermissionStatus(status: String)
}

#if DEBUG
public class MainScreenAnalyticsMock: MainScreenAnalytics {
    public func mainDiscoveryTabClicked() {}
    public func mainLearnTabClicked() {}
    public func mainProfileTabClicked() {}
    public func mainProgramsTabClicked() {}
    public func mainProgramsClicked() {}
    public func mainCoursesClicked() {}
    public func notificationPermissionStatus(status: String) {}
}
#endif

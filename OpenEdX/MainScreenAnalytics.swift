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
    func mainDashboardTabClicked()
    func mainProgramsTabClicked()
    func mainProfileTabClicked()
}

#if DEBUG
public class MainScreenAnalyticsMock: MainScreenAnalytics {
    public func mainDiscoveryTabClicked() {}
    public func mainDashboardTabClicked() {}
    public func mainProgramsTabClicked() {}
    public func mainProfileTabClicked() {}
}
#endif

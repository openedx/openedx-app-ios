//
//  MainScreenAnalytics.swift
//  NewEdX
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

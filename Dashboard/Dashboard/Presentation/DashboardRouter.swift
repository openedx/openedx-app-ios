//
//  DashboardRouter.swift
//  Dashboard
//
//  Created by  Stepanok Ivan on 16.11.2022.
//

import Foundation
import Core

public protocol PaymentRouter {
    func showUpgradeInfo(for sku: String)
}

public protocol DashboardRouter: BaseRouter, PaymentRouter {
    
    func showCourseScreens(courseID: String,
                           isActive: Bool?,
                           courseStart: Date?,
                           courseEnd: Date?,
                           enrollmentStart: Date?,
                           enrollmentEnd: Date?,
                           title: String)
    
}

// Mark - For testing and SwiftUI preview
#if DEBUG
public class DashboardRouterMock: BaseRouterMock, DashboardRouter {
    public override init() {}
    
    public func showCourseScreens(courseID: String,
                                  isActive: Bool?,
                                  courseStart: Date?,
                                  courseEnd: Date?,
                                  enrollmentStart: Date?,
                                  enrollmentEnd: Date?,
                                  title: String) {}
    
    public func showUpgradeInfo(for sku: String) {}
}
#endif

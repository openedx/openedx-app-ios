//
//  AppDatesRouter.swift
//  AppDates
//
//  Created by Ivan Stepanok on 17.03.2025.
//

import Foundation
import Core

@MainActor
public protocol AppDatesRouter: BaseRouter {
    func showSettings()
    func showUpdateRequiredView(showAccountLink: Bool)
    func showCourseScreens(
        courseID: String,
        hasAccess: Bool?,
        courseStart: Date?,
        courseEnd: Date?,
        enrollmentStart: Date?,
        enrollmentEnd: Date?,
        title: String,
        courseRawImage: String?,
        showDates: Bool,
        lastVisitedBlockID: String?
    )
}

// Mark - For testing and SwiftUI preview
#if DEBUG
public class AppDatesRouterMock: BaseRouterMock, AppDatesRouter {
    public func showSettings() {}
    public func showUpdateRequiredView(showAccountLink: Bool) {}
    public func showCourseScreens(
        courseID: String,
        hasAccess: Bool?,
        courseStart: Date?,
        courseEnd: Date?,
        enrollmentStart: Date?,
        enrollmentEnd: Date?,
        title: String,
        courseRawImage: String?,
        showDates: Bool,
        lastVisitedBlockID: String?
    ) {}
}
#endif

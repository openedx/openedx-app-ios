//
//  DownloadsRouter.swift
//  Downloads
//
//  Created by Ivan Stepanok on 28.02.2025.
//

import Foundation
import Core

@MainActor
public protocol DownloadsRouter: BaseRouter {
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
public class DownloadsRouterMock: BaseRouterMock, DownloadsRouter {
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

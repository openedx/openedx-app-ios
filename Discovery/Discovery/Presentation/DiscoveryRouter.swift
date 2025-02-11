//
//  DiscoveryRouter.swift
//  Discovery
//
//  Created by  Stepanok Ivan on 16.11.2022.
//

import Foundation
import Core

@MainActor
public protocol DiscoveryRouter: BaseRouter {
    func showCourseDetais(courseID: String, title: String)
    func showWebDiscoveryDetails(
        pathID: String,
        discoveryType: DiscoveryWebviewType,
        sourceScreen: LogistrationSourceScreen
    )
    func showUpdateRequiredView(showAccountLink: Bool)
    func showUpdateRecomendedView()
    func showDiscoverySearch(searchQuery: String?)
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
    
    func showWebProgramDetails(
        pathID: String,
        viewType: ProgramViewType
    )
}

// Mark - For testing and SwiftUI preview
#if DEBUG
public class DiscoveryRouterMock: BaseRouterMock, DiscoveryRouter {
    
    public override init() {}
    
    public func showCourseDetais(courseID: String, title: String) {}
    public func showWebDiscoveryDetails(
        pathID: String,
        discoveryType: DiscoveryWebviewType,
        sourceScreen: LogistrationSourceScreen
    ) {}
    public func showUpdateRequiredView(showAccountLink: Bool) {}
    public func showUpdateRecomendedView() {}
    public func showDiscoverySearch(searchQuery: String? = nil) {}
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
    
    public func showWebProgramDetails(
        pathID: String,
        viewType: ProgramViewType
    ) {}
}
#endif

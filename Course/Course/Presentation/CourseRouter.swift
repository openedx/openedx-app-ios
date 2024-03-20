//
//  CourseRouter.swift
//  Course
//
//  Created by  Stepanok Ivan on 16.11.2022.
//

import Foundation
import Core

public protocol CourseRouter: BaseRouter {
    
    func presentAppReview()
    
    func showCourseUnit(
        courseName: String,
        blockId: String,
        courseID: String,
        sectionName: String,
        verticalIndex: Int,
        chapters: [CourseChapter],
        chapterIndex: Int,
        sequentialIndex: Int
    )
    
    func replaceCourseUnit(
        courseName: String,
        blockId: String,
        courseID: String,
        sectionName: String,
        verticalIndex: Int,
        chapters: [CourseChapter],
        chapterIndex: Int,
        sequentialIndex: Int,
        animated: Bool
    )
    
    func showCourseVerticalView(
        courseID: String,
        courseName: String,
        title: String,
        chapters: [CourseChapter],
        chapterIndex: Int,
        sequentialIndex: Int
    )
    
    func showHandoutsUpdatesView(
        handouts: String?,
        announcements: [CourseUpdate]?,
        router: Course.CourseRouter,
        cssInjector: CSSInjector
    )
    
    func showCourseComponent(
        componentID: String,
        courseStructure: CourseStructure,
        blockLink: String
    )

    func showDownloads(
        downloads: [DownloadDataTask],
        manager: DownloadManagerProtocol
    )
}

// Mark - For testing and SwiftUI preview
#if DEBUG
public class CourseRouterMock: BaseRouterMock, CourseRouter {
    
    public override init() {}
    
    public func presentAppReview() {}
    
    public func showCourseUnit(
        courseName: String,
        blockId: String,
        courseID: String,
        sectionName: String,
        verticalIndex: Int,
        chapters: [CourseChapter],
        chapterIndex: Int,
        sequentialIndex: Int
    ) {}
    
    public func replaceCourseUnit(
        courseName: String,
        blockId: String,
        courseID: String,
        sectionName: String,
        verticalIndex: Int,
        chapters: [CourseChapter],
        chapterIndex: Int,
        sequentialIndex: Int,
        animated: Bool
    ) {}
    
    public func showCourseVerticalView(
        courseID: String,
        courseName: String,
        title: String,
        chapters: [CourseChapter],
        chapterIndex: Int,
        sequentialIndex: Int
    ) {}
    
    public func showHandoutsUpdatesView(
        handouts: String?,
        announcements: [CourseUpdate]?,
        router: Course.CourseRouter,
        cssInjector: CSSInjector
    ) {}
    
    public func showCourseComponent(
        componentID: String,
        courseStructure: CourseStructure,
        blockLink: String
    ) {}

    public func showDownloads(
        downloads: [Core.DownloadDataTask],
        manager: Core.DownloadManagerProtocol
    ) {}
}
#endif

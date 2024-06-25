//
//  CourseVerticalViewModel.swift
//  Course
//
//  Created by  Stepanok Ivan on 14.03.2023.
//

import SwiftUI
import Core
import Combine

public class CourseVerticalViewModel: BaseCourseViewModel {
    let router: CourseRouter
    let analytics: CourseAnalytics
    let connectivity: ConnectivityProtocol
    @Published var verticals: [CourseVertical]
    @Published var downloadState: [String: DownloadViewState] = [:]
    @Published var showError: Bool = false
    let chapters: [CourseChapter]
    let chapterIndex: Int
    let sequentialIndex: Int
    
    var errorMessage: String? {
        didSet {
            withAnimation {
                showError = errorMessage != nil
            }
        }
    }
    
    public init(
        chapters: [CourseChapter],
        chapterIndex: Int,
        sequentialIndex: Int,
        manager: DownloadManagerProtocol,
        router: CourseRouter,
        analytics: CourseAnalytics,
        connectivity: ConnectivityProtocol
    ) {
        self.chapters = chapters
        self.chapterIndex = chapterIndex
        self.sequentialIndex = sequentialIndex
        self.router = router
        self.analytics = analytics
        self.connectivity = connectivity
        self.verticals = chapters[chapterIndex].childs[sequentialIndex].childs
        super.init(manager: manager)
    }

    func trackVerticalClicked(
        courseId: String,
        courseName: String,
        vertical: CourseVertical
    ) {
        analytics.verticalClicked(
            courseId: courseId,
            courseName: courseName,
            blockId: vertical.blockId,
            blockName: vertical.displayName
        )
    }
}

//
//  LessonViewModel.swift
//  CourseDetails
//
//  Created by  Stepanok Ivan on 05.10.2022.
//

import SwiftUI
import Core

public enum LessonType: Equatable {
    case web(String)
    case youtube(viewYouTubeUrl: String, blockID: String)
    case video(videoUrl: String, blockID: String)
    case unknown(String)
    case discussion(String, String, String)
    
    static func from(_ block: CourseBlock) -> Self {
        switch block.type {
        case .course, .chapter, .vertical, .sequential, .unknown:
            return .unknown(block.studentUrl)
        case .html:
            return .web(block.studentUrl)
        case .discussion:
            return .discussion(block.topicId ?? "", block.id, block.displayName)
        case .video:
            if block.youTubeUrl != nil, let encodedVideo = block.videoUrl {
                return .video(videoUrl: encodedVideo, blockID: block.id)
            } else if let viewYouTubeUrl = block.youTubeUrl {
                return .youtube(viewYouTubeUrl: viewYouTubeUrl, blockID: block.id)
            } else if let encodedVideo = block.videoUrl {
                return .video(videoUrl: encodedVideo, blockID: block.id)
            } else {
                return .unknown(block.studentUrl)
            }
            
        case .problem:
            return .web(block.studentUrl)
        }
    }
}

public class CourseUnitViewModel: ObservableObject {
    
    enum LessonAction {
        case next
        case previous
    }
    
    var verticals: [CourseVertical]
    var verticalIndex: Int
    var courseName: String
    
    @Published var index: Int = 0
    var previousLesson: String = ""
    var nextLesson: String = ""
    @Published var showError: Bool = false
    var errorMessage: String? {
        didSet {
            showError = errorMessage != nil
        }
    }
    
    var lessonID: String
    var courseID: String
    
    private let interactor: CourseInteractorProtocol
    let router: CourseRouter
    let analytics: CourseAnalytics
    let connectivity: ConnectivityProtocol
    private let manager: DownloadManagerProtocol
    private var subtitlesDownloaded: Bool = false
    let chapters: [CourseChapter]
    let chapterIndex: Int
    let sequentialIndex: Int
    
    func loadIndex() {
        index = selectLesson()
    }
    
    public init(
        lessonID: String,
        courseID: String,
        courseName: String,
        chapters: [CourseChapter],
        chapterIndex: Int,
        sequentialIndex: Int,
        verticalIndex: Int,
        interactor: CourseInteractorProtocol,
        router: CourseRouter,
        analytics: CourseAnalytics,
        connectivity: ConnectivityProtocol,
        manager: DownloadManagerProtocol
    ) {
        self.lessonID = lessonID
        self.courseID = courseID
        self.courseName = courseName
        self.chapters = chapters
        self.chapterIndex = chapterIndex
        self.sequentialIndex = sequentialIndex
        self.verticalIndex = verticalIndex
        self.verticals = chapters[chapterIndex].childs[sequentialIndex].childs
        self.interactor = interactor
        self.router = router
        self.analytics = analytics
        self.connectivity = connectivity
        self.manager = manager
    }
    
    private func selectLesson() -> Int {
        guard verticals[verticalIndex].childs.count > 0 else { return 0 }
        let index = verticals[verticalIndex].childs.firstIndex(where: { $0.id == lessonID }) ?? 0
        nextTitles()
        return index
    }
    
    func selectedLesson() -> CourseBlock {
        return verticals[verticalIndex].childs[index]
    }
    
    func select(move: LessonAction) {
        switch move {
        case .next:
            if index != verticals[verticalIndex].childs.count - 1 { index += 1 }
            let nextBlock = verticals[verticalIndex].childs[index]
            nextTitles()
            analytics.nextBlockClicked(
                courseId: courseID,
                courseName: courseName,
                blockId: nextBlock.blockId,
                blockName: nextBlock.displayName
            )
        case .previous:
            if index != 0 { index -= 1 }
            nextTitles()
            let prevBlock = verticals[verticalIndex].childs[index]
            analytics.prevBlockClicked(
                courseId: courseID,
                courseName: courseName,
                blockId: prevBlock.blockId,
                blockName: prevBlock.displayName
            )
        }
    }
    
    @MainActor
    func blockCompletionRequest(blockID: String) async {
        do {
            try await interactor.blockCompletionRequest(courseID: courseID, blockID: blockID)
        } catch let error {
            if error.isInternetError || error is NoCachedDataError {
                errorMessage = CoreLocalization.Error.slowOrNoInternetConnection
            } else {
                errorMessage = CoreLocalization.Error.unknownError
            }
        }
    }
    
    func nextTitles() {
        if index != 0 {
            previousLesson = verticals[verticalIndex].childs[index - 1].displayName
        } else {
            previousLesson = ""
        }
        if index != verticals[verticalIndex].childs.count - 1 {
            nextLesson = verticals[verticalIndex].childs[index + 1].displayName
        } else {
            nextLesson = ""
        }
    }
    
    func urlForVideoFileOrFallback(blockId: String, url: String) -> URL? {
        if let fileURL = manager.fileUrl(for: blockId) {
            return fileURL
        } else {
            return URL(string: url)
        }
    }
    
    func trackFinishVerticalBackToOutlineClicked() {
        analytics.finishVerticalBackToOutlineClicked(courseId: courseID, courseName: courseName)
    }
    
    func route(to vertical: CourseVertical) {
        if let index = verticals.firstIndex(where: {$0.id == vertical.id}),
            let block = vertical.childs.first {
            router.replaceCourseUnit(
                courseName: courseName,
                blockId: block.id,
                courseID: courseID,
                sectionName: block.displayName,
                verticalIndex: index,
                chapters: chapters,
                chapterIndex: chapterIndex,
                sequentialIndex: sequentialIndex,
                animated: false
            )
        }
    }
}

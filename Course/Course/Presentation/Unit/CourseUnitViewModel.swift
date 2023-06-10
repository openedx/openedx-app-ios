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
    
    public var verticals: [CourseVertical]
    public var verticalIndex: Int

    @Published var index: Int = 0
    var previousLesson: String = ""
    var nextLesson: String = ""
    @Published var showError: Bool = false
    var errorMessage: String? {
        didSet {
            showError = errorMessage != nil
        }
    }
    
    public var lessonID: String
    public var courseID: String
    public var id: String

    private let interactor: CourseInteractorProtocol
    public let router: CourseRouter
    public let connectivity: ConnectivityProtocol
    private let manager: DownloadManagerProtocol
    private var subtitlesDownloaded: Bool = false
    public let chapters: [CourseChapter]
    public let chapterIndex: Int
    public let sequentialIndex: Int
    
    func loadIndex() {
        index = selectLesson()
    }
    
    public init(lessonID: String,
                courseID: String,
                id: String,
                chapters: [CourseChapter],
                chapterIndex: Int,
                sequentialIndex: Int,
                verticalIndex: Int,
                interactor: CourseInteractorProtocol,
                router: CourseRouter,
                connectivity: ConnectivityProtocol,
                manager: DownloadManagerProtocol
    ) {
        self.lessonID = lessonID
        self.courseID = courseID
        self.id = id
        self.chapters = chapters
        self.chapterIndex = chapterIndex
        self.sequentialIndex = sequentialIndex
        self.verticalIndex = verticalIndex
        self.verticals = chapters[chapterIndex].childs[sequentialIndex].childs
        self.interactor = interactor
        self.router = router
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
    
    enum LessonAction {
        case next
        case previous
    }
    
    func select(move: LessonAction) {
        switch move {
        case .next:
            if index != verticals[verticalIndex].childs.count - 1 { index += 1 }
                nextTitles()
        case .previous:
            if index != 0 { index -= 1 }
                nextTitles()
        }
    }
    
    @MainActor
    func blockCompletionRequest(blockID: String) async {
        do {
            try await interactor.blockCompletionRequest(courseID: self.id, blockID: blockID)
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
}

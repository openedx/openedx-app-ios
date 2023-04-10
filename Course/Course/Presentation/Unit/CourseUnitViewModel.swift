//
//  LessonViewModel.swift
//  CourseDetails
//
//  Created by  Stepanok Ivan on 05.10.2022.
//

import Foundation
import Core

public enum LessonType: Equatable {
    case web(String)
    case youtube(viewYouTubeUrl: String, blockID: String)
    case video(videoUrl: String, blockID: String)
    case unknown(String)
    case discussion(String)
    
    static func from(_ block: CourseBlock) -> Self {
        switch block.type {
        case .course, .chapter, .vertical, .sequential, .unknown:
            return .unknown(block.studentUrl)
        case .html:
            return .web(block.studentUrl)
        case .discussion:
            return .discussion(block.topicId ?? "")
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
    
    public var blocks: [CourseBlock]
    @Published var index: Int = 0
    @Published var previousLesson: String = ""
    @Published var nextLesson: String = ""
    @Published var lessonType: LessonType?
    @Published var killPlayer = false
    @Published var showError: Bool = false
    var errorMessage: String? {
        didSet {
            showError = errorMessage != nil
        }
    }
    
    public var lessonID: String
    public var courseID: String

    private let interactor: CourseInteractorProtocol
    public let router: CourseRouter
    public let connectivity: ConnectivityProtocol
    private let manager: DownloadManagerProtocol
    private var subtitlesDownloaded: Bool = false
    
    func loadIndex() {
        index = selectLesson()
    }
    
    public init(lessonID: String,
                courseID: String,
                blocks: [CourseBlock],
                interactor: CourseInteractorProtocol,
                router: CourseRouter,
                connectivity: ConnectivityProtocol,
                manager: DownloadManagerProtocol
    ) {
        self.lessonID = lessonID
        self.courseID = courseID
        self.blocks = blocks
        self.interactor = interactor
        self.router = router
        self.connectivity = connectivity
        self.manager = manager
    }
    
    public func subtitlesUrl() -> String? {
        return blocks.first(where: { $0.id == lessonID })?.subtitles
    }

    private func selectLesson() -> Int {
        guard blocks.count > 0 else { return 0 }
        let index = blocks.firstIndex(where: { $0.id == lessonID }) ?? 0
        nextTitles()
        return index
    }
    
    func selectedLesson() -> CourseBlock {
        return blocks[index]
    }
    
    func createLessonType() {
        self.lessonType = LessonType.from(blocks[index])
    }
    
    enum LessonAction {
        case next
        case previous
    }
    
    func select(move: LessonAction) {
        switch move {
        case .next:
            if index != blocks.count - 1 { index += 1 }
            nextTitles()
        case .previous:
            if index != 0 { index -= 1 }
            nextTitles()
        }
    }
    
    @MainActor
    func blockCompletionRequest(blockID: String) async {
        let fullBlockID = "block-v1:\(courseID.dropFirst(10))+type@discussion+block@\(blockID)"
        do {
            try await interactor.blockCompletionRequest(courseID: courseID, blockID: fullBlockID)
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
            previousLesson = blocks[index - 1].displayName
        } else {
            previousLesson = ""
        }
        if index != blocks.count - 1 {
            nextLesson = blocks[index + 1].displayName
        } else {
            nextLesson = ""
        }
    }
    
    public func urlForVideoFileOrFallback(blockId: String, url: String) -> URL? {
        guard let block = blocks.first(where: { $0.id == blockId }) else { return nil }
        
        if let fileURL = manager.fileUrl(for: blockId) {
            return fileURL
        } else {
            return URL(string: url)
        }
    }
}

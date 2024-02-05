//
//  LessonViewModel.swift
//  CourseDetails
//
//  Created by  Stepanok Ivan on 05.10.2022.
//

import SwiftUI
import Core

public enum LessonType: Equatable {
    case web(url: String, injections: [WebviewInjection])
    case youtube(youtubeVideoUrl: String, blockID: String)
    case video(videoUrl: String, blockID: String)
    case unknown(String)
    case discussion(String, String, String)
    
    static func from(_ block: CourseBlock, streamingQuality: StreamingQuality) -> Self {
        switch block.type {
        case .course, .chapter, .vertical, .sequential, .unknown:
            return .unknown(block.studentUrl)
        case .html:
            return .web(url: block.studentUrl, injections: [.ajaxCallback])
        case .discussion:
            return .discussion(block.topicId ?? "", block.id, block.displayName)
        case .video:
            if block.encodedVideo?.youtubeVideoUrl != nil, let encodedVideo = block.encodedVideo?.video(streamingQuality: streamingQuality)?.url {
                return .video(videoUrl: encodedVideo, blockID: block.id)
            } else if let youtubeVideoUrl = block.encodedVideo?.youtubeVideoUrl {
                return .youtube(youtubeVideoUrl: youtubeVideoUrl, blockID: block.id)
            } else if let encodedVideo = block.encodedVideo?.video(streamingQuality: streamingQuality)?.url {
                return .video(videoUrl: encodedVideo, blockID: block.id)
            } else {
                return .unknown(block.studentUrl)
            }
            
        case .problem:
            return .web(url: block.studentUrl, injections: [.ajaxCallback])
        case .dragAndDropV2:
            return .web(url: block.studentUrl, injections: [.ajaxCallback, .dragAndDropCss])
        case .survey:
            return .web(url: block.studentUrl, injections: [.ajaxCallback, .surveyCSS])
        }
    }
}

public class CourseUnitViewModel: ObservableObject {
    
    enum LessonAction {
        case next
        case previous
    }

    struct VerticalData {
        var chapterIndex: Int
        var sequentialIndex: Int
        var verticalIndex: Int
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
    let config: ConfigProtocol
    let analytics: CourseAnalytics
    let connectivity: ConnectivityProtocol
    let storage: CourseStorage
    private let manager: DownloadManagerProtocol
    private var subtitlesDownloaded: Bool = false
    let chapters: [CourseChapter]
    let chapterIndex: Int
    let sequentialIndex: Int

    var streamingQuality: StreamingQuality  {
        storage.userSettings?.streamingQuality ?? .auto
    }

    func loadIndex() {
        index = selectLesson()
    }

    var courseUnitProgressEnabled: Bool {
        config.uiComponents.courseUnitProgressEnabled
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
        config: ConfigProtocol,
        router: CourseRouter,
        analytics: CourseAnalytics,
        connectivity: ConnectivityProtocol,
        storage: CourseStorage,
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
        self.config = config
        self.router = router
        self.analytics = analytics
        self.connectivity = connectivity
        self.manager = manager
        self.storage = storage
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
            setBlockCompletionForSelectedLesson()
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

    // MARK: Navigation to next vertical
    var nextData: VerticalData? {
        nextData(
            from: VerticalData(
                chapterIndex: chapterIndex,
                sequentialIndex: sequentialIndex,
                verticalIndex: verticalIndex
            )
        )
    }
    
    private func chapter(for data: VerticalData) -> CourseChapter? {
        guard data.chapterIndex >= 0 && data.chapterIndex < chapters.count else { return nil }
        return chapters[data.chapterIndex]
    }
    
    private func sequential(for data: VerticalData) -> CourseSequential? {
        guard let chapter = chapter(for: data),
              data.sequentialIndex >= 0 && data.sequentialIndex < chapter.childs.count
        else { return nil }
        return chapter.childs[data.sequentialIndex]
    }
    
    func vertical(for data: VerticalData) -> CourseVertical? {
        guard let sequential = sequential(for: data),
            data.verticalIndex >= 0 && data.verticalIndex < sequential.childs.count
        else { return nil }
        return sequential.childs[data.verticalIndex]
    }
        
    private func sequentials(for data: VerticalData) -> [CourseSequential]? {
        guard let chapter = chapter(for: data) else { return nil }
        return chapter.childs
    }
    
    private func verticals(for data: VerticalData) -> [CourseVertical]? {
        guard let sequential = sequential(for: data) else { return nil }
        return sequential.childs
    }
    
    private func nextData(from data: VerticalData) -> VerticalData? {
        var resultData: VerticalData = data
        if let verticals = verticals(for: data), verticals.count > data.verticalIndex + 1 {
            resultData.verticalIndex = data.verticalIndex + 1
        } else if let sequentials = sequentials(for: data), sequentials.count > data.sequentialIndex + 1 {
            resultData.sequentialIndex = data.sequentialIndex + 1
            resultData.verticalIndex = 0
        } else if chapters.count > data.chapterIndex + 1 {
            resultData.chapterIndex = data.chapterIndex + 1
            resultData.sequentialIndex = 0
            resultData.verticalIndex = 0
        } else {
            return nil
        }

        if let vertical = vertical(for: resultData), vertical.childs.count > 0 {
            return resultData
        } else {
            return nextData(from: resultData)
        }
    }

    private func setBlockCompletionForSelectedLesson() {
        verticals[verticalIndex].childs[index].completion = 1.0
        NotificationCenter.default.post(
            name: .onBlockCompletion,
            object: nil,
            userInfo: [
                "chapterID": chapters[chapterIndex].id,
                "sequentialID": chapters[chapterIndex].childs[sequentialIndex].id,
                "verticalID": chapters[chapterIndex].childs[sequentialIndex].childs[verticalIndex].id,
                "blockID": verticals[verticalIndex].childs[index].id
            ]
        )
    }

    func route(to vertical: CourseVertical) {
        if let index = verticals.firstIndex(where: { $0.id == vertical.id }),
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

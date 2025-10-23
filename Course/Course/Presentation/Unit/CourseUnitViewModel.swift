//
//  LessonViewModel.swift
//  CourseDetails
//
//  Created by  Stepanok Ivan on 05.10.2022.
//

import SwiftUI
import Core

public enum LessonType: Equatable {
    case web(url: String, injections: [WebviewInjection], blockId: String, isDownloadable: Bool)
    case youtube(youtubeVideoUrl: String, blockId: String)
    case video(videoUrl: String, blockId: String)
    case unknown(String)
    case discussion(String, String, String)
    
    static func from(_ block: CourseBlock, streamingQuality: StreamingQuality) -> Self {
        let mandatoryInjections: [WebviewInjection] = [.colorInversionCss, .ajaxCallback, .readability, .accessibility]
        switch block.type {
        case .course, .chapter, .vertical, .sequential:
            return .unknown(block.studentUrl)
        case .unknown:
            if let multiDevice = block.multiDevice, multiDevice {
                return .web(
                    url: block.studentUrl,
                    injections: mandatoryInjections,
                    blockId: block.id,
                    isDownloadable: block.isDownloadable
                )
            } else {
                return .unknown(block.studentUrl)
            }
        case .html:
            return .web(
                url: block.studentUrl,
                injections: mandatoryInjections,
                blockId: block.id,
                isDownloadable: block.isDownloadable
            )
        case .discussion:
            return .discussion(block.topicId ?? "", block.id, block.displayName)
        case .video:
            if let encodedVideo = block.encodedVideo?.video(streamingQuality: streamingQuality),
               let videoURL = encodedVideo.url {
                if encodedVideo.type == .youtube {
                    return .youtube(youtubeVideoUrl: videoURL, blockId: block.id)
                } else if encodedVideo.isVideoURL {
                    return .video(videoUrl: videoURL, blockId: block.id)
                } else {
                    return .unknown(block.studentUrl)
                }
            } else {
                return .unknown(block.studentUrl)
            }
            
        case .problem:
            return .web(
                url: block.studentUrl,
                injections: mandatoryInjections,
                blockId: block.id,
                isDownloadable: block.isDownloadable
            )
        case .dragAndDropV2:
            return .web(
                url: block.studentUrl,
                injections: mandatoryInjections + [.dragAndDropCss],
                blockId: block.id,
                isDownloadable: block.isDownloadable
            )
        case .survey:
            return .web(
                url: block.studentUrl,
                injections: mandatoryInjections + [.surveyCSS],
                blockId: block.id,
                isDownloadable: block.isDownloadable
            )
        case .openassessment, .peerInstructionTool:
            return .web(
                url: block.studentUrl,
                injections: mandatoryInjections,
                blockId: block.id,
                isDownloadable: block.isDownloadable
            )
        }
    }
}

public struct VerticalData: Equatable {
    public var chapterIndex: Int
    public var sequentialIndex: Int
    public var verticalIndex: Int
    public var blockIndex: Int
    
    public init(chapterIndex: Int, sequentialIndex: Int, verticalIndex: Int, blockIndex: Int) {
        self.chapterIndex = chapterIndex
        self.sequentialIndex = sequentialIndex
        self.verticalIndex = verticalIndex
        self.blockIndex = blockIndex
    }
    
    public static func dataFor(blockId: String?, in chapters: [CourseChapter]) -> VerticalData? {
        guard let blockId = blockId else { return nil }
        for (chapterIndex, chapter) in chapters.enumerated() {
            for (sequentialIndex, sequential) in chapter.childs.enumerated() {
                for (verticalIndex, vertical) in sequential.childs.enumerated() {
                    for (blockIndex, block) in vertical.childs.enumerated() where block.id.contains(blockId) {
                        return VerticalData(
                            chapterIndex: chapterIndex,
                            sequentialIndex: sequentialIndex,
                            verticalIndex: verticalIndex,
                            blockIndex: blockIndex
                        )
                    }
                }
            }
        }
        return nil
    }
}

@MainActor
public final class CourseUnitViewModel: ObservableObject {
    
    enum LessonAction: Sendable {
        case next
        case previous
    }

    var verticals: [CourseVertical]
    var verticalIndex: Int
    var courseName: String

    @Published var courseVideosStructure: CourseStructure?
    @Published var index: Int = 0
    var previousLesson: String = ""
    var nextLesson: String = ""
    @Published var showError: Bool = false
    var errorMessage: String? {
        didSet {
            showError = errorMessage != nil
        }
    }

    @Published public var allVideosForNavigation: [CourseBlock] = []
    @Published public var allVideosFetched = false
    @Published public var isVideosForNavigationLoading: Bool = false
    @Published var currentVideoIndex: Int?

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
    
    var showVideoNavigation: Bool = false

    var streamingQuality: StreamingQuality {
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
        manager: DownloadManagerProtocol,
        showVideoNavigation: Bool = false,
        courseVideosStructure: CourseStructure? = nil
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
        self.showVideoNavigation = showVideoNavigation
        self.courseVideosStructure = courseVideosStructure
    }
    
    private func selectLesson() -> Int {
        guard verticals[verticalIndex].childs.count > 0 else { return 0 }
        let index = verticals[verticalIndex].childs.firstIndex(where: { $0.id.contains(lessonID) }) ?? 0
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
    
    func urlForVideoFileOrFallback(blockId: String, url: String) async -> URL? {
        guard !connectivity.isInternetAvaliable else { return URL(string: url) }
        if let fileURL = await manager.fileUrl(for: blockId) {
            return fileURL
        } else {
            return URL(string: url)
        }
    }

    func urlForOfflineContent(blockId: String) async -> URL? {
        return await manager.fileUrl(for: blockId)
    }
    
    func trackFinishVerticalBackToOutlineClicked() {
        analytics.finishVerticalBackToOutlineClicked(courseId: courseID, courseName: courseName)
    }

    // MARK: Navigation to next vertical
    var nextData: VerticalData? {
        nextData(
            from: currentData
        )
    }
    
    var currentData: VerticalData {
        VerticalData(
            chapterIndex: chapterIndex,
            sequentialIndex: sequentialIndex,
            verticalIndex: verticalIndex,
            blockIndex: index
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
            resultData.blockIndex = 0
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

    func blockFor(index: Int, in vertical: CourseVertical) -> CourseBlock? {
        guard index >= 0 && index < vertical.childs.count else { return nil }
        return vertical.childs[index]
    }
    
    func route(to data: VerticalData?, animated: Bool = false) {
        guard let data = data, data != currentData else { return }
        if let vertical = vertical(for: data),
                  let block = blockFor(index: data.blockIndex, in: vertical) {
            router.replaceCourseUnit(
                courseName: courseName,
                blockId: block.blockId,
                courseID: courseID,
                verticalIndex: data.verticalIndex,
                chapters: chapters,
                chapterIndex: data.chapterIndex,
                sequentialIndex: data.sequentialIndex,
                animated: animated,
                showVideoNavigation: false,
                courseVideoStructure: nil
            )
        }
    }
    
    public func route(to blockId: String?) {
        guard let data = VerticalData.dataFor(blockId: blockId, in: chapters) else { return }
        route(to: data, animated: true)
    }
    
    public var currentCourseId: String {
        courseID
    }

    @MainActor
    private func getCourseStructure(courseID: String) async throws -> CourseStructure? {
        if connectivity.isInternetAvaliable {
            return try await interactor.getCourseBlocks(courseID: courseID)
        } else {
            return try await interactor.getLoadedCourseBlocks(courseID: courseID)
        }
    }

    @MainActor
    func getCourseVideoBlocks() async {
        isVideosForNavigationLoading = true
        
        defer {
            Task { @MainActor in
                try? await Task.sleep(for: .seconds(0.2))
                self.isVideosForNavigationLoading = false
            }
        }

        if let courseVideosStructure {
            do {
                let videoFromCourse = await interactor.getCourseVideoBlocks(fullStructure: courseVideosStructure)

                allVideosForNavigation = try await interactor.getAllVideosForNavigation(
                    structure: videoFromCourse
                )

                return

            } catch {
                print("Failed to get all videos for course: \(error.localizedDescription)")
            }
        }

        async let structureTask = getCourseStructure(courseID: courseID)

        do {
            guard let courseStructure = try await structureTask else {
                throw NSError(
                    domain: "GetCourseBlocks",
                    code: 0,
                    userInfo: [NSLocalizedDescriptionKey: "Course structure is nil"]
                )
            }

            async let videosTask = interactor.getCourseVideoBlocks(fullStructure: courseStructure)
            courseVideosStructure = await videosTask

            if let courseVideosStructure {
                allVideosForNavigation = try await interactor.getAllVideosForNavigation(
                    structure: courseVideosStructure
                )
            }

        } catch {
            print("Failed to load course blocks: \(error.localizedDescription)")
            courseVideosStructure = nil
        }
    }

    func createBreadCrumpsForVideoNavigation(video: CourseBlock) -> String {
        guard let courseStructure = courseVideosStructure else {
            return ""
        }

        let breadcrumb = courseStructure.childs
            .flatMap { chapter in
                chapter.childs.flatMap { sequential in
                    sequential.childs.compactMap { vertical -> String? in
                        if vertical.childs.contains(where: { $0.id == video.id }) {
                            return [chapter.displayName, sequential.displayName, vertical.displayName]
                                .joined(separator: " > ")
                        }
                        return nil
                    }
                }
            }
            .first

        return breadcrumb ?? ""
    }

    func handleVideoTap(video: CourseBlock) {
        // Find indices for navigation using full course structure
        guard let chapterIndex = findChapterIndexInFullStructure(video: video),
              let sequentialIndex = findSequentialIndexInFullStructure(video: video),
              let verticalIndex = findVerticalIndexInFullStructure(video: video),
              let courseStructure = courseVideosStructure else {
            return
        }

        // Track video click analytics
        analytics.courseVideoClicked(
            courseId: courseStructure.id,
            courseName: courseStructure.displayName,
            blockId: video.id,
            blockName: video.displayName
        )

        router.replaceCourseUnit(
            courseName: courseName,
            blockId: video.blockId,
            courseID: courseID,
            verticalIndex: verticalIndex,
            chapters: courseStructure.childs,
            chapterIndex: chapterIndex,
            sequentialIndex: sequentialIndex,
            animated: false,
            showVideoNavigation: true,
            courseVideoStructure: courseStructure
        )
    }

    private func findChapterIndexInFullStructure(video: CourseBlock) -> Int? {
        guard let courseStructure = courseVideosStructure else { return nil }

        // Find the chapter that contains this video in the full structure
        return courseStructure.childs.firstIndex { fullChapter in
            fullChapter.childs.contains { sequential in
                sequential.childs.contains { vertical in
                    vertical.childs.contains { $0.id == video.id }
                }
            }
        }
    }

    private func findSequentialIndexInFullStructure(video: CourseBlock) -> Int? {
        guard let courseStructure = courseVideosStructure else { return nil }

        // Find the chapter and sequential that contains this video in the full structure
        for fullChapter in courseStructure.childs {
            if let sequentialIndex = fullChapter.childs.firstIndex(where: { sequential in
                sequential.childs.contains { vertical in
                    vertical.childs.contains { $0.id == video.id }
                }
            }) {
                return sequentialIndex
            }
        }
        return nil
    }

    private func findVerticalIndexInFullStructure(video: CourseBlock) -> Int? {
        guard let courseStructure = courseVideosStructure else { return nil }

        // Find the vertical that contains this video in the full structure
        for fullChapter in courseStructure.childs {
            for sequential in fullChapter.childs {
                if let verticalIndex = sequential.childs.firstIndex(where: { vertical in
                    vertical.childs.contains { $0.id == video.id }
                }) {
                    return verticalIndex
                }
            }
        }
        return nil
    }
}

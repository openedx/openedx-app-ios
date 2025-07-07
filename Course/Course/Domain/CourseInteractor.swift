//
//  CourseInteractor.swift
//  Course
//
//  Created by  Stepanok Ivan on 26.09.2022.
//

import Foundation
import Core

//sourcery: AutoMockable
public protocol CourseInteractorProtocol: Sendable {
    func getCourseBlocks(courseID: String) async throws -> CourseStructure
    func getCourseVideoBlocks(fullStructure: CourseStructure) async -> CourseStructure
    func getLoadedCourseBlocks(courseID: String) async throws -> CourseStructure
    func getSequentialsContainsBlocks(blockIds: [String], courseID: String) async throws -> [CourseSequential]
    func blockCompletionRequest(courseID: String, blockID: String) async throws
    func getHandouts(courseID: String) async throws -> String?
    func getUpdates(courseID: String) async throws -> [CourseUpdate]
    func resumeBlock(courseID: String) async throws -> ResumeBlock
    func getSubtitles(url: String, selectedLanguage: String) async throws -> [Subtitle]
    func getCourseDates(courseID: String) async throws -> CourseDates
    func getCourseDeadlineInfo(courseID: String) async throws -> CourseDateBanner
    func shiftDueDates(courseID: String) async throws
    func updateLocalVideoProgress(blockID: String, progress: Double) async
    func loadLocalVideoProgress(blockID: String) async -> Double?
    func enrichCourseStructureWithLocalProgress(_ structure: CourseStructure) async -> CourseStructure
}

public actor CourseInteractor: CourseInteractorProtocol, CourseStructureManagerProtocol {
    
    private let repository: CourseRepositoryProtocol
    
    public init(repository: CourseRepositoryProtocol) {
        self.repository = repository
    }
    
    public func getCourseBlocks(courseID: String) async throws -> CourseStructure {
        return try await repository.getCourseBlocks(courseID: courseID)
    }
    
    public func getCourseVideoBlocks(fullStructure course: CourseStructure) async -> CourseStructure {
        var newChilds = [CourseChapter]()
        for chapter in course.childs {
            let newChapter = filterChapter(chapter: chapter)
            if !newChapter.childs.isEmpty {
                newChilds.append(newChapter)
            }
        }
        
        // Calculate video progress specifically
        let allVideos = getAllVideosFromStructure(childs: newChilds)
        let completedVideos = allVideos.filter { $0.completion >= 1.0 }
        let videoProgress = allVideos.isEmpty ? nil : CourseProgress(
            totalAssignmentsCount: allVideos.count,
            assignmentsCompleted: completedVideos.count
        )
        
        let filteredStructure = CourseStructure(
            id: course.id,
            graded: course.graded,
            completion: course.completion,
            viewYouTubeUrl: course.viewYouTubeUrl,
            encodedVideo: course.encodedVideo,
            displayName: course.displayName,
            topicID: course.topicID,
            childs: newChilds,
            media: course.media,
            certificate: course.certificate,
            org: course.org,
            isSelfPaced: course.isSelfPaced,
            courseProgress: videoProgress
        )
        
        // Enrich with local video progress
        let enrichedStructure = await enrichCourseStructureWithLocalProgress(filteredStructure)
        
        // After enrichment, recalculate progress with updated video states
        let enrichedVideos = getAllVideosFromStructure(childs: enrichedStructure.childs)
        let enrichedCompletedVideos = enrichedVideos.filter { $0.completion >= 1.0 }
        let finalVideoProgress = enrichedVideos.isEmpty ? nil : CourseProgress(
            totalAssignmentsCount: enrichedVideos.count,
            assignmentsCompleted: enrichedCompletedVideos.count
        )
        
        var finalStructure = enrichedStructure
        finalStructure.courseProgress = finalVideoProgress
                
        return finalStructure
    }
    
    private func getAllVideosFromStructure(childs: [CourseChapter]) -> [CourseBlock] {
        return childs.flatMap { chapter in
            chapter.childs.flatMap { sequential in
                sequential.childs.flatMap { vertical in
                    vertical.childs.filter { $0.type == .video }
                }
            }
        }
    }
    
    public func getLoadedCourseBlocks(courseID: String) async throws -> CourseStructure {
        return try await repository.getLoadedCourseBlocks(courseID: courseID)
    }
    
    public func getSequentialsContainsBlocks(blockIds: [String], courseID: String) async throws -> [CourseSequential] {
        let courseStructure = try await repository.getLoadedCourseBlocks(courseID: courseID)
        var sequentials: [CourseSequential] = []
        
        for chapter in courseStructure.childs {
            for sequential in chapter.childs {
                let filteredChilds = sequential.childs.filter { vertical in
                    vertical.childs.contains { block in
                        blockIds.contains(block.id)
                    }
                }
                if !filteredChilds.isEmpty {
                    var newSequential = sequential
                    newSequential.childs = filteredChilds
                    sequentials.append(newSequential)
                }
            }
        }
        
        return sequentials
    }
    
    public func blockCompletionRequest(courseID: String, blockID: String) async throws {
        return try await repository.blockCompletionRequest(courseID: courseID, blockID: blockID)
    }
    
    public func shiftDueDates(courseID: String) async throws {
        return try await repository.shiftDueDates(courseID: courseID)
    }
    
    public func getHandouts(courseID: String) async throws -> String? {
        return try await repository.getHandouts(courseID: courseID)
    }
    
    public func getUpdates(courseID: String) async throws -> [CourseUpdate] {
        return try await repository.getUpdates(courseID: courseID)
    }
    
    public func resumeBlock(courseID: String) async throws -> ResumeBlock {
        return try await repository.resumeBlock(courseID: courseID)
    }
        
    public func getSubtitles(url: String, selectedLanguage: String) async throws -> [Subtitle] {
        let result = try await repository.getSubtitles(url: url, selectedLanguage: selectedLanguage)
        return parseSubtitles(from: result)
    }
    
    public func getCourseDates(courseID: String) async throws -> CourseDates {
        return try await repository.getCourseDates(courseID: courseID)
    }
    
    public func getCourseDeadlineInfo(courseID: String) async throws -> CourseDateBanner {
        return try await repository.getCourseDeadlineInfo(courseID: courseID)
    }
    
    private func filterChapter(chapter: CourseChapter) -> CourseChapter {
        var newChilds = [CourseSequential]()
        for sequential in chapter.childs {
            let newSequential = filterSequential(sequential: sequential)
            if !newSequential.childs.isEmpty {
                newChilds.append(newSequential)
            }
        }
        return CourseChapter(
            blockId: chapter.blockId,
            id: chapter.id,
            displayName: chapter.displayName,
            type: chapter.type,
            childs: newChilds
        )
    }
    
    private func filterSequential(sequential: CourseSequential) -> CourseSequential {
        var newChilds = [CourseVertical]()
        for vertical in sequential.childs {
            let newVertical = filterVertical(vertical: vertical)
            if !newVertical.childs.isEmpty {
                newChilds.append(newVertical)
            }
        }
        return CourseSequential(
            blockId: sequential.blockId,
            id: sequential.id,
            displayName: sequential.displayName,
            type: sequential.type,
            completion: sequential.completion,
            childs: newChilds,
            sequentialProgress: sequential.sequentialProgress,
            due: sequential.due
        )
    }
    
    private func filterVertical(vertical: CourseVertical) -> CourseVertical {
        let newChilds = vertical.childs.filter { $0.type == .video }
        return CourseVertical(
            blockId: vertical.blockId,
            id: vertical.id,
            courseId: vertical.courseId,
            displayName: vertical.displayName,
            type: vertical.type,
            completion: vertical.completion,
            childs: newChilds,
            webUrl: vertical.webUrl
        )
    }
    
    private func removeEmptyElements(from subtitlesString: String) -> String {
        let subtitleComponents = subtitlesString.components(separatedBy: "\n\n")
            .filter({
                let lines = $0.components(separatedBy: .newlines)

                if lines.count >= 3 {
                    let text = lines[2..<lines.count].joined(separator: "\n")
                    if !text.isEmpty {
                       return true
                    }
                }
                return false
            })
            .map {
                if $0.hasPrefix("\n") {
                    let index = $0.index($0.startIndex, offsetBy: 1)
                    return String($0[index...])
                } else {
                    return $0
                }
            }
        
        return subtitleComponents.joined(separator: "\n\n")
    }
    
    private func parseSubtitles(from subtitlesString: String) -> [Subtitle] {
        let clearedSubtitles = removeEmptyElements(from: subtitlesString)
        let subtitleComponents = clearedSubtitles.components(separatedBy: "\n\n")
        var subtitles = [Subtitle]()
        
        for component in subtitleComponents {
            let lines = component.components(separatedBy: .newlines)
            
            if lines.count >= 3 {
                let idString = lines[0]
                let id = Int(idString) ?? 0
                
                let startAndEndTimes = lines[1].components(separatedBy: " --> ")
                let startTime = startAndEndTimes.first ?? "00:00:00,000"
                let endTime = startAndEndTimes.last ?? "00:00:00,000"
                let text = lines[2..<lines.count].joined(separator: "\n")
                
                let startTimeInterval = Date(subtitleTime: startTime)
                var endTimeInverval = Date(subtitleTime: endTime)
                if startTimeInterval > endTimeInverval {
                    endTimeInverval = startTimeInterval
                }
                
                let subtitle = Subtitle(id: id,
                                        fromTo: DateInterval(start: startTimeInterval,
                                                             end: endTimeInverval),
                                        text: text.decodedHTMLEntities())
                subtitles.append(subtitle)
            }
        }
        return subtitles
    }
    
    public func updateLocalVideoProgress(blockID: String, progress: Double) async {
        await repository.updateLocalVideoProgress(blockID: blockID, progress: progress)
    }
    
    public func loadLocalVideoProgress(blockID: String) async -> Double? {
        let progress = await repository.loadLocalVideoProgress(blockID: blockID)
        return progress
    }
    
    public func enrichCourseStructureWithLocalProgress(_ structure: CourseStructure) async -> CourseStructure {
        var enrichedStructure = structure
        enrichedStructure.childs = await withTaskGroup(of: CourseChapter.self) { group in
            for chapter in structure.childs {
                group.addTask {
                    await self.enrichChapterWithLocalProgress(chapter)
                }
            }
            
            var enrichedChapters: [CourseChapter] = []
            for await enrichedChapter in group {
                enrichedChapters.append(enrichedChapter)
            }
            return enrichedChapters.sorted { $0.id < $1.id }
        }
        return enrichedStructure
    }
    
    private func enrichChapterWithLocalProgress(_ chapter: CourseChapter) async -> CourseChapter {
        var enrichedChapter = chapter
        enrichedChapter.childs = await withTaskGroup(of: CourseSequential.self) { group in
            for sequential in chapter.childs {
                group.addTask {
                    await self.enrichSequentialWithLocalProgress(sequential)
                }
            }
            
            var enrichedSequentials: [CourseSequential] = []
            for await enrichedSequential in group {
                enrichedSequentials.append(enrichedSequential)
            }
            return enrichedSequentials.sorted { $0.id < $1.id }
        }
        return enrichedChapter
    }
    
    private func enrichSequentialWithLocalProgress(_ sequential: CourseSequential) async -> CourseSequential {
        var enrichedSequential = sequential
        enrichedSequential.childs = await withTaskGroup(of: CourseVertical.self) { group in
            for vertical in sequential.childs {
                group.addTask {
                    await self.enrichVerticalWithLocalProgress(vertical)
                }
            }
            
            var enrichedVerticals: [CourseVertical] = []
            for await enrichedVertical in group {
                enrichedVerticals.append(enrichedVertical)
            }
            return enrichedVerticals.sorted { $0.id < $1.id }
        }
        return enrichedSequential
    }
    
    private func enrichVerticalWithLocalProgress(_ vertical: CourseVertical) async -> CourseVertical {
        var enrichedVertical = vertical
        enrichedVertical.childs = await withTaskGroup(of: CourseBlock.self) { group in
            for block in vertical.childs {
                group.addTask {
                    await self.enrichBlockWithLocalProgress(block)
                }
            }
            
            var enrichedBlocks: [CourseBlock] = []
            for await enrichedBlock in group {
                enrichedBlocks.append(enrichedBlock)
            }
            return enrichedBlocks.sorted { $0.id < $1.id }
        }
        return enrichedVertical
    }
    
    private func enrichBlockWithLocalProgress(_ block: CourseBlock) async -> CourseBlock {
        var enrichedBlock = block
        if block.type == .video {
            if let localProgress = await repository.loadLocalVideoProgress(blockID: block.id) {
                enrichedBlock.localVideoProgress = localProgress
            }
        }
        return enrichedBlock
    }
}

// Mark - For testing and SwiftUI preview
#if DEBUG
public extension CourseInteractor {
    static let mock = CourseInteractor(repository: CourseRepositoryMock())
}
#endif

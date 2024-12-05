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
}

public actor CourseInteractor: CourseInteractorProtocol {
    
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
        return CourseStructure(
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
            courseProgress: course.courseProgress == nil ? nil : CourseProgress(
                totalAssignmentsCount: course.courseProgress?.totalAssignmentsCount ?? 0,
                assignmentsCompleted: course.courseProgress?.assignmentsCompleted ?? 0
            )
        )
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
}

// Mark - For testing and SwiftUI preview
#if DEBUG
public extension CourseInteractor {
    static let mock = CourseInteractor(repository: CourseRepositoryMock())
}
#endif

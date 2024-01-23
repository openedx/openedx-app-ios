//
//  CourseRepository.swift
//  Course
//
//  Created by  Stepanok Ivan on 26.09.2022.
//

import Foundation
import Core

public protocol CourseRepositoryProtocol {
    func getCourseBlocks(courseID: String) async throws -> CourseStructure
    func getLoadedCourseBlocks(courseID: String) throws -> CourseStructure
    func blockCompletionRequest(courseID: String, blockID: String) async throws
    func getHandouts(courseID: String) async throws -> String?
    func getUpdates(courseID: String) async throws -> [CourseUpdate]
    func resumeBlock(courseID: String) async throws -> ResumeBlock
    func getSubtitles(url: String, selectedLanguage: String) async throws -> String
    func getCourseDates(courseID: String) async throws -> CourseDates
    func getCourseDatesOffline(courseID: String) async throws -> CourseDates
}

public class CourseRepository: CourseRepositoryProtocol {
    
    private let api: API
    private let coreStorage: CoreStorage
    private let config: ConfigProtocol
    private let persistence: CoursePersistenceProtocol
    
    public init(
        api: API,
        coreStorage: CoreStorage,
        config: ConfigProtocol,
        persistence: CoursePersistenceProtocol
    ) {
        self.api = api
        self.coreStorage = coreStorage
        self.config = config
        self.persistence = persistence
    }
        
    public func getCourseBlocks(courseID: String) async throws -> CourseStructure {
        let course = try await api.requestData(
            CourseEndpoint.getCourseBlocks(courseID: courseID, userName: coreStorage.user?.username ?? "")
        ).mapResponse(DataLayer.CourseStructure.self)
        persistence.saveCourseStructure(structure: course)
        let parsedStructure = parseCourseStructure(course: course)
        return parsedStructure
    }
    
    public func getLoadedCourseBlocks(courseID: String) throws -> CourseStructure {
        let localData = try persistence.loadCourseStructure(courseID: courseID)
        return parseCourseStructure(course: localData)
    }
    
    public func blockCompletionRequest(courseID: String, blockID: String) async throws {
        try await api.requestData(CourseEndpoint.blockCompletionRequest(
            username: coreStorage.user?.username ?? "",
            courseID: courseID,
            blockID: blockID)
        )
    }
    
    public func getHandouts(courseID: String) async throws -> String? {
        return try await api.requestData(CourseEndpoint.getHandouts(courseID: courseID))
            .mapResponse(DataLayer.HandoutsResponse.self)
            .handoutsHtml
    }
    
    public func getUpdates(courseID: String) async throws -> [CourseUpdate] {
        return try await api.requestData(CourseEndpoint.getUpdates(courseID: courseID))
            .mapResponse(DataLayer.CourseUpdates.self).map { $0.domain }
    }
    
    public func resumeBlock(courseID: String) async throws -> ResumeBlock {
        return try await api.requestData(CourseEndpoint
            .resumeBlock(userName: coreStorage.user?.username ?? "", courseID: courseID))
        .mapResponse(DataLayer.ResumeBlock.self).domain
    }
    
    public func getSubtitles(url: String, selectedLanguage: String) async throws -> String {
        if let subtitlesOffline = persistence.loadSubtitles(url: url + selectedLanguage) {
            return subtitlesOffline
        } else {
            let result = try await api.requestData(CourseEndpoint.getSubtitles(
                url: url,
                selectedLanguage: selectedLanguage
            ))
            let subtitles = String(data: result, encoding: .utf8) ?? ""
            persistence.saveSubtitles(url: url + selectedLanguage, subtitlesString: subtitles)
            return subtitles
        }
    }
    
    public func getCourseDates(courseID: String) async throws -> CourseDates {
        let courseDates = try await api.requestData(
            CourseEndpoint.getCourseDates(courseID: courseID)
        ).mapResponse(DataLayer.CourseDates.self).domain
        persistence.saveCourseDates(courseID: courseID, courseDates: courseDates)
        return courseDates
    }
    
    public func getCourseDatesOffline(courseID: String) async throws -> CourseDates {
        return try persistence.loadCourseDates(courseID: courseID)
    }
    
    private func parseCourseStructure(course: DataLayer.CourseStructure) -> CourseStructure {
        let blocks = Array(course.dict.values)
        let courseBlock = blocks.first(where: {$0.type == BlockType.course.rawValue })!
        let descendants = courseBlock.descendants ?? []
        var childs: [CourseChapter] = []
        for descend in descendants {
            let chapter = parseChapters(id: descend, courseId: course.id, blocks: blocks)
            childs.append(chapter)
        }
        
        return CourseStructure(
            id: course.id,
            graded: courseBlock.graded,
            completion: courseBlock.completion ?? 0,
            viewYouTubeUrl: courseBlock.userViewData?.encodedVideo?.youTube?.url ?? "",
            encodedVideo: courseBlock.userViewData?.encodedVideo?.fallback?.url ?? "",
            displayName: courseBlock.displayName,
            topicID: courseBlock.userViewData?.topicID,
            childs: childs,
            media: course.media,
            certificate: course.certificate?.domain
        )
    }
    
    private func parseChapters(id: String, courseId: String, blocks: [DataLayer.CourseBlock]) -> CourseChapter {
        let chapter = blocks.first(where: {$0.id == id })!
        let descendants = chapter.descendants ?? []
        var childs: [CourseSequential] = []
        for descend in descendants {
            let chapter = parseSequential(id: descend, courseId: courseId, blocks: blocks)
            childs.append(chapter)
        }
        return CourseChapter(blockId: chapter.blockId,
                             id: chapter.id,
                             displayName: chapter.displayName,
                             type: BlockType(rawValue: chapter.type) ?? .unknown,
                             childs: childs)
        
    }
    
    private func parseSequential(id: String, courseId: String, blocks: [DataLayer.CourseBlock]) -> CourseSequential {
        let sequential = blocks.first(where: {$0.id == id })!
        let descendants = sequential.descendants ?? []
        var childs: [CourseVertical] = []
        for descend in descendants {
            let vertical = parseVerticals(id: descend, courseId: courseId, blocks: blocks)
            childs.append(vertical)
        }
        return CourseSequential(
            blockId: sequential.blockId,
            id: sequential.id,
            displayName: sequential.displayName,
            type: BlockType(rawValue: sequential.type) ?? .unknown,
            completion: sequential.completion ?? 0,
            childs: childs
        )
    }
    
    private func parseVerticals(id: String, courseId: String, blocks: [DataLayer.CourseBlock]) -> CourseVertical {
        let sequential = blocks.first(where: {$0.id == id })!
        let descendants = sequential.descendants ?? []
        var childs: [CourseBlock] = []
        for descend in descendants {
            let block = parseBlock(id: descend, courseId: courseId, blocks: blocks)
            childs.append(block)
        }
        return CourseVertical(
            blockId: sequential.blockId,
            id: sequential.id,
            courseId: courseId,
            displayName: sequential.displayName,
            type: BlockType(rawValue: sequential.type) ?? .unknown,
            completion: sequential.completion ?? 0,
            childs: childs
        )
    }
    
    private func parseBlock(id: String, courseId: String, blocks: [DataLayer.CourseBlock]) -> CourseBlock {
        let block = blocks.first(where: {$0.id == id })!
        let subtitles = block.userViewData?.transcripts?.map {
            let url = $0.value
                .replacingOccurrences(of: config.baseURL.absoluteString, with: "")
                .replacingOccurrences(of: "?lang=\($0.key)", with: "")
            return SubtitleUrl(language: $0.key, url: url)
        }
            
        return CourseBlock(
            blockId: block.blockId,
            id: block.id,
            courseId: courseId,
            topicId: block.userViewData?.topicID,
            graded: block.graded,
            completion: block.completion ?? 0,
            type: BlockType(rawValue: block.type) ?? .unknown,
            displayName: block.displayName,
            studentUrl: block.studentUrl,
            subtitles: subtitles,
            videoUrl: block.userViewData?.encodedVideo?.fallback?.url,
            youTubeUrl: block.userViewData?.encodedVideo?.youTube?.url
        )
    }
    
}

// Mark - For testing and SwiftUI preview
// swiftlint:disable all
#if DEBUG
class CourseRepositoryMock: CourseRepositoryProtocol {
    func getCourseDatesOffline(courseID: String) async throws -> CourseDates {
        throw NoCachedDataError()
    }
    
    func resumeBlock(courseID: String) async throws -> ResumeBlock {
        ResumeBlock(blockID: "123")
    }
    
    func getHandouts(courseID: String) async throws -> String? {
        return "Test Handouts"
    }
    
    func getUpdates(courseID: String) async throws -> [CourseUpdate] {
        return [CourseUpdate(id: 1, date: "Date", content: "content", status: "status")]
    }
    
    func getCourseDates(courseID: String) async throws -> CourseDates {
        do {
            let courseDates = try courseDatesJSON.data(using: .utf8)!.mapResponse(DataLayer.CourseDates.self)
            return courseDates.domain
        } catch {
            throw error
        }
    }
    
    func getLoadedCourseBlocks(courseID: String) throws -> CourseStructure {
        let decoder = JSONDecoder()
        let jsonData = Data(courseStructureJson.utf8)
        let courseBlocks = try decoder.decode(DataLayer.CourseStructure.self, from: jsonData)
        return parseCourseStructure(course: courseBlocks)
    }
        
    public  func getCourseBlocks(courseID: String) async throws -> CourseStructure {
        do {
            let courseBlocks = try courseStructureJson.data(using: .utf8)!.mapResponse(DataLayer.CourseStructure.self)
            return parseCourseStructure(course: courseBlocks)
        } catch {
            throw error
        }
    }
    
    public  func blockCompletionRequest(courseID: String, blockID: String) {
        
    }
    
    public func getSubtitles(url: String, selectedLanguage: String) async throws -> String {
        return """
0
00:00:00,350 --> 00:00:05,230
GREGORY NAGY: In hour zero, where I try to introduce Homeric poetry to
1
00:00:05,230 --> 00:00:11,060
people who may never have been exposed to the Iliad and the Odyssey even in
2
00:00:11,060 --> 00:00:20,290
translation, my idea was to get a sense of the medium, which is not a
3
00:00:20,290 --> 00:00:25,690
readable medium because Homeric poetry, in its historical context, was
4
00:00:25,690 --> 00:00:30,210
meant to be heard, not read.
5
00:00:30,210 --> 00:00:34,760
And there are various ways of describing it-- call it oral poetry or
"""
    }
    
    private func parseCourseStructure(course: DataLayer.CourseStructure) -> CourseStructure {
        let blocks = Array(course.dict.values)
        let courseBlock = blocks.first(where: {$0.type == BlockType.course.rawValue })!
        let descendants = courseBlock.descendants ?? []
        var childs: [CourseChapter] = []
        for descend in descendants {
            let chapter = parseChapters(id: descend, courseId: course.id, blocks: blocks)
            childs.append(chapter)
        }
        
        return CourseStructure(
            id: course.id,
            graded: courseBlock.graded,
            completion: courseBlock.completion ?? 0,
            viewYouTubeUrl: courseBlock.userViewData?.encodedVideo?.youTube?.url ?? "",
            encodedVideo: courseBlock.userViewData?.encodedVideo?.fallback?.url ?? "",
            displayName: courseBlock.displayName,
            topicID: courseBlock.userViewData?.topicID,
            childs: childs,
            media: course.media,
            certificate: course.certificate?.domain
        )
    }
    
    private func parseChapters(id: String, courseId: String, blocks: [DataLayer.CourseBlock]) -> CourseChapter {
        let chapter = blocks.first(where: {$0.id == id })!
        let descendants = chapter.descendants ?? []
        var childs: [CourseSequential] = []
        for descend in descendants {
            let chapter = parseSequential(id: descend, courseId: courseId, blocks: blocks)
            childs.append(chapter)
        }
        return CourseChapter(
            blockId: chapter.blockId,
            id: chapter.id,
            displayName: chapter.displayName,
            type: BlockType(rawValue: chapter.type) ?? .unknown,
            childs: childs
        )
    }
    
    private func parseSequential(id: String, courseId: String, blocks: [DataLayer.CourseBlock]) -> CourseSequential {
        let sequential = blocks.first(where: {$0.id == id })!
        let descendants = sequential.descendants ?? []
        var childs: [CourseVertical] = []
        for descend in descendants {
            let vertical = parseVerticals(id: descend, courseId: courseId, blocks: blocks)
            childs.append(vertical)
        }
        return CourseSequential(
            blockId: sequential.blockId,
            id: sequential.id,
            displayName: sequential.displayName,
            type: BlockType(rawValue: sequential.type) ?? .unknown,
            completion: sequential.completion ?? 0,
            childs: childs
        )
    }
    
    private func parseVerticals(id: String, courseId: String, blocks: [DataLayer.CourseBlock]) -> CourseVertical {
        let sequential = blocks.first(where: {$0.id == id })!
        let descendants = sequential.descendants ?? []
        var childs: [CourseBlock] = []
        for descend in descendants {
            let block = parseBlock(id: descend, courseId: courseId, blocks: blocks)
            childs.append(block)
        }
        return CourseVertical(
            blockId: sequential.blockId,
            id: sequential.id,
            courseId: courseId,
            displayName: sequential.displayName,
            type: BlockType(rawValue: sequential.type) ?? .unknown,
            completion: sequential.completion ?? 0,
            childs: childs
        )
    }
    
    private func parseBlock(id: String, courseId: String, blocks: [DataLayer.CourseBlock]) -> CourseBlock {
        let block = blocks.first(where: {$0.id == id })!
        let subtitles = block.userViewData?.transcripts?.map {
            let url = $0.value
            return SubtitleUrl(language: $0.key, url: url)
        }
            
        return CourseBlock(blockId: block.blockId,
                           id: block.id,
                           courseId: courseId,
                           topicId: block.userViewData?.topicID,
                           graded: block.graded,
                           completion: block.completion ?? 0,
                           type: BlockType(rawValue: block.type) ?? .unknown,
                           displayName: block.displayName,
                           studentUrl: block.studentUrl,
                           subtitles: subtitles,
                           videoUrl: block.userViewData?.encodedVideo?.fallback?.url,
                           youTubeUrl: block.userViewData?.encodedVideo?.youTube?.url)
    }
    
    private let courseStructureJson: String = """
    {"root": "block-v1:QA+comparison+2022+type@course+block@course",
          "blocks": {
            "block-v1:QA+comparison+2022+type@comparison+block@be1704c576284ba39753c6f0ea4a4c78": {
              "id": "block-v1:QA+comparison+2022+type@comparison+block@be1704c576284ba39753c6f0ea4a4c78",
              "block_id": "be1704c576284ba39753c6f0ea4a4c78",
              "lms_web_url": "https://lms.lilac-vso-dev.raccoongang.com/courses/course-v1:QA+comparison+2022/jump_to/block-v1:QA+comparison+2022+type@comparison+block@be1704c576284ba39753c6f0ea4a4c78",
              "legacy_web_url": "https://lms.lilac-vso-dev.raccoongang.com/courses/course-v1:QA+comparison+2022/jump_to/block-v1:QA+comparison+2022+type@comparison+block@be1704c576284ba39753c6f0ea4a4c78?experience=legacy",
              "student_view_url": "https://lms.lilac-vso-dev.raccoongang.com/xblock/block-v1:QA+comparison+2022+type@comparison+block@be1704c576284ba39753c6f0ea4a4c78",
              "type": "comparison",
              "display_name": "Comparison",
              "graded": false,
              "student_view_multi_device": false,
              "block_counts": {
                "video": 0
              },
              "descendants": [
                
              ],
              "completion": 0.0
            },
            "block-v1:QA+comparison+2022+type@problem+block@93acc543871e4c73bc20a72a64e93296": {
              "id": "block-v1:QA+comparison+2022+type@problem+block@93acc543871e4c73bc20a72a64e93296",
              "block_id": "93acc543871e4c73bc20a72a64e93296",
              "lms_web_url": "https://lms.lilac-vso-dev.raccoongang.com/courses/course-v1:QA+comparison+2022/jump_to/block-v1:QA+comparison+2022+type@problem+block@93acc543871e4c73bc20a72a64e93296",
              "legacy_web_url": "https://lms.lilac-vso-dev.raccoongang.com/courses/course-v1:QA+comparison+2022/jump_to/block-v1:QA+comparison+2022+type@problem+block@93acc543871e4c73bc20a72a64e93296?experience=legacy",
              "student_view_url": "https://lms.lilac-vso-dev.raccoongang.com/xblock/block-v1:QA+comparison+2022+type@problem+block@93acc543871e4c73bc20a72a64e93296",
              "type": "problem",
              "display_name": "Dropdown with Hints and Feedback",
              "graded": false,
              "student_view_multi_device": true,
              "block_counts": {
                "video": 0
              },
              "descendants": [
                
              ],
              "completion": 0.0
            },
            "block-v1:QA+comparison+2022+type@comparison+block@06c17035106e48328ebcd042babcf47b": {
              "id": "block-v1:QA+comparison+2022+type@comparison+block@06c17035106e48328ebcd042babcf47b",
              "block_id": "06c17035106e48328ebcd042babcf47b",
              "lms_web_url": "https://lms.lilac-vso-dev.raccoongang.com/courses/course-v1:QA+comparison+2022/jump_to/block-v1:QA+comparison+2022+type@comparison+block@06c17035106e48328ebcd042babcf47b",
              "legacy_web_url": "https://lms.lilac-vso-dev.raccoongang.com/courses/course-v1:QA+comparison+2022/jump_to/block-v1:QA+comparison+2022+type@comparison+block@06c17035106e48328ebcd042babcf47b?experience=legacy",
              "student_view_url": "https://lms.lilac-vso-dev.raccoongang.com/xblock/block-v1:QA+comparison+2022+type@comparison+block@06c17035106e48328ebcd042babcf47b",
              "type": "comparison",
              "display_name": "Comparison",
              "graded": false,
              "student_view_multi_device": false,
              "block_counts": {
                "video": 0
              },
              "descendants": [
                
              ],
              "completion": 0.0
            },
            "block-v1:QA+comparison+2022+type@problem+block@c19e41b61db14efe9c45f1354332ae58": {
              "id": "block-v1:QA+comparison+2022+type@problem+block@c19e41b61db14efe9c45f1354332ae58",
              "block_id": "c19e41b61db14efe9c45f1354332ae58",
              "lms_web_url": "https://lms.lilac-vso-dev.raccoongang.com/courses/course-v1:QA+comparison+2022/jump_to/block-v1:QA+comparison+2022+type@problem+block@c19e41b61db14efe9c45f1354332ae58",
              "legacy_web_url": "https://lms.lilac-vso-dev.raccoongang.com/courses/course-v1:QA+comparison+2022/jump_to/block-v1:QA+comparison+2022+type@problem+block@c19e41b61db14efe9c45f1354332ae58?experience=legacy",
              "student_view_url": "https://lms.lilac-vso-dev.raccoongang.com/xblock/block-v1:QA+comparison+2022+type@problem+block@c19e41b61db14efe9c45f1354332ae58",
              "type": "problem",
              "display_name": "Text Input with Hints and Feedback",
              "graded": false,
              "student_view_multi_device": true,
              "block_counts": {
                "video": 0
              },
              "descendants": [
                
              ],
              "completion": 0.0
            },
            "block-v1:QA+comparison+2022+type@problem+block@0d96732f577b4ff68799faf8235d1bfb": {
              "id": "block-v1:QA+comparison+2022+type@problem+block@0d96732f577b4ff68799faf8235d1bfb",
              "block_id": "0d96732f577b4ff68799faf8235d1bfb",
              "lms_web_url": "https://lms.lilac-vso-dev.raccoongang.com/courses/course-v1:QA+comparison+2022/jump_to/block-v1:QA+comparison+2022+type@problem+block@0d96732f577b4ff68799faf8235d1bfb",
              "legacy_web_url": "https://lms.lilac-vso-dev.raccoongang.com/courses/course-v1:QA+comparison+2022/jump_to/block-v1:QA+comparison+2022+type@problem+block@0d96732f577b4ff68799faf8235d1bfb?experience=legacy",
              "student_view_url": "https://lms.lilac-vso-dev.raccoongang.com/xblock/block-v1:QA+comparison+2022+type@problem+block@0d96732f577b4ff68799faf8235d1bfb",
              "type": "problem",
              "display_name": "Numerical Input with Hints and Feedback",
              "graded": false,
              "student_view_multi_device": true,
              "block_counts": {
                "video": 0
              },
              "descendants": [
                
              ],
              "completion": 0.0
            },
            "block-v1:QA+comparison+2022+type@problem+block@dd2e22fdf0724bd88c8b2e6b68dedd96": {
              "id": "block-v1:QA+comparison+2022+type@problem+block@dd2e22fdf0724bd88c8b2e6b68dedd96",
              "block_id": "dd2e22fdf0724bd88c8b2e6b68dedd96",
              "lms_web_url": "https://lms.lilac-vso-dev.raccoongang.com/courses/course-v1:QA+comparison+2022/jump_to/block-v1:QA+comparison+2022+type@problem+block@dd2e22fdf0724bd88c8b2e6b68dedd96",
              "legacy_web_url": "https://lms.lilac-vso-dev.raccoongang.com/courses/course-v1:QA+comparison+2022/jump_to/block-v1:QA+comparison+2022+type@problem+block@dd2e22fdf0724bd88c8b2e6b68dedd96?experience=legacy",
              "student_view_url": "https://lms.lilac-vso-dev.raccoongang.com/xblock/block-v1:QA+comparison+2022+type@problem+block@dd2e22fdf0724bd88c8b2e6b68dedd96",
              "type": "problem",
              "display_name": "Blank Common Problem",
              "graded": false,
              "student_view_multi_device": true,
              "block_counts": {
                "video": 0
              },
              "descendants": [
                
              ],
              "completion": 0.0
            },
            "block-v1:QA+comparison+2022+type@problem+block@d1e091aa305741c5bedfafed0d269efd": {
              "id": "block-v1:QA+comparison+2022+type@problem+block@d1e091aa305741c5bedfafed0d269efd",
              "block_id": "d1e091aa305741c5bedfafed0d269efd",
              "lms_web_url": "https://lms.lilac-vso-dev.raccoongang.com/courses/course-v1:QA+comparison+2022/jump_to/block-v1:QA+comparison+2022+type@problem+block@d1e091aa305741c5bedfafed0d269efd",
              "legacy_web_url": "https://lms.lilac-vso-dev.raccoongang.com/courses/course-v1:QA+comparison+2022/jump_to/block-v1:QA+comparison+2022+type@problem+block@d1e091aa305741c5bedfafed0d269efd?experience=legacy",
              "student_view_url": "https://lms.lilac-vso-dev.raccoongang.com/xblock/block-v1:QA+comparison+2022+type@problem+block@d1e091aa305741c5bedfafed0d269efd",
              "type": "problem",
              "display_name": "Blank Common Problem",
              "graded": false,
              "student_view_multi_device": true,
              "block_counts": {
                "video": 0
              },
              "descendants": [
                
              ],
              "completion": 0.0
            },
            "block-v1:QA+comparison+2022+type@comparison+block@23e10dea806345b19b77997b4fc0eea7": {
              "id": "block-v1:QA+comparison+2022+type@comparison+block@23e10dea806345b19b77997b4fc0eea7",
              "block_id": "23e10dea806345b19b77997b4fc0eea7",
              "lms_web_url": "https://lms.lilac-vso-dev.raccoongang.com/courses/course-v1:QA+comparison+2022/jump_to/block-v1:QA+comparison+2022+type@comparison+block@23e10dea806345b19b77997b4fc0eea7",
              "legacy_web_url": "https://lms.lilac-vso-dev.raccoongang.com/courses/course-v1:QA+comparison+2022/jump_to/block-v1:QA+comparison+2022+type@comparison+block@23e10dea806345b19b77997b4fc0eea7?experience=legacy",
              "student_view_url": "https://lms.lilac-vso-dev.raccoongang.com/xblock/block-v1:QA+comparison+2022+type@comparison+block@23e10dea806345b19b77997b4fc0eea7",
              "type": "comparison",
              "display_name": "Comparison",
              "graded": false,
              "student_view_multi_device": false,
              "block_counts": {
                "video": 0
              },
              "descendants": [
                
              ],
              "completion": 0.0
            },
            "block-v1:QA+comparison+2022+type@vertical+block@29e7eddbe8964770896e4036748c9904": {
              "id": "block-v1:QA+comparison+2022+type@vertical+block@29e7eddbe8964770896e4036748c9904",
              "block_id": "29e7eddbe8964770896e4036748c9904",
              "lms_web_url": "https://lms.lilac-vso-dev.raccoongang.com/courses/course-v1:QA+comparison+2022/jump_to/block-v1:QA+comparison+2022+type@vertical+block@29e7eddbe8964770896e4036748c9904",
              "legacy_web_url": "https://lms.lilac-vso-dev.raccoongang.com/courses/course-v1:QA+comparison+2022/jump_to/block-v1:QA+comparison+2022+type@vertical+block@29e7eddbe8964770896e4036748c9904?experience=legacy",
              "student_view_url": "https://lms.lilac-vso-dev.raccoongang.com/xblock/block-v1:QA+comparison+2022+type@vertical+block@29e7eddbe8964770896e4036748c9904",
              "type": "vertical",
              "display_name": "Unit",
              "graded": false,
              "student_view_multi_device": false,
              "block_counts": {
                "video": 0
              },
              "descendants": [
                "block-v1:QA+comparison+2022+type@comparison+block@be1704c576284ba39753c6f0ea4a4c78",
                "block-v1:QA+comparison+2022+type@problem+block@93acc543871e4c73bc20a72a64e93296",
                "block-v1:QA+comparison+2022+type@comparison+block@06c17035106e48328ebcd042babcf47b",
                "block-v1:QA+comparison+2022+type@problem+block@c19e41b61db14efe9c45f1354332ae58",
                "block-v1:QA+comparison+2022+type@problem+block@0d96732f577b4ff68799faf8235d1bfb",
                "block-v1:QA+comparison+2022+type@problem+block@dd2e22fdf0724bd88c8b2e6b68dedd96",
                "block-v1:QA+comparison+2022+type@problem+block@d1e091aa305741c5bedfafed0d269efd",
                "block-v1:QA+comparison+2022+type@comparison+block@23e10dea806345b19b77997b4fc0eea7"
              ],
              "completion": 0
            },
            "block-v1:QA+comparison+2022+type@sequential+block@f468bb5c6e8641179e523c7fcec4e6d6": {
              "id": "block-v1:QA+comparison+2022+type@sequential+block@f468bb5c6e8641179e523c7fcec4e6d6",
              "block_id": "f468bb5c6e8641179e523c7fcec4e6d6",
              "lms_web_url": "https://lms.lilac-vso-dev.raccoongang.com/courses/course-v1:QA+comparison+2022/jump_to/block-v1:QA+comparison+2022+type@sequential+block@f468bb5c6e8641179e523c7fcec4e6d6",
              "legacy_web_url": "https://lms.lilac-vso-dev.raccoongang.com/courses/course-v1:QA+comparison+2022/jump_to/block-v1:QA+comparison+2022+type@sequential+block@f468bb5c6e8641179e523c7fcec4e6d6?experience=legacy",
              "student_view_url": "https://lms.lilac-vso-dev.raccoongang.com/xblock/block-v1:QA+comparison+2022+type@sequential+block@f468bb5c6e8641179e523c7fcec4e6d6",
              "type": "sequential",
              "display_name": "Subsection",
              "graded": false,
              "student_view_multi_device": false,
              "block_counts": {
                "video": 0
              },
              "descendants": [
                "block-v1:QA+comparison+2022+type@vertical+block@29e7eddbe8964770896e4036748c9904"
              ],
              "completion": 0
            },
            "block-v1:QA+comparison+2022+type@problem+block@eaf91d8fc70547339402043ba1a1c234": {
              "id": "block-v1:QA+comparison+2022+type@problem+block@eaf91d8fc70547339402043ba1a1c234",
              "block_id": "eaf91d8fc70547339402043ba1a1c234",
              "lms_web_url": "https://lms.lilac-vso-dev.raccoongang.com/courses/course-v1:QA+comparison+2022/jump_to/block-v1:QA+comparison+2022+type@problem+block@eaf91d8fc70547339402043ba1a1c234",
              "legacy_web_url": "https://lms.lilac-vso-dev.raccoongang.com/courses/course-v1:QA+comparison+2022/jump_to/block-v1:QA+comparison+2022+type@problem+block@eaf91d8fc70547339402043ba1a1c234?experience=legacy",
              "student_view_url": "https://lms.lilac-vso-dev.raccoongang.com/xblock/block-v1:QA+comparison+2022+type@problem+block@eaf91d8fc70547339402043ba1a1c234",
              "type": "problem",
              "display_name": "Dropdown with Hints and Feedback",
              "graded": false,
              "student_view_multi_device": true,
              "block_counts": {
                "video": 0
              },
              "descendants": [
                
              ],
              "completion": 0.0
            },
            "block-v1:QA+comparison+2022+type@comparison+block@fac531c3f1f3400cb8e3b97eb2c3d751": {
              "id": "block-v1:QA+comparison+2022+type@comparison+block@fac531c3f1f3400cb8e3b97eb2c3d751",
              "block_id": "fac531c3f1f3400cb8e3b97eb2c3d751",
              "lms_web_url": "https://lms.lilac-vso-dev.raccoongang.com/courses/course-v1:QA+comparison+2022/jump_to/block-v1:QA+comparison+2022+type@comparison+block@fac531c3f1f3400cb8e3b97eb2c3d751",
              "legacy_web_url": "https://lms.lilac-vso-dev.raccoongang.com/courses/course-v1:QA+comparison+2022/jump_to/block-v1:QA+comparison+2022+type@comparison+block@fac531c3f1f3400cb8e3b97eb2c3d751?experience=legacy",
              "student_view_url": "https://lms.lilac-vso-dev.raccoongang.com/xblock/block-v1:QA+comparison+2022+type@comparison+block@fac531c3f1f3400cb8e3b97eb2c3d751",
              "type": "comparison",
              "display_name": "Comparison",
              "graded": false,
              "student_view_multi_device": false,
              "block_counts": {
                "video": 0
              },
              "descendants": [
                
              ],
              "completion": 0.0
            },
            "block-v1:QA+comparison+2022+type@html+block@74a1074024fe401ea305534f2241e5de": {
              "id": "block-v1:QA+comparison+2022+type@html+block@74a1074024fe401ea305534f2241e5de",
              "block_id": "74a1074024fe401ea305534f2241e5de",
              "lms_web_url": "https://lms.lilac-vso-dev.raccoongang.com/courses/course-v1:QA+comparison+2022/jump_to/block-v1:QA+comparison+2022+type@html+block@74a1074024fe401ea305534f2241e5de",
              "legacy_web_url": "https://lms.lilac-vso-dev.raccoongang.com/courses/course-v1:QA+comparison+2022/jump_to/block-v1:QA+comparison+2022+type@html+block@74a1074024fe401ea305534f2241e5de?experience=legacy",
              "student_view_url": "https://lms.lilac-vso-dev.raccoongang.com/xblock/block-v1:QA+comparison+2022+type@html+block@74a1074024fe401ea305534f2241e5de",
              "type": "html",
              "display_name": "Raw HTML",
              "graded": false,
              "student_view_data": {
                "last_modified": "2023-05-04T19:08:07Z",
                "html_data": "https://s3.eu-central-1.amazonaws.com/vso-dev-edx-sorage/htmlxblock/QA/comparison/html/74a1074024fe401ea305534f2241e5de/content_html.zip",
                "size": 576,
                "index_page": "index.html",
                "icon_class": "other"
              },
              "student_view_multi_device": true,
              "block_counts": {
                "video": 0
              },
              "descendants": [
                
              ],
              "completion": 0.0
            },
            "block-v1:QA+comparison+2022+type@vertical+block@e5b2e105f4f947c5b76fb12c35da1eca": {
              "id": "block-v1:QA+comparison+2022+type@vertical+block@e5b2e105f4f947c5b76fb12c35da1eca",
              "block_id": "e5b2e105f4f947c5b76fb12c35da1eca",
              "lms_web_url": "https://lms.lilac-vso-dev.raccoongang.com/courses/course-v1:QA+comparison+2022/jump_to/block-v1:QA+comparison+2022+type@vertical+block@e5b2e105f4f947c5b76fb12c35da1eca",
              "legacy_web_url": "https://lms.lilac-vso-dev.raccoongang.com/courses/course-v1:QA+comparison+2022/jump_to/block-v1:QA+comparison+2022+type@vertical+block@e5b2e105f4f947c5b76fb12c35da1eca?experience=legacy",
              "student_view_url": "https://lms.lilac-vso-dev.raccoongang.com/xblock/block-v1:QA+comparison+2022+type@vertical+block@e5b2e105f4f947c5b76fb12c35da1eca",
              "type": "vertical",
              "display_name": "Unit",
              "graded": false,
              "student_view_multi_device": false,
              "block_counts": {
                "video": 0
              },
              "descendants": [
                "block-v1:QA+comparison+2022+type@problem+block@eaf91d8fc70547339402043ba1a1c234",
                "block-v1:QA+comparison+2022+type@comparison+block@fac531c3f1f3400cb8e3b97eb2c3d751",
                "block-v1:QA+comparison+2022+type@html+block@74a1074024fe401ea305534f2241e5de"
              ],
              "completion": 0
            },
            "block-v1:QA+comparison+2022+type@sequential+block@d37cb0c5c2d24ddaacf3494760a055f2": {
              "id": "block-v1:QA+comparison+2022+type@sequential+block@d37cb0c5c2d24ddaacf3494760a055f2",
              "block_id": "d37cb0c5c2d24ddaacf3494760a055f2",
              "lms_web_url": "https://lms.lilac-vso-dev.raccoongang.com/courses/course-v1:QA+comparison+2022/jump_to/block-v1:QA+comparison+2022+type@sequential+block@d37cb0c5c2d24ddaacf3494760a055f2",
              "legacy_web_url": "https://lms.lilac-vso-dev.raccoongang.com/courses/course-v1:QA+comparison+2022/jump_to/block-v1:QA+comparison+2022+type@sequential+block@d37cb0c5c2d24ddaacf3494760a055f2?experience=legacy",
              "student_view_url": "https://lms.lilac-vso-dev.raccoongang.com/xblock/block-v1:QA+comparison+2022+type@sequential+block@d37cb0c5c2d24ddaacf3494760a055f2",
              "type": "sequential",
              "display_name": "Another one subsection",
              "graded": false,
              "student_view_multi_device": false,
              "block_counts": {
                "video": 0
              },
              "descendants": [
                "block-v1:QA+comparison+2022+type@vertical+block@e5b2e105f4f947c5b76fb12c35da1eca"
              ],
              "completion": 0
            },
            "block-v1:QA+comparison+2022+type@chapter+block@abecaefe203c4c93b441d16cea3b7846": {
              "id": "block-v1:QA+comparison+2022+type@chapter+block@abecaefe203c4c93b441d16cea3b7846",
              "block_id": "abecaefe203c4c93b441d16cea3b7846",
              "lms_web_url": "https://lms.lilac-vso-dev.raccoongang.com/courses/course-v1:QA+comparison+2022/jump_to/block-v1:QA+comparison+2022+type@chapter+block@abecaefe203c4c93b441d16cea3b7846",
              "legacy_web_url": "https://lms.lilac-vso-dev.raccoongang.com/courses/course-v1:QA+comparison+2022/jump_to/block-v1:QA+comparison+2022+type@chapter+block@abecaefe203c4c93b441d16cea3b7846?experience=legacy",
              "student_view_url": "https://lms.lilac-vso-dev.raccoongang.com/xblock/block-v1:QA+comparison+2022+type@chapter+block@abecaefe203c4c93b441d16cea3b7846",
              "type": "chapter",
              "display_name": "Section",
              "graded": false,
              "student_view_multi_device": false,
              "block_counts": {
                "video": 0
              },
              "descendants": [
                "block-v1:QA+comparison+2022+type@sequential+block@f468bb5c6e8641179e523c7fcec4e6d6",
                "block-v1:QA+comparison+2022+type@sequential+block@d37cb0c5c2d24ddaacf3494760a055f2"
              ],
              "completion": 0
            },
            "block-v1:QA+comparison+2022+type@pdf+block@a0c3ac29daab425f92a34b34eb2af9de": {
              "id": "block-v1:QA+comparison+2022+type@pdf+block@a0c3ac29daab425f92a34b34eb2af9de",
              "block_id": "a0c3ac29daab425f92a34b34eb2af9de",
              "lms_web_url": "https://lms.lilac-vso-dev.raccoongang.com/courses/course-v1:QA+comparison+2022/jump_to/block-v1:QA+comparison+2022+type@pdf+block@a0c3ac29daab425f92a34b34eb2af9de",
              "legacy_web_url": "https://lms.lilac-vso-dev.raccoongang.com/courses/course-v1:QA+comparison+2022/jump_to/block-v1:QA+comparison+2022+type@pdf+block@a0c3ac29daab425f92a34b34eb2af9de?experience=legacy",
              "student_view_url": "https://lms.lilac-vso-dev.raccoongang.com/xblock/block-v1:QA+comparison+2022+type@pdf+block@a0c3ac29daab425f92a34b34eb2af9de",
              "type": "pdf",
              "display_name": "PDF title",
              "graded": false,
              "student_view_data": {
                "last_modified": "2023-04-26T08:43:45Z",
                "url": "https://www.adobe.com/support/products/enterprise/knowledgecenter/media/c4611_sample_explain.pdf",
              },
              "student_view_multi_device": false,
              "block_counts": {
                "video": 0
              },
              "descendants": [
                
              ],
              "completion": 0.0
            },
            "block-v1:QA+comparison+2022+type@pdf+block@bcd1b0f3015b4d3696b12f65a5d682f9": {
              "id": "block-v1:QA+comparison+2022+type@pdf+block@bcd1b0f3015b4d3696b12f65a5d682f9",
              "block_id": "bcd1b0f3015b4d3696b12f65a5d682f9",
              "lms_web_url": "https://lms.lilac-vso-dev.raccoongang.com/courses/course-v1:QA+comparison+2022/jump_to/block-v1:QA+comparison+2022+type@pdf+block@bcd1b0f3015b4d3696b12f65a5d682f9",
              "legacy_web_url": "https://lms.lilac-vso-dev.raccoongang.com/courses/course-v1:QA+comparison+2022/jump_to/block-v1:QA+comparison+2022+type@pdf+block@bcd1b0f3015b4d3696b12f65a5d682f9?experience=legacy",
              "student_view_url": "https://lms.lilac-vso-dev.raccoongang.com/xblock/block-v1:QA+comparison+2022+type@pdf+block@bcd1b0f3015b4d3696b12f65a5d682f9",
              "type": "pdf",
              "display_name": "PDF",
              "graded": false,
              "student_view_data": {
                "last_modified": "2023-04-26T08:43:45Z",
                "url": "https://www.adobe.com/support/products/enterprise/knowledgecenter/media/c4611_sample_explain.pdf",
              },
              "student_view_multi_device": false,
              "block_counts": {
                "video": 0
              },
              "descendants": [
                
              ],
              "completion": 0.0
            },
            "block-v1:QA+comparison+2022+type@pdf+block@67d805daade34bd4b6ace607e6d48f59": {
              "id": "block-v1:QA+comparison+2022+type@pdf+block@67d805daade34bd4b6ace607e6d48f59",
              "block_id": "67d805daade34bd4b6ace607e6d48f59",
              "lms_web_url": "https://lms.lilac-vso-dev.raccoongang.com/courses/course-v1:QA+comparison+2022/jump_to/block-v1:QA+comparison+2022+type@pdf+block@67d805daade34bd4b6ace607e6d48f59",
              "legacy_web_url": "https://lms.lilac-vso-dev.raccoongang.com/courses/course-v1:QA+comparison+2022/jump_to/block-v1:QA+comparison+2022+type@pdf+block@67d805daade34bd4b6ace607e6d48f59?experience=legacy",
              "student_view_url": "https://lms.lilac-vso-dev.raccoongang.com/xblock/block-v1:QA+comparison+2022+type@pdf+block@67d805daade34bd4b6ace607e6d48f59",
              "type": "pdf",
              "display_name": "PDF",
              "graded": false,
              "student_view_data": {
                "last_modified": "2023-04-26T08:43:45Z",
                "url": "https://www.adobe.com/support/products/enterprise/knowledgecenter/media/c4611_sample_explain.pdf",
              },
              "student_view_multi_device": false,
              "block_counts": {
                "video": 0
              },
              "descendants": [
                
              ],
              "completion": 0.0
            },
            "block-v1:QA+comparison+2022+type@pdf+block@828606a51f4e44198e92f86a45be7974": {
              "id": "block-v1:QA+comparison+2022+type@pdf+block@828606a51f4e44198e92f86a45be7974",
              "block_id": "828606a51f4e44198e92f86a45be7974",
              "lms_web_url": "https://lms.lilac-vso-dev.raccoongang.com/courses/course-v1:QA+comparison+2022/jump_to/block-v1:QA+comparison+2022+type@pdf+block@828606a51f4e44198e92f86a45be7974",
              "legacy_web_url": "https://lms.lilac-vso-dev.raccoongang.com/courses/course-v1:QA+comparison+2022/jump_to/block-v1:QA+comparison+2022+type@pdf+block@828606a51f4e44198e92f86a45be7974?experience=legacy",
              "student_view_url": "https://lms.lilac-vso-dev.raccoongang.com/xblock/block-v1:QA+comparison+2022+type@pdf+block@828606a51f4e44198e92f86a45be7974",
              "type": "pdf",
              "display_name": "PDF",
              "graded": false,
              "student_view_data": {
                "last_modified": "2023-04-26T08:43:45Z",
                "url": "https://www.adobe.com/support/products/enterprise/knowledgecenter/media/c4611_sample_explain.pdf",
              },
              "student_view_multi_device": false,
              "block_counts": {
                "video": 0
              },
              "descendants": [
                
              ],
              "completion": 0.0
            },
            "block-v1:QA+comparison+2022+type@pdf+block@8646c3bc2184467b86e5ef01ecd452ee": {
              "id": "block-v1:QA+comparison+2022+type@pdf+block@8646c3bc2184467b86e5ef01ecd452ee",
              "block_id": "8646c3bc2184467b86e5ef01ecd452ee",
              "lms_web_url": "https://lms.lilac-vso-dev.raccoongang.com/courses/course-v1:QA+comparison+2022/jump_to/block-v1:QA+comparison+2022+type@pdf+block@8646c3bc2184467b86e5ef01ecd452ee",
              "legacy_web_url": "https://lms.lilac-vso-dev.raccoongang.com/courses/course-v1:QA+comparison+2022/jump_to/block-v1:QA+comparison+2022+type@pdf+block@8646c3bc2184467b86e5ef01ecd452ee?experience=legacy",
              "student_view_url": "https://lms.lilac-vso-dev.raccoongang.com/xblock/block-v1:QA+comparison+2022+type@pdf+block@8646c3bc2184467b86e5ef01ecd452ee",
              "type": "pdf",
              "display_name": "PDF",
              "graded": false,
              "student_view_data": {
                "last_modified": "2023-04-26T08:43:45Z",
                "url": "https://www.adobe.com/support/products/enterprise/knowledgecenter/media/c4611_sample_explain.pdf",
              },
              "student_view_multi_device": false,
              "block_counts": {
                "video": 0
              },
              "descendants": [
                
              ],
              "completion": 0.0
            },
            "block-v1:QA+comparison+2022+type@vertical+block@e2faa0e62223489e91a41700865c5fc1": {
              "id": "block-v1:QA+comparison+2022+type@vertical+block@e2faa0e62223489e91a41700865c5fc1",
              "block_id": "e2faa0e62223489e91a41700865c5fc1",
              "lms_web_url": "https://lms.lilac-vso-dev.raccoongang.com/courses/course-v1:QA+comparison+2022/jump_to/block-v1:QA+comparison+2022+type@vertical+block@e2faa0e62223489e91a41700865c5fc1",
              "legacy_web_url": "https://lms.lilac-vso-dev.raccoongang.com/courses/course-v1:QA+comparison+2022/jump_to/block-v1:QA+comparison+2022+type@vertical+block@e2faa0e62223489e91a41700865c5fc1?experience=legacy",
              "student_view_url": "https://lms.lilac-vso-dev.raccoongang.com/xblock/block-v1:QA+comparison+2022+type@vertical+block@e2faa0e62223489e91a41700865c5fc1",
              "type": "vertical",
              "display_name": "Unit",
              "graded": false,
              "student_view_multi_device": false,
              "block_counts": {
                "video": 0
              },
              "descendants": [
                "block-v1:QA+comparison+2022+type@pdf+block@a0c3ac29daab425f92a34b34eb2af9de",
                "block-v1:QA+comparison+2022+type@pdf+block@bcd1b0f3015b4d3696b12f65a5d682f9",
                "block-v1:QA+comparison+2022+type@pdf+block@67d805daade34bd4b6ace607e6d48f59",
                "block-v1:QA+comparison+2022+type@pdf+block@828606a51f4e44198e92f86a45be7974",
                "block-v1:QA+comparison+2022+type@pdf+block@8646c3bc2184467b86e5ef01ecd452ee"
              ],
              "completion": 0
            },
            "block-v1:QA+comparison+2022+type@problem+block@0c5e89fa6d7a4fac8f7b26f2ca0bbe52": {
              "id": "block-v1:QA+comparison+2022+type@problem+block@0c5e89fa6d7a4fac8f7b26f2ca0bbe52",
              "block_id": "0c5e89fa6d7a4fac8f7b26f2ca0bbe52",
              "lms_web_url": "https://lms.lilac-vso-dev.raccoongang.com/courses/course-v1:QA+comparison+2022/jump_to/block-v1:QA+comparison+2022+type@problem+block@0c5e89fa6d7a4fac8f7b26f2ca0bbe52",
              "legacy_web_url": "https://lms.lilac-vso-dev.raccoongang.com/courses/course-v1:QA+comparison+2022/jump_to/block-v1:QA+comparison+2022+type@problem+block@0c5e89fa6d7a4fac8f7b26f2ca0bbe52?experience=legacy",
              "student_view_url": "https://lms.lilac-vso-dev.raccoongang.com/xblock/block-v1:QA+comparison+2022+type@problem+block@0c5e89fa6d7a4fac8f7b26f2ca0bbe52",
              "type": "problem",
              "display_name": "Checkboxes with Hints and Feedback",
              "graded": false,
              "student_view_multi_device": true,
              "block_counts": {
                "video": 0
              },
              "descendants": [
                
              ],
              "completion": 0.0
            },
            "block-v1:QA+comparison+2022+type@vertical+block@8ba437d8b20d416d91a2d362b0c940a4": {
              "id": "block-v1:QA+comparison+2022+type@vertical+block@8ba437d8b20d416d91a2d362b0c940a4",
              "block_id": "8ba437d8b20d416d91a2d362b0c940a4",
              "lms_web_url": "https://lms.lilac-vso-dev.raccoongang.com/courses/course-v1:QA+comparison+2022/jump_to/block-v1:QA+comparison+2022+type@vertical+block@8ba437d8b20d416d91a2d362b0c940a4",
              "legacy_web_url": "https://lms.lilac-vso-dev.raccoongang.com/courses/course-v1:QA+comparison+2022/jump_to/block-v1:QA+comparison+2022+type@vertical+block@8ba437d8b20d416d91a2d362b0c940a4?experience=legacy",
              "student_view_url": "https://lms.lilac-vso-dev.raccoongang.com/xblock/block-v1:QA+comparison+2022+type@vertical+block@8ba437d8b20d416d91a2d362b0c940a4",
              "type": "vertical",
              "display_name": "Unit",
              "graded": false,
              "student_view_multi_device": false,
              "block_counts": {
                "video": 0
              },
              "descendants": [
                "block-v1:QA+comparison+2022+type@problem+block@0c5e89fa6d7a4fac8f7b26f2ca0bbe52"
              ],
              "completion": 0
            },
            "block-v1:QA+comparison+2022+type@pdf+block@021f70794f7349998e190b060260b70d": {
              "id": "block-v1:QA+comparison+2022+type@pdf+block@021f70794f7349998e190b060260b70d",
              "block_id": "021f70794f7349998e190b060260b70d",
              "lms_web_url": "https://lms.lilac-vso-dev.raccoongang.com/courses/course-v1:QA+comparison+2022/jump_to/block-v1:QA+comparison+2022+type@pdf+block@021f70794f7349998e190b060260b70d",
              "legacy_web_url": "https://lms.lilac-vso-dev.raccoongang.com/courses/course-v1:QA+comparison+2022/jump_to/block-v1:QA+comparison+2022+type@pdf+block@021f70794f7349998e190b060260b70d?experience=legacy",
              "student_view_url": "https://lms.lilac-vso-dev.raccoongang.com/xblock/block-v1:QA+comparison+2022+type@pdf+block@021f70794f7349998e190b060260b70d",
              "type": "pdf",
              "display_name": "PDF",
              "graded": false,
              "student_view_data": {
                "last_modified": "2023-04-26T08:43:45Z",
                "url": "https://www.adobe.com/support/products/enterprise/knowledgecenter/media/c4611_sample_explain.pdf",
              },
              "student_view_multi_device": false,
              "block_counts": {
                "video": 0
              },
              "descendants": [
                
              ],
              "completion": 0.0
            },
            "block-v1:QA+comparison+2022+type@vertical+block@2c344115d3554ac58c140ec86e591aa1": {
              "id": "block-v1:QA+comparison+2022+type@vertical+block@2c344115d3554ac58c140ec86e591aa1",
              "block_id": "2c344115d3554ac58c140ec86e591aa1",
              "lms_web_url": "https://lms.lilac-vso-dev.raccoongang.com/courses/course-v1:QA+comparison+2022/jump_to/block-v1:QA+comparison+2022+type@vertical+block@2c344115d3554ac58c140ec86e591aa1",
              "legacy_web_url": "https://lms.lilac-vso-dev.raccoongang.com/courses/course-v1:QA+comparison+2022/jump_to/block-v1:QA+comparison+2022+type@vertical+block@2c344115d3554ac58c140ec86e591aa1?experience=legacy",
              "student_view_url": "https://lms.lilac-vso-dev.raccoongang.com/xblock/block-v1:QA+comparison+2022+type@vertical+block@2c344115d3554ac58c140ec86e591aa1",
              "type": "vertical",
              "display_name": "Unit",
              "graded": false,
              "student_view_multi_device": false,
              "block_counts": {
                "video": 0
              },
              "descendants": [
                "block-v1:QA+comparison+2022+type@pdf+block@021f70794f7349998e190b060260b70d"
              ],
              "completion": 0
            },
            "block-v1:QA+comparison+2022+type@sequential+block@6c9c6ba663b54c0eb9cbdcd0c6b4bebe": {
              "id": "block-v1:QA+comparison+2022+type@sequential+block@6c9c6ba663b54c0eb9cbdcd0c6b4bebe",
              "block_id": "6c9c6ba663b54c0eb9cbdcd0c6b4bebe",
              "lms_web_url": "https://lms.lilac-vso-dev.raccoongang.com/courses/course-v1:QA+comparison+2022/jump_to/block-v1:QA+comparison+2022+type@sequential+block@6c9c6ba663b54c0eb9cbdcd0c6b4bebe",
              "legacy_web_url": "https://lms.lilac-vso-dev.raccoongang.com/courses/course-v1:QA+comparison+2022/jump_to/block-v1:QA+comparison+2022+type@sequential+block@6c9c6ba663b54c0eb9cbdcd0c6b4bebe?experience=legacy",
              "student_view_url": "https://lms.lilac-vso-dev.raccoongang.com/xblock/block-v1:QA+comparison+2022+type@sequential+block@6c9c6ba663b54c0eb9cbdcd0c6b4bebe",
              "type": "sequential",
              "display_name": "Subsection",
              "graded": false,
              "student_view_multi_device": false,
              "block_counts": {
                "video": 0
              },
              "descendants": [
                "block-v1:QA+comparison+2022+type@vertical+block@e2faa0e62223489e91a41700865c5fc1",
                "block-v1:QA+comparison+2022+type@vertical+block@8ba437d8b20d416d91a2d362b0c940a4",
                "block-v1:QA+comparison+2022+type@vertical+block@2c344115d3554ac58c140ec86e591aa1"
              ],
              "completion": 0
            },
            "block-v1:QA+comparison+2022+type@chapter+block@d5a4f1f2f5314288aae400c270fb03f7": {
              "id": "block-v1:QA+comparison+2022+type@chapter+block@d5a4f1f2f5314288aae400c270fb03f7",
              "block_id": "d5a4f1f2f5314288aae400c270fb03f7",
              "lms_web_url": "https://lms.lilac-vso-dev.raccoongang.com/courses/course-v1:QA+comparison+2022/jump_to/block-v1:QA+comparison+2022+type@chapter+block@d5a4f1f2f5314288aae400c270fb03f7",
              "legacy_web_url": "https://lms.lilac-vso-dev.raccoongang.com/courses/course-v1:QA+comparison+2022/jump_to/block-v1:QA+comparison+2022+type@chapter+block@d5a4f1f2f5314288aae400c270fb03f7?experience=legacy",
              "student_view_url": "https://lms.lilac-vso-dev.raccoongang.com/xblock/block-v1:QA+comparison+2022+type@chapter+block@d5a4f1f2f5314288aae400c270fb03f7",
              "type": "chapter",
              "display_name": "PDF",
              "graded": false,
              "student_view_multi_device": false,
              "block_counts": {
                "video": 0
              },
              "descendants": [
                "block-v1:QA+comparison+2022+type@sequential+block@6c9c6ba663b54c0eb9cbdcd0c6b4bebe"
              ],
              "completion": 0
            },
            "block-v1:QA+comparison+2022+type@chapter+block@7ab45affb80f4846a60648ec6aff9fbf": {
              "id": "block-v1:QA+comparison+2022+type@chapter+block@7ab45affb80f4846a60648ec6aff9fbf",
              "block_id": "7ab45affb80f4846a60648ec6aff9fbf",
              "lms_web_url": "https://lms.lilac-vso-dev.raccoongang.com/courses/course-v1:QA+comparison+2022/jump_to/block-v1:QA+comparison+2022+type@chapter+block@7ab45affb80f4846a60648ec6aff9fbf",
              "legacy_web_url": "https://lms.lilac-vso-dev.raccoongang.com/courses/course-v1:QA+comparison+2022/jump_to/block-v1:QA+comparison+2022+type@chapter+block@7ab45affb80f4846a60648ec6aff9fbf?experience=legacy",
              "student_view_url": "https://lms.lilac-vso-dev.raccoongang.com/xblock/block-v1:QA+comparison+2022+type@chapter+block@7ab45affb80f4846a60648ec6aff9fbf",
              "type": "chapter",
              "display_name": "Section",
              "graded": false,
              "student_view_multi_device": false,
              "block_counts": {
                "video": 0
              },
              "descendants": [
                
              ]
            },
            "block-v1:QA+comparison+2022+type@course+block@course": {
              "id": "block-v1:QA+comparison+2022+type@course+block@course",
              "block_id": "course",
              "lms_web_url": "https://lms.lilac-vso-dev.raccoongang.com/courses/course-v1:QA+comparison+2022/jump_to/block-v1:QA+comparison+2022+type@course+block@course",
              "legacy_web_url": "https://lms.lilac-vso-dev.raccoongang.com/courses/course-v1:QA+comparison+2022/jump_to/block-v1:QA+comparison+2022+type@course+block@course?experience=legacy",
              "student_view_url": "https://lms.lilac-vso-dev.raccoongang.com/xblock/block-v1:QA+comparison+2022+type@course+block@course",
              "type": "course",
              "display_name": "Comparison xblock test coursre",
              "graded": false,
              "student_view_multi_device": false,
              "block_counts": {
                "video": 0
              },
              "descendants": [
                "block-v1:QA+comparison+2022+type@chapter+block@abecaefe203c4c93b441d16cea3b7846",
                "block-v1:QA+comparison+2022+type@chapter+block@d5a4f1f2f5314288aae400c270fb03f7",
                "block-v1:QA+comparison+2022+type@chapter+block@7ab45affb80f4846a60648ec6aff9fbf"
              ],
              "completion": 0
            }
          },
          "id": "course-v1:QA+comparison+2022",
          "name": "Comparison xblock test coursre",
          "number": "comparison",
          "org": "QA",
          "start": "2022-01-01T00:00:00Z",
          "start_display": "01 january 2022 р.",
          "start_type": "timestamp",
          "end": null,
          "courseware_access": {
            "has_access": true,
            "error_code": null,
            "developer_message": null,
            "user_message": null,
            "additional_context_user_message": null,
            "user_fragment": null
          },
          "media": {
            "image": {
              "raw": "/asset-v1:QA+comparison+2022+type@asset+block@images_course_image.jpg",
              "small": "/asset-v1:QA+comparison+2022+type@asset+block@images_course_image.jpg",
              "large": "/asset-v1:QA+comparison+2022+type@asset+block@images_course_image.jpg"
            }
          },
          "certificate": {
            
          },
          "is_self_paced": false
        }
    """
    
    private let courseDatesJSON: String = """
    {
      "dates_banner_info": {
        "missed_deadlines": true,
        "content_type_gating_enabled": false,
        "missed_gated_content": false,
        "verified_upgrade_link": "https://ecommerce.edx.org/basket/add/?sku=87701A8"
      },
      "course_date_blocks": [
        {
          "assignment_type": null,
          "complete": null,
          "date": "2023-09-26T04:41:52Z",
          "date_type": "course-start-date",
          "description": "",
          "learner_has_access": true,
          "link": "",
          "link_text": "",
          "title": "Course starts",
          "extra_info": null,
          "first_component_block_id": ""
        },
        {
          "assignment_type": "Module 0",
          "complete": true,
          "date": "2024-01-11T09:39:37.467099Z",
          "date_type": "assignment-due-date",
          "description": "",
          "learner_has_access": true,
          "link": "https://courses.edx.org/courses/course-v1:HarvardX+ECD01+1T2023/jump_to/block-v1:HarvardX+ECD01+1T2023+type@sequential+block@fcc82b68eb944b83962be3fdaa004ac0",
          "link_text": "",
          "title": "Course Policies and Expectations",
          "extra_info": null,
          "first_component_block_id": "block-v1:HarvardX+ECD01+1T2023+type@problem+block@c0e15c6127404c6d9f21b588342067ac"
        },
        {
          "assignment_type": "Module 0",
          "complete": false,
          "date": "2024-01-11T09:39:37.467099Z",
          "date_type": "assignment-due-date",
          "description": "",
          "learner_has_access": true,
          "link": "https://courses.edx.org/courses/course-v1:HarvardX+ECD01+1T2023/jump_to/block-v1:HarvardX+ECD01+1T2023+type@sequential+block@2a3ed0b868cd429ebdfbd1fe416d9c5a",
          "link_text": "",
          "title": "Syllabus Quiz",
          "extra_info": null,
          "first_component_block_id": "block-v1:HarvardX+ECD01+1T2023+type@html+block@987158ea28e24f13855ff6abfb3e63e2"
        },
        {
          "assignment_type": "Module 1",
          "complete": false,
          "date": "2024-01-15T20:19:37.467099Z",
          "date_type": "assignment-due-date",
          "description": "",
          "learner_has_access": true,
          "link": "https://courses.edx.org/courses/course-v1:HarvardX+ECD01+1T2023/jump_to/block-v1:HarvardX+ECD01+1T2023+type@sequential+block@84141e77957c45cca6b5039da8ee679d",
          "link_text": "",
          "title": "1.2 Why Should we Invest in ECD Interventions?",
          "extra_info": null,
          "first_component_block_id": "block-v1:HarvardX+ECD01+1T2023+type@html+block@bf278c64a4034e88a33e0904fe03e256"
        },
        {
          "assignment_type": "Module 1",
          "complete": false,
          "date": "2024-01-16T09:19:37.467099Z",
          "date_type": "assignment-due-date",
          "description": "",
          "learner_has_access": true,
          "link": "https://courses.edx.org/courses/course-v1:HarvardX+ECD01+1T2023/jump_to/block-v1:HarvardX+ECD01+1T2023+type@sequential+block@e2d228da088648479e5fda7478c006b8",
          "link_text": "",
          "title": "1.6 Closing",
          "extra_info": null,
          "first_component_block_id": "block-v1:HarvardX+ECD01+1T2023+type@html+block@c97497458d30419ea0d41f6b3688e584"
        },
        {
          "assignment_type": "Module 2",
          "complete": false,
          "date": "2024-01-16T21:59:37.467099Z",
          "date_type": "assignment-due-date",
          "description": "",
          "learner_has_access": true,
          "link": "https://courses.edx.org/courses/course-v1:HarvardX+ECD01+1T2023/jump_to/block-v1:HarvardX+ECD01+1T2023+type@sequential+block@ade8a7cfbf724bf5b58902bd27b613b0",
          "link_text": "",
          "title": "2.2 What can we learn about active ingredients from case studies of ECD interventions around the world?",
          "extra_info": null,
          "first_component_block_id": "block-v1:HarvardX+ECD01+1T2023+type@html+block@e14daeca668d4c77a6f918b41b486195"
        },
        {
          "assignment_type": "Module 3",
          "complete": false,
          "date": "2024-01-17T17:39:37.467099Z",
          "date_type": "assignment-due-date",
          "description": "",
          "learner_has_access": true,
          "link": "https://courses.edx.org/courses/course-v1:HarvardX+ECD01+1T2023/jump_to/block-v1:HarvardX+ECD01+1T2023+type@sequential+block@57ee148192f046859d6c8a2c3531ab49",
          "link_text": "",
          "title": "3.1 Delivery and Dose",
          "extra_info": null,
          "first_component_block_id": "block-v1:HarvardX+ECD01+1T2023+type@html+block@ded1a7f220cb403887d3f894d0171762"
        },
        {
          "assignment_type": "Module 3",
          "complete": false,
          "date": "2024-01-22T06:59:37.467099Z",
          "date_type": "assignment-due-date",
          "description": "",
          "learner_has_access": true,
          "link": "https://courses.edx.org/courses/course-v1:HarvardX+ECD01+1T2023/jump_to/block-v1:HarvardX+ECD01+1T2023+type@sequential+block@5be015e209ee4a44b71a10682ddb3eee",
          "link_text": "",
          "title": "3.2 Demand",
          "extra_info": null,
          "first_component_block_id": "block-v1:HarvardX+ECD01+1T2023+type@html+block@e4f7b5f3cf9c498cb9d41a665e420ac8"
        },
        {
          "assignment_type": "Module 3",
          "complete": false,
          "date": "2024-01-18T17:39:37.467099Z",
          "date_type": "assignment-due-date",
          "description": "",
          "learner_has_access": true,
          "link": "https://courses.edx.org/courses/course-v1:HarvardX+ECD01+1T2023/jump_to/block-v1:HarvardX+ECD01+1T2023+type@sequential+block@1da589ea848740628d173cba2c6833c8",
          "link_text": "",
          "title": "3.4 Closure",
          "extra_info": null,
          "first_component_block_id": "block-v1:HarvardX+ECD01+1T2023+type@problem+block@eae438670a9844818518d52fff4d8aa4"
        },
        {
          "assignment_type": "Module 4",
          "complete": false,
          "date": "2024-01-19T04:19:37.467099Z",
          "date_type": "assignment-due-date",
          "description": "",
          "learner_has_access": true,
          "link": "https://courses.edx.org/courses/course-v1:HarvardX+ECD01+1T2023/jump_to/block-v1:HarvardX+ECD01+1T2023+type@sequential+block@47f62ec6b1744ba5a1350a9f69e28cdc",
          "link_text": "",
          "title": "4.5 Closure",
          "extra_info": null,
          "first_component_block_id": "block-v1:HarvardX+ECD01+1T2023+type@html+block@aff4b3b4b4ad4301a6293be7f626287a"
        },
        {
          "assignment_type": "Module 5",
          "complete": false,
          "date": "2024-01-27T04:19:37.467099Z",
          "date_type": "assignment-due-date",
          "description": "",
          "learner_has_access": true,
          "link": "https://courses.edx.org/courses/course-v1:HarvardX+ECD01+1T2023/jump_to/block-v1:HarvardX+ECD01+1T2023+type@sequential+block@d28b2ee7d1a4425b872d62bfaeb56128",
          "link_text": "",
          "title": "5.1 Measuring Progress in ECD Interventions",
          "extra_info": null,
          "first_component_block_id": "block-v1:HarvardX+ECD01+1T2023+type@html+block@b2f2e069242945728fd7e7fbc401eed5"
        },
        {
          "assignment_type": "Module 5",
          "complete": false,
          "date": "2024-01-28T14:59:37.467099Z",
          "date_type": "assignment-due-date",
          "description": "",
          "learner_has_access": true,
          "link": "https://courses.edx.org/courses/course-v1:HarvardX+ECD01+1T2023/jump_to/block-v1:HarvardX+ECD01+1T2023+type@sequential+block@e9875420bbb9405e95c18186718d7529",
          "link_text": "",
          "title": "5.2 Measuring Progress in ECD Policies",
          "extra_info": null,
          "first_component_block_id": "block-v1:HarvardX+ECD01+1T2023+type@html+block@0d0111f05f974c1ebaf66e8262f39da4"
        },
        {
          "assignment_type": "Module 5",
          "complete": false,
          "date": "2024-01-30T14:59:37.467099Z",
          "date_type": "assignment-due-date",
          "description": "",
          "learner_has_access": true,
          "link": "https://courses.edx.org/courses/course-v1:HarvardX+ECD01+1T2023/jump_to/block-v1:HarvardX+ECD01+1T2023+type@sequential+block@504b2e012ec143d2a45ca5a6d04f8b22",
          "link_text": "",
          "title": "5.3 Challenges and Data-Driven Solutions",
          "extra_info": null,
          "first_component_block_id": "block-v1:HarvardX+ECD01+1T2023+type@html+block@2b94eda3fe694579b941a055f3fb963a"
        },
        {
          "assignment_type": "Module 6",
          "complete": false,
          "date": "2024-01-31T01:39:37.467099Z",
          "date_type": "assignment-due-date",
          "description": "",
          "learner_has_access": true,
          "link": "https://courses.edx.org/courses/course-v1:HarvardX+ECD01+1T2023/jump_to/block-v1:HarvardX+ECD01+1T2023+type@sequential+block@3aed70e1f3354a4eb5d21d63ec44618c",
          "link_text": "",
          "title": "6.2 Examples of Innovations",
          "extra_info": null,
          "first_component_block_id": "block-v1:HarvardX+ECD01+1T2023+type@html+block@c23ad5f08cd842b49d30a1c8b7ce176a"
        },
        {
          "assignment_type": null,
          "complete": false,
          "date": "2024-02-01T12:00:00Z",
          "date_type": "assignment-due-date",
          "description": "",
          "learner_has_access": true,
          "link": "https://courses.edx.org/courses/block-v1:HarvardX+ECD01+1T2023+type@course+block@course/jump_to/block-v1:HarvardX+ECD01+1T2023+type@openassessment+block@217e302038da4a638cc5c0eb8aa6a239",
          "link_text": "",
          "title": "Open Response Assessment (Self Assessment)",
          "extra_info": "This Open Response Assessment's due dates are set by your instructor and can't be shifted.",
          "first_component_block_id": "block-v1:HarvardX+ECD01+1T2023+type@openassessment+block@217e302038da4a638cc5c0eb8aa6a239"
        },
        {
          "assignment_type": "Module 0",
          "complete": false,
          "date": "2024-02-03T09:39:37.467099Z",
          "date_type": "assignment-due-date",
          "description": "",
          "learner_has_access": true,
          "link": "https://courses.edx.org/courses/course-v1:HarvardX+ECD01+1T2023/jump_to/block-v1:HarvardX+ECD01+1T2023+type@sequential+block@fcc82b68eb944b83962be3fdaa004ac0",
          "link_text": "",
          "title": "Course Policies and Expectations",
          "extra_info": null,
          "first_component_block_id": "block-v1:HarvardX+ECD01+1T2023+type@problem+block@c0e15c6127404c6d9f21b588342067ac"
        },
        {
          "assignment_type": "Module 0",
          "complete": false,
          "date": "2024-01-15T09:39:37.467099Z",
          "date_type": "assignment-due-date",
          "description": "",
          "learner_has_access": true,
          "link": "https://courses.edx.org/courses/course-v1:HarvardX+ECD01+1T2023/jump_to/block-v1:HarvardX+ECD01+1T2023+type@sequential+block@2a3ed0b868cd429ebdfbd1fe416d9c5a",
          "link_text": "",
          "title": "Syllabus Quiz",
          "extra_info": null,
          "first_component_block_id": "block-v1:HarvardX+ECD01+1T2023+type@html+block@987158ea28e24f13855ff6abfb3e63e2"
        },
        {
          "assignment_type": "Module 1",
          "complete": true,
          "date": "2024-01-14T09:39:37.467099Z",
          "date_type": "assignment-due-date",
          "description": "",
          "learner_has_access": true,
          "link": "https://courses.edx.org/courses/course-v1:HarvardX+ECD01+1T2023/jump_to/block-v1:HarvardX+ECD01+1T2023+type@sequential+block@84141e77957c45cca6b5039da8ee679d",
          "link_text": "",
          "title": "1.2 Why Should we Invest in ECD Interventions?",
          "extra_info": null,
          "first_component_block_id": "block-v1:HarvardX+ECD01+1T2023+type@html+block@bf278c64a4034e88a33e0904fe03e256"
        },
        {
          "assignment_type": "Module 1",
          "complete": false,
          "date": "2024-01-13T09:39:37.467099Z",
          "date_type": "assignment-due-date",
          "description": "",
          "learner_has_access": true,
          "link": "https://courses.edx.org/courses/course-v1:HarvardX+ECD01+1T2023/jump_to/block-v1:HarvardX+ECD01+1T2023+type@sequential+block@d11c050c03de4cb48b80faf011162195",
          "link_text": "",
          "title": "1.5: What Implementation Features Matter to Implement ECD Interventions?",
          "extra_info": null,
          "first_component_block_id": "block-v1:HarvardX+ECD01+1T2023+type@html+block@1655c4b7d4934734b401e70babc14d28"
        },
        {
          "assignment_type": "Module 1",
          "complete": true,
          "date": "2024-01-12T09:39:37.467099Z",
          "date_type": "assignment-due-date",
          "description": "",
          "learner_has_access": true,
          "link": "https://courses.edx.org/courses/course-v1:HarvardX+ECD01+1T2023/jump_to/block-v1:HarvardX+ECD01+1T2023+type@sequential+block@e2d228da088648479e5fda7478c006b8",
          "link_text": "",
          "title": "1.6 Closing",
          "extra_info": null,
          "first_component_block_id": "block-v1:HarvardX+ECD01+1T2023+type@html+block@c97497458d30419ea0d41f6b3688e584"
        },
        {
          "assignment_type": "Module 2",
          "complete": true,
          "date": "2024-01-11T09:39:37.467099Z",
          "date_type": "assignment-due-date",
          "description": "",
          "learner_has_access": true,
          "link": "https://courses.edx.org/courses/course-v1:HarvardX+ECD01+1T2023/jump_to/block-v1:HarvardX+ECD01+1T2023+type@sequential+block@ed3b874a340d4dfa9245a3d2deaee5da",
          "link_text": "",
          "title": "2.1 What are the active ingredients of effective ECD interventions?",
          "extra_info": null,
          "first_component_block_id": "block-v1:HarvardX+ECD01+1T2023+type@html+block@286da9b199c24445b1685040ded994d1"
        },
        {
          "assignment_type": "Module 2",
          "complete": false,
          "date": "2024-01-10T09:39:37.467099Z",
          "date_type": "assignment-due-date",
          "description": "",
          "learner_has_access": true,
          "link": "https://courses.edx.org/courses/course-v1:HarvardX+ECD01+1T2023/jump_to/block-v1:HarvardX+ECD01+1T2023+type@sequential+block@ade8a7cfbf724bf5b58902bd27b613b0",
          "link_text": "",
          "title": "2.2 What can we learn about active ingredients from case studies of ECD interventions around the world?",
          "extra_info": null,
          "first_component_block_id": "block-v1:HarvardX+ECD01+1T2023+type@html+block@e14daeca668d4c77a6f918b41b486195"
        },
        {
          "assignment_type": "Module 3",
          "complete": false,
          "date": "2024-01-09T09:39:37.467099Z",
          "date_type": "assignment-due-date",
          "description": "",
          "learner_has_access": true,
          "link": "https://courses.edx.org/courses/course-v1:HarvardX+ECD01+1T2023/jump_to/block-v1:HarvardX+ECD01+1T2023+type@sequential+block@57ee148192f046859d6c8a2c3531ab49",
          "link_text": "",
          "title": "3.1 Delivery and Dose",
          "extra_info": null,
          "first_component_block_id": "block-v1:HarvardX+ECD01+1T2023+type@html+block@ded1a7f220cb403887d3f894d0171762"
        },
        {
          "assignment_type": "Module 3",
          "complete": false,
          "date": "2024-01-08T09:39:37.467099Z",
          "date_type": "assignment-due-date",
          "description": "",
          "learner_has_access": true,
          "link": "https://courses.edx.org/courses/course-v1:HarvardX+ECD01+1T2023/jump_to/block-v1:HarvardX+ECD01+1T2023+type@sequential+block@5be015e209ee4a44b71a10682ddb3eee",
          "link_text": "",
          "title": "3.2 Demand",
          "extra_info": null,
          "first_component_block_id": "block-v1:HarvardX+ECD01+1T2023+type@html+block@e4f7b5f3cf9c498cb9d41a665e420ac8"
        },
        {
          "assignment_type": "Module 3",
          "complete": false,
          "date": "2020-01-07T09:39:37.467099Z",
          "date_type": "assignment-due-date",
          "description": "",
          "learner_has_access": true,
          "link": "https://courses.edx.org/courses/course-v1:HarvardX+ECD01+1T2023/jump_to/block-v1:HarvardX+ECD01+1T2023+type@sequential+block@1da589ea848740628d173cba2c6833c8",
          "link_text": "",
          "title": "3.4 Closure",
          "extra_info": null,
          "first_component_block_id": "block-v1:HarvardX+ECD01+1T2023+type@problem+block@eae438670a9844818518d52fff4d8aa4"
        },
        {
          "assignment_type": "Module 4",
          "complete": false,
          "date": "2024-01-16T09:39:37.467099Z",
          "date_type": "assignment-due-date",
          "description": "",
          "learner_has_access": true,
          "link": "https://courses.edx.org/courses/course-v1:HarvardX+ECD01+1T2023/jump_to/block-v1:HarvardX+ECD01+1T2023+type@sequential+block@47f62ec6b1744ba5a1350a9f69e28cdc",
          "link_text": "",
          "title": "4.5 Closure",
          "extra_info": null,
          "first_component_block_id": "block-v1:HarvardX+ECD01+1T2023+type@html+block@aff4b3b4b4ad4301a6293be7f626287a"
        },
        {
          "assignment_type": "Module 5",
          "complete": false,
          "date": "2024-01-17T09:39:37.467099Z",
          "date_type": "assignment-due-date",
          "description": "",
          "learner_has_access": true,
          "link": "https://courses.edx.org/courses/course-v1:HarvardX+ECD01+1T2023/jump_to/block-v1:HarvardX+ECD01+1T2023+type@sequential+block@d28b2ee7d1a4425b872d62bfaeb56128",
          "link_text": "",
          "title": "5.1 Measuring Progress in ECD Interventions",
          "extra_info": null,
          "first_component_block_id": "block-v1:HarvardX+ECD01+1T2023+type@html+block@b2f2e069242945728fd7e7fbc401eed5"
        },
        {
          "assignment_type": "Module 5",
          "complete": false,
          "date": "2024-01-18T09:39:37.467099Z",
          "date_type": "assignment-due-date",
          "description": "",
          "learner_has_access": true,
          "link": "https://courses.edx.org/courses/course-v1:HarvardX+ECD01+1T2023/jump_to/block-v1:HarvardX+ECD01+1T2023+type@sequential+block@e9875420bbb9405e95c18186718d7529",
          "link_text": "",
          "title": "5.2 Measuring Progress in ECD Policies",
          "extra_info": null,
          "first_component_block_id": "block-v1:HarvardX+ECD01+1T2023+type@html+block@0d0111f05f974c1ebaf66e8262f39da4"
        },
        {
          "assignment_type": "Module 5",
          "complete": false,
          "date": "2024-01-19T09:39:37.467099Z",
          "date_type": "assignment-due-date",
          "description": "",
          "learner_has_access": true,
          "link": "https://courses.edx.org/courses/course-v1:HarvardX+ECD01+1T2023/jump_to/block-v1:HarvardX+ECD01+1T2023+type@sequential+block@504b2e012ec143d2a45ca5a6d04f8b22",
          "link_text": "",
          "title": "5.3 Challenges and Data-Driven Solutions",
          "extra_info": null,
          "first_component_block_id": "block-v1:HarvardX+ECD01+1T2023+type@html+block@2b94eda3fe694579b941a055f3fb963a"
        },
        {
          "assignment_type": "Module 6",
          "complete": false,
          "date": "2024-01-20T09:39:37.467099Z",
          "date_type": "assignment-due-date",
          "description": "",
          "learner_has_access": true,
          "link": "https://courses.edx.org/courses/course-v1:HarvardX+ECD01+1T2023/jump_to/block-v1:HarvardX+ECD01+1T2023+type@sequential+block@3aed70e1f3354a4eb5d21d63ec44618c",
          "link_text": "",
          "title": "6.2 Examples of Innovations",
          "extra_info": null,
          "first_component_block_id": "block-v1:HarvardX+ECD01+1T2023+type@html+block@c23ad5f08cd842b49d30a1c8b7ce176a"
        },
        {
          "assignment_type": "Module 7",
          "complete": false,
          "date": "2024-01-23T15:39:37.467099Z",
          "date_type": "assignment-due-date",
          "description": "",
          "learner_has_access": true,
          "link": "https://courses.edx.org/courses/course-v1:HarvardX+ECD01+1T2023/jump_to/block-v1:HarvardX+ECD01+1T2023+type@sequential+block@1aea57e69f2a40f8a25c8edd389e3608",
          "link_text": "",
          "title": "7.0 Course Summary",
          "extra_info": null,
          "first_component_block_id": "block-v1:HarvardX+ECD01+1T2023+type@html+block@625c5399993344fdaa852a967be6f690"
        },
        {
          "assignment_type": null,
          "complete": false,
          "date": "2024-01-23T12:39:37.467099Z",
          "date_type": "assignment-due-date",
          "description": "",
          "learner_has_access": true,
          "link": "https://courses.edx.org/courses/block-v1:HarvardX+ECD01+1T2023+type@course+block@course/jump_to/block-v1:HarvardX+ECD01+1T2023+type@openassessment+block@217e302038da4a638cc5c0eb8aa6a239",
          "link_text": "",
          "title": "Open Response Assessment (Submission)",
          "extra_info": "This Open Response Assessment's due dates are set by your instructor and can't be shifted.",
          "first_component_block_id": "block-v1:HarvardX+ECD01+1T2023+type@openassessment+block@217e302038da4a638cc5c0eb8aa6a239"
        },
        {
          "assignment_type": null,
          "complete": false,
          "date": "2024-01-23T09:39:37.467099Z",
          "date_type": "assignment-due-date",
          "description": "",
          "learner_has_access": true,
          "link": "https://courses.edx.org/courses/block-v1:HarvardX+ECD01+1T2023+type@course+block@course/jump_to/block-v1:HarvardX+ECD01+1T2023+type@openassessment+block@c3880270b8c7471287dd72a4b4b7e103",
          "link_text": "",
          "title": "Practice Creating a Theory of Change (Submission)",
          "extra_info": "This Open Response Assessment's due dates are set by your instructor and can't be shifted.",
          "first_component_block_id": "block-v1:HarvardX+ECD01+1T2023+type@openassessment+block@c3880270b8c7471287dd72a4b4b7e103"
        },
        {
          "assignment_type": null,
          "complete": false,
          "date": "2024-01-24T09:39:37.467099Z",
          "date_type": "assignment-due-date",
          "description": "",
          "learner_has_access": true,
          "link": "https://courses.edx.org/courses/block-v1:HarvardX+ECD01+1T2023+type@course+block@course/jump_to/block-v1:HarvardX+ECD01+1T2023+type@openassessment+block@7f7924ba31fe4dfba5aee3304fd56cc9",
          "link_text": "",
          "title": "Activity 1: Logic Model (Submission)",
          "extra_info": "This Open Response Assessment's due dates are set by your instructor and can't be shifted.",
          "first_component_block_id": "block-v1:HarvardX+ECD01+1T2023+type@openassessment+block@7f7924ba31fe4dfba5aee3304fd56cc9"
        },
        {
          "assignment_type": null,
          "complete": false,
          "date": "2024-01-25T09:39:37.467099Z",
          "date_type": "assignment-due-date",
          "description": "",
          "learner_has_access": true,
          "link": "https://courses.edx.org/courses/block-v1:HarvardX+ECD01+1T2023+type@course+block@course/jump_to/block-v1:HarvardX+ECD01+1T2023+type@openassessment+block@217e302038da4a638cc5c0eb8aa6a239",
          "link_text": "",
          "title": "Open Response Assessment (Peer Assessment)",
          "extra_info": "This Open Response Assessment's due dates are set by your instructor and can't be shifted.",
          "first_component_block_id": "block-v1:HarvardX+ECD01+1T2023+type@openassessment+block@217e302038da4a638cc5c0eb8aa6a239"
        },
        {
          "assignment_type": null,
          "complete": false,
          "date": "2024-02-26T09:39:37.467099Z",
          "date_type": "assignment-due-date",
          "description": "",
          "learner_has_access": true,
          "link": "https://courses.edx.org/courses/block-v1:HarvardX+ECD01+1T2023+type@course+block@course/jump_to/block-v1:HarvardX+ECD01+1T2023+type@openassessment+block@217e302038da4a638cc5c0eb8aa6a239",
          "link_text": "",
          "title": "Open Response Assessment (Self Assessment)",
          "extra_info": "This Open Response Assessment's due dates are set by your instructor and can't be shifted.",
          "first_component_block_id": "block-v1:HarvardX+ECD01+1T2023+type@openassessment+block@217e302038da4a638cc5c0eb8aa6a239"
        },
        {
          "assignment_type": null,
          "complete": false,
          "date": "2024-03-27T09:39:37.467099Z",
          "date_type": "assignment-due-date",
          "description": "",
          "learner_has_access": true,
          "link": "https://courses.edx.org/courses/block-v1:HarvardX+ECD01+1T2023+type@course+block@course/jump_to/block-v1:HarvardX+ECD01+1T2023+type@openassessment+block@c3880270b8c7471287dd72a4b4b7e103",
          "link_text": "",
          "title": "Practice Creating a Theory of Change (Peer Assessment)",
          "extra_info": "This Open Response Assessment's due dates are set by your instructor and can't be shifted.",
          "first_component_block_id": "block-v1:HarvardX+ECD01+1T2023+type@openassessment+block@c3880270b8c7471287dd72a4b4b7e103"
        },
        {
          "assignment_type": null,
          "complete": false,
          "date": "2024-04-28T09:39:37.467099Z",
          "date_type": "assignment-due-date",
          "description": "",
          "learner_has_access": true,
          "link": "https://courses.edx.org/courses/block-v1:HarvardX+ECD01+1T2023+type@course+block@course/jump_to/block-v1:HarvardX+ECD01+1T2023+type@openassessment+block@c3880270b8c7471287dd72a4b4b7e103",
          "link_text": "",
          "title": "Practice Creating a Theory of Change (Self Assessment)",
          "extra_info": "This Open Response Assessment's due dates are set by your instructor and can't be shifted.",
          "first_component_block_id": "block-v1:HarvardX+ECD01+1T2023+type@openassessment+block@c3880270b8c7471287dd72a4b4b7e103"
        },
        {
          "assignment_type": null,
          "complete": false,
          "date": "2025-01-29T09:39:37.467099Z",
          "date_type": "assignment-due-date",
          "description": "",
          "learner_has_access": true,
          "link": "https://courses.edx.org/courses/block-v1:HarvardX+ECD01+1T2023+type@course+block@course/jump_to/block-v1:HarvardX+ECD01+1T2023+type@openassessment+block@7f7924ba31fe4dfba5aee3304fd56cc9",
          "link_text": "",
          "title": "Activity 1: Logic Model (Peer Assessment)",
          "extra_info": "This Open Response Assessment's due dates are set by your instructor and can't be shifted.",
          "first_component_block_id": "block-v1:HarvardX+ECD01+1T2023+type@openassessment+block@7f7924ba31fe4dfba5aee3304fd56cc9"
        },
        {
          "assignment_type": null,
          "complete": false,
          "date": "2026-01-30T09:39:37.467099Z",
          "date_type": "assignment-due-date",
          "description": "",
          "learner_has_access": true,
          "link": "https://courses.edx.org/courses/block-v1:HarvardX+ECD01+1T2023+type@course+block@course/jump_to/block-v1:HarvardX+ECD01+1T2023+type@openassessment+block@7f7924ba31fe4dfba5aee3304fd56cc9",
          "link_text": "",
          "title": "Activity 1: Logic Model (Self Assessment)",
          "extra_info": "This Open Response Assessment's due dates are set by your instructor and can't be shifted.",
          "first_component_block_id": "block-v1:HarvardX+ECD01+1T2023+type@openassessment+block@7f7924ba31fe4dfba5aee3304fd56cc9"
        },
        {
          "assignment_type": null,
          "complete": false,
          "date": "2027-02-21T12:00:00Z",
          "date_type": "verified-upgrade-deadline",
          "description": "ABC",
          "learner_has_access": true,
          "link": "https://courses.edx.org/courses/block-v1:HarvardX+ECD01+1T2023+type@course+block@course/jump_to/block-v1:HarvardX+ECD01+1T2023+type@openassessment+block@c3880270b8c7471287dd72a4b4b7e103",
          "link_text": "",
          "title": "Practice Creating a Theory of Change (Peer Assessment)",
          "extra_info": "This Open Response Assessment's due dates are set by your instructor and can't be shifted.",
          "first_component_block_id": "block-v1:HarvardX+ECD01+1T2023+type@openassessment+block@c3880270b8c7471287dd72a4b4b7e103"
        },
        {
          "assignment_type": null,
          "complete": false,
          "date": "2027-02-21T12:00:00Z",
          "date_type": "verified-upgrade-deadline",
          "description": "ABC lmn",
          "learner_has_access": true,
          "link": "https://courses.edx.org/courses/block-v1:HarvardX+ECD01+1T2023+type@course+block@course/jump_to/block-v1:HarvardX+ECD01+1T2023+type@openassessment+block@c3880270b8c7471287dd72a4b4b7e103",
          "link_text": "",
          "title": "Practice Creating a Theory of Change (Self Assessment)",
          "extra_info": "This Open Response Assessment's due dates are set by your instructor and can't be shifted.",
          "first_component_block_id": "block-v1:HarvardX+ECD01+1T2023+type@openassessment+block@c3880270b8c7471287dd72a4b4b7e103"
        },
        {
          "assignment_type": null,
          "complete": false,
          "date": "2027-02-21T12:00:00Z",
          "date_type": "certificate-available-date",
          "description": "",
          "learner_has_access": true,
          "link": "https://courses.edx.org/courses/block-v1:HarvardX+ECD01+1T2023+type@course+block@course/jump_to/block-v1:HarvardX+ECD01+1T2023+type@openassessment+block@7f7924ba31fe4dfba5aee3304fd56cc9",
          "link_text": "",
          "title": "Certificate",
          "extra_info": "This Open Response Assessment's due dates are set by your instructor and can't be shifted.",
          "first_component_block_id": "block-v1:HarvardX+ECD01+1T2023+type@openassessment+block@7f7924ba31fe4dfba5aee3304fd56cc9"
        },
        {
          "assignment_type": null,
          "complete": false,
          "date": "2027-02-21T12:00:00Z",
          "date_type": "course-expired-date",
          "description": "",
          "learner_has_access": true,
          "link": "https://courses.edx.org/courses/block-v1:HarvardX+ECD01+1T2023+type@course+block@course/jump_to/block-v1:HarvardX+ECD01+1T2023+type@openassessment+block@7f7924ba31fe4dfba5aee3304fd56cc9",
          "link_text": "",
          "title": "Course Access Expires",
          "extra_info": "This Open Response Assessment's due dates are set by your instructor and can't be shifted.",
          "first_component_block_id": "block-v1:HarvardX+ECD01+1T2023+type@openassessment+block@7f7924ba31fe4dfba5aee3304fd56cc9"
        },
        {
          "assignment_type": null,
          "complete": null,
          "date": "2027-02-22T12:00:00Z",
          "date_type": "course-end-date",
          "description": "After this date, the course will be archived, which means you can review the course content but can no longer participate in graded assignments or work towards earning a certificate.",
          "learner_has_access": true,
          "link": "",
          "link_text": "",
          "title": "Course ends",
          "extra_info": null,
          "first_component_block_id": ""
        }
      ],
      "has_ended": false,
      "learner_is_full_access": true,
      "user_timezone": null
    }
    """
}
#endif
// swiftlint:enable all

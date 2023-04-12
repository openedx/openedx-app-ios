//
//  CourseRepository.swift
//  Course
//
//  Created by  Stepanok Ivan on 26.09.2022.
//

import Foundation
import Core

public protocol CourseRepositoryProtocol {
    func getCourseDetails(courseID: String) async throws -> CourseDetails
    func getCourseBlocks(courseID: String) async throws -> CourseStructure
    func getCourseDetailsOffline(courseID: String) async throws -> CourseDetails
    func getCourseBlocksOffline(courseID: String) throws -> CourseStructure
    func enrollToCourse(courseID: String) async throws -> Bool
    func blockCompletionRequest(courseID: String, blockID: String) async throws
    func getHandouts(courseID: String) async throws -> String?
    func getUpdates(courseID: String) async throws -> [CourseUpdate]
    func resumeBlock(courseID: String) async throws -> ResumeBlock
    func getSubtitles(url: String) async throws -> String
}

public class CourseRepository: CourseRepositoryProtocol {
    
    private let api: API
    private let appStorage: AppStorage
    private let config: Config
    private let persistence: CoursePersistenceProtocol
    
    public init(api: API,
                appStorage: AppStorage,
                config: Config,
                persistence: CoursePersistenceProtocol) {
        self.api = api
        self.appStorage = appStorage
        self.config = config
        self.persistence = persistence
    }
    
    public func getCourseDetails(courseID: String) async throws -> CourseDetails {
        let response = try await api.requestData(CourseDetailsEndpoint.getCourseDetail(courseID: courseID))
            .mapResponse(DataLayer.CourseDetailsResponse.self)
            .domain(baseURL: config.baseURL.absoluteString)
        persistence.saveCourseDetails(course: response)
        return response
    }
    
    public func getCourseDetailsOffline(courseID: String) async throws -> CourseDetails {
        return try persistence.loadCourseDetails(courseID: courseID)
    }
        
    public func getCourseBlocks(courseID: String) async throws -> CourseStructure {
        let structure = try await api.requestData(
            CourseDetailsEndpoint.getCourseBlocks(courseID: courseID, userName: appStorage.user?.username ?? "")
        ).mapResponse(DataLayer.CourseStructure.self)
        persistence.saveCourseStructure(structure: structure)
        let parsedStructure = parseCourseStructure(structure: structure)
        return parsedStructure
    }
    
    public func getCourseBlocksOffline(courseID: String) throws -> CourseStructure {
        let localData = try persistence.loadCourseStructure(courseID: courseID)
        return parseCourseStructure(structure: localData)
    }
    
    public func enrollToCourse(courseID: String) async throws -> Bool {
        let enroll = try await api.request(CourseDetailsEndpoint.enrollToCourse(courseID: courseID))
        if enroll.statusCode == 200 {
            return true
        } else {
            return false
        }
    }
    
    public func blockCompletionRequest(courseID: String, blockID: String) async throws {
        try await api.requestData(CourseDetailsEndpoint.blockCompletionRequest(
            username: appStorage.user?.username ?? "",
            courseID: courseID,
            blockID: blockID)
        )
    }
    
    public func getHandouts(courseID: String) async throws -> String? {
        return try await api.requestData(CourseDetailsEndpoint.getHandouts(courseID: courseID))
            .mapResponse(DataLayer.HandoutsResponse.self)
            .handoutsHtml
    }
    
    public func getUpdates(courseID: String) async throws -> [CourseUpdate] {
        return try await api.requestData(CourseDetailsEndpoint.getUpdates(courseID: courseID))
            .mapResponse(DataLayer.CourseUpdates.self).map { $0.domain }
    }
    
    public func resumeBlock(courseID: String) async throws -> ResumeBlock {
        return try await api.requestData(CourseDetailsEndpoint
            .resumeBlock(userName: appStorage.user?.username ?? "", courseID: courseID))
        .mapResponse(DataLayer.ResumeBlock.self).domain
    }
    
    public func getSubtitles(url: String) async throws -> String {
        if let subtitlesOffline = persistence.loadSubtitles(url: url) {
            return subtitlesOffline
        } else {
            let result = try await api.requestData(CourseDetailsEndpoint.getSubtitles(url: url))
            let subtitles = String(data: result, encoding: .utf8) ?? ""
            persistence.saveSubtitles(url: url, subtitlesString: subtitles)
            return subtitles
        }
    }
    
    private func parseCourseStructure(structure: DataLayer.CourseStructure) -> CourseStructure {
        let blocks = Array(structure.dict.values)
        let course = blocks.first(where: {$0.type == BlockType.course.rawValue })!
        let descendants = course.descendants ?? []
        var childs: [CourseChapter] = []
        for descend in descendants {
            let chapter = parseChapters(id: descend, blocks: blocks)
            childs.append(chapter)
        }
        
        return CourseStructure(id: course.id,
                               graded: course.graded,
                               completion: course.completion ?? 0,
                               viewYouTubeUrl: course.userViewData?.encodedVideo?.youTube?.url ?? "",
                               encodedVideo: course.userViewData?.encodedVideo?.fallback?.url ?? "",
                               displayName: course.displayName,
                               topicID: course.userViewData?.topicID,
                               childs: childs,
                               media: structure.media,
                               certificate: structure.certificate?.domain)
    }
    
    private func parseChapters(id: String, blocks: [DataLayer.CourseBlock]) -> CourseChapter {
        let chapter = blocks.first(where: {$0.id == id })!
        let descendants = chapter.descendants ?? []
        var childs: [CourseSequential] = []
        for descend in descendants {
            let chapter = parseSequential(id: descend, blocks: blocks)
            childs.append(chapter)
        }
        return CourseChapter(blockId: chapter.blockId,
                             id: chapter.id,
                             displayName: chapter.displayName,
                             type: BlockType(rawValue: chapter.type) ?? .unknown,
                             childs: childs)
        
    }
    
    private func parseSequential(id: String, blocks: [DataLayer.CourseBlock]) -> CourseSequential {
        let sequential = blocks.first(where: {$0.id == id })!
        let descendants = sequential.descendants ?? []
        var childs: [CourseVertical] = []
        for descend in descendants {
            let vertical = parseVerticals(id: descend, blocks: blocks)
            childs.append(vertical)
        }
        return CourseSequential(blockId: sequential.blockId,
                                id: sequential.id,
                                displayName: sequential.displayName,
                                type: BlockType(rawValue: sequential.type) ?? .unknown,
                                completion: sequential.completion ?? 0,
                                childs: childs)
    }
    
    private func parseVerticals(id: String, blocks: [DataLayer.CourseBlock]) -> CourseVertical {
        let sequential = blocks.first(where: {$0.id == id })!
        let descendants = sequential.descendants ?? []
        var childs: [CourseBlock] = []
        for descend in descendants {
            let block = parseBlock(id: descend, blocks: blocks)
            childs.append(block)
        }
        return CourseVertical(blockId: sequential.blockId,
                                id: sequential.id,
                                displayName: sequential.displayName,
                                type: BlockType(rawValue: sequential.type) ?? .unknown,
                                completion: sequential.completion ?? 0,
                                childs: childs)
    }
    
    private func parseBlock(id: String, blocks: [DataLayer.CourseBlock]) -> CourseBlock {
        let block = blocks.first(where: {$0.id == id })!
        let subtitles = block.userViewData?.transcripts?.map {
            let url = $0.value
                .replacingOccurrences(of: config.baseURL.absoluteString, with: "")
                .replacingOccurrences(of: "?lang=\($0.key)", with: "")
            return SubtitleUrl(language: $0.key, url: url)
        }
            
        return CourseBlock(blockId: block.blockId,
                           id: block.id,
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
    
}

// Mark - For testing and SwiftUI preview
#if DEBUG
// swiftlint:disable all
class CourseRepositoryMock: CourseRepositoryProtocol {
    func resumeBlock(courseID: String) async throws -> ResumeBlock {
        ResumeBlock(blockID: "123")
    }
    
    func getHandouts(courseID: String) async throws -> String? {
        return "Test Handouts"
    }
    
    func getUpdates(courseID: String) async throws -> [CourseUpdate] {
        return [CourseUpdate(id: 1, date: "Date", content: "content", status: "status")]
    }
    
    
    func getCourseDetailsOffline(courseID: String) async throws -> CourseDetails {
        return CourseDetails(
            courseID: "courseID",
            org: "Organization",
            courseTitle: "Course title",
            courseDescription: "Course description",
            courseStart: Date(iso8601: "2021-05-26T12:13:14Z"),
            courseEnd: Date(iso8601: "2022-05-26T12:13:14Z"),
            enrollmentStart: nil,
            enrollmentEnd: nil,
            isEnrolled: false,
            overviewHTML: "<b>Course description</b><br><br>Lorem ipsum",
            courseBannerURL: "courseBannerURL",
            courseVideoURL: nil
        )
    }
    
    func getCourseBlocksOffline(courseID: String) throws -> CourseStructure {
        let decoder = JSONDecoder()
        let jsonData = Data(courseStructureJson.utf8)
        let courseBlocks = try decoder.decode(DataLayer.CourseStructure.self, from: jsonData)
        return parseCourseStructure(courseBlocks: courseBlocks)
    }
    
    public  func getCourseDetails(courseID: String) async throws -> CourseDetails {
        return CourseDetails(
            courseID: "courseID",
            org: "Organization",
            courseTitle: "Course title",
            courseDescription: "Course description",
            courseStart: Date(iso8601: "2021-05-26T12:13:14Z"),
            courseEnd: Date(iso8601: "2022-05-26T12:13:14Z"),
            enrollmentStart: nil,
            enrollmentEnd: nil,
            isEnrolled: false,
            overviewHTML: "<b>Course description</b><br><br>Lorem ipsum",
            courseBannerURL: "courseBannerURL",
            courseVideoURL: nil
        )
    }
        
    public  func getCourseBlocks(courseID: String) async throws -> CourseStructure {
        do {
            let decoder = JSONDecoder()
            let jsonData = Data(courseStructureJson.utf8)
            let courseBlocks = try decoder.decode(DataLayer.CourseStructure.self, from: jsonData)
            return parseCourseStructure(courseBlocks: courseBlocks)
        } catch {
            throw error
        }
    }
    
    public  func enrollToCourse(courseID: String) async throws -> Bool {
        return true
    }
    
    public  func blockCompletionRequest(courseID: String, blockID: String) {
        
    }
    
    public func getSubtitles(url: String) async throws -> String {
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
    
    private func parseCourseStructure(courseBlocks: DataLayer.CourseStructure) -> CourseStructure {
        let blocks = Array(courseBlocks.dict.values)
        let course = blocks.first(where: {$0.type == BlockType.course.rawValue })!
        let descendants = course.descendants ?? []
        var childs: [CourseChapter] = []
        for descend in descendants {
            let chapter = parseChapters(id: descend, blocks: blocks)
            childs.append(chapter)
        }
        
        return CourseStructure(id: course.id,
                               graded: course.graded,
                               completion: course.completion ?? 0,
                               viewYouTubeUrl: course.userViewData?.encodedVideo?.youTube?.url ?? "",
                               encodedVideo: course.userViewData?.encodedVideo?.fallback?.url ?? "",
                               displayName: course.displayName,
                               topicID: course.userViewData?.topicID,
                               childs: childs,
                               media: courseBlocks.media,
                               certificate: courseBlocks.certificate?.domain)
    }
    
    private func parseChapters(id: String, blocks: [DataLayer.CourseBlock]) -> CourseChapter {
        let chapter = blocks.first(where: {$0.id == id })!
        let descendants = chapter.descendants ?? []
        var childs: [CourseSequential] = []
        for descend in descendants {
            let chapter = parseSequential(id: descend, blocks: blocks)
            childs.append(chapter)
        }
        return CourseChapter(blockId: chapter.blockId,
                             id: chapter.id,
                             displayName: chapter.displayName,
                             type: BlockType(rawValue: chapter.type) ?? .unknown,
                             childs: childs)
    }
    
    private func parseSequential(id: String, blocks: [DataLayer.CourseBlock]) -> CourseSequential {
        let sequential = blocks.first(where: {$0.id == id })!
        let descendants = sequential.descendants ?? []
        var childs: [CourseVertical] = []
        for descend in descendants {
            let vertical = parseVerticals(id: descend, blocks: blocks)
            childs.append(vertical)
        }
        return CourseSequential(blockId: sequential.blockId,
                                id: sequential.id,
                                displayName: sequential.displayName,
                                type: BlockType(rawValue: sequential.type) ?? .unknown,
                                completion: sequential.completion ?? 0,
                                childs: childs)
    }
    
    private func parseVerticals(id: String, blocks: [DataLayer.CourseBlock]) -> CourseVertical {
        let sequential = blocks.first(where: {$0.id == id })!
        let descendants = sequential.descendants ?? []
        var childs: [CourseBlock] = []
        for descend in descendants {
            let block = parseBlock(id: descend, blocks: blocks)
            childs.append(block)
        }
        return CourseVertical(blockId: sequential.blockId,
                                id: sequential.id,
                                displayName: sequential.displayName,
                                type: BlockType(rawValue: sequential.type) ?? .unknown,
                                completion: sequential.completion ?? 0,
                                childs: childs)
    }
    
    private func parseBlock(id: String, blocks: [DataLayer.CourseBlock]) -> CourseBlock {
        let block = blocks.first(where: {$0.id == id })!
        let subtitles = block.userViewData?.transcripts?.map {
//            let url = $0.value
//                .replacingOccurrences(of: config.baseURL.absoluteString, with: "")
//                .replacingOccurrences(of: "?lang=en", with: "")
            SubtitleUrl(language: $0.key, url: $0.value)
        }
        return CourseBlock(blockId: block.blockId,
                           id: block.id,
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
    
    private let courseStructureJson: String = "{\n" +
    "    \"root\": \"block-v1:RG+MC01+2022+type@course+block@course\",\n" +
    "    \"blocks\": {\n" +
    "        \"block-v1:RG+MC01+2022+type@html+block@8718fdf95d584d198a3b17c0d2611139\": {\n" +
    "            \"id\": \"block-v1:RG+MC01+2022+type@html+block@8718fdf95d584d198a3b17c0d2611139\",\n" +
    "            \"block_id\": \"8718fdf95d584d198a3b17c0d2611139\",\n" +
    "            \"lms_web_url\": \"https://lms-client-demo-maple.raccoongang.com/courses/course-v1:RG+MC01+2022/jump_to/block-v1:RG+MC01+2022+type@html+block@8718fdf95d584d198a3b17c0d2611139\",\n" +
    "            \"legacy_web_url\": \"https://lms-client-demo-maple.raccoongang.com/courses/course-v1:RG+MC01+2022/jump_to/block-v1:RG+MC01+2022+type@html+block@8718fdf95d584d198a3b17c0d2611139?experience=legacy\",\n" +
    "            \"student_view_url\": \"https://lms-client-demo-maple.raccoongang.com/xblock/block-v1:RG+MC01+2022+type@html+block@8718fdf95d584d198a3b17c0d2611139\",\n" +
    "            \"type\": \"html\",\n" +
    "            \"display_name\": \"Text\",\n" +
    "            \"graded\": false,\n" +
    "            \"student_view_data\": {\n" +
    "                \"enabled\": false,\n" +
    "                \"message\": \"To enable, set FEATURES[\\\"ENABLE_HTML_XBLOCK_STUDENT_VIEW_DATA\\\"]\"\n" +
    "            },\n" +
    "            \"student_view_multi_device\": true,\n" +
    "            \"block_counts\": {\n" +
    "                \"video\": 0\n" +
    "            },\n" +
    "            \"descendants\": [],\n" +
    "            \"completion\": 1.0\n" +
    "        },\n" +
    "        \"block-v1:RG+MC01+2022+type@video+block@d1bb8c9e6ed44b708ea54cacf67b650a\": {\n" +
    "            \"id\": \"block-v1:RG+MC01+2022+type@video+block@d1bb8c9e6ed44b708ea54cacf67b650a\",\n" +
    "            \"block_id\": \"d1bb8c9e6ed44b708ea54cacf67b650a\",\n" +
    "            \"lms_web_url\": \"https://lms-client-demo-maple.raccoongang.com/courses/course-v1:RG+MC01+2022/jump_to/block-v1:RG+MC01+2022+type@video+block@d1bb8c9e6ed44b708ea54cacf67b650a\",\n" +
    "            \"legacy_web_url\": \"https://lms-client-demo-maple.raccoongang.com/courses/course-v1:RG+MC01+2022/jump_to/block-v1:RG+MC01+2022+type@video+block@d1bb8c9e6ed44b708ea54cacf67b650a?experience=legacy\",\n" +
    "            \"student_view_url\": \"https://lms-client-demo-maple.raccoongang.com/xblock/block-v1:RG+MC01+2022+type@video+block@d1bb8c9e6ed44b708ea54cacf67b650a\",\n" +
    "            \"type\": \"video\",\n" +
    "            \"display_name\": \"Video\",\n" +
    "            \"graded\": false,\n" +
    "            \"student_view_data\": {\n" +
    "                \"only_on_web\": false,\n" +
    "                \"duration\": null,\n" +
    "                \"transcripts\": {\n" +
    "                    \"en\": \"https://lms-client-demo-maple.raccoongang.com/courses/course-v1:RG+MC01+2022/xblock/block-v1:RG+MC01+2022+type@video+block@d1bb8c9e6ed44b708ea54cacf67b650a/handler_noauth/transcript/download?lang=en\"\n" +
    "                },\n" +
    "                \"encoded_videos\": {\n" +
    "                    \"youtube\": {\n" +
    "                        \"url\": \"https://www.youtube.com/watch?v=3_yD_cEKoCk\",\n" +
    "                        \"file_size\": 0\n" +
    "                    }\n" +
    "                },\n" +
    "                \"all_sources\": []\n" +
    "            },\n" +
    "            \"student_view_multi_device\": false,\n" +
    "            \"block_counts\": {\n" +
    "                \"video\": 1\n" +
    "            },\n" +
    "            \"descendants\": [],\n" +
    "            \"completion\": 0.0\n" +
    "        },\n" +
    "        \"block-v1:RG+MC01+2022+type@vertical+block@8ccbceb2abec4028a9cc8b1fecf5e7d8\": {\n" +
    "            \"id\": \"block-v1:RG+MC01+2022+type@vertical+block@8ccbceb2abec4028a9cc8b1fecf5e7d8\",\n" +
    "            \"block_id\": \"8ccbceb2abec4028a9cc8b1fecf5e7d8\",\n" +
    "            \"lms_web_url\": \"https://lms-client-demo-maple.raccoongang.com/courses/course-v1:RG+MC01+2022/jump_to/block-v1:RG+MC01+2022+type@vertical+block@8ccbceb2abec4028a9cc8b1fecf5e7d8\",\n" +
    "            \"legacy_web_url\": \"https://lms-client-demo-maple.raccoongang.com/courses/course-v1:RG+MC01+2022/jump_to/block-v1:RG+MC01+2022+type@vertical+block@8ccbceb2abec4028a9cc8b1fecf5e7d8?experience=legacy\",\n" +
    "            \"student_view_url\": \"https://lms-client-demo-maple.raccoongang.com/xblock/block-v1:RG+MC01+2022+type@vertical+block@8ccbceb2abec4028a9cc8b1fecf5e7d8\",\n" +
    "            \"type\": \"vertical\",\n" +
    "            \"display_name\": \"Welcome!\",\n" +
    "            \"graded\": false,\n" +
    "            \"student_view_multi_device\": false,\n" +
    "            \"block_counts\": {\n" +
    "                \"video\": 1\n" +
    "            },\n" +
    "            \"descendants\": [\n" +
    "                \"block-v1:RG+MC01+2022+type@html+block@8718fdf95d584d198a3b17c0d2611139\",\n" +
    "                \"block-v1:RG+MC01+2022+type@video+block@d1bb8c9e6ed44b708ea54cacf67b650a\"\n" +
    "            ],\n" +
    "            \"completion\": 0\n" +
    "        },\n" +
    "        \"block-v1:RG+MC01+2022+type@html+block@5735347ae4be44d5b184728661d79bb4\": {\n" +
    "            \"id\": \"block-v1:RG+MC01+2022+type@html+block@5735347ae4be44d5b184728661d79bb4\",\n" +
    "            \"block_id\": \"5735347ae4be44d5b184728661d79bb4\",\n" +
    "            \"lms_web_url\": \"https://lms-client-demo-maple.raccoongang.com/courses/course-v1:RG+MC01+2022/jump_to/block-v1:RG+MC01+2022+type@html+block@5735347ae4be44d5b184728661d79bb4\",\n" +
    "            \"legacy_web_url\": \"https://lms-client-demo-maple.raccoongang.com/courses/course-v1:RG+MC01+2022/jump_to/block-v1:RG+MC01+2022+type@html+block@5735347ae4be44d5b184728661d79bb4?experience=legacy\",\n" +
    "            \"student_view_url\": \"https://lms-client-demo-maple.raccoongang.com/xblock/block-v1:RG+MC01+2022+type@html+block@5735347ae4be44d5b184728661d79bb4\",\n" +
    "            \"type\": \"html\",\n" +
    "            \"display_name\": \"Text\",\n" +
    "            \"graded\": false,\n" +
    "            \"student_view_data\": {\n" +
    "                \"enabled\": false,\n" +
    "                \"message\": \"To enable, set FEATURES[\\\"ENABLE_HTML_XBLOCK_STUDENT_VIEW_DATA\\\"]\"\n" +
    "            },\n" +
    "            \"student_view_multi_device\": true,\n" +
    "            \"block_counts\": {\n" +
    "                \"video\": 0\n" +
    "            },\n" +
    "            \"descendants\": [],\n" +
    "            \"completion\": 1.0\n" +
    "        },\n" +
    "        \"block-v1:RG+MC01+2022+type@discussion+block@0b26805b246c44148a2c02dfbffa2b27\": {\n" +
    "            \"id\": \"block-v1:RG+MC01+2022+type@discussion+block@0b26805b246c44148a2c02dfbffa2b27\",\n" +
    "            \"block_id\": \"0b26805b246c44148a2c02dfbffa2b27\",\n" +
    "            \"lms_web_url\": \"https://lms-client-demo-maple.raccoongang.com/courses/course-v1:RG+MC01+2022/jump_to/block-v1:RG+MC01+2022+type@discussion+block@0b26805b246c44148a2c02dfbffa2b27\",\n" +
    "            \"legacy_web_url\": \"https://lms-client-demo-maple.raccoongang.com/courses/course-v1:RG+MC01+2022/jump_to/block-v1:RG+MC01+2022+type@discussion+block@0b26805b246c44148a2c02dfbffa2b27?experience=legacy\",\n" +
    "            \"student_view_url\": \"https://lms-client-demo-maple.raccoongang.com/xblock/block-v1:RG+MC01+2022+type@discussion+block@0b26805b246c44148a2c02dfbffa2b27\",\n" +
    "            \"type\": \"discussion\",\n" +
    "            \"display_name\": \"Discussion\",\n" +
    "            \"graded\": false,\n" +
    "            \"student_view_data\": {\n" +
    "                \"topic_id\": \"035315aac3f889b472c8f051d8fd0abaa99682de\"\n" +
    "            },\n" +
    "            \"student_view_multi_device\": false,\n" +
    "            \"block_counts\": {\n" +
    "                \"video\": 0\n" +
    "            },\n" +
    "            \"descendants\": []\n" +
    "        },\n" +
    "        \"block-v1:RG+MC01+2022+type@vertical+block@890277efe17a42a185c68b8ba8fc5a98\": {\n" +
    "            \"id\": \"block-v1:RG+MC01+2022+type@vertical+block@890277efe17a42a185c68b8ba8fc5a98\",\n" +
    "            \"block_id\": \"890277efe17a42a185c68b8ba8fc5a98\",\n" +
    "            \"lms_web_url\": \"https://lms-client-demo-maple.raccoongang.com/courses/course-v1:RG+MC01+2022/jump_to/block-v1:RG+MC01+2022+type@vertical+block@890277efe17a42a185c68b8ba8fc5a98\",\n" +
    "            \"legacy_web_url\": \"https://lms-client-demo-maple.raccoongang.com/courses/course-v1:RG+MC01+2022/jump_to/block-v1:RG+MC01+2022+type@vertical+block@890277efe17a42a185c68b8ba8fc5a98?experience=legacy\",\n" +
    "            \"student_view_url\": \"https://lms-client-demo-maple.raccoongang.com/xblock/block-v1:RG+MC01+2022+type@vertical+block@890277efe17a42a185c68b8ba8fc5a98\",\n" +
    "            \"type\": \"vertical\",\n" +
    "            \"display_name\": \"General Info\",\n" +
    "            \"graded\": false,\n" +
    "            \"student_view_multi_device\": false,\n" +
    "            \"block_counts\": {\n" +
    "                \"video\": 0\n" +
    "            },\n" +
    "            \"descendants\": [\n" +
    "                \"block-v1:RG+MC01+2022+type@html+block@5735347ae4be44d5b184728661d79bb4\",\n" +
    "                \"block-v1:RG+MC01+2022+type@discussion+block@0b26805b246c44148a2c02dfbffa2b27\"\n" +
    "            ],\n" +
    "            \"completion\": 1\n" +
    "        },\n" +
    "        \"block-v1:RG+MC01+2022+type@sequential+block@45b174bf007b4d86a3a265d996565883\": {\n" +
    "            \"id\": \"block-v1:RG+MC01+2022+type@sequential+block@45b174bf007b4d86a3a265d996565883\",\n" +
    "            \"block_id\": \"45b174bf007b4d86a3a265d996565883\",\n" +
    "            \"lms_web_url\": \"https://lms-client-demo-maple.raccoongang.com/courses/course-v1:RG+MC01+2022/jump_to/block-v1:RG+MC01+2022+type@sequential+block@45b174bf007b4d86a3a265d996565883\",\n" +
    "            \"legacy_web_url\": \"https://lms-client-demo-maple.raccoongang.com/courses/course-v1:RG+MC01+2022/jump_to/block-v1:RG+MC01+2022+type@sequential+block@45b174bf007b4d86a3a265d996565883?experience=legacy\",\n" +
    "            \"student_view_url\": \"https://lms-client-demo-maple.raccoongang.com/xblock/block-v1:RG+MC01+2022+type@sequential+block@45b174bf007b4d86a3a265d996565883\",\n" +
    "            \"type\": \"sequential\",\n" +
    "            \"display_name\": \"Course Intro\",\n" +
    "            \"graded\": false,\n" +
    "            \"student_view_multi_device\": false,\n" +
    "            \"block_counts\": {\n" +
    "                \"video\": 1\n" +
    "            },\n" +
    "            \"descendants\": [\n" +
    "                \"block-v1:RG+MC01+2022+type@vertical+block@8ccbceb2abec4028a9cc8b1fecf5e7d8\",\n" +
    "                \"block-v1:RG+MC01+2022+type@vertical+block@890277efe17a42a185c68b8ba8fc5a98\"\n" +
    "            ],\n" +
    "            \"completion\": 0\n" +
    "        },\n" +
    "        \"block-v1:RG+MC01+2022+type@chapter+block@7cb5739b6ead4fc39b126bbe56cdb9c7\": {\n" +
    "            \"id\": \"block-v1:RG+MC01+2022+type@chapter+block@7cb5739b6ead4fc39b126bbe56cdb9c7\",\n" +
    "            \"block_id\": \"7cb5739b6ead4fc39b126bbe56cdb9c7\",\n" +
    "            \"lms_web_url\": \"https://lms-client-demo-maple.raccoongang.com/courses/course-v1:RG+MC01+2022/jump_to/block-v1:RG+MC01+2022+type@chapter+block@7cb5739b6ead4fc39b126bbe56cdb9c7\",\n" +
    "            \"legacy_web_url\": \"https://lms-client-demo-maple.raccoongang.com/courses/course-v1:RG+MC01+2022/jump_to/block-v1:RG+MC01+2022+type@chapter+block@7cb5739b6ead4fc39b126bbe56cdb9c7?experience=legacy\",\n" +
    "            \"student_view_url\": \"https://lms-client-demo-maple.raccoongang.com/xblock/block-v1:RG+MC01+2022+type@chapter+block@7cb5739b6ead4fc39b126bbe56cdb9c7\",\n" +
    "            \"type\": \"chapter\",\n" +
    "            \"display_name\": \"Info Section\",\n" +
    "            \"graded\": false,\n" +
    "            \"student_view_multi_device\": false,\n" +
    "            \"block_counts\": {\n" +
    "                \"video\": 1\n" +
    "            },\n" +
    "            \"descendants\": [\n" +
    "                \"block-v1:RG+MC01+2022+type@sequential+block@45b174bf007b4d86a3a265d996565883\"\n" +
    "            ],\n" +
    "            \"completion\": 0\n" +
    "        },\n" +
    "        \"block-v1:RG+MC01+2022+type@problem+block@376ec419a01449fd86c2d11c8054d0be\": {\n" +
    "            \"id\": \"block-v1:RG+MC01+2022+type@problem+block@376ec419a01449fd86c2d11c8054d0be\",\n" +
    "            \"block_id\": \"376ec419a01449fd86c2d11c8054d0be\",\n" +
    "            \"lms_web_url\": \"https://lms-client-demo-maple.raccoongang.com/courses/course-v1:RG+MC01+2022/jump_to/block-v1:RG+MC01+2022+type@problem+block@376ec419a01449fd86c2d11c8054d0be\",\n" +
    "            \"legacy_web_url\": \"https://lms-client-demo-maple.raccoongang.com/courses/course-v1:RG+MC01+2022/jump_to/block-v1:RG+MC01+2022+type@problem+block@376ec419a01449fd86c2d11c8054d0be?experience=legacy\",\n" +
    "            \"student_view_url\": \"https://lms-client-demo-maple.raccoongang.com/xblock/block-v1:RG+MC01+2022+type@problem+block@376ec419a01449fd86c2d11c8054d0be\",\n" +
    "            \"type\": \"problem\",\n" +
    "            \"display_name\": \"Checkboxes\",\n" +
    "            \"graded\": true,\n" +
    "            \"student_view_multi_device\": true,\n" +
    "            \"block_counts\": {\n" +
    "                \"video\": 0\n" +
    "            },\n" +
    "            \"descendants\": [],\n" +
    "            \"completion\": 1.0\n" +
    "        },\n" +
    "        \"block-v1:RG+MC01+2022+type@problem+block@ebc2d20fad364992b13fff49fc53d7cf\": {\n" +
    "            \"id\": \"block-v1:RG+MC01+2022+type@problem+block@ebc2d20fad364992b13fff49fc53d7cf\",\n" +
    "            \"block_id\": \"ebc2d20fad364992b13fff49fc53d7cf\",\n" +
    "            \"lms_web_url\": \"https://lms-client-demo-maple.raccoongang.com/courses/course-v1:RG+MC01+2022/jump_to/block-v1:RG+MC01+2022+type@problem+block@ebc2d20fad364992b13fff49fc53d7cf\",\n" +
    "            \"legacy_web_url\": \"https://lms-client-demo-maple.raccoongang.com/courses/course-v1:RG+MC01+2022/jump_to/block-v1:RG+MC01+2022+type@problem+block@ebc2d20fad364992b13fff49fc53d7cf?experience=legacy\",\n" +
    "            \"student_view_url\": \"https://lms-client-demo-maple.raccoongang.com/xblock/block-v1:RG+MC01+2022+type@problem+block@ebc2d20fad364992b13fff49fc53d7cf\",\n" +
    "            \"type\": \"problem\",\n" +
    "            \"display_name\": \"Dropdown\",\n" +
    "            \"graded\": true,\n" +
    "            \"student_view_multi_device\": true,\n" +
    "            \"block_counts\": {\n" +
    "                \"video\": 0\n" +
    "            },\n" +
    "            \"descendants\": [],\n" +
    "            \"completion\": 1.0\n" +
    "        },\n" +
    "        \"block-v1:RG+MC01+2022+type@problem+block@6b822c82f2ca4b049ee380a1cf65396b\": {\n" +
    "            \"id\": \"block-v1:RG+MC01+2022+type@problem+block@6b822c82f2ca4b049ee380a1cf65396b\",\n" +
    "            \"block_id\": \"6b822c82f2ca4b049ee380a1cf65396b\",\n" +
    "            \"lms_web_url\": \"https://lms-client-demo-maple.raccoongang.com/courses/course-v1:RG+MC01+2022/jump_to/block-v1:RG+MC01+2022+type@problem+block@6b822c82f2ca4b049ee380a1cf65396b\",\n" +
    "            \"legacy_web_url\": \"https://lms-client-demo-maple.raccoongang.com/courses/course-v1:RG+MC01+2022/jump_to/block-v1:RG+MC01+2022+type@problem+block@6b822c82f2ca4b049ee380a1cf65396b?experience=legacy\",\n" +
    "            \"student_view_url\": \"https://lms-client-demo-maple.raccoongang.com/xblock/block-v1:RG+MC01+2022+type@problem+block@6b822c82f2ca4b049ee380a1cf65396b\",\n" +
    "            \"type\": \"problem\",\n" +
    "            \"display_name\": \"Numerical Input with Hints and Feedback\",\n" +
    "            \"graded\": true,\n" +
    "            \"student_view_multi_device\": true,\n" +
    "            \"block_counts\": {\n" +
    "                \"video\": 0\n" +
    "            },\n" +
    "            \"descendants\": [],\n" +
    "            \"completion\": 1.0\n" +
    "        },\n" +
    "        \"block-v1:RG+MC01+2022+type@problem+block@009da5f764a04078855d322e205c5863\": {\n" +
    "            \"id\": \"block-v1:RG+MC01+2022+type@problem+block@009da5f764a04078855d322e205c5863\",\n" +
    "            \"block_id\": \"009da5f764a04078855d322e205c5863\",\n" +
    "            \"lms_web_url\": \"https://lms-client-demo-maple.raccoongang.com/courses/course-v1:RG+MC01+2022/jump_to/block-v1:RG+MC01+2022+type@problem+block@009da5f764a04078855d322e205c5863\",\n" +
    "            \"legacy_web_url\": \"https://lms-client-demo-maple.raccoongang.com/courses/course-v1:RG+MC01+2022/jump_to/block-v1:RG+MC01+2022+type@problem+block@009da5f764a04078855d322e205c5863?experience=legacy\",\n" +
    "            \"student_view_url\": \"https://lms-client-demo-maple.raccoongang.com/xblock/block-v1:RG+MC01+2022+type@problem+block@009da5f764a04078855d322e205c5863\",\n" +
    "            \"type\": \"problem\",\n" +
    "            \"display_name\": \"Multiple Choice\",\n" +
    "            \"graded\": true,\n" +
    "            \"student_view_multi_device\": true,\n" +
    "            \"block_counts\": {\n" +
    "                \"video\": 0\n" +
    "            },\n" +
    "            \"descendants\": [],\n" +
    "            \"completion\": 1.0\n" +
    "        },\n" +
    "        \"block-v1:RG+MC01+2022+type@vertical+block@e34d9616cbaa45d1a6986a687c49f5c4\": {\n" +
    "            \"id\": \"block-v1:RG+MC01+2022+type@vertical+block@e34d9616cbaa45d1a6986a687c49f5c4\",\n" +
    "            \"block_id\": \"e34d9616cbaa45d1a6986a687c49f5c4\",\n" +
    "            \"lms_web_url\": \"https://lms-client-demo-maple.raccoongang.com/courses/course-v1:RG+MC01+2022/jump_to/block-v1:RG+MC01+2022+type@vertical+block@e34d9616cbaa45d1a6986a687c49f5c4\",\n" +
    "            \"legacy_web_url\": \"https://lms-client-demo-maple.raccoongang.com/courses/course-v1:RG+MC01+2022/jump_to/block-v1:RG+MC01+2022+type@vertical+block@e34d9616cbaa45d1a6986a687c49f5c4?experience=legacy\",\n" +
    "            \"student_view_url\": \"https://lms-client-demo-maple.raccoongang.com/xblock/block-v1:RG+MC01+2022+type@vertical+block@e34d9616cbaa45d1a6986a687c49f5c4\",\n" +
    "            \"type\": \"vertical\",\n" +
    "            \"display_name\": \"Common Problems\",\n" +
    "            \"graded\": true,\n" +
    "            \"student_view_multi_device\": false,\n" +
    "            \"block_counts\": {\n" +
    "                \"video\": 0\n" +
    "            },\n" +
    "            \"descendants\": [\n" +
    "                \"block-v1:RG+MC01+2022+type@problem+block@376ec419a01449fd86c2d11c8054d0be\",\n" +
    "                \"block-v1:RG+MC01+2022+type@problem+block@ebc2d20fad364992b13fff49fc53d7cf\",\n" +
    "                \"block-v1:RG+MC01+2022+type@problem+block@6b822c82f2ca4b049ee380a1cf65396b\",\n" +
    "                \"block-v1:RG+MC01+2022+type@problem+block@009da5f764a04078855d322e205c5863\"\n" +
    "            ],\n" +
    "            \"completion\": 1\n" +
    "        },\n" +
    "        \"block-v1:RG+MC01+2022+type@sequential+block@ac7862e8c3c9481bbe657a82795def56\": {\n" +
    "            \"id\": \"block-v1:RG+MC01+2022+type@sequential+block@ac7862e8c3c9481bbe657a82795def56\",\n" +
    "            \"block_id\": \"ac7862e8c3c9481bbe657a82795def56\",\n" +
    "            \"lms_web_url\": \"https://lms-client-demo-maple.raccoongang.com/courses/course-v1:RG+MC01+2022/jump_to/block-v1:RG+MC01+2022+type@sequential+block@ac7862e8c3c9481bbe657a82795def56\",\n" +
    "            \"legacy_web_url\": \"https://lms-client-demo-maple.raccoongang.com/courses/course-v1:RG+MC01+2022/jump_to/block-v1:RG+MC01+2022+type@sequential+block@ac7862e8c3c9481bbe657a82795def56?experience=legacy\",\n" +
    "            \"student_view_url\": \"https://lms-client-demo-maple.raccoongang.com/xblock/block-v1:RG+MC01+2022+type@sequential+block@ac7862e8c3c9481bbe657a82795def56\",\n" +
    "            \"type\": \"sequential\",\n" +
    "            \"display_name\": \"Test\",\n" +
    "            \"graded\": true,\n" +
    "            \"format\": \"Final Exam\",\n" +
    "            \"student_view_multi_device\": false,\n" +
    "            \"block_counts\": {\n" +
    "                \"video\": 0\n" +
    "            },\n" +
    "            \"descendants\": [\n" +
    "                \"block-v1:RG+MC01+2022+type@vertical+block@e34d9616cbaa45d1a6986a687c49f5c4\"\n" +
    "            ],\n" +
    "            \"completion\": 1\n" +
    "        },\n" +
    "        \"block-v1:RG+MC01+2022+type@problem+block@9355144723fc4270a1081547fd8bdd3d\": {\n" +
    "            \"id\": \"block-v1:RG+MC01+2022+type@problem+block@9355144723fc4270a1081547fd8bdd3d\",\n" +
    "            \"block_id\": \"9355144723fc4270a1081547fd8bdd3d\",\n" +
    "            \"lms_web_url\": \"https://lms-client-demo-maple.raccoongang.com/courses/course-v1:RG+MC01+2022/jump_to/block-v1:RG+MC01+2022+type@problem+block@9355144723fc4270a1081547fd8bdd3d\",\n" +
    "            \"legacy_web_url\": \"https://lms-client-demo-maple.raccoongang.com/courses/course-v1:RG+MC01+2022/jump_to/block-v1:RG+MC01+2022+type@problem+block@9355144723fc4270a1081547fd8bdd3d?experience=legacy\",\n" +
    "            \"student_view_url\": \"https://lms-client-demo-maple.raccoongang.com/xblock/block-v1:RG+MC01+2022+type@problem+block@9355144723fc4270a1081547fd8bdd3d\",\n" +
    "            \"type\": \"problem\",\n" +
    "            \"display_name\": \"Image Mapped Input\",\n" +
    "            \"graded\": false,\n" +
    "            \"student_view_multi_device\": false,\n" +
    "            \"block_counts\": {\n" +
    "                \"video\": 0\n" +
    "            },\n" +
    "            \"descendants\": [],\n" +
    "            \"completion\": 0.0\n" +
    "        },\n" +
    "        \"block-v1:RG+MC01+2022+type@vertical+block@50d42e9c9d91451fb50693e01b9e4340\": {\n" +
    "            \"id\": \"block-v1:RG+MC01+2022+type@vertical+block@50d42e9c9d91451fb50693e01b9e4340\",\n" +
    "            \"block_id\": \"50d42e9c9d91451fb50693e01b9e4340\",\n" +
    "            \"lms_web_url\": \"https://lms-client-demo-maple.raccoongang.com/courses/course-v1:RG+MC01+2022/jump_to/block-v1:RG+MC01+2022+type@vertical+block@50d42e9c9d91451fb50693e01b9e4340\",\n" +
    "            \"legacy_web_url\": \"https://lms-client-demo-maple.raccoongang.com/courses/course-v1:RG+MC01+2022/jump_to/block-v1:RG+MC01+2022+type@vertical+block@50d42e9c9d91451fb50693e01b9e4340?experience=legacy\",\n" +
    "            \"student_view_url\": \"https://lms-client-demo-maple.raccoongang.com/xblock/block-v1:RG+MC01+2022+type@vertical+block@50d42e9c9d91451fb50693e01b9e4340\",\n" +
    "            \"type\": \"vertical\",\n" +
    "            \"display_name\": \"Advanced Problems\",\n" +
    "            \"graded\": false,\n" +
    "            \"student_view_multi_device\": false,\n" +
    "            \"block_counts\": {\n" +
    "                \"video\": 0\n" +
    "            },\n" +
    "            \"descendants\": [\n" +
    "                \"block-v1:RG+MC01+2022+type@problem+block@9355144723fc4270a1081547fd8bdd3d\"\n" +
    "            ],\n" +
    "            \"completion\": 0\n" +
    "        },\n" +
    "        \"block-v1:RG+MC01+2022+type@sequential+block@5cdb10d7d0e9498faba55450173e23be\": {\n" +
    "            \"id\": \"block-v1:RG+MC01+2022+type@sequential+block@5cdb10d7d0e9498faba55450173e23be\",\n" +
    "            \"block_id\": \"5cdb10d7d0e9498faba55450173e23be\",\n" +
    "            \"lms_web_url\": \"https://lms-client-demo-maple.raccoongang.com/courses/course-v1:RG+MC01+2022/jump_to/block-v1:RG+MC01+2022+type@sequential+block@5cdb10d7d0e9498faba55450173e23be\",\n" +
    "            \"legacy_web_url\": \"https://lms-client-demo-maple.raccoongang.com/courses/course-v1:RG+MC01+2022/jump_to/block-v1:RG+MC01+2022+type@sequential+block@5cdb10d7d0e9498faba55450173e23be?experience=legacy\",\n" +
    "            \"student_view_url\": \"https://lms-client-demo-maple.raccoongang.com/xblock/block-v1:RG+MC01+2022+type@sequential+block@5cdb10d7d0e9498faba55450173e23be\",\n" +
    "            \"type\": \"sequential\",\n" +
    "            \"display_name\": \"X-blocks not supported in app\",\n" +
    "            \"graded\": false,\n" +
    "            \"student_view_multi_device\": false,\n" +
    "            \"block_counts\": {\n" +
    "                \"video\": 0\n" +
    "            },\n" +
    "            \"descendants\": [\n" +
    "                \"block-v1:RG+MC01+2022+type@vertical+block@50d42e9c9d91451fb50693e01b9e4340\"\n" +
    "            ],\n" +
    "            \"completion\": 0\n" +
    "        },\n" +
    "        \"block-v1:RG+MC01+2022+type@chapter+block@8f208b5d63234ce483f7d6702c46238a\": {\n" +
    "            \"id\": \"block-v1:RG+MC01+2022+type@chapter+block@8f208b5d63234ce483f7d6702c46238a\",\n" +
    "            \"block_id\": \"8f208b5d63234ce483f7d6702c46238a\",\n" +
    "            \"lms_web_url\": \"https://lms-client-demo-maple.raccoongang.com/courses/course-v1:RG+MC01+2022/jump_to/block-v1:RG+MC01+2022+type@chapter+block@8f208b5d63234ce483f7d6702c46238a\",\n" +
    "            \"legacy_web_url\": \"https://lms-client-demo-maple.raccoongang.com/courses/course-v1:RG+MC01+2022/jump_to/block-v1:RG+MC01+2022+type@chapter+block@8f208b5d63234ce483f7d6702c46238a?experience=legacy\",\n" +
    "            \"student_view_url\": \"https://lms-client-demo-maple.raccoongang.com/xblock/block-v1:RG+MC01+2022+type@chapter+block@8f208b5d63234ce483f7d6702c46238a\",\n" +
    "            \"type\": \"chapter\",\n" +
    "            \"display_name\": \"Problems\",\n" +
    "            \"graded\": false,\n" +
    "            \"student_view_multi_device\": false,\n" +
    "            \"block_counts\": {\n" +
    "                \"video\": 0\n" +
    "            },\n" +
    "            \"descendants\": [\n" +
    "                \"block-v1:RG+MC01+2022+type@sequential+block@ac7862e8c3c9481bbe657a82795def56\",\n" +
    "                \"block-v1:RG+MC01+2022+type@sequential+block@5cdb10d7d0e9498faba55450173e23be\"\n" +
    "            ],\n" +
    "            \"completion\": 0\n" +
    "        },\n" +
    "        \"block-v1:RG+MC01+2022+type@html+block@4b0ea9edbf59484fb5ecc1f8f29f73c2\": {\n" +
    "            \"id\": \"block-v1:RG+MC01+2022+type@html+block@4b0ea9edbf59484fb5ecc1f8f29f73c2\",\n" +
    "            \"block_id\": \"4b0ea9edbf59484fb5ecc1f8f29f73c2\",\n" +
    "            \"lms_web_url\": \"https://lms-client-demo-maple.raccoongang.com/courses/course-v1:RG+MC01+2022/jump_to/block-v1:RG+MC01+2022+type@html+block@4b0ea9edbf59484fb5ecc1f8f29f73c2\",\n" +
    "            \"legacy_web_url\": \"https://lms-client-demo-maple.raccoongang.com/courses/course-v1:RG+MC01+2022/jump_to/block-v1:RG+MC01+2022+type@html+block@4b0ea9edbf59484fb5ecc1f8f29f73c2?experience=legacy\",\n" +
    "            \"student_view_url\": \"https://lms-client-demo-maple.raccoongang.com/xblock/block-v1:RG+MC01+2022+type@html+block@4b0ea9edbf59484fb5ecc1f8f29f73c2\",\n" +
    "            \"type\": \"html\",\n" +
    "            \"display_name\": \"Text\",\n" +
    "            \"graded\": false,\n" +
    "            \"student_view_data\": {\n" +
    "                \"enabled\": false,\n" +
    "                \"message\": \"To enable, set FEATURES[\\\"ENABLE_HTML_XBLOCK_STUDENT_VIEW_DATA\\\"]\"\n" +
    "            },\n" +
    "            \"student_view_multi_device\": true,\n" +
    "            \"block_counts\": {\n" +
    "                \"video\": 0\n" +
    "            },\n" +
    "            \"descendants\": [],\n" +
    "            \"completion\": 1.0\n" +
    "        },\n" +
    "        \"block-v1:RG+MC01+2022+type@vertical+block@b912f9ba42ac43c492bfb423e15b0da1\": {\n" +
    "            \"id\": \"block-v1:RG+MC01+2022+type@vertical+block@b912f9ba42ac43c492bfb423e15b0da1\",\n" +
    "            \"block_id\": \"b912f9ba42ac43c492bfb423e15b0da1\",\n" +
    "            \"lms_web_url\": \"https://lms-client-demo-maple.raccoongang.com/courses/course-v1:RG+MC01+2022/jump_to/block-v1:RG+MC01+2022+type@vertical+block@b912f9ba42ac43c492bfb423e15b0da1\",\n" +
    "            \"legacy_web_url\": \"https://lms-client-demo-maple.raccoongang.com/courses/course-v1:RG+MC01+2022/jump_to/block-v1:RG+MC01+2022+type@vertical+block@b912f9ba42ac43c492bfb423e15b0da1?experience=legacy\",\n" +
    "            \"student_view_url\": \"https://lms-client-demo-maple.raccoongang.com/xblock/block-v1:RG+MC01+2022+type@vertical+block@b912f9ba42ac43c492bfb423e15b0da1\",\n" +
    "            \"type\": \"vertical\",\n" +
    "            \"display_name\": \"Thank you\",\n" +
    "            \"graded\": false,\n" +
    "            \"student_view_multi_device\": false,\n" +
    "            \"block_counts\": {\n" +
    "                \"video\": 0\n" +
    "            },\n" +
    "            \"descendants\": [\n" +
    "                \"block-v1:RG+MC01+2022+type@html+block@4b0ea9edbf59484fb5ecc1f8f29f73c2\"\n" +
    "            ],\n" +
    "            \"completion\": 1\n" +
    "        },\n" +
    "        \"block-v1:RG+MC01+2022+type@sequential+block@a6e2101867234019b60607a9b9bf64f9\": {\n" +
    "            \"id\": \"block-v1:RG+MC01+2022+type@sequential+block@a6e2101867234019b60607a9b9bf64f9\",\n" +
    "            \"block_id\": \"a6e2101867234019b60607a9b9bf64f9\",\n" +
    "            \"lms_web_url\": \"https://lms-client-demo-maple.raccoongang.com/courses/course-v1:RG+MC01+2022/jump_to/block-v1:RG+MC01+2022+type@sequential+block@a6e2101867234019b60607a9b9bf64f9\",\n" +
    "            \"legacy_web_url\": \"https://lms-client-demo-maple.raccoongang.com/courses/course-v1:RG+MC01+2022/jump_to/block-v1:RG+MC01+2022+type@sequential+block@a6e2101867234019b60607a9b9bf64f9?experience=legacy\",\n" +
    "            \"student_view_url\": \"https://lms-client-demo-maple.raccoongang.com/xblock/block-v1:RG+MC01+2022+type@sequential+block@a6e2101867234019b60607a9b9bf64f9\",\n" +
    "            \"type\": \"sequential\",\n" +
    "            \"display_name\": \"Thank you note\",\n" +
    "            \"graded\": false,\n" +
    "            \"student_view_multi_device\": false,\n" +
    "            \"block_counts\": {\n" +
    "                \"video\": 0\n" +
    "            },\n" +
    "            \"descendants\": [\n" +
    "                \"block-v1:RG+MC01+2022+type@vertical+block@b912f9ba42ac43c492bfb423e15b0da1\"\n" +
    "            ],\n" +
    "            \"completion\": 1\n" +
    "        },\n" +
    "        \"block-v1:RG+MC01+2022+type@chapter+block@29f4043d199e46ef95d437da3be1d222\": {\n" +
    "            \"id\": \"block-v1:RG+MC01+2022+type@chapter+block@29f4043d199e46ef95d437da3be1d222\",\n" +
    "            \"block_id\": \"29f4043d199e46ef95d437da3be1d222\",\n" +
    "            \"lms_web_url\": \"https://lms-client-demo-maple.raccoongang.com/courses/course-v1:RG+MC01+2022/jump_to/block-v1:RG+MC01+2022+type@chapter+block@29f4043d199e46ef95d437da3be1d222\",\n" +
    "            \"legacy_web_url\": \"https://lms-client-demo-maple.raccoongang.com/courses/course-v1:RG+MC01+2022/jump_to/block-v1:RG+MC01+2022+type@chapter+block@29f4043d199e46ef95d437da3be1d222?experience=legacy\",\n" +
    "            \"student_view_url\": \"https://lms-client-demo-maple.raccoongang.com/xblock/block-v1:RG+MC01+2022+type@chapter+block@29f4043d199e46ef95d437da3be1d222\",\n" +
    "            \"type\": \"chapter\",\n" +
    "            \"display_name\": \"Fin\",\n" +
    "            \"graded\": false,\n" +
    "            \"student_view_multi_device\": false,\n" +
    "            \"block_counts\": {\n" +
    "                \"video\": 0\n" +
    "            },\n" +
    "            \"descendants\": [\n" +
    "                \"block-v1:RG+MC01+2022+type@sequential+block@a6e2101867234019b60607a9b9bf64f9\"\n" +
    "            ],\n" +
    "            \"completion\": 1\n" +
    "        },\n" +
    "        \"block-v1:RG+MC01+2022+type@course+block@course\": {\n" +
    "            \"id\": \"block-v1:RG+MC01+2022+type@course+block@course\",\n" +
    "            \"block_id\": \"course\",\n" +
    "            \"lms_web_url\": \"https://lms-client-demo-maple.raccoongang.com/courses/course-v1:RG+MC01+2022/jump_to/block-v1:RG+MC01+2022+type@course+block@course\",\n" +
    "            \"legacy_web_url\": \"https://lms-client-demo-maple.raccoongang.com/courses/course-v1:RG+MC01+2022/jump_to/block-v1:RG+MC01+2022+type@course+block@course?experience=legacy\",\n" +
    "            \"student_view_url\": \"https://lms-client-demo-maple.raccoongang.com/xblock/block-v1:RG+MC01+2022+type@course+block@course\",\n" +
    "            \"type\": \"course\",\n" +
    "            \"display_name\": \"Mobile Course Demo\",\n" +
    "            \"graded\": false,\n" +
    "            \"student_view_multi_device\": false,\n" +
    "            \"block_counts\": {\n" +
    "                \"video\": 1\n" +
    "            },\n" +
    "            \"descendants\": [\n" +
    "                \"block-v1:RG+MC01+2022+type@chapter+block@7cb5739b6ead4fc39b126bbe56cdb9c7\",\n" +
    "                \"block-v1:RG+MC01+2022+type@chapter+block@8f208b5d63234ce483f7d6702c46238a\",\n" +
    "                \"block-v1:RG+MC01+2022+type@chapter+block@29f4043d199e46ef95d437da3be1d222\"\n" +
    "            ],\n" +
    "            \"completion\": 0\n" +
    "        }\n" +
    "    }\n" +
    "}"
}

#endif

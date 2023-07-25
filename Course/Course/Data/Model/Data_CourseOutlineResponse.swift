//
//  CourseOutlineResponse.swift
//  CourseOutline
//
//  Created by  Stepanok Ivan on 28.09.2022.
//

import Foundation
import CoreData
import Core

public extension DataLayer {
    
    typealias Blocks = [String: CourseBlock]
    
    struct CourseStructure: Decodable {
        public let rootItem: String
        public var dict: Blocks
        public let id: String
        public let media: DataLayer.CourseMedia
        public let certificate: Certificate?
        
        enum CodingKeys: String, CodingKey {
            case blocks
            case rootItem = "root"
            case id
            case media
            case certificate
        }
        
        public init(rootItem: String, dict: Blocks, id: String, media: DataLayer.CourseMedia, certificate: Certificate?) {
            self.rootItem = rootItem
            self.dict = dict
            self.id = id
            self.media = media
            self.certificate = certificate
        }
        
        public init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            
            dict = try values.decode(Blocks.self, forKey: .blocks)
            rootItem = try values.decode(String.self, forKey: .rootItem)
            id = try values.decode(String.self, forKey: .id)
            media = try values.decode(DataLayer.CourseMedia.self, forKey: .media)
            certificate = try values.decode(Certificate.self, forKey: .certificate)
        }
    }
}
public extension DataLayer {
    struct CourseBlock: Decodable {
        public let blockId: String
        public let id: String
        public let graded: Bool
        public let completion: Double?
        public let studentUrl: String
        public let type: String
        public let displayName: String
        public let descendants: [String]?
        public let allSources: [String]?
        public let userViewData: CourseDetailUserViewData?
        
        public init(
            blockId: String,
            id: String,
            graded: Bool,
            completion: Double?,
            studentUrl: String,
            type: String,
            displayName: String,
            descendants: [String]?,
            allSources: [String]?,
            userViewData: CourseDetailUserViewData?
        ) {
            self.blockId = blockId
            self.id = id
            self.graded = graded
            self.completion = completion
            self.studentUrl = studentUrl
            self.type = type
            self.displayName = displayName
            self.descendants = descendants
            self.allSources = allSources
            self.userViewData = userViewData
        }
        
        public enum CodingKeys: String, CodingKey {
            case id, type, descendants, graded, completion
            case blockId = "block_id"
            case studentUrl = "student_view_url"
            case displayName = "display_name"
            case userViewData = "student_view_data"
            case allSources = "all_sources"
        }
    }
        
    struct Transcripts: Codable {
        public let en: String?

        enum CodingKeys: String, CodingKey {
            case en
        }

        public init(en: String?) {
            self.en = en
        }
    }
    
    struct CourseDetailUserViewData: Decodable {
        public let transcripts: [String: String]?
        public let encodedVideo: CourseDetailEncodedVideoData?
        public let topicID: String?
        
        public init(
            transcripts: [String: String]?,
            encodedVideo: CourseDetailEncodedVideoData?,
            topicID: String?
        ) {
            self.transcripts = transcripts
            self.encodedVideo = encodedVideo
            self.topicID = topicID
        }
        
        public enum CodingKeys: String, CodingKey {
            case encodedVideo = "encoded_videos"
            case topicID = "topic_id"
            case transcripts
        }
    }
    
    struct CourseDetailEncodedVideoData: Decodable {
        public let youTube: CourseDetailYouTubeData?
        public let fallback: CourseDetailYouTubeData?
        
        public init(
            youTube: CourseDetailYouTubeData?,
            fallback: CourseDetailYouTubeData?
        ) {
            self.youTube = youTube
            self.fallback = fallback
        }
        
        enum CodingKeys: String, CodingKey {
            case youTube = "youtube"
            case fallback
        }
    }
    
    struct CourseDetailYouTubeData: Decodable {
        public let url: String?
        
        public init(url: String?) {
            self.url = url
        }
        
    }
}

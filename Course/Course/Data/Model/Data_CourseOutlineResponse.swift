//
//  CourseOutlineResponse.swift
//  CourseOutline
//
//  Created by  Stepanok Ivan on 28.09.2022.
//

import Foundation
import CoreData
import Core

public struct BECourseDetailBlocks: Decodable {
    let rootItem: String
    typealias Blocks = [String: BECourseDetailIncoming]
    var dict: Blocks
    let id: String
    let media: DataLayer.CourseMedia
    let certificate: Certificate?
    
    enum CodingKeys: String, CodingKey {
        case blocks
        case rootItem = "root"
        case id
        case media
        case certificate
    }
    
    init(rootItem: String, dict: Blocks, id: String, media: DataLayer.CourseMedia, certificate: Certificate?) {
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

public struct BECourseDetailIncoming: Decodable {
    let blockId: String
    let id: String
    let graded: Bool
    let completion: Double?
    let studentUrl: String
    let type: String
    let displayName: String
    let descendants: [String]?
    let allSources: [String]?
    let userViewData: BECourseDetailUserViewData?
    
    public enum CodingKeys: String, CodingKey {
        case id, type, descendants, graded, completion
        case blockId = "block_id"
        case studentUrl = "student_view_url"
        case displayName = "display_name"
        case userViewData = "student_view_data"
        case allSources = "all_sources"
    }
}

public struct BECourseDetailUserViewData: Decodable {
    let encodedVideo: BECourseDetailEncodedVideoData?
    let topicID: String?
    
    public enum CodingKeys: String, CodingKey {
        case encodedVideo = "encoded_videos"
        case topicID = "topic_id"
    }
}

struct BECourseDetailEncodedVideoData: Decodable {
    let youTube: BECourseDetailYouTubeData?
    let fallback: BECourseDetailYouTubeData?
    
    enum CodingKeys: String, CodingKey {
        case youTube = "youtube"
        case fallback
    }
}

struct BECourseDetailYouTubeData: Decodable {
    let url: String?
    
}

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
        public let isSelfPaced: Bool
        public let courseModes: [CourseMode]?
        public let enrollment: EnrollmentDetail?
        public let courseStart: String?
        public let dynamicUpgradeDeadline: String?
        public var courseSKU: String?
        public var courseMode: Mode?
        
        enum CodingKeys: String, CodingKey {
            case blocks
            case rootItem = "root"
            case id
            case media
            case certificate
            case isSelfPaced = "is_self_paced"
            case enrollmentDetails = "enrollment_details"
            case courseStart = "start"
            case dynamicUpgradeDeadline = "dynamic_upgrade_deadline"
            case courseModes = "course_modes"
        }
        
        public init(
            rootItem: String,
            dict: Blocks,
            id: String,
            media: DataLayer.CourseMedia,
            certificate: Certificate?,
            isSelfPaced: Bool,
            courseModes: [CourseMode]? = nil,
            enrollmentDetails: EnrollmentDetail? = nil,
            courseStart: String? = nil,
            dynamicUpgradeDeadline: String? = nil,
            courseSKU: String? = nil,
            courseMode: Mode? = .unknown
        ) {
            self.rootItem = rootItem
            self.dict = dict
            self.id = id
            self.media = media
            self.certificate = certificate
            self.isSelfPaced = isSelfPaced
            self.courseModes = courseModes
            self.enrollment = enrollmentDetails
            self.courseStart = courseStart
            self.dynamicUpgradeDeadline = dynamicUpgradeDeadline
            
            if enrollmentDetails?.mode != nil {
                self.courseMode = enrollmentDetails?.mode
            }
            
            populateCourseSKU()
        }
        
        public init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            
            dict = try values.decode(Blocks.self, forKey: .blocks)
            rootItem = try values.decode(String.self, forKey: .rootItem)
            id = try values.decode(String.self, forKey: .id)
            media = try values.decode(DataLayer.CourseMedia.self, forKey: .media)
            certificate = try values.decode(Certificate.self, forKey: .certificate)
            isSelfPaced = try values.decode(Bool.self, forKey: .isSelfPaced)
            courseModes = try values.decode([CourseMode].self, forKey: .courseModes)
            enrollment = try values.decode(EnrollmentDetail.self, forKey: .enrollmentDetails)
            courseStart = try values.decode(String.self, forKey: .courseStart)
            dynamicUpgradeDeadline = try? values.decode(String.self, forKey: .dynamicUpgradeDeadline)
            
            populateCourseSKU()
        }
        
        mutating func populateCourseSKU() {
            for mode in courseModes ?? [] where mode.slug == .verified {
                courseSKU = mode.iosSku ?? ""
            }
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
        public let webUrl: String
        public let type: String
        public let displayName: String
        public let descendants: [String]?
        public let allSources: [String]?
        public let userViewData: CourseDetailUserViewData?
        public let multiDevice: Bool?
        
        public init(
            blockId: String,
            id: String,
            graded: Bool,
            completion: Double?,
            studentUrl: String,
            webUrl: String,
            type: String,
            displayName: String,
            descendants: [String]?,
            allSources: [String]?,
            userViewData: CourseDetailUserViewData?,
            multiDevice: Bool?
        ) {
            self.blockId = blockId
            self.id = id
            self.graded = graded
            self.completion = completion
            self.studentUrl = studentUrl
            self.webUrl = webUrl
            self.type = type
            self.displayName = displayName
            self.descendants = descendants
            self.allSources = allSources
            self.userViewData = userViewData
            self.multiDevice = multiDevice
        }
        
        public enum CodingKeys: String, CodingKey {
            case id, type, descendants, graded, completion
            case blockId = "block_id"
            case studentUrl = "student_view_url"
            case webUrl = "lms_web_url"
            case displayName = "display_name"
            case userViewData = "student_view_data"
            case allSources = "all_sources"
            case multiDevice = "student_view_multi_device"
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
    
    struct EnrollmentDetail: Codable {
        let created: String
        let isActive: Bool
        let mode: Mode
        
        public enum CodingKeys: String, CodingKey {
            case created
            case isActive = "is_active"
            case mode
        }
        
        init(created: String, isActive: Bool, mode: Mode) {
            self.created = created
            self.isActive = isActive
            self.mode = mode
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
        public let youTube: EncodedVideoData?
        public let fallback: EncodedVideoData?
        public let desktopMP4: EncodedVideoData?
        public let mobileHigh: EncodedVideoData?
        public let mobileLow: EncodedVideoData?
        public let hls: EncodedVideoData?

        public init(
            youTube: EncodedVideoData?,
            fallback: EncodedVideoData?,
            desktopMP4: EncodedVideoData? = nil,
            mobileHigh: EncodedVideoData? = nil,
            mobileLow: EncodedVideoData? = nil,
            hls: EncodedVideoData? = nil
        ) {
            self.youTube = youTube
            self.fallback = fallback
            self.desktopMP4 = desktopMP4
            self.mobileHigh = mobileHigh
            self.mobileLow = mobileLow
            self.hls = hls
        }
        
        enum CodingKeys: String, CodingKey {
            case youTube = "youtube"
            case fallback
            case desktopMP4 = "desktop_mp4"
            case mobileHigh = "mobile_high"
            case mobileLow = "mobile_low"
            case hls
        }
    }
    
    struct EncodedVideoData: Decodable {
        public let url: String?
        public let fileSize: Int?
        public let streamPriority: Int?

        public init(url: String?, fileSize: Int?, streamPriority: Int? = nil) {
            self.url = url
            self.fileSize = fileSize
            self.streamPriority = streamPriority
        }

        enum CodingKeys: String, CodingKey {
            case url
            case fileSize = "file_size"
            case streamPriority = "stream_priority"
        }

    }
}

extension DataLayer.CourseStructure {
    var isUpgradeable: Bool {
        guard let start = courseStart,
//                let upgradeDeadline = dynamicUpgradeDeadline,
              enrollment?.mode == .audit
        else { return false }
        
        let startDate = Date(iso8601: start)
//        let dynamicUpgradeDeadline = Date(iso8601: upgradeDeadline)
        
        return startDate.isInPast()
        && courseSKU?.isEmpty == false
       // && !dynamicUpgradeDeadline.isInPast()
        
        // TODO: uncomment !dynamicUpgradeDeadline.isInPast() and related code
        // when it will be available in API response
    }
}

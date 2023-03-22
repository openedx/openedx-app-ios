//
//  Data_Discovery.swift
//  Core
//
//  Created by  Stepanok Ivan on 16.09.2022.
//

import Foundation

// MARK: "/api/courses/v1/courses/"

// MARK: - Pagination
public extension DataLayer {
    struct Pagination: Codable {
        public let next: String?
        public let previous: String?
        public let count: Int
        public let numPages: Int
        
        public enum CodingKeys: String, CodingKey {
            case next = "next"
            case previous = "previous"
            case count = "count"
            case numPages = "num_pages"
        }
        
        public init(next: String?, previous: String?, count: Int, numPages: Int) {
            self.next = next
            self.previous = previous
            self.count = count
            self.numPages = numPages
        }
    }
}

public extension DataLayer {
    struct DiscoveryResponce: Codable {
        public let results: [DataLayer.Course]
        public let pagination: Pagination
    }
}

public extension DataLayer {
    // MARK: - Result
    struct Course: Codable {
        public let blocksURL: String
        public let effort: String?
        public let end: String?
        public let enrollmentStart: String?
        public let enrollmentEnd: String?
        public let id: String
        public let media: DataLayer.Media
        public let name: String
        public let number: String
        public let org: String
        public let shortDescription: String?
        public let start: String?
        public let startDisplay: String?
        public let startType: String?
        public let pacing: Pacing
        public let mobileAvailable: Bool
        public let hidden: Bool
        public let invitationOnly: Bool
        public let courseID: String
        
        enum CodingKeys: String, CodingKey {
            case blocksURL = "blocks_url"
            case effort = "effort"
            case end = "end"
            case enrollmentStart = "enrollment_start"
            case enrollmentEnd = "enrollment_end"
            case id = "id"
            case media = "media"
            case name = "name"
            case number = "number"
            case org = "org"
            case shortDescription = "short_description"
            case start = "start"
            case startDisplay = "start_display"
            case startType = "start_type"
            case pacing = "pacing"
            case mobileAvailable = "mobile_available"
            case hidden = "hidden"
            case invitationOnly = "invitation_only"
            case courseID = "course_id"
        }
    }
    
    enum Pacing: String, Codable {
        case instructor = "instructor"
        case pacingSelf = "self"
    }
    
    enum StartType: String, Codable {
        case empty
        case timestamp
    }
}

public extension DataLayer.DiscoveryResponce {
    var domain: [CourseItem] {
        let listReady = results.map({
            CourseItem(name: $0.name, org: $0.org,
                       shortDescription: $0.shortDescription ?? "",
                       imageURL: $0.media.image.small,
                       isActive: nil,
                       courseStart: Date(iso8601: $0.start ?? ""),
                       courseEnd: Date(iso8601: $0.end ?? ""),
                       enrollmentStart: Date(iso8601: $0.enrollmentStart ?? ""),
                       enrollmentEnd: Date(iso8601: $0.enrollmentEnd ?? ""),
                       courseID: $0.courseID,
                       certificate: nil,
                       numPages: pagination.numPages,
                       coursesCount: pagination.count)
        })
        return listReady
    }
}

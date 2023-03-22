//
//  Data_Dashboard.swift
//  Core
//
//  Created by  Stepanok Ivan on 19.09.2022.
//

import Foundation

// MARK: "/api/mobile/v1/users/\(username)/course_enrollments/"

public extension DataLayer {
    
    struct MyCourse: Codable {
        public let auditAccessExpires: String?
        public let created: String
        public let mode: String
        public let isActive: Bool
        public let course: DashboardCourse
        public let certificate: Certificate?
        
        enum CodingKeys: String, CodingKey {
            case auditAccessExpires = "audit_access_expires"
            case created
            case mode
            case isActive = "is_active"
            case course
            case certificate = "certificate"
        }
    }
    
    // MARK: - Certificate
    struct Certificate: Codable {
        public let url: String?
    }
    
    // MARK: - Course
    struct DashboardCourse: Codable {
        public let id: String
        public let name: String
        public let number: String
        public let org: String
        public let start: String?
        public let startDisplay: String?
        public let startType: String?
        public let end: String?
        public let dynamicUpgradeDeadline: String?
        public let subscriptionID: String
        public let coursewareAccess: CoursewareAccess
        public let media: DashboardMedia
        public let courseImage: String
        public let courseAbout: String
        public let courseSharingUtmParameters: CourseSharingUtmParameters
        public let courseUpdates: String
        public let courseHandouts: String
        public let discussionURL: String
        public let videoOutline: String?
        public let isSelfPaced: Bool
        
        enum CodingKeys: String, CodingKey {
            case id
            case name
            case number
            case org
            case start
            case startDisplay = "start_display"
            case startType = "start_type"
            case end
            case dynamicUpgradeDeadline = "dynamic_upgrade_deadline"
            case subscriptionID = "subscription_id"
            case coursewareAccess = "courseware_access"
            case media
            case courseImage = "course_image"
            case courseAbout = "course_about"
            case courseSharingUtmParameters = "course_sharing_utm_parameters"
            case courseUpdates = "course_updates"
            case courseHandouts = "course_handouts"
            case discussionURL = "discussion_url"
            case videoOutline = "video_outline"
            case isSelfPaced = "is_self_paced"
        }
    }
    
    // MARK: - CourseSharingUtmParameters
    struct CourseSharingUtmParameters: Codable {
        public let facebook: String
        public let twitter: String
    }
    
    // MARK: - CoursewareAccess
    struct CoursewareAccess: Codable {
        public let hasAccess: Bool
        public let errorCode: String?
        public let developerMessage: String?
        public let userMessage: String?
        public let additionalContextUserMessage: String?
        public let userFragment: String?
        
        enum CodingKeys: String, CodingKey {
            case hasAccess = "has_access"
            case errorCode = "error_code"
            case developerMessage = "developer_message"
            case userMessage = "user_message"
            case additionalContextUserMessage = "additional_context_user_message"
            case userFragment = "user_fragment"
        }
    }
    
    // MARK: - Media
    struct DashboardMedia: Codable {
        public let courseImage: CourseImage
        
        enum CodingKeys: String, CodingKey {
            case courseImage = "course_image"
        }
    }
    
    // MARK: - CourseImage
    struct CourseImage: Codable {
        public let url: String
        public let name: String
        
        enum CodingKeys: String, CodingKey {
            case url = "uri"
            case name = "name"
        }
    }
}

public extension DataLayer.Certificate {
    var domain: Certificate {
        return Certificate(url: url ?? "")
    }
}

public extension DataLayer.MyCourse {
    func domain(baseURL: String) -> CourseItem {
        let imageURL = baseURL + (course.media.courseImage.url.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed) ?? "")
        return CourseItem(
            name: course.name,
            org: course.org,
            shortDescription: course.courseAbout,
            imageURL: imageURL,
            isActive: isActive,
            courseStart: course.start != nil ? Date(iso8601: course.start!) : nil,
            courseEnd: course.end != nil ? Date(iso8601: course.end!) : nil,
            enrollmentStart: nil,
            enrollmentEnd: nil,
            courseID: course.id,
            certificate: certificate?.domain,
            numPages: 1,
            coursesCount: 0
        )
    }
}

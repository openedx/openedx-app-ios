//
//  Data_Dashboard.swift
//  Core
//
//  Created by  Stepanok Ivan on 24.03.2023.
//

import Foundation

public extension DataLayer {
    // MARK: - CourseEnrollments
    struct CourseEnrollments: Codable {
        public let enrollments: Enrollments

        enum CodingKeys: String, CodingKey {
            case enrollments
        }

        public init(enrollments: Enrollments) {
            self.enrollments = enrollments
        }
    }

    // MARK: - Enrollments
    struct Enrollments: Codable {
        public let next: String?
        public let previous: String?
        public let count: Int?
        public let numPages: Int?
        public let currentPage: Int?
        public let start: Int?
        public let results: [Result]

        enum CodingKeys: String, CodingKey {
            case next
            case previous
            case count
            case numPages = "num_pages"
            case currentPage = "current_page"
            case start
            case results
        }

        public init(
            next: String?,
            previous: String?,
            count: Int?,
            numPages: Int?,
            currentPage: Int?,
            start: Int?,
            results: [Result]
        ) {
            self.next = next
            self.previous = previous
            self.count = count
            self.numPages = numPages
            self.currentPage = currentPage
            self.start = start
            self.results = results
        }
    }

    // MARK: - Result
    struct Result: Codable {
        public let auditAccessExpires: String?
        public let created: String
        public let mode: Mode
        public let isActive: Bool
        public let course: DashboardCourse
        public let courseModes: [CourseMode]

        enum CodingKeys: String, CodingKey {
            case auditAccessExpires = "audit_access_expires"
            case created
            case mode
            case isActive = "is_active"
            case course
            case courseModes = "course_modes"
        }

        public init(
            auditAccessExpires: String?,
            created: String,
            mode: Mode,
            isActive: Bool,
            course: DashboardCourse,
            courseModes: [CourseMode]
        ) {
            self.auditAccessExpires = auditAccessExpires
            self.created = created
            self.mode = mode
            self.isActive = isActive
            self.course = course
            self.courseModes = courseModes
        }
    }

    // MARK: - Course
    struct DashboardCourse: Codable {
        public let id: String
        public let name: String
        public let number: String
        public let org: String
        public let start: String?
        public let startDisplay: String
        public let startType: StartType
        public let end: String?
        public let dynamicUpgradeDeadline: String?
        public let subscriptionID: String
        public let coursewareAccess: CoursewareAccess
        public let media: Media
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

        public init(
            id: String,
            name: String,
            number: String,
            org: String,
            start: String?,
            startDisplay: String,
            startType: StartType,
            end: String?,
            dynamicUpgradeDeadline: String?,
            subscriptionID: String,
            coursewareAccess: CoursewareAccess,
            media: Media,
            courseImage: String,
            courseAbout: String,
            courseSharingUtmParameters: CourseSharingUtmParameters,
            courseUpdates: String,
            courseHandouts: String,
            discussionURL: String,
            videoOutline: String?,
            isSelfPaced: Bool
        ) {
            self.id = id
            self.name = name
            self.number = number
            self.org = org
            self.start = start
            self.startDisplay = startDisplay
            self.startType = startType
            self.end = end
            self.dynamicUpgradeDeadline = dynamicUpgradeDeadline
            self.subscriptionID = subscriptionID
            self.coursewareAccess = coursewareAccess
            self.media = media
            self.courseImage = courseImage
            self.courseAbout = courseAbout
            self.courseSharingUtmParameters = courseSharingUtmParameters
            self.courseUpdates = courseUpdates
            self.courseHandouts = courseHandouts
            self.discussionURL = discussionURL
            self.videoOutline = videoOutline
            self.isSelfPaced = isSelfPaced
        }
    }

    enum Name: String, Codable {
        case courseImage = "Course Image"
    }

    enum Org: String, Codable {
        case organization = "Organization"
        case univerity = "Univerity"
        case university = "University"
    }

    // MARK: - CourseMode
    struct CourseMode: Codable {
        public let slug: Mode?
        public let sku: Mode?
        public let androidSku: Mode?
        public let iosSku: Mode?

        enum CodingKeys: String, CodingKey {
            case slug
            case sku
            case androidSku = "android_sku"
            case iosSku = "ios_sku"
        }

        public init(slug: Mode?, sku: Mode?, androidSku: Mode?, iosSku: Mode?) {
            self.slug = slug
            self.sku = sku
            self.androidSku = androidSku
            self.iosSku = iosSku
        }
    }

    enum Mode: String, Codable {
        case audit
        case honor
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
}

public extension DataLayer.CourseEnrollments {
    func domain(baseURL: String) -> [CourseItem] {
        return enrollments.results.map { result in
            let course = result.course
            
            let imageUrl = course.media.courseImage?.url ?? ""
            let encodedUrl = imageUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let fullImageURL = baseURL + encodedUrl
            
            return CourseItem(
                name: course.name,
                org: course.org,
                shortDescription: "",
                imageURL: fullImageURL,
                isActive: true,
                courseStart: course.start != nil ? Date(iso8601: course.start!) : nil,
                courseEnd: course.end != nil ? Date(iso8601: course.end!) : nil,
                enrollmentStart: course.start != nil
                ? Date(iso8601: course.start!)
                : nil,
                enrollmentEnd: course.end != nil
                ? Date(iso8601: course.end!)
                : nil,
                courseID: course.id,
                numPages: enrollments.numPages ?? 1,
                coursesCount: enrollments.count ?? 0
            )
        }
    }
}

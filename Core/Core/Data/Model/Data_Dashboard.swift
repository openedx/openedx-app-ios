//
//  Data_Dashboard.swift
//  Core
//
//  Created by  Stepanok Ivan on 24.03.2023.
//

import Foundation

public extension DataLayer {
    struct CourseEnrollments: Codable {
        public let next: String?
        public let previous: String?
        public let count: Int
        public let numPages: Int
        public let currentPage: Int
        public let start: Int
        public let results: [Result]
        
        enum CodingKeys: String, CodingKey {
            case next = "next"
            case previous = "previous"
            case count = "count"
            case numPages = "num_pages"
            case currentPage = "current_page"
            case start = "start"
            case results = "results"
        }
        
        public init(next: String?,
                    previous: String?,
                    count: Int,
                    numPages: Int,
                    currentPage: Int,
                    start: Int,
                    results: [Result]) {
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
        public let isActive: Bool
        public let course: Course
        public let certificate: Certificate
        
        enum CodingKeys: String, CodingKey {
            case auditAccessExpires = "audit_access_expires"
            case created = "created"
            case isActive = "is_active"
            case course = "course"
            case certificate = "certificate"
        }
        
        public init(auditAccessExpires: String?, created: String,// mode: Mode,
                    isActive: Bool, course: Course, certificate: Certificate) {
            self.auditAccessExpires = auditAccessExpires
            self.created = created
            self.isActive = isActive
            self.course = course
            self.certificate = certificate
        }
    }
}

public extension DataLayer.CourseEnrollments {
    func domain(baseURL: String) -> [CourseItem] {
        
        return results.map { course in
            let imageURL = baseURL + (course.course.media.courseImage?.url?.addingPercentEncoding(
                withAllowedCharacters: .urlQueryAllowed) ?? "")
            return CourseItem(
                name: course.course.name,
                org: course.course.org,
                shortDescription: "",
                imageURL: imageURL,
                isActive: true,
                courseStart: course.course.start != nil ? Date(iso8601: course.course.start!) : nil,
                courseEnd: course.course.end != nil ? Date(iso8601: course.course.end!) : nil,
                enrollmentStart: course.course.enrollmentStart != nil
                ? Date(iso8601: course.course.enrollmentStart!)
                : nil,
                enrollmentEnd: course.course.enrollmentEnd != nil
                ? Date(iso8601: course.course.enrollmentEnd!)
                : nil,
                courseID: course.course.id,
                numPages: numPages,
                coursesCount: count
            )
        }
    }
}

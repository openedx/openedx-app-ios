//
//  Data_MyLearnCourses.swift
//  Core
//
//  Created by  Stepanok Ivan on 16.04.2024.
//

import Foundation

public extension DataLayer {
    struct MyLearnCourses: Codable {
        public let userTimezone: String
        public let enrollments: Enrollments
        public let primary: Primary?
        
        enum CodingKeys: String, CodingKey {
            case userTimezone = "user_timezone"
            case enrollments = "enrollments"
            case primary = "primary"
        }
        
        public init(userTimezone: String, enrollments: Enrollments, primary: Primary?) {
            self.userTimezone = userTimezone
            self.enrollments = enrollments
            self.primary = primary
        }
    }
    
    // MARK: - CourseImage
    struct CourseImage: Codable {
        public let uri: String
        public let name: String
        
        enum CodingKeys: String, CodingKey {
            case uri = "uri"
            case name = "name"
        }
        
        public init(uri: String, name: String) {
            self.uri = uri
            self.name = name
        }
    }
    
    // MARK: - Primary
    struct Primary: Codable {
        public let auditAccessExpires: Date?
        public let created: String?
        public let mode: String?
        public let isActive: Bool?
        public let course: DashboardCourse?
        public let certificate: DataLayer.Certificate?
        public let courseModes: [CourseMode]?
        public let courseStatus: CourseStatus?
        public let progress: Progress?
        public let courseAssignments: CourseAssignments?
        
        enum CodingKeys: String, CodingKey {
            case auditAccessExpires = "audit_access_expires"
            case created = "created"
            case mode = "mode"
            case isActive = "is_active"
            case course = "course"
            case certificate = "certificate"
            case courseModes = "course_modes"
            case courseStatus = "course_status"
            case progress = "course_progress"
            case courseAssignments = "course_assignments"
        }
        
        public init(
            auditAccessExpires: Date?,
            created: String?,
            mode: String?,
            isActive: Bool?,
            course: DashboardCourse?,
            certificate: DataLayer.Certificate?,
            courseModes: [CourseMode]?,
            courseStatus: CourseStatus?,
            progress: Progress?,
            courseAssignments: CourseAssignments?
        ) {
            self.auditAccessExpires = auditAccessExpires
            self.created = created
            self.mode = mode
            self.isActive = isActive
            self.course = course
            self.certificate = certificate
            self.courseModes = courseModes
            self.courseStatus = courseStatus
            self.progress = progress
            self.courseAssignments = courseAssignments
        }
    }
    
    // MARK: - CourseStatus
    struct CourseStatus: Codable {
        public let lastVisitedModuleID: String
        public let lastVisitedModulePath: [String]
        public let lastVisitedBlockID: String
        public let lastVisitedUnitDisplayName: String

        enum CodingKeys: String, CodingKey {
            case lastVisitedModuleID = "last_visited_module_id"
            case lastVisitedModulePath = "last_visited_module_path"
            case lastVisitedBlockID = "last_visited_block_id"
            case lastVisitedUnitDisplayName = "last_visited_unit_display_name"
        }
    }
    
    // MARK: - CourseAssignments
    struct CourseAssignments: Codable {
        public let futureAssignments: [Assignment]?
        public let pastAssignments: [Assignment]?
        
        enum CodingKeys: String, CodingKey {
            case futureAssignments = "future_assignments"
            case pastAssignments = "past_assignments"
        }
        
        public init(futureAssignments: [Assignment]?, pastAssignments: [Assignment]?) {
            self.futureAssignments = futureAssignments
            self.pastAssignments = pastAssignments
        }
    }
    
    // MARK: - Assignment
    struct Assignment: Codable {
        public let assignmentType: String?
        public let complete: Bool?
        public let date: String?
        public let dateType: String?
        public let description: String?
        public let learnerHasAccess: Bool?
        public let link: String?
        public let linkText: String?
        public let title: String?
        public let extraInfo: String?
        public let firstComponentBlockID: String?
        
        enum CodingKeys: String, CodingKey {
            case assignmentType = "assignment_type"
            case complete = "complete"
            case date = "date"
            case dateType = "date_type"
            case description = "description"
            case learnerHasAccess = "learner_has_access"
            case link = "link"
            case linkText = "link_text"
            case title = "title"
            case extraInfo = "extra_info"
            case firstComponentBlockID = "first_component_block_id"
        }
        
        public init(
            assignmentType: String?,
            complete: Bool?,
            date: String?,
            dateType: String?,
            description: String?,
            learnerHasAccess: Bool?,
            link: String?,
            linkText: String?,
            title: String?,
            extraInfo: String?,
            firstComponentBlockID: String?
        ) {
            self.assignmentType = assignmentType
            self.complete = complete
            self.date = date
            self.dateType = dateType
            self.description = description
            self.learnerHasAccess = learnerHasAccess
            self.link = link
            self.linkText = linkText
            self.title = title
            self.extraInfo = extraInfo
            self.firstComponentBlockID = firstComponentBlockID
        }
    }
    
    // MARK: - Progress
    struct Progress: Codable {
        public let assignmentsCompleted: Double
        public let totalAssignmentsCount: Double
        
        enum CodingKeys: String, CodingKey {
            case assignmentsCompleted = "assignments_completed"
            case  totalAssignmentsCount = "total_assignments_count"
        }
        
        public init(assignmentsCompleted: Double, totalAssignmentsCount: Double) {
            self.assignmentsCompleted = assignmentsCompleted
            self.totalAssignmentsCount = totalAssignmentsCount
        }
    }
}

public extension DataLayer.MyLearnCourses {
    func domain(baseURL: String) -> MyEnrollments {
        var primaryCourse: PrimaryCourse?
        if let primary = self.primary {
            let futureAssignments: [DataLayer.Assignment] = primary.courseAssignments?.futureAssignments ?? []
            let pastAssignments: [DataLayer.Assignment] = primary.courseAssignments?.pastAssignments ?? []
            
            primaryCourse = PrimaryCourse(
                name: primary.course?.name ?? "",
                org: primary.course?.org ?? "",
                courseID: primary.course?.id ?? "",
                isActive: primary.course?.coursewareAccess.hasAccess ?? true,
                courseStart: primary.course?.start != nil
                ? Date(iso8601: primary.course?.start ?? "")
                : nil,
                courseEnd: primary.course?.end != nil
                ? Date(iso8601: primary.course?.end ?? "")
                : nil,
                courseBanner: baseURL + (primary.course?.media.courseImage?.url ?? ""),
                futureAssignments: futureAssignments.map {
                    Assignment(
                        type: $0.assignmentType ?? "",
                        title: $0.title ?? "",
                        description: $0.description,
                        date: Date(iso8601: $0.date  ?? ""),
                        complete: $0.complete ?? false,
                        firstComponentBlockId: $0.firstComponentBlockID
                    )
                },
                pastAssignments: pastAssignments.map {
                    Assignment(
                        type: $0.assignmentType ?? "",
                        title: $0.title ?? "",
                        description: $0.description ?? "",
                        date: Date(iso8601: $0.date ?? ""),
                        complete: $0.complete ?? false,
                        firstComponentBlockId: $0.firstComponentBlockID
                    )
                },
                progressEarned: primary.progress?.assignmentsCompleted ?? 0,
                progressPossible: primary.progress?.totalAssignmentsCount ?? 0,
                lastVisitedBlockID: primary.courseStatus?.lastVisitedBlockID, 
                resumeTitle: primary.courseStatus?.lastVisitedUnitDisplayName
            )
        }
        let courses = self.enrollments.results.map {
            let imageUrl = $0.course.media.courseImage?.url ?? ""
            let encodedUrl = imageUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let fullImageURL = baseURL + encodedUrl
            return CourseItem(
                name: $0.course.name,
                org: $0.course.org,
                shortDescription: "",
                imageURL: fullImageURL,
                isActive: $0.course.coursewareAccess.hasAccess,
                courseStart: $0.course.start != nil
                ? Date(iso8601: $0.course.start!)
                : nil,
                courseEnd: $0.course.end != nil
                ? Date(iso8601: $0.course.end!)
                : nil,
                enrollmentStart: $0.course.start != nil
                ? Date(iso8601: $0.course.start!)
                : nil,
                enrollmentEnd: $0.course.end != nil
                ? Date(iso8601: $0.course.end!)
                : nil,
                courseID: $0.course.id,
                numPages: enrollments.numPages ?? 1,
                coursesCount: enrollments.count ?? 0,
                progressEarned: $0.progress?.assignmentsCompleted ?? 0,
                progressPossible: $0.progress?.totalAssignmentsCount ?? 0
            )
        }
        
        return MyEnrollments(
            primaryCourse: primaryCourse,
            courses: courses,
            totalPages: enrollments.numPages ?? 1,
            count: enrollments.count ?? 1
        )
    }
}

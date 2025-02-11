//
//  Data_PrimaryEnrollment.swift
//  Core
//
//  Created by  Stepanok Ivan on 16.04.2024.
//

import Foundation

public extension DataLayer {
    struct PrimaryEnrollment: Codable {
        public let userTimezone: String?
        public let enrollments: Enrollments?
        public let primary: ActiveEnrollment?
        
        enum CodingKeys: String, CodingKey {
            case userTimezone = "user_timezone"
            case enrollments
            case primary
        }
        
        public init(userTimezone: String?, enrollments: Enrollments?, primary: ActiveEnrollment?) {
            self.userTimezone = userTimezone
            self.enrollments = enrollments
            self.primary = primary
        }
    }
    
    // MARK: - Primary
    struct ActiveEnrollment: Codable {
        public let auditAccessExpires: String?
        public let created: String?
        public let mode: String?
        public let isActive: Bool?
        public let course: DashboardCourse?
        public let certificate: DataLayer.Certificate?
        public let courseModes: [CourseMode]?
        public let courseStatus: CourseStatus?
        public let progress: DataLayer.CourseProgress?
        public let courseAssignments: CourseAssignments?
        
        enum CodingKeys: String, CodingKey {
            case auditAccessExpires = "audit_access_expires"
            case created
            case mode
            case isActive = "is_active"
            case course
            case certificate
            case courseModes = "course_modes"
            case courseStatus = "course_status"
            case progress = "course_progress"
            case courseAssignments = "course_assignments"
        }
        
        public init(
            auditAccessExpires: String?,
            created: String?,
            mode: String?,
            isActive: Bool?,
            course: DashboardCourse?,
            certificate: DataLayer.Certificate?,
            courseModes: [CourseMode]?,
            courseStatus: CourseStatus?,
            progress: CourseProgress?,
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
        public let lastVisitedModuleID: String?
        public let lastVisitedModulePath: [String]?
        public let lastVisitedBlockID: String?
        public let lastVisitedUnitDisplayName: String?

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
            case complete
            case date
            case dateType = "date_type"
            case description
            case learnerHasAccess = "learner_has_access"
            case link
            case linkText = "link_text"
            case title
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
    
    // MARK: - CourseProgress
    struct CourseProgress: Codable, Sendable {
        public let assignmentsCompleted: Int?
        public let totalAssignmentsCount: Int?
        
        enum CodingKeys: String, CodingKey {
            case assignmentsCompleted = "assignments_completed"
            case  totalAssignmentsCount = "total_assignments_count"
        }
        
        public init(assignmentsCompleted: Int?, totalAssignmentsCount: Int?) {
            self.assignmentsCompleted = assignmentsCompleted
            self.totalAssignmentsCount = totalAssignmentsCount
        }
    }
}

public extension DataLayer.PrimaryEnrollment {
    
    func domain(baseURL: String) -> PrimaryEnrollment {
        let primaryCourse = createPrimaryCourse(from: self.primary, baseURL: baseURL)
        let courses = createCourseItems(from: self.enrollments, baseURL: baseURL)
        
        return PrimaryEnrollment(
            primaryCourse: primaryCourse,
            courses: courses,
            totalPages: enrollments?.numPages ?? 1,
            count: enrollments?.count ?? 1
        )
    }
    
    private func createPrimaryCourse(from primary: DataLayer.ActiveEnrollment?, baseURL: String) -> PrimaryCourse? {
        guard let primary = primary else { return nil }
        
        let futureAssignments = primary.courseAssignments?.futureAssignments ?? []
        let pastAssignments = primary.courseAssignments?.pastAssignments ?? []
        
        return PrimaryCourse(
            name: primary.course?.name ?? "",
            org: primary.course?.org ?? "",
            courseID: primary.course?.id ?? "",
            hasAccess: primary.course?.coursewareAccess.hasAccess ?? true,
            courseStart: primary.course?.start.flatMap { Date(iso8601: $0) },
            courseEnd: primary.course?.end.flatMap { Date(iso8601: $0) },
            courseBanner: baseURL + (primary.course?.media.courseImage?.url ?? ""),
            futureAssignments: futureAssignments.map { createAssignment(from: $0) },
            pastAssignments: pastAssignments.map { createAssignment(from: $0) },
            progressEarned: primary.progress?.assignmentsCompleted ?? 0,
            progressPossible: primary.progress?.totalAssignmentsCount ?? 0,
            lastVisitedBlockID: primary.courseStatus?.lastVisitedBlockID,
            resumeTitle: primary.courseStatus?.lastVisitedUnitDisplayName
        )
    }
    
    private func createAssignment(from assignment: DataLayer.Assignment) -> Assignment {
        return Assignment(
            type: assignment.assignmentType ?? "",
            title: assignment.title ?? "",
            description: assignment.description ?? "",
            date: Date(iso8601: assignment.date ?? ""),
            complete: assignment.complete ?? false,
            firstComponentBlockId: assignment.firstComponentBlockID
        )
    }
    
    private func createCourseItems(from enrollments: DataLayer.Enrollments?, baseURL: String) -> [CourseItem] {
        return enrollments?.results.map {
            createCourseItem(
                from: $0,
                baseURL: baseURL,
                numPages: enrollments?.numPages ?? 1,
                count: enrollments?.count ?? 0
            )
        } ?? []
    }

    private func createCourseItem(
        from enrollment: DataLayer.Enrollment,
        baseURL: String,
        numPages: Int,
        count: Int
    ) -> CourseItem {
        let imageUrl = enrollment.course.media.courseImage?.url ?? ""
        let encodedUrl = imageUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let fullImageURL = baseURL + encodedUrl
        
        return CourseItem(
            name: enrollment.course.name,
            org: enrollment.course.org,
            shortDescription: "",
            imageURL: fullImageURL,
            hasAccess: enrollment.course.coursewareAccess.hasAccess,
            courseStart: enrollment.course.start.flatMap { Date(iso8601: $0) },
            courseEnd: enrollment.course.end.flatMap { Date(iso8601: $0) },
            enrollmentStart: enrollment.course.start.flatMap { Date(iso8601: $0) },
            enrollmentEnd: enrollment.course.end.flatMap { Date(iso8601: $0) },
            courseID: enrollment.course.id,
            numPages: numPages,
            coursesCount: count,
            courseRawImage: enrollment.course.media.image?.raw,
            progressEarned: enrollment.progress?.assignmentsCompleted ?? 0,
            progressPossible: enrollment.progress?.totalAssignmentsCount ?? 0
        )
    }
}

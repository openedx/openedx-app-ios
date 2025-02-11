//
//  DashboardRepository.swift
//  Dashboard
//
//  Created by  Stepanok Ivan on 19.09.2022.
//

import Foundation
import Core
import OEXFoundation

public protocol DashboardRepositoryProtocol: Sendable {
    func getEnrollments(page: Int) async throws -> [CourseItem]
    func getEnrollmentsOffline() async throws -> [CourseItem]
    func getPrimaryEnrollment(pageSize: Int) async throws -> PrimaryEnrollment
    func getPrimaryEnrollmentOffline() async throws -> PrimaryEnrollment
    func getAllCourses(filteredBy: String, page: Int) async throws -> PrimaryEnrollment
}

public actor DashboardRepository: DashboardRepositoryProtocol {
    
    private let api: API
    private let storage: CoreStorage
    private let config: ConfigProtocol
    private let persistence: DashboardPersistenceProtocol
    
    public init(api: API, storage: CoreStorage, config: ConfigProtocol, persistence: DashboardPersistenceProtocol) {
        self.api = api
        self.storage = storage
        self.config = config
        self.persistence = persistence
    }
    
    public func getEnrollments(page: Int) async throws -> [CourseItem] {
        let result = try await api.requestData(
            DashboardEndpoint.getEnrollments(username: storage.user?.username ?? "", page: page)
        )
            .mapResponse(DataLayer.CourseEnrollments.self)
            .domain(baseURL: config.baseURL.absoluteString)
        await persistence.saveEnrollments(items: result)
        return result
        
    }
    
    public func getEnrollmentsOffline() async throws -> [CourseItem] {
        return try await persistence.loadEnrollments()
    }
    
    public func getPrimaryEnrollment(pageSize: Int) async throws -> PrimaryEnrollment {
        let result = try await api.requestData(
            DashboardEndpoint.getPrimaryEnrollment(
                username: storage.user?.username ?? "",
                pageSize: pageSize
            )
        )
            .mapResponse(DataLayer.PrimaryEnrollment.self)
            .domain(baseURL: config.baseURL.absoluteString)
        await persistence.savePrimaryEnrollment(enrollments: result)
        return result
    }
    
    public func getPrimaryEnrollmentOffline() async throws -> PrimaryEnrollment {
        return try await persistence.loadPrimaryEnrollment()
    }
    
    public func getAllCourses(filteredBy: String, page: Int) async throws -> PrimaryEnrollment {
        let result = try await api.requestData(
            DashboardEndpoint.getAllCourses(
                username: storage.user?.username ?? "",
                filteredBy: filteredBy,
                page: page
            )
        )
            .mapResponse(DataLayer.PrimaryEnrollment.self)
            .domain(baseURL: config.baseURL.absoluteString)
        return result
    }
}

// swiftlint:disable all
// Mark - For testing and SwiftUI preview
#if DEBUG
final class DashboardRepositoryMock: DashboardRepositoryProtocol {
    
    func getEnrollments(page: Int) async throws -> [CourseItem] {
        var models: [CourseItem] = []
        for i in 0...10 {
            models.append(
                CourseItem(
                    name: "Course name \(i)",
                    org: "Organization",
                    shortDescription: "shortDescription",
                    imageURL: "",
                    hasAccess: true,
                    courseStart: nil,
                    courseEnd: nil,
                    enrollmentStart: nil,
                    enrollmentEnd: nil,
                    courseID: "course_id_\(i)",
                    numPages: 1,
                    coursesCount: 0,
                    courseRawImage: nil,
                    progressEarned: 0,
                    progressPossible: 0
                )
            )
        }
        return models
    }
    
    func getEnrollmentsOffline() throws -> [CourseItem] { return [] }
    
    public func getPrimaryEnrollment(pageSize: Int) async throws -> PrimaryEnrollment {
        
        var courses: [CourseItem] = []
        for i in 0...10 {
            courses.append(
                CourseItem(
                    name: "Course name \(i)",
                    org: "Organization",
                    shortDescription: "shortDescription",
                    imageURL: "",
                    hasAccess: true,
                    courseStart: nil,
                    courseEnd: nil,
                    enrollmentStart: nil,
                    enrollmentEnd: nil,
                    courseID: "course_id_\(i)",
                    numPages: 1,
                    coursesCount: 0,
                    courseRawImage: nil,
                    progressEarned: 4,
                    progressPossible: 10
                )
            )
        }
        
        let futureAssignment = Assignment(
            type: "Final Exam",
            title: "Subsection 3",
            description: "",
            date: Date(),
            complete: false, 
            firstComponentBlockId: nil
        )
        
        let primaryCourse = PrimaryCourse(
            name: "Primary Course",
            org: "Organization",
            courseID: "123",
            hasAccess: true,
            courseStart: Date(),
            courseEnd: Date(),
            courseBanner: "https://thumbs.dreamstime.com/b/logo-edx-samsung-tablet-edx-massive-open-online-course-mooc-provider-hosts-online-university-level-courses-wide-117763805.jpg",
            futureAssignments: [futureAssignment],
            pastAssignments: [futureAssignment],
            progressEarned: 2,
            progressPossible: 5, 
            lastVisitedBlockID: nil, 
            resumeTitle: nil
        )
        return PrimaryEnrollment(primaryCourse: primaryCourse, courses: courses, totalPages: 1, count: 1)
    }
    
    func getPrimaryEnrollmentOffline() async throws -> Core.PrimaryEnrollment {
        Core.PrimaryEnrollment(primaryCourse: nil, courses: [], totalPages: 1, count: 1)
    }
    
    func getAllCourses(filteredBy: String, page: Int) async throws -> Core.PrimaryEnrollment {
        var courses: [CourseItem] = []
        for i in 0...10 {
            courses.append(
                CourseItem(
                    name: "Course name \(i)",
                    org: "Organization",
                    shortDescription: "shortDescription",
                    imageURL: "",
                    hasAccess: true,
                    courseStart: nil,
                    courseEnd: nil,
                    enrollmentStart: nil,
                    enrollmentEnd: nil,
                    courseID: "course_id_\(i)",
                    numPages: 1,
                    coursesCount: 0,
                    courseRawImage: nil,
                    progressEarned: 4,
                    progressPossible: 10
                )
            )
        }
        
        return PrimaryEnrollment(primaryCourse: nil, courses: courses, totalPages: 1, count: 1)
    }
}
#endif
// swiftlint:enable all

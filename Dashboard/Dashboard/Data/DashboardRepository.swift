//
//  DashboardRepository.swift
//  Dashboard
//
//  Created by  Stepanok Ivan on 19.09.2022.
//

import Foundation
import Core

public protocol DashboardRepositoryProtocol {
    func getMyCourses(page: Int) async throws -> [CourseItem]
    func getMyCoursesOffline() throws -> [CourseItem]
    func getMyLearnCourses(pageSize: Int) async throws -> MyEnrollments
    func getMyLearnCoursesOffline() async throws -> MyEnrollments
    func getAllCourses(filteredBy: String, page: Int) async throws -> MyEnrollments
    func getAllCoursesOffline() async throws -> MyEnrollments
}

public class DashboardRepository: DashboardRepositoryProtocol {
    
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
    
    public func getMyCourses(page: Int) async throws -> [CourseItem] {
        let result = try await api.requestData(
            DashboardEndpoint.getMyCourses(username: storage.user?.username ?? "", page: page)
        )
            .mapResponse(DataLayer.CourseEnrollments.self)
            .domain(baseURL: config.baseURL.absoluteString)
        persistence.saveMyCourses(items: result)
        return result
        
    }
    
    public func getMyCoursesOffline() throws -> [CourseItem] {
        return try persistence.loadMyCourses()
    }
    
    public func getMyLearnCourses(pageSize: Int) async throws -> MyEnrollments {
        let result = try await api.requestData(
            DashboardEndpoint.getMyLearnCourses(
                username: storage.user?.username ?? "",
                pageSize: pageSize
            )
        )
            .mapResponse(DataLayer.MyLearnCourses.self)
            .domain(baseURL: config.baseURL.absoluteString)
        persistence.saveMyEnrollments(enrollments: result)
        return result
    }
    
    public func getMyLearnCoursesOffline() async throws -> MyEnrollments {
        return try persistence.loadMyEnrollments()
    }
    
    public func getAllCourses(filteredBy: String, page: Int) async throws -> MyEnrollments {
        let result = try await api.requestData(
            DashboardEndpoint.getAllCourses(
                username: storage.user?.username ?? "",
                filteredBy: filteredBy,
                page: page
            )
        )
            .mapResponse(DataLayer.MyLearnCourses.self)
            .domain(baseURL: config.baseURL.absoluteString)
//        persistence.saveMyCourses(items: result.courses)
        return result
    }
    
    public func getAllCoursesOffline() async throws -> MyEnrollments {
//        let courses = try persistence.loadMyCourses()
        return MyEnrollments(primaryCourse: nil, courses: [], totalPages: 1, count: 1)
    }
}

// Mark - For testing and SwiftUI preview
#if DEBUG
class DashboardRepositoryMock: DashboardRepositoryProtocol {
    func getCourseEnrollments(baseURL: String) async throws -> [CourseItem] {
        do {
            let courseEnrollments = try
            DashboardRepository.CourseEnrollmentsJSON.data(using: .utf8)!
                .mapResponse(DataLayer.CourseEnrollments.self)
                .domain(baseURL: baseURL)
            return courseEnrollments
        } catch {
            throw error
        }
    }
    
    func getMyCourses(page: Int) async throws -> [CourseItem] {
        var models: [CourseItem] = []
        for i in 0...10 {
            models.append(
                CourseItem(
                    name: "Course name \(i)",
                    org: "Organization",
                    shortDescription: "shortDescription",
                    imageURL: "",
                    isActive: true,
                    courseStart: nil,
                    courseEnd: nil,
                    enrollmentStart: nil,
                    enrollmentEnd: nil,
                    courseID: "course_id_\(i)",
                    numPages: 1,
                    coursesCount: 0,
                    progressEarned: 0,
                    progressPossible: 0
                )
            )
        }
        return models
    }
    
    func getMyCoursesOffline() throws -> [CourseItem] { return [] }
    
    public func getMyLearnCourses(pageSize: Int) async throws -> MyEnrollments {
        
        var courses: [CourseItem] = []
        for i in 0...10 {
            courses.append(
                CourseItem(
                    name: "Course name \(i)",
                    org: "Organization",
                    shortDescription: "shortDescription",
                    imageURL: "",
                    isActive: true,
                    courseStart: nil,
                    courseEnd: nil,
                    enrollmentStart: nil,
                    enrollmentEnd: nil,
                    courseID: "course_id_\(i)",
                    numPages: 1,
                    coursesCount: 0,
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
            isActive: true,
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
        return MyEnrollments(primaryCourse: primaryCourse, courses: courses, totalPages: 1, count: 1)
    }
    
    func getMyLearnCoursesOffline() async throws -> Core.MyEnrollments {
        Core.MyEnrollments(primaryCourse: nil, courses: [], totalPages: 1, count: 1)
    }
    
    
    func getAllCourses(filteredBy: String, page: Int) async throws -> Core.MyEnrollments {
        var courses: [CourseItem] = []
        for i in 0...10 {
            courses.append(
                CourseItem(
                    name: "Course name \(i)",
                    org: "Organization",
                    shortDescription: "shortDescription",
                    imageURL: "",
                    isActive: true,
                    courseStart: nil,
                    courseEnd: nil,
                    enrollmentStart: nil,
                    enrollmentEnd: nil,
                    courseID: "course_id_\(i)",
                    numPages: 1,
                    coursesCount: 0,
                    progressEarned: 4,
                    progressPossible: 10
                )
            )
        }
        
        return MyEnrollments(primaryCourse: nil, courses: courses, totalPages: 1, count: 1)
    }
    
    func getAllCoursesOffline() async throws -> Core.MyEnrollments {
        Core.MyEnrollments(primaryCourse: nil, courses: [], totalPages: 1, count: 1)
    }
}
#endif

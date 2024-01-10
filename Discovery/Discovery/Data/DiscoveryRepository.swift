//
//  DiscoveryRepository.swift
//  Discovery
//
//  Created by  Stepanok Ivan on 16.09.2022.
//

import Foundation
import Core
import CoreData
import Alamofire

public protocol DiscoveryRepositoryProtocol {
    func getDiscovery(page: Int) async throws -> [CourseItem]
    func searchCourses(page: Int, searchTerm: String) async throws -> [CourseItem]
    func getDiscoveryOffline() throws -> [CourseItem]
    func getCourseDetails(courseID: String) async throws -> CourseDetails
    func getLoadedCourseDetails(courseID: String) async throws -> CourseDetails
    func enrollToCourse(courseID: String) async throws -> Bool
}

public class DiscoveryRepository: DiscoveryRepositoryProtocol {
    
    private let api: API
    private let coreStorage: CoreStorage
    private let config: ConfigProtocol
    private let persistence: DiscoveryPersistenceProtocol
    
    public init(api: API,
                appStorage: CoreStorage,
                config: ConfigProtocol,
                persistence: DiscoveryPersistenceProtocol) {
        self.api = api
        self.coreStorage = appStorage
        self.config = config
        self.persistence = persistence
    }
    
    public func getDiscovery(page: Int) async throws -> [CourseItem] {
        let discoveryResponse = try await api.requestData(DiscoveryEndpoint.getDiscovery(
            username: coreStorage.user?.username ?? "", page: page)
        ).mapResponse(DataLayer.DiscoveryResponce.self).domain
        persistence.saveDiscovery(items: discoveryResponse)
        return discoveryResponse
    }
    
    public func getDiscoveryOffline() throws -> [CourseItem] {
        return try persistence.loadDiscovery()
    }
    
    public func searchCourses(page: Int, searchTerm: String) async throws -> [CourseItem] {
        let searchResponse = try await api.requestData(DiscoveryEndpoint.searchCourses(
            username: coreStorage.user?.username ?? "", page: page, searchTerm: searchTerm)
        ).mapResponse(DataLayer.DiscoveryResponce.self).domain
                         
        return searchResponse
    }
    
    public func getCourseDetails(courseID: String) async throws -> CourseDetails {
        let response = try await api.requestData(
            DiscoveryEndpoint.getCourseDetail(courseID: courseID, username: coreStorage.user?.username ?? "")
        ).mapResponse(DataLayer.CourseDetailsResponse.self)
            .domain(baseURL: config.baseURL.absoluteString)
        
        persistence.saveCourseDetails(course: response)
        
        return response
    }
    
    public func getLoadedCourseDetails(courseID: String) async throws -> CourseDetails {
        return try persistence.loadCourseDetails(courseID: courseID)
    }
    
    public func enrollToCourse(courseID: String) async throws -> Bool {
        let enroll = try await api.request(DiscoveryEndpoint.enrollToCourse(courseID: courseID))
        if enroll.statusCode == 200 {
            return true
        } else {
            return false
        }
    }
}

// Mark - For testing and SwiftUI preview
#if DEBUG
class DiscoveryRepositoryMock: DiscoveryRepositoryProtocol {
    
    public  func getCourseDetails(courseID: String) async throws -> CourseDetails {
        return CourseDetails(
            courseID: "courseID",
            org: "Organization",
            courseTitle: "Course title",
            courseDescription: "Course description",
            courseStart: Date(iso8601: "2021-05-26T12:13:14Z"),
            courseEnd: Date(iso8601: "2022-05-26T12:13:14Z"),
            enrollmentStart: nil,
            enrollmentEnd: nil,
            isEnrolled: false,
            overviewHTML: "<b>Course description</b><br><br>Lorem ipsum",
            courseBannerURL: "courseBannerURL",
            courseVideoURL: nil
        )
    }
    
    func getLoadedCourseDetails(courseID: String) async throws -> CourseDetails {
        return CourseDetails(
            courseID: "courseID",
            org: "Organization",
            courseTitle: "Course title",
            courseDescription: "Course description",
            courseStart: Date(iso8601: "2021-05-26T12:13:14Z"),
            courseEnd: Date(iso8601: "2022-05-26T12:13:14Z"),
            enrollmentStart: nil,
            enrollmentEnd: nil,
            isEnrolled: false,
            overviewHTML: "<b>Course description</b><br><br>Lorem ipsum",
            courseBannerURL: "courseBannerURL",
            courseVideoURL: nil
        )
    }
    
    public  func enrollToCourse(courseID: String) async throws -> Bool {
        return true
    }
    
    func getDiscovery(page: Int) async throws -> [CourseItem] {
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
                    numPages: 1, coursesCount: 10
                )
            )
        }
        return models
    }
    
    func searchCourses(page: Int, searchTerm: String) async throws -> [CourseItem] {
        var models: [CourseItem] = []
        for i in 0...10 {
            models.append(
                CourseItem(
                    name: "Course name \(i)",
                    org: "Organization",
                    shortDescription: "shortDescription",
                    imageURL: "",
                    isActive: nil,
                    courseStart: nil,
                    courseEnd: nil,
                    enrollmentStart: nil,
                    enrollmentEnd: nil,
                    courseID: "course_id_\(i)",
                    numPages: 1, coursesCount: 10
                )
            )
        }
        return models
    }
    
    func getDiscoveryOffline() -> [CourseItem] {
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
                    coursesCount: 10
                )
            )
        }
        return models
    }
}
#endif

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
}

public class DiscoveryRepository: DiscoveryRepositoryProtocol {
    
    private let api: API
    private let appStorage: CoreStorage
    private let config: Configurable
    private let persistence: DiscoveryPersistenceProtocol
    
    public init(api: API,
                appStorage: CoreStorage,
                config: Configurable,
                persistence: DiscoveryPersistenceProtocol) {
        self.api = api
        self.appStorage = appStorage
        self.config = config
        self.persistence = persistence
    }
    
    public func getDiscovery(page: Int) async throws -> [CourseItem] {
        let discoveryResponse = try await api.requestData(DiscoveryEndpoint.getDiscovery(
            username: appStorage.user?.username ?? "", page: page)
        ).mapResponse(DataLayer.DiscoveryResponce.self).domain
        persistence.saveDiscovery(items: discoveryResponse)
        return discoveryResponse
    }
    
    public func getDiscoveryOffline() throws -> [CourseItem] {
        return try persistence.loadDiscovery()
    }
    
    public func searchCourses(page: Int, searchTerm: String) async throws -> [CourseItem] {
        let searchResponse = try await api.requestData(DiscoveryEndpoint.searchCourses(
            username: appStorage.user?.username ?? "", page: page, searchTerm: searchTerm)
        ).mapResponse(DataLayer.DiscoveryResponce.self).domain
                         
        return searchResponse
    }
}

// Mark - For testing and SwiftUI preview
#if DEBUG
class DiscoveryRepositoryMock: DiscoveryRepositoryProtocol {
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

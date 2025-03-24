//
//  DatesViewRepository.swift
//  AppDates
//
//  Created by Ivan Stepanok on 15.02.2025.
//

import Foundation
import Core
import OEXFoundation

public protocol DatesViewRepositoryProtocol: Sendable {
    func getCourseDates(page: Int) async throws -> ([CourseDate], Int?)
    func getCourseDatesOffline() async throws -> [CourseDate]
}

public actor DatesViewRepository: DatesViewRepositoryProtocol {
    
    private let api: API
    private let storage: CoreStorage
    private let config: ConfigProtocol
    
    public init(api: API, storage: CoreStorage, config: ConfigProtocol) {
        self.api = api
        self.storage = storage
        self.config = config
    }
    
    public func getCourseDates(page: Int) async throws -> ([CourseDate], Int?) {
        let response = try await api.requestData(
            DatesViewEndpoint.getCourseDates(username: storage.user?.username ?? "", page: page)
        )
            .mapResponse(DataLayer.CourseDatesResponse.self)
        
        return (response.domain(), response.next)
    }
    
    public func getCourseDatesOffline() async throws -> [CourseDate] {
        // In a real implementation, this would fetch from a local database
        // For now, return an empty array
        return []
    }
}

// Mark - For testing and SwiftUI preview
#if DEBUG
public final class DatesViewRepositoryMock: DatesViewRepositoryProtocol {
    
    public init() {}
    
    public func getCourseDates(page: Int) async throws -> ([CourseDate], Int?) {
        let dates: [CourseDate]
        let nextPage: Int?
        
        if page == 1 {
            dates = [
                CourseDate(
                    date: Date().addingTimeInterval(-86400 * 5),
                    title: "Past Assignment 1",
                    courseName: "Course 1",
                    courseId: "course-v1:1+1+1",
                    blockId: "block-v1:1+1+1+type@sequential+block@bafd854414124f6db42fee42ca8acc14",
                    hasAccess: true
                ),
                CourseDate(
                    date: Date().addingTimeInterval(-86400 * 4),
                    title: "Past Assignment 2",
                    courseName: "Course 2",
                    courseId: "course-v1:1+1+2",
                    blockId: "block-v1:1+1+2+type@sequential+block@bafd854414124f6db42fee42ca8acc15",
                    hasAccess: true
                )
            ]
            nextPage = 2
        } else {
            dates = [
                CourseDate(
                    date: Date(),
                    title: "Today's Assignment",
                    courseName: "Course 3",
                    courseId: "course-v1:1+1+3",
                    blockId: "block-v1:1+1+3+type@sequential+block@bafd854414124f6db42fee42ca8acc16",
                    hasAccess: true
                ),
                CourseDate(
                    date: Date().addingTimeInterval(86400 * 2),
                    title: "Future Assignment 1",
                    courseName: "Course 4",
                    courseId: "course-v1:1+1+4",
                    blockId: "block-v1:1+1+4+type@sequential+block@bafd854414124f6db42fee42ca8acc17",
                    hasAccess: true
                ),
                CourseDate(
                    date: Date().addingTimeInterval(86400 * 7),
                    title: "Future Assignment 2",
                    courseName: "Course 5",
                    courseId: "course-v1:1+1+5",
                    blockId: "block-v1:1+1+5+type@sequential+block@bafd854414124f6db42fee42ca8acc18",
                    hasAccess: true
                )
            ]
            nextPage = nil
        }
        
        return (dates, nextPage)
    }
    
    public func getCourseDatesOffline() async throws -> [CourseDate] {
        return []
    }
}
#endif

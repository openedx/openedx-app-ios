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
    func getCourseDates(page: Int) async throws -> ([CourseDate], String?)
    func getCourseDatesOffline(page: Int?) async throws -> [CourseDate]
    func resetAllRelativeCourseDeadlines() async throws
    func clearAllCourseDates() async
}

public actor DatesViewRepository: DatesViewRepositoryProtocol {
    
    private let api: API
    private let storage: CoreStorage
    private let config: ConfigProtocol
    private let persistence: DatesPersistenceProtocol
    
    public init(api: API, storage: CoreStorage, config: ConfigProtocol, persistence: DatesPersistenceProtocol) {
        self.api = api
        self.storage = storage
        self.config = config
        self.persistence = persistence
    }
    
    public func getCourseDates(page: Int) async throws -> ([CourseDate], String?) {
        let startTime = Date()  // Начало замера времени

        let response = try await api.requestData(
            DatesViewEndpoint.getCourseDates(username: storage.user?.username ?? "", page: page)
        )
        .mapResponse(DataLayer.CourseDatesResponse.self)
        
        let dates = response.domain()
        await persistence.saveCourseDates(dates: dates, page: page)
        
        let elapsedTime = Date().timeIntervalSince(startTime)  // Вычисляем прошедшее время
        print("Запрос занял \(elapsedTime) секунд")
        
        return (dates, response.next)
    }
    
    public func getCourseDatesOffline(page: Int?) async throws -> [CourseDate] {
        return try await persistence.loadCourseDates(page: page)
    }
    
    public func resetAllRelativeCourseDeadlines() async throws {
        let response = try await api.request(DatesViewEndpoint.resetAllRelativeCourseDeadlines)
        print(">>>>> resetAllRelativeCourseDeadlines: statusCode \(response.statusCode)")
    }
    
    public func clearAllCourseDates() async {
        await persistence.clearAllCourseDates()
    }
}

// Mark - For testing and SwiftUI preview
#if DEBUG
public final class DatesViewRepositoryMock: DatesViewRepositoryProtocol {
    
    public init() {}
    
    public func getCourseDates(page: Int) async throws -> ([CourseDate], String?) {
        let dates: [CourseDate]
        let hasNextPage: String?
        
        if page == 1 {
            dates = [
                CourseDate(
                    location: "1",
                    date: Date().addingTimeInterval(-86400 * 5),
                    title: "Past Assignment 1",
                    courseName: "Course 1",
                    courseId: "course-v1:1+1+1",
                    blockId: "block-v1:1+1+1+type@sequential+block@bafd854414124f6db42fee42ca8acc14",
                    hasAccess: true
                ),
                CourseDate(
                    location: "2",
                    date: Date().addingTimeInterval(-86400 * 4),
                    title: "Past Assignment 2",
                    courseName: "Course 2",
                    courseId: "course-v1:1+1+2",
                    blockId: "block-v1:1+1+2+type@sequential+block@bafd854414124f6db42fee42ca8acc15",
                    hasAccess: true
                )
            ]
            hasNextPage = "2"
        } else {
            dates = [
                CourseDate(
                    location: "3",
                    date: Date(),
                    title: "Today's Assignment",
                    courseName: "Course 3",
                    courseId: "course-v1:1+1+3",
                    blockId: "block-v1:1+1+3+type@sequential+block@bafd854414124f6db42fee42ca8acc16",
                    hasAccess: true
                ),
                CourseDate(
                    location: "4",
                    date: Date().addingTimeInterval(86400 * 2),
                    title: "Future Assignment 1",
                    courseName: "Course 4",
                    courseId: "course-v1:1+1+4",
                    blockId: "block-v1:1+1+4+type@sequential+block@bafd854414124f6db42fee42ca8acc17",
                    hasAccess: true
                ),
                CourseDate(
                    location: "5",
                    date: Date().addingTimeInterval(86400 * 7),
                    title: "Future Assignment 2",
                    courseName: "Course 5",
                    courseId: "course-v1:1+1+5",
                    blockId: "block-v1:1+1+5+type@sequential+block@bafd854414124f6db42fee42ca8acc18",
                    hasAccess: true
                )
            ]
            hasNextPage = nil
        }
        
        return (dates, hasNextPage)
    }
    
    public func getCourseDatesOffline(page: Int?) async throws -> [CourseDate] {
        return [
            CourseDate(
                location: "6",
                date: Date().addingTimeInterval(-86400 * 3),
                title: "Offline Assignment",
                courseName: "Cached Course",
                courseId: "course-v1:1+1+offline",
                blockId: "block-v1:1+1+offline+type@sequential+block@bafd854414124f6db42fee42ca8acc19",
                hasAccess: true
            )
        ]
    }
    
    public func resetAllRelativeCourseDeadlines() async throws {}
    
    public func clearAllCourseDates() async {}
}
#endif

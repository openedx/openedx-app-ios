//
//  DatesRepository.swift
//  AppDates
//
//  Created by Ivan Stepanok on 15.02.2025.
//

import Foundation
import Core
import OEXFoundation

public protocol DatesRepositoryProtocol: Sendable {
    func getCourseDates(page: Int) async throws -> ([CourseDate], String?)
    func getCourseDatesOffline(limit: Int?, offset: Int?) async throws -> [CourseDate]
    func resetAllRelativeCourseDeadlines() async throws
}

public actor DatesRepository: DatesRepositoryProtocol {
    
    private let api: API
    private let storage: CoreStorage
    private let config: ConfigProtocol
    private let persistence: DatesPersistenceProtocol
    private var totalItemsCount: Int = 0
    
    public init(api: API, storage: CoreStorage, config: ConfigProtocol, persistence: DatesPersistenceProtocol) {
        self.api = api
        self.storage = storage
        self.config = config
        self.persistence = persistence
    }
    
    public func getCourseDates(page: Int) async throws -> ([CourseDate], String?) {
        let response = try await api.requestData(
            DatesEndpoint.getCourseDates(username: storage.user?.username ?? "", page: page)
        )
        .mapResponse(DataLayer.CourseDatesResponse.self)
        
        let dates = response.domain
        
        if page == 1 {
            await persistence.clearAllCourseDates()
            totalItemsCount = 0
        }
        
        let startIndex = totalItemsCount
        let indexedDates = dates.enumerated().map { offset, date in
            CourseDate(
                date: date.date,
                title: date.title,
                courseName: date.courseName,
                courseId: date.courseId,
                blockId: date.blockId,
                hasAccess: date.hasAccess,
                order: startIndex + offset
            )
        }
        totalItemsCount += indexedDates.count
        
        await persistence.saveCourseDates(dates: indexedDates, startIndex: startIndex)
        
        return (indexedDates, response.next)
    }
    
    public func getCourseDatesOffline(limit: Int? = nil, offset: Int? = nil) async throws -> [CourseDate] {
        return try await persistence.loadCourseDates(limit: limit, offset: offset)
    }
    
    public func resetAllRelativeCourseDeadlines() async throws {
        try await api.request(DatesEndpoint.resetAllRelativeCourseDeadlines)
    }
}

// Mark - For testing and SwiftUI preview
#if DEBUG
public final class DatesRepositoryMock: DatesRepositoryProtocol {
    
    public init() {}
    
    public func getCourseDates(page: Int) async throws -> ([CourseDate], String?) {
        let dates = [
            CourseDate(
                    date: Date().addingTimeInterval(-86400 * 2),
                    title: "Assignment from the Day Before Yesterday",
                    courseName: "Course 6",
                    courseId: "course-v1:1+1+daybeforeyesterday",
                    blockId: "block-v1:1+1+daybeforeyesterday+type@sequential+block@assignment",
                    hasAccess: true
                ),
                CourseDate(
                    date: Date().addingTimeInterval(-86400),
                    title: "Assignment from Yesterday",
                    courseName: "Course 7",
                    courseId: "course-v1:1+1+yesterday",
                    blockId: "block-v1:1+1+yesterday+type@sequential+block@assignment",
                    hasAccess: true
                ),
            CourseDate(
                date: Date(),
                title: "Today's Assignment 1",
                courseName: "Course 1",
                courseId: "course-v1:1+1+today1",
                blockId: "block-v1:1+1+today1+type@sequential+block@assignment1",
                hasAccess: true
            ),
            CourseDate(
                date: Date(),
                title: "Today's Assignment 2",
                courseName: "Course 1",
                courseId: "course-v1:1+1+today2",
                blockId: "block-v1:1+1+today2+type@sequential+block@assignment2",
                hasAccess: true
            ),
            CourseDate(
                date: Date().addingTimeInterval(86400), // 1 day
                title: "Tomorrow's Assignment",
                courseName: "Course 2",
                courseId: "course-v1:1+1+tomorrow1",
                blockId: "block-v1:1+1+tomorrow1+type@sequential+block@assignment3",
                hasAccess: true
            ),
            CourseDate(
                date: Date().addingTimeInterval(86400 * 5),
                title: "Assignment in 5 Days",
                courseName: "Course 3",
                courseId: "course-v1:1+1+5days1",
                blockId: "block-v1:1+1+5days1+type@sequential+block@assignment4",
                hasAccess: true
            ),
            CourseDate(
                date: Date().addingTimeInterval(86400 * 5),
                title: "Assignment in 5 Days (Part 2)",
                courseName: "Course 3",
                courseId: "course-v1:1+1+5days2",
                blockId: "block-v1:1+1+5days2+type@sequential+block@assignment5",
                hasAccess: true
            ),
            CourseDate(
                date: Date().addingTimeInterval(86400 * 10),
                title: "Assignment in 10 Days",
                courseName: "Course 4",
                courseId: "course-v1:1+1+10days1",
                blockId: "block-v1:1+1+10days1+type@sequential+block@assignment6",
                hasAccess: true
            ),
            CourseDate(
                date: Date().addingTimeInterval(86400 * 20),
                title: "Assignment in 20 Days 1",
                courseName: "Course 5",
                courseId: "course-v1:1+1+20days1",
                blockId: "block-v1:1+1+20days1+type@sequential+block@assignment7",
                hasAccess: true
            ),
            CourseDate(
                date: Date().addingTimeInterval(86400 * 20),
                title: "Assignment in 20 Days 2",
                courseName: "Course 5",
                courseId: "course-v1:1+1+20days2",
                blockId: "block-v1:1+1+20days2+type@sequential+block@assignment8",
                hasAccess: true
            )
        ]
        
        return (dates, nil)
    }
    
    public func getCourseDatesOffline(limit: Int? = nil, offset: Int? = nil) async throws -> [CourseDate] {
        return [
            CourseDate(
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

//
//  CourseDate.swift
//  AppDates
//
//  Created by Ivan Stepanok on 15.02.2025.
//

public struct CourseDate: Identifiable, Sendable {
    public var id: String { date.description + title + courseName }
    public let date: Date
    public let title: String
    public let courseName: String
    public let courseId: String?
    public let blockId: String?
    public let hasAccess: Bool
    
    public init(
        date: Date,
        title: String,
        courseName: String,
        courseId: String? = nil,
        blockId: String? = nil,
        hasAccess: Bool = true
    ) {
        self.date = date
        self.title = title
        self.courseName = courseName
        self.courseId = courseId
        self.blockId = blockId
        self.hasAccess = hasAccess
    }
}

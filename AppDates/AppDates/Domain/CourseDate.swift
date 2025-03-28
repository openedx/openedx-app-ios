//
//  CourseDate.swift
//  AppDates
//
//  Created by Ivan Stepanok on 15.02.2025.
//

public struct CourseDate: Identifiable, Sendable {
    public var id: String { location + courseName + title + (blockId ?? "") }
    public let location: String
    public let date: Date
    public let title: String
    public let courseName: String
    public let courseId: String?
    public let blockId: String?
    public let hasAccess: Bool
    
    public init(
        location: String,
        date: Date,
        title: String,
        courseName: String,
        courseId: String? = nil,
        blockId: String? = nil,
        hasAccess: Bool = true
    ) {
        self.location = location
        self.date = date
        self.title = title
        self.courseName = courseName
        self.courseId = courseId
        self.blockId = blockId
        self.hasAccess = hasAccess
    }
}

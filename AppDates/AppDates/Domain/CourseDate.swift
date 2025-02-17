//
//  CourseDate.swift
//  AppDates
//
//  Created by Ivan Stepanok on 15.02.2025.
//

public struct CourseDate: Identifiable {
    public var id: String { date.description + title + courseName }
    public let date: Date
    public let title: String
    public let courseName: String
    
    public init(date: Date, title: String, courseName: String) {
        self.date = date
        self.title = title
        self.courseName = courseName
    }
}

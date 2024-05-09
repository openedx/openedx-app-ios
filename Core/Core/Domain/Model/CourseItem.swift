//
//  Discovery.swift
//  Core
//
//  Created by  Stepanok Ivan on 16.09.2022.
//

import Foundation

public enum CourseTab: Int, CaseIterable, Identifiable {
    public var id: Int {
        rawValue
    }

    case course
    case videos
    case discussion
    case dates
    case handounds

}

public struct CourseItem: Hashable {
    public let name: String
    public let org: String
    public let shortDescription: String
    public let imageURL: String
    public let isActive: Bool
    public let courseStart: Date?
    public let courseEnd: Date?
    public let enrollmentStart: Date?
    public let enrollmentEnd: Date?
    public let courseID: String
    public let numPages: Int
    public let coursesCount: Int
    public let progressEarned: Double
    public let progressPossible: Double
    
    public init(name: String,
                org: String,
                shortDescription: String,
                imageURL: String,
                isActive: Bool,
                courseStart: Date?,
                courseEnd: Date?,
                enrollmentStart: Date?,
                enrollmentEnd: Date?,
                courseID: String,
                numPages: Int,
                coursesCount: Int,
                progressEarned: Double,
                progressPossible: Double) {
        self.name = name
        self.org = org
        self.shortDescription = shortDescription
        self.imageURL = imageURL
        self.isActive = isActive
        self.courseStart = courseStart
        self.courseEnd = courseEnd
        self.enrollmentStart = enrollmentStart
        self.enrollmentEnd = enrollmentEnd
        self.courseID = courseID
        self.numPages = numPages
        self.coursesCount = coursesCount
        self.progressEarned = progressEarned
        self.progressPossible = progressPossible
    }
}

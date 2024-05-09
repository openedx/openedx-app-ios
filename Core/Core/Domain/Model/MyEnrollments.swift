//
//  MyEnrollments.swift
//  Core
//
//  Created by  Stepanok Ivan on 16.04.2024.
//

import Foundation

public struct MyEnrollments: Hashable {
    public let primaryCourse: PrimaryCourse?
    public var courses: [CourseItem]
    public let totalPages: Int
    public let count: Int
    
    public init(primaryCourse: PrimaryCourse?, courses: [CourseItem], totalPages: Int, count: Int) {
        self.primaryCourse = primaryCourse
        self.courses = courses
        self.totalPages = totalPages
        self.count = count
    }
}

public struct PrimaryCourse: Hashable {
    public let name: String
    public let org: String
    public let courseID: String
    public let isActive: Bool
    public let courseStart: Date?
    public let courseEnd: Date?
    public let courseBanner: String
    public let futureAssignments: [Assignment]
    public let pastAssignments: [Assignment]
    public let progressEarned: Double?
    public let progressPossible: Double?
    public let lastVisitedBlockID: String?
    public let resumeTitle: String?
    
    public init(
        name: String,
        org: String,
        courseID: String,
        isActive: Bool,
        courseStart: Date?,
        courseEnd: Date?,
        courseBanner: String,
        futureAssignments: [Assignment],
        pastAssignments: [Assignment],
        progressEarned: Double?,
        progressPossible: Double?,
        lastVisitedBlockID: String?,
        resumeTitle: String?
    ) {
        self.name = name
        self.org = org
        self.courseID = courseID
        self.isActive = isActive
        self.courseStart = courseStart
        self.courseEnd = courseEnd
        self.courseBanner = courseBanner
        self.futureAssignments = futureAssignments
        self.pastAssignments = pastAssignments
        self.progressEarned = progressEarned
        self.progressPossible = progressPossible
        self.lastVisitedBlockID = lastVisitedBlockID
        self.resumeTitle = resumeTitle
    }
}

public struct Assignment: Hashable {
    public let type: String
    public let title: String
    public let description: String?
    public let date: Date
    public let complete: Bool
    public let firstComponentBlockId: String?
    
    public init(
        type: String,
        title: String,
        description: String?,
        date: Date,
        complete: Bool,
        firstComponentBlockId: String?
    ) {
        self.type = type
        self.title = title
        self.description = description
        self.date = date
        self.complete = complete
        self.firstComponentBlockId = firstComponentBlockId
    }
}

//
//  Discovery.swift
//  Core
//
//  Created by  Stepanok Ivan on 16.09.2022.
//

import Foundation

public struct CourseItem: Hashable {
    public let name: String
    public let org: String
    public let shortDescription: String
    public let imageURL: String
    public let isActive: Bool?
    public let courseStart: Date?
    public let courseEnd: Date?
    public let enrollmentStart: Date?
    public let enrollmentEnd: Date?
    public let courseID: String
    public let certificate: Certificate?
    public let numPages: Int
    public let coursesCount: Int
    
    public init(name: String,
                org: String,
                shortDescription: String,
                imageURL: String,
                isActive: Bool?,
                courseStart: Date?,
                courseEnd: Date?,
                enrollmentStart: Date?,
                enrollmentEnd: Date?,
                courseID: String,
                certificate: Certificate?,
                numPages: Int,
                coursesCount: Int) {
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
        self.certificate = certificate
        self.numPages = numPages
        self.coursesCount = coursesCount
    }
}

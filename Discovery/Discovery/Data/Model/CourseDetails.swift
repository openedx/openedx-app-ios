//
//  CourseDetails.swift
//  CourseDetails
//
//  Created by  Stepanok Ivan on 26.09.2022.
//

import Foundation

public struct CourseDetails {
    public let courseID: String
    public let org: String
    public let courseTitle: String
    public let courseDescription: String?
    public let courseStart: Date?
    public let courseEnd: Date?
    public let enrollmentStart: Date?
    public let enrollmentEnd: Date?
    public var isEnrolled: Bool
    public var overviewHTML: String
    public let courseBannerURL: String
    public let courseVideoURL: String?
    
    public init(courseID: String,
                org: String,
                courseTitle: String,
                courseDescription: String?,
                courseStart: Date?,
                courseEnd: Date?,
                enrollmentStart: Date?,
                enrollmentEnd: Date?,
                isEnrolled: Bool,
                overviewHTML: String,
                courseBannerURL: String,
                courseVideoURL: String?) {
        self.courseID = courseID
        self.org = org
        self.courseTitle = courseTitle
        self.courseDescription = courseDescription
        self.courseStart = courseStart
        self.courseEnd = courseEnd
        self.enrollmentStart = enrollmentStart
        self.enrollmentEnd = enrollmentEnd
        self.isEnrolled = isEnrolled
        self.overviewHTML = overviewHTML
        self.courseBannerURL = courseBannerURL
        self.courseVideoURL = courseVideoURL
    }
}

//
//  CourseDetails.swift
//  CourseDetails
//
//  Created by  Stepanok Ivan on 26.09.2022.
//

import Foundation

public struct CourseDetails {
    let courseID: String
    let org: String
    let courseTitle: String
    let courseDescription: String
    let courseStart: Date?
    let courseEnd: Date?
    let enrollmentStart: Date?
    let enrollmentEnd: Date?
    var isEnrolled: Bool
    var overviewHTML: String
    let courseBannerURL: String
    let courseVideoURL: String?
    
    public init(courseID: String,
                org: String,
                courseTitle: String,
                courseDescription: String,
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

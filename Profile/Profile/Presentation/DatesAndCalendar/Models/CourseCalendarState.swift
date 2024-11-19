//
//  CourseCalendarState.swift
//  Profile
//
//  Created by  Stepanok Ivan on 03.06.2024.
//

import Foundation

public struct CourseCalendarState: Sendable {
    public let courseID: String
    public var checksum: String
    
    public init(courseID: String, checksum: String) {
        self.courseID = courseID
        self.checksum = checksum
    }
}

//
//  CourseCalendarEvent.swift
//  Profile
//
//  Created by  Stepanok Ivan on 10.06.2024.
//

import Foundation

public struct CourseCalendarEvent: Sendable {
    public let courseID: String
    public let eventIdentifier: String
    
    public init(courseID: String, eventIdentifier: String) {
        self.courseID = courseID
        self.eventIdentifier = eventIdentifier
    }
}

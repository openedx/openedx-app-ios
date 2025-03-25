//
//  Data_Dates.swift
//  AppDates
//
//  Created by Ivan Stepanok on 15.02.2025.
//

import Foundation
import Core

public extension DataLayer {
    // MARK: - CourseDatesResponse
    struct CourseDatesResponse: Codable {
        public let count: Int
        public let next: String?
        public let previous: String?
        public let results: [CourseDateItem]
        
        public init(count: Int, next: String?, previous: String?, results: [CourseDateItem]) {
            self.count = count
            self.next = next
            self.previous = previous
            self.results = results
        }
    }
    
    // MARK: - CourseDateItem
    struct CourseDateItem: Codable {
        public let courseId: String
        public let location: String
        public let assignmentBlockId: String?
        public let dueDate: String
        public let assignmentTitle: String
        public let learnerHasAccess: Bool
        public let courseName: String
        
        enum CodingKeys: String, CodingKey {
            case courseId = "course_id"
            case location = "location"
            case assignmentBlockId = "first_component_block_id"
            case dueDate = "due_date"
            case assignmentTitle = "assignment_title"
            case learnerHasAccess = "learner_has_access"
            case courseName = "course_name"
        }
        
        public init(
            courseId: String,
            location: String,
            assignmentBlockId: String?,
            dueDate: String,
            assignmentTitle: String,
            learnerHasAccess: Bool,
            courseName: String
        ) {
            self.courseId = courseId
            self.location = location
            self.assignmentBlockId = assignmentBlockId
            self.dueDate = dueDate
            self.assignmentTitle = assignmentTitle
            self.learnerHasAccess = learnerHasAccess
            self.courseName = courseName
        }
    }
}

// Extension for domain conversion
public extension DataLayer.CourseDatesResponse {
    func domain() -> [CourseDate] {
        return results.map { result in
            CourseDate(
                location: result.location,
                date: Date(iso8601: result.dueDate),
                title: result.assignmentTitle,
                courseName: result.courseName,
                courseId: result.courseId,
                blockId: result.assignmentBlockId,
                hasAccess: result.learnerHasAccess
            )
        }
    }
}

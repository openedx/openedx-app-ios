//
//  AssignmentSection.swift
//  Course
//
//  Created by Ivan Stepanok on 12.07.2025.
//

import Foundation

struct AssignmentSection {
    let assignmentType: String
    let label: String
    let weight: Double
    let subsections: [CourseProgressSubsection]
}

struct AssignmentSectionUI {
    let key: String
    let subsections: [CourseProgressSubsection]
    let weight: Double
}

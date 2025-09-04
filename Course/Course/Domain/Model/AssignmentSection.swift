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
    let subsections: [CourseProgressSubsectionUI]
}

struct AssignmentSectionUI {
    let key: String
    let subsections: [CourseProgressSubsectionUI]
    let weight: Double
}

struct CourseProgressSubsectionUI {
    let subsection: CourseProgressSubsection
    let statusText: String
    let statusTextForCarousel: String
    let sequenceName: String
    let status: AssignmentCardStatus
    let shortLabel: String
    var date: Date?
}

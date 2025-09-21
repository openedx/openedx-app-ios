//
//  AssignmentContentData.swift
//  Course
//
//  Created by Ivan Stepanok on 30.07.2025.
//

import Foundation
import Core

struct AssignmentContentData {
    let courseAssignmentsStructure: CourseStructure?
    let assignmentSections: [AssignmentSectionUI]
    let assignmentTypeColors: [String: String]
    let isShowProgress: Bool
    let showError: Bool
    let errorMessage: String?
    
    func clearError() -> AssignmentContentData {
        return AssignmentContentData(
            courseAssignmentsStructure: courseAssignmentsStructure,
            assignmentSections: assignmentSections,
            assignmentTypeColors: assignmentTypeColors,
            isShowProgress: isShowProgress,
            showError: false,
            errorMessage: nil
        )
    }
}

struct AssignmentSectionData {
    let subsectionsUI: [CourseProgressSubsectionUI]
    let sectionName: String
    let assignmentTypeColors: [String: String]
    let courseStructure: CourseStructure?
}

struct AssignmentDetailData {
    let subsectionUI: CourseProgressSubsectionUI
    let sectionName: String
    let onAssignmentTap: (CourseProgressSubsectionUI) -> Void
}

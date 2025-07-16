//
//  OverallGradeView.swift
//  Course
//
//  Created by Ivan Stepanok on 19.06.2025.
//

import SwiftUI
import Core
import Theme

struct OverallGradeView: View {
    
    let currentGrade: Double
    let requiredGrade: Double
    let assignmentPolicies: [CourseProgressAssignmentPolicy]
    let assignmentProgressData: [String: AssignmentProgressData]
    let assignmentColors: [String]
    
    var isCarousel: Bool = false
    
    private var currentGradePercent: Int {
        Int(currentGrade * 100)
    }
    
    private var requiredGradePercent: Int {
        Int(requiredGrade * 100)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            if !isCarousel {
                VStack(alignment: .leading, spacing: 8) {
                    Text(CourseLocalization.CourseContainer.Progress.overallGrade)
                        .font(Theme.Fonts.titleMedium)
                        .foregroundColor(Theme.Colors.textPrimary)
                        .accessibilityAddTraits(.isHeader)
                    
                    Text(CourseLocalization.CourseContainer.Progress.overallGradeDescription)
                        .font(Theme.Fonts.bodySmall)
                        .foregroundColor(Theme.Colors.textPrimary)
                        .lineLimit(nil)
                }
            }
            
            // Current Grade Label
            HStack(spacing: 4) {
                Text(CourseLocalization.CourseContainer.Progress.currentOverallWeightedGrade)
                    .font(Theme.Fonts.bodyMedium)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                Text(String(currentGradePercent) + "%")
                    .font(Theme.Fonts.bodyMedium)
                    .foregroundColor(Theme.Colors.accentColor)
            }
            
            // Segmented Progress Bar
            SegmentedProgressView(
                assignmentPolicies: assignmentPolicies,
                assignmentProgressData: assignmentProgressData,
                assignmentColors: assignmentColors,
                requiredGrade: requiredGrade
            )
            
            if !isCarousel {
                // Warning Message
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(Theme.Colors.warning)
                    
                    Text(CourseLocalization.CourseContainer.Progress.weightedGradeRequired("\(requiredGradePercent)"))
                        .font(Theme.Fonts.labelLarge)
                        .foregroundColor(Theme.Colors.textPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(12)
                .background(Theme.Colors.shade)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Theme.Colors.warning, lineWidth: 1)
                )
                .cornerRadius(8)
            }
        }
    }
}

#if DEBUG
#Preview {
    OverallGradeView(
        currentGrade: 0.52,
        requiredGrade: 0.75,
        assignmentPolicies: [
            CourseProgressAssignmentPolicy(
                numDroppable: 0,
                numTotal: 5,
                shortLabel: "HW",
                type: "Homework",
                weight: 0.3
            ),
            CourseProgressAssignmentPolicy(
                numDroppable: 0,
                numTotal: 2,
                shortLabel: "Exam",
                type: "Exam",
                weight: 0.7
            )
        ],
        assignmentProgressData: [
            "Homework": AssignmentProgressData(
                completed: 3,
                total: 5,
                earnedPoints: 85.0,
                possiblePoints: 100.0,
                percentGraded: 0.85
            ),
            "Exam": AssignmentProgressData(
                completed: 1,
                total: 2,
                earnedPoints: 75.0,
                possiblePoints: 100.0,
                percentGraded: 0.75
            )
        ],
        assignmentColors: ["#D24242", "#7B9645"]
    )
    .padding()
    .background(Theme.Colors.background)
}
#endif

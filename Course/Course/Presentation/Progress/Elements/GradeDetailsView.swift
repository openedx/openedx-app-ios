//
//  GradeDetailsView.swift
//  Course
//
//  Created by Ivan Stepanok on 19.06.2025.
//

import SwiftUI
import Core
import Theme

struct GradeDetailsView: View {
    
    let assignmentPolicies: [CourseProgressAssignmentPolicy]
    @Binding var assignmentProgressData: [String: AssignmentProgressData]
    let currentGrade: Double
    let getAssignmentColor: (Int) -> Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            Text(CourseLocalization.CourseContainer.Progress.gradeDetails)
                .font(Theme.Fonts.titleMedium)
                .foregroundColor(Theme.Colors.textPrimary)
                .accessibilityAddTraits(.isHeader)
            
            // Table Header
            HStack {
                Text(CourseLocalization.CourseContainer.Progress.assignmentType)
                    .font(Theme.Fonts.bodySmall)
                    .foregroundColor(Theme.Colors.textPrimary)
                    .accessibilityLabel(CourseLocalization.Accessibility.assignmentTypeHeader)
                    .accessibilityAddTraits(.isHeader)
                
                Spacer()
                
                Text(CourseLocalization.CourseContainer.Progress.currentMaxPercent)
                    .font(Theme.Fonts.bodySmall)
                    .foregroundColor(Theme.Colors.textPrimary)
                    .accessibilityLabel(CourseLocalization.Accessibility.currentMaxPercentHeader)
                    .accessibilityAddTraits(.isHeader)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel(
                CourseLocalization.Accessibility.assignmentTypeHeader
                + ", "
                + CourseLocalization.Accessibility.currentMaxPercentHeader
            )
            
            // Assignment Items
            VStack(spacing: 0) {
                ForEach(
                    Array(assignmentPolicies.enumerated()),
                    id: \.element.type
                ) { index, policy in
                    GradeItemView(
                        assignmentPolicy: policy,
                        assignmentProgressData: $assignmentProgressData,
                        assignmentType: policy.type,
                        color: getAssignmentColor(index)
                    )
                    
                    Divider()
                        .padding(.vertical, 16)
                }
            }
            
            // Bottom Overall Grade
            HStack {
                Text(CourseLocalization.CourseContainer.Progress.currentOverallWeightedGrade)
                    .font(Theme.Fonts.labelLarge)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                Spacer()
                
                Text("\(Int(currentGrade * 100))%")
                    .font(Theme.Fonts.labelLarge)
                    .foregroundColor(Theme.Colors.accentColor)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel(
                CourseLocalization.Accessibility.currentGrade("\(Int(currentGrade * 100))")
            )
            .accessibilityAddTraits(.updatesFrequently)
        }
    }
}

#if DEBUG
#Preview {
    GradeDetailsView(
        assignmentPolicies: [
            CourseProgressAssignmentPolicy(
                numDroppable: 0,
                numTotal: 5,
                shortLabel: "HW",
                type: "Homework",
                weight: 0.3
            )
        ],
        assignmentProgressData: .constant([
            "Homework": AssignmentProgressData(
                completed: 3,
                total: 5,
                earnedPoints: 85.0,
                possiblePoints: 100.0,
                percentGraded: 0.85
            )
        ]),
        currentGrade: 0.75,
        getAssignmentColor: { _ in .red }
    )
    .padding()
    .loadFonts()
}
#endif

//
//  GradeItemView.swift
//  Course
//
//  Created by Ivan Stepanok on 19.06.2025.
//

import SwiftUI
import Core
import Theme

struct GradeItemView: View {
    
    let assignmentPolicy: CourseProgressAssignmentPolicy
    @Binding var assignmentProgressData: [String: AssignmentProgressData]
    let assignmentType: String
    let color: Color
    
    private var progressData: AssignmentProgressData {
        assignmentProgressData[assignmentType] ?? AssignmentProgressData(
            completed: 0,
            total: 0,
            earnedPoints: 0.0,
            possiblePoints: 0.0,
            percentGraded: 0.0
        )
    }
    
    private var earnedPercent: Int {
        return Int(assignmentPolicy.weight * progressData.percentGraded * 100)
    }
    
    private var maxPercent: Int {
        Int(assignmentPolicy.weight * 100)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(assignmentPolicy.type)
                .font(Theme.Fonts.labelLarge)
                .foregroundColor(Theme.Colors.textPrimary)
                .accessibilityLabel(assignmentPolicy.type)
                .accessibilityAddTraits(.isHeader)
            
            HStack(spacing: 8) {
                // Color indicator
                RoundedRectangle(cornerRadius: 4)
                    .fill(color)
                    .frame(width: 7)
                    .accessibilityHidden(true)
                
                // Content
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        // Assignment type name
                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 4) {
                                Text("\(Int(progressData.completed)) / \(Int(progressData.total))")
                                    .font(Theme.Fonts.bodySmall)
                                    .foregroundColor(Theme.Colors.textPrimary)
                                Text(CourseLocalization.CourseContainer.Progress.complete)
                                    .font(Theme.Fonts.bodySmall)
                                    .foregroundColor(Theme.Colors.textPrimary)
                            }
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel(
                                CourseLocalization.Accessibility.assignmentCompletion(
                                    "\(Int(progressData.completed))", "\(Int(progressData.total))"
                                )
                            )
                            
                            HStack(spacing: 4) {
                                Text("\(maxPercent)%")
                                    .font(Theme.Fonts.bodySmall)
                                    .fontWeight(.bold)
                                    .foregroundColor(Theme.Colors.textPrimary)
                                Text(CourseLocalization.CourseContainer.Progress.ofGrade)
                                    .font(Theme.Fonts.bodySmall)
                                    .foregroundColor(Theme.Colors.textPrimary)
                            }
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel(CourseLocalization.Accessibility.weightContribution("\(maxPercent)"))
                        }
                        
                        Spacer()
                        
                        // Current/Max percentage
                        Text("\(earnedPercent) / \(maxPercent)%")
                            .font(Theme.Fonts.bodyLarge)
                            .fontWeight(.bold)
                            .foregroundColor(Theme.Colors.textPrimary)
                            .accessibilityLabel(CourseLocalization.Accessibility.assignmentGradeEarned(
                                "\(earnedPercent)", "\(maxPercent)")
                            )
                    }
                }
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding(.vertical, 8)
        }
        
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(assignmentPolicy.type)
        .accessibilityValue(CourseLocalization.Accessibility.assignmentFullDetails(
            "\(Int(progressData.completed))",
            "\(Int(progressData.total))",
            "\(maxPercent)",
            "\(earnedPercent)",
            "\(maxPercent)"
        ))
        .accessibilityAddTraits(.updatesFrequently)
    }
}

#if DEBUG
#Preview {
    let mockPolicy = CourseProgressAssignmentPolicy(
        numDroppable: 0,
        numTotal: 1,
        shortLabel: "Homework",
        type: "Basic Assessment Tools",
        weight: 0.15
    )
    
    GradeItemView(
        assignmentPolicy: mockPolicy,
        assignmentProgressData: .constant([
            "Basic Assessment Tools": AssignmentProgressData(
                completed: 13,
                total: 16,
                earnedPoints: 10.0,
                possiblePoints: 15.0,
                percentGraded: 0.67
            )
        ]),
        assignmentType: "Basic Assessment Tools",
        color: .red
    )
    .padding()
    .loadFonts()
}
#endif

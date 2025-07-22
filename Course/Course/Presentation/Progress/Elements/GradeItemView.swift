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
    let progressData: AssignmentProgressData
    let color: Color
    
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
            
            HStack(spacing: 8) {
                // Color indicator
                RoundedRectangle(cornerRadius: 4)
                    .fill(color)
                    .frame(width: 7)
                
                // Content
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        // Assignment type name
                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 4) {
                                Text("\(progressData.completed) / \(progressData.total)")
                                    .font(Theme.Fonts.bodySmall)
                                    .foregroundColor(Theme.Colors.textPrimary)
                                Text(CourseLocalization.CourseContainer.Progress.complete)
                                    .font(Theme.Fonts.bodySmall)
                                    .foregroundColor(Theme.Colors.textPrimary)
                            }
                            
                            HStack(spacing: 4) {
                                Text("\(maxPercent)%")
                                    .font(Theme.Fonts.bodySmall)
                                    .fontWeight(.bold)
                                    .foregroundColor(Theme.Colors.textPrimary)
                                Text(CourseLocalization.CourseContainer.Progress.ofGrade)
                                    .font(Theme.Fonts.bodySmall)
                                    .foregroundColor(Theme.Colors.textPrimary)
                            }
                        }
                        
                        Spacer()
                        
                        // Current/Max percentage
                        Text("\(earnedPercent) / \(maxPercent)%")
                            .font(Theme.Fonts.bodyLarge)
                            .fontWeight(.bold)
                            .foregroundColor(Theme.Colors.textPrimary)
                    }
                }
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding(.vertical, 8)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(CourseLocalization.Accessibility.assignmentItem)
        .accessibilityValue(CourseLocalization.Accessibility.assignmentProgressDetails(
            assignmentPolicy.shortLabel,
            "\(progressData.completed)",
            "\(progressData.total)",
            "\(earnedPercent)",
            "\(maxPercent)"
        ))
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
        progressData: AssignmentProgressData(
            completed: 13,
            total: 16,
            earnedPoints: 10.0,
            possiblePoints: 15.0,
            percentGraded: 0.67
        ),
        color: .red
    )
    .padding()
    .loadFonts()
}
#endif

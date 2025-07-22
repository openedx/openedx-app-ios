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
    
    let viewModel: CourseProgressViewModel
    
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
                    Array(viewModel.assignmentPolicies.enumerated()),
                    id: \.element.type
                ) { index, policy in
                    let progressData = viewModel.getAssignmentProgress(for: policy.type)
                    
                    GradeItemView(
                        assignmentPolicy: policy,
                        progressData: progressData,
                        color: viewModel.getAssignmentColor(for: index)
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
                
                Text("\(Int(viewModel.gradePercentage * 100))%")
                    .font(Theme.Fonts.labelLarge)
                    .foregroundColor(Theme.Colors.accentColor)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel(
                CourseLocalization.Accessibility.currentGrade("\(Int(viewModel.gradePercentage * 100))")
            )
            .accessibilityAddTraits(.updatesFrequently)
        }
    }
}

#if DEBUG
#Preview {
    GradeDetailsView(
        viewModel: CourseProgressViewModel(
            interactor: CourseInteractor.mock,
            router: CourseRouterMock(),
            analytics: CourseAnalyticsMock(),
            connectivity: Connectivity()
        )
    )
    .padding()
    .loadFonts()
}
#endif

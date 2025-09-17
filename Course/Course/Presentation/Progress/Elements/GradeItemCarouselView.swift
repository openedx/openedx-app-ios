import SwiftUI
import Core
import Theme

struct GradeItemCarouselView: View {

    let assignmentPolicy: CourseProgressAssignmentPolicy
    let progressData: AssignmentProgressData
    let color: Color

    private var earnedPercent: Int {
        if progressData.completed == 0 {
            return 0
        }
        return Int(Double(progressData.completed)/Double(progressData.total) * 100)
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
                            Text("\(earnedPercent)%")
                                .font(Theme.Fonts.bodyLarge)
                                .fontWeight(.bold)
                                .foregroundColor(Theme.Colors.textPrimary)
                            HStack(spacing: 4) {
                                Text("\(progressData.completed) / \(progressData.total)")
                                    .font(Theme.Fonts.labelSmall)
                                    .foregroundStyle(Theme.Colors.textPrimary)
                                Text(CourseLocalization.CourseContainer.Progress.complete)
                                    .font(Theme.Fonts.labelSmall)
                                    .foregroundColor(Theme.Colors.textPrimary)
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(content: {
            RoundedRectangle(cornerRadius: 4)
                .fill(color.opacity(0.14))
        })
        .accessibilityElement(children: .combine)
        .accessibilityLabel(CourseLocalization.Accessibility.assignmentItem)
        .accessibilityValue(CourseLocalization.Accessibility.assignmentProgressDetails(
            assignmentPolicy.type,
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

    GradeItemCarouselView(
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

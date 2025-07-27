//
//  SegmentedProgressView.swift
//  Course
//
//  Created by Ivan Stepanok on 19.06.2025.
//

import SwiftUI
import Core
import Theme

struct ProgressSegment {
    let progress: Double
    let color: Color
    let weight: Double
    let label: String
}

struct SegmentedProgressView: View {
    
    @Environment(\.colorScheme) var colorScheme
    let segments: [ProgressSegment]
    let totalProgress: Double
    let requiredGrade: Double
    
    init(
        segments: [ProgressSegment],
        totalProgress: Double,
        requiredGrade: Double = 0.0
    ) {
        self.segments = segments
        self.totalProgress = totalProgress
        self.requiredGrade = requiredGrade
    }
    
    var body: some View {
        VStack(spacing: 1) {
            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Theme.Colors.cardViewBackground)
                        .frame(height: 5)
                    
                    // Progress segments
                    HStack(spacing: 0) {
                        ForEach(Array(segments.enumerated()), id: \.offset) { _, segment in
                            let segmentWidth = geometry.size.width * segment.weight * segment.progress
                            
                            if segmentWidth > 0 {
                                Rectangle()
                                    .fill(segment.color)
                                    .frame(width: segmentWidth, height: 5)
                            }
                        }
                        
                        // Only add spacer if total progress is less than 100%
                        if totalProgress < 1.0 {
                            Spacer()
                        }
                    }
                    .mask(
                        RoundedRectangle(cornerRadius: 3)
                            .frame(height: 5)
                    )
                    
                    // Inner border with 10% opacity
                    RoundedRectangle(cornerRadius: 3)
                        .strokeBorder(Theme.Colors.cardViewStroke, lineWidth: colorScheme == .dark ? 0 : 1)
                        .frame(height: 5)
                }
            }
            .frame(height: 5)
            
            // Required grade indicator
            if requiredGrade > 0 {
                GeometryReader { geometry in
                    RequiredGradeIndicator(
                        requiredGrade: requiredGrade,
                        totalWidth: geometry.size.width
                    )
                }
                .frame(height: 30)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(CourseLocalization.Accessibility.progressVisualization("\(segments.count)"))
        .accessibilityValue(CourseLocalization.Accessibility.overallProgressValue("\(Int(totalProgress * 100))"))
        .accessibilityHint(CourseLocalization.Accessibility.progressHint)
        .accessibilityAddTraits(.updatesFrequently)
    }
}

// MARK: - Required Grade Indicator
struct RequiredGradeIndicator: View {
    let requiredGrade: Double
    let totalWidth: CGFloat
    
    var body: some View {
        HStack {
            // Position indicator at the required percentage
            let indicatorPosition = totalWidth * requiredGrade
            let indicatorWidth: CGFloat = 50 // Approximate width of the indicator
            
            Spacer()
                .frame(width: max(0, indicatorPosition - indicatorWidth / 2))
            
            VStack(spacing: 0) {
                // Triangle pointing up
                Triangle()
                    .fill(Theme.Colors.warning)
                    .frame(width: 14, height: 6)
                
                // Rounded indicator with percentage
                Text("\(Int(requiredGrade * 100))%")
                    .font(Theme.Fonts.labelMedium)
                    .foregroundColor(Color.black)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Theme.Colors.warning)
                    )
                    .fixedSize()
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel(CourseLocalization.Accessibility.requiredGradeIndicator)
            .accessibilityValue(CourseLocalization.Accessibility.requiredGradeToPass("\(Int(requiredGrade * 100))"))
            
            Spacer()
        }
    }
}

// MARK: - Triangle Shape
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

// MARK: - Convenience initializer for assignment types
extension SegmentedProgressView {
    init(
        assignmentPolicies: [CourseProgressAssignmentPolicy],
        assignmentProgressData: Binding<[String: AssignmentProgressData]>,
        assignmentColors: [String] = [],
        requiredGrade: Double = 0.0
    ) {
        // Create segments from assignment policies
        var segments: [ProgressSegment] = []
        
        for (index, policy) in assignmentPolicies.enumerated() {
            let progressData = assignmentProgressData.wrappedValue[policy.type] ?? AssignmentProgressData(
                completed: 0,
                total: 0,
                earnedPoints: 0.0,
                possiblePoints: 0.0,
                percentGraded: 0.0
            )
            
            let color: Color
            if !assignmentColors.isEmpty {
                let colorIndex = index % assignmentColors.count
                let hexColor = assignmentColors[colorIndex]
                color = Color(hex: hexColor) ?? Theme.Colors.textSecondary
            } else {
                color = Theme.Colors.textSecondary
            }
            
            let segment = ProgressSegment(
                progress: progressData.pointsPercentage,
                color: color,
                weight: policy.weight,
                label: policy.shortLabel
            )
            segments.append(segment)
        }
        
        // Calculate total progress
        let totalProgress = segments.reduce(0.0) { $0 + ($1.progress * $1.weight) }
        
        self.init(
            segments: segments,
            totalProgress: totalProgress,
            requiredGrade: requiredGrade
        )
    }
}

// MARK: - Preview
#if DEBUG
#Preview {
    VStack(spacing: 20) {
        // Example with manual segments
        
        SegmentedProgressView(
            segments: [
                ProgressSegment(progress: 0.4, color: .red, weight: 0.5, label: "Part 1"),
                ProgressSegment(progress: 0.7, color: .purple, weight: 0.5, label: "Part 2")
            ],
            totalProgress: 0,
            requiredGrade: 0.1
        )
        
        SegmentedProgressView(
            segments: [
                ProgressSegment(progress: 0.8, color: .orange, weight: 0.3, label: "Homework"),
                ProgressSegment(progress: 0.6, color: .green, weight: 0.4, label: "Exams"),
                ProgressSegment(progress: 0.9, color: .blue, weight: 0.3, label: "Quiz")
            ],
            totalProgress: 0.75,
            requiredGrade: 0.5
        )
        
        // Example with different required grade
        SegmentedProgressView(
            segments: [
                ProgressSegment(progress: 0.5, color: .red, weight: 0.5, label: "Part 1"),
                ProgressSegment(progress: 0.3, color: .purple, weight: 0.5, label: "Part 2")
            ],
            totalProgress: 0.4,
            requiredGrade: 0.75
        )
        
        // Example with different required grade
        SegmentedProgressView(
            segments: [
                ProgressSegment(progress: 1, color: .red, weight: 0.5, label: "Part 1"),
                ProgressSegment(progress: 1, color: .purple, weight: 0.5, label: "Part 2")
            ],
            totalProgress: 1,
            requiredGrade: 1
        )
    }
    .padding()
    .background(Theme.Colors.background)
    .loadFonts()
}
#endif

//
//  CourseProgressCircleView.swift
//  Course
//
//  Created by Ivan Stepanok on 19.06.2025.
//

import SwiftUI
import Core
import Theme
import Foundation

struct CourseProgressCircleView: View {
    
    // MARK: - Properties
    let progressPercentage: Double
    let size: CGFloat
    let lineWidth: CGFloat
    
    // MARK: - Init
    init(
        progressPercentage: Double,
        size: CGFloat = 100,
        lineWidth: CGFloat = 10
    ) {
        self.progressPercentage = progressPercentage
        self.size = size
        self.lineWidth = lineWidth
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Circle()
                .stroke(Theme.Colors.circleProgressBG, lineWidth: 1)
                .frame(width: size + lineWidth + 4, height: size + lineWidth + 4)
            
            Circle()
                .stroke(Theme.Colors.circleProgressBG, lineWidth: lineWidth)
                .frame(width: size, height: size)
            
            // Progress circle
            Circle()
                .trim(from: 0, to: progressPercentage)
                .stroke(
                    Theme.Colors.accentColor,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .frame(width: size, height: size)
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 1.0), value: progressPercentage)
            
            // Progress text
            VStack(spacing: 2) {
                Text("\(Int(ceil(progressPercentage * 100)))%")
                    .font(Theme.Fonts.headlineSmall)
                    .foregroundColor(Theme.Colors.progressPercentage)
                
                Text(CourseLocalization.CourseContainer.Progress.completed)
                    .font(Theme.Fonts.labelSmall)
                    .foregroundColor(Theme.Colors.textPrimary)
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(
                CourseLocalization.Accessibility.progressPercentageCompleted("\(Int(ceil(progressPercentage * 100)))")
            )
        }
    }
}

// MARK: - Preview
#if DEBUG
#Preview {
    VStack(spacing: 30) {
        CourseProgressCircleView(progressPercentage: 0.5)
        CourseProgressCircleView(progressPercentage: 0.75)
        CourseProgressCircleView(progressPercentage: 1.0)
    }
    .padding()
    .background(Theme.Colors.background)
    .loadFonts()
}
#endif

//
//  CourseProgressView.swift
//  Course
//
//  Created by  Stepanok Ivan on 23.05.2024.
//

import SwiftUI
import Theme
import Core

public struct CourseProgressView: View {
    private var progress: CourseProgress
    private var showCompletedToggle: Bool
    private var isShowingCompleted: Bool
    private var onToggleCompleted: (() -> Void)?
    private var onShowCompletedAnalytics: (() -> Void)?
    
    public init(
        progress: CourseProgress,
        showCompletedToggle: Bool = false,
        isShowingCompleted: Bool = true,
        onToggleCompleted: (() -> Void)? = nil,
        onShowCompletedAnalytics: (() -> Void)? = nil
    ) {
        self.progress = progress
        self.showCompletedToggle = showCompletedToggle
        self.isShowingCompleted = isShowingCompleted
        self.onToggleCompleted = onToggleCompleted
        self.onShowCompletedAnalytics = onShowCompletedAnalytics
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .leading) {
                GeometryReader { geometry in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Theme.Colors.courseProgressBG)
                        .frame(width: geometry.size.width, height: 4)
                    
                    if let total = progress.totalAssignmentsCount,
                       let completed = progress.assignmentsCompleted {
                        RoundedCorners(tl: 2, tr: 0, bl: 2, br: 0)
                            .fill(Theme.Colors.success)
                            .frame(width: geometry.size.width * CGFloat(completed) / CGFloat(total), height: 4)
                    }
                }
                .frame(height: 4)
            }
            .cornerRadius(2)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(CourseLocalization.Accessibility.courseProgressSection)
            
            HStack {
                if let total = progress.totalAssignmentsCount,
                   let completed = progress.assignmentsCompleted {
                    Text(showCompletedToggle
                         ? CourseLocalization.Course.progressVideosCompleted(completed, total)
                         : CourseLocalization.Course.progressCompleted(completed, total)
                    )
                    .foregroundColor(Theme.Colors.textPrimary)
                    .font(Theme.Fonts.labelMedium)
                    .padding(.top, 5)
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel(
                        CourseLocalization.Accessibility.videoProgressSection(
                            completed,
                            total
                        )
                    )
                }
                
                Spacer()
                
                if showCompletedToggle {
                    Button(action: {
                        onToggleCompleted?()
                        onShowCompletedAnalytics?()
                    }) {
                        HStack(spacing: 2) {
                            Text(
                                isShowingCompleted
                                ? CourseLocalization.Course.progressHideCompleted
                                : CourseLocalization.Course.progressViewCompleted
                            )
                            .font(Theme.Fonts.labelMedium)
                            .foregroundColor(Theme.Colors.accentColor)
                            CoreAssets.chevronRight.swiftUIImage
                                .rotationEffect(
                                    .degrees(isShowingCompleted ? -90 : 90)
                                )
                                .animation(.default, value: isShowingCompleted)
                        }
                    }
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(
                        isShowingCompleted
                        ? CourseLocalization.Accessibility.hideCompletedSections
                        : CourseLocalization.Accessibility.showCompletedSections
                    )
                }
            }
        }
    }
}

struct CourseProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CourseProgressView(progress: CourseProgress(totalAssignmentsCount: 20, assignmentsCompleted: 12))
            .padding()
    }
}

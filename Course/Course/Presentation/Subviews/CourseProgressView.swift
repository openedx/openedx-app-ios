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
    
    public init(progress: CourseProgress) {
        self.progress = progress
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
            
            if let total = progress.totalAssignmentsCount,
                let completed = progress.assignmentsCompleted {
                Text(CourseLocalization.Course.progressCompleted(completed, total))
                    .foregroundColor(Theme.Colors.textPrimary)
                    .font(Theme.Fonts.labelMedium)
                    .padding(.top, 4)
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

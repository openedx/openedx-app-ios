//
//  CourseSubsectionView.swift
//  Course
//
//  Created by Vladimir Chekyrta on 27.03.2023.
//

import SwiftUI
import Core

struct CourseSubsectionView: View {
    
    let subsection: CourseProgress.Subsection
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(subsection.title)
                .foregroundColor(CoreAssets.accentColor.swiftUIColor)
                .font(Theme.Fonts.titleMedium)
                .padding(.vertical, 10)
            
            if subsection.score.isEmpty {
                Text("Without Progress")
                    .foregroundColor(CoreAssets.textPrimary.swiftUIColor)
                    .font(Theme.Fonts.titleMedium)
            } else {
                let score = subsection.score.map {
                    "\($0.earned)/\($0.possible)"
                }.joined(separator: "   ")
                Text("Progress: \(score)")
                    .foregroundColor(CoreAssets.textPrimary.swiftUIColor)
                    .font(Theme.Fonts.titleMedium)
            }
        }
    }
}

struct CourseSubsectionView_Previews: PreviewProvider {
    static var previews: some View {
        CourseSubsectionView(
            subsection: CourseProgress.Subsection(
                earned: "3",
                total: "4",
                percentageString: "75%",
                displayName: "Subsection 1",
                score: [
                    CourseProgress.Score(earned: "1", possible: "1"),
                    CourseProgress.Score(earned: "1", possible: "1"),
                    CourseProgress.Score(earned: "1", possible: "1"),
                    CourseProgress.Score(earned: "0", possible: "1")
                ],
                showGrades: true,
                graded: true,
                gradeType: "Final Exam"
            )
        )
    }
}

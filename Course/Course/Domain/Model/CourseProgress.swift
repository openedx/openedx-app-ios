//
//  CourseProgress.swift
//  Course
//
//  Created by Vladimir Chekyrta on 22.03.2023.
//

import Foundation

public struct CourseProgress {
    let sections: [Section]
    let progress: Int
    
    struct Section {
        let displayName: String
        let subsections: [Subsection]
    }

    struct Subsection {
        let earned: Double
        let total: Double
        let percentageString: String
        let displayName: String
        let score: [Score]
        let showGrades: Bool
        let graded: Bool
        let gradeType: String
    }

    struct Score {
        let earned: Double
        let possible: Double
    }
}

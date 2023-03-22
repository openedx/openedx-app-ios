//
//  Data_ProgressResponse.swift
//  Course
//
//  Created by Vladimir Chekyrta on 22.03.2023.
//

import Foundation
import Core

extension DataLayer {
    struct ProgressResponse: Codable {
        let sections: [Section]?
        
        enum CodingKeys: String, CodingKey {
            case sections
        }
    }
    
    struct Section: Codable {
        let displayName: String?
        let subsections: [Subsection]?
        
        enum CodingKeys: String, CodingKey {
            case displayName = "display_name"
            case subsections
        }
    }
    
    struct Subsection: Codable {
        let earned: Double?
        let total: Double?
        let percentageString: String?
        let displayName: String?
        let score: [Score]?
        let showGrades: Bool?
        let graded: Bool?
        let gradeType: String?
        
        enum CodingKeys: String, CodingKey {
            case earned
            case total
            case percentageString
            case displayName = "display_name"
            case score
            case showGrades = "show_grades"
            case graded
            case gradeType = "grade_type"
        }
    }
    
    struct Score: Codable {
        let earned: Double?
        let possible: Double?
        
        enum CodingKeys: String, CodingKey {
            case earned, possible
        }
    }
}

extension DataLayer.ProgressResponse {
    var domain: CourseProgress {
        let sections = sections?.map { $0.domain } ?? []
        
        var earned: Double = 0
        var total: Double = 0
        for section in sections {
            for subsection in section.subsections where subsection.score.count != 0 {
                earned += subsection.earned
                total += subsection.total
            }
        }
        
        var progress: Double = 0
        if earned > 0 && total > 0 {
            progress = earned / total * 100
        }
        
        return CourseProgress(
            sections: sections,
            progress: Int(progress.rounded())
        )
    }
}

extension DataLayer.Section {
    var domain: CourseProgress.Section {
        CourseProgress.Section(
            displayName: displayName ?? "",
            subsections: subsections?.map { $0.domain } ?? []
        )
    }
}

extension DataLayer.Subsection {
    var domain: CourseProgress.Subsection {
        CourseProgress.Subsection(
            earned: earned ?? 0,
            total: total ?? 0,
            percentageString: percentageString ?? "",
            displayName: displayName ?? "",
            score: score?.map { $0.domain } ?? [],
            showGrades: showGrades ?? false,
            graded: graded ?? false,
            gradeType: gradeType ?? ""
        )
    }
}

extension DataLayer.Score {
    var domain: CourseProgress.Score {
        CourseProgress.Score(earned: earned ?? 0, possible: possible ?? 0)
    }
}

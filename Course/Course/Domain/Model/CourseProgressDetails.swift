//
//  CourseProgressDetails.swift
//  Course
//
//  Created by Ivan Stepanok on 19.06.2025.
//

import Foundation

// MARK: - CourseProgressDetails
public struct CourseProgressDetails: Sendable {
    public let verifiedMode: String?
    public let accessExpiration: String?
    public let certificateData: CourseProgressCertificateData
    public let completionSummary: CourseProgressCompletionSummary
    public let courseGrade: CourseProgressGrade
    public let creditCourseRequirements: String?
    public let end: String?
    public let enrollmentMode: String
    public let gradingPolicy: CourseProgressGradingPolicy
    public let hasScheduledContent: Bool
    public let sectionScores: [CourseProgressSectionScore]
    public let verificationData: CourseProgressVerificationData?
    
    public init(
        verifiedMode: String?,
        accessExpiration: String?,
        certificateData: CourseProgressCertificateData,
        completionSummary: CourseProgressCompletionSummary,
        courseGrade: CourseProgressGrade,
        creditCourseRequirements: String?,
        end: String?,
        enrollmentMode: String,
        gradingPolicy: CourseProgressGradingPolicy,
        hasScheduledContent: Bool,
        sectionScores: [CourseProgressSectionScore],
        verificationData: CourseProgressVerificationData?
    ) {
        self.verifiedMode = verifiedMode
        self.accessExpiration = accessExpiration
        self.certificateData = certificateData
        self.completionSummary = completionSummary
        self.courseGrade = courseGrade
        self.creditCourseRequirements = creditCourseRequirements
        self.end = end
        self.enrollmentMode = enrollmentMode
        self.gradingPolicy = gradingPolicy
        self.hasScheduledContent = hasScheduledContent
        self.sectionScores = sectionScores
        self.verificationData = verificationData
    }
    
    public func getAssignmentProgress(for assignmentType: String) -> AssignmentProgressData {
        guard let policy = self.gradingPolicy.assignmentPolicies
            .first(where: { $0.type == assignmentType }) else {
            return AssignmentProgressData(
                completed: 0,
                total: 0,
                earnedPoints: 0.0,
                possiblePoints: 0.0,
                percentGraded: 0.0
            )
        }
        
        let assignments = self.sectionScores.flatMap { $0.subsections }
            .filter { $0.assignmentType == assignmentType && $0.hasGradedAssignment }
        
        // Calculate completed and total based on problem scores
        var completedProblems = 0
        var totalProblems = 0
        
        for assignment in assignments {
            // Count problems in this assignment
            totalProblems += assignment.problemScores.count
            
            // Count completed problems (where earned > 0)
            completedProblems += assignment.problemScores.filter { $0.earned > 0 }.count
        }
        
        // If no problem scores available, fall back to subsection-based counting
        if totalProblems == 0 {
            completedProblems = assignments.filter { $0.numPointsEarned > 0 }.count
            totalProblems = assignments.count > 0 ? policy.numTotal : 0
        }
        
        let earnedPoints = assignments.reduce(0.0) { $0 + $1.numPointsEarned }
        let possiblePoints = assignments.reduce(0.0) { $0 + $1.numPointsPossible }
        
        // Calculate average percent_graded for this assignment type (from server data)
        let totalPercentGraded = assignments.reduce(0.0) { $0 + $1.percentGraded }
        let averagePercentGraded = assignments.isEmpty ? 0.0 : totalPercentGraded / Double(assignments.count)
        
        return AssignmentProgressData(
            completed: completedProblems,
            total: totalProblems,
            earnedPoints: earnedPoints,
            possiblePoints: possiblePoints,
            percentGraded: averagePercentGraded
        )
    }
}

// MARK: - AssignmentProgressData
public struct AssignmentProgressData {
    public let completed: Int
    public let total: Int
    public let earnedPoints: Double
    public let possiblePoints: Double
    public let percentGraded: Double
    
    public init(completed: Int, total: Int, earnedPoints: Double, possiblePoints: Double, percentGraded: Double = 0.0) {
        self.completed = completed
        self.total = total
        self.earnedPoints = earnedPoints
        self.possiblePoints = possiblePoints
        self.percentGraded = percentGraded
    }
    
    public var completionPercentage: Double {
        guard total > 0 else { return 0.0 }
        return Double(completed) / Double(total)
    }
    
    public var pointsPercentage: Double {
        guard possiblePoints > 0 else { return 0.0 }
        return earnedPoints / possiblePoints
    }
}

public struct CourseProgressCertificateData: Sendable {
    public let certStatus: String?
    public let certWebViewUrl: String?
    public let downloadUrl: String?
    public let certificateAvailableDate: String?
    
    public init(
        certStatus: String?,
        certWebViewUrl: String?,
        downloadUrl: String?,
        certificateAvailableDate: String?
    ) {
        self.certStatus = certStatus
        self.certWebViewUrl = certWebViewUrl
        self.downloadUrl = downloadUrl
        self.certificateAvailableDate = certificateAvailableDate
    }
}

public struct CourseProgressCompletionSummary: Sendable {
    public let completeCount: Int
    public let incompleteCount: Int
    public let lockedCount: Int
    
    public var totalCount: Int {
        completeCount + incompleteCount + lockedCount
    }
    
    public var completionPercentage: Double {
        guard totalCount > 0 else { return 0.0 }
        return Double(completeCount) / Double(totalCount)
    }
    
    public init(completeCount: Int, incompleteCount: Int, lockedCount: Int) {
        self.completeCount = completeCount
        self.incompleteCount = incompleteCount
        self.lockedCount = lockedCount
    }
}

public struct CourseProgressGrade: Sendable {
    public let letterGrade: String?
    public let percent: Double
    public let isPassing: Bool
    
    public init(letterGrade: String?, percent: Double, isPassing: Bool) {
        self.letterGrade = letterGrade
        self.percent = percent
        self.isPassing = isPassing
    }
}

public struct CourseProgressGradingPolicy: Sendable {
    public let assignmentPolicies: [CourseProgressAssignmentPolicy]
    public let gradeRange: [String: Double]
    public let assignmentColors: [String]
    
    public init(
        assignmentPolicies: [CourseProgressAssignmentPolicy],
        gradeRange: [String: Double],
        assignmentColors: [String]
    ) {
        self.assignmentPolicies = assignmentPolicies
        self.gradeRange = gradeRange
        self.assignmentColors = assignmentColors
    }
}

public struct CourseProgressAssignmentPolicy: Sendable {
    public let numDroppable: Int
    public let numTotal: Int
    public let shortLabel: String
    public let type: String
    public let weight: Double
    
    public init(numDroppable: Int, numTotal: Int, shortLabel: String, type: String, weight: Double) {
        self.numDroppable = numDroppable
        self.numTotal = numTotal
        self.shortLabel = shortLabel
        self.type = type
        self.weight = weight
    }
}

public struct CourseProgressSectionScore: Sendable {
    public let displayName: String
    public let subsections: [CourseProgressSubsection]
    
    public var totalPointsEarned: Double {
        subsections.reduce(0) { $0 + $1.numPointsEarned }
    }
    
    public var totalPointsPossible: Double {
        subsections.reduce(0) { $0 + $1.numPointsPossible }
    }
    
    public var sectionProgress: Double {
        guard totalPointsPossible > 0 else { return 0.0 }
        return totalPointsEarned / totalPointsPossible
    }
    
    public init(displayName: String, subsections: [CourseProgressSubsection]) {
        self.displayName = displayName
        self.subsections = subsections
    }
}

public struct CourseProgressSubsection: Sendable {
    public let assignmentType: String?
    public let blockKey: String
    public let displayName: String
    public let hasGradedAssignment: Bool
    public let override: String?
    public let learnerHasAccess: Bool
    public let numPointsEarned: Double
    public let numPointsPossible: Double
    public let percentGraded: Double
    public let problemScores: [CourseProgressProblemScore]
    public let showCorrectness: String
    public let showGrades: Bool
    public let url: String
    
    public var progress: Double {
        guard numPointsPossible > 0 else { return 0.0 }
        return numPointsEarned / numPointsPossible
    }
    
    public init(
        assignmentType: String?,
        blockKey: String,
        displayName: String,
        hasGradedAssignment: Bool,
        override: String?,
        learnerHasAccess: Bool,
        numPointsEarned: Double,
        numPointsPossible: Double,
        percentGraded: Double,
        problemScores: [CourseProgressProblemScore],
        showCorrectness: String,
        showGrades: Bool,
        url: String
    ) {
        self.assignmentType = assignmentType
        self.blockKey = blockKey
        self.displayName = displayName
        self.hasGradedAssignment = hasGradedAssignment
        self.override = override
        self.learnerHasAccess = learnerHasAccess
        self.numPointsEarned = numPointsEarned
        self.numPointsPossible = numPointsPossible
        self.percentGraded = percentGraded
        self.problemScores = problemScores
        self.showCorrectness = showCorrectness
        self.showGrades = showGrades
        self.url = url
    }
}

public struct CourseProgressProblemScore: Sendable {
    public let earned: Double
    public let possible: Double
    
    public var progress: Double {
        guard possible > 0 else { return 0.0 }
        return earned / possible
    }
    
    public init(earned: Double, possible: Double) {
        self.earned = earned
        self.possible = possible
    }
}

public struct CourseProgressVerificationData: Sendable {
    public let link: String?
    public let status: String
    public let statusDate: String?
    
    public init(link: String?, status: String, statusDate: String?) {
        self.link = link
        self.status = status
        self.statusDate = statusDate
    }
}

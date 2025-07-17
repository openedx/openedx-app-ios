//
//  Data_CourseProgressResponse.swift
//  Course
//
//  Created by Ivan Stepanok on 19.06.2025.
//

import Foundation
import Core

public extension DataLayer {
    
    struct CourseProgressResponse: Codable, Sendable {
        public let verifiedMode: String?
        public let accessExpiration: String?
        public let certificateData: CertificateData
        public let completionSummary: CompletionSummary
        public let courseGrade: CourseGrade
        public let creditCourseRequirements: String?
        public let end: String?
        public let enrollmentMode: String
        public let gradingPolicy: GradingPolicy
        public let hasScheduledContent: Bool?
        public let sectionScores: [SectionScore]
        public let studioUrl: String
        public let username: String
        public let userHasPassingGrade: Bool
        public let verificationData: VerificationData
        public let disableProgressGraph: Bool
        public let assignmentColors: [String]?
        
        enum CodingKeys: String, CodingKey {
            case verifiedMode = "verified_mode"
            case accessExpiration = "access_expiration"
            case certificateData = "certificate_data"
            case completionSummary = "completion_summary"
            case courseGrade = "course_grade"
            case creditCourseRequirements = "credit_course_requirements"
            case end
            case enrollmentMode = "enrollment_mode"
            case gradingPolicy = "grading_policy"
            case hasScheduledContent = "has_scheduled_content"
            case sectionScores = "section_scores"
            case studioUrl = "studio_url"
            case username
            case userHasPassingGrade = "user_has_passing_grade"
            case verificationData = "verification_data"
            case disableProgressGraph = "disable_progress_graph"
            case assignmentColors = "assignment_colors"
        }
        
        public init(
            verifiedMode: String?,
            accessExpiration: String?,
            certificateData: CertificateData,
            completionSummary: CompletionSummary,
            courseGrade: CourseGrade,
            creditCourseRequirements: String?,
            end: String?,
            enrollmentMode: String,
            gradingPolicy: GradingPolicy,
            hasScheduledContent: Bool?,
            sectionScores: [SectionScore],
            studioUrl: String,
            username: String,
            userHasPassingGrade: Bool,
            verificationData: VerificationData,
            disableProgressGraph: Bool,
            assignmentColors: [String]?
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
            self.studioUrl = studioUrl
            self.username = username
            self.userHasPassingGrade = userHasPassingGrade
            self.verificationData = verificationData
            self.disableProgressGraph = disableProgressGraph
            self.assignmentColors = assignmentColors
        }
    }
    
    struct CertificateData: Codable, Sendable {
        public let certStatus: String?
        public let certWebViewUrl: String?
        public let downloadUrl: String?
        public let certificateAvailableDate: String?
        
        enum CodingKeys: String, CodingKey {
            case certStatus = "cert_status"
            case certWebViewUrl = "cert_web_view_url"
            case downloadUrl = "download_url"
            case certificateAvailableDate = "certificate_available_date"
        }
        
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
    
    struct CompletionSummary: Codable, Sendable {
        public let completeCount: Int
        public let incompleteCount: Int
        public let lockedCount: Int
        
        enum CodingKeys: String, CodingKey {
            case completeCount = "complete_count"
            case incompleteCount = "incomplete_count"
            case lockedCount = "locked_count"
        }
        
        public init(completeCount: Int, incompleteCount: Int, lockedCount: Int) {
            self.completeCount = completeCount
            self.incompleteCount = incompleteCount
            self.lockedCount = lockedCount
        }
    }
    
    struct CourseGrade: Codable, Sendable {
        public let letterGrade: String?
        public let percent: Double
        public let isPassing: Bool
        
        enum CodingKeys: String, CodingKey {
            case letterGrade = "letter_grade"
            case percent
            case isPassing = "is_passing"
        }
        
        public init(letterGrade: String?, percent: Double, isPassing: Bool) {
            self.letterGrade = letterGrade
            self.percent = percent
            self.isPassing = isPassing
        }
    }
    
    struct GradingPolicy: Codable, Sendable {
        public let assignmentPolicies: [AssignmentPolicy]
        public let gradeRange: [String: Double]
        
        enum CodingKeys: String, CodingKey {
            case assignmentPolicies = "assignment_policies"
            case gradeRange = "grade_range"
        }
        
        public init(assignmentPolicies: [AssignmentPolicy], gradeRange: [String: Double]) {
            self.assignmentPolicies = assignmentPolicies
            self.gradeRange = gradeRange
        }
    }
    
    struct AssignmentPolicy: Codable, Sendable {
        public let numDroppable: Int
        public let numTotal: Int
        public let shortLabel: String
        public let type: String
        public let weight: Double
        
        enum CodingKeys: String, CodingKey {
            case numDroppable = "num_droppable"
            case numTotal = "num_total"
            case shortLabel = "short_label"
            case type
            case weight
        }
        
        public init(numDroppable: Int, numTotal: Int, shortLabel: String, type: String, weight: Double) {
            self.numDroppable = numDroppable
            self.numTotal = numTotal
            self.shortLabel = shortLabel
            self.type = type
            self.weight = weight
        }
    }
    
    struct SectionScore: Codable, Sendable {
        public let displayName: String
        public let subsections: [Subsection]
        
        enum CodingKeys: String, CodingKey {
            case displayName = "display_name"
            case subsections
        }
        
        public init(displayName: String, subsections: [Subsection]) {
            self.displayName = displayName
            self.subsections = subsections
        }
    }
    
    struct Subsection: Codable, Sendable {
        public let assignmentType: String?
        public let blockKey: String
        public let displayName: String
        public let hasGradedAssignment: Bool
        public let override: String?
        public let learnerHasAccess: Bool
        public let numPointsEarned: Double
        public let numPointsPossible: Double
        public let percentGraded: Double
        public let problemScores: [ProblemScore]
        public let showCorrectness: String
        public let showGrades: Bool
        public let url: String
        
        enum CodingKeys: String, CodingKey {
            case assignmentType = "assignment_type"
            case blockKey = "block_key"
            case displayName = "display_name"
            case hasGradedAssignment = "has_graded_assignment"
            case override
            case learnerHasAccess = "learner_has_access"
            case numPointsEarned = "num_points_earned"
            case numPointsPossible = "num_points_possible"
            case percentGraded = "percent_graded"
            case problemScores = "problem_scores"
            case showCorrectness = "show_correctness"
            case showGrades = "show_grades"
            case url
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
            problemScores: [ProblemScore],
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
    
    struct ProblemScore: Codable, Sendable {
        public let earned: Double
        public let possible: Double
        
        public init(earned: Double, possible: Double) {
            self.earned = earned
            self.possible = possible
        }
    }
    
    struct VerificationData: Codable, Sendable {
        public let link: String?
        public let status: String
        public let statusDate: String?
        
        enum CodingKeys: String, CodingKey {
            case link
            case status
            case statusDate = "status_date"
        }
        
        public init(link: String?, status: String, statusDate: String?) {
            self.link = link
            self.status = status
            self.statusDate = statusDate
        }
    }
}

public extension DataLayer.CourseProgressResponse {
    func domain() -> CourseProgressDetails {
        CourseProgressDetails(
            verifiedMode: verifiedMode,
            accessExpiration: accessExpiration,
            certificateData: certificateData.domain,
            completionSummary: completionSummary.domain,
            courseGrade: courseGrade.domain,
            creditCourseRequirements: creditCourseRequirements,
            end: end,
            enrollmentMode: enrollmentMode,
            gradingPolicy: gradingPolicy.domain,
            hasScheduledContent: hasScheduledContent ?? false,
            sectionScores: sectionScores.map { $0.domain },
            verificationData: verificationData.domain,
            assignmentColors: assignmentColors ?? []
        )
    }
}

public extension DataLayer.CertificateData {
    var domain: CourseProgressCertificateData {
        CourseProgressCertificateData(
            certStatus: certStatus,
            certWebViewUrl: certWebViewUrl,
            downloadUrl: downloadUrl,
            certificateAvailableDate: certificateAvailableDate
        )
    }
}

public extension DataLayer.CompletionSummary {
    var domain: CourseProgressCompletionSummary {
        CourseProgressCompletionSummary(
            completeCount: completeCount,
            incompleteCount: incompleteCount,
            lockedCount: lockedCount
        )
    }
}

public extension DataLayer.CourseGrade {
    var domain: CourseProgressGrade {
        CourseProgressGrade(
            letterGrade: letterGrade,
            percent: percent,
            isPassing: isPassing
        )
    }
}

public extension DataLayer.GradingPolicy {
    var domain: CourseProgressGradingPolicy {
        CourseProgressGradingPolicy(
            assignmentPolicies: assignmentPolicies.map { $0.domain },
            gradeRange: gradeRange
        )
    }
}

public extension DataLayer.AssignmentPolicy {
    var domain: CourseProgressAssignmentPolicy {
        CourseProgressAssignmentPolicy(
            numDroppable: numDroppable,
            numTotal: numTotal,
            shortLabel: shortLabel,
            type: type,
            weight: weight
        )
    }
}

public extension DataLayer.SectionScore {
    var domain: CourseProgressSectionScore {
        CourseProgressSectionScore(
            displayName: displayName,
            subsections: subsections.map { $0.domain }
        )
    }
}

public extension DataLayer.Subsection {
    var domain: CourseProgressSubsection {
        CourseProgressSubsection(
            assignmentType: assignmentType,
            blockKey: blockKey,
            displayName: displayName,
            hasGradedAssignment: hasGradedAssignment,
            override: override,
            learnerHasAccess: learnerHasAccess,
            numPointsEarned: numPointsEarned,
            numPointsPossible: numPointsPossible,
            percentGraded: percentGraded,
            problemScores: problemScores.map { $0.domain },
            showCorrectness: showCorrectness,
            showGrades: showGrades,
            url: url
        )
    }
}

public extension DataLayer.ProblemScore {
    var domain: CourseProgressProblemScore {
        CourseProgressProblemScore(
            earned: earned,
            possible: possible
        )
    }
}

public extension DataLayer.VerificationData {
    var domain: CourseProgressVerificationData {
        CourseProgressVerificationData(
            link: link,
            status: status,
            statusDate: statusDate
        )
    }
}

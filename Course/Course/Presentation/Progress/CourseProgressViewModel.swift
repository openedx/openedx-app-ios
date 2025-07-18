//
//  CourseProgressViewModel.swift
//  Course
//
//  Created by Ivan Stepanok on 19.06.2025.
//

import SwiftUI
import Core
import Foundation
import Theme

@MainActor
public class CourseProgressViewModel: ObservableObject {
    
    @Published var courseProgress: CourseProgressDetails?
    @Published var isLoading: Bool = false
    @Published var isShowRefresh = false
    @Published var showError: Bool = false
    
    let router: CourseRouter
    let analytics: CourseAnalytics
    let connectivity: ConnectivityProtocol
    let interactor: CourseInteractorProtocol
    
    public var errorMessage: String? {
        didSet {
            withAnimation {
                showError = errorMessage != nil
            }
        }
    }
    
    public init(
        interactor: CourseInteractorProtocol,
        router: CourseRouter,
        analytics: CourseAnalytics,
        connectivity: ConnectivityProtocol
    ) {
        self.interactor = interactor
        self.router = router
        self.analytics = analytics
        self.connectivity = connectivity
    }
    
    public func getCourseProgress(courseID: String, withProgress: Bool = true) async {
        isLoading = withProgress
        isShowRefresh = !withProgress
        do {
            if connectivity.isInternetAvaliable {
                courseProgress = try await interactor.getCourseProgress(courseID: courseID)
            } else {
                courseProgress = try await interactor.getCourseProgressOffline(courseID: courseID)
            }
            isLoading = false
            isShowRefresh = false
        } catch let error {
            if error.isInternetError || error is NoCachedDataError {
                errorMessage = CoreLocalization.Error.slowOrNoInternetConnection
            } else {
                errorMessage = CoreLocalization.Error.unknownError
            }
            isLoading = false
            isShowRefresh = false
        }
    }
    
    public func trackProgressTabClicked(courseId: String, courseName: String) {
        analytics.courseOutlineProgressTabClicked(courseId: courseId, courseName: courseName)
    }
    
    public var isProgressEmpty: Bool {
        guard let progress = courseProgress else { return true }
        return progress.sectionScores.isEmpty &&
               progress.completionSummary.completeCount == 0 &&
               progress.completionSummary.incompleteCount == 0
    }
    
    public var hasGradedAssignments: Bool {
        guard let progress = courseProgress else { return false }
        
        // Check if there are any graded sections
        let hasGradedSections = progress.sectionScores.contains { section in
            section.subsections.contains { $0.hasGradedAssignment }
        }
        
        // Check if there are any assignment policies
        let hasAssignmentPolicies = !progress.gradingPolicy.assignmentPolicies.isEmpty
        
        return hasGradedSections && hasAssignmentPolicies
    }
    
    public var overallProgressPercentage: Double {
        guard let progress = courseProgress else { return 0.0 }
        return progress.completionSummary.completionPercentage
    }
    
    public var gradePercentage: Double {
        courseProgress?.courseGrade.percent ?? 0.0
    }
    
    public var isPassing: Bool {
        courseProgress?.courseGrade.isPassing ?? false
    }
    
    public var hasCertificate: Bool {
        guard let certStatus = courseProgress?.certificateData.certStatus else { return false }
        return certStatus.contains("passing") || certStatus.contains("downloadable")
    }
    
    public var certificateUrl: String? {
        courseProgress?.certificateData.downloadUrl
    }
    
    public var requiredGradePercentage: Double {
        guard let gradeRange = courseProgress?.gradingPolicy.gradeRange,
              let passGrade = gradeRange["Pass"] else { return 0.0 }
        return passGrade
    }
    
    public var assignmentPolicies: [CourseProgressAssignmentPolicy] {
        courseProgress?.gradingPolicy.assignmentPolicies ?? []
    }
    
    public func getAssignmentProgress(for assignmentType: String) -> AssignmentProgressData {
        guard let courseProgress = courseProgress else {
            return AssignmentProgressData(
                completed: 0,
                total: 0,
                earnedPoints: 0.0,
                possiblePoints: 0.0,
                percentGraded: 0.0
            )
        }
        
        return courseProgress.getAssignmentProgress(for: assignmentType)
    }
    
    public func getAssignmentColor(for index: Int) -> Color {
        guard let courseProgress = courseProgress else {
            return Theme.Colors.textSecondary
        }
        
        if courseProgress.gradingPolicy.assignmentColors.isEmpty {
            return Theme.Colors.accentColor
        }
        
        let colorIndex = index % courseProgress.gradingPolicy.assignmentColors.count
        let hexColor = courseProgress.gradingPolicy.assignmentColors[colorIndex]
        
        return Color(hex: hexColor) ?? Theme.Colors.textSecondary
    }
    
    public func getAllAssignmentProgressData() -> [String: AssignmentProgressData] {
        guard let courseProgress = courseProgress else { return [:] }
        
        var progressData: [String: AssignmentProgressData] = [:]
        
        for policy in courseProgress.gradingPolicy.assignmentPolicies {
            let data = getAssignmentProgress(for: policy.type)
            progressData[policy.type] = data
        }
        
        return progressData
    }
}

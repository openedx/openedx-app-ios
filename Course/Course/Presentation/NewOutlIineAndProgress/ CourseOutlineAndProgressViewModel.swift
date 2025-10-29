import SwiftUI
import Core
import Foundation
import Theme
import OEXFoundation
import Combine

@MainActor
public class CourseOutlineAndProgressViewModel: ObservableObject {
    
    // MARK: - Variables
    @Published public var courseProgress: CourseProgressDetails?
    @Published public var showError: Bool = false
    @Published public var selection: Int
    @Published var userSettings: UserSettings?
    @Published var isInternetAvaliable: Bool = true

    let router: CourseRouter
    let analytics: CourseAnalytics
    let connectivity: ConnectivityProtocol
    let interactor: CourseInteractorProtocol
    let config: ConfigProtocol
    
    let isActive: Bool?
    let courseStart: Date?
    let courseEnd: Date?
    let enrollmentStart: Date?
    let enrollmentEnd: Date?
    let lastVisitedBlockID: String?
    
    var courseDownloadTasks: [DownloadDataTask] = []
    private(set) var waitingDownloads: [CourseBlock]?
    
    private let authInteractor: AuthInteractorProtocol
    private(set) var storage: CourseStorage
    
    private let cellularFileSizeLimit: Int = 100 * 1024 * 1024
    var courseHelper: CourseDownloadHelperProtocol
    
    public var errorMessage: String? {
        didSet {
            withAnimation {
                showError = errorMessage != nil
            }
        }
    }
    
    // MARK: - Init
    public init(
        interactor: CourseInteractorProtocol,
        router: CourseRouter,
        analytics: CourseAnalytics,
        connectivity: ConnectivityProtocol,
        authInteractor: AuthInteractorProtocol,
        config: ConfigProtocol,
        manager: DownloadManagerProtocol,
        storage: CourseStorage,
        isActive: Bool?,
        courseStart: Date?,
        courseEnd: Date?,
        enrollmentStart: Date?,
        enrollmentEnd: Date?,
        lastVisitedBlockID: String?,
        coreAnalytics: CoreAnalytics,
        selection: CourseTab = CourseTab.course,
        courseHelper: CourseDownloadHelperProtocol
    ) {
        self.interactor = interactor
        self.router = router
        self.analytics = analytics
        self.connectivity = connectivity
        self.authInteractor = authInteractor
        self.config = config
        self.isActive = isActive
        self.courseStart = courseStart
        self.courseEnd = courseEnd
        self.enrollmentStart = enrollmentStart
        self.enrollmentEnd = enrollmentEnd
        self.storage = storage
        self.userSettings = storage.userSettings
        self.isInternetAvaliable = connectivity.isInternetAvaliable
        self.lastVisitedBlockID = lastVisitedBlockID
        self.selection = selection.rawValue
        self.courseHelper = courseHelper
        self.courseHelper.videoQuality = storage.userSettings?.downloadQuality ?? .auto
    }
    
    @MainActor
    public func getCourseProgress(courseID: String, withProgress: Bool = true) async {
        do {
            if connectivity.isInternetAvaliable {
                courseProgress = try await interactor.getCourseProgress(courseID: courseID)
            } else {
                courseProgress = try await interactor.getCourseProgressOffline(courseID: courseID)
            }
        } catch let error {
            if error.isInternetError || error is NoCachedDataError {
                errorMessage = CoreLocalization.Error.slowOrNoInternetConnection
            } else {
                errorMessage = CoreLocalization.Error.unknownError
            }
        }
    }
    
    public func trackProgressTabClicked(courseId: String, courseName: String) {
        analytics.courseOutlineProgressTabClicked(courseId: courseId, courseName: courseName)
    }
    
    public func refreshProgress(courseID: String) async {
        await getCourseProgress(courseID: courseID)
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
        
        guard let policy = courseProgress.gradingPolicy.assignmentPolicies
            .first(where: { $0.type == assignmentType }) else {
            return AssignmentProgressData(
                completed: 0,
                total: 0,
                earnedPoints: 0.0,
                possiblePoints: 0.0,
                percentGraded: 0.0
            )
        }
        
        let assignments = courseProgress.sectionScores.flatMap { $0.subsections }
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
            totalProblems = policy.numTotal
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

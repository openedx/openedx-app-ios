//
//  CourseProgressScreenView.swift
//  Course
//
//  Created by Ivan Stepanok on 19.06.2025.
//

import SwiftUI
import Core
import Theme
import Foundation

struct CourseProgressScreenView: View {
    
    private let courseID: String
    @Binding private var coordinate: CGFloat
    @Binding private var collapsed: Bool
    @Binding private var viewHeight: CGFloat
    
    @StateObject
    private var viewModel: CourseProgressViewModel
    
    private let connectivity: ConnectivityProtocol
    
    public init(
        courseID: String,
        coordinate: Binding<CGFloat>,
        collapsed: Binding<Bool>,
        viewHeight: Binding<CGFloat>,
        viewModel: CourseProgressViewModel,
        connectivity: ConnectivityProtocol
    ) {
        self.courseID = courseID
        self._coordinate = coordinate
        self._collapsed = collapsed
        self._viewHeight = viewHeight
        self._viewModel = StateObject(wrappedValue: { viewModel }())
        self.connectivity = connectivity
    }
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .center) {
                VStack(alignment: .center) {
                    
                    // MARK: - Page Body
                    if viewModel.isLoading {
                        HStack(alignment: .center) {
                            ProgressBar(size: 40, lineWidth: 8)
                                .padding(.top, 200)
                                .padding(.horizontal)
                        }
                    } else {
                        ScrollView {
                            VStack(alignment: .center, spacing: 20) {
                                DynamicOffsetView(
                                    coordinate: $coordinate,
                                    collapsed: $collapsed,
                                    viewHeight: $viewHeight
                                )
                                RefreshProgressView(isShowRefresh: $viewModel.isShowRefresh)
                                
                                courseProgressContent
                                
                                Spacer(minLength: 84)
                            }
                            .padding(.horizontal, 24)
                        }
                        .refreshable {
                            Task {
                                await viewModel.getCourseProgress(courseID: courseID, withProgress: false)
                            }
                        }
                    }
                }
                .accessibilityElement(children: .contain)
                .frameLimit(width: proxy.size.width)
                
                // MARK: - Offline mode SnackBar
                OfflineSnackBarView(
                    connectivity: connectivity,
                    reloadAction: {
                        Task {
                            await viewModel.getCourseProgress(courseID: courseID)
                        }
                    }
                )
                
                // MARK: - Error Alert
                if viewModel.showError {
                    VStack {
                        Spacer()
                        SnackBarView(message: viewModel.errorMessage)
                    }
                    .padding(.bottom, connectivity.isInternetAvaliable
                             ? 0 : OfflineSnackBarView.height)
                    .transition(.move(edge: .bottom))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(
                            deadline: .now() + Theme.Timeout.snackbarMessageLongTimeout
                        ) {
                            viewModel.errorMessage = nil
                        }
                    }
                }
            }
            .background(
                Theme.Colors.background
                    .ignoresSafeArea()
            )
            .onFirstAppear {
                Task {
                    await viewModel.getCourseProgress(courseID: courseID)
                }
            }
        }
    }
    
    @ViewBuilder
    private var courseProgressContent: some View {
        VStack(alignment: .leading, spacing: 32) {
            if viewModel.courseProgress != nil {
                // Course Completion Header Section
                VStack(alignment: .leading, spacing: 16) {
                    HStack(alignment: .top, spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(CourseLocalization.CourseContainer.Progress.title)
                                .font(Theme.Fonts.titleMedium)
                                .foregroundColor(Theme.Colors.textPrimary)
                                .accessibilityAddTraits(.isHeader)
                            
                            Text(CourseLocalization.CourseContainer.Progress.description)
                                .font(Theme.Fonts.bodySmall)
                                .foregroundColor(Theme.Colors.textPrimary)
                                .lineLimit(nil)
                        }
                        .accessibilityElement(children: .combine)
                        
                        Spacer()
                        
                        // Circular Progress
                        CourseProgressCircleView(
                            progressPercentage: viewModel.overallProgressPercentage
                        )
                        .accessibilityLabel(CourseLocalization.Accessibility.progressRing)
                        .accessibilityValue(
                            CourseLocalization.Accessibility.progressPercentageCompleted(
                                "\(Int(ceil(viewModel.overallProgressPercentage * 100)))"
                            )
                        )
                        .accessibilityAddTraits(.updatesFrequently)
                    }
                }
                .padding(.top, 16)
                
                // Check if course has graded assignments
                if viewModel.hasGradedAssignments {
                    // Overall Grade Section
                    OverallGradeView(
                        currentGrade: viewModel.gradePercentage,
                        requiredGrade: viewModel.requiredGradePercentage,
                        assignmentPolicies: viewModel.assignmentPolicies,
                        assignmentProgressData: $viewModel.assignmentProgressData,
                        assignmentColors: viewModel.courseProgress?.gradingPolicy.assignmentColors ?? []
                    )
                    .accessibilityElement(children: .contain)
                    .accessibilityLabel(CourseLocalization.Accessibility.overallGradeSection)
                    
                    // Grade Details Section
                    GradeDetailsView(
                        assignmentPolicies: viewModel.assignmentPolicies,
                        assignmentProgressData: $viewModel.assignmentProgressData,
                        currentGrade: viewModel.gradePercentage,
                        getAssignmentColor: viewModel.getAssignmentColor
                    )
                        .accessibilityElement(children: .contain)
                        .accessibilityLabel(CourseLocalization.Accessibility.gradeDetailsSection)
                } else {
                    // No graded assignments message
                    VStack(spacing: 16) {
                        Image(systemName: "doc.text")
                            .font(.system(size: 48))
                            .foregroundColor(Theme.Colors.textSecondary)
                        
                        Text(CourseLocalization.CourseContainer.Progress.noGradedAssignments)
                            .font(Theme.Fonts.titleMedium)
                            .foregroundColor(Theme.Colors.textPrimary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(32)
                    .frame(maxWidth: .infinity)
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel(CourseLocalization.CourseContainer.Progress.noGradedAssignments)
                    .accessibilityHint(CourseLocalization.Accessibility.noGradedAssignmentsHint)
                }
                
            } else if viewModel.isProgressEmpty {
                // Empty state
                VStack(spacing: 16) {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.system(size: 48))
                        .foregroundColor(Theme.Colors.textSecondary)
                    
                    Text(CourseLocalization.CourseContainer.Progress.noProgressAvailable)
                        .font(Theme.Fonts.titleMedium)
                        .foregroundColor(Theme.Colors.textPrimary)
                        .multilineTextAlignment(.center)
                    
                    Text(CourseLocalization.CourseContainer.Progress.startLearning)
                        .font(Theme.Fonts.bodyMedium)
                        .foregroundColor(Theme.Colors.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .padding(32)
                .frame(maxWidth: .infinity)
                .accessibilityElement(children: .combine)
                .accessibilityLabel(CourseLocalization.CourseContainer.Progress.noProgressAvailable)
                .accessibilityHint(CourseLocalization.Accessibility.noProgressHint)
            }
        }
    }
}

#if DEBUG
#Preview {
    let vm = CourseProgressViewModel(
        interactor: CourseInteractor.mock,
        router: CourseRouterMock(),
        analytics: CourseAnalyticsMock(),
        connectivity: Connectivity()
    )
    
    CourseProgressScreenView(
        courseID: "test",
        coordinate: .constant(0),
        collapsed: .constant(false),
        viewHeight: .constant(0),
        viewModel: vm,
        connectivity: Connectivity()
    )
    .loadFonts()
}
#endif

//
//  AssignmentsContentView.swift
//  Course
//
//  Created by Ivan Stepanok on 08.07.2025.
//

import SwiftUI
import Core
import OEXFoundation
import Kingfisher
import Theme

struct AssignmentsContentView: View {
    
    @StateObject private var viewModel: CourseContainerViewModel
    private let title: String
    private let courseID: String
    private let dateTabIndex: Int
    
    private let proxy: GeometryProxy
    @State private var isShowingCompletedAssignments: Bool = false
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    
    private var isLandscape: Bool {
        horizontalSizeClass == .regular && verticalSizeClass == .compact
    }
    
    private var isTablet: Bool {
        horizontalSizeClass == .regular && verticalSizeClass == .regular
    }
    
    private var assignmentSections: [AssignmentSectionUI] {
        viewModel.assignmentSections().map { section in
            AssignmentSectionUI(
                key: section.label,
                subsections: section.subsections,
                weight: section.weight
            )
        }
    }
    
    private func sectionProgress(_ subsections: [CourseProgressSubsection]) -> Double {
        guard !subsections.isEmpty else { return 0.0 }
        let completed = subsections.filter { $0.status == .completed }.count
        return Double(completed) / Double(subsections.count)
    }
    
    private func sectionProgressText(_ subsections: [CourseProgressSubsection]) -> String {
        let completed = subsections.filter { $0.status == .completed }.count
        return "\(completed)/\(subsections.count) Completed"
    }
    
    init(
        viewModel: CourseContainerViewModel,
        proxy: GeometryProxy,
        title: String,
        courseID: String,
        dateTabIndex: Int
    ) {
        self.title = title
        self._viewModel = StateObject(wrappedValue: { viewModel }())
        self.proxy = proxy
        self.courseID = courseID
        self.dateTabIndex = dateTabIndex
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Error View
            if viewModel.showError {
                VStack {
                    SnackBarView(message: viewModel.errorMessage)
                }
                .transition(.move(edge: .bottom))
                .onAppear {
                    doAfter(Theme.Timeout.snackbarMessageLongTimeout) {
                        viewModel.errorMessage = nil
                    }
                }
            }
            
            ZStack(alignment: .center) {
                // MARK: - Page Body
                if viewModel.isShowProgress && !viewModel.isShowRefresh {
                    HStack(alignment: .center) {
                        ProgressBar(size: 40, lineWidth: 8)
                            .padding(.top, 200)
                            .padding(.horizontal)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    VStack(alignment: .leading) {
                        if viewModel.courseAssignmentsStructure != nil {
                            
                            Spacer(minLength: 16)
                            
                            // MARK: Course Progress (only assignments)
                            if let courseProgressDetails = viewModel.courseProgressDetails {
                                let totalAssignments = courseProgressDetails.sectionScores
                                    .flatMap { $0.subsections }.count
                                let completedAssignments = courseProgressDetails.sectionScores
                                    .flatMap { $0.subsections }
                                    .filter { $0.status == .completed }.count
                                
                                CourseProgressView(
                                    progress: CourseProgress(
                                        totalAssignmentsCount: totalAssignments,
                                        assignmentsCompleted: completedAssignments
                                    ),
                                    showCompletedToggle: true,
                                    isShowingCompleted: isShowingCompletedAssignments,
                                    onToggleCompleted: {
                                        isShowingCompletedAssignments.toggle()
                                    }
                                )
                                .padding(.horizontal, isTablet ? 24 : 16)
                                .accessibilityIdentifier("assignments_overall_progress")
                            }
                            
                            Spacer(minLength: 16)
                            
                            // MARK: - Assignment Sections
                            if assignmentSections.isEmpty && !viewModel.isShowProgress {
                                // No assignments available
                                NoContentAvailable(
                                    type: .assignments,
                                    action: { viewModel.selection = CourseTab.course.id }
                                )
                                .accessibilityIdentifier("no_assignments_available")
                            } else {
                                ScrollView {
                                    LazyVStack(alignment: .leading, spacing: 32) {
                                        ForEach(assignmentSections, id: \.key) { section in
                                            VStack(alignment: .leading, spacing: 16) {
                                                // Section Title and Progress
                                                HStack {
                                                    Text(section.key)
                                                        .font(Theme.Fonts.titleLarge)
                                                        .foregroundColor(Theme.Colors.textPrimary)
                                                        .accessibilityIdentifier(
                                                            "assignment_section_title_\(section.key)"
                                                        )
                                                    
                                                    Spacer()
                                                    
                                                    Text("\(Int(section.weight * 100))% of Grade")
                                                        .font(Theme.Fonts.bodySmall)
                                                        .foregroundColor(Theme.Colors.textSecondary)
                                                        .padding(.horizontal, 8)
                                                        .padding(.vertical, 4)
                                                        .background(Theme.Colors.cardViewBackground)
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 4)
                                                                .stroke(Theme.Colors.cardViewStroke, lineWidth: 1)
                                                        )
                                                        .accessibilityIdentifier(
                                                            "assignment_section_weight_\(section.weight)"
                                                        )
                                                }
                                                .padding(.horizontal, isTablet ? 32 : 24)
                                                
                                                // Progress Bar
                                                VStack(alignment: .leading, spacing: 8) {
                                                    ProgressView(value: sectionProgress(section.subsections))
                                                        .progressViewStyle(
                                                            LinearProgressViewStyle(tint: Theme.Colors.success)
                                                        )
                                                        .frame(height: 8)
                                                      .accessibilityIdentifier("section_progress_bar_\(section.weight)")
                                                    
                                                Text(sectionProgressText(section.subsections))
                                                        .font(Theme.Fonts.bodySmall)
                                                        .foregroundColor(Theme.Colors.textPrimary)
                                                    .accessibilityIdentifier("section_progress_text_\(section.weight)")
                                                }
                                                .padding(.horizontal, isTablet ? 32 : 24)
                                                
                                                // Assignment Cards for this section
                                                ProgressAssignmentTypeSection(
                                                    subsections: section.subsections,
                                                    sectionName: section.key,
                                                    viewModel: viewModel,
                                                    proxy: proxy,
                                                    isShowingCompletedAssignments: $isShowingCompletedAssignments
                                                )
                                            }
                                        }
                                    }
                                    .animation(.default, value: isShowingCompletedAssignments)
                                }
                            }
                        }
                        
                        Spacer(minLength: 200)
                    }
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .onBlockCompletion)) { _ in
            Task {
                await viewModel.getCourseBlocks(courseID: courseID, withProgress: false)
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

#if DEBUG
#Preview {
    let viewModel = CourseContainerViewModel(
        interactor: CourseInteractor.mock,
        authInteractor: AuthInteractor.mock,
        router: CourseRouterMock(),
        analytics: CourseAnalyticsMock(),
        config: ConfigMock(),
        connectivity: Connectivity(),
        manager: DownloadManagerMock(),
        storage: CourseStorageMock(),
        isActive: true,
        courseStart: Date(),
        courseEnd: nil,
        enrollmentStart: Date(),
        enrollmentEnd: nil,
        lastVisitedBlockID: nil,
        coreAnalytics: CoreAnalyticsMock(),
        courseHelper: CourseDownloadHelper(courseStructure: nil, manager: DownloadManagerMock())
    )
    
    GeometryReader { proxy in
        AssignmentsContentView(
            viewModel: viewModel,
            proxy: proxy,
            title: "Course title",
            courseID: "",
            dateTabIndex: 2
        )
    }
}
#endif

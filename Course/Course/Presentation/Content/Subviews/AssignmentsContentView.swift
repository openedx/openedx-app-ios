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
    
    let assignmentContentData: AssignmentContentData
    private let proxy: GeometryProxy
    private let onAssignmentTap: (CourseProgressSubsectionUI) -> Void
    private let onTabSelection: (Int) -> Void
    private let onErrorDismiss: () -> Void
    private let onShowCompletedAnalytics: () -> Void
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    
    private var isLandscape: Bool {
        horizontalSizeClass == .regular && verticalSizeClass == .compact
    }
    
    private var isTablet: Bool {
        horizontalSizeClass == .regular && verticalSizeClass == .regular
    }
    
    private var assignmentSections: [AssignmentSectionUI] {
        assignmentContentData.assignmentSections
    }
    
    init(
        assignmentContentData: AssignmentContentData,
        proxy: GeometryProxy,
        onAssignmentTap: @escaping (CourseProgressSubsectionUI) -> Void,
        onTabSelection: @escaping (Int) -> Void,
        onErrorDismiss: @escaping () -> Void,
        onShowCompletedAnalytics: @escaping () -> Void = {}
    ) {
        self.assignmentContentData = assignmentContentData
        self.proxy = proxy
        self.onAssignmentTap = onAssignmentTap
        self.onTabSelection = onTabSelection
        self.onErrorDismiss = onErrorDismiss
        self.onShowCompletedAnalytics = onShowCompletedAnalytics
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Error View
            if assignmentContentData.showError {
                VStack {
                    SnackBarView(message: assignmentContentData.errorMessage)
                }
                .transition(.move(edge: .bottom))
                .onAppear {
                    doAfter(Theme.Timeout.snackbarMessageLongTimeout) {
                        onErrorDismiss()
                    }
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel(CourseLocalization.Accessibility.errorMessageSection)
            }
            
            ZStack(alignment: .center) {
                // MARK: - Page Body
                if assignmentContentData.isShowProgress {
                    HStack(alignment: .center) {
                        ProgressBar(size: 40, lineWidth: 8)
                            .padding(.top, 200)
                            .padding(.horizontal)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel(CourseLocalization.Accessibility.loadingSection)
                } else {
                    VStack(alignment: .leading) {
                        if assignmentContentData.courseAssignmentsStructure != nil {
                            
                            Spacer(minLength: 16)
                            
                            // MARK: Course Progress (only assignments)
                            if !assignmentSections.isEmpty {
                                let totalAssignments = assignmentSections
                                    .flatMap { $0.subsections }.count
                                let completedAssignments = assignmentSections
                                    .flatMap { $0.subsections }
                                    .filter { $0.status == .completed }.count
                                
                                CourseProgressView(
                                    progress: CourseProgress(
                                        totalAssignmentsCount: totalAssignments,
                                        assignmentsCompleted: completedAssignments
                                    )
                                )
                                .padding(.horizontal, 24)
                                .accessibilityIdentifier("assignments_overall_progress")
                                .accessibilityElement(children: .combine)
                                .accessibilityLabel(CourseLocalization.Accessibility.assignmentProgressSection)
                            }
                            
                            Spacer(minLength: 16)
                            
                            // MARK: - Assignment Sections
                            if assignmentSections.isEmpty && !assignmentContentData.isShowProgress {
                                // No assignments available
                                NoContentAvailable(
                                    type: .assignments,
                                    action: { onTabSelection(CourseTab.course.id) }
                                )
                                .accessibilityIdentifier("no_assignments_available")
                                .accessibilityElement(children: .combine)
                                .accessibilityLabel(CourseLocalization.Accessibility.noContentSection)
                            } else {
                                ScrollView {
                                    LazyVStack(alignment: .leading, spacing: 32) {
                                        Divider()
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
                                                    
                                                    let weightColor = Color(
                                                        hex: assignmentContentData.assignmentTypeColors[section.key]
                                                        ?? "#666666"
                                                    ) ?? Color.accentColor
                                                    
                                                    Text("\(Int(section.weight * 100))% of Grade")
                                                        .font(Theme.Fonts.bodySmall)
                                                        .foregroundStyle(Theme.Colors.textPrimary)
                                                        .padding(.horizontal, 8)
                                                        .padding(.vertical, 4)
                                                        .background(Theme.Colors.cardViewBackground)
                                                        .overlay(
                                                            ZStack {
                                                                RoundedRectangle(cornerRadius: 4)
                                                                    .foregroundStyle(weightColor.opacity(0.1))
                                                                RoundedRectangle(cornerRadius: 4)
                                                                    .stroke(weightColor, lineWidth: 1)
                                                            }
                                                        )
                                                        .accessibilityIdentifier(
                                                            "assignment_section_weight_\(section.weight)"
                                                        )
                                                }
                                                .padding(.horizontal, isTablet ? 32 : 24)
                                                
                                                // Assignment Cards for this section
                                                ProgressAssignmentTypeSection(
                                                    sectionData: AssignmentSectionData(
                                                        subsectionsUI: section.subsections,
                                                        sectionName: section.key,
                                                        assignmentTypeColors: assignmentContentData.assignmentTypeColors
                                                    ),
                                                    proxy: proxy,
                                                    onAssignmentTap: onAssignmentTap,
                                                    onShowCompletedAnalytics: onShowCompletedAnalytics
                                                )
                                                Divider()
                                            }
                                        .accessibilityElement(children: .contain)
                                        .accessibilityLabel(
                                            "\(section.key) \(CourseLocalization.Accessibility.assignmentsSection)"
                                        )
                                    }
                                }
                            }
                        }
                    }
                    
                    Spacer(minLength: 200)
                }
            }
        }
    }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
}
}

#if DEBUG
#Preview {
    let assignmentContentData = AssignmentContentData(
        courseAssignmentsStructure: nil,
        assignmentSections: [],
        assignmentTypeColors: [:],
        isShowProgress: false,
        showError: false,
        errorMessage: nil
    )
    
    GeometryReader { proxy in
        AssignmentsContentView(
            assignmentContentData: assignmentContentData,
            proxy: proxy,
            onAssignmentTap: { _ in },
            onTabSelection: { _ in },
            onErrorDismiss: { },
            onShowCompletedAnalytics: { }
        )
    }
}
#endif

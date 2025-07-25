//
//  ProgressAssignmentTypeSection.swift
//  Course
//
//  Created by Ivan Stepanok on 08.07.2025.
//

import SwiftUI
import Core
import OEXFoundation
import Theme

struct ProgressAssignmentTypeSection: View {

    let subsections: [CourseProgressSubsection]
    let sectionName: String
    let viewModel: CourseContainerViewModel
    let proxy: GeometryProxy

    @State private var selectedIndex: Int = 0
    @State private var isShowingCompletedAssignments: Bool = true
    @State private var uiScrollView: UIScrollView?

    // MARK: – Filters and metrics
    private var filteredSubsections: [CourseProgressSubsection] {
        isShowingCompletedAssignments ? subsections
                                      : subsections.filter { $0.status != .completed }
    }

    private var firstIncompleteIndex: Int {
        filteredSubsections.firstIndex { $0.status != .completed } ?? 0
    }

    private var completedCount: Int {
        subsections.filter { $0.status == .completed }.count
    }
    private var totalCount: Int { subsections.count }

    // MARK: – View
    var body: some View {
        VStack(spacing: 16) {
            // MARK: – Progress + Toggle
            CourseProgressView(
                progress: CourseProgress(totalAssignmentsCount: totalCount,
                                          assignmentsCompleted: completedCount),
                showCompletedToggle: completedCount >= 1 || completedCount == totalCount,
                isShowingCompleted: isShowingCompletedAssignments,
                onToggleCompleted: { isShowingCompletedAssignments.toggle() }
            )
            .padding(.horizontal, 24)

            ScrollViewReader { reader in
                ScrollView(.horizontal, showsIndicators: false) {
                    if filteredSubsections.count > 1 {
                        LazyHStack(spacing: 12) {
                            ForEach(Array(filteredSubsections.enumerated()), id: \.offset) { index, subsection in
                                AssignmentCardSmallView(
                                    subsection: subsection,
                                    index: index,
                                    sectionName: sectionName,
                                    isSelected: Binding(
                                        get: { index == selectedIndex },
                                        set: { _ in selectedIndex = index }
                                    ),
                                    onTap: { selectedIndex = index },
                                    viewModel: viewModel
                                )
                                .padding(.leading, index == 0 ? 24 : 0)
                                .padding(.top, 9)
                                .id(index)
                            }
                            
                            Spacer(minLength: 200)
                        }
                    }
                }
                .accessibilityIdentifier("assignment_cards_horizontal_scroll_\(sectionName)")

                .introspect(.scrollView, on: .iOS(.v16, .v17, .v18)) { scroll in
                    DispatchQueue.main.async { uiScrollView = scroll }
                }

                // MARK: – Behavior when the filter appears and changes
                .onAppear {
                    applyInitialScroll(using: reader, animated: false)
                    hideCompletedAssignments()
                }
                .onChange(of: isShowingCompletedAssignments) { _ in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        applyInitialScroll(using: reader, animated: true)
                    }
                }
            }

            // MARK: – Detail Card
            if selectedIndex < filteredSubsections.count {
                AssignmentDetailCardView(
                    subsection: filteredSubsections[selectedIndex],
                    sectionName: sectionName,
                    viewModel: viewModel
                )
                .accessibilityIdentifier("assignment_detail_card_\(sectionName)")
            }
        }
    }

    // MARK: – Helpers
    
    private func hideCompletedAssignments() {
        if totalCount == completedCount {
            isShowingCompletedAssignments = false
        }
    }
    
    private func applyInitialScroll(using reader: ScrollViewProxy, animated: Bool) {
        if isShowingCompletedAssignments {
            selectedIndex = firstIncompleteIndex
            reader.scrollTo(firstIncompleteIndex, anchor: .leading)

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                guard let scroll = uiScrollView else { return }
                let newX = max(scroll.contentOffset.x - 20, 0)
                scroll.setContentOffset(CGPoint(x: newX, y: 0), animated: animated)
            }
        } else {
            selectedIndex = 0
            uiScrollView?.setContentOffset(.zero, animated: animated)
        }
    }
}

#if DEBUG
#Preview {
    GeometryReader { proxy in
        ProgressAssignmentTypeSection(
            subsections: [
                CourseProgressSubsection(
                    assignmentType: "1",
                    blockKey: "block1",
                    displayName: "Test Assignment 1",
                    hasGradedAssignment: true,
                    override: nil,
                    learnerHasAccess: true,
                    numPointsEarned: 1.0,
                    numPointsPossible: 1.0,
                    percentGraded: 1.0,
                    problemScores: [],
                    showCorrectness: "always",
                    showGrades: true,
                    url: "https://example.com",
                    shortLabel: "HW1 01"
                ),
                CourseProgressSubsection(
                    assignmentType: "1",
                    blockKey: "block2",
                    displayName: "Test Assignment 2",
                    hasGradedAssignment: true,
                    override: nil,
                    learnerHasAccess: true,
                    numPointsEarned: 0.0,
                    numPointsPossible: 1.0,
                    percentGraded: 0.0,
                    problemScores: [],
                    showCorrectness: "always",
                    showGrades: true,
                    url: "https://example.com",
                    shortLabel: "HW1 02"
                ),
                CourseProgressSubsection(
                    assignmentType: "1",
                    blockKey: "block3",
                    displayName: "Test Assignment 3",
                    hasGradedAssignment: true,
                    override: nil,
                    learnerHasAccess: false,
                    numPointsEarned: 0.0,
                    numPointsPossible: 1.0,
                    percentGraded: 0.0,
                    problemScores: [],
                    showCorrectness: "always",
                    showGrades: true,
                    url: "https://example.com",
                    shortLabel: "HW1 03"
                )
            ],
            sectionName: "Labs",
            viewModel: CourseContainerViewModel.mock,
            proxy: proxy
        )
    }
    .padding()
}

extension CourseContainerViewModel {
    static var mock: CourseContainerViewModel {
        CourseContainerViewModel(
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
    }
}
#endif

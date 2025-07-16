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

struct ProgressAssignmentTypeSection: View, Equatable {
    nonisolated static func == (lhs: ProgressAssignmentTypeSection, rhs: ProgressAssignmentTypeSection) -> Bool {
        lhs.sectionName == rhs.sectionName &&
        lhs.subsections == rhs.subsections
    }
    
    let subsections: [CourseProgressSubsection]
    let sectionName: String
    let viewModel: CourseContainerViewModel
    let proxy: GeometryProxy
    @Binding var isShowingCompletedAssignments: Bool
    
    @State private var selectedIndex: Int = 0
    
    private var filteredSubsections: [CourseProgressSubsection] {
        if isShowingCompletedAssignments {
            return subsections
        } else {
            return subsections.filter { $0.numPointsEarned < $0.numPointsPossible }
        }
    }
    
    private var firstIncompleteIndex: Int {
        for (index, subsection) in filteredSubsections.enumerated()
            where subsection.numPointsEarned < subsection.numPointsPossible {
            return index
        }
        return 0
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Горизонтальный скролл карточек
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(
                        Array(filteredSubsections.enumerated()),
                        id: \.element.blockKey
                    ) { index, subsection in
                        AssignmentCardSmallView(
                            subsection: subsection,
                            index: index,
                            sectionName: sectionName,
                            isSelected: index == selectedIndex,
                            onTap: {
                                selectedIndex = index
                            },
                            viewModel: viewModel
                        )
                        .padding(.top, 9)
                    }
                }
                .padding(.horizontal, 24)
            }
            .accessibilityIdentifier("assignment_cards_horizontal_scroll_\(sectionName)")
            
            if selectedIndex < filteredSubsections.count {
                AssignmentDetailCardView(
                    subsection: filteredSubsections[selectedIndex],
                    sectionName: sectionName,
                    viewModel: viewModel
                )
                .accessibilityIdentifier("assignment_detail_card_\(sectionName)")
            }
        }
        .onAppear {
            selectedIndex = firstIncompleteIndex
        }
        .onChange(of: firstIncompleteIndex) { newIndex in
            selectedIndex = newIndex
        }
        .onChange(of: isShowingCompletedAssignments) { _ in
            selectedIndex = firstIncompleteIndex
        }
    }
}

#if DEBUG
struct ProgressAssignmentTypeSection_Previews: PreviewProvider {
    static var previews: some View {
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
                        url: "https://example.com"
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
                        url: "https://example.com"
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
                        url: "https://example.com"
                    )
                ],
                sectionName: "Labs",
                viewModel: CourseContainerViewModel.mock,
                proxy: proxy,
                isShowingCompletedAssignments: .constant(false)
            )
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
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

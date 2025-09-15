import SwiftUI
import Theme
import Core

struct CourseAssignmentsCarouselSlideView: View {

    // MARK: - Variables
    @ObservedObject var viewModelProgress: CourseProgressViewModel
    @ObservedObject var viewModelContainer: CourseContainerViewModel

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass

    private var assignmentContentData: AssignmentContentData {
        AssignmentContentData(
            courseAssignmentsStructure: viewModelContainer.courseAssignmentsStructure,
            assignmentSections: viewModelContainer.assignmentSectionsData.map { section in
                AssignmentSectionUI(
                    key: section.label,
                    subsections: section.subsections,
                    weight: section.weight
                )
            },
            assignmentTypeColors: Dictionary(uniqueKeysWithValues:
                                                viewModelContainer.assignmentSectionsData.map { section in
                    (section.label, viewModelContainer.assignmentTypeColor(for: section.label) ?? "#666666")
                }
            ),
            isShowProgress: viewModelContainer.isShowProgress,
            showError: viewModelContainer.showError,
            errorMessage: viewModelContainer.errorMessage
        )
    }

    private var isLandscape: Bool {
        horizontalSizeClass == .regular && verticalSizeClass == .compact
    }

    private var assignmentSections: [AssignmentSectionUI] {
        assignmentContentData.assignmentSections
    }

    private var allAssignmentsCompleted: Bool {

        let allSubsections = assignmentSections.flatMap { $0.subsections }
        if allSubsections.allSatisfy({ $0.status == .completed }) {
            return true
        }

        return false
    }

    private var showedAssignmentSection: AssignmentSectionUI? {
        let allSubsections = assignmentSections.flatMap { $0.subsections }

        if let pastDueSection = assignmentSections.first(where: {
            $0.subsections.contains(where: { $0.status == .pastDue })
        }) {
            return pastDueSection
        }

        let dueSoonSubsection = allSubsections
            .filter { $0.status == .incomplete || $0.status == .notAvailable }
            .compactMap { $0.date }
            .first

        if let dueSoonDate = dueSoonSubsection {
            return assignmentSections.first(where: {
                $0.subsections.contains(where: { $0.date == dueSoonDate })
            })
        }

        if let incompleteSection = assignmentSections.first(where: {
              $0.subsections.contains(where: { $0.status == .incomplete })
          }) {
              return incompleteSection
          }

        return nil
    }

    private var showedAssignmentSubsection: CourseProgressSubsectionUI? {
        let allSubsections = assignmentSections.flatMap { $0.subsections }

        if let pastDue = allSubsections.first(where: { $0.status == .pastDue }) {
            return pastDue
        }

        if let notAvailable = allSubsections.first(where: { $0.status == .incomplete }) {
            return notAvailable
        }

        return nil
    }

    // MARK: - Body
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                if assignmentSections.isEmpty {
                    NoContentAvailable(
                        type: .assignments,
                        action: {},
                        showButton: false
                    )
                    .accessibilityIdentifier("no_assignments_available")
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel(CourseLocalization.Accessibility.noContentSection)
                } else {
                    headerView
                    assignmentCompletedView

                    if allAssignmentsCompleted {
                        VStack(spacing: 16) {
                            Text(CourseLocalization.CourseCarousel.allVideosCompleted)
                                .font(Theme.Fonts.titleMedium)
                                .foregroundColor(Theme.Colors.textPrimary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 16)
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel(CourseLocalization.CourseCarousel.allAssignmentsCompleted)
                    } else {
                        if let section = showedAssignmentSection, let subSectionUI = showedAssignmentSubsection {
                            AssignmentCarouselDetailCardView(
                                detailData: AssignmentDetailData(
                                    subsectionUI: subSectionUI,
                                    sectionName: section.key,
                                    onAssignmentTap: { subSectionUI in
                                        viewModelContainer.navigateToAssignment(for: subSectionUI.subsection)
                                        viewModelContainer.trackCourseHomeAssignmentClicked(
                                            blockId: subSectionUI.subsection.blockKey,
                                            blockName: subSectionUI.subsection.displayName
                                        )
                                    }
                                )
                            )
                        }
                    }

                    ViewAllButton(section: CourseLocalization.CourseCarousel.viewAllAssignments) {
                        viewModelContainer.selection = 1
                        viewModelContainer.selectedTab = .assignments
                        viewModelContainer.trackCourseHomeViewAllAssignmentsClicked()
                    }
                    .frame(maxWidth: .infinity)
                }

            }
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(Theme.Colors.datesSectionBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(style: .init(lineWidth: 1, lineCap: .round, lineJoin: .round, miterLimit: 1))
                    .foregroundColor(Theme.Colors.cardViewStroke)
            )

            Spacer()
        }
    }

    // MARK: - Header View
    private var headerView: some View {
        Text(CourseLocalization.CourseContent.assignments)
            .foregroundStyle(Theme.Colors.textPrimary)
            .font(Theme.Fonts.titleLarge)
            .frame(maxWidth: .infinity, alignment: .leading)
            .clipped()
            .padding(.bottom, 16)
            .padding(.horizontal, 16)
    }

    // MARK: - Assigments Completed View
    private var assignmentCompletedView: some View {
        VStack(alignment: .leading, spacing: 8) {
                if !assignmentSections.isEmpty {
                    let totalAssignments = assignmentSections
                        .flatMap { $0.subsections }.count
                    let completedAssignments = assignmentSections
                        .flatMap { $0.subsections }
                        .filter { $0.status == .completed }.count

                    HStack(alignment: .center) {
                        CoreAssets.icAssignment.swiftUIImage
                            .renderingMode(.template)
                            .foregroundStyle(Theme.Colors.textPrimary)
                            .padding(.trailing, 4)

                        Text("\(completedAssignments)/\(totalAssignments)")
                            .font(Theme.Fonts.displaySmall)
                            .foregroundStyle(Theme.Colors.textPrimary)
                            .padding(.trailing, 8)

                        Text(CourseLocalization.CourseCarousel.assigmentsCompleted)
                            .font(Theme.Fonts.labelLarge)
                            .foregroundStyle(Theme.Colors.textSecondary)
                    }

                    CourseProgressView(
                        progress: CourseProgress(
                            totalAssignmentsCount: totalAssignments,
                            assignmentsCompleted: completedAssignments,
                        ),
                        showCompletedText: false
                    )
                    .accessibilityIdentifier("assignments_overall_progress")
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel(CourseLocalization.Accessibility.assignmentProgressSection)
                }
        }
        .padding(.horizontal, 16)
    }
}

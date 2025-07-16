import SwiftUI
import Theme
import Core

struct CourseGradeCarouselSlideView: View {
    
    // MARK: - Variables
    let viewModelProgress: CourseProgressViewModel
    let viewModelContainer: CourseContainerViewModel

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading) {

            headerView
            descriptionView
            if viewModelProgress.hasGradedAssignments {
                gradeView
            } else {
                noGradeAssignmentView
            }

            ViewAllButton(section: CourseLocalization.CourseContainer.progress) {
                viewModelContainer.selection = 1
            }
            .frame(maxWidth: .infinity)
        }
        .padding(16)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(style: .init(lineWidth: 1, lineCap: .round, lineJoin: .round, miterLimit: 1))
                .foregroundColor(Theme.Colors.cardViewStroke)
        )
    }
    
    // MARK: - Header View
    private var headerView: some View {
        Text(CourseLocalization.CourseCarousel.grades)
            .foregroundStyle(Theme.Colors.textPrimary)
            .font(Theme.Fonts.titleLarge)
            .frame(maxWidth: .infinity, alignment: .leading)
            .clipped()
            .padding(.bottom, 16)
    }
    
    // MARK: - Description View
    private var descriptionView: some View {
        Text(CourseLocalization.CourseCarousel.gradesDescription)
            .foregroundStyle(Theme.Colors.textSecondary)
            .font(Theme.Fonts.bodyMedium)
            .lineLimit(2)
            .padding(.bottom, 12)
            .accessibilityLabel(CourseLocalization.Accessibility.overallGradeSection)
    }

    // MARK: - Grade View
    private var gradeView: some View {
        VStack {
            OverallGradeView(
                currentGrade: viewModelProgress.gradePercentage,
                requiredGrade: viewModelProgress.requiredGradePercentage,
                assignmentPolicies: viewModelProgress.assignmentPolicies,
                assignmentProgressData: viewModelProgress.getAllAssignmentProgressData(),
                assignmentColors: viewModelProgress.courseProgress?.assignmentColors ?? [],
                isCarousel: true
            )
            .accessibilityLabel(CourseLocalization.Accessibility.overallGradeSection)

            gradeDetailsItems
        }
    }

    // MARK: - Grade Details Items
    private var gradeDetailsItems: some View {
        let columns = [
            GridItem(.adaptive(minimum: 140))
        ]

        return LazyVGrid(columns: columns, spacing: 16) {
                ForEach(
                    Array(viewModelProgress.assignmentPolicies.prefix(3).enumerated()),
                    id: \.element.type
                ) { index, policy in
                    let progressData = viewModelProgress.getAssignmentProgress(for: policy.type)

                    GradeItemCarouselView(
                        assignmentPolicy: policy,
                        progressData: progressData,
                        color: viewModelProgress.getAssignmentColor(for: index)
                    )
                }
            }
            .padding(16)
    }

    // MARK: - No Grade Assignment View
    private var noGradeAssignmentView: some View {
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
    }
}

// MARK: - Preview
#if DEBUG
#Preview {
    CourseGradeCarouselSlideView(viewModelProgress: CourseProgressViewModel(
        interactor: CourseInteractor.mock,
        router: CourseRouterMock(),
        analytics: CourseAnalyticsMock(),
        connectivity: Connectivity(),
    ),
    viewModelContainer: CourseContainerViewModel(
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
    ))
    .padding(16)
    .frame(height: 408)
    .loadFonts()
}
#endif

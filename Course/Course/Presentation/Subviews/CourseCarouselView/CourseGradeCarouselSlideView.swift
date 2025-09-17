import SwiftUI
import Theme
import Core

struct CourseGradeCarouselSlideView: View {
    
    // MARK: - Variables
    @ObservedObject var viewModelProgress: CourseProgressViewModel
    @ObservedObject var viewModelContainer: CourseContainerViewModel
    
    // MARK: - Body
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                if viewModelProgress.hasGradedAssignments {
                    headerView
                    descriptionView
                    gradeView
                    
                    ViewAllButton(section: CourseLocalization.CourseContainer.progress) {
                        viewModelContainer.selection = 2
                        viewModelContainer.trackCourseHomeGradesViewProgressClicked()
                    }
                    .frame(maxWidth: .infinity)
                } else {
                    noGradeAssignmentView
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
        Text(CourseLocalization.CourseCarousel.grades)
            .foregroundStyle(Theme.Colors.textPrimary)
            .font(Theme.Fonts.titleLarge)
            .frame(maxWidth: .infinity, alignment: .leading)
            .clipped()
            .padding(.bottom, 16)
            .padding(.horizontal, 16)
    }
    
    // MARK: - Description View
    private var descriptionView: some View {
        Text(CourseLocalization.CourseCarousel.gradesDescription)
            .foregroundStyle(Theme.Colors.textSecondaryDark)
            .font(Theme.Fonts.bodyMedium)
            .lineLimit(2)
            .padding(.bottom, 12)
            .accessibilityLabel(CourseLocalization.CourseCarousel.gradesDescription)
            .padding(.horizontal, 16)
    }

    // MARK: - Grade View
    private var gradeView: some View {
        VStack {
            OverallGradeView(
                currentGrade: viewModelProgress.gradePercentage,
                requiredGrade: viewModelProgress.requiredGradePercentage,
                assignmentPolicies: viewModelProgress.assignmentPolicies,
                assignmentProgressData: $viewModelProgress.assignmentProgressData,
                assignmentColors: viewModelProgress.courseProgress?.gradingPolicy.assignmentColors ?? [],
                isCarousel: true
            )
            .padding(.horizontal, 16)

            gradeDetailsItems
        }
    }

    // MARK: - Grade Details Items
    private var gradeDetailsItems: some View {

        let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 2)

        return LazyVGrid(columns: columns, spacing: 16) {
            ForEach(
                Array(viewModelProgress.assignmentPolicies.prefix(4).enumerated()),
                id: \.element.type
            ) { index, policy in
                let progressData = viewModelProgress.getAssignmentProgress(for: policy.type)

                GradeItemCarouselView(
                    assignmentPolicy: policy,
                    progressData: progressData,
                    color: viewModelProgress.getAssignmentColor(for: index)
                )
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 16)
    }

    // MARK: - No Grade Assignment View
    private var noGradeAssignmentView: some View {
        VStack(spacing: 16) {
            CoreAssets.iconWarning.swiftUIImage

            Text(CourseLocalization.CourseContainer.Progress.noGradedAssignments)
                .font(Theme.Fonts.titleMedium)
                .foregroundColor(Theme.Colors.textPrimary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(CourseLocalization.CourseContainer.Progress.noGradedAssignments)
    }
}

// MARK: - Preview
#if DEBUG
#Preview {
    CourseGradeCarouselSlideView(
        viewModelProgress: CourseProgressViewModel(
            interactor: CourseInteractor.mock,
            router: CourseRouterMock(),
            analytics: CourseAnalyticsMock(),
            connectivity: Connectivity()
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
        )
    )
    .padding(16)
    .frame(height: 408)
    .loadFonts()
}
#endif

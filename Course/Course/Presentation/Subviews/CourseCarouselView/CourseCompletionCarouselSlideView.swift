import SwiftUI
import Theme
import Core

struct CourseCompletionCarouselSlideView<DownloadBarsView: View>: View {

    // MARK: - Variables
    let viewModelProgress: CourseProgressViewModel
    let viewModelContainer: CourseContainerViewModel
    let isVideo: Bool
    let idiom: UIUserInterfaceIdiom
    let downloadQualityBars: (GeometryProxy) -> DownloadBarsView

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading) {

            headerView
            progressView
            sectionView

            ViewAllButton(section: CourseLocalization.CourseCarousel.allContent) {
                viewModelContainer.selection = 1
                viewModelContainer.selectedTab = .all
                viewModelContainer.trackCourseHomeViewAllContentClicked()
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 16)

        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(Theme.Colors.datesSectionBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(style: .init(lineWidth: 1, lineCap: .round, lineJoin: .round, miterLimit: 1))
                .foregroundColor(Theme.Colors.cardViewStroke)
        )
    }

    // MARK: - Header View
    private var headerView: some View {
        Text(CourseLocalization.CourseContainer.Progress.title)
            .foregroundStyle(Theme.Colors.textPrimary)
            .font(Theme.Fonts.titleLarge)
            .frame(maxWidth: .infinity, alignment: .leading)
            .clipped()
    }

    // MARK: - Progress View
    private var progressView: some View {

        let progressPercentage = Int(ceil(viewModelProgress.overallProgressPercentage * 100))

        return HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                Text(CourseLocalization.CourseContainer.progress)
                    .font(Theme.Fonts.titleMedium)
                    .foregroundColor(Theme.Colors.textPrimary)
                    .accessibilityAddTraits(.isHeader)

                Text(CourseLocalization.CourseCarousel.progressCompletion(progressPercentage))
                    .font(Theme.Fonts.bodyMedium)
                    .foregroundColor(Theme.Colors.textSecondary)
                    .lineLimit(nil)
            }

            Spacer()

            CourseProgressCircleView(
                progressPercentage: viewModelProgress.overallProgressPercentage,
                size: 90
            )
            .accessibilityLabel(CourseLocalization.Accessibility.progressRing)
            .accessibilityValue(
                CourseLocalization.Accessibility.progressPercentageCompleted("\(progressPercentage)")
            )
        }
    }

    // MARK: - Section View
    private var sectionView: some View {
        VStack {
            GeometryReader { proxy in
            if let course = isVideo
                ? viewModelContainer.courseVideosStructure
                : viewModelContainer.courseStructure {
                if let progress = course.courseProgress,
                   progress.totalAssignmentsCount != 0 {
                        VStack(spacing: 18) {
                            ZStack {
                                GeometryReader { geometry in
                                    RoundedCorners(tl: 8, tr: 8, bl: 0, br: 0)
                                        .fill(Theme.Colors.courseProgressBG)
                                        .frame(width: geometry.size.width, height: 6)
                                        .padding(.horizontal, 1)

                                    if let total = progress.totalAssignmentsCount,
                                       let completed = progress.assignmentsCompleted {
                                        RoundedCorners(tl: 4, tr: completed == total ? 4 : 0, bl: 0, br: 0)
                                            .fill(Theme.Colors.success)
                                            .frame(width: geometry.size.width * CGFloat(completed) / CGFloat(total),
                                                   height: 6)
                                            .padding(.horizontal, 2)
                                    }
                                }
                                .frame(height: 6)
                            }
                        }
                    }
                if let continueWith = viewModelContainer.continueWith,
                   let courseStructure = viewModelContainer.courseStructure {
                    let chapter = courseStructure.childs[continueWith.chapterIndex]
                    let sequential = chapter.childs[continueWith.sequentialIndex]
                    nextSectionView(
                        courseStructure: courseStructure,
                        chapter: chapter,
                        sequential: sequential,
                        proxy: proxy
                    )
                } else {
                    if let courseStructure = viewModelContainer.courseStructure,
                        let chapter = courseStructure.childs.first,
                        let sequential = chapter.childs.first {
                        nextSectionView(
                            courseStructure: courseStructure,
                            chapter: chapter,
                            sequential: sequential,
                            proxy: proxy
                        )
                    }
                }
                }
            }
            .frame(height: 96)
        }
    }

    // MARK: - Next Section View
    private func nextSectionView(courseStructure: CourseStructure,
                                 chapter: CourseChapter,
                                 sequential: CourseSequential,
                                 proxy: GeometryProxy) -> some View {
        VStack {
            HStack {
                Text("\(chapter.displayName)")
                    .font(Theme.Fonts.titleMedium)
                    .foregroundColor(Theme.Colors.textPrimary)

                Spacer()

                if isVideo, viewModelContainer.isShowProgress == false {
                    downloadQualityBars(proxy)
                }
            }

            HStack {
                CoreAssets.chapter.swiftUIImage
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 20, height: 20)

                Text(sequential.displayName)
                    .font(Theme.Fonts.titleSmall)
                    .multilineTextAlignment(.leading)
                    .lineLimit(1)
                    .frame(
                        maxWidth: idiom == .pad
                        ? proxy.size.width * 0.5
                        : proxy.size.width * 0.6,
                        alignment: .leading
                    )

                Spacer()

                CoreAssets.chevronRight.swiftUIImage
                    .foregroundColor(Theme.Colors.textPrimary)
                    .flipsForRightToLeftLayoutDirection(true)
            }
            .onTapGesture {
                viewModelContainer.router.showCourseVerticalView(
                    courseID: courseStructure.id,
                    courseName: courseStructure.displayName,
                    title: sequential.displayName,
                    chapters: courseStructure.childs,
                    chapterIndex: 0,
                    sequentialIndex: 0
                )

                viewModelContainer.trackCourseHomeSectionClicked(
                    section: chapter.displayName,
                    subsection: sequential.displayName
                )
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 96)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(style: StrokeStyle(lineWidth: 1, lineCap: .round, lineJoin: .round))
                .foregroundColor(Theme.Colors.cardViewStroke)
        )
    }
}

// MARK: - Preview
#if DEBUG
#Preview {
    CourseCompletionCarouselSlideView(
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
            courseStart: nil,
            courseEnd: nil,
            enrollmentStart: nil,
            enrollmentEnd: nil,
            lastVisitedBlockID: nil,
            coreAnalytics: CoreAnalyticsMock(),
            courseHelper: CourseDownloadHelper(courseStructure: nil, manager: DownloadManagerMock())
        ),
        isVideo: false,
        idiom: .phone,
        downloadQualityBars: { _ in
            HStack(spacing: 4) {
                Capsule().fill(Color.gray.opacity(0.3)).frame(width: 12, height: 6)
                Capsule().fill(Color.gray.opacity(0.6)).frame(width: 12, height: 6)
                Capsule().fill(Color.gray).frame(width: 12, height: 6)
            }
        }
    )
    .padding(16)
    .frame(height: 327)
    .loadFonts()
}
#endif

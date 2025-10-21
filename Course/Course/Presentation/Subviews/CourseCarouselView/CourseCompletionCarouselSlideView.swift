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
                    .foregroundColor(Theme.Colors.textSecondaryDark)
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
                if let courseStructure = viewModelContainer.courseStructure,
                   let chapter = courseStructure.childs.first(where: {
                       $0.childs.contains(where: { $0.completion != 1 })
                   }),
                   let sequential = chapter.childs.first(where: { $0.completion != 1 }) {
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
            .frame(height: 96)
        }
    }

    // MARK: - Next Section View
    private func nextSectionView(courseStructure: CourseStructure,
                                 chapter: CourseChapter,
                                 sequential: CourseSequential,
                                 proxy: GeometryProxy) -> some View {
        VStack {
            SectionProgressView(progress: viewModelContainer.chapterProgressDeep(for: chapter))
                .accessibilityLabel(
                    CourseLocalization.Accessibility.progressPercentageCompleted(
                        viewModelContainer.chapterCompletionPercentProgress(
                            for: chapter
                        )
                    )
                )
            Spacer()

            VStack {
                HStack {
                    Text("\(chapter.displayName)")
                        .font(Theme.Fonts.titleMedium)
                        .foregroundColor(Theme.Colors.textPrimary)

                    Spacer()

                    Spacer()

                    if canDownloadAllSections(in: chapter),
                       let state = downloadAllButtonState(for: chapter) {
                        Button(
                            action: {
                                downloadAllSubsections(in: chapter, state: state)
                            }, label: {
                                switch state {
                                case .available:
                                    DownloadAvailableView()
                                case .downloading:
                                    DownloadProgressView()
                                case .finished:
                                    DownloadFinishedView()
                                }

                            }
                        )
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
                    if sequential.due != nil {
                        CoreAssets.chevronRight.swiftUIImage
                            .foregroundColor(Theme.Colors.textPrimary)
                            .flipsForRightToLeftLayoutDirection(true)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .frame(height: 96)
        .background(content: {
            Theme.Colors.cardViewBackground
        })
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(style: StrokeStyle(lineWidth: 1, lineCap: .round, lineJoin: .round))
                .foregroundColor(Theme.Colors.cardViewStroke)
        )
        .onTapGesture {
            if let chapterIndex = courseStructure.childs.firstIndex(where: {
                $0.childs.contains(where: { $0.completion != 1 })
            }),
            let sequentialIndex = courseStructure.childs[chapterIndex].childs.firstIndex(where: {
                $0.completion != 1
            }) {
                viewModelContainer.router.showCourseVerticalView(
                    courseID: courseStructure.id,
                    courseName: courseStructure.displayName,
                    title: sequential.displayName,
                    chapters: courseStructure.childs,
                    chapterIndex: chapterIndex,
                    sequentialIndex: sequentialIndex
                )

                viewModelContainer.trackCourseHomeSectionClicked(
                    section: chapter.displayName,
                    subsection: sequential.displayName
                )
            }
        }
    }

    private func downloadAllSubsections(in chapter: CourseChapter, state: DownloadViewState) {
        Task {
            var allBlocks: [CourseBlock] = []
            var sequentialsToDownload: [CourseSequential] = []
            for sequential in chapter.childs {
                let blocks = await viewModelContainer.collectBlocks(
                    chapter: chapter,
                    blockId: sequential.id,
                    state: state
                )
                if !blocks.isEmpty {
                    allBlocks.append(contentsOf: blocks)
                    sequentialsToDownload.append(sequential)
                }
            }
            await viewModelContainer.download(
                state: state,
                blocks: allBlocks,
                sequentials: sequentialsToDownload
            )
        }
    }

    private func downloadAllButtonState(for chapter: CourseChapter) -> DownloadViewState? {
        if canDownloadAllSections(in: chapter) {
            var downloads: [DownloadViewState] = []
            for sequential in chapter.childs {
                if let state = sequentialDownloadState(sequential) {
                    downloads.append(state)
                }
            }
            if downloads.contains(.downloading) {
                return .downloading
            } else if downloads.allSatisfy({ $0 == .finished }) {
                return .finished
            } else {
                return .available
            }
        }
        return nil
    }

    private func canDownloadAllSections(in chapter: CourseChapter) -> Bool {
        chapter.childs.contains { sequential in
            sequentialDownloadState(sequential) != nil
        }
    }

    private func sequentialDownloadState(_ sequential: CourseSequential) -> DownloadViewState? {
        return viewModelContainer.sequentialsDownloadState[sequential.id]
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

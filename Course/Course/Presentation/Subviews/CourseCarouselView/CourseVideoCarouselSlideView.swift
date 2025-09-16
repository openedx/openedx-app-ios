import SwiftUI
import Theme
import Core

struct CourseVideoCarouselSlideView: View {

    // MARK: - Variables
    @ObservedObject var viewModelProgress: CourseProgressViewModel
    @ObservedObject var viewModelContainer: CourseContainerViewModel
    @State private var isHidingCompletedSections = true

    private var videoContentData: VideoContentData {
        VideoContentData(
            courseVideosStructure: viewModelContainer.courseVideosStructure,
            courseProgress: viewModelContainer.courseVideosStructure?.courseProgress,
            sequentialsDownloadState: viewModelContainer.sequentialsDownloadState,
            isShowProgress: viewModelContainer.isShowProgress,
            showError: viewModelContainer.showError,
            errorMessage: viewModelContainer.errorMessage
        )
    }

    private var allVideosCompleted: Bool {
        let visible = getVisibleChapters()

        let allVideos = visible.flatMap { getAllVideos(from: $0) }
        if allVideos.allSatisfy({ $0.completion >= 1.0 }) {
            return true
        }

        return false
    }

    // MARK: - Helper Methods
    private func getAllVideos(from chapter: CourseChapter) -> [CourseBlock] {
        chapter.childs.flatMap { $0.childs.flatMap { $0.childs } }
    }

    private func isChapterFullyCompleted(_ chapter: CourseChapter) -> Bool {
        let allVideos = getAllVideos(from: chapter)
        return !allVideos.isEmpty && allVideos.allSatisfy { $0.completion >= 1.0 }
    }

    private func hasFullyCompletedSections() -> Bool {
        guard let courseVideosStructure = videoContentData.courseVideosStructure else { return false }
        return courseVideosStructure.childs.contains { isChapterFullyCompleted($0) }
    }

    private func getVisibleChapters() -> [CourseChapter] {
        guard let courseVideosStructure = videoContentData.courseVideosStructure else { return [] }

        if isHidingCompletedSections {
            return courseVideosStructure.childs.filter { !isChapterFullyCompleted($0) }
        } else {
            let completedChapters = courseVideosStructure.childs.filter { isChapterFullyCompleted($0) }
            let incompleteChapters = courseVideosStructure.childs.filter { !isChapterFullyCompleted($0) }
            return completedChapters + incompleteChapters
        }
    }

    // MARK: - Find chapter: first partial, else first unwatched
    private var courseChapter: CourseChapter? {
        let visible = getVisibleChapters()

        if let partial = visible.first(
            where: { chapter in
                getAllVideos(
                    from: chapter
                )
                .contains {
                    $0.localVideoProgress > 0 && $0.localVideoProgress < 1 && $0.completion < 1
                }
        }) {
            return partial
        } else {
            return visible.first(where: { chapter in
                getAllVideos(from: chapter).contains { $0.localVideoProgress == 0 }
            })
        }
    }

    // MARK: - Select video: partial if available, else first unwatched
    private var videoBlock: CourseBlock? {
        guard let chapter = courseChapter else { return nil }
        let videos = getAllVideos(from: chapter)
        if let partial = videos.first(
            where: {
                $0.localVideoProgress > 0 && $0.localVideoProgress < 1 && $0.completion < 1
            }) {
            return partial
        } else {
            return videos.first(where: { $0.localVideoProgress == 0 })
        }
    }

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading) {
            if let courseVideosStructure = videoContentData.courseVideosStructure {
                if courseVideosStructure.childs.isEmpty && !videoContentData.isShowProgress {
                    NoContentAvailable(
                        type: .video,
                        action: {},
                        showButton: false
                    )
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel(CourseLocalization.Error.videosUnavailable)
                } else {
                    headerView
                    videosCompletedView

                    if allVideosCompleted {
                        VStack(spacing: 16) {
                            Text(CourseLocalization.CourseCarousel.allVideosCompleted)
                                .font(Theme.Fonts.titleMedium)
                                .foregroundColor(Theme.Colors.textPrimary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel(CourseLocalization.CourseCarousel.allVideosCompleted)
                    } else {
                        continueWatchingView
                    }

                    ViewAllButton(section: CourseLocalization.CourseCarousel.viewAllVideos) {
                        viewModelContainer.selection = 1
                        viewModelContainer.selectedTab = .videos
                        viewModelContainer.trackCourseHomeViewAllVideosClicked()
                    }
                    .frame(maxWidth: .infinity)
                }
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
    }

    // MARK: - Header View
    private var headerView: some View {
        Text(CourseLocalization.CourseContent.videos)
            .foregroundStyle(Theme.Colors.textPrimary)
            .font(Theme.Fonts.titleLarge)
            .frame(maxWidth: .infinity, alignment: .leading)
            .clipped()
            .padding(.bottom, 16)
            .padding(.horizontal, 16)
    }

    // MARK: - Videos Completed View
    private var videosCompletedView: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let progress = videoContentData.courseProgress {
                HStack(alignment: .center) {
                    CoreAssets.noVideos.swiftUIImage
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 24, height: 16)
                        .padding(.trailing, 4)
                        .foregroundStyle(Theme.Colors.textPrimary)

                    if let total = progress.totalAssignmentsCount,
                       let completed = progress.assignmentsCompleted {
                        Text("\(completed)/\(total)")
                            .font(Theme.Fonts.displaySmall)
                            .padding(.trailing, 8)
                            .foregroundStyle(Theme.Colors.textPrimary)
                    }

                    Text(CourseLocalization.CourseCarousel.videosCompleted)
                        .font(Theme.Fonts.labelLarge)
                        .foregroundStyle(Theme.Colors.textSecondaryDark)
                        .frame(height: 44)
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel(
                    CourseLocalization.Accessibility.videoProgressSection(
                        progress.assignmentsCompleted ?? 0,
                        progress.totalAssignmentsCount ?? 0
                    )
                )
                if progress.totalAssignmentsCount != 0 {
                    CourseProgressView(
                        progress: progress,
                        showCompletedToggle: false,
                        isShowingCompleted: !isHidingCompletedSections,
                        onToggleCompleted: {
                            isHidingCompletedSections.toggle()
                        },
                        onShowCompletedAnalytics: {
                            viewModelContainer.trackShowCompletedSubsectionClicked()
                        },
                        showCompletedText: false
                    )
                }
            }
        }
        .padding(.horizontal, 16)
    }

    // MARK: - Continue Watching View
    private var continueWatchingView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(CourseLocalization.CourseCarousel.continueWatching)
                .font(Theme.Fonts.titleMedium)
                .foregroundStyle(Theme.Colors.textPrimary)

            VStack {
                if let chapter = courseChapter, let video = videoBlock {
                    VideoThumbnailView(
                        thumbnailData: VideoThumbnailData(
                            video: video,
                            chapter: chapter,
                            courseStructure: videoContentData.courseVideosStructure,
                            onVideoTap: { tappedVideo, tappedChapter in
                                viewModelContainer.handleVideoTap(video: tappedVideo, chapter: tappedChapter)
                                viewModelContainer.trackCourseHomeVideoClicked(blockId: video.id,
                                                                               blockName: video.displayName)
                            }
                        ),
                        cornerOnlyTop: true
                    )

                    HStack {
                        Text("\(chapter.displayName)")
                            .font(Theme.Fonts.labelMedium)
                            .foregroundStyle(Theme.Colors.textPrimary)

                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)
                }
            }
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 11)
                        .foregroundColor(Theme.Colors.background)
                    RoundedRectangle(cornerRadius: 11)
                        .stroke(style: .init(lineWidth: 1, lineCap: .round, lineJoin: .round, miterLimit: 1))
                        .foregroundColor(Theme.Colors.cardViewStroke)
                }
            )
        }
        .padding(.horizontal, 16)
    }
}

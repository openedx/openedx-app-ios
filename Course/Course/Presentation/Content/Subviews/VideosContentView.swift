//
//  VideosContentView.swift
//  Course
//
//  Created by  Stepanok Ivan on 27.06.2025.
//

import SwiftUI
import Core
import OEXFoundation
import Kingfisher
import Theme

struct VideosContentView: View {
    
    let videoContentData: VideoContentData
    private let proxy: GeometryProxy
    private let onVideoTap: (CourseBlock, CourseChapter?) -> Void
    private let onDownloadSectionTap: (CourseChapter, DownloadViewState) async -> Void
    private let onTabSelection: (Int) -> Void
    private let onErrorDismiss: () -> Void
    private let onShowCompletedAnalytics: () -> Void
    
    @State private var isHidingCompletedSections: Bool = true
    
    init(
        videoContentData: VideoContentData,
        proxy: GeometryProxy,
        onVideoTap: @escaping (CourseBlock, CourseChapter?) -> Void,
        onDownloadSectionTap: @escaping (CourseChapter, DownloadViewState) async -> Void,
        onTabSelection: @escaping (Int) -> Void,
        onErrorDismiss: @escaping () -> Void,
        onShowCompletedAnalytics: @escaping () -> Void = {}
    ) {
        self.videoContentData = videoContentData
        self.proxy = proxy
        self.onVideoTap = onVideoTap
        self.onDownloadSectionTap = onDownloadSectionTap
        self.onTabSelection = onTabSelection
        self.onErrorDismiss = onErrorDismiss
        self.onShowCompletedAnalytics = onShowCompletedAnalytics
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
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Error View
            if videoContentData.showError {
                VStack {
                    SnackBarView(message: videoContentData.errorMessage)
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
                if videoContentData.isShowProgress {
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
                        if let courseVideosStructure = videoContentData.courseVideosStructure {
                            
                            Spacer(minLength: 16)
                            
                            // MARK: Course Progress (only videos)
                            if let progress = videoContentData.courseProgress,
                               progress.totalAssignmentsCount != 0 {
                                CourseProgressView(
                                    progress: progress,
                                    showCompletedToggle: hasFullyCompletedSections(),
                                    isShowingCompleted: !isHidingCompletedSections,
                                    onToggleCompleted: {
                                        isHidingCompletedSections.toggle()
                                    },
                                    onShowCompletedAnalytics: onShowCompletedAnalytics
                                )
                                .padding(.horizontal, 24)
                            }
                            
                            Spacer(minLength: 16)
                            
                            // MARK: - Video Sections
                            let visibleChapters = getVisibleChapters()
                            
                            if courseVideosStructure.childs.isEmpty && !videoContentData.isShowProgress {
                                // No videos available
                                NoContentAvailable(
                                    type: .video,
                                    action: { onTabSelection(CourseTab.course.id) }
                                )
                                .accessibilityElement(children: .combine)
                                .accessibilityLabel(CourseLocalization.Accessibility.noContentSection)
                            } else {
                                ScrollView {
                                    LazyVStack(alignment: .leading, spacing: 16) {
                                        ForEach(
                                            Array(visibleChapters.enumerated()),
                                            id: \.offset
                                        ) { index, chapter in
                                            
                                            if index == 0 {
                                                Divider()
                                            }
                                            
                                            VideoSectionView(
                                                sectionData: VideoSectionData(
                                                    chapter: chapter,
                                                    sequentialsDownloadState: videoContentData.sequentialsDownloadState
                                                ),
                                                proxy: proxy,
                                                isShowingCompletedVideos: .constant(true),
                                                onVideoTap: onVideoTap,
                                                onDownloadSectionTap: onDownloadSectionTap
                                            )
                                        }
                                    }
                                    .animation(.default, value: isHidingCompletedSections)
                                }
                                .accessibilityElement(children: .contain)
                                .accessibilityLabel(CourseLocalization.Accessibility.videosSection)
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
    let videoContentData = VideoContentData(
        courseVideosStructure: nil,
        courseProgress: nil,
        sequentialsDownloadState: [:],
        isShowProgress: false,
        showError: false,
        errorMessage: nil
    )
    
    GeometryReader { proxy in
        VideosContentView(
            videoContentData: videoContentData,
            proxy: proxy,
            onVideoTap: { _, _ in },
            onDownloadSectionTap: { _, _ in },
            onTabSelection: { _ in },
            onErrorDismiss: { },
            onShowCompletedAnalytics: { }
        )
    }
}
#endif

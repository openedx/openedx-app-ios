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
    private let onVideoTap: (CourseBlock, CourseChapter) -> Void
    private let onDownloadSectionTap: (CourseChapter, DownloadViewState) async -> Void
    private let onTabSelection: (Int) -> Void
    private let onErrorDismiss: () -> Void
    private let onShowCompletedAnalytics: () -> Void
    
    @State private var isShowingCompletedVideos: Bool = false
    
    init(
        videoContentData: VideoContentData,
        proxy: GeometryProxy,
        onVideoTap: @escaping (CourseBlock, CourseChapter) -> Void,
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
                                    showCompletedToggle: true,
                                    isShowingCompleted: isShowingCompletedVideos,
                                    onToggleCompleted: {
                                        isShowingCompletedVideos.toggle()
                                    },
                                    onShowCompletedAnalytics: onShowCompletedAnalytics
                                )
                                .padding(.horizontal, 24)
                                .accessibilityElement(children: .combine)
                                .accessibilityLabel(
                                    CourseLocalization.Accessibility.videoProgressSection(
                                        progress.assignmentsCompleted ?? 0,
                                        progress.totalAssignmentsCount ?? 0
                                    )
                                )
                            }
                            
                            Spacer(minLength: 16)
                            
                            // MARK: - Video Sections
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
                                            Array(courseVideosStructure.childs.enumerated()),
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
                                                isShowingCompletedVideos: $isShowingCompletedVideos,
                                                onVideoTap: onVideoTap,
                                                onDownloadSectionTap: onDownloadSectionTap
                                            )
                                        }
                                    }
                                    .animation(.default, value: isShowingCompletedVideos)
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

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
    
    @StateObject private var viewModel: CourseContainerViewModel
    private let title: String
    private let courseID: String
    private let dateTabIndex: Int
    
    private let proxy: GeometryProxy
    @State private var isShowingCompletedVideos: Bool = false
    
    init(
        viewModel: CourseContainerViewModel,
        proxy: GeometryProxy,
        title: String,
        courseID: String,
        dateTabIndex: Int
    ) {
        self.title = title
        self._viewModel = StateObject(wrappedValue: { viewModel }())
        self.proxy = proxy
        self.courseID = courseID
        self.dateTabIndex = dateTabIndex
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Error View
            if viewModel.showError {
                VStack {
                    SnackBarView(message: viewModel.errorMessage)
                }
                .transition(.move(edge: .bottom))
                .onAppear {
                    doAfter(Theme.Timeout.snackbarMessageLongTimeout) {
                        viewModel.errorMessage = nil
                    }
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel(CourseLocalization.Accessibility.errorMessageSection)
            }
            
            ZStack(alignment: .center) {
                // MARK: - Page Body
                if viewModel.isShowProgress && !viewModel.isShowRefresh {
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
                        if let courseVideosStructure = viewModel.courseVideosStructure {
                            
                            Spacer(minLength: 16)
                            
                            // MARK: Course Progress (only videos)
                            if let progress = courseVideosStructure.courseProgress,
                               progress.totalAssignmentsCount != 0 {
                                CourseProgressView(
                                    progress: progress,
                                    showCompletedToggle: true,
                                    isShowingCompleted: isShowingCompletedVideos,
                                    onToggleCompleted: {
                                        isShowingCompletedVideos.toggle()
                                    }
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
                            if courseVideosStructure.childs.isEmpty && !viewModel.isShowProgress {
                                // No videos available
                                NoContentAvailable(
                                    type: .video,
                                    action: { viewModel.selection = CourseTab.course.id }
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
                                                chapter: chapter,
                                                viewModel: viewModel,
                                                proxy: proxy,
                                                isShowingCompletedVideos: $isShowingCompletedVideos
                                            )
                                            .id("\(chapter.id)_\(viewModel.videoProgressUpdateTrigger)")
                                        }
                                    }
                                    .id("video_list_\(viewModel.videoProgressUpdateTrigger)")
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
        .onReceive(NotificationCenter.default.publisher(for: .onBlockCompletion)) { _ in
            Task {
                await viewModel.getCourseBlocks(courseID: courseID, withProgress: false)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .onVideoProgressUpdated)) { notification in
            guard let userInfo = notification.userInfo,
                  let blockID = userInfo["blockID"] as? String,
                  let progress = userInfo["progress"] as? Double else {
                return
            }
            Task {
                await viewModel.updateVideoProgress(blockID: blockID, progress: progress)
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

#if DEBUG
#Preview {
    let viewModel = CourseContainerViewModel(
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
    
    GeometryReader { proxy in
        VideosContentView(
            viewModel: viewModel,
            proxy: proxy,
            title: "Course title",
            courseID: "",
            dateTabIndex: 2
        )
    }
}
#endif

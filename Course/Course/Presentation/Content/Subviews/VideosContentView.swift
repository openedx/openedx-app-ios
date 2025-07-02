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
    @State private var showingDownloads: Bool = false
    @State private var showingVideoDownloadQuality: Bool = false
    @State private var showingNoWifiMessage: Bool = false
    
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
            }
            
            ZStack(alignment: .center) {
                // MARK: - Page Body
                if viewModel.isShowProgress && !viewModel.isShowRefresh {
                    HStack(alignment: .center) {
                        ProgressBar(size: 40, lineWidth: 8)
                            .padding(.horizontal)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    VStack(alignment: .leading) {
                        if let courseVideosStructure = viewModel.courseVideosStructure {
                            
                            Spacer(minLength: 16)
                            
                            // MARK: Course Progress (only videos)
                            if let progress = courseVideosStructure.courseProgress,
                               progress.totalAssignmentsCount != 0 {
                                CourseProgressView(progress: progress)
                                    .padding(.horizontal, 24)
                            }
                            
                            Spacer(minLength: 16)
                            
                            // MARK: - Video Sections
                            if courseVideosStructure.childs.isEmpty {
                                // No videos available
                                VStack(spacing: 16) {
                                    Spacer()
                                    
                                    Image(systemName: "play.rectangle")
                                        .font(.system(size: 60))
                                        .foregroundColor(Theme.Colors.textSecondary)
                                    
                                    Text(CourseLocalization.Error.videosUnavailable)
                                        .font(Theme.Fonts.titleLarge)
                                        .foregroundColor(Theme.Colors.textPrimary)
                                        .multilineTextAlignment(.center)
                                    
                                    Spacer()
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, 24)
                            } else {
                                ScrollView {
                                    LazyVStack(alignment: .leading, spacing: 16) {
                                        ForEach(courseVideosStructure.childs) { chapter in
                                            VideoSectionView(
                                                chapter: chapter,
                                                viewModel: viewModel,
                                                proxy: proxy
                                            )
                                            
                                            Divider()
                                        }
                                    }
                                }
                            }
                            
                        } else {
                            // Loading or error state
                            VStack(spacing: 16) {
                                Spacer()
                                
                                Image(systemName: "play.rectangle")
                                    .font(.system(size: 60))
                                    .foregroundColor(Theme.Colors.textSecondary)
                                
                                Text(CourseLocalization.Error.videosUnavailable)
                                    .font(Theme.Fonts.titleLarge)
                                    .foregroundColor(Theme.Colors.textPrimary)
                                    .multilineTextAlignment(.center)
                                
                                Spacer()
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 24)
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

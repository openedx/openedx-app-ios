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

//swiftlint: disable for_where
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
                                    LazyVStack(alignment: .leading, spacing: 24) {
                                        ForEach(courseVideosStructure.childs) { chapter in
                                            VideoSectionView(
                                                chapter: chapter,
                                                viewModel: viewModel,
                                                proxy: proxy
                                            )
                                        }
                                    }
                                    .padding(.horizontal, 24)
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

// MARK: - Video Section View
struct VideoSectionView: View {
    let chapter: CourseChapter
    @ObservedObject var viewModel: CourseContainerViewModel
    let proxy: GeometryProxy
    
    private var allVideos: [CourseBlock] {
        chapter.childs.flatMap { $0.childs.flatMap { $0.childs } }
    }
    
    private var completedVideos: [CourseBlock] {
        allVideos.filter { $0.completion >= 1.0 }
    }
    
    private var firstUnwatchedVideo: CourseBlock? {
        allVideos.first { $0.completion == 0.0 }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // MARK: - Section Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(chapter.displayName)
                        .font(Theme.Fonts.titleMedium)
                        .foregroundColor(Theme.Colors.textPrimary)
                        .lineLimit(2)
                    
                    Text("\(completedVideos.count) / \(allVideos.count) Completed")
                        .font(Theme.Fonts.bodySmall)
                        .foregroundColor(Theme.Colors.textSecondary)
                }
                
                Spacer()
                
                // Download button for section
                if canDownloadSection,
                   let state = downloadButtonState {
                    Button(action: {
                        downloadSection(state: state)
                    }) {
                        switch state {
                        case .available:
                            DownloadAvailableView()
                        case .downloading:
                            DownloadProgressView()
                        case .finished:
                            DownloadFinishedView()
                        }
                    }
                }
            }
            
            // MARK: - Video Thumbnails Scroll
            ScrollViewReader { scrollProxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 12) {
                        ForEach(allVideos) { video in
                            VideoThumbnailView(
                                video: video,
                                viewModel: viewModel,
                                chapter: chapter
                            )
                            .id(video.id)
                        }
                    }
                    .padding(.horizontal, 4)
                }
                .onAppear {
                    // Auto-scroll to first unwatched video if there are completed videos
                    if completedVideos.count > 0,
                       let firstUnwatched = firstUnwatchedVideo {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                scrollProxy.scrollTo(firstUnwatched.id, anchor: .leading)
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Download Logic
    private var canDownloadSection: Bool {
        chapter.childs.contains { sequential in
            viewModel.sequentialsDownloadState[sequential.id] != nil
        }
    }
    
    private var downloadButtonState: DownloadViewState? {
        if canDownloadSection {
            var downloads: [DownloadViewState] = []
            for sequential in chapter.childs {
                if let state = viewModel.sequentialsDownloadState[sequential.id] {
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
    
    private func downloadSection(state: DownloadViewState) {
        Task {
            await viewModel.onDownloadViewTap(chapter: chapter, state: state)
        }
    }
}

// MARK: - Video Thumbnail View
struct VideoThumbnailView: View {
    let video: CourseBlock
    @ObservedObject var viewModel: CourseContainerViewModel
    let chapter: CourseChapter
    
    private var thumbnailURL: URL? {
        if let youtubeVideo = video.encodedVideo?.youtube,
           let youtubeURL = youtubeVideo.url,
           let videoID = extractYouTubeVideoID(from: youtubeURL) {
            return URL(string: "https://img.youtube.com/vi/\(videoID)/hqdefault.jpg")
        }
        return nil
    }
    
    var body: some View {
        Button(action: {
            openVideo()
        }) {
            ZStack {
                // MARK: - Thumbnail Image
                KFImage(thumbnailURL)
                    .placeholder {
                        Rectangle()
                            .fill(Theme.Colors.textSecondary.opacity(0.3))
                            .overlay(
                                Image(systemName: "play.rectangle")
                                    .font(.system(size: 32))
                                    .foregroundColor(Theme.Colors.textSecondary)
                            )
                    }
                    .resizable()
                    .aspectRatio(16/9, contentMode: .fit)
                    .frame(width: 192, height: 108)
                    .clipped()
                    .cornerRadius(10)
                
                // MARK: - Play Button Overlay
                Circle()
                    .fill(Color.black.opacity(0.6))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: "play.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                            .offset(x: 2) // Slight offset to center visually
                    )
                
                // MARK: - Completion Indicator
                if video.completion >= 1.0 {
                    ZStack(alignment: .bottomTrailing) {
                        
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(Theme.Colors.success)
                            .background(
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 16, height: 16)
                            )
                        
                        // Progress bar for completed videos
                        Rectangle()
                            .fill(Theme.Colors.success)
                            .frame(height: 4)
                            .cornerRadius(2)
                            .padding(.horizontal, 4)
                            .padding(.bottom, 4)
                    }
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func openVideo() {
        // Find indices for navigation
        guard let chapterIndex = findChapterIndex(),
              let sequentialIndex = findSequentialIndex(),
              let verticalIndex = findVerticalIndex(),
              let courseStructure = viewModel.courseStructure else {
            return
        }
        
        viewModel.router.showCourseUnit(
            courseName: courseStructure.displayName,
            blockId: video.id,
            courseID: courseStructure.id,
            verticalIndex: verticalIndex,
            chapters: courseStructure.childs,
            chapterIndex: chapterIndex,
            sequentialIndex: sequentialIndex
        )
    }
    
    private func findChapterIndex() -> Int? {
        return viewModel.courseStructure?.childs.firstIndex { $0.id == chapter.id }
    }
    
    private func findSequentialIndex() -> Int? {
        for sequential in chapter.childs {
            if sequential.childs.contains(where: { vertical in
                vertical.childs.contains { $0.id == video.id }
            }) {
                return chapter.childs.firstIndex { $0.id == sequential.id }
            }
        }
        return nil
    }
    
    private func findVerticalIndex() -> Int? {
        for sequential in chapter.childs {
            for vertical in sequential.childs {
                if vertical.childs.contains(where: { $0.id == video.id }) {
                    return sequential.childs.firstIndex { $0.id == vertical.id }
                }
            }
        }
        return nil
    }
}

// MARK: - Helper Functions
private func extractYouTubeVideoID(from urlString: String) -> String? {
    guard let url = URL(string: urlString) else { return nil }
    
    if let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems {
        return queryItems.first(where: { $0.name == "v" })?.value
    }
    
    // Handle youtu.be format
    if url.host == "youtu.be" {
        return url.lastPathComponent
    }
    
    return nil
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
//swiftlint: enable for_where

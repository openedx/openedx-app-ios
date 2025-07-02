//
//  VideoSectionView.swift
//  Course
//
//  Created by Ivan Stepanok on 02.07.2025.
//

import SwiftUI
import Core
import Theme

struct VideoSectionView: View {
    let chapter: CourseChapter
    @ObservedObject var viewModel: CourseContainerViewModel
    let proxy: GeometryProxy
    
    @State private var uiScrollView: UIScrollView?
    
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
                        .font(Theme.Fonts.titleSmall)
                        .foregroundColor(Theme.Colors.textPrimary)
                        .lineLimit(2)
                    
                    Text("\(completedVideos.count) / \(allVideos.count) Completed")
                        .font(Theme.Fonts.bodySmall)
                        .foregroundColor(Theme.Colors.textPrimary)
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
            .padding(.horizontal, 22)
            
            // MARK: - Video Thumbnails Scroll
            ScrollViewReader { scrollProxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 0) {
                        ForEach(Array(allVideos.enumerated()), id: \.offset) { index, video in
                            VideoThumbnailView(
                                video: video,
                                viewModel: viewModel,
                                chapter: chapter
                            )
                            .padding(.leading, index == 0 ? 24 : 8)
                            .id(video.id)
                        }
                    }
                }
                .introspect(.scrollView, on: .iOS(.v16, .v17, .v18)) { scroll in
                    guard uiScrollView == nil else { return }
                    print(">>>> INTROSPECT", scroll)
                    DispatchQueue.main.async {
                        uiScrollView = scroll
                    }
                }
                .onAppear {
                    guard let firstUnwatched = firstUnwatchedVideo else { return }
                    
                    // ② обычный scrollTo
//                    withAnimation(.easeInOut(duration: 0.5)) {
                        scrollProxy.scrollTo(firstUnwatched.id, anchor: .leading)
//                    }
                    
                    // ③ добавляем точный сдвиг 24 pt
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        guard let scroll = uiScrollView else { return }
                        let newX = max(scroll.contentOffset.x - 20, 0)
                        scroll.setContentOffset(CGPoint(x: newX, y: 0), animated: true)
                    }
                }
//                .onAppear {
//                    // Auto-scroll to first unwatched video if there are completed videos
//                    if completedVideos.count > 0,
//                       let firstUnwatched = firstUnwatchedVideo {
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                            withAnimation(.easeInOut(duration: 0.5)) {
//                                scrollProxy.scrollTo(firstUnwatched.id, anchor: .leading)
//                            }
//                        }
//                    }
//                }
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
        VideoSectionView(
            chapter: CourseChapter(
                blockId: "1",
                id: "2",
                displayName: "Video",
                type: .video,
                childs: []
            ),
            viewModel: viewModel,
            proxy: proxy
        )
    }
}
#endif

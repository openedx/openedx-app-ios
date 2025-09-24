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

    let sectionData: VideoSectionData
    let proxy: GeometryProxy
    @Binding var isShowingCompletedVideos: Bool
    let onVideoTap: (CourseBlock, CourseChapter?) -> Void
    let onDownloadSectionTap: (CourseChapter, DownloadViewState) async -> Void
    
    private var chapter: CourseChapter {
        sectionData.chapter
    }
    
    @State private var uiScrollView: UIScrollView?
    
    private var allVideos: [CourseBlock] {
        chapter.childs.flatMap { $0.childs.flatMap { $0.childs } }
    }
    
    private var completedVideos: [CourseBlock] {
        allVideos.filter { $0.completion >= 1.0 }
    }
    
    private var visibleVideos: [CourseBlock] {
        return allVideos
    }
    
    private var firstUnwatchedVideo: CourseBlock? {
        allVideos.first { $0.completion == 0.0 }
    }
    
    private var shouldShowSection: Bool {
        !allVideos.isEmpty
    }
    
    var body: some View {
        if shouldShowSection {
            VStack(alignment: .leading, spacing: 12) {
                // MARK: - Section Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(chapter.displayName)
                            .font(Theme.Fonts.titleSmall)
                            .foregroundColor(Theme.Colors.textPrimary)
                            .lineLimit(2)
                        
                        Text(
                            CourseLocalization.Course.progressWatched(
                                completedVideos.count,
                                allVideos.count
                            )
                        )
                            .font(Theme.Fonts.bodySmall)
                            .foregroundColor(Theme.Colors.textPrimary)
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel(
                        CourseLocalization.Accessibility.videoSectionHeader(
                            chapter.displayName,
                            completedVideos.count,
                            allVideos.count
                        )
                    )
                    
                    Spacer()
                    
                    // Download button for section
                    if canDownloadSection,
                       let state = downloadButtonState {
                        Button(action: {
                            Task {
                                await onDownloadSectionTap(chapter, state)
                            }
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
                        .accessibilityLabel(
                            CourseLocalization.Accessibility
                                .downloadSectionButton(getDownloadStateAccessibilityLabel(state))
                        )
                    }
                }
                .padding(.horizontal, 22)
                
                // MARK: - Video Thumbnails Scroll
                ScrollViewReader { scrollProxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 0) {
                            ForEach(Array(visibleVideos.enumerated()), id: \.element.id) { index, video in
                                VideoThumbnailView(
                                    thumbnailData: VideoThumbnailData(
                                        video: video,
                                        chapter: chapter,
                                        courseStructure: nil,
                                        onVideoTap: onVideoTap
                                    )
                                )
                                .padding(.leading, index == 0 ? 24 : 8)
                                .id(video.id)
                                
                                if index == visibleVideos.count - 1 {
                                    Spacer(minLength: 500)
                                }
                            }
                        }
                    }
                    .introspect(.scrollView, on: .iOS(.v16, .v17, .v18, .v26)) { scroll in
                        DispatchQueue.main.async {
                            uiScrollView = scroll
                        }
                    }
                    .onAppear {
                        guard isShowingCompletedVideos else {
                            scrollProxy.scrollTo(visibleVideos.first, anchor: .leading)
                            return
                        }
                        scrollToFirstUnwatchedVideo { id in
                            scrollProxy.scrollTo(id, anchor: .leading)
                        }
                    }
                    .onChange(of: isShowingCompletedVideos) { show in
                        if show {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                scrollToFirstUnwatchedVideo { id in
                                    scrollProxy.scrollTo(id, anchor: .leading)
                                }
                            }
                        } else {
                            guard let scroll = uiScrollView else { return }
                            scroll.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                        }
                    }
                }
                Divider()
                    .padding(.top, 16)
            }
        }
    }
    
    private func scrollToFirstUnwatchedVideo(scrollTo: @escaping (String) -> Void) {
        guard let firstUnwatched = firstUnwatchedVideo,
              visibleVideos.contains(where: { $0.id == firstUnwatched.id }) else { return }
        
        scrollTo(firstUnwatched.id)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            guard let scroll = uiScrollView else { return }
            let newX = max(scroll.contentOffset.x - 16, 0)
            scroll.setContentOffset(CGPoint(x: newX, y: 0), animated: true)
        }
    }
    
    // MARK: - Download Logic
    private var canDownloadSection: Bool {
        chapter.childs.contains { sequential in
            sectionData.sequentialsDownloadState[sequential.id] != nil
        }
    }
    
    private func getDownloadStateAccessibilityLabel(_ state: DownloadViewState) -> String {
        switch state {
        case .available:
            return CourseLocalization.Course.TotalProgress.avaliableToDownload
        case .downloading:
            return CourseLocalization.Course.TotalProgress.downloading
        case .finished:
            return CourseLocalization.Course.TotalProgress.downloaded
        }
    }
    
    private var downloadButtonState: DownloadViewState? {
        if canDownloadSection {
            var downloads: [DownloadViewState] = []
            for sequential in chapter.childs {
                if let state = sectionData.sequentialsDownloadState[sequential.id] {
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
}

#if DEBUG
#Preview {
    GeometryReader { proxy in
        VideoSectionView(
            sectionData: VideoSectionData(
                chapter: CourseChapter(
                    blockId: "1",
                    id: "2",
                    displayName: "Video",
                    type: .video,
                    childs: []
                ),
                sequentialsDownloadState: [:]
            ),
            proxy: proxy,
            isShowingCompletedVideos: .constant(true),
            onVideoTap: { _, _ in },
            onDownloadSectionTap: { _, _ in }
        )
    }
}
#endif

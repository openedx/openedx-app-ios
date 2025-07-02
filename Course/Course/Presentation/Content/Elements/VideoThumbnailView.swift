//
//  VideoThumbnailView.swift
//  Course
//
//  Created by Ivan Stepanok on 02.07.2025.
//

import SwiftUI
import Core
import Theme
import Kingfisher

struct VideoThumbnailView: View {
    let video: CourseBlock
    @ObservedObject var viewModel: CourseContainerViewModel
    let chapter: CourseChapter
    
    private let thumbnailWidth: CGFloat = 192
    private let thumbnailHeight: CGFloat = 108
    
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
                        Theme.Colors.commentCellBackground
                    }
                    .resizable()
                    .aspectRatio(16/9, contentMode: .fill)
                    .scaleEffect(y: 1.35, anchor: .center)
                    .clipped()
                    .cornerRadius(10)
                
                // MARK: - Play Button Overlay
                CoreAssets.videoPlayButton.swiftUIImage
                
                // MARK: - Completion Indicator
                if video.completion >= 1.0 {
                    ZStack(alignment: .trailing) {
                        // Progress bar for completed videos
                        Rectangle()
                            .fill(Theme.Colors.success)
                            .frame(height: 4)
                            .cornerRadius(2)
                            .padding(.horizontal, 4)
                            .padding(.bottom, 4)
                        
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(Theme.Colors.success)
                            .background(
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 14, height: 14)
                            )
                            .offset(y: -3)
                    }
                    .padding(.horizontal, 2)
                    .frame(width: thumbnailWidth, height: thumbnailHeight, alignment: .bottomTrailing)
                }
            }
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(lineWidth: video.completion >= 1.0 ? 2 : 0)
                    .foregroundStyle(Theme.Colors.success)
            }
            .frame(width: thumbnailWidth, height: thumbnailHeight)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(1)
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
        chapter.childs.firstIndex { sequential in
            sequential.childs.contains { vertical in
                vertical.childs.contains { $0.id == video.id }
            }
        }
    }
    
    private func findVerticalIndex() -> Int? {
        for sequential in chapter.childs {
            for vertical in sequential.childs
            where vertical.childs.contains(where: { $0.id == video.id }) {
                
                return sequential.childs.firstIndex { $0.id == vertical.id }
            }
        }
        return nil
    }
}

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
    
    VideoThumbnailView(
        video: CourseBlock(
            blockId: "1",
            id: "1",
            courseId: "1",
            graded: true,
            due: Date(),
            completion: 1,
            type: .video,
            displayName: "Video",
            studentUrl: "",
            webUrl: "",
            encodedVideo: CourseBlockEncodedVideo(
                fallback: nil,
                youtube: CourseBlockVideo(
                    url: "https://www.youtube.com/watch?v=uFdWM1a44C8",
                    fileSize: 999,
                    streamPriority: 1,
                    type: .youtube
                ),
                desktopMP4: nil,
                mobileHigh: nil,
                mobileLow: nil,
                hls: nil
            ),
            multiDevice: true,
            offlineDownload: nil
        ),
        viewModel: viewModel,
        chapter: CourseChapter(
            blockId: "1",
            id: "1",
            displayName: "Chapter",
            type: .video,
            childs: []
        )
    )
}

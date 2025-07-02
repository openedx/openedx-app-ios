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
import AVFoundation

struct VideoThumbnailView: View, Equatable {
    
    nonisolated static func == (lhs: VideoThumbnailView, rhs: VideoThumbnailView) -> Bool {
        lhs.video == rhs.video
    }

    let video: CourseBlock
    @ObservedObject var viewModel: CourseContainerViewModel
    let chapter: CourseChapter
    
    private let thumbnailWidth: CGFloat = 192
    private let thumbnailHeight: CGFloat = 108
    
    @State private var thumbnailImage: UIImage?
    @State private var isGeneratingThumbnail = false
    
    private var thumbnailURL: URL? {
        // First priority: YouTube thumbnail
        if let youtubeVideo = video.encodedVideo?.youtube,
           let youtubeURL = youtubeVideo.url,
           let videoID = extractYouTubeVideoID(from: youtubeURL) {
            return URL(string: "https://img.youtube.com/vi/\(videoID)/hqdefault.jpg")
        }
        
        return nil
    }
    
    private func getVideoURL() -> URL? {
        let encodedVideo = video.encodedVideo
        
        // Priority order for video sources
        let videoSources = [
            encodedVideo?.desktopMP4,
            encodedVideo?.mobileHigh,
            encodedVideo?.mobileLow,
            encodedVideo?.hls,
            encodedVideo?.fallback
        ].compactMap { $0 }
        
        for videoSource in videoSources {
            if let urlString = videoSource.url, !urlString.isEmpty {
                return URL(string: urlString)
            }
        }
        
        return nil
    }
    
    var body: some View {
        Button(action: {
            openVideo()
        }) {
            ZStack {
                // MARK: - Thumbnail Image
                thumbnailImageView()
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
        .task {
            // Generate video thumbnail if needed
            if thumbnailURL == nil, let videoURL = getVideoURL() {
                await generateVideoThumbnailIfNeeded(from: videoURL)
            }
        }
    }
    
    // MARK: - Helper Functions
    @ViewBuilder
    private func thumbnailImageView() -> some View {
        if let thumbnailURL = thumbnailURL {
            // For YouTube thumbnails
            KFImage(thumbnailURL)
                .placeholder {
                    Theme.Colors.commentCellBackground
                }
                .resizable()
        } else if let thumbnailImage = thumbnailImage {
            // For generated video thumbnails
            Image(uiImage: thumbnailImage)
                .resizable()
        } else if isGeneratingThumbnail {
            // Loading state
            ZStack {
                Theme.Colors.commentCellBackground
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Theme.Colors.accentColor))
            }
        } else {
            // Default placeholder
            Theme.Colors.commentCellBackground
        }
    }
    
    private func generateVideoThumbnailIfNeeded(from url: URL) async {
        let cacheKey = "video_thumbnail_\(url.absoluteString.hash)"
        
        // Check if thumbnail is already cached (both memory and disk)
        do {
            let cacheResult = try await ImageCache.default.retrieveImage(forKey: cacheKey)
            if let cachedImage = cacheResult.image {
                await MainActor.run {
                    self.thumbnailImage = cachedImage
                }
                return
            }
        } catch {
            // Cache retrieval failed, continue to generate new thumbnail
        }
        
        await MainActor.run {
            self.isGeneratingThumbnail = true
        }
        
        do {
            let image = try await generateVideoThumbnail(from: url)
            
            // Cache the generated thumbnail to both memory and disk
            try await ImageCache.default.store(
                image,
                forKey: cacheKey,
                toDisk: true
            )
            
            await MainActor.run {
                self.thumbnailImage = image
                self.isGeneratingThumbnail = false
            }
        } catch {
            await MainActor.run {
                self.isGeneratingThumbnail = false
            }
        }
    }
    
    private func generateVideoThumbnail(from url: URL) async throws -> UIImage {
        let asset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        imageGenerator.requestedTimeToleranceBefore = .zero
        imageGenerator.requestedTimeToleranceAfter = .zero
        
        let time = CMTime(seconds: 1.0, preferredTimescale: 600)
        
        return try await withCheckedThrowingContinuation { continuation in
            imageGenerator.generateCGImagesAsynchronously(
                forTimes: [NSValue(time: time)]) { _, cgImage, _, _, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let cgImage = cgImage else {
                    continuation.resume(
                        throwing: NSError(
                            domain: "VideoThumbnailError", code: -1,
                            userInfo: [NSLocalizedDescriptionKey: "Failed to generate thumbnail"]
                        )
                    )
                    return
                }
                
                let image = UIImage(cgImage: cgImage)
                continuation.resume(returning: image)
            }
        }
    }
    
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
        // Find indices for navigation using full course structure
        guard let chapterIndex = findChapterIndexInFullStructure(),
              let sequentialIndex = findSequentialIndexInFullStructure(),
              let verticalIndex = findVerticalIndexInFullStructure(),
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
    
    private func findChapterIndexInFullStructure() -> Int? {
        guard let courseStructure = viewModel.courseStructure else { return nil }
        
        // Find the chapter that contains this video in the full structure
        return courseStructure.childs.firstIndex { fullChapter in
            fullChapter.childs.contains { sequential in
                sequential.childs.contains { vertical in
                    vertical.childs.contains { $0.id == video.id }
                }
            }
        }
    }
    
    private func findSequentialIndexInFullStructure() -> Int? {
        guard let courseStructure = viewModel.courseStructure else { return nil }
        
        // Find the chapter and sequential that contains this video in the full structure
        for fullChapter in courseStructure.childs {
            if let sequentialIndex = fullChapter.childs.firstIndex(where: { sequential in
                sequential.childs.contains { vertical in
                    vertical.childs.contains { $0.id == video.id }
                }
            }) {
                return sequentialIndex
            }
        }
        return nil
    }
    
    private func findVerticalIndexInFullStructure() -> Int? {
        guard let courseStructure = viewModel.courseStructure else { return nil }
        
        // Find the vertical that contains this video in the full structure
        for fullChapter in courseStructure.childs {
            for sequential in fullChapter.childs {
                if let verticalIndex = sequential.childs.firstIndex(where: { vertical in
                    vertical.childs.contains { $0.id == video.id }
                }) {
                    return verticalIndex
                }
            }
        }
        return nil
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
                fallback: CourseBlockVideo(
                    url: "https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4",
                    fileSize: 1000000,
                    streamPriority: 2,
                    type: .fallback
                ),
                youtube: CourseBlockVideo(
                    url: "https://www.youtube.com/watch?v=uFdWM1a44C8",
                    fileSize: 999,
                    streamPriority: 1,
                    type: .youtube
                ),
                desktopMP4: CourseBlockVideo(
                    url: "https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_2mb.mp4",
                    fileSize: 2000000,
                    streamPriority: 3,
                    type: .desktopMP4
                ),
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
#endif

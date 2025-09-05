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
import Swinject

struct VideoThumbnailView: View {
    
    let thumbnailData: VideoThumbnailData
    
    private var video: CourseBlock {
        thumbnailData.video
    }
    
    private var chapter: CourseChapter? {
        thumbnailData.chapter
    }
    
    var thumbnailWidth: CGFloat = 192
    var thumbnailHeight: CGFloat = 108
    var isCurrentVideo = false

    @State private var thumbnailImage: UIImage?
    @State private var isGeneratingThumbnail = false

    private var thumbnailService: VideoThumbnailServiceProtocol {
        Container.shared.resolve(VideoThumbnailServiceProtocol.self)!
    }
    
    private var thumbnailURL: URL? {
        // First priority: YouTube thumbnail
        if let youtubeVideo = video.encodedVideo?.youtube,
           let youtubeURL = youtubeVideo.url,
           let videoID = youtubeURL.youtubeVideoID() {
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
            if !isCurrentVideo {
                openVideo()
            }
        }) {
            ZStack {
                // MARK: - Thumbnail Image
                thumbnailImageView()
                    .aspectRatio(16/9, contentMode: .fill)
                    .scaleEffect(y: 1.35, anchor: .center)
                    .clipped()
                    .cornerRadius(10)
                
                Text(video.displayName)
                    .lineLimit(2)
                    .font(Theme.Fonts.bodySmall)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 11)
                    .padding(.top, 11)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                
                // MARK: - Play Button Overlay
                if !isCurrentVideo {
                    CoreAssets.videoPlayButton.swiftUIImage
                }

                // MARK: - Progress Indicator
                progressIndicatorView()
                    .padding(.horizontal, 2)
                    .frame(width: thumbnailWidth, height: thumbnailHeight, alignment: .bottomTrailing)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(lineWidth: isCurrentVideo ? 3 : (video.completion >= 1.0 ? 2 : 0))
                    .foregroundStyle(isCurrentVideo ? Theme.Colors.accentColor : Theme.Colors.success)
            }
            .frame(width: thumbnailWidth, height: thumbnailHeight)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(1)
        .accessibilityLabel(getAccessibilityLabel())
        .accessibilityHint(CourseLocalization.Accessibility.videoThumbnailHint)
        .task {
            // Generate video thumbnail if needed
            if thumbnailURL == nil, let videoURL = getVideoURL() {
                await generateVideoThumbnailIfNeeded(from: videoURL)
            }
        }
    }
    
    // MARK: - Helper Functions
    @ViewBuilder
    private func progressIndicatorView() -> some View {
        let effectiveProgress = getEffectiveProgress()
        let shouldShowAsCompleted = video.completion >= 0.9
        let shouldShowGreenBar = shouldShowAsCompleted && (
            video.localVideoProgress == 0 || video.localVideoProgress >= 0.9
        )
        
        if shouldShowAsCompleted {
            // Video completed on server - show checkmark
            ZStack(alignment: .trailing) {
                if shouldShowGreenBar {
                    // Show green bar when no local progress OR local progress >= 90%
                    Rectangle()
                        .fill(Theme.Colors.success)
                        .frame(height: 4)
                        .cornerRadius(2)
                        .padding(.horizontal, 4)
                        .padding(.bottom, 4)
                } else if effectiveProgress > 0 {
                    // Show local progress bar when rewatching
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 4)
                            .cornerRadius(2)
                            .padding(.horizontal, 4)
                            .padding(.bottom, 4)
                        
                        Rectangle()
                            .fill(Theme.Colors.accentColor)
                            .frame(width: max(8, thumbnailWidth * effectiveProgress - 8), height: 4)
                            .cornerRadius(2)
                            .padding(.horizontal, 4)
                            .padding(.bottom, 4)
                    }
                }
                
                // Always show checkmark for completed videos
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
        } else if effectiveProgress > 0 {
            // Partially watched - show progress bar
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 4)
                    .cornerRadius(2)
                    .padding(.horizontal, 4)
                    .padding(.bottom, 4)
                
                Rectangle()
                    .fill(Theme.Colors.accentColor)
                    .frame(width: max(8, thumbnailWidth * effectiveProgress - 8), height: 4)
                    .cornerRadius(2)
                    .padding(.horizontal, 4)
                    .padding(.bottom, 4)
            }
        }
    }
    
    private func getEffectiveProgress() -> Double {
        let effectiveProgress: Double
        
        // Always prioritize local progress if available
        if video.localVideoProgress > 0 {
            effectiveProgress = video.localVideoProgress
        } else if video.completion >= 1.0 {
            // If no local progress but completed on server, show as 100%
            effectiveProgress = 1.0
        } else {
            // Not completed and no local progress
            effectiveProgress = 0.0
        }
        
        return effectiveProgress
    }
    
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
        await MainActor.run {
            self.isGeneratingThumbnail = true
        }
        
        let image = await thumbnailService.generateVideoThumbnailIfNeeded(from: url)
        
        await MainActor.run {
            self.thumbnailImage = image
            self.isGeneratingThumbnail = false
        }
    }
    
    private func openVideo() {
        thumbnailData.onVideoTap(video, chapter)
    }
    
    private func getAccessibilityLabel() -> String {
        let baseLabel = CourseLocalization.Accessibility.videoThumbnail(video.displayName)
        
        if video.completion >= 1.0 {
            return CourseLocalization.Accessibility.videoThumbnailCompleted(baseLabel)
        } else if getEffectiveProgress() > 0 {
            let progressPercent = Int(getEffectiveProgress() * 100)
            return CourseLocalization.Accessibility.videoThumbnailInProgress(baseLabel, progressPercent)
        } else {
            return CourseLocalization.Accessibility.videoThumbnailNotStarted(baseLabel)
        }
    }
}

#if DEBUG
#Preview {
    VideoThumbnailView(
        thumbnailData: VideoThumbnailData(
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
            chapter: CourseChapter(
                blockId: "1",
                id: "1",
                displayName: "Chapter",
                type: .video,
                childs: []
            ),
            courseStructure: nil,
            onVideoTap: { _, _ in }
        )
    )
}
#endif

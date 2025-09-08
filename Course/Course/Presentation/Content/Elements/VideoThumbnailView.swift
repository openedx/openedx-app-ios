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
    
    private var video: CourseBlock { thumbnailData.video }
    private var chapter: CourseChapter { thumbnailData.chapter }
    
    private let thumbnailWidth: CGFloat = 192
    private let thumbnailHeight: CGFloat = 108
    
    @State private var thumbnailImage: UIImage?
    @State private var isGeneratingThumbnail = false
    
    private var thumbnailService: VideoThumbnailServiceProtocol {
        Container.shared.resolve(VideoThumbnailServiceProtocol.self)!
    }
    
    private var fixedSize: Bool

    init(
        thumbnailData: VideoThumbnailData,
        thumbnailImage: UIImage? = nil,
        isGeneratingThumbnail: Bool = false,
        fixedSize: Bool = true
    ) {
        self.thumbnailData = thumbnailData
        self.thumbnailImage = thumbnailImage
        self.isGeneratingThumbnail = isGeneratingThumbnail
        self.fixedSize = fixedSize
    }

    var body: some View {
        Button(action: openVideo) {
            Group {
                if !fixedSize {
                    content
                        .frame(width: thumbnailWidth, height: thumbnailHeight)
                } else {
                    content
                        .aspectRatio(16/9, contentMode: .fit)
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .buttonStyle(.plain)
        .padding(1)
        .accessibilityLabel(getAccessibilityLabel())
        .accessibilityHint(CourseLocalization.Accessibility.videoThumbnailHint)
        .task {
            if thumbnailURL == nil, let videoURL = getVideoURL() {
                await generateVideoThumbnailIfNeeded(from: videoURL)
            }
        }
    }
    
    private var content: some View {
        ZStack {
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
            
            CoreAssets.videoPlayButton.swiftUIImage
            
            progressIndicatorView()
                .padding(.horizontal, 2)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(lineWidth: video.completion >= 1.0 ? 2 : 0)
                .foregroundStyle(Theme.Colors.success)
        }
    }

    private var thumbnailURL: URL? {
        if let youtubeVideo = video.encodedVideo?.youtube,
             let youtubeURL = youtubeVideo.url,
             let videoID = youtubeURL.youtubeVideoID() {
            return URL(string: "https://img.youtube.com/vi/\(videoID)/hqdefault.jpg")
        }
        return nil
    }
    
    private func getVideoURL() -> URL? {
        let sources = [
            video.encodedVideo?.desktopMP4,
            video.encodedVideo?.mobileHigh,
            video.encodedVideo?.mobileLow,
            video.encodedVideo?.hls,
            video.encodedVideo?.fallback
        ].compactMap { $0 }
        
        for src in sources {
            if let str = src.url, !str.isEmpty {
                return URL(string: str)
            }
        }
        return nil
    }

    @ViewBuilder
    private func thumbnailImageView() -> some View {
        if let url = thumbnailURL {
            KFImage(url)
                .placeholder { Theme.Colors.commentCellBackground }
                .resizable()
        } else if let img = thumbnailImage {
            Image(uiImage: img).resizable()
        } else if isGeneratingThumbnail {
            ZStack {
                Theme.Colors.commentCellBackground
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Theme.Colors.accentColor))
            }
        } else {
            Theme.Colors.commentCellBackground
        }
    }
    
    @ViewBuilder
    private func progressIndicatorView() -> some View {
        GeometryReader { geometry in
            let progress = getEffectiveProgress()
            let done = video.completion >= 0.9
            let greenBar = done && (video.localVideoProgress == 0 || video.localVideoProgress >= 0.9)
            let availableWidth = fixedSize ? thumbnailWidth : geometry.size.width

            if done {
                ZStack(alignment: .trailing) {
                    if greenBar {
                        Rectangle()
                            .fill(Theme.Colors.success)
                            .frame(height: 4)
                            .cornerRadius(2)
                            .padding(.horizontal, 4)
                            .padding(.bottom, 4)
                    } else if progress > 0 {
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 4)
                                .cornerRadius(2)
                                .padding(.horizontal, 4)
                                .padding(.bottom, 4)
                            
                            Rectangle()
                                .fill(Theme.Colors.accentColor)
                                .frame(width: max(8, availableWidth * progress - 8),
                                       height: 4)
                                .cornerRadius(2)
                                .padding(.horizontal, 4)
                                .padding(.bottom, 4)
                        }
                    }
                    
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(Theme.Colors.success)
                        .background(Circle().fill(Color.white).frame(width: 14, height: 14))
                        .offset(y: -3)
                }
            } else if progress > 0 {
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 4)
                        .cornerRadius(2)
                        .padding(.horizontal, 4)
                        .padding(.bottom, 4)
                    
                    Rectangle()
                        .fill(Theme.Colors.accentColor)
                        .frame(width: max(8, availableWidth * progress - 8),
                               height: 4)
                        .cornerRadius(2)
                        .padding(.horizontal, 4)
                        .padding(.bottom, 4)
                }
            }
        }
    }
    
    private func getEffectiveProgress() -> Double {
        if video.localVideoProgress > 0 {
            return video.localVideoProgress
        } else if video.completion >= 1.0 {
            return 1.0
        } else {
            return 0.0
        }
    }
    
    private func generateVideoThumbnailIfNeeded(from url: URL) async {
        await MainActor.run { isGeneratingThumbnail = true }
        let img = await thumbnailService.generateVideoThumbnailIfNeeded(from: url)
        await MainActor.run {
            thumbnailImage = img
            isGeneratingThumbnail = false
        }
    }
    
    private func openVideo() {
        thumbnailData.onVideoTap(video, chapter)
    }
    
    private func getAccessibilityLabel() -> String {
        let base = CourseLocalization.Accessibility.videoThumbnail(video.displayName)
        if video.completion >= 1.0 {
            return CourseLocalization.Accessibility.videoThumbnailCompleted(base)
        } else if getEffectiveProgress() > 0 {
            return CourseLocalization.Accessibility.videoThumbnailInProgress(
                base,
                Int(getEffectiveProgress() * 100)
            )
        } else {
            return CourseLocalization.Accessibility.videoThumbnailNotStarted(base)
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

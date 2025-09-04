import Foundation
import SwiftUI
import Core
import OEXFoundation
import Theme

struct VideoNavigationView: View {
    @ObservedObject var viewModel: CourseUnitViewModel
    @Binding var currentBlock: CourseBlock?
    @State private var uiScrollView: UIScrollView?
    @State private var isShowRefresh = true
    let block: CourseBlock

    var body: some View {
        if isShowRefresh {
            RefreshProgressView(isShowRefresh: $isShowRefresh)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        isShowRefresh = false
                    }
                }
        } else {
            videoNavigationView(block: block)
                .padding(.bottom, 17)

            Divider()
                .padding(.bottom, 16)

            HStack {
                Text(viewModel.createBreadCrumpsForVideoNavigation(video: block))
                    .font(Theme.Fonts.bodySmall)
                    .foregroundStyle(Theme.Colors.textPrimary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .padding(.bottom, 8)
                    .padding(.horizontal, 16)
                Spacer()
            }
        }
    }

    @ViewBuilder
    private func videoNavigationView(block: CourseBlock) -> some View {
        ScrollViewReader { scrollProxy in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 0) {
                    ForEach(Array(viewModel.allVideosForNavigation.enumerated()), id: \.element.id) { index, video in
                        VideoThumbnailView(
                            thumbnailData: VideoThumbnailData(
                                video: video,
                                chapter: nil,
                                courseStructure: nil,
                                onVideoTap: { video, _ in
                                    viewModel.handleVideoTap(video: video)
                                }
                            ),
                            thumbnailWidth: 122,
                            thumbnailHeight: 67,
                            isCurrentVideo: video == currentBlock
                        )
                        .padding(.leading, index == 0 ? 24 : 8)
                        .id(video.id)

                        if index == viewModel.allVideosForNavigation.count - 1 {
                            Spacer(minLength: 100)
                        }
                    }
                }
            }
            .introspect(.scrollView, on: .iOS(.v16, .v17, .v18)) { scroll in
                DispatchQueue.main.async {
                    uiScrollView = scroll
                }
            }
            .onChange(of: viewModel.allVideosForNavigation) { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    scrollToCurrentVideo(block: block) { id in
                        scrollProxy.scrollTo(id, anchor: .leading)
                    }
                }
            }
            .frame(height: 72)
        }
    }

    private func scrollToCurrentVideo(block: CourseBlock, scrollTo: @escaping (String) -> Void) {
        guard let currentVideo = viewModel.allVideosForNavigation.first(where: { $0 == block }) else {
            return
        }

        scrollTo(currentVideo.id)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            guard let scroll = uiScrollView else { return }
            let newX = max(scroll.contentOffset.x - 20, 0)
            scroll.setContentOffset(CGPoint(x: newX, y: 0), animated: true)
        }
    }
}

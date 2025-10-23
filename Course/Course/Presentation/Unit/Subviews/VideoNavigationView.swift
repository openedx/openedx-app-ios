import Foundation
import SwiftUI
import Core
import OEXFoundation
import Theme

struct VideoNavigationView: View {
    @ObservedObject var viewModel: CourseUnitViewModel
    @Binding var currentBlock: CourseBlock?
    @State private var uiScrollView: UIScrollView?
    let block: CourseBlock

    var body: some View {
        if viewModel.isVideosForNavigationLoading {
            HStack {
                Spacer()
                RefreshProgressView(isShowRefresh: $viewModel.isVideosForNavigationLoading)
                Spacer()
            }
            .frame(height: 72)
            .padding(.bottom, 17)
            .background(content: {
                Theme.Colors.courseCardBackground
            })
        } else {
            videoNavigationView(block: block)
                .padding(.bottom, 17)
                .background(content: {
                    Theme.Colors.courseCardBackground
                })
        }

        Rectangle()
            .frame(height: 1)
            .foregroundStyle(Theme.Colors.avatarStroke.opacity(0.3))
            .padding(.bottom, 16)

        HStack {
                 let breadCrumps = viewModel.createBreadCrumpsForVideoNavigation(video: block)

                 VStack(alignment: .leading, spacing: 8) {
                     Text(breadCrumps)
                         .font(Theme.Fonts.bodySmall)
                         .foregroundStyle(Theme.Colors.textPrimary)
                         .multilineTextAlignment(.leading)
                         .lineLimit(2)

                     Text("\(currentBlock?.displayName ?? "")")
                         .font(Theme.Fonts.bodyMedium).bold()
                         .foregroundStyle(Theme.Colors.textPrimary)
                         .accessibilityLabel(currentBlock?.displayName ??
                                             CourseLocalization.VideoNavigation.noVideoTitle)
                 }
                 Spacer()
             }
             .padding(.bottom, 16)
             .padding(.horizontal, 16)
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
                            type: .navigationVideo,
                            thumbnailWidth: 122,
                            thumbnailHeight: 67,
                            isCurrentVideo: video == currentBlock,

                        )
                        .padding(.leading, index == 0 ? 24 : 8)
                        .padding(.top, 2)
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
            .onAppear(perform: {
                scrollToCurrentVideo(block: block) { id in
                    scrollProxy.scrollTo(id, anchor: .leading)
                }
            })
            .onChange(of: viewModel.allVideosForNavigation) { _ in
                scrollToCurrentVideo(block: block) { id in
                    scrollProxy.scrollTo(id, anchor: .leading)
                }
            }
            .background(content: {
                Theme.Colors.courseCardBackground
            })
            .frame(height: 72)
            .accessibilityLabel(CourseLocalization.Accessibility.videoNavigation)
            .accessibilityValue({
                let all = viewModel.allVideosForNavigation
                let count = all.count
                let idx = indexOfCurrent(in: all, current: currentBlock) ?? 0
                return CourseLocalization.Accessibility.videoNavigationCount(idx+1, count)
            }())
        }
    }

    private func indexOfCurrent(in all: [CourseBlock], current: CourseBlock?) -> Int? {
        guard let current else { return nil }
        return all.firstIndex(of: current)
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

//
//  YouTubeVideoPlayer.swift
//  Course
//
//  Created by Vladimir Chekyrta on 13.02.2023.
//

import SwiftUI
import Core
import YouTubePlayerKit
import Combine
import Swinject

public struct YouTubeVideoPlayer: View {
    
    @Bindable private var viewModel: YouTubeVideoPlayerViewModel
    private var isOnScreen: Bool
    @State
    private var showAlert = false
    @State
    private var alertMessage: String? {
        didSet {
            withAnimation {
                showAlert = alertMessage != nil
            }
        }
    }
    
    @Environment(\.isHorizontalLayout) private var isHorizontal

    public init(viewModel: YouTubeVideoPlayerViewModel, isOnScreen: Bool) {
        self.viewModel =  viewModel
        self.isOnScreen = isOnScreen
    }
    
    public var body: some View {
            ZStack {
                GeometryReader { reader in
                    playerLayout {
                        VStack {
                            YouTubePlayerView(
                                viewModel.youtubePlayer,
                                transaction: .init(animation: .easeIn),
                                overlay: { _ in })
                            .onAppear {
                                alertMessage = CourseLocalization.Alert.rotateDevice
                            }
                            .cornerRadius(12)
                            .padding(.horizontal, isHorizontal ? 0 : 8)
                            .aspectRatio(16 / 8.8, contentMode: .fit)
                            .frame(minWidth: isHorizontal ? reader.size.width  * 0.6 : min(380, reader.size.width))
                            // Adjust the width based on the horizontal state
                            if isHorizontal {
                                Spacer()
                            }
                        }
                        ZStack {
                            SubtitlesView(
                                languages: viewModel.languages,
                                currentTime: $viewModel.currentTime,
                                viewModel: viewModel,
                                scrollTo: { date in
                                    viewModel.youtubePlayer.seek(
                                        to: Measurement(value: date.secondsSinceMidnight(), unit: UnitDuration.seconds),
                                        allowSeekAhead: true
                                    )
                                    viewModel.youtubePlayer.play()
                                    viewModel.pauseScrolling()
                                    viewModel.currentTime = date.secondsSinceMidnight() + 1
                                }
                            )
                            if viewModel.isLoading {
                                ProgressBar(size: 40, lineWidth: 8)
                            }
                        }
                    }
                }
               
            }
            .onDisappear {
                viewModel.saveCurrentProgress(duration: viewModel.playerHolder.duration)
            }
        }

    private var playerLayout: AnyLayout {
        isHorizontal
        ? AnyLayout(HStackLayout(spacing: 0))
        : AnyLayout(VStackLayout(alignment: .center, spacing: 0))
    }
}

#if DEBUG
struct YouTubeVideoPlayer_Previews: PreviewProvider {
    static var previews: some View {
        YouTubeVideoPlayer(
            viewModel: YouTubeVideoPlayerViewModel(
                languages: [],
                playerStateSubject: CurrentValueSubject<VideoPlayerState?, Never>(nil),
                connectivity: Connectivity(config: ConfigMock()),
                playerHolder: YoutubePlayerViewControllerHolder.mock,
                appStorage: CoreStorageMock(),
                analytics: CourseAnalyticsMock()
            ),
            isOnScreen: true
        )
    }
}
#endif

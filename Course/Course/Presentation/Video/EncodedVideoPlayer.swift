//
//  EncodedVideoPlayer.swift
//  Course
//
//  Created by Vladimir Chekyrta on 13.02.2023.
//

import SwiftUI
import _AVKit_SwiftUI
import Core
import Swinject
import Combine

public enum VideoPlayerState: Sendable {
    case pause
    case kill
}

public struct EncodedVideoPlayer: View {
    
    @StateObject
    private var viewModel: EncodedVideoPlayerViewModel
    
    private var isOnScreen: Bool
    
    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    @State private var orientation = UIDevice.current.orientation
    @State private var isLoading: Bool = true
    @State private var isAnimating: Bool = false
    @State private var isOrientationChanged: Bool = false
    
    @State var showAlert = false
    @State var alertMessage: String? {
        didSet {
            withAnimation {
                showAlert = alertMessage != nil
            }
        }
    }
    
    @Environment(\.isHorizontal) private var isHorizontal
    
    public init(
        viewModel: EncodedVideoPlayerViewModel,
        isOnScreen: Bool
    ) {
        self._viewModel = StateObject(wrappedValue: { viewModel }())
        self.isOnScreen = isOnScreen
    }
    
    public var body: some View {
        ZStack {
            GeometryReader { reader in
                VStack(spacing: 10) {
                    HStack {
                        VStack {
                            PlayerViewController(playerController: viewModel.controller)
                            .aspectRatio(16 / 9, contentMode: .fit)
                            .frame(minWidth: playerWidth(for: reader.size))
                            .cornerRadius(12)
                            .onAppear {
                                if !viewModel.isPlayingInPip,
                                    !viewModel.isOtherPlayerInPip {
                                    viewModel.controller.player?.play()
                                }
                            }
                            if isHorizontal {
                                Spacer()
                            }
                        }
                        if isHorizontal {
                            SubtitlesView(
                                languages: viewModel.languages,
                                currentTime: $viewModel.currentTime,
                                viewModel: viewModel,
                                scrollTo: { date in
                                    viewModel.controller.player?.seek(
                                        to: CMTime(
                                            seconds: date.secondsSinceMidnight(),
                                            preferredTimescale: 10000
                                        )
                                    )
                                    viewModel.controller.player?.play()
                                    viewModel.pauseScrolling()
                                    viewModel.currentTime = (date.secondsSinceMidnight() + 1)
                                })
                        }
                    }
                    if !isHorizontal {
                        SubtitlesView(
                            languages: viewModel.languages,
                            currentTime: $viewModel.currentTime,
                            viewModel: viewModel,
                            scrollTo: { date in
                                viewModel.controller.player?.seek(
                                    to: CMTime(
                                        seconds: date.secondsSinceMidnight(),
                                        preferredTimescale: 10000
                                    )
                                )
                                viewModel.controller.player?.play()
                                viewModel.pauseScrolling()
                                viewModel.currentTime = (date.secondsSinceMidnight() + 1)
                            })
                    }
                }
            }
        }
        .padding(.horizontal, 8)
        .statusBarHidden(false)
        .onDisappear {
            viewModel.controller.player?.allowsExternalPlayback = false
        }
        .onAppear {
            viewModel.controller.player?.allowsExternalPlayback = true
            viewModel.controller.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    private func playerWidth(for size: CGSize) -> CGFloat {
        if isHorizontal {
            return size.width  * 0.6
        } else {
            //subtitles is a second half of screen, 10 - space between subtitles and player
            let availableHeight = size.height / 2 - 10
            let ratio: CGFloat = 16/9
            let calculatedWidth = availableHeight * ratio
            return min(calculatedWidth, size.width)
        }
    }
}

#if DEBUG
struct EncodedVideoPlayer_Previews: PreviewProvider {
    static var previews: some View {
        EncodedVideoPlayer(
            viewModel: EncodedVideoPlayerViewModel(
                languages: [],
                playerStateSubject: CurrentValueSubject<VideoPlayerState?, Never>(nil),
                connectivity: Connectivity(),
                playerHolder: PlayerViewControllerHolder.mock
            ),
            isOnScreen: true
        )
    }
}
#endif

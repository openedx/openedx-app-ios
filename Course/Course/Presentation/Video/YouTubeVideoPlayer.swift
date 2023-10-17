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
    
    @StateObject
    private var viewModel: YouTubeVideoPlayerViewModel
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
    
    @Environment(\.isHorizontal) private var isHorizontal

    public init(viewModel: YouTubeVideoPlayerViewModel, isOnScreen: Bool) {
        self._viewModel = StateObject(wrappedValue: { viewModel }())
        self.isOnScreen = isOnScreen
    }
    
    public var body: some View {
            ZStack {
                GeometryReader { reader in
                    adaptiveStack(isHorizontal: isHorizontal) {
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
                            .frame(minWidth: isHorizontal ? reader.size.width  * 0.6 : 380)
                            // Adjust the width based on the horizontal state
                            if isHorizontal {
                                Spacer()
                            }
                        }
                        SubtittlesView(
                            languages: viewModel.languages,
                            currentTime: $viewModel.currentTime,
                            viewModel: viewModel, scrollTo: { date in
                                viewModel.youtubePlayer.seek(to: date.secondsSinceMidnight(), allowSeekAhead: true)
                                viewModel.pauseScrolling()
                                viewModel.currentTime = date.secondsSinceMidnight() + 1
                            }
                        )
                    }
                }
                if viewModel.isLoading {
                    ProgressBar(size: 40, lineWidth: 8)
                }
            }
        }
}

#if DEBUG
struct YouTubeVideoPlayer_Previews: PreviewProvider {
    static var previews: some View {
        YouTubeVideoPlayer(
            viewModel: YouTubeVideoPlayerViewModel(
                url: "",
                blockID: "",
                courseID: "",
                languages: [],
                playerStateSubject: CurrentValueSubject<VideoPlayerState?, Never>(nil),
                interactor: CourseInteractor(repository: CourseRepositoryMock()),
                router: CourseRouterMock(),
                connectivity: Connectivity()),
            isOnScreen: true)
    }
}
#endif

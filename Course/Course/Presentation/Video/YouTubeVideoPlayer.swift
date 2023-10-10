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
            adaptiveStack(isHorizontal: isHorizontal) {
                YouTubePlayerView(
                    viewModel.youtubePlayer,
                    transaction: .init(animation: .easeIn),
                    overlay: { _ in })
                .onAppear {
                    alertMessage = CourseLocalization.Alert.rotateDevice
                }
                .cornerRadius(12)
                .padding(.horizontal, 6)
                .aspectRatio(16 / 8.8, contentMode: .fit)
                .frame(minWidth: 380)
                SubtittlesView(
                    languages: viewModel.languages,
                    currentTime: $viewModel.currentTime,
                    viewModel: viewModel
                )
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

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
    
    public init(viewModel: YouTubeVideoPlayerViewModel, isOnScreen: Bool) {
        self._viewModel = StateObject(wrappedValue: { viewModel }())
        self.isOnScreen = isOnScreen
    }
    
    public var body: some View {
        ZStack {
            VStack {
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
                .onReceive(NotificationCenter.Publisher(
                    center: .default, name: UIDevice.orientationDidChangeNotification
                )) { _ in
                    if isOnScreen {
                        let orientation = UIDevice.current.orientation
                        if orientation.isPortrait {
                            viewModel.youtubePlayer.update(configuration: YouTubePlayer.Configuration(configure: {
                                $0.playInline = true
                                $0.autoPlay = viewModel.play
                                $0.startTime = Int(viewModel.currentTime)
                            }))
                        } else {
                            viewModel.youtubePlayer.update(configuration: YouTubePlayer.Configuration(configure: {
                                $0.playInline = false
                                $0.autoPlay = true
                                $0.startTime = Int(viewModel.currentTime)
                            }))
                        }
                    }
                }
                SubtittlesView(
                    languages: viewModel.languages,
                    currentTime: $viewModel.currentTime,
                    viewModel: viewModel
                )
            }
            
            if viewModel.isLoading {
                ProgressBar(size: 40, lineWidth: 8)
            }
            
            // MARK: - Alert
            if showAlert, let alertMessage {
                VStack(alignment: .center) {
                    Spacer()
                    HStack(spacing: 6) {
                        CoreAssets.rotateDevice.swiftUIImage.renderingMode(.template)
                        Text(alertMessage)
                    }.shadowCardStyle(bgColor: Theme.Colors.snackbarInfoAlert,
                                      textColor: .white)
                    .transition(.move(edge: .bottom))
                    .onAppear {
                        doAfter(Theme.Timeout.snackbarMessageLongTimeout) {
                            self.alertMessage = nil
                            showAlert = false
                        }
                    }
                }
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

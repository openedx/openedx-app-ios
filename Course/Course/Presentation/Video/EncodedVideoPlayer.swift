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

public enum VideoPlayerState {
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
    @State private var isViewedOnce: Bool = false
    @State private var currentTime: Double = 0
    @State private var isOrientationChanged: Bool = false
    @State private var pause: Bool = false
    
    @State var showAlert = false
    @State var alertMessage: String? {
        didSet {
            withAnimation {
                showAlert = alertMessage != nil
            }
        }
    }
    
    public init(
        viewModel: EncodedVideoPlayerViewModel,
        isOnScreen: Bool
    ) {
        self._viewModel = StateObject(wrappedValue: { viewModel }())
        self.isOnScreen = isOnScreen
    }
    
    public var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                PlayerViewController(
                    videoURL: viewModel.url,
                    controller: viewModel.controller,
                    progress: { progress in
                        if progress >= 0.8 {
                            if !isViewedOnce {
                                Task {
                                    await viewModel.blockCompletionRequest()
                                }
                                isViewedOnce = true
                            }
                        }
                    }, seconds: { seconds in
                        if !pause {
                            currentTime = seconds
                        }
                    })
                .aspectRatio(16 / 9, contentMode: .fit)
                .cornerRadius(12)
                .padding(.horizontal, 6)
                .onReceive(NotificationCenter.Publisher(
                    center: .default,
                    name: UIDevice.orientationDidChangeNotification)
                ) { _ in
                    if isOnScreen {
                        self.orientation = UIDevice.current.orientation
                        if self.orientation.isLandscape {
                            viewModel.controller.enterFullScreen(animated: true)
                            viewModel.controller.player?.play()
                            isOrientationChanged = true
                        } else {
                            if isOrientationChanged {
                                viewModel.controller.exitFullScreen(animated: true)
                                viewModel.controller.player?.pause()
                                isOrientationChanged = false
                            }
                        }
                    }
                }
                SubtittlesView(languages: viewModel.languages,
                                        currentTime: $currentTime,
                                        viewModel: viewModel, scrollTo: { date in
                             viewModel.controller.player?.seek(to: CMTime(seconds: date.secondsSinceMidnight(),
                                                                          preferredTimescale: 10000))
                             pauseScrolling()
                             currentTime = (date.secondsSinceMidnight() + 1)
                         })
                Spacer()
                if !orientation.isLandscape || idiom != .pad {
                    VStack {}.onAppear {
                        isLoading = false
                        alertMessage = CourseLocalization.Alert.rotateDevice
                    }
                }
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
    private func pauseScrolling() {
        pause = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.pause = false
        }
    }
}

#if DEBUG
struct EncodedVideoPlayer_Previews: PreviewProvider {
    static var previews: some View {
        EncodedVideoPlayer(
            viewModel: EncodedVideoPlayerViewModel(
                url: URL(string: "")!,
                blockID: "",
                courseID: "",
                languages: [],
                playerStateSubject: CurrentValueSubject<VideoPlayerState?, Never>(nil),
                interactor: CourseInteractor(repository: CourseRepositoryMock()),
                router: CourseRouterMock(),
                connectivity: Connectivity()
            ),
            isOnScreen: true
        )
    }
}
#endif

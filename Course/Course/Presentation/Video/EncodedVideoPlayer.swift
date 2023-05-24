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
    
    private var blockID: String
    private var courseID: String
    
    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    @State private var orientation = UIDevice.current.orientation
    @State private var isLoading: Bool = true
    @State private var isAnimating: Bool = false
    @State private var isViewedOnce: Bool = false
    @State private var currentTime: Double = 0
    @State private var isOrientationChanged: Bool = false
    private var subscription = Set<AnyCancellable>()

    @State var showAlert = false
    @State var alertMessage: String? {
        didSet {
            withAnimation {
                showAlert = alertMessage != nil
            }
        }
    }
    private let url: URL?
    
    public init(
        url: URL?,
        blockID: String,
        courseID: String,
        viewModel: EncodedVideoPlayerViewModel,
        playerStateSubject: CurrentValueSubject<VideoPlayerState?, Never>
    ) {
        self.url = url
        self.blockID = blockID
        self.courseID = courseID
        self._viewModel = StateObject(wrappedValue: { viewModel }())
        
        playerStateSubject.sink(receiveValue: { state in
            switch state {
            case .pause:
                viewModel.controller.player?.pause()
            case .kill:
                viewModel.controller.player?.replaceCurrentItem(with: nil)
            case .none:
                break
            }
        }).store(in: &subscription)
    }
    
    public var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                PlayerViewController(
                    videoURL: url,
                    controller: viewModel.controller,
                    progress: { progress in
                        if progress >= 0.8 {
                            if !isViewedOnce {
                                Task {
                                    await viewModel.blockCompletionRequest(blockID: blockID, courseID: courseID)
                                }
                                isViewedOnce = true
                            }
                        }
                    }, seconds: { seconds in
                        currentTime = seconds
                    })
                .aspectRatio(16 / 9, contentMode: .fit)
                .cornerRadius(12)
                .padding(.horizontal, 6)
                .onReceive(NotificationCenter.Publisher(
                    center: .default,
                    name: UIDevice.orientationDidChangeNotification)) { _ in
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
                SubtittlesView(languages: viewModel.languages,
                                   currentTime: $currentTime,
                                   viewModel: viewModel)
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
                    }.shadowCardStyle(bgColor: CoreAssets.snackbarInfoAlert.swiftUIColor,
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

struct EncodedVideoPlayer_Previews: PreviewProvider {
    static var previews: some View {
        EncodedVideoPlayer(url: nil, blockID: "", courseID: "",
                           viewModel: EncodedVideoPlayerViewModel(languages: [],
                                                                  interactor: CourseInteractor(repository:
                                                                                                CourseRepositoryMock()),
                                                                  router: CourseRouterMock(),
                                                                  connectivity: Connectivity()),
                           playerStateSubject: CurrentValueSubject<VideoPlayerState?, Never>(nil))
    }
}

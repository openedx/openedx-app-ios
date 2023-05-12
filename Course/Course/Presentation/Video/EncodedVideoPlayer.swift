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

public struct EncodedVideoPlayer: View {
    
    @ObservedObject
    private var viewModel = Container.shared.resolve(VideoPlayerViewModel.self)!
    
    private var blockID: String
    private var courseID: String
    private let languages: [SubtitleUrl]
    
    private var controller = AVPlayerViewController()
    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    @State private var orientation = UIDevice.current.orientation
    @State private var isLoading: Bool = true
    @State private var isAnimating: Bool = false
    @State private var isViewedOnce: Bool = false
    @State private var currentTime: Double = 0
    @State private var isOrientationChanged: Bool = false
    @Binding private var killPlayer: Bool
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
        languages: [SubtitleUrl],
        killPlayer: Binding<Bool>
    ) {
        self.url = url
        self.blockID = blockID
        self.courseID = courseID
        self.languages = languages
        self._killPlayer = killPlayer
    }
    
    public var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                PlayerViewController(
                    videoURL: url,
                    controller: controller,
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
                            controller.enterFullScreen(animated: true)
                            controller.player?.play()
                            isOrientationChanged = true
                        } else {
                            if isOrientationChanged {
                                controller.exitFullScreen(animated: true)
                                controller.player?.pause()
                                isOrientationChanged = false
                            }
                        }
                    }
                    SubtittlesView(languages: languages,
                                   currentTime: $currentTime,
                                   viewModel: viewModel)
                Spacer()
                if !orientation.isLandscape || idiom != .pad {
                    VStack {}.onAppear {
                        isLoading = false
                        alertMessage = CourseLocalization.Alert.rotateDevice
                    }
                }
            }.onChange(of: killPlayer, perform: { _ in
                controller.player?.replaceCurrentItem(with: nil)
            })
            // MARK: - Alert
            if showAlert {
                VStack(alignment: .center) {
                    Spacer()
                    HStack(spacing: 6) {
                        CoreAssets.rotateDevice.swiftUIImage.renderingMode(.template)
                        Text(alertMessage ?? "")
                    }.shadowCardStyle(bgColor: CoreAssets.snackbarInfoAlert.swiftUIColor,
                                      textColor: .white)
                    .transition(.move(edge: .bottom))
                    .onAppear {
                        doAfter(Theme.Timeout.snackbarMessageLongTimeout) {
                            alertMessage = nil
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
        EncodedVideoPlayer(url: nil, blockID: "", courseID: "", languages: [], killPlayer: .constant(false))
    }
}

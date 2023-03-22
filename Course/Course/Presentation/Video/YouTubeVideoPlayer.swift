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

public struct YouTubeVideoPlayer: View {

    private let youtubePlayer: YouTubePlayer
    private var timePublisher: AnyPublisher<Double, Never>
    private var durationPublisher: AnyPublisher<Double, Never>
    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    @State private var duration: Double?
    @State private var orientation = UIDevice.current.orientation
    @State private var isLoading: Bool = true
    @State private var isAnimating: Bool = false
    @State private var hideRotationPromt: Bool = false
    @State private var isViewedOnce: Bool = false
    public var isViewed: ((Bool) -> Void)
    @State var showAlert = false
    @State var alertMessage: String? {
        didSet {
            withAnimation {
                showAlert = alertMessage != nil
            }
        }
    }

    public init(url: String, isViewed: @escaping ((Bool) -> Void)) {
        self.isViewed = isViewed
        let videoID = url.replacingOccurrences(of: "https://www.youtube.com/watch?v=", with: "")
        let configuration = YouTubePlayer.Configuration(configure: {
            $0.autoPlay = false
            $0.playInline = false
            $0.showFullscreenButton = true
            $0.allowsPictureInPictureMediaPlayback = true
            $0.showControls = true
            $0.useModestBranding = false
            $0.progressBarColor = .white
            $0.showRelatedVideos = false
            $0.showCaptions = false
            $0.showAnnotations = false
            $0.customUserAgent = """
                                 Mozilla/5.0 (iPod; U; CPU iPhone OS 4_3_3 like Mac OS X; ja-jp)
                                 AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8J2 Safari/6533.18.5
                                 """
        })
        self.youtubePlayer = YouTubePlayer(source: .video(id: videoID),
                                           configuration: configuration)
        self.timePublisher = youtubePlayer.currentTimePublisher()
        self.durationPublisher = youtubePlayer.durationPublisher
    }

    public var body: some View {
        ZStack {
            VStack {
                YouTubePlayerView(
                    youtubePlayer,
                    transaction: .init(animation: .easeIn),
                    overlay: { state in
                        if state == .ready {
                            if idiom == .pad {
                                VStack {}.onAppear {
                                    isLoading = false
                                }
                            } else {
                                VStack {}.onAppear {
                                    isLoading = false
                                    alertMessage = CourseLocalization.Alert.rotateDevice
                                }
                            }
                        }
                    })
                .aspectRatio(16/8.8, contentMode: .fit)
                .onReceive(NotificationCenter
                    .Publisher(center: .default,
                               name: UIDevice.orientationDidChangeNotification)) { _ in
                    self.orientation = UIDevice.current.orientation
                    if self.orientation.isPortrait {
                    } else {
                        youtubePlayer.play()
                    }
                }
            }.onReceive(durationPublisher, perform: { duration in
                self.duration = duration
            })

            .onReceive(timePublisher, perform: { time in
                if let duration {
                    if (time / duration) >= 0.8 {
                        if !isViewedOnce {
                            self.isViewed(true)
                            isViewedOnce = true
                        }
                    }
                }
            })
            if isLoading {
                ProgressBar(size: 40, lineWidth: 8)
            }
        }
        // MARK: - Alert
        if showAlert {
            VStack(alignment: .center) {
                Spacer()
                HStack(spacing: 6) {
                    CoreAssets.rotateDevice.swiftUIImage.renderingMode(.template)
                    Text(alertMessage ?? "")
                }.shadowCardStyle(bgColor: CoreAssets.accentColor.swiftUIColor,
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

struct YouTubeVideoPlayer_Previews: PreviewProvider {
    static var previews: some View {
        YouTubeVideoPlayer(url: "", isViewed: {_ in})
    }
}

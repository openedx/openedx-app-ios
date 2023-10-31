//
//  YouTubeVideoPlayerViewModel.swift
//  Course
//
//  Created by  Stepanok Ivan on 24.05.2023.
//

import SwiftUI
import Core
import YouTubePlayerKit
import Combine
import Swinject

public class YouTubeVideoPlayerViewModel: VideoPlayerViewModel {
    
    @Published var youtubePlayer: YouTubePlayer
    private (set) var play = false
    @Published var isLoading: Bool = true
    @Published var currentTime: Double = 0
    @Published var pause: Bool = false
    
    private var subscription = Set<AnyCancellable>()
    private var duration: Double?
    private var isViewedOnce: Bool = false
    private var url: String
    
    public init(
        url: String,
        blockID: String,
        courseID: String,
        languages: [SubtitleUrl],
        playerStateSubject: CurrentValueSubject<VideoPlayerState?, Never>,
        interactor: CourseInteractorProtocol,
        router: CourseRouter,
        connectivity: ConnectivityProtocol
    ) {
        self.url = url

        let videoID = url.replacingOccurrences(of: "https://www.youtube.com/watch?v=", with: "")
        let configuration = YouTubePlayer.Configuration(configure: {
            $0.autoPlay = false
            $0.playInline = true
            $0.showFullscreenButton = true
            $0.allowsPictureInPictureMediaPlayback = false
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
        self.youtubePlayer = YouTubePlayer(source: .video(id: videoID), configuration: configuration)
        
        super.init(
            blockID: blockID,
            courseID: courseID,
            languages: languages,
            interactor: interactor,
            router: router,
            connectivity: connectivity
        )
        
        self.youtubePlayer.pause()
        
        subscrube(playerStateSubject: playerStateSubject)
    }
    
    func pauseScrolling() {
        pause = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.pause = false
        }
    }
    
    private func subscrube(playerStateSubject: CurrentValueSubject<VideoPlayerState?, Never>) {
        playerStateSubject.sink(receiveValue: { [weak self] state in
            switch state {
            case .pause:
                self?.youtubePlayer.pause()
            case .kill, .none:
                break
            }
        }).store(in: &subscription)

        youtubePlayer.durationPublisher.sink(receiveValue: { [weak self] duration in
            self?.duration = duration
        }).store(in: &subscription)

        youtubePlayer.currentTimePublisher(updateInterval: 0.1).sink(receiveValue: { [weak self] time in
            guard let self else { return }
            if !self.pause {
                self.currentTime = time
            }

            if let duration = self.duration {
                if (time / duration) >= 0.8 {
                    if !isViewedOnce {
                        Task {
                            await self.blockCompletionRequest()
                           
                        }
                        isViewedOnce = true
                    }
                }
                if (time / duration) >= 0.99 {
                    self.router.presentAppReview()
                }
            }
        }).store(in: &subscription)

        youtubePlayer.playbackStatePublisher.sink(receiveValue: { [weak self] state in
            guard let self else { return }
            switch state {
            case .unstarted:
                self.play = false
            case .ended:
                self.play = false
            case .playing:
                self.play = true
            case .paused:
                self.play = false
            case .buffering, .cued:
                break
            }
        }).store(in: &subscription)

        youtubePlayer.statePublisher.sink(receiveValue: { [weak self] state in
            guard let self else { return }
            if state == .ready {
                self.isLoading = false
            }
        }).store(in: &subscription)
    }
}

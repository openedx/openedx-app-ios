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
    
    var youtubePlayer: YouTubePlayer {
        (playerHolder.playerController as? YouTubePlayer) ?? YouTubePlayer()
    }
    private (set) var play = false
    @Published var isLoading: Bool = true
    
    override func observePlayer(with playerStateSubject: CurrentValueSubject<VideoPlayerState?, Never>) {
        super.observePlayer(with: playerStateSubject)
        playerHolder.getReadyPublisher()
            .sink {[weak self] isReady in
                guard isReady else { return }
                self?.isLoading = false
            }
            .store(in: &subscription)
    }
}

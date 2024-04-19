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
    
    public init(
        languages: [SubtitleUrl],
        playerStateSubject: CurrentValueSubject<VideoPlayerState?, Never>,
        connectivity: ConnectivityProtocol,
        playerHolder: PlayerViewControllerHolderProtocol
    ) {
        super.init(
            languages: languages,
            playerStateSubject: playerStateSubject,
            connectivity: connectivity,
            playerHolder: playerHolder
        )
    }
}

//
//  EncodedVideoPlayerViewModel.swift
//  Course
//
//  Created by  Stepanok Ivan on 24.05.2023.
//

import _AVKit_SwiftUI
import Core
import Combine

public class EncodedVideoPlayerViewModel: VideoPlayerViewModel {
    var controller: AVPlayerViewController {
        (playerHolder.playerController as? AVPlayerViewController) ?? AVPlayerViewController()
    }
    
    public init(
        languages: [SubtitleUrl],
        playerStateSubject: CurrentValueSubject<VideoPlayerState?, Never>,
        connectivity: ConnectivityProtocol,
        playerHolder: PlayerViewControllerHolderProtocol
    ) {
        super.init(languages: languages,
                   playerStateSubject: playerStateSubject,
                   connectivity: connectivity,
                   playerHolder: playerHolder
        )
    }
}

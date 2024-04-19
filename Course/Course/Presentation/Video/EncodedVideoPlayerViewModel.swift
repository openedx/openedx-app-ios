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
    let playerHolder: PlayerViewControllerHolderProtocol
    var controller: AVPlayerViewController {
        (playerHolder.playerController as? AVPlayerViewController) ?? AVPlayerViewController()
    }
    private var subscription = Set<AnyCancellable>()
    var isPlayingInPip: Bool {
        playerHolder.isPlayingInPip
    }
    
    var isOtherPlayerInPip: Bool {
        playerHolder.isOtherPlayerInPipPlaying
    }
    
    public init(
        blockID: String,
        courseID: String,
        languages: [SubtitleUrl],
        playerStateSubject: CurrentValueSubject<VideoPlayerState?, Never>,
        connectivity: ConnectivityProtocol,
        playerHolder: PlayerViewControllerHolderProtocol,
        playerService: PlayerServiceProtocol
    ) {
        self.playerHolder = playerHolder
        super.init(blockID: blockID,
                   courseID: courseID,
                   languages: languages,
                   connectivity: connectivity,
                   playerService: playerService)
        
        playerStateSubject.sink(receiveValue: { [weak self] state in
            switch state {
            case .pause:
                if self?.playerHolder.isPlayingInPip != true {
                    self?.controller.player?.pause()
                }
            case .kill:
                if self?.playerHolder.isPlayingInPip != true {
                    self?.controller.player?.replaceCurrentItem(with: nil)
                }
            case .none:
                break
            }
        }).store(in: &subscription)
        
        playerHolder.getTimePublisher()
            .sink {[weak self] time in
                self?.currentTime = time
            }
            .store(in: &subscription)
        playerHolder.getErrorPublisher()
            .sink {[weak self] error in
                if error.isInternetError || error is NoCachedDataError {
                    self?.errorMessage = CoreLocalization.Error.slowOrNoInternetConnection
                } else {
                    self?.errorMessage = CoreLocalization.Error.unknownError
                }
            }
            .store(in: &subscription)
    }
}

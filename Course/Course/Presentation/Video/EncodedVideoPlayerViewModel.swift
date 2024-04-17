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
    let playerHolder: PlayerViewControllerHolder
    var controller: AVPlayerViewController {
        playerHolder.playerController
    }
    private var subscription = Set<AnyCancellable>()
    
    public init(
        blockID: String,
        courseID: String,
        languages: [SubtitleUrl],
        playerStateSubject: CurrentValueSubject<VideoPlayerState?, Never>,
        interactor: CourseInteractorProtocol,
        router: CourseRouter,
        connectivity: ConnectivityProtocol,
        playerHolder: PlayerViewControllerHolder
    ) {
        self.playerHolder = playerHolder
        
        super.init(blockID: blockID,
                   courseID: courseID,
                   languages: languages,
                   interactor: interactor,
                   router: router,
                   connectivity: connectivity)
        
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
    }
        
    func progress(for time: Double) -> Double {
        let duration = playerHolder.duration
        if !time.isNaN && !duration.isNaN {
            return time/duration
        }
        return 0
    }
}

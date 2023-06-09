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
    
    let url: URL?
    
    let controller = AVPlayerViewController()
    private var subscription = Set<AnyCancellable>()
    
    public init(
        url: URL?,
        blockID: String,
        courseID: String,
        languages: [SubtitleUrl],
        playerStateSubject: CurrentValueSubject<VideoPlayerState?, Never>,
        interactor: CourseInteractorProtocol,
        router: CourseRouter,
        connectivity: ConnectivityProtocol) {
            self.url = url
            
            super.init(blockID: blockID,
                       courseID: courseID,
                       languages: languages,
                       interactor: interactor,
                       router: router,
                       connectivity: connectivity)
            
            playerStateSubject.sink(receiveValue: { [weak self] state in
                switch state {
                case .pause:
                self?.controller.player?.pause()
            case .kill:
                self?.controller.player?.replaceCurrentItem(with: nil)
            case .none:
                break
            }
        }).store(in: &subscription)
    }
}

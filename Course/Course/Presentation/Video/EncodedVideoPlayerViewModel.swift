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
        appStorage: CoreStorage,
        connectivity: ConnectivityProtocol
    ) {
        self.url = url
        
        super.init(blockID: blockID,
                   courseID: courseID,
                   languages: languages,
                   interactor: interactor,
                   router: router, 
                   appStorage: appStorage,
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
    
    func getBitRate() -> Double {
        switch appStorage.userSettings?.streamingQuality {
        case .auto:
            return 0
        case .low:
            return 1500000
        case .medium:
            return 2000000
        case .high:
            return 4000000
        case .none:
            return 0
        }
    }
}

//
//  EncodedVideoPlayerViewModel.swift
//  Course
//
//  Created by  Stepanok Ivan on 24.05.2023.
//

import _AVKit_SwiftUI
import Core

public class EncodedVideoPlayerViewModel: VideoPlayerViewModel {
    
    let controller = AVPlayerViewController()
    
    public override init(languages: [SubtitleUrl],
                         interactor: CourseInteractorProtocol,
                         router: CourseRouter,
                         connectivity: ConnectivityProtocol) {
        super.init(languages: languages,
                   interactor: interactor,
                   router: router,
                   connectivity: connectivity)
    }
}

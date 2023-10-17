//
//  EncodedVideoView.swift
//  Course
//
//  Created by  Stepanok Ivan on 30.05.2023.
//

import SwiftUI
import Core
import Combine
import Swinject

struct EncodedVideoView: View {
    
    let name: String
    let url: URL?
    let courseID: String
    let blockID: String
    let playerStateSubject: CurrentValueSubject<VideoPlayerState?, Never>
    let languages: [SubtitleUrl]
    let isOnScreen: Bool
    
    var body: some View {
            let vm = Container.shared.resolve(
                EncodedVideoPlayerViewModel.self,
                arguments: url,
                blockID,
                courseID,
                languages,
                playerStateSubject
            )!
            EncodedVideoPlayer(viewModel: vm, isOnScreen: isOnScreen)
    }
}

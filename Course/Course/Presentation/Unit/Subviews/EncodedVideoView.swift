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
    let index: Int
    let encodedUrl: String
    let blockID: String
    let viewModel: CourseUnitViewModel
    let playerStateSubject: CurrentValueSubject<VideoPlayerState?, Never>
    @State var isOnScreen: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if isOnScreen {
            Text(viewModel.verticals[viewModel.verticalIndex].childs[index].displayName)
                .font(Theme.Fonts.titleLarge)
                .padding(.horizontal, 24)
            
            let vm = Container.shared.resolve(EncodedVideoPlayerViewModel.self,
                                              arguments: viewModel.languages(),
                                              playerStateSubject)!
                EncodedVideoPlayer(
                    url: viewModel.urlForVideoFileOrFallback(blockId: blockID, url: encodedUrl),
                    blockID: blockID,
                    courseID: viewModel.courseID,
                    isOnScreen: isOnScreen,
                    viewModel: vm
                )
                Spacer(minLength: 100)
            }
        }
    }
}

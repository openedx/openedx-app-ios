//
//  YouTubeView.swift
//  Course
//
//  Created by  Stepanok Ivan on 30.05.2023.
//

import SwiftUI
import Core
import Combine
import Swinject

struct YouTubeView: View {
    let index: Int
    let url: String
    let blockID: String
    let viewModel: CourseUnitViewModel
    let playerStateSubject: CurrentValueSubject<VideoPlayerState?, Never>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            VStack(alignment: .leading) {
                Text(viewModel.verticals[viewModel.verticalIndex].childs[index].displayName)
                    .font(Theme.Fonts.titleLarge)
                    .padding(.horizontal, 24)
                let vm = Container.shared.resolve(YouTubeVideoPlayerViewModel.self,
                                                  arguments: url,
                                                  blockID,
                                                  viewModel.courseID,
                                                  viewModel.languages(),
                                                  playerStateSubject)!
                YouTubeVideoPlayer(viewModel: vm)
                Spacer(minLength: 100)
            }.background(CoreAssets.background.swiftUIColor)
        }
    }
}

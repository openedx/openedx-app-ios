//
//  EncodedVideoPlayer.swift
//  Course
//
//  Created by Vladimir Chekyrta on 13.02.2023.
//

import SwiftUI
import _AVKit_SwiftUI
import Core
import Swinject
import Combine

public enum VideoPlayerState {
    case pause
    case kill
}

public struct EncodedVideoPlayer: View {
    
    @StateObject
    private var viewModel: EncodedVideoPlayerViewModel
    
    private var isOnScreen: Bool
    
    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    @State private var orientation = UIDevice.current.orientation
    @State private var isLoading: Bool = true
    @State private var isAnimating: Bool = false
    @State private var isViewedOnce: Bool = false
    @State private var currentTime: Double = 0
    @State private var isOrientationChanged: Bool = false
    
    @State var showAlert = false
    @State var alertMessage: String? {
        didSet {
            withAnimation {
                showAlert = alertMessage != nil
            }
        }
    }
    
    @Environment(\.isHorizontal) private var isHorizontal
    
    public init(
        viewModel: EncodedVideoPlayerViewModel,
        isOnScreen: Bool
    ) {
        self._viewModel = StateObject(wrappedValue: { viewModel }())
        self.isOnScreen = isOnScreen
    }
    
    public var body: some View {
        ZStack {
            VStack {
                HStack {
                    PlayerViewController(
                        videoURL: viewModel.url,
                        controller: viewModel.controller,
                        progress: { progress in
                            if progress >= 0.8 {
                                if !isViewedOnce {
                                    Task {
                                        await viewModel.blockCompletionRequest()
                                    }
                                    isViewedOnce = true
                                }
                            }
                        }, seconds: { seconds in
                            currentTime = seconds
                        })
                    .aspectRatio(16 / 9, contentMode: .fit)
                    .frame(minWidth: 380)
                    .cornerRadius(12)
                    .padding(.horizontal, 6)
                    if isHorizontal {
                        SubtittlesView(languages: viewModel.languages,
                                       currentTime: $currentTime,
                                       viewModel: viewModel)
                    }
                }
                if !isHorizontal {
                    SubtittlesView(languages: viewModel.languages,
                                   currentTime: $currentTime,
                                   viewModel: viewModel)
                }
            }
        }
    }
}

#if DEBUG
struct EncodedVideoPlayer_Previews: PreviewProvider {
    static var previews: some View {
        EncodedVideoPlayer(
            viewModel: EncodedVideoPlayerViewModel(
                url: URL(string: "")!,
                blockID: "",
                courseID: "",
                languages: [],
                playerStateSubject: CurrentValueSubject<VideoPlayerState?, Never>(nil),
                interactor: CourseInteractor(repository: CourseRepositoryMock()),
                router: CourseRouterMock(),
                connectivity: Connectivity()
            ),
            isOnScreen: true
        )
    }
}
#endif

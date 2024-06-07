//
//  YoutubePlayerViewControllerHolder.swift
//  Course
//
//  Created by Vadim Kuznetsov on 22.04.24.
//

import Combine
import Foundation
import YouTubePlayerKit

public class YoutubePlayerViewControllerHolder: PlayerViewControllerHolderProtocol {
    public let url: URL?
    public let blockID: String
    public let courseID: String
    public let selectedCourseTab: Int
    
    public var isPlaying: Bool {
        playerTracker.isPlaying
    }
    public var timePublisher: AnyPublisher<Double, Never> {
        playerTracker.getTimePublisher()
    }

    public let isPlayingInPip: Bool = false

    public var isOtherPlayerInPipPlaying: Bool {
        pipManager.isPipActive && pipManager.isPipPlaying
    }

    public var duration: Double {
        playerTracker.duration
    }
    private let playerTracker: any PlayerTrackerProtocol
    private let playerService: PlayerServiceProtocol
    private let videoResolution: CGSize
    private let errorPublisher = PassthroughSubject<Error, Never>()
    private var isViewedOnce: Bool = false
    private var cancellations: [AnyCancellable] = []

    let pipManager: PipManagerProtocol

    public var playerController: PlayerControllerProtocol? {
        playerTracker.player as? YouTubePlayer
    }

    required public init(
        url: URL?,
        blockID: String,
        courseID: String,
        selectedCourseTab: Int,
        videoResolution: CGSize,
        pipManager: PipManagerProtocol,
        playerTracker: any PlayerTrackerProtocol,
        playerDelegate: PlayerDelegateProtocol?,
        playerService: PlayerServiceProtocol
    ) {
        self.url = url
        self.blockID = blockID
        self.courseID = courseID
        self.selectedCourseTab = selectedCourseTab
        self.videoResolution = videoResolution
        self.pipManager = pipManager
        self.playerTracker = playerTracker
        self.playerService = playerService
        let youtubePlayer = playerTracker.player as? YouTubePlayer
        var configuration = youtubePlayer?.configuration
        configuration?.autoPlay = !pipManager.isPipActive
        if let configuration = configuration {
            youtubePlayer?.update(configuration: configuration)
        }
        addObservers()
    }
    
    private func addObservers() {
        timePublisher
            .sink {[weak self] _ in
                guard let strongSelf = self else { return }
                if strongSelf.playerTracker.progress > 0.8 && !strongSelf.isViewedOnce {
                    strongSelf.isViewedOnce = true
                    Task {
                        await strongSelf.sendCompletion()
                    }
                }
            }
            .store(in: &cancellations)
        playerTracker.getFinishPublisher()
            .sink { [weak self] in
                self?.playerService.presentAppReview()
            }
            .store(in: &cancellations)
        playerTracker.getRatePublisher()
            .sink {[weak self] rate in
                guard rate > 0 else { return }
                self?.pausePipIfNeed()
            }
            .store(in: &cancellations)
        pipManager.pipRatePublisher()?
            .sink {[weak self] rate in
                guard rate > 0, self?.isPlayingInPip == false else { return }
                self?.playerController?.pause()
            }
            .store(in: &cancellations)
    }

    public func pausePipIfNeed() {
        if !isPlayingInPip {
            pipManager.pauseCurrentPipVideo()
        }
    }
    
    public func getTimePublisher() -> AnyPublisher<Double, Never> {
        playerTracker.getTimePublisher()
    }

    public func getErrorPublisher() -> AnyPublisher<Error, Never> {
        errorPublisher
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    public func getRatePublisher() -> AnyPublisher<Float, Never> {
        playerTracker.getRatePublisher()
    }

    public func getReadyPublisher() -> AnyPublisher<Bool, Never> {
        playerTracker.getReadyPublisher()
    }

    public func getService() -> PlayerServiceProtocol {
        playerService
    }
    
    public func sendCompletion() async {
        do {
            try await playerService.blockCompletionRequest()
        } catch {
            errorPublisher.send(error)
        }
    }
}

extension YoutubePlayerViewControllerHolder {
    static var mock: YoutubePlayerViewControllerHolder {
        YoutubePlayerViewControllerHolder(
            url: URL(string: "")!,
            blockID: "",
            courseID: "",
            selectedCourseTab: 0,
            videoResolution: .zero,
            pipManager: PipManagerProtocolMock(),
            playerTracker: PlayerTrackerProtocolMock(url: URL(string: "")),
            playerDelegate: nil,
            playerService: PlayerService(
                courseID: "",
                blockID: "",
                interactor: CourseInteractor.mock,
                router: CourseRouterMock()
            )
        )
    }
}

extension YouTubePlayer: PlayerControllerProtocol {
    public func play() {
        self.play(completion: nil)
    }
    
    public func pause() {
        self.pause(completion: nil)
    }
    
    public func seekTo(to date: Date) {
        self.seek(
            to: Measurement(value: date.secondsSinceMidnight(), unit: UnitDuration.seconds),
            allowSeekAhead: true
        )
    }
    
    public func stop() {
        self.stop(completion: nil)
    }
}

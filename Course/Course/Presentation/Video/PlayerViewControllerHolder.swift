//
//  PlayerViewControllerHolder.swift
//  Core
//
//  Created by Vadim Kuznetsov on 20.03.24.
//

import AVKit
import Combine

public protocol PlayerViewControllerHolderProtocol: AnyObject {
    var url: URL? { get }
    var blockID: String { get }
    var courseID: String { get }
    var selectedCourseTab: Int { get }
    var playerController: PlayerControllerProtocol? { get }
    var isPlaying: Bool { get }
    var isPlayingInPip: Bool { get }
    var isOtherPlayerInPipPlaying: Bool { get }

    init(
        url: URL?,
        blockID: String,
        courseID: String,
        selectedCourseTab: Int,
        videoResolution: CGSize,
        pipManager: PipManagerProtocol,
        playerTracker: any PlayerTrackerProtocol,
        playerDelegate: PlayerDelegateProtocol?,
        playerService: PlayerServiceProtocol
    )
    func getTimePublisher() -> AnyPublisher<Double, Never>
    func getErrorPublisher() -> AnyPublisher<Error, Never>
    func getRatePublisher() -> AnyPublisher<Float, Never>
    func getReadyPublisher() -> AnyPublisher<Bool, Never>
    func getService() -> PlayerServiceProtocol
    func sendCompletion() async
}

public class PlayerViewControllerHolder: PlayerViewControllerHolderProtocol {
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

    public var isPlayingInPip: Bool {
        playerDelegate?.isPlayingInPip ?? false
    }

    public var isOtherPlayerInPipPlaying: Bool {
        let holder = pipManager.holder(
            for: url,
            blockID: blockID,
            courseID: courseID,
            selectedCourseTab: selectedCourseTab
        )
        return holder == nil && pipManager.isPipActive && pipManager.isPipPlaying
    }
    public var duration: Double {
        playerTracker.duration
    }
    private let playerTracker: any PlayerTrackerProtocol
    private let playerDelegate: PlayerDelegateProtocol?
    private let playerService: PlayerServiceProtocol
    private let videoResolution: CGSize
    private let errorPublisher = PassthroughSubject<Error, Never>()
    private var isViewedOnce: Bool = false
    private var cancellations: [AnyCancellable] = []

    let pipManager: PipManagerProtocol

    public lazy var playerController: PlayerControllerProtocol? = {
        let playerController = AVPlayerViewController()
        playerController.modalPresentationStyle = .fullScreen
        playerController.allowsPictureInPicturePlayback = true
        playerController.canStartPictureInPictureAutomaticallyFromInline = true
        playerController.delegate = playerDelegate
        playerController.player = playerTracker.player as? AVPlayer
        playerController.player?.currentItem?.preferredMaximumResolution = videoResolution
        return playerController
    }()

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
        self.playerDelegate = playerDelegate
        self.playerService = playerService
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

extension PlayerViewControllerHolder {
    static var mock: PlayerViewControllerHolder {
        PlayerViewControllerHolder(
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

extension AVPlayerViewController: PlayerControllerProtocol {
    public func play() {
        player?.play()
    }
    
    public func pause() {
        player?.pause()
    }
    
    public func seekTo(to date: Date) {
        player?.seek(to: date)
    }
    
    public func stop() {
        player?.replaceCurrentItem(with: nil)
    }
}

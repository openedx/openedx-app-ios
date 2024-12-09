//
//  PlayerViewControllerHolder.swift
//  Core
//
//  Created by Vadim Kuznetsov on 20.03.24.
//

@preconcurrency import AVKit
@preconcurrency import Combine
import Core

@MainActor
public protocol PlayerViewControllerHolderProtocol: AnyObject, Sendable {
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
        pipManager: PipManagerProtocol,
        playerTracker: any PlayerTrackerProtocol,
        playerDelegate: PlayerDelegateProtocol?,
        playerService: PlayerServiceProtocol,
        appStorage: CoreStorage?
    )
    func getTimePublisher() -> AnyPublisher<Double, Never>
    func getErrorPublisher() -> AnyPublisher<Error, Never>
    func getRatePublisher() -> AnyPublisher<Float, Never>
    func getReadyPublisher() -> AnyPublisher<Bool, Never>
    func getService() -> PlayerServiceProtocol
    func sendCompletion() async
}

@MainActor
public final class PlayerViewControllerHolder: PlayerViewControllerHolderProtocol {
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
    private let errorPublisher = PassthroughSubject<Error, Never>()
    private var isViewedOnce: Bool = false
    private var cancellations: [AnyCancellable] = []
    private var appStorage: CoreStorage?

    let pipManager: PipManagerProtocol

    public lazy var playerController: PlayerControllerProtocol? = {
        let playerController = AVPlayerViewController()
        playerController.modalPresentationStyle = .fullScreen
        playerController.allowsPictureInPicturePlayback = true
        playerController.canStartPictureInPictureAutomaticallyFromInline = true
        playerController.delegate = playerDelegate
        playerController.player = playerTracker.player as? AVPlayer
        playerController.player?.currentItem?.preferredMaximumResolution = (
            appStorage?.userSettings?.streamingQuality ?? .auto
        ).resolution

        if let speed = appStorage?.userSettings?.videoPlaybackSpeed {
            if #available(iOS 16.0, *) {
                if let playbackSpeed = playerController.speeds.first(where: { $0.rate == speed }) {
                    playerController.selectSpeed(playbackSpeed)
                }
            } else {
                // Fallback on earlier versions
                playerController.player?.rate = speed
            }
        }

        return playerController
    }()

    required public init(
        url: URL?,
        blockID: String,
        courseID: String,
        selectedCourseTab: Int,
        pipManager: PipManagerProtocol,
        playerTracker: any PlayerTrackerProtocol,
        playerDelegate: PlayerDelegateProtocol?,
        playerService: PlayerServiceProtocol,
        appStorage: CoreStorage?
    ) {
        self.url = url
        self.blockID = blockID
        self.courseID = courseID
        self.selectedCourseTab = selectedCourseTab
        self.pipManager = pipManager
        self.playerTracker = playerTracker
        self.playerDelegate = playerDelegate
        self.playerService = playerService
        self.appStorage = appStorage
        addObservers()
    }
    
    @MainActor
    private func addObservers() {
        timePublisher
            .sink {[weak self]  _ in
                guard let self else { return }
                if self.playerTracker.progress > 0.8 && !self.isViewedOnce {
                    self.isViewedOnce = true
                    Task {
                        await self.sendCompletion()
                    }
                }
            }
            .store(in: &cancellations)
        playerTracker.getFinishPublisher()
            .sink { [weak self] in
                guard let self else { return }
                MainActor.assumeIsolated {
                   self.playerService.presentAppReview()
                }
            }
            .store(in: &cancellations)
        playerTracker.getRatePublisher()
            .sink {[weak self] rate in
                guard rate > 0 else { return }
                guard let self else { return }
                MainActor.assumeIsolated {
                    self.pausePipIfNeed()
                    self.saveSelectedRate(rate: rate)
                }
            }
            .store(in: &cancellations)
        pipManager.pipRatePublisher()?
            .sink {[weak self] rate in
                guard let self else { return }
                MainActor.assumeIsolated {
                    guard rate > 0, self.isPlayingInPip == false else { return }
                    self.playerController?.pause()
                }
            }
            .store(in: &cancellations)
    }

    private func saveSelectedRate(rate: Float) {
        if var storage = appStorage, var userSettings = storage.userSettings, userSettings.videoPlaybackSpeed != rate {
            userSettings.videoPlaybackSpeed = rate
            storage.userSettings = userSettings
        }
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
    
    @MainActor
    public func sendCompletion() async {
        do {
            try await playerService.blockCompletionRequest()
        } catch {
            errorPublisher.send(error)
        }
    }
}

extension AVPlayerViewController: PlayerControllerProtocol, @retroactive Sendable {
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

#if DEBUG
@MainActor
extension PlayerViewControllerHolder {
    static var mock: PlayerViewControllerHolder {
        PlayerViewControllerHolder(
            url: URL(string: "")!,
            blockID: "",
            courseID: "",
            selectedCourseTab: 0,
            pipManager: PipManagerProtocolMock(),
            playerTracker: PlayerTrackerProtocolMock(url: URL(string: "")),
            playerDelegate: nil,
            playerService: PlayerService(
                courseID: "",
                blockID: "",
                interactor: CourseInteractor.mock,
                router: CourseRouterMock()
            ),
            appStorage: CoreStorageMock()
        )
    }
}
#endif

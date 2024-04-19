//
//  PlayerViewControllerHolder.swift
//  Core
//
//  Created by Vadim Kuznetsov on 20.03.24.
//

import AVKit
import Combine
import Swinject

public protocol PipManagerProtocol {
    var isPipActive: Bool { get }
    var isPipPlaying: Bool { get }
    
    func holder(
        for url: URL?,
        blockID: String,
        courseID: String,
        selectedCourseTab: Int
    ) -> PlayerViewControllerHolderProtocol?
    func set(holder: PlayerViewControllerHolderProtocol)
    func remove(holder: PlayerViewControllerHolderProtocol)
    func restore(holder: PlayerViewControllerHolderProtocol) async throws
    func pipRatePublisher() -> AnyPublisher<Float, Never>?
    func pauseCurrentPipVideo()
}

#if DEBUG
public class PipManagerProtocolMock: PipManagerProtocol {
    public var isPipActive: Bool {
        false
    }
    
    public var isPipPlaying: Bool {
        false
    }

    public init() {}
    public func holder(
        for url: URL?,
        blockID: String,
        courseID: String,
        selectedCourseTab: Int
    ) -> PlayerViewControllerHolderProtocol? {
        return nil
    }
    public func set(holder: PlayerViewControllerHolderProtocol) {}
    public func remove(holder: PlayerViewControllerHolderProtocol) {}
    public func restore(holder: PlayerViewControllerHolderProtocol) async throws {}
    public func pipRatePublisher() -> AnyPublisher<Float, Never>? { nil }
    public func pauseCurrentPipVideo() {}
}
#endif
import SwiftUI

public protocol PlayerServiceProtocol {
    var router: CourseRouter { get }

    init(courseID: String, blockID: String, interactor: CourseInteractorProtocol, router: CourseRouter)
    func blockCompletionRequest() async throws
    func presentAppReview()
    func presentView(transitionStyle: UIModalTransitionStyle, animated: Bool, content: () -> any View)
    func getSubtitles(url: String, selectedLanguage: String) async throws -> [Subtitle]
}

#if DEBUG
public class PlayerServiceMock: PlayerServiceProtocol {
    private let courseID: String
    private let blockID: String
    private let interactor: CourseInteractorProtocol
    public let router: CourseRouter
    
    public init() {
        courseID = ""
        blockID = ""
        interactor = CourseInteractor.mock
        router = CourseRouterMock()
    }
    
    public required init(courseID: String, blockID: String, interactor: CourseInteractorProtocol, router: CourseRouter) {
        self.courseID = courseID
        self.blockID = blockID
        self.interactor = interactor
        self.router = router
    }
    
    public func blockCompletionRequest() async throws {}
    public func presentAppReview() {}
    public func presentView(transitionStyle: UIModalTransitionStyle, animated: Bool, content: () -> any View) {}
    public func getSubtitles(url: String, selectedLanguage: String) async throws -> [Subtitle] {
        []
    }
}
#endif

public class PlayerService: PlayerServiceProtocol {
    private let courseID: String
    private let blockID: String
    private let interactor: CourseInteractorProtocol
    public let router: CourseRouter
    
    public required init(
        courseID: String,
        blockID: String,
        interactor: CourseInteractorProtocol,
        router: CourseRouter
    ) {
        self.courseID = courseID
        self.blockID = blockID
        self.interactor = interactor
        self.router = router
    }
    
    @MainActor
    public func blockCompletionRequest() async throws {
        try await interactor.blockCompletionRequest(courseID: courseID, blockID: blockID)
        NotificationCenter.default.post(
            name: NSNotification.blockCompletion,
            object: nil
        )
    }

    @MainActor
    public func presentAppReview() {
        router.presentAppReview()
    }
    
    @MainActor
    public func presentView(transitionStyle: UIModalTransitionStyle, animated: Bool, content: () -> any View) {
        router.presentView(transitionStyle: transitionStyle, animated: animated, content: content)
    }

    public func getSubtitles(url: String, selectedLanguage: String) async throws -> [Subtitle] {
        try await interactor.getSubtitles(
            url: url,
            selectedLanguage: selectedLanguage
        )
    }
}

public protocol PlayerControllerProtocol {
    func play()
    func pause()
    func seekTo(to date: Date)
    func stop()
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
    func getService() -> PlayerServiceProtocol
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
        playerDelegate?.isPlayingInPip
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
                        do {
                            try await strongSelf.playerService.blockCompletionRequest()
                        } catch {
                            strongSelf.errorPublisher.send(error)
                        }
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

    public func getService() -> PlayerServiceProtocol {
        playerService
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
            playerService: PlayerServiceMock(
                courseID: "",
                blockID: "",
                interactor: CourseInteractor.mock,
                router: CourseRouterMock()
            )
        )
    }
}

public protocol PlayerDelegateProtocol: AVPlayerViewControllerDelegate {
    var isPlayingInPip: Bool { get }
    var playerHolder: PlayerViewControllerHolderProtocol? { get set }
    init(pipManager: PipManagerProtocol)
}

public class PlayerDelegate: NSObject, PlayerDelegateProtocol {
    private(set) public var isPlayingInPip: Bool = false
    private let pipManager: PipManagerProtocol
    weak public var playerHolder: PlayerViewControllerHolderProtocol?
    
    required public init(pipManager: PipManagerProtocol) {
        self.pipManager = pipManager
        super.init()
    }
    
    public func playerViewControllerWillStartPictureInPicture(_ playerViewController: AVPlayerViewController) {
        isPlayingInPip = true
        if let holder = playerHolder {
            pipManager.set(holder: holder)
        }
    }
    
    public func playerViewController(
        _ playerViewController: AVPlayerViewController,
        failedToStartPictureInPictureWithError error: any Error
    ) {
        isPlayingInPip = false
        if let holder = playerHolder {
            pipManager.remove(holder: holder)
        }
    }
    
    public func playerViewControllerDidStopPictureInPicture(_ playerViewController: AVPlayerViewController) {
        isPlayingInPip = false
        if let holder = playerHolder {
            pipManager.remove(holder: holder)
        }
    }
    
    public func playerViewControllerRestoreUserInterfaceForPictureInPictureStop(
        _ playerViewController: AVPlayerViewController
    ) async -> Bool {
        do {
            if let holder = playerHolder {
                try await pipManager.restore(holder: holder)
            }
            return true
        } catch {
            return false
        }
    }
}

public protocol PlayerTrackerProtocol {
    associatedtype Player
    var player: Player? { get }
    var duration: Double { get }
    var progress: Double { get }
    var isPlaying: Bool { get }
    init(url: URL?)

    func getTimePublisher() -> AnyPublisher<Double, Never>
    func getRatePublisher() -> AnyPublisher<Float, Never>
    func getFinishPublisher() -> AnyPublisher<Void, Never>
}

#if DEBUG
class PlayerTrackerProtocolMock: PlayerTrackerProtocol {
    let player: AVPlayer?
    var duration: Double {
        player?.currentItem?.duration.seconds ?? .nan
    }
    var progress: Double {
        0
    }
    let isPlaying = false

    required init(url: URL?) {
        var item: AVPlayerItem?
        if let url = url {
            item = AVPlayerItem(url: url)
        }
        self.player = AVPlayer(playerItem: item)
    }

    func getTimePublisher() -> AnyPublisher<Double, Never> {
        CurrentValueSubject<Double, Never>(0).eraseToAnyPublisher()
    }

    func getRatePublisher() -> AnyPublisher<Float, Never> {
        CurrentValueSubject<Float, Never>(0).eraseToAnyPublisher()
    }

    func getFinishPublisher() -> AnyPublisher<Void, Never> {
        PassthroughSubject<Void, Never>().eraseToAnyPublisher()
    }
}
#endif
public class PlayerTracker: PlayerTrackerProtocol {
    public let player: AVPlayer?
    public var duration: Double {
        player?.currentItem?.duration.seconds ?? .nan
    }
    public var isPlaying: Bool {
        (player?.rate ?? 0) > 0
    }

    public var progress: Double {
        let currentTime = player?.currentTime().seconds ?? 0
        guard !currentTime.isNaN && !currentTime.isInfinite && duration.isNormal
        else {
            return 0
        }
        
        return currentTime/duration
    }

    private var cancellations: [AnyCancellable] = []
    private var timeObserver: Any?
    private let timePublisher: CurrentValueSubject<Double, Never>
    private let ratePublisher: CurrentValueSubject<Float, Never>
    private let finishPublisher: PassthroughSubject<Void, Never>
    
    public required init(url: URL?) {
        var item: AVPlayerItem?
        if let url = url {
            item = AVPlayerItem(url: url)
        }
        self.player = AVPlayer(playerItem: item)
        timePublisher = CurrentValueSubject(player?.currentTime().seconds ?? 0)
        ratePublisher = CurrentValueSubject(player?.rate ?? 0)
        finishPublisher = PassthroughSubject<Void, Never>()
        observe()
    }

    deinit {
        clear()
    }
    
    private func observe() {
        let interval = CMTime(
            seconds: 0.1,
            preferredTimescale: CMTimeScale(NSEC_PER_SEC)
        )
        
        timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) {[weak self] time in
            self?.timePublisher.send(time.seconds)
        }
        
        player?.publisher(for: \.rate)
            .sink {[weak self] rate in
                self?.ratePublisher.send(rate)
            }
            .store(in: &cancellations)
        NotificationCenter.default.publisher(for: AVPlayerItem.didPlayToEndTimeNotification, object: player?.currentItem)
            .sink {[weak self] _ in
                if self?.player?.currentItem != nil {
                    self?.finishPublisher.send()
                }
            }
            .store(in: &cancellations)
    }
    
    private func clear() {
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
        }
        cancellations.removeAll()
    }
    
    public func getTimePublisher() -> AnyPublisher<Double, Never> {
        timePublisher
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    public func getRatePublisher() -> AnyPublisher<Float, Never> {
        ratePublisher
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    public func getFinishPublisher() -> AnyPublisher<Void, Never> {
        finishPublisher
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

// MARK: YouTube
import YouTubePlayerKit
public class YoutubePlayerTracker: PlayerTrackerProtocol {
    public let player: YouTubePlayer?
    public var duration: Double = 0
    public var isPlaying: Bool {
        player?.isPlaying ?? false
    }

    public var progress: Double {
        timePublisher.value / duration
    }

    private var cancellations: [AnyCancellable] = []
    private let timePublisher: CurrentValueSubject<Double, Never>
    private let ratePublisher: CurrentValueSubject<Float, Never>
    private let finishPublisher: PassthroughSubject<Void, Never>
    
    public required init(url: URL?) {
        if let url = url {
            let videoID = url.absoluteString.replacingOccurrences(of: "https://www.youtube.com/watch?v=", with: "")
            let configuration = YouTubePlayer.Configuration(configure: {
//                $0.autoPlay = !pipManager.isPipActive
                $0.playInline = true
                $0.showFullscreenButton = true
                $0.allowsPictureInPictureMediaPlayback = false
                $0.showControls = true
                $0.useModestBranding = false
                $0.progressBarColor = .white
                $0.showRelatedVideos = false
                $0.showCaptions = false
                $0.showAnnotations = false
                $0.customUserAgent = """
                                     Mozilla/5.0 (iPod; U; CPU iPhone OS 4_3_3 like Mac OS X; ja-jp)
                                     AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8J2 Safari/6533.18.5
                                     """
            })
            self.player = YouTubePlayer(source: .video(id: videoID), configuration: configuration)
            self.player?.pause()
        } else {
            self.player = nil
        }
        
        timePublisher = CurrentValueSubject(0)
        ratePublisher = CurrentValueSubject(0)
        finishPublisher = PassthroughSubject<Void, Never>()
        observe()
    }

    deinit {
        clear()
    }

    private func observe() {
        player?.durationPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] duration in
                self?.duration = duration.value
            }
            .store(in: &cancellations)
        
        player?.currentTimePublisher(updateInterval: 0.1)
            .sink { [weak self] time in
                self?.timePublisher.send(time.value)
            }
            .store(in: &cancellations)
        player?.playbackRatePublisher
            .sink { [weak self] rate in
                self?.ratePublisher.send(Float(rate))
            }
            .store(in: &cancellations)
        player?.playbackStatePublisher
            .sink { [weak self] state in
                guard let self else { return }
                if state == .ended {
                    self.finishPublisher.send()
                }
            }
            .store(in: &cancellations)
    }
    
    private func clear() {
        cancellations.removeAll()
    }
    
    public func getTimePublisher() -> AnyPublisher<Double, Never> {
        timePublisher
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    public func getRatePublisher() -> AnyPublisher<Float, Never> {
        ratePublisher
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    public func getFinishPublisher() -> AnyPublisher<Void, Never> {
        finishPublisher
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
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
        youtubePlayer?.configuration.autoPlay = !pipManager.isPipActive
        addObservers()
    }
    
    private func addObservers() {
        timePublisher
            .sink {[weak self] _ in
                guard let strongSelf = self else { return }
                if strongSelf.playerTracker.progress > 0.8 && !strongSelf.isViewedOnce {
                    strongSelf.isViewedOnce = true
                    Task {
                        do {
                            try await strongSelf.playerService.blockCompletionRequest()
                        } catch {
                            strongSelf.errorPublisher.send(error)
                        }
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
    
    public func getService() -> PlayerServiceProtocol {
        playerService
    }
}

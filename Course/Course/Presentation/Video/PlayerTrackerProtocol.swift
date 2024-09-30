//
//  PlayerTrackerProtocol.swift
//  Course
//
//  Created by Vadim Kuznetsov on 22.04.24.
//

import AVKit
import Combine
import Foundation

public protocol PlayerTrackerProtocol {
    associatedtype Player
    var player: Player? { get }
    var duration: Double { get }
    var progress: Double { get }
    var isPlaying: Bool { get }
    var isReady: Bool { get }
    init(url: URL?)

    func getTimePublisher() -> AnyPublisher<Double, Never>
    func getRatePublisher() -> AnyPublisher<Float, Never>
    func getFinishPublisher() -> AnyPublisher<Void, Never>
    func getReadyPublisher() -> AnyPublisher<Bool, Never>
}

#if DEBUG
class PlayerTrackerProtocolMock: PlayerTrackerProtocol {
    let player: AVPlayer?
    var duration: Double {
        1
    }
    var progress: Double {
        0
    }
    let isPlaying = false
    let isReady = false
    private let timePublisher: CurrentValueSubject<Double, Never>
    private let ratePublisher: CurrentValueSubject<Float, Never>
    private let finishPublisher: PassthroughSubject<Void, Never>
    private let readyPublisher: PassthroughSubject<Bool, Never>

    required init(url: URL?) {
        var item: AVPlayerItem?
        if let url = url {
            item = AVPlayerItem(url: url)
        }
        self.player = AVPlayer(playerItem: item)
        timePublisher = CurrentValueSubject(0)
        ratePublisher = CurrentValueSubject(0)
        finishPublisher = PassthroughSubject<Void, Never>()
        readyPublisher = PassthroughSubject<Bool, Never>()
    }

    func getTimePublisher() -> AnyPublisher<Double, Never> {
        timePublisher.eraseToAnyPublisher()
    }

    func getRatePublisher() -> AnyPublisher<Float, Never> {
        ratePublisher.eraseToAnyPublisher()
    }

    func getFinishPublisher() -> AnyPublisher<Void, Never> {
        finishPublisher.eraseToAnyPublisher()
    }
    
    func getReadyPublisher() -> AnyPublisher<Bool, Never> {
        readyPublisher.eraseToAnyPublisher()
    }
    
    func sendProgress(_ progress: Double) {
        timePublisher.send(progress)
    }
    
    func sendFinish() {
        finishPublisher.send()
    }
}
#endif
// MARK: Video
public class PlayerTracker: PlayerTrackerProtocol {
    public var isReady: Bool = false
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
    private let readyPublisher: PassthroughSubject<Bool, Never>
    
    public required init(url: URL?) {
        var item: AVPlayerItem?
        if let url = url {
            item = AVPlayerItem(url: url)
        }
        self.player = AVPlayer(playerItem: item)
        
        var playerTime = player?.currentTime().seconds ?? 0.0
        if playerTime.isNaN == true {
            playerTime = 0.0
        }
        
        timePublisher = CurrentValueSubject(playerTime)
        ratePublisher = CurrentValueSubject(player?.rate ?? 0)
        finishPublisher = PassthroughSubject<Void, Never>()
        readyPublisher = PassthroughSubject<Bool, Never>()
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
        
        player?.publisher(for: \.status)
            .sink {[weak self] status in
                guard let strongSelf = self else { return }
                strongSelf.isReady = status == .readyToPlay
                strongSelf.readyPublisher.send(strongSelf.isReady)
            }
            .store(in: &cancellations)

        NotificationCenter.default.publisher(
            for: AVPlayerItem.didPlayToEndTimeNotification,
            object: player?.currentItem
        )
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
    
    public func getReadyPublisher() -> AnyPublisher<Bool, Never> {
        readyPublisher
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

// MARK: YouTube
import YouTubePlayerKit
public class YoutubePlayerTracker: PlayerTrackerProtocol {
    public var isReady: Bool = false
    
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
    private let readyPublisher: PassthroughSubject<Bool, Never>
    
    public required init(url: URL?) {
        if let url = url {
            let videoID = url.absoluteString.replacingOccurrences(of: "https://www.youtube.com/watch?v=", with: "")
            let configuration = YouTubePlayer.Configuration(configure: {
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
        readyPublisher = PassthroughSubject<Bool, Never>()
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
        player?.statePublisher
            .sink { [weak self] state in
                switch state {
                case .ready:
                    self?.isReady = true
                    self?.readyPublisher.send(true)
                default:
                    self?.isReady = false
                    self?.readyPublisher.send(false)
                }
            }
            .store(in: &cancellations)
        
        player?.playbackStatePublisher
            .sink { [weak self] state in
                guard let strongSelf = self else { return }
                switch state {
                case .playing:
                    strongSelf.ratePublisher.send(1)
                case .ended:
                    strongSelf.ratePublisher.send(0)
                    strongSelf.finishPublisher.send()
                default:
                    strongSelf.ratePublisher.send(0)
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
    
    public func getReadyPublisher() -> AnyPublisher<Bool, Never> {
        readyPublisher
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

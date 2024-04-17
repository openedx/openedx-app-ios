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
    
    func holder(for url: URL?, blockID: String, courseID: String, selectedCourseTab: Int) -> PlayerViewControllerHolder?
    func set(holder: PlayerViewControllerHolder)
    func remove(holder: PlayerViewControllerHolder)
    func restore(holder: PlayerViewControllerHolder) async throws
    func pipRatePublisher() -> AnyPublisher<Float, Never>?
    func pauseCurrentPipVideo()
}

#if DEBUG
public class PipManagerProtocolMock: PipManagerProtocol {
    public var isPipActive: Bool {
        false
    }

    public init() {}
    public func holder(
        for url: URL?,
        blockID: String,
        courseID: String,
        selectedCourseTab: Int
    ) -> PlayerViewControllerHolder? {
        return nil
    }
    public func set(holder: PlayerViewControllerHolder) {}
    public func remove(holder: PlayerViewControllerHolder) {}
    public func restore(holder: PlayerViewControllerHolder) async throws {}
    public func pipRatePublisher() -> AnyPublisher<Float, Never>? { nil }
    public func pauseCurrentPipVideo() {}
}
#endif

public class PlayerViewControllerHolder: NSObject, AVPlayerViewControllerDelegate {
    public let url: URL?
    public let blockID: String
    public let courseID: String
    public let selectedCourseTab: Int
    public var isPlayingInPip: Bool = false
    public var isOtherPlayerInPip: Bool {
        let holder = pipManager.holder(
            for: url,
            blockID: blockID,
            courseID: courseID,
            selectedCourseTab: selectedCourseTab
        )
        return holder == nil && pipManager.isPipActive
    }
    public var duration: Double {
        guard let duration = playerController.player?.currentItem?.duration else { return .nan }
        return duration.seconds
    }
    private let videoResolution: CGSize
    private var cancellations: [AnyCancellable] = []
    
    let pipManager: PipManagerProtocol
    
    public lazy var playerController: AVPlayerViewController = {
        let playerController = AVPlayerViewController()
        playerController.modalPresentationStyle = .fullScreen
        playerController.allowsPictureInPicturePlayback = true
        playerController.canStartPictureInPictureAutomaticallyFromInline = true
        playerController.delegate = self
        if let url = url {
            let player = AVPlayer()
            player.replaceCurrentItem(with: AVPlayerItem(url: url))
            player.currentItem?.preferredMaximumResolution = videoResolution
            addSubscriptions(to: player)
            playerController.player = player
        }
        return playerController
    }()
    
    public init(
        url: URL?,
        blockID: String,
        courseID: String,
        selectedCourseTab: Int,
        videoResolution: CGSize,
        pipManager: PipManagerProtocol
    ) {
        self.url = url
        self.blockID = blockID
        self.courseID = courseID
        self.selectedCourseTab = selectedCourseTab
        self.videoResolution = videoResolution
        self.pipManager = pipManager
    }
    
    public func playerViewControllerWillStartPictureInPicture(_ playerViewController: AVPlayerViewController) {
        isPlayingInPip = true
        pipManager.set(holder: self)
    }
    
    public func playerViewController(
        _ playerViewController: AVPlayerViewController,
        failedToStartPictureInPictureWithError error: any Error
    ) {
        isPlayingInPip = false
        pipManager.remove(holder: self)
    }
    
    public func playerViewControllerDidStopPictureInPicture(_ playerViewController: AVPlayerViewController) {
        isPlayingInPip = false
        pipManager.remove(holder: self)
    }
    
    public func playerViewControllerRestoreUserInterfaceForPictureInPictureStop(
        _ playerViewController: AVPlayerViewController
    ) async -> Bool {
        do {
            try await Container.shared.resolve(PipManagerProtocol.self)?.restore(holder: self)
            return true
        } catch {
            return false
        }
    }
    
    public override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? PlayerViewControllerHolder else {
            return false
        }
        return url?.absoluteString == object.url?.absoluteString &&
        courseID == object.courseID &&
        blockID == object.blockID &&
        selectedCourseTab == object.selectedCourseTab
    }
    
    public func pausePipIfNeed() {
        if !isPlayingInPip {
            pipManager.pauseCurrentPipVideo()
        }
    }
    
    public func pipRatePublisher() -> AnyPublisher<Float, Never>? {
        pipManager.pipRatePublisher()
    }
    
    private func addSubscriptions(to player: AVPlayer) {
        
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
            pipManager: PipManagerProtocolMock()
        )
    }
}

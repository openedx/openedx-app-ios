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

    private let pipManager: PipManagerProtocol

    public lazy var playerController: AVPlayerViewController = {
        let playerController = AVPlayerViewController()
        playerController.delegate = self
        return playerController
    }()

    public init(
        url: URL?,
        blockID: String,
        courseID: String,
        selectedCourseTab: Int
    ) {
        self.url = url
        self.blockID = blockID
        self.courseID = courseID
        self.selectedCourseTab = selectedCourseTab
        self.pipManager = Container.shared.resolve(PipManagerProtocol.self)!
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
}

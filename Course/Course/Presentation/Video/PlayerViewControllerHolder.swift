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
    func holder(for url: URL?, blockID: String, courseID: String, isVideoTab: Bool) -> PlayerViewControllerHolder?
    func set(holder: PlayerViewControllerHolder)
    func remove(holder: PlayerViewControllerHolder)
    func restore(holder: PlayerViewControllerHolder) async throws
    func appearancePublisher(for holder: PlayerViewControllerHolder) -> AnyPublisher<Void, Never>?
}

#if DEBUG
public class PipManagerProtocolMock: PipManagerProtocol {
    public init() {}
    public func holder(
        for url: URL?,
        blockID: String,
        courseID: String,
        isVideoTab: Bool
    ) -> PlayerViewControllerHolder? {
        return nil
    }
    public func set(holder: PlayerViewControllerHolder) {}
    public func remove(holder: PlayerViewControllerHolder) {}
    public func restore(holder: PlayerViewControllerHolder) async throws {}
    public func appearancePublisher(for holder: PlayerViewControllerHolder) -> AnyPublisher<Void, Never>? {
        return nil
    }
}
#endif

public class PlayerViewControllerHolder: NSObject, AVPlayerViewControllerDelegate {
    public let url: URL?
    public let blockID: String
    public let courseID: String
    public let isVideoTab: Bool
    public var isPipModeActive: Bool = false

    public lazy var playerController: AVPlayerViewController = {
        let playerController = AVPlayerViewController()
        playerController.delegate = self
        return playerController
    }()

    public init(
        url: URL?,
        blockID: String,
        courseID: String,
        isVideoTab: Bool
    ) {
        self.url = url
        self.blockID = blockID
        self.courseID = courseID
        self.isVideoTab = isVideoTab
    }
    
    public func playerViewControllerWillStartPictureInPicture(_ playerViewController: AVPlayerViewController) {
        isPipModeActive = true
        Container.shared.resolve(PipManagerProtocol.self)?.set(holder: self)
    }
    
//    func playerViewControllerDidStartPictureInPicture(_ playerViewController: AVPlayerViewController) {
//
//    }
    
    public func playerViewController(_ playerViewController: AVPlayerViewController, failedToStartPictureInPictureWithError error: any Error) {
        isPipModeActive = false
        Container.shared.resolve(PipManagerProtocol.self)?.remove(holder: self)
        print("ALARM failed to start \(error)")
    }
    
    public func playerViewControllerDidStopPictureInPicture(_ playerViewController: AVPlayerViewController) {
        isPipModeActive = false
        Container.shared.resolve(PipManagerProtocol.self)?.remove(holder: self)
        print("ALARM did stop picture in picture")
    }
    
//    func playerViewControllerDidStopPictureInPicture(_ playerViewController: AVPlayerViewController) {
//
//    }
    public func playerViewControllerRestoreUserInterfaceForPictureInPictureStop(_ playerViewController: AVPlayerViewController) async -> Bool {
        print("ALARM restore controller")
        do {
            try await Container.shared.resolve(PipManagerProtocol.self)?.restore(holder: self)
            print("ALARM restore completed")
            return true
        } catch {
            print("ALARM restore failed")
            return false
        }
    }
    
    static func == (lhs: PlayerViewControllerHolder, rhs: PlayerViewControllerHolder) -> Bool {
        lhs.url?.absoluteString == rhs.url?.absoluteString &&
        lhs.courseID == rhs.courseID &&
        lhs.blockID == rhs.blockID &&
        lhs.isVideoTab == rhs.isVideoTab
    }
}


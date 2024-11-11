//
//  PlayerDelegateProtocol.swift
//  Course
//
//  Created by Vadim Kuznetsov on 22.04.24.
//

import AVKit

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

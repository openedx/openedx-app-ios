//
//  PlayerDelegateProtocol.swift
//  Course
//
//  Created by Vadim Kuznetsov on 22.04.24.
//

import AVKit

public protocol PlayerDelegateProtocol: AVPlayerViewControllerDelegate, Sendable {
    var isPlayingInPip: Bool { get }
    var playerHolder: PlayerViewControllerHolderProtocol? { get set }
    init(pipManager: PipManagerProtocol)
}

public final class PlayerDelegate: NSObject, PlayerDelegateProtocol {
    private(set) public nonisolated(unsafe) var isPlayingInPip: Bool = false
    private let pipManager: PipManagerProtocol
    weak public nonisolated(unsafe) var playerHolder: PlayerViewControllerHolderProtocol?
    
    required public init(pipManager: PipManagerProtocol) {
        self.pipManager = pipManager
        super.init()
    }
    
    nonisolated public func playerViewControllerWillStartPictureInPicture(
        _ playerViewController: AVPlayerViewController
    ) {
        isPlayingInPip = true
        if let holder = playerHolder {
            Task { @MainActor in
                pipManager.set(holder: holder)
            }
        }
    }
    
    public func playerViewController(
        _ playerViewController: AVPlayerViewController,
        failedToStartPictureInPictureWithError error: any Error
    ) {
        Task { @MainActor in
            isPlayingInPip = false
            if let holder = playerHolder {
                pipManager.remove(holder: holder)
            }
        }
    }
    
    public func playerViewControllerDidStopPictureInPicture(_ playerViewController: AVPlayerViewController) {
        isPlayingInPip = false
        Task { @MainActor in
            if let holder = playerHolder {
                pipManager.remove(holder: holder)
            }
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

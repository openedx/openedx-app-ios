//
//  PlayerViewController.swift
//  Course
//
//  Created by Vladimir Chekyrta on 13.02.2023.
//

import SwiftUI
import _AVKit_SwiftUI

struct PlayerViewController: UIViewControllerRepresentable {
    
    var videoURL: URL?
    var controller: AVPlayerViewController
    var progress: ((Float) -> Void)
    var seconds: ((Double) -> Void)
    
    init(
        videoURL: URL?, controller: AVPlayerViewController,
        progress: @escaping ((Float) -> Void),
        seconds: @escaping ((Double) -> Void)
    ) {
        self.videoURL = videoURL
        self.controller = controller
        self.progress = progress
        self.seconds = seconds
    }
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        controller.modalPresentationStyle = .fullScreen
        controller.allowsPictureInPicturePlayback = true
        controller.player = AVPlayer()
        
        addPeriodicTimeObserver(
            controller,
            currentProgress: { progress, seconds in
                self.progress(progress)
                self.seconds(seconds)
            }
        )
        return controller
    }
    
    private func addPeriodicTimeObserver(
        _ controller: AVPlayerViewController,
        currentProgress: @escaping ((Float, Double) -> Void)
    ) {
        let interval = CMTime(
            seconds: 0.1,
            preferredTimescale: CMTimeScale(NSEC_PER_SEC)
        )
        
        self.controller.player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { time in
            var progress: Float = .zero
            let currentSeconds = CMTimeGetSeconds(time)
            guard let duration = controller.player?.currentItem?.duration else { return }
            let totalSeconds = CMTimeGetSeconds(duration)
            progress = Float(currentSeconds / totalSeconds)
            currentProgress(progress, currentSeconds)
        }
    }
    
    func updateUIViewController(_ playerController: AVPlayerViewController, context: Context) {
        DispatchQueue.main.async {
            let asset = playerController.player?.currentItem?.asset as? AVURLAsset
            if asset?.url.absoluteString != videoURL?.absoluteString {
                if playerController.player == nil {
                    playerController.player = AVPlayer()
                }
                playerController.player?.replaceCurrentItem(with: AVPlayerItem(url: videoURL!))
                addPeriodicTimeObserver(playerController, currentProgress: { progress, seconds in
                    self.progress(progress)
                    self.seconds(seconds)
                })
            }
        }
    }
}

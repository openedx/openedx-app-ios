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
    public var progress: ((Float) -> Void)
    
    init(videoURL: URL?, controller: AVPlayerViewController,
         progress: @escaping ((Float) -> Void)) {
        self.videoURL = videoURL
        self.controller = controller
        self.progress = progress
    }
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        controller.modalPresentationStyle = .fullScreen
        controller.allowsPictureInPicturePlayback = true
        
        addPeriodicTimeObserver(controller, currentProgress: { progress in
            self.progress(progress)
        })
        return controller
    }
    
    private func addPeriodicTimeObserver(_ controller: AVPlayerViewController,
                                         currentProgress: @escaping ((Float) -> Void)) {
        let interval = CMTime(seconds: 0.5,
                              preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        
        self.controller.player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { time in
            var progress: Float = .zero
            let currentSeconds = CMTimeGetSeconds(time)
            guard let duration = controller.player?.currentItem?.duration else { return }
            let totalSeconds = CMTimeGetSeconds(duration)
            progress = Float(currentSeconds/totalSeconds)
            currentProgress(progress)
        }
    }
    
    func updateUIViewController(_ playerController: AVPlayerViewController, context: Context) {
        DispatchQueue.main.async {
            if (playerController.player?.currentItem?.asset as? AVURLAsset)?.url.absoluteString != videoURL?.absoluteString {
                playerController.player = AVPlayer(url: videoURL!)
            }
        }
    }
}

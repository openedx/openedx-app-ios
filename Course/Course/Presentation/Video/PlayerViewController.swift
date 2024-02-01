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
    var videoResolution: CGSize
    var controller: AVPlayerViewController
    var progress: ((Float) -> Void)
    var seconds: ((Double) -> Void)
    
    init(
        videoURL: URL?, 
        controller: AVPlayerViewController,
        bitrate: CGSize,
        progress: @escaping ((Float) -> Void),
        seconds: @escaping ((Double) -> Void)
    ) {
        self.videoURL = videoURL
        self.controller = controller
        self.videoResolution = bitrate
        self.progress = progress
        self.seconds = seconds
    }
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        controller.modalPresentationStyle = .fullScreen
        controller.allowsPictureInPicturePlayback = true
        let player = AVPlayer()
        controller.player = player
        context.coordinator.setPlayer(AVPlayer()) { progress, seconds in
            self.progress(progress)
            self.seconds(seconds)
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch {
            print(error.localizedDescription)
        }
        
        return controller
    }
    
    func updateUIViewController(_ playerController: AVPlayerViewController, context: Context) {
        DispatchQueue.main.async {
            let asset = playerController.player?.currentItem?.asset as? AVURLAsset
            if asset?.url.absoluteString != videoURL?.absoluteString {
                var player = playerController.player
                if player == nil {
                    player = AVPlayer()
                    player?.allowsExternalPlayback = true
                    playerController.player = player
                }
                player?.replaceCurrentItem(with: AVPlayerItem(url: videoURL!))
                player?.currentItem?.preferredMaximumResolution = videoResolution
                
                context.coordinator.setPlayer(player) { progress, seconds in
                    self.progress(progress)
                    self.seconds(seconds)
                }
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    static func dismantleUIViewController(_ uiViewController: AVPlayerViewController, coordinator: Coordinator) {
        coordinator.setPlayer(nil) { _, _ in }
    }
        
    class Coordinator {
        var currentPlayer: AVPlayer?
        var observer: Any?
        
        func setPlayer(_ player: AVPlayer?, currentProgress: @escaping ((Float, Double) -> Void)) {
            if let observer = observer {
                currentPlayer?.removeTimeObserver(observer)
                currentPlayer?.pause()
            }
            
            let interval = CMTime(
                seconds: 0.1,
                preferredTimescale: CMTimeScale(NSEC_PER_SEC)
            )
            
            observer = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) {[weak player] time in
                var progress: Float = .zero
                let currentSeconds = CMTimeGetSeconds(time)
                guard let duration = player?.currentItem?.duration else { return }
                let totalSeconds = CMTimeGetSeconds(duration)
                progress = Float(currentSeconds / totalSeconds)
                currentProgress(progress, currentSeconds)
            }
            
            currentPlayer = player
            
        }
    }
}

//
//  PlayerViewController.swift
//  Course
//
//  Created by Vladimir Chekyrta on 13.02.2023.
//

import Combine
import Core
import SwiftUI
import _AVKit_SwiftUI

struct PlayerViewController: UIViewControllerRepresentable {
    var playerHolder: PlayerViewControllerHolder
    var seconds: ((Double) -> Void)
    
    init(
        playerHolder: PlayerViewControllerHolder,
        seconds: @escaping ((Double) -> Void)
    ) {
        self.playerHolder = playerHolder
        self.seconds = seconds
    }
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch {
            print(error.localizedDescription)
        }
        
        return playerHolder.playerController
    }
    
    func updateUIViewController(_ playerController: AVPlayerViewController, context: Context) {
        context.coordinator.setPlayer(playerController.player, timeBlock: seconds)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    static func dismantleUIViewController(_ uiViewController: AVPlayerViewController, coordinator: Coordinator) {
        coordinator.setPlayer(nil)
    }
        
    class Coordinator {
        var currentPlayer: AVPlayer?
        var observer: Any?
        
        weak var currentHolder: PlayerViewControllerHolder?
                
        func setPlayer(_ player: AVPlayer?, timeBlock: ((Double) -> Void)? = nil) {
            if let observer = observer {
                currentPlayer?.removeTimeObserver(observer)
                if currentHolder?.isPlayingInPip == false {
                    currentPlayer?.pause()
                }
            }
            
            let interval = CMTime(
                seconds: 0.1,
                preferredTimescale: CMTimeScale(NSEC_PER_SEC)
            )
            
            observer = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { time in
                let currentSeconds = CMTimeGetSeconds(time)
                timeBlock?(currentSeconds)
//                var progress: Float = .zero
//                guard let duration = player?.currentItem?.duration else { return }
//                let totalSeconds = CMTimeGetSeconds(duration)
//                progress = Float(currentSeconds / totalSeconds)
//                currentProgress(progress, currentSeconds)
            }
            
//            NotificationCenter.default.publisher(for: AVPlayerItem.didPlayToEndTimeNotification, object: player?.currentItem)
//                .sink {[weak self] rate in
//                    print("ALARM: did end to play for item \(self?.currentPlayer?.currentItem)")
//                }
//                .store(in: &cancellations)
            
//            player?.publisher(for: \.rate)
//                .sink {[weak self] rate in
//                    guard rate > 0 else { return }
//                    self?.currentHolder?.pausePipIfNeed()
//                }
//                .store(in: &cancellations)
//            currentHolder?.pipRatePublisher()?
//                .sink {[weak self] rate in
//                    guard rate > 0 else { return }
//                    if self?.currentHolder?.isPlayingInPip == false {
//                        self?.currentPlayer?.pause()
//                    }
//                }
//                .store(in: &cancellations)

            currentPlayer = player
            
        }
    }
}

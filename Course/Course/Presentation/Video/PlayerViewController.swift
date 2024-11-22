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
    var playerController: CustomAVPlayerViewController
    @Binding var subtitleText: String

    func makeUIViewController(context: Context) -> CustomAVPlayerViewController {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch {
            print(error.localizedDescription)
        }
        
        return playerController
    }
    
    func updateUIViewController(_ playerController: CustomAVPlayerViewController, context: Context) {
        playerController.subtitleText = subtitleText
    }
}

class CustomAVPlayerViewController: AVPlayerViewController {
    private let subtitleLabel = UILabel()

    var subtitleText: String = "" {
        didSet {
            subtitleLabel.text = subtitleText
        }
    }
    
    var hideSubtitle: Bool = false {
        didSet {
            subtitleLabel.isHidden = hideSubtitle
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure the subtitle label
        subtitleLabel.textColor = .white
        subtitleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        subtitleLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        subtitleLabel.layer.cornerRadius = 8
        subtitleLabel.layer.masksToBounds = true
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.isHidden = true
        
        self.delegate = self

        // Add subtitle label to the content overlay view of AVPlayerViewController
        contentOverlayView?.addSubview(subtitleLabel)

        // Set constraints for the subtitle label
        NSLayoutConstraint.activate([
            subtitleLabel.centerXAnchor.constraint(equalTo: contentOverlayView!.centerXAnchor),
            subtitleLabel.bottomAnchor.constraint(equalTo: contentOverlayView!.bottomAnchor, constant: -20),
            subtitleLabel.widthAnchor.constraint(lessThanOrEqualTo: contentOverlayView!.widthAnchor, multiplier: 0.9)
        ])
    }
}

extension CustomAVPlayerViewController: AVPlayerViewControllerDelegate {
    func playerViewController(
        _ playerViewController: AVPlayerViewController,
        willBeginFullScreenPresentationWithAnimationCoordinator coordinator: any UIViewControllerTransitionCoordinator
    ) {
        hideSubtitle = false
    }
    
    func playerViewController(
        _ playerViewController: AVPlayerViewController,
        willEndFullScreenPresentationWithAnimationCoordinator coordinator: any UIViewControllerTransitionCoordinator
    ) {
        hideSubtitle = true
    }
}

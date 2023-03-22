//
//  AVPlayerViewControllerExtension.swift
//  Core
//
//  Created by  Stepanok Ivan on 24.11.2022.
//

import AVKit

public extension AVPlayerViewController {
    func enterFullScreen(animated: Bool) {
        perform(NSSelectorFromString("enterFullScreenAnimated:completionHandler:"), with: animated, with: nil)
    }
    func exitFullScreen(animated: Bool) {
        perform(NSSelectorFromString("exitFullScreenAnimated:completionHandler:"), with: animated, with: nil)
    }
}

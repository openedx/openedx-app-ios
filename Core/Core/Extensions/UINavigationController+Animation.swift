//
//  UINavigationController+Animation.swift
//  Core
//
//  Created by Vladimir Chekyrta on 23.02.2023.
//

import Foundation
import UIKit

public extension UINavigationController {
    
    func popFade(
        transitionType type: CATransitionType = .fade,
        duration: CFTimeInterval = 0.3
    ) {
        addTransition(transitionType: type, duration: duration)
        popViewController(animated: false)
    }
    
    func pushFade(
        viewController vc: UIViewController,
        transitionType type: CATransitionType = .fade,
        duration: CFTimeInterval = 0.3
    ) {
        addTransition(transitionType: type, duration: duration)
        pushViewController(vc, animated: UIAccessibility.isVoiceOverRunning)
    }
    
    private func addTransition(
        transitionType type: CATransitionType = .fade,
        duration: CFTimeInterval = 0.3
    ) {
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = type
        view.layer.add(transition, forKey: nil)
    }
    
}

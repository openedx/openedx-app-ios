//
//  UIApplicationExtension.swift
//  Core
//
//  Created by  Stepanok Ivan on 15.06.2023.
//

import UIKit

extension UIApplication {
    
    public var keyWindow: UIWindow? {
        UIApplication.shared.windows.first { $0.isKeyWindow }
    }
    
    public func endEditing(force: Bool = true) {
        windows.forEach { $0.endEditing(force) }
    }
    
    public class func topViewController(
        controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
    ) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

extension UINavigationController {
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        navigationBar.topItem?.backButtonDisplayMode = .minimal
        navigationBar.backIndicatorImage = CoreAssets.arrowLeft.image
        navigationBar.backIndicatorTransitionMaskImage = CoreAssets.arrowLeft.image
        navigationBar.titleTextAttributes = [.foregroundColor: CoreAssets.textPrimary.color]
    }
}

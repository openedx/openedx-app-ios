//
//  UIApplicationExtension.swift
//  Core
//
//  Created by  Stepanok Ivan on 15.06.2023.
//

import UIKit
import Theme

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
        navigationBar.barTintColor = .clear
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        
        let image = CoreAssets.arrowLeft.image
        navigationBar.backIndicatorImage = image.withTintColor(Theme.UIColors.accentColor)
        navigationBar.backItem?.backButtonTitle = " "
        navigationBar.backIndicatorTransitionMaskImage = image.withTintColor(Theme.UIColors.accentColor)
        navigationBar.titleTextAttributes = [.foregroundColor: Theme.UIColors.textPrimary]
    }
}

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if #available(iOS 17, *) {
            return false
        } else {
            return viewControllers.count > 1
        }
    }
}

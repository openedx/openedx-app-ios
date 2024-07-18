//
//  UIApplicationExtension.swift
//  Core
//
//  Created by  Stepanok Ivan on 15.06.2023.
//

import UIKit
import Theme

public extension UIApplication {
    
    var keyWindow: UIWindow? {
        UIApplication.shared.windows.first { $0.isKeyWindow }
    }
    
    func endEditing(force: Bool = true) {
        windows.forEach { $0.endEditing(force) }
    }
    
    class func topViewController(
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
    
    var windowInsets: UIEdgeInsets {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let window = windowScene.windows.first else {
            return .zero
        }

        return window.safeAreaInsets
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
        navigationBar.backIndicatorImage = image.withTintColor(Theme.UIColors.accentXColor)
        navigationBar.backIndicatorTransitionMaskImage = image.withTintColor(Theme.UIColors.accentXColor)
        navigationBar.titleTextAttributes = [
            .foregroundColor: Theme.UIColors.navigationBarTintColor,
            .font: Theme.UIFonts.titleMedium()
        ]
        
        UISegmentedControl.appearance().setTitleTextAttributes(
            [
                .foregroundColor: Theme.Colors.textPrimary.uiColor(),
                .font: Theme.UIFonts.labelLarge()
            ],
            for: .normal
        )
        UISegmentedControl.appearance().setTitleTextAttributes(
            [
                .foregroundColor: Theme.Colors.primaryButtonTextColor.uiColor(),
                .font: Theme.UIFonts.labelLarge()
            ],
            for: .selected
        )
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Theme.Colors.accentXColor)
        
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = Theme.UIColors.accentXColor
    }
}

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
        navigationItem.backButtonDisplayMode = .minimal
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if #available(iOS 17, *) {
            return false
        } else {
            return viewControllers.count > 1
        }
    }
}

//
//  UIAlertController+BlockActions.swift
//  Core
//
//  Created by Saeed Bashir on 4/25/24.
//

import Foundation
import UIKit

private let cancelButtonIndex = 0
private let destructiveButtonIndex = 1
private let firstOtherButtonIndex = 2

// Adding this to complete the IAP flow
// Will replace it with new designs when will be provided by design team

public extension UIAlertController {
    
    @discardableResult func showAlert(
        with title: String?,
        message: String?,
        preferredStyle: UIAlertController.Style,
        cancelButtonTitle: String? = nil,
        destructiveButtonTitle: String?,
        otherButtonsTitle: [String]?,
        tapBlock: ((
            _ controller: UIAlertController,
            _ action: UIAlertAction, _ buttonIndex: Int
        ) -> Void)?,
        textFieldWithConfigurationHandler: ((_ textField: UITextField) -> Void)? = nil
    ) -> UIAlertController? {
        
        guard let controller = UIApplication.topViewController() else { return nil }
        
        return showIn(
            viewController: controller,
            title: title,
            message: message,
            preferredStyle: preferredStyle
            , cancelButtonTitle: cancelButtonTitle,
            destructiveButtonTitle: destructiveButtonTitle,
            otherButtonsTitle: otherButtonsTitle,
            tapBlock: tapBlock
        )
    }
    
    @discardableResult func showIn(
        viewController pController: UIViewController? = nil,
        title: String?,
        message: String?,
        preferredStyle: UIAlertController.Style,
        cancelButtonTitle: String? = nil,
        destructiveButtonTitle: String?,
        otherButtonsTitle: [String]?,
        tapBlock: ((
            _ controller: UIAlertController,
            _ action: UIAlertAction,
            _ buttonIndex: Int
        ) -> Void)?,
        textFieldWithConfigurationHandler: ((_ textField: UITextField) -> Void)? = nil,
        autoPresent: Bool = true
    ) -> UIAlertController {
        
        let controller = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        if let textFieldHandler = textFieldWithConfigurationHandler {
            controller.addTextField { textField in
                textFieldHandler(textField)
            }
        }
        
        if let cancelText = cancelButtonTitle {
            let cancelAction = UIAlertAction(
                title: cancelText,
                style: .cancel,
                handler: { (action) in
                    if let tap = tapBlock {
                        tap(controller, action, cancelButtonIndex)
                    }
                })
            controller.addAction(cancelAction)
        }
        
        if let destructiveText = destructiveButtonTitle {
            let destructiveAction = UIAlertAction(
                title: destructiveText,
                style: .destructive,
                handler: { (action) in
                    if let tap = tapBlock {
                        tap(controller, action, destructiveButtonIndex)
                    }
                })
            controller.addAction(destructiveAction)
        }
        
        if let otherButtonsText = otherButtonsTitle {
            for otherTitle in otherButtonsText {
                let otherAction = UIAlertAction(
                    title: otherTitle,
                    style: .default, handler: { (action) in
                        if let tap = tapBlock {
                            tap(controller, action, destructiveButtonIndex)
                        }
                    })
                controller.addAction(otherAction)
            }
        }
        controller.view.tintColor = .systemBlue
        
        if autoPresent == true {
            var onController = pController
            if onController == nil {
                onController = UIApplication.topViewController()
            }
            onController?.present(controller, animated: true, completion: nil)
        }
        
        return controller
    }
    
    @discardableResult func showAlert(
        withTitle title: String?,
        message: String?,
        cancelButtonTitle: String? = nil,
        onViewController viewController: UIViewController
    ) -> UIAlertController {
        return showIn(
            viewController: viewController,
            title: title,
            message: message,
            preferredStyle: UIAlertController.Style.alert,
            cancelButtonTitle: cancelButtonTitle,
            destructiveButtonTitle: nil,
            otherButtonsTitle: nil,
            tapBlock: nil
        )
        
    }
    
    @discardableResult func showAlert(
        withTitle title: String?,
        message: String?,
        onViewController viewController: UIViewController
    ) -> UIAlertController {
        return showAlert(
            withTitle: title,
            message: message,
            cancelButtonTitle: CoreLocalization.ok,
            onViewController: viewController
        )
    }
    
    @discardableResult func showAlert(
        withTitle title: String?,
        message: String?,
        cancelButtonTitle: String? = nil,
        onViewController viewController: UIViewController,
        tapBlock: ((
            _ controller: UIAlertController,
            _ action: UIAlertAction,
            _ buttonIndex: Int
        ) -> Void)?) -> UIAlertController {
        
        return showIn(
            viewController: viewController,
            title: title,
            message: message,
            preferredStyle: UIAlertController.Style.alert,
            cancelButtonTitle: cancelButtonTitle,
            destructiveButtonTitle: nil,
            otherButtonsTitle: nil,
            tapBlock: tapBlock
        )
    }

    @discardableResult func alert(
        withTitle title: String?,
        message: String?,
        cancelButtonTitle: String? = nil,
        tapBlock: ((
            _ controller: UIAlertController,
            _ action: UIAlertAction,
            _ buttonIndex: Int
        ) -> Void)?
    ) -> UIAlertController {
        return showIn(
            title: title,
            message: message,
            preferredStyle: UIAlertController.Style.alert,
            cancelButtonTitle: cancelButtonTitle,
            destructiveButtonTitle: nil,
            otherButtonsTitle: nil,
            tapBlock: tapBlock,
            autoPresent: false
        )
    }
    
    func addButton(
        withTitle title: String,
        style: UIAlertAction.Style,
        actionBlock: ((_ action: UIAlertAction) -> Void)?
    ) {
        let alertAction = UIAlertAction(
            title: title,
            style: style,
            handler: { (action) in
                if let tap = actionBlock {
                    tap(action)
                }
            })
        addAction(alertAction)
    }
    
    func addButton(
        withTitle title: String,
        actionBlock: ((_ action: UIAlertAction) -> Void)?) {
            let alertAction = UIAlertAction(
                title: title,
                style: .default,
                handler: { (action) in
                    if let tap = actionBlock {
                        tap(action)
                    }
                })
            addAction(alertAction)
        }
    
    var isVisible: Bool {
        return view != nil
    }
    
}

extension UIAlertController {
    convenience init(
        style: UIAlertController.Style,
        childController: UIViewController,
        title: String? = nil,
        message: String? = nil
    ) {
        self.init(title: title, message: message, preferredStyle: style)
        setValue(childController, forKey: "contentViewController")
    }
}

fileprivate extension UIActivityIndicatorView {
    func scaleIndicator(factor: CGFloat) {
        transform = CGAffineTransform(scaleX: factor, y: factor)
    }
}

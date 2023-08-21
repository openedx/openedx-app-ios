//
//  Router.swift
//  Core
//
//  Created by Vladimir Chekyrta on 13.09.2022.
//

import Foundation
import SwiftUI

//sourcery: AutoMockable
public protocol BaseRouter {
    
    func backToRoot(animated: Bool)
    
    func back(animated: Bool)
    
    func backWithFade()
    
    func dismiss(animated: Bool)
    
    func removeLastView(controllers: Int)

    func showMainScreen()

    func showLoginScreen()

    func showRegisterScreen()
    
    func showForgotPasswordScreen()
        
    func presentAlert(
        alertTitle: String,
        alertMessage: String,
        positiveAction: String,
        onCloseTapped: @escaping () -> Void,
        okTapped: @escaping () -> Void,
        type: AlertViewType
    )
    
    func presentAlert(
        alertTitle: String,
        alertMessage: String,
        nextSectionName: String?,
        action: String,
        image: SwiftUI.Image,
        onCloseTapped: @escaping () -> Void,
        okTapped: @escaping () -> Void,
        nextSectionTapped: @escaping () -> Void
    )
    
    func presentView(transitionStyle: UIModalTransitionStyle, view: any View)
    
    func presentView(transitionStyle: UIModalTransitionStyle, content: () -> any View)

}

extension BaseRouter {
    public func backToRoot(animated: Bool = true) {
        backToRoot(animated: animated)
    }
    
    public func back(animated: Bool = true) {
        back(animated: animated)
    }
}

// Mark - For testing and SwiftUI preview
#if DEBUG
open class BaseRouterMock: BaseRouter {

    public init() {}

    public func dismiss(animated: Bool) {}

    public func showMainScreen() {}

    public func showLoginScreen() {}

    public func showRegisterScreen() {}
    
    public func showForgotPasswordScreen() {}
    
    public func backToRoot(animated: Bool) {}
        
    public func back(animated: Bool) {}
    
    public func backWithFade() {}
    
    public func removeLastView(controllers: Int) {}
        
    public func presentAlert(
        alertTitle: String,
        alertMessage: String,
        positiveAction: String,
        onCloseTapped: @escaping () -> Void,
        okTapped: @escaping () -> Void,
        type: AlertViewType
    ) {}
    
    public func presentAlert(
        alertTitle: String,
        alertMessage: String,
        nextSectionName: String? = nil,
        action: String,
        image: SwiftUI.Image,
        onCloseTapped: @escaping () -> Void,
        okTapped: @escaping () -> Void,
        nextSectionTapped: @escaping () -> Void
    ) {}

    public func presentView(transitionStyle: UIModalTransitionStyle, view: any View) {}

    public func presentView(transitionStyle: UIModalTransitionStyle, content: () -> any View) {}
    
}
#endif

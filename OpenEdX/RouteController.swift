//
//  RouteController.swift
//  OpenEdX
//
//  Created by Vladimir Chekyrta on 13.09.2022.
//

import UIKit
import SwiftUI
import Core
import Authorization

class RouteController: UIViewController {
    
    private lazy var navigation: UINavigationController = {
        diContainer.resolve(UINavigationController.self)!
    }()
    
    private lazy var appStorage: Core.AppStorage = {
        diContainer.resolve(AppStorage.self)!
    }()
    
    private lazy var analytics: AuthorizationAnalytics = {
        diContainer.resolve(AuthorizationAnalytics.self)!
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = appStorage.user, appStorage.accessToken != nil {
            analytics.setUserID("\(user.id)")
            DispatchQueue.main.async {
                self.showMainScreen()
            }
        } else {
            DispatchQueue.main.async {
                self.showAuthorization()
            }
        }
    }
    
    private func showAuthorization() {
        let controller = UIHostingController(
            rootView: SignInView(viewModel: diContainer.resolve(SignInViewModel.self)!)
        )
        navigation.viewControllers = [controller]
        present(navigation, animated: false)
    }
    
    private func showMainScreen() {
        let controller = UIHostingController(rootView: MainScreenView())
        navigation.viewControllers = [controller]
        present(navigation, animated: false)
    }
}

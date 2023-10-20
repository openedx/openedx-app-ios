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
import WhatsNew
import Swinject

class RouteController: UIViewController {
    
    private lazy var navigation: UINavigationController = {
        diContainer.resolve(UINavigationController.self)!
    }()
    
    private lazy var appStorage: CoreStorage = {
        diContainer.resolve(CoreStorage.self)!
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
        let viewModel = WhatsNewViewModel(router: Container.shared.resolve(WhatsNewRouter.self)!)
        let whatsNew = WhatsNewView(viewModel: viewModel)
        let storage = Container.shared.resolve(AppStorage.self)!
        let showWhatsNew = viewModel.shouldShowWhatsNew(savedVersion: storage.whatsNewVersion)
        
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            print("App version: \(appVersion)")
            // is appVersion logic are needed?
        }
        
        if showWhatsNew {
            if let jsonVersion = viewModel.getVersion() {
                storage.whatsNewVersion = jsonVersion
            }
            let controller = UIHostingController(rootView: whatsNew)
            navigation.viewControllers = [controller]
        } else {
            let controller = UIHostingController(rootView: MainScreenView())
            navigation.viewControllers = [controller]
        }
        present(navigation, animated: false)
    }
}

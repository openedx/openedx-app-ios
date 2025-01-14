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
    
    private lazy var coreAnalytics: CoreAnalytics = {
        diContainer.resolve(CoreAnalytics.self)!
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = appStorage.user, appStorage.accessToken != nil {
            analytics.identify(id: "\(user.id)", username: user.username ?? "", email: user.email ?? "")
            DispatchQueue.main.async {
                self.showMainOrWhatsNewScreen()
            }
        } else {
            DispatchQueue.main.async {
                self.showStartupScreen()
            }
        }
        
        resetAppSupportDirectoryUserData()
        coreAnalytics.trackEvent(.launch, biValue: .launch)
    }
    
    private func showStartupScreen() {
        if let config = Container.shared.resolve(ConfigProtocol.self), config.features.startupScreenEnabled {
            let controller = UIHostingController(
                rootView: StartupView(viewModel: diContainer.resolve(StartupViewModel.self)!))
            navigation.viewControllers = [controller]
            present(navigation, animated: false)
        } else {
            let controller = UIHostingController(
                rootView: SignInView(
                    viewModel: diContainer.resolve(
                        SignInViewModel.self,
                        argument: LogistrationSourceScreen.default
                    )!
                )
            )
            navigation.viewControllers = [controller]
            present(navigation, animated: false)
        }
    }
    
    private func showMainOrWhatsNewScreen() {
        guard var storage = Container.shared.resolve(WhatsNewStorage.self),
              let config = Container.shared.resolve(ConfigProtocol.self),
              let analytics = Container.shared.resolve(WhatsNewAnalytics.self)
        else {
            assert(false, "unable to resolve basic dependencies to start app")
            return
        }

        let viewModel = WhatsNewViewModel(storage: storage, analytics: analytics)
        let shouldShowWhatsNew = viewModel.shouldShowWhatsNew()

        if shouldShowWhatsNew && config.features.whatNewEnabled {
            if let jsonVersion = viewModel.getVersion() {
                storage.whatsNewVersion = jsonVersion
            }
            let whatsNewView = WhatsNewView(
                router: Container.shared.resolve(WhatsNewRouter.self)!,
                viewModel: viewModel
            )
            let controller = UIHostingController(rootView: whatsNewView)
            navigation.viewControllers = [controller]
        } else {
            let postLoginDataDefault: PostLoginData? = PostLoginData()
            let viewModel = Container.shared.resolve(
                MainScreenViewModel.self,
                arguments: LogistrationSourceScreen.default,
                postLoginDataDefault
            )!
            let controller = UIHostingController(rootView: MainScreenView(viewModel: viewModel))
            navigation.viewControllers = [controller]
        }
        present(navigation, animated: false)
    }

    /**
     This code will delete any old application’s downloaded user data, such as video files,
     from the Application Support directory to optimize storage. This activity will be performed
     only once during the upgrade from the old Open edX application to the new one or during
     fresh installation. We can consider removing this code once we are confident that most or
     all users have transitioned to the new application.
     */
    private func resetAppSupportDirectoryUserData() {
        guard var upgradationValue = Container.shared.resolve(CoreStorage.self),
              let downloadManager = Container.shared.resolve(DownloadManagerProtocol.self),
              upgradationValue.resetAppSupportDirectoryUserData == false
        else { return }
        
        Task {
            downloadManager.removeAppSupportDirectoryUnusedContent()
            upgradationValue.resetAppSupportDirectoryUserData = true
        }
    }
}

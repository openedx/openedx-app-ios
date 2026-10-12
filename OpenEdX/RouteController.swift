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

    private lazy var instanceStore: InstanceStore = {
        diContainer.resolve(InstanceStore.self)!
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
        // No valid session exists at this point (see the check above), so for a
        // multi-instance catalog that means the site picker, not Startup/SignIn. A
        // single-instance catalog never reaches here -- InstanceStore auto-selects it.
        if instanceStore.instancesConfig.instances.count > 1 {
            let controller = UIHostingController(
                rootView: LearningSitesView(
                    viewModel: diContainer.resolve(LearningSitesViewModel.self, argument: false)!
                )
            )
            navigation.viewControllers = [controller]
            present(navigation, animated: false)
            return
        }

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

final class AppNavigationController: UINavigationController {

#if canImport(SwiftUI, _version: 8.0.85.27)
    @available(iOS 27.1, *)
    override var preferredVerticalBarBehavior: UIVerticalBarBehavior {
        if topViewController is UIHostingController<MainScreenView> || traitCollection.verticalSizeClass == .compact {
            return .automatic
        }
        return .disabled
    }

    @available(iOS 27.1, *)
    override var childForPreferredVerticalBarBehavior: UIViewController? {
        nil
    }
#endif

    override func viewDidLoad() {
        super.viewDidLoad()
        registerForTraitChanges([UITraitVerticalSizeClass.self]) { (self: Self, _) in
            self.verticalBarConfigurationDidChange()
        }
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        verticalBarConfigurationDidChange()
    }

    override func popViewController(animated: Bool) -> UIViewController? {
        let popped = super.popViewController(animated: animated)
        verticalBarConfigurationDidChange()
        return popped
    }

    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        let popped = super.popToViewController(viewController, animated: animated)
        verticalBarConfigurationDidChange()
        return popped
    }

    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        let popped = super.popToRootViewController(animated: animated)
        verticalBarConfigurationDidChange()
        return popped
    }

    override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        super.setViewControllers(viewControllers, animated: animated)
        verticalBarConfigurationDidChange()
    }

    private func verticalBarConfigurationDidChange() {
#if canImport(SwiftUI, _version: 8.0.85.27)
        if #available(iOS 27.1, *) {
            setNeedsUpdateOfVerticalBarConfiguration()
        }
#endif
    }
}

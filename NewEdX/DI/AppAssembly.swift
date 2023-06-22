//
//  AppAssembly.swift
//  NewEdX
//
//  Created by Vladimir Chekyrta on 13.09.2022.
//

import UIKit
import Core
import Swinject
import KeychainSwift
import Discovery
import Dashboard
import Course
import Discussion
import Authorization
import Profile

// swiftlint:disable function_body_length
class AppAssembly: Assembly {
    
    private let navigation: UINavigationController
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
    }
    
    func assemble(container: Container) {
        container.register(UINavigationController.self) { _ in
            self.navigation
        }.inObjectScope(.container)
        
        container.register(Router.self) { r in
            Router(navigationController: r.resolve(UINavigationController.self)!, container: container)
        }
        
        container.register(ConnectivityProtocol.self) { _ in
            Connectivity()
        }
        
        container.register(CorePersistenceProtocol.self) { _ in
            CorePersistence()
        }.inObjectScope(.container)
        
        container.register(DownloadManagerProtocol.self, factory: { r in
            DownloadManager(persistence: r.resolve(CorePersistenceProtocol.self)!,
                            appStorage: r.resolve(AppStorage.self)!,
                            connectivity: r.resolve(ConnectivityProtocol.self)!)
        }).inObjectScope(.container)
        
        container.register(AuthorizationRouter.self) { r in
            r.resolve(Router.self)!
        }.inObjectScope(.container)
                
        container.register(DiscoveryRouter.self) { r in
            r.resolve(Router.self)!
        }.inObjectScope(.container)
        
        container.register(ProfileRouter.self) { r in
            r.resolve(Router.self)!
        }.inObjectScope(.container)
        
        container.register(DashboardRouter.self) { r in
            r.resolve(Router.self)!
        }.inObjectScope(.container)
        
        container.register(CourseRouter.self) { r in
            r.resolve(Router.self)!
        }.inObjectScope(.container)
        
        container.register(DiscussionRouter.self) { r in
            r.resolve(Router.self)!
        }.inObjectScope(.container)
        
        container.register(Config.self) { _ in
            Config(baseURL: BuildConfiguration.shared.baseURL, oAuthClientId: BuildConfiguration.shared.clientId)
        }.inObjectScope(.container)
        
        container.register(CSSInjector.self) { _ in
            CSSInjector(baseURL: BuildConfiguration.shared.baseURL)
        }.inObjectScope(.container)
        
        container.register(KeychainSwift.self) { _ in
            KeychainSwift()
        }.inObjectScope(.container)
        
        container.register(UserDefaults.self) { _ in
            UserDefaults.standard
        }.inObjectScope(.container)
        
        container.register(AppStorage.self) { r in
            AppStorage(
                keychain: r.resolve(KeychainSwift.self)!,
                userDefaults: r.resolve(UserDefaults.self)!
            )
        }.inObjectScope(.container)
        
        container.register(Validator.self) { _ in
            Validator()
        }.inObjectScope(.container)
    }
}

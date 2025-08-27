//
//  AppAssembly.swift
//  OpenEdX
//
//  Created by Vladimir Chekyrta on 13.09.2022.
//

import UIKit
import Core
import OEXFoundation
@preconcurrency import Swinject
import KeychainSwift
import Discovery
import Dashboard
import Course
import Discussion
import Authorization
import Downloads
import Profile
import WhatsNew

// swiftlint:disable function_body_length
class AppAssembly: Assembly {
    
    private let navigation: UINavigationController
    private let pluginManager: PluginManager
    
    init(navigation: UINavigationController, pluginManager: PluginManager) {
        self.navigation = navigation
        self.pluginManager = pluginManager
    }
    
    func assemble(container: Container) {
        container.register(UINavigationController.self) { _ in
            self.navigation
        }.inObjectScope(.container)
        
        container.register(PluginManager.self) { _ in
            self.pluginManager
        }.inObjectScope(.container)
        
        container.register(Router.self) { @MainActor r in
            Router(navigationController: r.resolve(UINavigationController.self)!, container: container)
        }
        
        container.register(AnalyticsManager.self) { r in
            AnalyticsManager(services: r.resolve(PluginManager.self)!.analyticsServices)
        }
        
        container.register(AuthorizationAnalytics.self) { r in
            r.resolve(AnalyticsManager.self)!
        }.inObjectScope(.container)
        
        container.register(MainScreenAnalytics.self) { r in
            r.resolve(AnalyticsManager.self)!
        }.inObjectScope(.container)
        
        container.register(DiscoveryAnalytics.self) { r in
            r.resolve(AnalyticsManager.self)!
        }.inObjectScope(.container)
        
        container.register(DashboardAnalytics.self) { r in
            r.resolve(AnalyticsManager.self)!
        }.inObjectScope(.container)
        
        container.register(ProfileAnalytics.self) { r in
            r.resolve(AnalyticsManager.self)!
        }.inObjectScope(.container)
        
        container.register(CourseAnalytics.self) { r in
            r.resolve(AnalyticsManager.self)!
        }.inObjectScope(.container)
        
        container.register(DiscussionAnalytics.self) { r in
            r.resolve(AnalyticsManager.self)!
        }.inObjectScope(.container)
        
        container.register(CoreAnalytics.self) { r in
            r.resolve(AnalyticsManager.self)!
        }.inObjectScope(.container)
        
        container.register(WhatsNewAnalytics.self) { r in
            r.resolve(AnalyticsManager.self)!
        }.inObjectScope(.container)
        
        container.register(DownloadsAnalytics.self) { r in
            r.resolve(AnalyticsManager.self)!
        }.inObjectScope(.container)
        
        container.register(ConnectivityProtocol.self) { @MainActor _ in
            Connectivity()
        }
        
        container.register(DatabaseManager.self) { _ in
            DatabaseManager(databaseName: "Database")
        }.inObjectScope(.container)
        
        container.register(CoreDataHandlerProtocol.self) { r in
            r.resolve(DatabaseManager.self)!
        }.inObjectScope(.container)
        
        container.register(CorePersistenceProtocol.self) { r in
            CorePersistence(container: r.resolve(DatabaseManager.self)!.getPersistentContainer())
        }.inObjectScope(.container)
        
        container.register(DownloadManagerProtocol.self) { @MainActor r in
            DownloadManager(
                persistence: r.resolve(CorePersistenceProtocol.self)!,
                appStorage: r.resolve(CoreStorage.self)!,
                connectivity: r.resolve(ConnectivityProtocol.self)!
            )
        }.inObjectScope(.container)
        
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
        
        container.register(WhatsNewRouter.self) { r in
            r.resolve(Router.self)!
        }.inObjectScope(.container)
        
        container.register(DownloadsRouter.self) { r in
            r.resolve(Router.self)!
        }.inObjectScope(.container)
        
        container.register(ConfigProtocol.self) { _ in
            Config()
        }.inObjectScope(.container)
        
        container.register(CSSInjector.self) { r in
            CSSInjector(config: r.resolve(ConfigProtocol.self)!,
                        tenantProvider: r.resolve(TenantProvider.self)!
                        )
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
        
        container.register(CoreStorage.self) { r in
            r.resolve(AppStorage.self)!
        }.inObjectScope(.container)
        
        container.register(WhatsNewStorage.self) { r in
            r.resolve(AppStorage.self)!
        }.inObjectScope(.container)

        container.register(CourseStorage.self) { r in
            r.resolve(AppStorage.self)!
        }.inObjectScope(.container)
        
        container.register(DownloadsStorage.self) { r in
            r.resolve(AppStorage.self)!
        }.inObjectScope(.container)

        container.register(ProfileStorage.self) { r in
            r.resolve(AppStorage.self)!
        }.inObjectScope(.container)
        
        container.register(SSOHelper.self) { r in
            SSOHelper(
                keychain: r.resolve(KeychainSwift.self)!
            )
        }
        
        container.register(Validator.self) { _ in
            Validator()
        }.inObjectScope(.container)
        
        container.register(PushNotificationsManager.self) { @MainActor r in
            PushNotificationsManager(
                providers: r.resolve(PluginManager.self)!.pushNotificationsProviders,
                listeners: r.resolve(PluginManager.self)!.pushNotificationsListeners
            )
        }.inObjectScope(.container)
        
        container.register(CalendarManagerProtocol.self) { @MainActor r in
            CalendarManager(
                persistence: r.resolve(ProfilePersistenceProtocol.self)!,
                interactor: r.resolve(ProfileInteractorProtocol.self)!,
                profileStorage: r.resolve(ProfileStorage.self)!
            )
        }
        .inObjectScope(.container)

        container.register(DeepLinkManager.self) { @MainActor r in
            DeepLinkManager(
                config: r.resolve(ConfigProtocol.self)!,
                router: r.resolve(Router.self)!,
                storage: r.resolve(CoreStorage.self)!,
                discoveryInteractor: r.resolve(DiscoveryInteractorProtocol.self)!,
                discussionInteractor: r.resolve(DiscussionInteractorProtocol.self)!,
                courseInteractor: r.resolve(CourseInteractorProtocol.self)!,
                profileInteractor: r.resolve(ProfileInteractorProtocol.self)!
            )
        }.inObjectScope(.container)
        
        container.register(PipManagerProtocol.self) { @MainActor r in
            let config = r.resolve(ConfigProtocol.self)!
            return PipManager(
                router: r.resolve(Router.self)!,
                discoveryInteractor: r.resolve(DiscoveryInteractorProtocol.self)!,
                courseInteractor: r.resolve(CourseInteractorProtocol.self)!,
                courseDropDownNavigationEnabled: config.uiComponents.courseDropDownNavigationEnabled
            )
        }.inObjectScope(.container)
    }
}
// swiftlint:enable function_body_length

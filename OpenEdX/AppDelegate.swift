//
//  AppDelegate.swift
//  OpenEdX
//
//  Created by Vladimir Chekyrta on 13.09.2022.
//

import UIKit
import Core
import Swinject
import Profile
import GoogleSignIn
import FacebookCore
import MSAL
import UserNotifications
import FirebaseCore
import FirebaseMessaging
import Theme

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static var shared: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }

    var window: UIWindow?
        
    private var assembler: Assembler?
    
    private var lastForceLogoutTime: TimeInterval = 0
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        initDI()
        
        if let config = Container.shared.resolve(ConfigProtocol.self) {
            Theme.Shapes.isRoundedCorners = config.theme.isRoundedCorners
            
            if config.facebook.enabled {
                ApplicationDelegate.shared.application(
                    application,
                    didFinishLaunchingWithOptions: launchOptions
                )
            }
            configureDeepLinkServices(launchOptions: launchOptions)
            
            let pushManager = Container.shared.resolve(PushNotificationsManager.self)
            
            if config.firebase.enabled {
                FirebaseApp.configure()
                if config.firebase.cloudMessagingEnabled {
                    Messaging.messaging().delegate = pushManager
                    UNUserNotificationCenter.current().delegate = pushManager
                }
            }
            
            if pushManager?.hasProviders == true {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }

        Theme.Fonts.registerFonts()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = RouteController()
        window?.makeKeyAndVisible()
        window?.tintColor = Theme.UIColors.accentColor
          
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didUserAuthorize),
            name: .userAuthorized,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didUserLogout),
            name: .userLoggedOut,
            object: nil
        )

        return true
    }

    func application(
        _ app: UIApplication,
        open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        guard let config = Container.shared.resolve(ConfigProtocol.self) else { return false }

        if let deepLinkManager = Container.shared.resolve(DeepLinkManager.self),
            deepLinkManager.anyServiceEnabled {
            if deepLinkManager.handledURLWith(app: app, open: url, options: options) {
                return true
            }
        }

        if config.facebook.enabled {
            if ApplicationDelegate.shared.application(
                app,
                open: url,
                sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                annotation: options[UIApplication.OpenURLOptionsKey.annotation]
            ) {
                return true
            }
        }

        if config.google.enabled {
            if GIDSignIn.sharedInstance.handle(url) {
                return true
            }
        }

        if config.microsoft.enabled {
            if MSALPublicClientApplication.handleMSALResponse(
                url,
                sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String
            ) {
                return true
            }
        }

        return false
    }

    private func initDI() {
        let navigation = UINavigationController()
        navigation.modalPresentationStyle = .fullScreen
        
        assembler = Assembler(
            [
                AppAssembly(navigation: navigation),
                NetworkAssembly(),
                ScreenAssembly()
            ],
            container: Container.shared
        )
    }
    
    @objc private func didUserAuthorize() {
        Container.shared.resolve(PushNotificationsManager.self)?.synchronizeToken()
    }
    
    @objc func didUserLogout(_ notification: Notification) {
        guard Date().timeIntervalSince1970 - lastForceLogoutTime > 5 else {
            return
        }
        if let userInfo = notification.userInfo,
           userInfo[Notification.UserInfoKey.isForced] as? Bool == true {
            let analyticsManager = Container.shared.resolve(AnalyticsManager.self)
            analyticsManager?.userLogout(force: true)
            
            lastForceLogoutTime = Date().timeIntervalSince1970
            
            Container.shared.resolve(CoreStorage.self)?.clear()
            Task {
                await Container.shared.resolve(DownloadManagerProtocol.self)?.deleteAllFiles()
            }
            Container.shared.resolve(CoreDataHandlerProtocol.self)?.clear()
            window?.rootViewController = RouteController()
        }
        
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        Container.shared.resolve(PushNotificationsManager.self)?.refreshToken()
    }
    
    // Push Notifications
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        guard let pushManager = Container.shared.resolve(PushNotificationsManager.self) else { return }
        pushManager.didRegisterForRemoteNotificationsWithDeviceToken(deviceToken: deviceToken)
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        guard let pushManager = Container.shared.resolve(PushNotificationsManager.self) else { return }
        pushManager.didFailToRegisterForRemoteNotificationsWithError(error: error)
    }
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        guard let pushManager = Container.shared.resolve(PushNotificationsManager.self) else {
            completionHandler(.newData)
            return
        }
        pushManager.didReceiveRemoteNotification(userInfo: userInfo)
        completionHandler(.newData)
    }
    
    // Deep link
    func configureDeepLinkServices(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        guard let deepLinkManager = Container.shared.resolve(DeepLinkManager.self) else { return }
        deepLinkManager.configureDeepLinkService(launchOptions: launchOptions)
    }
}

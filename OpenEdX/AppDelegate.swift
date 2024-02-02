//
//  AppDelegate.swift
//  OpenEdX
//
//  Created by Vladimir Chekyrta on 13.09.2022.
//

import UIKit
import Core
import Swinject
import FirebaseCore
//import FirebaseAnalytics
import FirebaseCrashlytics
import Profile
import GoogleSignIn
import FacebookCore
import MSAL
import Theme
//import BrazeKit
import Segment
import SegmentFirebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static var shared: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
//    var braze: Braze?
    var analytics: Analytics?

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
            if let configuration = config.firebase.firebaseOptions {
                FirebaseApp.configure(options: configuration)
                Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
            }
            if config.facebook.enabled {
                ApplicationDelegate.shared.application(
                    application,
                    didFinishLaunchingWithOptions: launchOptions
                )
            }
            configureDeepLinkServices(launchOptions: launchOptions)
            if config.segment.enabled {
                let configuration = Configuration(writeKey: config.segment.writeKey)
                                .trackApplicationLifecycleEvents(true)
                                .flushInterval(10)
                analytics = Analytics(configuration: configuration)
                if config.firebase.isAnalyticsSourceSegment {
                    analytics?.add(plugin: FirebaseDestination())
                }
            }
        }

        Theme.Fonts.registerFonts()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = RouteController()
        window?.makeKeyAndVisible()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(forceLogoutUser),
            name: .onTokenRefreshFailed,
            object: nil
        )
        
        if let pushManager = Container.shared.resolve(PushNotificationsManager.self) {
            pushManager.performRegistration()
        }

        return true
    }

    func application(
        _ app: UIApplication,
        open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        if let config = Container.shared.resolve(ConfigProtocol.self) {
            if let deepLinkManager = Container.shared.resolve(DeepLinkManager.self),
                deepLinkManager.serviceEnabled {
                if deepLinkManager.handledURLWith(app: app, open: url, options: options) {
                    return true
                }
            }

            if config.facebook.enabled {
                ApplicationDelegate.shared.application(
                    app,
                    open: url,
                    sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                    annotation: options[UIApplication.OpenURLOptionsKey.annotation]
                )
            }

            if config.google.enabled {
                return GIDSignIn.sharedInstance.handle(url)
            }

            if config.microsoft.enabled {
                return MSALPublicClientApplication.handleMSALResponse(
                    url,
                    sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String
                )
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
    
    @objc private func forceLogoutUser() {
        guard Date().timeIntervalSince1970 - lastForceLogoutTime > 5 else {
            return
        }
        let analytics = Container.shared.resolve(AnalyticsManager.self)
        analytics?.userLogout(force: true)
        
        lastForceLogoutTime = Date().timeIntervalSince1970
        
        Container.shared.resolve(CoreStorage.self)?.clear()
        Container.shared.resolve(DownloadManagerProtocol.self)?.deleteAllFiles()
        Container.shared.resolve(CoreDataHandlerProtocol.self)?.clear()
        window?.rootViewController = RouteController()
    }
    
    // Push Notifications
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        if let pushManager = Container.shared.resolve(PushNotificationsManager.self) {
            pushManager.didRegisterForRemoteNotificationsWithDeviceToken(deviceToken: deviceToken)
        }
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        if let pushManager = Container.shared.resolve(PushNotificationsManager.self) {
            pushManager.didFailToRegisterForRemoteNotificationsWithError(error: error)
        }
    }
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        if let pushManager = Container.shared.resolve(PushNotificationsManager.self) {
            pushManager.didReceiveRemoteNotification(userInfo: userInfo)
        }
        completionHandler(.newData)
    }
    
    // Deep link
    func configureDeepLinkServices(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        if let deepLinkManager = Container.shared.resolve(DeepLinkManager.self) {
            deepLinkManager.configureDeepLinkService(launchOptions: launchOptions)
        }
    }
}

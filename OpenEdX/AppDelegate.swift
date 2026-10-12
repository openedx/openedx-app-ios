//
//  AppDelegate.swift
//  OpenEdX
//
//  Created by Vladimir Chekyrta on 13.09.2022.
//

import UIKit
import Core
import OEXFoundation
import Swinject
import Profile
import GoogleSignIn
import FacebookCore
import MSAL
import UserNotifications
import OEXFirebaseAnalytics
import FirebaseCore
import FirebaseMessaging
import Theme
import BackgroundTasks

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static let bgAppTaskId = "openEdx.offlineProgressSync"
    
    static var shared: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }

    private var window: UIWindow? {
        UIApplication.shared.connectedScenes
            .compactMap { ($0.delegate as? SceneDelegate)?.window }
            .first
    }

    private let pluginManager = PluginManager()
    private var assembler: Assembler?
    
    private var lastForceLogoutTime: TimeInterval = 0
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        initDI()
        initPlugins()
        // Reset the value to false to get the actual status from the API
        if var storage = Container.shared.resolve(CoreStorage.self) {
            storage.updateAppRequired = false
        }
        
        if let config = Container.shared.resolve(ConfigProtocol.self) {
            Theme.Shapes.isRoundedCorners = config.theme.isRoundedCorners
            Theme.Shapes.buttonCornersRadius = config.theme.buttonCornersRadius
            
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
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @discardableResult
    func handleOpenURL(_ context: UIOpenURLContext) -> Bool {
        var options: [UIApplication.OpenURLOptionsKey: Any] = [:]
        options[.sourceApplication] = context.options.sourceApplication
        options[.annotation] = context.options.annotation
        options[.openInPlace] = context.options.openInPlace
        return handleOpenURL(context.url, options: options)
    }

    private func handleOpenURL(
        _ url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any]
    ) -> Bool {
        let app = UIApplication.shared
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
    
    private func initPlugins() {
        guard let config = Container.shared.resolve(ConfigProtocol.self) else { return }
        if config.firebase.enabled && config.firebase.isAnalyticsSourceFirebase {
            pluginManager.addPlugin(analyticsService: FirebaseAnalyticsService())
        }
        
        // - FCM
        if config.firebase.cloudMessagingEnabled,
            let storage = Container.shared.resolve(CoreStorage.self),
            let api = Container.shared.resolve(API.self),
            let deepLinkManager = Container.shared.resolve(DeepLinkManager.self) {
            pluginManager.addPlugin(
                pushNotificationsProvider: FCMProvider(storage: storage, api: api),
                pushNotificationsListener: FCMListener(deepLinkManager: deepLinkManager)
            )
        }
        // Initialize your plugins here
    }

    /// Fetches the remote instance catalog and hands it to `InstanceStore`. Falls back to
    /// the bundled/cached catalog near-instantly if no URL is configured or the fetch fails.
    func loadInstanceCatalog() async {
        guard let loader = Container.shared.resolve(InstanceConfigLoader.self),
              let instanceStore = Container.shared.resolve(InstanceStore.self) else {
            return
        }
        let config = await loader.load()
        instanceStore.updateInstancesConfig(config)

        // A persisted selection is restored inside updateInstancesConfig() above without
        // going through switchActiveInstance(to:), so nothing else applies its theme colors.
        Container.shared.resolve(InstanceSessionManagerProtocol.self)?.applyThemeForCurrentInstance()

        reconcileStaleKeychainSessions(against: instanceStore)
    }

    /// Keychain survives an app delete + reinstall; UserDefaults doesn't. Left alone, a
    /// reinstall shows every previously-logged-in instance as still signed in (Keychain has
    /// a token) with no matching UserDefaults `user` record -- tapping one opens Home with a
    /// dead token. A real login/logout always sets/clears both together, so that mismatch
    /// only means a reinstall; reconcile it for every instance on every launch.
    ///
    /// Must run after `updateInstancesConfig(_:)` above, once the real catalog (not the
    /// bundled placeholder) is loaded.
    private func reconcileStaleKeychainSessions(against instanceStore: InstanceStore) {
        guard let appStorage = Container.shared.resolve(AppStorage.self) else { return }
        for instance in instanceStore.instancesConfig.instances
        where appStorage.hasSession(forInstanceKey: instance.key)
            && !appStorage.hasUserRecord(forInstanceKey: instance.key) {
            appStorage.clearSession(forInstanceKey: instance.key)
        }

        // UserDefaults writes aren't guaranteed to hit disk before an abrupt process kill
        // (e.g. Xcode's Stop button), so a logout right before that can leave the selected-
        // instance pointer stuck on an instance with no session. Deselect it here too.
        if let current = instanceStore.currentInstance, !appStorage.hasSession(forInstanceKey: current.key) {
            instanceStore.select(nil)
        }
    }

    private func initDI() {
        let navigation = AppNavigationController()
        navigation.modalPresentationStyle = .fullScreen
        
        assembler = Assembler(
            [
                AppAssembly(navigation: navigation, pluginManager: pluginManager),
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

            // Routes through InstanceSessionManager instead of duplicating cleanup here.
            Task {
                await Container.shared.resolve(InstanceSessionManagerProtocol.self)?.logoutCurrentInstance()
                window?.rootViewController = RouteController()
            }
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
    
    // Background progress update
    
    func registerBackgroundTask() {
        let isRegistered = BGTaskScheduler.shared.register(
            forTaskWithIdentifier: Self.bgAppTaskId,
            using: nil
        ) { task in
            debugLog("Background task is executing: \(task.identifier)")
            guard let task = task as? BGAppRefreshTask else { return }
            self.handleAppRefreshTask(task: task)
        }
        debugLog("Is the background task registered? \(isRegistered)")
    }
    
    func handleAppRefreshTask(task: BGAppRefreshTask) {
        //In real case scenario we should check internet here
        reScheduleAppRefresh()
        
        task.expirationHandler = {
            //This Block call by System
            //Canel your all tak's & queues
            task.setTaskCompleted(success: true)
        }
        
        let offlineSyncManager = Container.shared.resolve(OfflineSyncManagerProtocol.self)!
        Task {
            await offlineSyncManager.syncOfflineProgress()
            task.setTaskCompleted(success: true)
        }
    }
    
    func reScheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: Self.bgAppTaskId)
        request.earliestBeginDate = Date(timeIntervalSinceNow: 60 * 60) // App Refresh after 60 minute.
        //Note :: EarliestBeginDate should not be set to too far into the future.
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            debugLog("Could not schedule app refresh: \(error)")
        }
    }
}

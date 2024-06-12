//
//  PushNotificationManager.swift
//  OpenEdX
//
//  Created by Anton Yarmolenka on 24/01/2024.
//

import Foundation
import Core
import UIKit
import Swinject
import UserNotifications
import FirebaseCore
import FirebaseMessaging

public protocol PushNotificationsProvider {
    func didRegisterWithDeviceToken(deviceToken: Data)
    func didFailToRegisterForRemoteNotificationsWithError(error: Error)
    func synchronizeToken()
    func refreshToken()
}

protocol PushNotificationsListener {
    func shouldListenNotification(userinfo: [AnyHashable: Any]) -> Bool
    func didReceiveRemoteNotification(userInfo: [AnyHashable: Any])
}

extension PushNotificationsListener {
    func didReceiveRemoteNotification(userInfo: [AnyHashable: Any]) {
        guard let dictionary = userInfo as? [String: AnyHashable],
             shouldListenNotification(userinfo: userInfo),
             let deepLinkManager = Container.shared.resolve(DeepLinkManager.self)
        else { return }
        let link = PushLink(dictionary: dictionary)
        deepLinkManager.processLinkFromNotification(link)
   }
}

class PushNotificationsManager: NSObject {
    private var providers: [PushNotificationsProvider] = []
    private var listeners: [PushNotificationsListener] = []
    
    public var hasProviders: Bool {
        providers.count > 0
    }
    
    // Init manager
    public init(config: ConfigProtocol) {
        super.init()
        providers = providersFor(config: config)
        listeners = listenersFor(config: config)
    }
    
    private func providersFor(config: ConfigProtocol) -> [PushNotificationsProvider] {
        var pushProviders: [PushNotificationsProvider] = []
        if config.braze.pushNotificationsEnabled {
            pushProviders.append(BrazeProvider())
        }
        if config.firebase.cloudMessagingEnabled {
            pushProviders.append(FCMProvider())
        }
        return pushProviders
    }
    
    private func listenersFor(config: ConfigProtocol) -> [PushNotificationsListener] {
        var pushListeners: [PushNotificationsListener] = []
        if config.braze.pushNotificationsEnabled {
            pushListeners.append(BrazeListener())
        }
        if config.firebase.cloudMessagingEnabled {
            pushListeners.append(FCMListener())
        }
        return pushListeners
    }
    
    // Register for push notifications
    public func performRegistration() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                debugLog("Permission for push notifications granted.")
            } else if let error = error {
                debugLog("Push notifications permission error: \(error.localizedDescription)")
            } else {
                debugLog("Permission for push notifications denied.")
            }
        }
    }
    
    // Proccess functions from app delegate
    public func didRegisterForRemoteNotificationsWithDeviceToken(deviceToken: Data) {
        for provider in providers {
            provider.didRegisterWithDeviceToken(deviceToken: deviceToken)
        }
    }
    public func didFailToRegisterForRemoteNotificationsWithError(error: Error) {
        for provider in providers {
            provider.didFailToRegisterForRemoteNotificationsWithError(error: error)
        }
    }
    public func didReceiveRemoteNotification(userInfo: [AnyHashable: Any]) {
        for listener in listeners {
            listener.didReceiveRemoteNotification(userInfo: userInfo)
        }
    }
    
    func synchronizeToken() {
        for provider in providers {
            provider.synchronizeToken()
        }
    }
    
    func refreshToken() {
        for provider in providers {
            provider.refreshToken()
        }
    }
}

// MARK: - MessagingDelegate
extension PushNotificationsManager: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        for provider in providers where provider is MessagingDelegate {
            (provider as? MessagingDelegate)?.messaging?(messaging, didReceiveRegistrationToken: fcmToken)
        }
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension PushNotificationsManager: UNUserNotificationCenterDelegate {
    @MainActor
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        Messaging.messaging().appDidReceiveMessage(notification.request.content.userInfo)
        
        // Show alert if application is active
        if let pushManager = Container.shared.resolve(PushNotificationsManager.self),
           UIApplication.shared.applicationState == .active {
            pushManager.didReceiveRemoteNotification(userInfo: notification.request.content.userInfo)
        }
        
        return [[.list, .banner, .sound]]
    }
    
    @MainActor
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {
        let userInfo = response.notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        didReceiveRemoteNotification(userInfo: userInfo)
    }
}

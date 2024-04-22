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

public protocol PushNotificationsProvider {
    func didRegisterWithDeviceToken(deviceToken: Data)
    func didFailToRegisterForRemoteNotificationsWithError(error: Error)
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

class PushNotificationsManager {
    private var providers: [PushNotificationsProvider] = []
    private var listeners: [PushNotificationsListener] = []
    
    // Init manager
    public init(config: ConfigProtocol) {
        providers = providersFor(config: config)
        listeners = listenersFor(config: config)
    }
    
    private func providersFor(config: ConfigProtocol) -> [PushNotificationsProvider] {
        var pushProviders: [PushNotificationsProvider] = []
        if config.firebase.cloudMessagingEnabled {
            pushProviders.append(FCMProvider())
        }
        if config.braze.pushNotificationsEnabled {
            pushProviders.append(BrazeProvider())
        }
        return pushProviders
    }
    
    private func listenersFor(config: ConfigProtocol) -> [PushNotificationsListener] {
        var pushListeners: [PushNotificationsListener] = []
        if config.firebase.cloudMessagingEnabled {
            pushListeners.append(FCMListener())
        }
        if config.braze.pushNotificationsEnabled {
            pushListeners.append(BrazeListener())
        }
        return pushListeners
    }
    
    // Register for push notifications
    public func performRegistration() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
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
}

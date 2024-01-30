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
    func registerWithDeviceToken(deviceToken: Data)
    func didFailToRegisterForRemoteNotificationsWithError(error: Error)
}

protocol PushNotificationsListener {
    func shouldListenNotification(userinfo: [AnyHashable: Any]) -> Bool
    func didReceiveRemoteNotification(userInfo: [AnyHashable: Any])
}

extension PushNotificationsListener {
    func didReceiveRemoteNotification(userInfo: [AnyHashable: Any]) {
       guard let dictionary = userInfo as? [String: Any], shouldListenNotification(userinfo: userInfo) else { return }
       let link = PushLink(dictionary: dictionary)
       if let deepLinkManager = Container.shared.resolve(DeepLinkManager.self) {
           deepLinkManager.processNotification(with: link)
       }
   }
}

class PushNotificationsManager {
    private var providers: [PushNotificationsProvider] = []
    private var listeners: [PushNotificationsListener] = []
    
    // Init manager
    public init(config: ConfigProtocol) {
        self.providers = self.providersFor(config: config)
        self.listeners = self.listenersFor(config: config)
    }
    
    private func providersFor(config: ConfigProtocol) -> [PushNotificationsProvider] {
        var rProviders: [PushNotificationsProvider] = []
        if config.firebase.cloudMessagingEnabled {
            rProviders.append(FCMProvider())
        }
        if config.braze.pushNotificationsEnabled {
            rProviders.append(BrazeProvider())
        }
        return rProviders
    }
    
    private func listenersFor(config: ConfigProtocol) -> [PushNotificationsListener] {
        var rListeners: [PushNotificationsListener] = []
        if config.firebase.cloudMessagingEnabled {
            rListeners.append(FCMListener())
        }
        if config.braze.pushNotificationsEnabled {
            rListeners.append(BrazeListener())
        }
        return rListeners
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
            provider.registerWithDeviceToken(deviceToken: deviceToken)
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

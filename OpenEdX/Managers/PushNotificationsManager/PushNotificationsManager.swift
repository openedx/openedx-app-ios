//
//  PushNotificationManager.swift
//  OpenEdX
//
//  Created by Anton Yarmolenka on 24/01/2024.
//

import Foundation
import Core

public protocol PushNotificationsProvider {
    func didRegisterForRemoteNotificationsWithDeviceToken(deviceToken: Data)
    func didFailToRegisterForRemoteNotificationsWithError(error: Error)
}

protocol PushNotificationsListener {
    func didReceiveRemoteNotification(userInfo: [AnyHashable: Any])
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
    
    // Proccess functions from app delegate
    public func didRegisterForRemoteNotificationsWithDeviceToken(deviceToken: Data) {
        for provider in providers {
            provider.didRegisterForRemoteNotificationsWithDeviceToken(deviceToken: deviceToken)
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

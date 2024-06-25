//
//  PushNotificationManager.swift
//  OpenEdX
//
//  Created by Anton Yarmolenka on 24/01/2024.
//

import Foundation
import Core
import UIKit
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

class PushNotificationsManager: NSObject {
    
    private let deepLinkManager: DeepLinkManager
    private let storage: CoreStorage
    private let api: API
    private let segemntService: SegmentAnalyticsService?
    
    private var providers: [PushNotificationsProvider] = []
    private var listeners: [PushNotificationsListener] = []
    
    
    public var hasProviders: Bool {
        providers.count > 0
    }
    
    // Init manager
    public init(deepLinkManager: DeepLinkManager,
                storage: CoreStorage,
                api: API,
                config: ConfigProtocol,
                segmentService: SegmentAnalyticsService?
    ) {
        self.deepLinkManager = deepLinkManager
        self.storage = storage
        self.api = api
        self.segemntService = segmentService
        
        super.init()
        providers = providersFor(config: config)
        listeners = listenersFor(config: config)
    }
    
    private func providersFor(config: ConfigProtocol) -> [PushNotificationsProvider] {
        var pushProviders: [PushNotificationsProvider] = []
        if config.braze.pushNotificationsEnabled {
            pushProviders.append(BrazeProvider(segmentService: segemntService))
        }
        if config.firebase.cloudMessagingEnabled {
            pushProviders.append(FCMProvider(storage: storage, api: api))
        }
        return pushProviders
    }
    
    private func listenersFor(config: ConfigProtocol) -> [PushNotificationsListener] {
        var pushListeners: [PushNotificationsListener] = []
        if config.braze.pushNotificationsEnabled {
            pushListeners.append(BrazeListener(deepLinkManager: deepLinkManager, segmentService: segemntService))
        }
        if config.firebase.cloudMessagingEnabled {
            pushListeners.append(FCMListener(deepLinkManager: deepLinkManager))
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
        if UIApplication.shared.applicationState == .active {
            didReceiveRemoteNotification(userInfo: notification.request.content.userInfo)
            return []
        }
        
        return [[.list, .banner, .sound]]
    }
    
    @MainActor
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {
        let userInfo = response.notification.request.content.userInfo
        didReceiveRemoteNotification(userInfo: userInfo)
    }
}

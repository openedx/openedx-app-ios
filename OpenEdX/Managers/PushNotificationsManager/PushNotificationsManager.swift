//
//  PushNotificationManager.swift
//  OpenEdX
//
//  Created by Anton Yarmolenka on 24/01/2024.
//

import Foundation
import Core
import OEXFoundation
import UIKit
import UserNotifications
import FirebaseCore
import FirebaseMessaging

@MainActor
class PushNotificationsManager: NSObject {
    
    private var providers: [PushNotificationsProvider] = []
    private var listeners: [PushNotificationsListener] = []
    
    public var hasProviders: Bool {
        providers.count > 0
    }
    
    // Init manager
    public init(
        providers: [PushNotificationsProvider],
        listeners: [PushNotificationsListener]
    ) {
        self.providers = providers
        self.listeners = listeners
        
        super.init()
    }
    
    // Register for push notifications
    public func performRegistration() async {
        do {
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(
                options: [.alert, .sound, .badge]
            )
            if granted {
                debugLog("Permission for push notifications granted.")
            } else {
                debugLog("Permission for push notifications denied.")
            }
        } catch {
            debugLog("Push notifications permission error: \(error.localizedDescription)")
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
extension PushNotificationsManager: @preconcurrency MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        for provider in providers where provider is MessagingDelegate {
            (provider as? MessagingDelegate)?.messaging?(messaging, didReceiveRegistrationToken: fcmToken)
        }
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension PushNotificationsManager: @preconcurrency UNUserNotificationCenterDelegate {
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
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {
        let userInfo = response.notification.request.content.userInfo
        didReceiveRemoteNotification(userInfo: userInfo)
    }
}

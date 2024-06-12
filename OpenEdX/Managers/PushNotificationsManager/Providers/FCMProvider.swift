//
//  FCMProvider.swift
//  OpenEdX
//
//  Created by Anton Yarmolenka on 24/01/2024.
//

import Foundation
import Core
import FirebaseCore
import FirebaseMessaging
import Swinject

class FCMProvider: NSObject, PushNotificationsProvider, MessagingDelegate {
    
    private var storage = Container.shared.resolve(CoreStorage.self)!
    private let api = Container.shared.resolve(API.self)!
    
    func didRegisterWithDeviceToken(deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }

    func didFailToRegisterForRemoteNotificationsWithError(error: Error) {
    }
    
    func synchronizeToken() {
        guard let fcmToken = storage.pushToken, storage.user != nil else { return }
        sendFCMToken(fcmToken)
    }
    
    func refreshToken() {
        Messaging.messaging().deleteToken { error in
            if let error = error {
                debugLog("Error deleting FCM token: \(error.localizedDescription)")
            } else {
                Messaging.messaging().token { token, error in
                    if let error = error {
                        debugLog("Error fetching FCM token: \(error.localizedDescription)")
                    } else if let token = token {
                        debugLog("FCM token fetched: \(token)")
                    }
                }
            }
        }
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        storage.pushToken = fcmToken
        
        guard let fcmToken, storage.user != nil else { return }
        sendFCMToken(fcmToken)
    }
    
    private func sendFCMToken(_ token: String) {
        Task {
            try? await api.request(NotificationsEndpoints.syncFirebaseToken(token: token))
        }
    }
}

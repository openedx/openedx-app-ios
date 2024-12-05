//
//  FCMProvider.swift
//  OpenEdX
//
//  Created by Anton Yarmolenka on 24/01/2024.
//

import Foundation
import Core
import OEXFoundation
import FirebaseCore
import FirebaseMessaging

final class FCMProvider: NSObject, PushNotificationsProvider, MessagingDelegate {
    
    private let storage: CoreStorage
    private let api: API
    
    init(storage: CoreStorage, api: API) {
        self.storage = storage
        self.api = api
    }
    
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
        var localStorage = storage
        localStorage.pushToken = fcmToken
        
        guard let fcmToken, storage.user != nil else { return }
        sendFCMToken(fcmToken)
    }
    
    private func sendFCMToken(_ token: String) {
        Task {
            try? await api.request(NotificationsEndpoints.syncFirebaseToken(token: token))
        }
    }
}

//
//  FCMListener.swift
//  OpenEdX
//
//  Created by Anton Yarmolenka on 24/01/2024.
//

import Foundation
import FirebaseMessaging
import OEXFoundation

class FCMListener: PushNotificationsListener {
    
    private let deepLinkManager: DeepLinkManagerProtocol
    
    init(deepLinkManager: DeepLinkManagerProtocol) {
        self.deepLinkManager = deepLinkManager
    }
    
    // check if userinfo contains data for this Listener
    func shouldListenNotification(userinfo: [AnyHashable: Any]) -> Bool {
        let data = userinfo["gcm.message_id"]
        return userinfo.count > 0 && data != nil
    }
    
    func didReceiveRemoteNotification(userInfo: [AnyHashable: Any]) {
        guard shouldListenNotification(userinfo: userInfo) else { return }
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        deepLinkManager.processLinkFrom(userInfo: userInfo)
    }
}

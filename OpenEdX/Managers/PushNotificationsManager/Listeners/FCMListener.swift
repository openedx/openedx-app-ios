//
//  FCMListener.swift
//  OpenEdX
//
//  Created by Anton Yarmolenka on 24/01/2024.
//

import Foundation
import Swinject
import FirebaseMessaging

class FCMListener: PushNotificationsListener {
    
    private let deepLinkManager: DeepLinkManager
    
    init(deepLinkManager: DeepLinkManager) {
        self.deepLinkManager = deepLinkManager
    }
    
    // check if userinfo contains data for this Listener
    func shouldListenNotification(userinfo: [AnyHashable: Any]) -> Bool {
        let data = userinfo["gcm.message_id"]
        return userinfo.count > 0 && data != nil
    }
    
    func didReceiveRemoteNotification(userInfo: [AnyHashable: Any]) {
        guard let dictionary = userInfo as? [String: AnyHashable],
              shouldListenNotification(userinfo: userInfo) else { return }
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        let link = PushLink(dictionary: dictionary)
        deepLinkManager.processLinkFromNotification(link)
    }
}

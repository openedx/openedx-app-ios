//
//  BrazeListener.swift
//  OpenEdX
//
//  Created by Anton Yarmolenka on 24/01/2024.
//

import Foundation
import Swinject

class BrazeListener: PushNotificationsListener {
    
    private let deepLinkManager: DeepLinkManager
    
    init(deepLinkManager: DeepLinkManager) {
        self.deepLinkManager = deepLinkManager
    }
    
    func shouldListenNotification(userinfo: [AnyHashable: Any]) -> Bool {
        //A push notification sent from the braze has a key ab in it like ab = {c = "c_value";};
        let data = userinfo["ab"] as? [String: Any]
        return userinfo.count > 0 && data != nil
    }
    
    func didReceiveRemoteNotification(userInfo: [AnyHashable: Any]) {
        guard let dictionary = userInfo as? [String: AnyHashable],
              shouldListenNotification(userinfo: userInfo) else { return }
        let link = PushLink(dictionary: dictionary)
        deepLinkManager.processLinkFromNotification(link)
    }
}

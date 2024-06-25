//
//  BrazeListener.swift
//  OpenEdX
//
//  Created by Anton Yarmolenka on 24/01/2024.
//

import Foundation

class BrazeListener: PushNotificationsListener {
    func shouldListenNotification(userinfo: [AnyHashable: Any]) -> Bool {
        //A push notification sent from the braze has a key ab in it like ab = {c = "c_value";};
        let data = userinfo["ab"] as? [String: Any]
        return userinfo.count > 0 && data != nil
    }
}

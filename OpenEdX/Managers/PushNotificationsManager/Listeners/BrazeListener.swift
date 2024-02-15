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
        guard let _ = userinfo["ab"] as? [String : Any], userinfo.count > 0
        else { return false }
        return true
    }
}

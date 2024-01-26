//
//  FCMListener.swift
//  OpenEdX
//
//  Created by Anton Yarmolenka on 24/01/2024.
//

import Foundation

class FCMListener: PushNotificationsListener {
    func notificationToThisListener(userinfo: [AnyHashable: Any]) -> Bool { false }
}

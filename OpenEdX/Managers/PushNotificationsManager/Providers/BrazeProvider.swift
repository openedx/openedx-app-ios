//
//  BrazeProvider.swift
//  OpenEdX
//
//  Created by Anton Yarmolenka on 24/01/2024.
//

import Foundation
import BrazeKit
import UIKit

class BrazeProvider: PushNotificationsProvider {
    func didRegisterForRemoteNotificationsWithDeviceToken(deviceToken: Data) {
        let configuration = Braze.Configuration(
            apiKey: "",
            endpoint: ""
        )
        let braze = Braze(configuration: configuration)
        braze.notifications.register(deviceToken: deviceToken)
        (UIApplication.shared.delegate as? AppDelegate)?.braze = braze
    }
    func didFailToRegisterForRemoteNotificationsWithError(error: Error) {
    }
}

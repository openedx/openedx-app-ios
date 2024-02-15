//
//  BrazeProvider.swift
//  OpenEdX
//
//  Created by Anton Yarmolenka on 24/01/2024.
//

import Foundation
import UIKit
import SegmentBrazeUI

class BrazeProvider: PushNotificationsProvider {
    func didRegisterWithDeviceToken(deviceToken: Data) {
        (UIApplication.shared.delegate as? AppDelegate)?.analytics?.add(
            plugin: BrazeDestination(
                additionalConfiguration: { configuration in
                    configuration.logger.level = .debug
                }, additionalSetup: { braze in
                    braze.notifications.register(deviceToken: deviceToken)
                }
            )
        )
    }
    func didFailToRegisterForRemoteNotificationsWithError(error: Error) {
    }
}

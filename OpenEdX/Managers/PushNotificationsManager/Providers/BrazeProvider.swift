//
//  BrazeProvider.swift
//  OpenEdX
//
//  Created by Anton Yarmolenka on 24/01/2024.
//

import Foundation
import SegmentBrazeUI
import Swinject

class BrazeProvider: PushNotificationsProvider {
    func didRegisterWithDeviceToken(deviceToken: Data) {
        guard let segmentService = Container.shared.resolve(SegmentAnalyticsService.self) else { return }
        segmentService.analytics?.add(
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

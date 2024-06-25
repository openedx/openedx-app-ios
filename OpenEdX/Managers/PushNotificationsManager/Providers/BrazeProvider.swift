//
//  BrazeProvider.swift
//  OpenEdX
//
//  Created by Anton Yarmolenka on 24/01/2024.
//

import Foundation
import SegmentBrazeUI

class BrazeProvider: PushNotificationsProvider {
    let segmentService: SegmentAnalyticsService?
    
    init(segmentService: SegmentAnalyticsService?) {
        self.segmentService = segmentService
    }
    
    func didRegisterWithDeviceToken(deviceToken: Data) {
        segmentService?.analytics?.add(
            plugin: BrazeDestination(
                additionalConfiguration: { configuration in
                    configuration.logger.level = .info
                }, additionalSetup: { braze in
                    braze.notifications.register(deviceToken: deviceToken)
                }
            )
        )
        
        segmentService?.analytics?.registeredForRemoteNotifications(deviceToken: deviceToken)
    }
    
    func didFailToRegisterForRemoteNotificationsWithError(error: Error) {
    }
    
    func synchronizeToken() {
    }
    
    func refreshToken() {
    }
}

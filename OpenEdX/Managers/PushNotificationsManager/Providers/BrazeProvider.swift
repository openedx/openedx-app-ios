//
//  BrazeProvider.swift
//  OpenEdX
//
//  Created by Anton Yarmolenka on 24/01/2024.
//

import Foundation
import Swinject
import OEXFoundation

class BrazeProvider: PushNotificationsProvider {
    
    func didRegisterWithDeviceToken(deviceToken: Data) {
        // Removed as part of the move to a plugin architecture, this code should be called from the plugin.
        
//        guard let segmentService = Container.shared.resolve(SegmentAnalyticsService.self) else { return }
//        segmentService.analytics?.add(
//            plugin: BrazeDestination(
//                additionalConfiguration: { configuration in
//                    configuration.logger.level = .info
//                }, additionalSetup: { braze in
//                    braze.notifications.register(deviceToken: deviceToken)
//                }
//            )
//        )
//        
//        segmentService.analytics?.registeredForRemoteNotifications(deviceToken: deviceToken)
    }
    
    func didFailToRegisterForRemoteNotificationsWithError(error: Error) {
    }
    
    func synchronizeToken() {
    }
    
    func refreshToken() {
    }
}

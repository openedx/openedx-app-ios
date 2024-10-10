//
//  BrazeProvider.swift
//  OpenEdX
//
//  Created by Anton Yarmolenka on 24/01/2024.
//

import Foundation
import SegmentBrazeUI
import Swinject
import OEXFoundation

class BrazeProvider: PushNotificationsProvider {
    
    func didRegisterWithDeviceToken(deviceToken: Data) {
    /// Removed as part of the move to a plugin architecture, this code should be called from the plugin.
    }
    
    func didFailToRegisterForRemoteNotificationsWithError(error: Error) {
    }
    
    func synchronizeToken() {
    }
    
    func refreshToken() {
    }
}

//
//  PushTokenUnregistering.swift
//  Core
//
//  Created by Rawan Matar on 20/09/2026.
//

import Foundation

/// @mockable
public protocol PushTokenUnregistering: Sendable {
    /// Unregisters this device's push token from the active instance's backend.
    func unregisterCurrentPushToken() async
}

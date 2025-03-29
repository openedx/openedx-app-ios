//
//  PluginManager.swift
//  OpenEdX
//
//  Created by Ivan Stepanok on 15.10.2024.
//

import Foundation
import OEXFoundation

public class PluginManager {
    
    private(set) var analyticsServices: [AnalyticsService] = []
    private(set) var pushNotificationsProviders: [PushNotificationsProvider] = []
    private(set) var pushNotificationsListeners: [PushNotificationsListener] = []
    
    public init() {}
    
    func addPlugin(analyticsService: AnalyticsService) {
        analyticsServices.append(analyticsService)
    }

    func addPlugin(
        pushNotificationsProvider: PushNotificationsProvider,
        pushNotificationsListener: PushNotificationsListener
    ) {
        pushNotificationsProviders.append(pushNotificationsProvider)
        pushNotificationsListeners.append(pushNotificationsListener)
    }
}

//
//  GoogleAnalyticsService.swift
//  OpenEdX
//
//  Created by Anton Yarmolenka on 15/02/2024.
//

import Foundation
import FirebaseAnalytics

class FirebaseAnalyticsService: AnalyticsService {
    func identify(id: String, username: String?, email: String?) {
        Analytics.setUserID(id)
    }
    func logEvent(_ event: Event, parameters: [String: Any]?) {
        Analytics.logEvent(event.rawValue, parameters: parameters)
    }
}

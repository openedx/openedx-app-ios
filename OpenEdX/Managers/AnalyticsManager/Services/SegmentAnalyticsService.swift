//
//  SegmentAnalyticsService.swift
//  OpenEdX
//
//  Created by Anton Yarmolenka on 15/02/2024.
//

import Foundation
import UIKit

class SegmentAnalyticsService: AnalyticsService {
    func identify(id: String, username: String?, email: String?) {
        guard let email = email, let username = username else { return }
        let traits: [String: String] = [
            "email": email,
            "username": username
        ]
        (UIApplication.shared.delegate as? AppDelegate)?.analytics?.identify(userId: id, traits: traits)
    }
    func logEvent(_ event: Event, parameters: [String: Any]?) {
        (UIApplication.shared.delegate as? AppDelegate)?.analytics?.track(
            name: event.rawValue,
            properties: parameters
        )
    }
}

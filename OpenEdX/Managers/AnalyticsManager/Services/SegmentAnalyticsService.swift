//
//  SegmentAnalyticsService.swift
//  OpenEdX
//
//  Created by Anton Yarmolenka on 15/02/2024.
//

import Foundation
import UIKit
import Swinject

class SegmentAnalyticsService: AnalyticsService {
    func identify(id: String, username: String?, email: String?) {
        guard let email = email, 
              let username = username,
              let segmentManager = Container.shared.resolve(SegmentManager.self)
        else { return }
        let traits: [String: String] = [
            "email": email,
            "username": username
        ]
        segmentManager.analytics?.identify(userId: id, traits: traits)
    }
    func logEvent(_ event: Event, parameters: [String: Any]?) {
        guard let segmentManager = Container.shared.resolve(SegmentManager.self) else { return }
        segmentManager.analytics?.track(
            name: event.rawValue,
            properties: parameters
        )
    }
}

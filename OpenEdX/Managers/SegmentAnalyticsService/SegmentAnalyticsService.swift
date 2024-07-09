//
//  SegmentAnalyticsService.swift
//  OpenEdX
//
//  Created by Anton Yarmolenka on 21/02/2024.
//

import Foundation
import Core
import Segment
import SegmentFirebase

class SegmentAnalyticsService: AnalyticsService {
    var analytics: Analytics?
    
    // Init manager
    public init(config: ConfigProtocol) {
        guard config.segment.enabled else { return }

        let configuration = Configuration(writeKey: config.segment.writeKey)
                        .trackApplicationLifecycleEvents(true)
                        .flushInterval(10)
        analytics = Analytics(configuration: configuration)
        if config.firebase.enabled && config.firebase.isAnalyticsSourceSegment {
            analytics?.add(plugin: FirebaseDestination())
        }
    }
    
    func identify(id: String, username: String?, email: String?) {
        guard let email = email, let username = username else { return }
        let traits: [String: String] = [
            "email": email,
            "username": username
        ]
        analytics?.identify(userId: id, traits: traits)
    }
    
    func logEvent(_ event: AnalyticsEvent, parameters: [String: Any]?) {
        analytics?.track(
            name: event.rawValue,
            properties: parameters
        )
    }
    
    func logScreenEvent(_ event: Core.AnalyticsEvent, parameters: [String: Any]?) {
        analytics?.screen(title: event.rawValue, properties: parameters)
    }
}

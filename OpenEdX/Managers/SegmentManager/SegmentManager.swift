//
//  SegmentManager.swift
//  OpenEdX
//
//  Created by Anton Yarmolenka on 21/02/2024.
//

import Foundation
import Core
import Segment
import SegmentFirebase

class SegmentManager {
    var analytics: Analytics?
    
    public func setup(with config: ConfigProtocol) {
        let configuration = Configuration(writeKey: config.segment.writeKey)
                        .trackApplicationLifecycleEvents(true)
                        .flushInterval(10)
        analytics = Analytics(configuration: configuration)
        if config.firebase.isAnalyticsSourceSegment {
            analytics?.add(plugin: FirebaseDestination())
        }
    }
}

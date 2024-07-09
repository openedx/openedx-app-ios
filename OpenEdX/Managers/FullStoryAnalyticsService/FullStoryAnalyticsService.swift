//
//  FullStoryAnalyticsService.swift
//  OpenEdX
//
//  Created by Saeed Bashir on 4/17/24.
//

import Foundation
import Core
import FullStory

class FullStoryAnalyticsService: AnalyticsService {
    
    func identify(id: String, username: String?, email: String?) {
        FS.identify(id, userVars: ["displayName": id])
    }
    
    func logEvent(_ event: AnalyticsEvent, parameters: [String: Any]?) {
        FS.event(event.rawValue, properties: parameters ?? [:])
    }
    
    func logScreenEvent(_ event: Core.AnalyticsEvent, parameters: [String: Any]?) {
        FS.page(withName: event.rawValue, properties: parameters).start()
    }
}

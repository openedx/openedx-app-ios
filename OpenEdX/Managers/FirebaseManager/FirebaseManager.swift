//
//  FirebaseManager.swift
//  OpenEdX
//
//  Created by Anton Yarmolenka on 19/02/2024.
//

import Foundation
import Firebase

class FirebaseManager: AnalyticsService {
    class func setup() {
        FirebaseApp.configure()
    }

    func identify(id: String, username: String?, email: String?) {
        Analytics.setUserID(id)
    }
    
    func logEvent(_ event: Event, parameters: [String: Any]?) {
        Analytics.logEvent(event.rawValue, parameters: parameters)
    }

}

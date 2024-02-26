//
//  FirebaseConfig.swift
//  Core
//
//  Created by Muhammad Umer on 11/12/23.
//

import Foundation

private enum FirebaseKeys: String {
    case enabled = "ENABLED"
    case analyticsSource = "ANALYTICS_SOURCE"
    case cloudMessagingEnabled = "CLOUD_MESSAGING_ENABLED"
    case apiKey = "API_KEY"
    case bundleID = "BUNDLE_ID"
    case clientID = "CLIENT_ID"
    case databaseURL = "DATABASE_URL"
    case gcmSenderID = "GCM_SENDER_ID"
    case googleAppID = "GOOGLE_APP_ID"
    case projectID = "PROJECT_ID"
    case reversedClientID = "REVERSED_CLIENT_ID"
    case storageBucket = "STORAGE_BUCKET"
}

enum AnalyticsSource: String {
    case firebase
    case segment
    case none
}

public final class FirebaseConfig: NSObject {
    public var enabled: Bool = false
    public var cloudMessagingEnabled: Bool = false
    public let apiKey: String?
    public let bundleID: String?
    public let clientID: String?
    public let databaseURL: String?
    public let gcmSenderID: String?
    public let googleAppID: String?
    public let projectID: String?
    public let reversedClientID: String?
    public let storageBucket: String?

    private let analyticsSource: AnalyticsSource
    
    public var requiredKeysAvailable: Bool {
        return apiKey != nil && clientID != nil && googleAppID != nil && gcmSenderID != nil
    }
    
    init(dictionary: [String: AnyObject]) {
        apiKey = dictionary[FirebaseKeys.apiKey.rawValue] as? String
        clientID = dictionary[FirebaseKeys.clientID.rawValue] as? String
        googleAppID = dictionary[FirebaseKeys.googleAppID.rawValue] as? String
        gcmSenderID = dictionary[FirebaseKeys.gcmSenderID.rawValue] as? String
        bundleID = dictionary[FirebaseKeys.bundleID.rawValue] as? String
        databaseURL = dictionary[FirebaseKeys.databaseURL.rawValue] as? String
        projectID = dictionary[FirebaseKeys.projectID.rawValue] as? String
        reversedClientID = dictionary[FirebaseKeys.reversedClientID.rawValue] as? String
        storageBucket = dictionary[FirebaseKeys.storageBucket.rawValue] as? String
        
        let analyticsSource = dictionary[FirebaseKeys.analyticsSource.rawValue] as? String
        self.analyticsSource = AnalyticsSource(rawValue: analyticsSource ?? AnalyticsSource.none.rawValue) ?? .none
        
        super.init()
        
        enabled = requiredKeysAvailable && dictionary[FirebaseKeys.enabled.rawValue] as? Bool == true
        let cloudMessagingEnabled = dictionary[FirebaseKeys.cloudMessagingEnabled.rawValue] as? Bool ?? false
        self.cloudMessagingEnabled = enabled && cloudMessagingEnabled
    }
    
    public var isAnalyticsSourceSegment: Bool {
        return analyticsSource == AnalyticsSource.segment
    }
    
    public var isAnalyticsSourceFirebase: Bool {
        return analyticsSource == AnalyticsSource.firebase
    }
}

private let firebaseKey = "FIREBASE"
extension Config {
    public var firebase: FirebaseConfig {
        FirebaseConfig(dictionary: self[firebaseKey] as? [String: AnyObject] ?? [:])
    }
}

//
//  ConfigTests.swift
//  CoreTests
//
//  Created by Muhammad Umer on 11/13/23.
//

import XCTest
@testable import Core

class ConfigTests: XCTestCase {
    
    private lazy var properties: [String: Any] = [
        "API_HOST_URL": "https://www.example.com",
        "OAUTH_CLIENT_ID": "oauth_client_id",
        "FEEDBACK_EMAIL_ADDRESS": "example@mail.com",
        "TOKEN_TYPE": "JWT",
        "WHATS_NEW_ENABLED": false,
        "AGREEMENT_URLS": [
            "PRIVACY_POLICY_URL": "https://www.example.com/privacy",
            "TOS_URL": "https://www.example.com/tos"
        ],
        "FIREBASE": [
            "ENABLED": true,
            "API_KEY": "testApiKey",
            "BUNDLE_ID": "testBundleID",
            "CLIENT_ID": "testClientID",
            "DATABASE_URL": "https://test.database.url",
            "GCM_SENDER_ID": "testGCMSenderID",
            "GOOGLE_APP_ID": "testGoogleAppID",
            "PROJECT_ID": "testProjectID",
            "REVERSED_CLIENT_ID": "testReversedClientID",
            "STORAGE_BUCKET": "testStorageBucket",
            "ANALYTICS_SOURCE": "firebase",
            "CLOUD_MESSAGING_ENABLED": true]
    ]
    
    func testConfigInitialization() {
        let config = Config(properties: properties)
        
        XCTAssertEqual(config.baseURL.absoluteString, "https://www.example.com")
        XCTAssertEqual(config.oAuthClientId, "oauth_client_id")
        XCTAssertEqual(config.feedbackEmail, "example@mail.com")
        XCTAssertEqual(config.tokenType.rawValue, "JWT")
        XCTAssertFalse(config.features.whatNewEnabled)
    }
    
    func testFeaturesConfigInitialization() {
        let config = Config(properties: properties)
        
        XCTAssertFalse(config.features.whatNewEnabled)
    }
    
    func testAgreementConfigInitialization() {
        let config = Config(properties: properties)
        
        XCTAssertEqual(config.agreement.privacyPolicyURL, URL(string: "https://www.example.com/privacy"))
        XCTAssertEqual(config.agreement.tosURL, URL(string: "https://www.example.com/tos"))
    }
    
    func testFirebaseConfigInitialization() {
        let config = Config(properties: properties)
        
        XCTAssertTrue(config.firebase.enabled)
        XCTAssertEqual(config.firebase.apiKey, "testApiKey")
        XCTAssertEqual(config.firebase.bundleID, "testBundleID")
        XCTAssertEqual(config.firebase.clientID, "testClientID")
        XCTAssertEqual(config.firebase.databaseURL, "https://test.database.url")
        XCTAssertEqual(config.firebase.gcmSenderID, "testGCMSenderID")
        XCTAssertEqual(config.firebase.googleAppID, "testGoogleAppID")
        XCTAssertEqual(config.firebase.projectID, "testProjectID")
        XCTAssertEqual(config.firebase.reversedClientID, "testReversedClientID")
        XCTAssertEqual(config.firebase.storageBucket, "testStorageBucket")
        XCTAssertEqual(config.firebase.isAnalyticsSourceFirebase, true)
        XCTAssertEqual(config.firebase.cloudMessagingEnabled, true)
    }
}

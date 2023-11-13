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
        "FIREBASE": firebaseProperties
    ]
    
    private lazy var firebaseProperties: [String: Any] = [
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
        "CLOUD_MESSAGING_ENABLED": true
    ]
    
    func testConfigInitialization() {
        let config = Config(properties: properties)
        
        XCTAssertEqual(config.baseURL.absoluteString, "https://www.example.com")
        XCTAssertEqual(config.oAuthClientId, "oauth_client_id")
        XCTAssertEqual(config.feedbackEmail, "example@mail.com")
        XCTAssertEqual(config.tokenType, TokenType.jwt)
        XCTAssertFalse(config.whatsNewEnabled)
    }
    
    func testAgreementConfigInitialization() {
        let config = Config(properties: properties)
        
        XCTAssertEqual(config.agreementConfig.privacyPolicyURL, URL(string: "https://www.example.com/privacy"))
        XCTAssertEqual(config.agreementConfig.tosURL, URL(string: "https://www.example.com/tos"))
    }
    
    func testFirebaseConfigInitialization() {
        let config = Config(properties: properties)
        
        XCTAssertTrue(config.firebaseConfig.enabled)
        XCTAssertEqual(config.firebaseConfig.apiKey, "testApiKey")
        XCTAssertEqual(config.firebaseConfig.bundleID, "testBundleID")
        XCTAssertEqual(config.firebaseConfig.clientID, "testClientID")
        XCTAssertEqual(config.firebaseConfig.databaseURL, "https://test.database.url")
        XCTAssertEqual(config.firebaseConfig.gcmSenderID, "testGCMSenderID")
        XCTAssertEqual(config.firebaseConfig.googleAppID, "testGoogleAppID")
        XCTAssertEqual(config.firebaseConfig.projectID, "testProjectID")
        XCTAssertEqual(config.firebaseConfig.reversedClientID, "testReversedClientID")
        XCTAssertEqual(config.firebaseConfig.storageBucket, "testStorageBucket")
        XCTAssertEqual(config.firebaseConfig.isAnalyticsSourceFirebase, true)
        XCTAssertEqual(config.firebaseConfig.cloudMessagingEnabled, true)
    }
}

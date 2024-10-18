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
        "WHATS_NEW_ENABLED": true,
        "AGREEMENT_URLS": [
            "PRIVACY_POLICY_URL": "https://www.example.com/privacy",
            "TOS_URL": "https://www.example.com/tos",
            "DATA_SELL_CONSENT_URL": "https://www.example.com/sell",
            "COOKIE_POLICY_URL": "https://www.example.com/cookie",
            "SUPPORTED_LANGUAGES": ["es"]
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
            "CLOUD_MESSAGING_ENABLED": true
        ],
        "GOOGLE": [
            "ENABLED": true,
            "CLIENT_ID": "clientId"
        ],
        "FACEBOOK": [
            "ENABLED": true,
            "FACEBOOK_APP_ID": "facebookAppId",
            "CLIENT_TOKEN": "client_token"
        ],
        "MICROSOFT": [
            "ENABLED": true,
            "APP_ID": "appId"
        ],
        "APPLE_SIGNIN": [
            "ENABLED": true
        ],
        "BRAZE": [
            "ENABLED": true,
            "PUSH_NOTIFICATIONS_ENABLED": true
        ],
        "BRANCH": [
            "ENABLED": true,
            "KEY": "testBranchKey"
        ],
        "SEGMENT_IO": [
            "ENABLED": true,
            "SEGMENT_IO_WRITE_KEY": "testSegmentKey"
        ]
    ]
    
    func testConfigInitialization() {
        let config = Config(properties: properties)
        
        XCTAssertEqual(config.baseURL.absoluteString, "https://www.example.com")
        XCTAssertEqual(config.oAuthClientId, "oauth_client_id")
        XCTAssertEqual(config.feedbackEmail, "example@mail.com")
        XCTAssertEqual(config.tokenType.rawValue, "JWT")
        XCTAssertTrue(config.features.whatNewEnabled)
    }
    
    func testFeaturesConfigInitialization() {
        let config = Config(properties: properties)
        
        XCTAssertTrue(config.features.whatNewEnabled)
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

    func testGoogleConfigInitialization() {
        let config = Config(properties: properties)

        XCTAssertTrue(config.google.enabled)
        XCTAssertEqual(config.google.clientID, "clientId")
    }

    func testFacebookConfigInitialization() {
        let config = Config(properties: properties)

        XCTAssertTrue(config.facebook.enabled)
        XCTAssertEqual(config.facebook.appID, "facebookAppId")
        XCTAssertEqual(config.facebook.clientToken, "client_token")
    }

    func testMicrosoftConfigInitialization() {
        let config = Config(properties: properties)

        XCTAssertTrue(config.microsoft.enabled)
        XCTAssertEqual(config.microsoft.appID, "appId")
    }

    func testAppleConfigInitialization() {
        let config = Config(properties: properties)

        XCTAssertTrue(config.appleSignIn.enabled)
    }
    
    func testBrazeConfigInitialization() {
        let config = Config(properties: properties)

        XCTAssertTrue(config.braze.pushNotificationsEnabled)
    }
    
    func testBranchConfigInitialization() {
        let config = Config(properties: properties)

        XCTAssertTrue(config.branch.enabled)
        XCTAssertEqual(config.branch.key, "testBranchKey")
    }
}

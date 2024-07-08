//
//  FullStoryConfigTests.swift
//  CoreTests
//
//  Created by Saeed Bashir on 6/21/24.
//

import XCTest
@testable import Core

class FullStoryConfigTests: XCTestCase {
    
    func testNoFullStoryConfig() {
        let config = Config(properties: [:])
        XCTAssertFalse(config.fullStory.enabled)
    }

    func testFullStoryEnabled() {
        let configDictionary = [
            "FULLSTORY": [
                "ENABLED": true,
                "ORG_ID": "org_id"
            ]
        ]

        let config = Config(properties: configDictionary)

        XCTAssertTrue(config.fullStory.enabled)
        XCTAssertNotNil(config.fullStory.orgID)
    }

    func testFullStoryDisabled() {
        let configDictionary = [
            "FULLSTORY": [
                "ENABLED": false,
                "ORG_ID": "org_id"
            ]
        ]

        let config = Config(properties: configDictionary)

        XCTAssertFalse(config.fullStory.enabled)
        XCTAssertNotNil(config.fullStory.orgID)
    }
    
    func testFullStoryMissingORGID() {
        let configDictionary = [
            "FULLSTORY": [
                "ENABLED": true
            ]
        ]

        let config = Config(properties: configDictionary)
        XCTAssertFalse(config.fullStory.enabled)
        XCTAssertEqual(config.fullStory.orgID, "")
    }
}

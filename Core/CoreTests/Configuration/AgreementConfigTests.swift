//
//  AgreementConfigTests.swift
//  CoreTests
//
//  Created by Eugene Yatsenko on 14.12.2023.
//

import XCTest
@testable import Core

class AgreementConfigTests: XCTestCase {
    private lazy var properties: [String: Any] = [
        "AGREEMENT_URLS": [
            "PRIVACY_POLICY_URL": "https://www.example.com/privacy",
            "TOS_URL": "https://www.example.com/tos",
            "DATA_SELL_CONSENT_URL": "https://www.example.com/sell",
            "COOKIE_POLICY_URL": "https://www.example.com/cookie",
            "SUPPORTED_LANGUAGES": ["es"]
        ]
    ]
    
    func testAgreementConfigInitialization() {
        let config = Config(properties: properties)
        
        XCTAssertEqual(config.agreement.privacyPolicyURL, URL(string: "https://www.example.com/privacy"))
        XCTAssertEqual(config.agreement.tosURL, URL(string: "https://www.example.com/tos"))
        XCTAssertEqual(config.agreement.cookiePolicyURL, URL(string: "https://www.example.com/cookie"))
        XCTAssertEqual(config.agreement.dataSellContentURL, URL(string: "https://www.example.com/sell"))
        XCTAssertEqual(config.agreement.supportedLanguages, ["es"])
    }
}

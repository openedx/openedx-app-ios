//
//  AgreementConfigTests.swift
//  CoreTests
//
//  Created by Eugene Yatsenko on 14.12.2023.
//

import XCTest
@testable import Core

class AgreementConfigTests: XCTestCase {

    private let privacy = "https://www.example.com/privacy"
    private let tos = "https://www.example.com/tos"
    private let dataSellContent = "https://www.example.com/sell"
    private let cookie = "https://www.example.com/cookie"
    private let supportedLanguages = ["es"]

    private lazy var properties: [String: Any] = [
        "AGREEMENT_URLS": [
            "PRIVACY_POLICY_URL": privacy,
            "TOS_URL": tos,
            "DATA_SELL_CONSENT_URL": dataSellContent,
            "COOKIE_POLICY_URL": cookie,
            "SUPPORTED_LANGUAGES": supportedLanguages
        ]
    ]
    
    func testAgreementConfigInitialization() {
        let config = Config(properties: properties)
        
        XCTAssertEqual(config.agreement.privacyPolicyURL, URL(string: privacy))
        XCTAssertEqual(config.agreement.tosURL, URL(string: tos))
        XCTAssertEqual(config.agreement.cookiePolicyURL, URL(string: cookie))
        XCTAssertEqual(config.agreement.dataSellContentURL, URL(string: dataSellContent))
        XCTAssertEqual(config.agreement.supportedLanguages, supportedLanguages)
    }
}

//
//  WhatsNewTests.swift
//  WhatsNewTests
//
//  Created by  Stepanok Ivan on 18.10.2023.
//

import XCTest
@testable import WhatsNew

final class WhatsNewTests: XCTestCase {

    func testGetVersion() throws {
     let viewModel = WhatsNewViewModel(storage: WhatsNewStorageMock())
        let version = viewModel.getVersion()
        XCTAssertNotNil(version)
        XCTAssertTrue(version == "1.0")
    }
    
    func testshouldShowWhatsNew() throws {
     let viewModel = WhatsNewViewModel(storage: WhatsNewStorageMock())
        let version = viewModel.getVersion()
        
        XCTAssertNotNil(version)
        XCTAssertTrue(viewModel.shouldShowWhatsNew())
    }
}

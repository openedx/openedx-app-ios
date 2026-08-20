//
//  LMSDirectoryConfigSourceTests.swift
//  CoreTests
//
//  Which document a build reads is decided entirely by the config file, and the
//  mistakes are invisible until someone ships: a build that quietly ignores the
//  copy it bundled, or one that thinks it has a directory when it has nothing.
//

import XCTest
@testable import Core

final class LMSDirectoryConfigSourceTests: XCTestCase {

    private func config(_ dict: [String: Any]) -> LMSDirectoryConfig {
        LMSDirectoryConfig(dictionary: dict)
    }

    func testAnAddressIsFetchedAsADocument() {
        XCTAssertEqual(
            config(["ENABLED": true, "DIRECTORY_URL": "https://example.com/lms_directory.json"]).source,
            .document(URL(string: "https://example.com/lms_directory.json")!)
        )
        // Nothing hangs off the file extension: whatever the address ends in, what
        // comes back is expected to be the document.
        XCTAssertEqual(
            config(["ENABLED": true, "DIRECTORY_URL": "https://example.com/directory"]).source,
            .document(URL(string: "https://example.com/directory")!)
        )
    }

    func testABundledFileWinsOverAnAddress() {
        // A build shipping its own copy has opted out of the network; quietly
        // preferring a remote list would undo that.
        XCTAssertEqual(
            config([
                "ENABLED": true,
                "DIRECTORY_URL": "https://example.com/lms_directory.json",
                "DIRECTORY_FILE": "lms_directory.json",
            ]).source,
            .bundledDocument("lms_directory.json")
        )
    }

    func testNothingConfiguredMeansNoSourceAndNothingReachable() {
        XCTAssertNil(config(["ENABLED": true]).source)
        XCTAssertFalse(config(["ENABLED": true]).isDirectoryReachable)
        XCTAssertNil(config(["ENABLED": false, "DIRECTORY_URL": "https://example.com/d.json"]).source)
    }

    func testABundledFileAloneIsEnoughToBeReachable() {
        XCTAssertTrue(config(["ENABLED": true, "DIRECTORY_FILE": "lms_directory.json"]).isDirectoryReachable)
    }

    func testWhitespaceIsNotAConfiguredSource() {
        XCTAssertNil(config(["ENABLED": true, "DIRECTORY_URL": "   ", "DIRECTORY_FILE": "  "]).source)
        XCTAssertFalse(config(["ENABLED": true, "DIRECTORY_URL": "   "]).isDirectoryReachable)
    }
}

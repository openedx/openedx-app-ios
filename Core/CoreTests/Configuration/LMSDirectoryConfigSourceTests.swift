//
//  LMSDirectoryConfigSourceTests.swift
//  CoreTests
//
//  Which source a build reads from is decided entirely by the config file, and
//  one capability hangs off it: whether there is anywhere to report a platform.
//  Both are worth holding down, because both are invisible until someone ships.
//

import XCTest
@testable import Core

final class LMSDirectoryConfigSourceTests: XCTestCase {

    private func config(_ dict: [String: Any]) -> LMSDirectoryConfig {
        LMSDirectoryConfig(dictionary: dict)
    }

    func testAJSONAddressIsADocumentAndAnythingElseIsAService() {
        XCTAssertEqual(
            config(["ENABLED": true, "DIRECTORY_URL": "https://example.com/directory.json"]).source,
            .document(URL(string: "https://example.com/directory.json")!)
        )
        XCTAssertEqual(
            config(["ENABLED": true, "DIRECTORY_URL": "https://example.com"]).source,
            .service(URL(string: "https://example.com")!)
        )
    }

    func testABundledFileWinsOverAnAddress() {
        // A build shipping its own copy has opted out of the network; quietly
        // preferring a remote list would undo that.
        XCTAssertEqual(
            config([
                "ENABLED": true,
                "DIRECTORY_URL": "https://example.com/directory.json",
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

    func testOnlyALiveServiceCanBeReportedTo() {
        // Reporting belongs to the universal app. A document has no service behind
        // it, so there is nowhere to post and the entry point must stay hidden.
        XCTAssertTrue(config(["ENABLED": true, "DIRECTORY_URL": "https://example.com"]).supportsReporting)
        XCTAssertFalse(config(["ENABLED": true, "DIRECTORY_URL": "https://example.com/d.json"]).supportsReporting)
        XCTAssertFalse(config(["ENABLED": true, "DIRECTORY_FILE": "lms_directory.json"]).supportsReporting)
        XCTAssertFalse(config(["ENABLED": false, "DIRECTORY_URL": "https://example.com"]).supportsReporting)
    }
}

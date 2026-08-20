//
//  LMSImageSourceTests.swift
//  Core
//
//  Created by Ivan Stepanok on 20.08.2026.
//

import XCTest
@testable import Core

/// CoreTests
/// One field decides whether an image is downloaded or read out of the app. The
/// rule is simple enough to state in a sentence, which is exactly why it needs
/// tests: an operator editing the document by hand will lean on it.
final class LMSImageSourceTests: XCTestCase {

    func testWebAddressesAreDownloaded() {
        XCTAssertEqual(
            LMSImageSource(value: "https://cdn.example.com/logo.png"),
            .remote(URL(string: "https://cdn.example.com/logo.png")!)
        )
        XCTAssertEqual(
            LMSImageSource(value: "http://cdn.example.com/logo.png"),
            .remote(URL(string: "http://cdn.example.com/logo.png")!)
        )
    }

    func testAnythingElseIsAFileInsideTheApp() {
        XCTAssertEqual(LMSImageSource(value: "acme-logo.png"), .bundled(name: "acme-logo.png"))
        XCTAssertEqual(LMSImageSource(value: "logos/acme.webp"), .bundled(name: "logos/acme.webp"))
        // A scheme we cannot fetch is not a download either.
        XCTAssertEqual(LMSImageSource(value: "file:///tmp/a.png"), .bundled(name: "file:///tmp/a.png"))
    }

    func testSurroundingWhitespaceDoesNotChangeTheAnswer() {
        // Hand-edited JSON picks up stray spaces; a trailing one used to turn a
        // perfectly good address into a request for "…png%20".
        XCTAssertEqual(
            LMSImageSource(value: "  https://cdn.example.com/logo.png  "),
            .remote(URL(string: "https://cdn.example.com/logo.png")!)
        )
        XCTAssertEqual(LMSImageSource(value: " acme.png "), .bundled(name: "acme.png"))
    }

    func testEmptyAndMissingValuesProduceNothing() {
        XCTAssertNil(LMSImageSource(value: nil))
        XCTAssertNil(LMSImageSource(value: ""))
        XCTAssertNil(LMSImageSource(value: "   "))
        XCTAssertNil(LMSImageSource(url: nil))
    }

    func testRemoteURLIsOnlyExposedForSomethingFetchable() {
        XCTAssertNotNil(LMSImageSource(value: "https://cdn.example.com/a.png")?.remoteURL)
        XCTAssertNil(LMSImageSource(value: "a.png")?.remoteURL)
        XCTAssertNil(LMSImageSource(value: "https://cdn.example.com/a.png")?.bundledImage())
    }
}

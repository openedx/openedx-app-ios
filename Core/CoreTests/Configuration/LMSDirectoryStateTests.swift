//
//  LMSDirectoryStateTests.swift
//  CoreTests
//
//  Whether a build offers to report a platform depends partly on something only
//  the server can say, remembered between launches. These are the tests that a
//  remembered answer is dropped the moment it stops applying — the failure they
//  guard against is silent, and shows up as a button that is missing (or present)
//  for the rest of a release.
//

import XCTest
@testable import Core

final class LMSDirectoryStateTests: XCTestCase {

    private var defaults: UserDefaults!
    private let suite = "LMSDirectoryStateTests"

    override func setUp() {
        super.setUp()
        UserDefaults().removePersistentDomain(forName: suite)
        defaults = UserDefaults(suiteName: suite)
    }

    override func tearDown() {
        defaults.removePersistentDomain(forName: suite)
        defaults = nil
        super.tearDown()
    }

    private func service(_ url: String = "https://registry.test", mode: String = "") -> LMSDirectoryConfig {
        LMSDirectoryConfig(dictionary: ["ENABLED": true, "DIRECTORY_URL": url, "DIRECTORY_MODE": mode])
    }

    private func document(_ url: String = "https://registry.test/d.json") -> LMSDirectoryConfig {
        LMSDirectoryConfig(dictionary: ["ENABLED": true, "DIRECTORY_URL": url])
    }

    private func bundled(_ name: String = "lms_directory.json") -> LMSDirectoryConfig {
        LMSDirectoryConfig(dictionary: ["ENABLED": true, "DIRECTORY_FILE": name])
    }

    // MARK: - What the configuration alone decides

    func testADocumentIsCuratedWithoutAskingAnyone() {
        XCTAssertTrue(LMSDirectoryState.isCurated(for: document(), defaults: defaults))
        XCTAssertTrue(LMSDirectoryState.isCurated(for: bundled(), defaults: defaults))
        // …and therefore never offers reporting, whatever is remembered.
        XCTAssertFalse(LMSDirectoryState.canReport(for: document(), defaults: defaults))
        XCTAssertFalse(LMSDirectoryState.canReport(for: bundled(), defaults: defaults))
    }

    func testAServiceStartsUncuratedUntilItSaysOtherwise() {
        XCTAssertFalse(LMSDirectoryState.isCurated(for: service(), defaults: defaults))
        XCTAssertTrue(LMSDirectoryState.canReport(for: service(), defaults: defaults))
    }

    func testAForcedModeIsHonouredWithoutTheServer() {
        XCTAssertTrue(LMSDirectoryState.isCurated(for: service(mode: "curated"), defaults: defaults))
        XCTAssertFalse(LMSDirectoryState.canReport(for: service(mode: "curated"), defaults: defaults))
    }

    // MARK: - Moving between sources

    func testACuratedAnswerDoesNotFollowTheBuildToAnotherService() {
        let curatedService = service("https://curated.test")
        LMSDirectoryState.rememberCurated(true, for: curatedService, defaults: defaults)
        XCTAssertFalse(LMSDirectoryState.canReport(for: curatedService, defaults: defaults))

        // The build is pointed at an open catalog. The picker may never run again —
        // a platform is already selected — so nothing would correct a remembered
        // answer. It must not be believed in the first place.
        let openCatalog = service("https://open.test")
        XCTAssertFalse(LMSDirectoryState.isCurated(for: openCatalog, defaults: defaults))
        XCTAssertTrue(LMSDirectoryState.canReport(for: openCatalog, defaults: defaults))
    }

    func testMovingFromADocumentToAnOpenCatalogRestoresReporting() {
        // A document build remembers nothing, but an earlier service build might
        // have left something behind.
        LMSDirectoryState.rememberCurated(true, for: service("https://old.test"), defaults: defaults)
        XCTAssertFalse(LMSDirectoryState.canReport(for: bundled(), defaults: defaults))

        let openCatalog = service("https://open.test")
        XCTAssertTrue(LMSDirectoryState.canReport(for: openCatalog, defaults: defaults))
    }

    func testTheAnswerStillHoldsForTheSourceThatGaveIt() {
        let catalog = service("https://registry.test")
        LMSDirectoryState.rememberCurated(true, for: catalog, defaults: defaults)
        XCTAssertTrue(LMSDirectoryState.isCurated(for: catalog, defaults: defaults))
        XCTAssertFalse(LMSDirectoryState.canReport(for: catalog, defaults: defaults))
    }

    func testReconcileDropsAnAnswerThatNoLongerApplies() {
        let old = service("https://old.test")
        LMSDirectoryState.rememberCurated(true, for: old, defaults: defaults)

        LMSDirectoryState.reconcile(with: service("https://new.test"), defaults: defaults)
        XCTAssertNil(defaults.string(forKey: "lmsDirectory.sourceKey"))
        XCTAssertFalse(defaults.bool(forKey: "lmsDirectory.isCurated"))
    }

    func testReconcileLeavesAMatchingAnswerAlone() {
        let same = service("https://registry.test")
        LMSDirectoryState.rememberCurated(true, for: same, defaults: defaults)
        LMSDirectoryState.reconcile(with: same, defaults: defaults)
        XCTAssertTrue(LMSDirectoryState.isCurated(for: same, defaults: defaults))
    }

    func testClearForgetsEverything() {
        LMSDirectoryState.rememberCurated(true, for: service(), defaults: defaults)
        LMSDirectoryState.clear(defaults: defaults)
        XCTAssertNil(defaults.string(forKey: "lmsDirectory.sourceKey"))
        XCTAssertTrue(LMSDirectoryState.canReport(for: service(), defaults: defaults))
    }

    // MARK: - Source keys

    func testEverySourceHasItsOwnKey() {
        XCTAssertEqual(service("https://a.test").sourceKey, "service:https://a.test")
        XCTAssertEqual(document("https://a.test/d.json").sourceKey, "document:https://a.test/d.json")
        XCTAssertEqual(bundled("x.json").sourceKey, "file:x.json")
        XCTAssertEqual(LMSDirectoryConfig(dictionary: ["ENABLED": false]).sourceKey, "")
    }

    /// An upgrade carries the old flag but no source key, and the flag alone is
    /// exactly what went stale.
    func testAValueFromAnOlderBuildWithNoSourceKeyIsNotTrusted() {
        defaults.set(true, forKey: "lmsDirectory.isCurated")

        XCTAssertFalse(LMSDirectoryState.isCurated(for: service(), defaults: defaults))
        XCTAssertTrue(LMSDirectoryState.canReport(for: service(), defaults: defaults))
    }

    /// The gate the Profile screen reads: with the feature off there is no
    /// directory at all, so there is nothing to report to.
    func testADisabledDirectoryOffersNoReporting() {
        LMSDirectoryState.rememberCurated(false, for: service(), defaults: defaults)
        let off = LMSDirectoryConfig(dictionary: ["ENABLED": false, "DIRECTORY_URL": "https://registry.test"])

        XCTAssertFalse(LMSDirectoryState.canReport(for: off, defaults: defaults))
    }
}

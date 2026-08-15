//
//  LMSDirectoryStateTests.swift
//  CoreTests
//
//  Whether a build offers to report a platform depends on something only a live
//  server can say, remembered between launches. These cover the ways a
//  remembered answer stops being true: the build is pointed elsewhere, the
//  server changes its mind at the same address, or the value was written by a
//  version that recorded no source at all.
//

import Combine
import XCTest
@testable import Core

@MainActor
final class LMSDirectoryStateTests: XCTestCase {

    private var defaults: UserDefaults!
    private var state: LMSDirectoryState!
    private let suite = "LMSDirectoryStateTests"

    override func setUp() {
        super.setUp()
        UserDefaults().removePersistentDomain(forName: suite)
        defaults = UserDefaults(suiteName: suite)
        state = LMSDirectoryState(defaults: defaults)
    }

    override func tearDown() {
        defaults.removePersistentDomain(forName: suite)
        defaults = nil
        state = nil
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
        XCTAssertEqual(state.mode(for: document()), .curated)
        XCTAssertEqual(state.mode(for: bundled()), .curated)
        XCTAssertFalse(state.canReport(for: document()))
        XCTAssertFalse(state.canReport(for: bundled()))
    }

    func testAServiceIsUnknownUntilItAnswers() {
        // The point of three states: an unanswered service is not "open", it is
        // unknown, and nothing that depends on the answer may appear yet.
        XCTAssertEqual(state.mode(for: service()), .unknown)
        XCTAssertFalse(state.canReport(for: service()))
    }

    func testAForcedModeIsHonouredWithoutTheServer() {
        XCTAssertEqual(state.mode(for: service(mode: "curated")), .curated)
        XCTAssertFalse(state.canReport(for: service(mode: "curated")))

        XCTAssertEqual(state.mode(for: service(mode: "search")), .search)
        XCTAssertTrue(state.canReport(for: service(mode: "search")))
    }

    func testADisabledDirectoryOffersNoReporting() {
        state.remember(.search, for: service())
        let off = LMSDirectoryConfig(dictionary: ["ENABLED": false, "DIRECTORY_URL": "https://registry.test"])

        XCTAssertFalse(state.canReport(for: off))
    }

    // MARK: - What a remembered answer is good for

    func testAnAnsweredServiceOffersReporting() {
        state.remember(.search, for: service())

        XCTAssertEqual(state.mode(for: service()), .search)
        XCTAssertTrue(state.canReport(for: service()))
    }

    func testTheAnswerStillHoldsForTheSourceThatGaveIt() {
        state.remember(.curated, for: service())

        XCTAssertEqual(state.mode(for: service()), .curated)
        XCTAssertFalse(state.canReport(for: service()))
    }

    func testAnAnswerDoesNotFollowTheBuildToAnotherService() {
        // The picker is skipped once a platform is selected, so nothing would
        // ever overwrite an answer left by a different registry.
        state.remember(.curated, for: service("https://old.test"))

        XCTAssertEqual(state.mode(for: service("https://new.test")), .unknown)
        XCTAssertFalse(state.canReport(for: service("https://new.test")))
    }

    func testMovingFromADocumentToAServiceLeavesTheModeUnknown() {
        state.remember(.curated, for: document())

        XCTAssertEqual(state.mode(for: service()), .unknown)
        XCTAssertFalse(state.canReport(for: service()))
    }

    func testMovingFromAServiceToADocumentHidesReporting() {
        state.remember(.search, for: service())

        XCTAssertEqual(state.mode(for: document()), .curated)
        XCTAssertFalse(state.canReport(for: document()))
    }

    // MARK: - The same address changing its mind

    func testTheSameServiceCanChangeItsMode() {
        state.remember(.curated, for: service())
        XCTAssertFalse(state.canReport(for: service()))

        state.remember(.search, for: service())

        XCTAssertEqual(state.mode(for: service()), .search)
        XCTAssertTrue(state.canReport(for: service()))
    }

    func testARefreshRecordsWhatTheServerNowSays() async {
        state.remember(.curated, for: service())

        await state.refresh(for: service()) { .search }

        XCTAssertEqual(state.mode(for: service()), .search)
        XCTAssertTrue(state.canReport(for: service()))
    }

    func testAFailedRefreshChangesNothing() async {
        struct Offline: Error {}
        state.remember(.search, for: service())

        await state.refresh(for: service()) { throw Offline() }

        XCTAssertEqual(state.mode(for: service()), .search)
    }

    func testARefreshDoesNotOverrideAConfiguredMode() async {
        // DIRECTORY_MODE is the operator's decision; the server does not get a vote.
        await state.refresh(for: service(mode: "curated")) { .search }

        XCTAssertEqual(state.mode(for: service(mode: "curated")), .curated)
    }

    func testADocumentIsNeverRefreshed() async {
        var asked = false
        await state.refresh(for: document()) {
            asked = true
            return .search
        }

        XCTAssertFalse(asked, "a document has no server to ask")
    }

    // MARK: - Upgrades from a build that stored only a boolean

    func testALegacyCuratedFlagIsNotTreatedAsAnOpenCatalog() {
        // The upgrade the old code got wrong twice over: the flag names no source,
        // so it cannot be trusted — and the absence of trust must hide reporting,
        // not reveal it.
        defaults.set(true, forKey: "lmsDirectory.isCurated")

        XCTAssertEqual(state.mode(for: service()), .unknown)
        XCTAssertFalse(state.canReport(for: service()))
    }

    func testALegacyOpenFlagAlsoHidesReportingUntilTheServerAnswers() {
        defaults.set(false, forKey: "lmsDirectory.isCurated")

        XCTAssertFalse(state.canReport(for: service()))

        state.remember(.search, for: service())
        XCTAssertTrue(state.canReport(for: service()))
    }

    func testReconcileDropsTheLegacyFlagEntirely() {
        defaults.set(true, forKey: "lmsDirectory.isCurated")

        state.reconcile(with: service())

        XCTAssertNil(defaults.object(forKey: "lmsDirectory.isCurated"))
    }

    // MARK: - Housekeeping

    func testReconcileDropsAnAnswerThatNoLongerApplies() {
        state.remember(.search, for: service("https://old.test"))

        state.reconcile(with: service("https://new.test"))

        XCTAssertEqual(state.mode(for: service("https://new.test")), .unknown)
    }

    func testReconcileLeavesAMatchingAnswerAlone() {
        state.remember(.search, for: service())

        state.reconcile(with: service())

        XCTAssertEqual(state.mode(for: service()), .search)
    }

    func testClearForgetsEverything() {
        state.remember(.search, for: service())

        state.clear()

        XCTAssertEqual(state.mode(for: service()), .unknown)
        XCTAssertFalse(state.canReport(for: service()))
    }

    func testEverySourceHasItsOwnKey() {
        XCTAssertNotEqual(service().sourceKey, document().sourceKey)
        XCTAssertNotEqual(document().sourceKey, bundled().sourceKey)
        XCTAssertNotEqual(service("https://a.test").sourceKey, service("https://b.test").sourceKey)
    }

    func testAChangedAnswerIsObservable() {
        // The Profile screen redraws off this; without it the entry point would
        // only appear on the next visit.
        var notified = 0
        let token = state.objectWillChange.sink { _ in notified += 1 }

        state.remember(.search, for: service())
        state.remember(.curated, for: service())

        XCTAssertEqual(notified, 2)
        token.cancel()
    }
}

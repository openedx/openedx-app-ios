//
//  LMSDirectoryProfileUITests.swift
//  LMSDirectoryUITests
//
//  Whether the app offers "Report this LMS" can only be seen from inside a
//  signed-in app, which is why this exists as a UI test rather than a unit one.
//
//  It needs a directory and an LMS to sign in against. Point the build at either
//  and tell the test what it should find:
//
//      TEST_RUNNER_LMS_DIRECTORY_UITEST=1
//      TEST_RUNNER_EXPECT_REPORTING=1        # 1 when the build reads a live catalog
//      TEST_RUNNER_LMS_PLATFORM="Stub College"
//      TEST_RUNNER_LMS_USERNAME=…  TEST_RUNNER_LMS_PASSWORD=…
//
//  Without the first variable the test skips: it drives a real sign-in, so it has
//  nothing to say in a run that was not set up for it. Point it at any Open edX
//  you can sign into, or at a stand-in that answers /oauth2/access_token,
//  /api/mobile/v0.5/my_user_info and /api/user/v1/accounts/<username>.
//

import XCTest

final class LMSDirectoryProfileUITests: XCTestCase {

    private var environment: [String: String] { ProcessInfo.processInfo.environment }

    func testProfileReportingMatchesTheConfiguredDirectory() throws {
        try XCTSkipUnless(
            environment["LMS_DIRECTORY_UITEST"] == "1",
            "needs a directory and an LMS to sign in against — see the file header"
        )
        let expected = environment["EXPECT_REPORTING"] == "1"
        let platformName = environment["LMS_PLATFORM"] ?? "Stub College"
        let username = environment["LMS_USERNAME"] ?? ""
        let password = environment["LMS_PASSWORD"] ?? ""

        let app = XCUIApplication()
        app.launch()

        // A signed-in build goes straight to the dashboard — which is the case
        // worth caring about, because it is the one where the platform picker
        // never runs and a remembered answer would go unchallenged.
        let platform = app.staticTexts[platformName].firstMatch
        if platform.waitForExistence(timeout: 20) {
            platform.tap()
            try signIn(app, username: username, password: password)
        }

        let profileTab = app.buttons["Profile"].firstMatch
        XCTAssertTrue(profileTab.waitForExistence(timeout: 30), "never signed in")
        profileTab.tap()

        XCTAssertTrue(
            app.buttons["Edit Profile"].firstMatch.waitForExistence(timeout: 20),
            "Profile tab never rendered"
        )

        // What this test is for.
        let reporting = app.buttons["Report this LMS"].firstMatch
        let present = reporting.waitForExistence(timeout: 5)
        XCTAssertEqual(present, expected, "reporting present=\(present), expected=\(expected)")

        let shot = XCTAttachment(screenshot: app.screenshot())
        shot.lifetime = .keepAlways
        shot.name = expected ? "profile-reporting-offered" : "profile-reporting-hidden"
        add(shot)
    }

    private func signIn(_ app: XCUIApplication, username: String, password: String) throws {
        let email = app.textFields["username_textfield"].firstMatch
        XCTAssertTrue(email.waitForExistence(timeout: 10), "sign-in form never appeared")
        email.tap()
        email.typeText(username)

        // A SwiftUI SecureField ignores synthesized input, so the password goes in
        // through the screen's own reveal button, which turns it into a plain field.
        app.buttons.matching(identifier: "password_textfield").firstMatch.tap()
        let revealed = app.textFields.matching(identifier: "password_textfield").firstMatch
        XCTAssertTrue(revealed.waitForExistence(timeout: 5), "password field never became visible")
        revealed.tap()
        XCTAssertTrue(app.keyboards.firstMatch.waitForExistence(timeout: 5), "no keyboard")
        // With the simulator's hardware keyboard disconnected, whatever language
        // the software keyboard is in decides what actually arrives.
        Thread.sleep(forTimeInterval: 1)
        app.typeText(password)
        XCTAssertEqual(revealed.value as? String, password, "password did not land in the field")

        app.buttons["Sign in"].firstMatch.tap()
    }
}

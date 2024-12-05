//
// ThirdPartyMailClient.swift
//
// Copyright (c) 2016-2022 Vincent Tourraine (https://www.vtourraine.net)
//
// Licensed under MIT License

import UIKit

/// Tests third party mail clients availability, and opens third party mail clients in compose mode.
@available(iOSApplicationExtension, unavailable)
@MainActor
open class ThirdPartyMailer {

    /// Tests the availability of a third-party mail client.
    /// - Parameters:
    ///   - client: The third-party client to test.
    /// - Returns: `true` if the application can open the client; otherwise, `false`.
    open class func isMailClientAvailable(_ client: ThirdPartyMailClient) -> Bool {
        var components = URLComponents()
        components.scheme = client.URLScheme

        guard let URL = components.url
            else { return false }

        let application = UIApplication.shared
        return application.canOpenURL(URL)
    }

    /// Opens a third-party mail client.
    /// - Parameters:
    ///   - client: The third-party client to open.
    ///   - completion: The block to execute with the results (optional, default value is `nil`).
    open class func open(
        _ client: ThirdPartyMailClient = .systemDefault,
        completionHandler completion: ( @Sendable (Bool) -> Void)? = nil
    ) {
        let url = client.openURL()
        let application = UIApplication.shared
        application.open(url, options: [:], completionHandler: completion)
    }

    /// Opens a third-party mail client in compose mode.
    /// - Parameters:
    ///   - client: The third-party client to open.
    ///   - recipient: The email address of the recipient (optional, default value is `nil`).
    ///   - subject: The email subject (optional, default value is `nil`).
    ///   - body: The email body (optional, default value is `nil`).
    ///   - cc: The email address of the recipient carbon copy (optional, default value is `nil`).
    ///   - bcc: The email address of the recipient blind carbon copy (optional, default value is `nil`).
    ///   - completion: The block to execute with the results (optional, default value is `nil`).
    open class func openCompose(
        _ client: ThirdPartyMailClient = .systemDefault,
        recipient: String? = nil,
        subject: String? = nil,
        body: String? = nil,
        cc: String? = nil,
        bcc: String? = nil,
        with application: UIApplication = .shared,
        completionHandler completion: (
            @Sendable (Bool) -> Void
        )? = nil
    ) {
        let url = client.composeURL(to: recipient, subject: subject, body: body, cc: cc, bcc: bcc)
        let application = UIApplication.shared
        application.open(url, options: [:], completionHandler: completion)
    }

}

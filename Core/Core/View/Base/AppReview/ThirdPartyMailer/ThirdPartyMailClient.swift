//
//  ThirdPartyMailClient.swift
//  Core
//
//  Created by  Stepanok Ivan on 30.10.2023.
//

import SwiftUI

/// A third-party mail client, offering a custom URL scheme.
public struct ThirdPartyMailClient {

    /// The name of the mail client.
    public let name: String

    /// The custom URL scheme of the mail client.
    public let URLScheme: String

    /// The URL “root” (after the URL scheme and the colon).
    let URLRoot: String?

    /// The URL query items key for the recipient.
    let URLRecipientKey: String?

    /// The URL query items key for the subject, or `nil` if this client doesn’t support setting the subject.
    let URLSubjectKey: String?

    /// The URL query items key for the message body, or `nil` if this client doesn’t support setting the message body.
    let URLBodyKey: String?
    
    let icon: Image?

    public init(name: String, icon: Image?, URLScheme: String, URLRoot: String? = nil, URLRecipientKey: String? = nil, URLSubjectKey: String? = "subject", URLBodyKey: String? = "body") {
        self.name = name
        self.icon = icon
        self.URLScheme = URLScheme
        self.URLRoot = URLRoot
        self.URLRecipientKey = URLRecipientKey
        self.URLSubjectKey = URLSubjectKey
        self.URLBodyKey = URLBodyKey
    }

    /// Returns the open URL for the mail client, based on its custom URL scheme.
    /// - Returns: A `URL` opening the mail client.
    public func openURL() -> URL {
        var components = URLComponents()
        components.scheme = URLScheme
        return components.url!
    }

    /// Returns the compose URL for the mail client, based on its custom URL scheme.
    /// - Parameters:
    ///   - recipient: The recipient for the email message (optional).
    ///   - subject: The subject for the email message (optional).
    ///   - body: The body for the email message (optional).
    ///   - cc: The carbon copy recipient for the email message (optional).
    ///   - bcc: The blind carbon copy recipient for the email message (optional).
    /// - Returns: A `URL` opening the mail client for the given parameters.
    public func composeURL(to recipient: String? = nil, subject: String? = nil, body: String? = nil, cc: String? = nil, bcc: String? = nil) -> URL {
        var components = URLComponents(string: "\(URLScheme):\(URLRoot ?? "")")
        components?.scheme = self.URLScheme

        if URLRecipientKey == nil {
            if let recipient = recipient {
                components = URLComponents(string: "\(URLScheme):\(URLRoot ?? "")\(recipient)")
            }
        }

        var queryItems: [URLQueryItem] = []

        if let recipient = recipient, let URLRecipientKey = URLRecipientKey {
            if URLRecipientKey == ":" {
                // Special format for ProtonMail
                // https://github.com/vtourraine/ThirdPartyMailer/issues/32
                components = URLComponents(string: "\(URLScheme):\(URLRoot ?? ""):\(recipient)")
            }
            else {
                queryItems.append(URLQueryItem(name: URLRecipientKey, value: recipient))
            }
        }

        if let subject = subject, let URLSubjectKey = URLSubjectKey {
            queryItems.append(URLQueryItem(name: URLSubjectKey, value: subject))
        }

        if let body = body, let URLBodyKey = URLBodyKey {
            queryItems.append(URLQueryItem(name: URLBodyKey, value: body))
        }

        if let cc = cc {
            queryItems.append(URLQueryItem(name: "cc", value: cc))
        }

        if let bcc = bcc {
            queryItems.append(URLQueryItem(name: "bcc", value: bcc))
        }

        if queryItems.isEmpty == false {
            components?.queryItems = queryItems
        }

        return components!.url!
    }
}

public extension ThirdPartyMailClient {
    static var systemDefault: ThirdPartyMailClient {
        get {
            // mailto:
            return ThirdPartyMailClient(name: "System Default", icon: Image(.defaultMail),  URLScheme: "mailto")
        }
    }

    /// Returns an array of predefined mail clients.
    static var clients: [ThirdPartyMailClient] {
        get {
            return [
                // sparrow:[to]?subject=[subject]&body=[body]
                ThirdPartyMailClient(name: "Sparrow", icon: nil, URLScheme: "sparrow"),

                // googlegmail:///co?to=[to]&subject=[subject]&body=[body]
                ThirdPartyMailClient(name: "Gmail", icon: Image(.googlegmail), URLScheme: "googlegmail", URLRoot: "///co", URLRecipientKey: "to"),
                
                // x-dispatch:///compose?to=[to]&subject=[subject]&body=[body]
                ThirdPartyMailClient(name: "Dispatch", icon: nil, URLScheme: "x-dispatch", URLRoot: "///compose", URLRecipientKey: "to"),

                // readdle-spark://compose?subject=[subject]&body=[body]&recipient=[recipient]
                ThirdPartyMailClient(name: "Spark", icon: Image(.readdleSpark), URLScheme: "readdle-spark", URLRoot: "//compose", URLRecipientKey: "recipient"),

                // airmail://compose?subject=[subject]&from=[from]&to=[to]&cc=[cc]&bcc=[bcc]&plainBody=[plainBody]&htmlBody=[htmlBody]
                ThirdPartyMailClient(name: "Airmail", icon: Image(.airmail), URLScheme: "airmail", URLRoot: "//compose", URLRecipientKey: "to", URLBodyKey: "plainBody"),

                // ms-outlook://compose?subject=[subject]&body=[body]&to=[to]
                ThirdPartyMailClient(name: "Microsoft Outlook", icon: Image(.msOutlook), URLScheme: "ms-outlook", URLRoot: "//compose", URLRecipientKey: "to"),

                // ymail://mail/compose?subject=[subject]&body=[body]&to=[to]
                ThirdPartyMailClient(name: "Yahoo Mail", icon: Image(.ymail), URLScheme: "ymail", URLRoot: "//mail/compose", URLRecipientKey: "to"),

                // fastmail://mail/compose?subject=[subject]&body=[body]&to=[to]
                ThirdPartyMailClient(name: "Fastmail", icon: Image(.fastmail), URLScheme: "fastmail", URLRoot: "//mail/compose", URLRecipientKey: "to"),

                // protonmail://mailto:foobar@foobar.org?subject=SubjectTitleOfEMail&body=MessageBodyFooBar
                ThirdPartyMailClient(name: "ProtonMail", icon: Image(.proton), URLScheme: "protonmail", URLRoot: "//mailto", URLRecipientKey: ":")
            ]
        }
    }
}

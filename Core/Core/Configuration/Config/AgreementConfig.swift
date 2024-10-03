//
//  AgreementConfig.swift
//  Core
//
//  Created by Muhammad Umer on 11/13/23.
//

import Foundation

private enum AgreementKeys: String, RawStringExtractable {
    case privacyPolicyURL = "PRIVACY_POLICY_URL"
    case tosURL = "TOS_URL"
    case cookiePolicyURL = "COOKIE_POLICY_URL"
    case dataSellContentURL = "DATA_SELL_CONSENT_URL"
    case eulaURL = "EULA_URL"
    case supportedLanguages = "SUPPORTED_LANGUAGES"
}

public class AgreementConfig: NSObject {
    public var privacyPolicyURL: URL?
    public var tosURL: URL?
    public var cookiePolicyURL: URL?
    public var dataSellContentURL: URL?
    public var eulaURL: URL?
    public var supportedLanguages: [String]?

    init(dictionary: [String: AnyObject]) {
        supportedLanguages = dictionary[AgreementKeys.supportedLanguages] as? [String]
        cookiePolicyURL = (dictionary[AgreementKeys.cookiePolicyURL] as? String).flatMap(URL.init)
        dataSellContentURL = (dictionary[AgreementKeys.dataSellContentURL] as? String).flatMap(URL.init)
        eulaURL = (dictionary[AgreementKeys.eulaURL] as? String).flatMap(URL.init)

        super.init()

        if let tosURL = dictionary[AgreementKeys.tosURL.rawValue] as? String {
            self.tosURL = URL(string: completePath(url: tosURL))
        }

        if let privacyPolicyURL = dictionary[AgreementKeys.privacyPolicyURL.rawValue] as? String {
            self.privacyPolicyURL = URL(string: completePath(url: privacyPolicyURL))
        }
    }

    private func completePath(url: String) -> String {
        let langCode = Locale.current.language.languageCode?.identifier ?? ""

        if let supportedLanguages = supportedLanguages,
           !supportedLanguages.contains(langCode) {
            return url
        }

        let URL = URL(string: url)
        let host = URL?.host ?? ""
        let components = url.components(separatedBy: host)

        if components.count != 2 {
            return url
        }

        if let firstComponent = components.first, let lastComponent = components.last {
            return "\(firstComponent)\(host)/\(langCode)\(lastComponent)"
        }

        return url
    }
}

private let key = "AGREEMENT_URLS"
extension Config {
    public var agreement: AgreementConfig {
        return AgreementConfig(dictionary: self[key] as? [String: AnyObject] ?? [:])
    }
}

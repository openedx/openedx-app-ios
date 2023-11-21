//
//  AgreementConfig.swift
//  Core
//
//  Created by Muhammad Umer on 11/13/23.
//

import Foundation

private enum AgreementKeys: String {
    case privacyPolicyURL = "PRIVACY_POLICY_URL"
    case tosURL = "TOS_URL"
}

public class AgreementConfig: NSObject {
    public var privacyPolicyURL: URL?
    public var tosURL: URL?
    
    init(dictionary: [String: AnyObject]) {
        privacyPolicyURL = (dictionary[AgreementKeys.privacyPolicyURL.rawValue] as? String).flatMap(URL.init)
        tosURL = (dictionary[AgreementKeys.tosURL.rawValue] as? String).flatMap(URL.init)
        super.init()
    }
}

private let key = "AGREEMENT_URLS"
extension Config {
    public var agreement: AgreementConfig {
        return AgreementConfig(dictionary: self[key] as? [String: AnyObject] ?? [:])
    }
}

//
//  MicrosoftConfig.swift
//  Core
//
//  Created by Eugene Yatsenko on 22.11.2023.
//

import Foundation

private enum MicrosoftKeys: String {
    case enabled = "ENABLED"
    case appID = "APP_ID"
}

public final class MicrosoftConfig: NSObject {
    public var enabled: Bool = false
    private(set) var appID: String?

    private var requiredKeysAvailable: Bool {
        return appID != nil
    }

    init(dictionary: [String: AnyObject]) {
        appID = dictionary[MicrosoftKeys.appID.rawValue] as? String
        super.init()
        enabled = requiredKeysAvailable && dictionary[MicrosoftKeys.enabled.rawValue] as? Bool == true
    }
}

private let microsoftKey = "MICROSOFT"
extension Config {
    public var microsoft: MicrosoftConfig {
        MicrosoftConfig(dictionary: self[microsoftKey] as? [String: AnyObject] ?? [:])
    }
}

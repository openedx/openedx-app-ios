//
//  MicrosoftConfig.swift
//  Core
//
//  Created by Eugene Yatsenko on 22.11.2023.
//

import Foundation

private enum MicrosoftKeys: String {
    case enabled = "ENABLED"
    case clientID = "CLIENT_ID"
}

public final class MicrosoftConfig: NSObject {
    public var enabled: Bool = false
    private(set) var clientID: String?

    private var requiredKeysAvailable: Bool {
        return clientID != nil
    }

    init(dictionary: [String: AnyObject]) {
        clientID = dictionary[MicrosoftKeys.clientID.rawValue] as? String
        super.init()
        enabled = requiredKeysAvailable && dictionary[MicrosoftKeys.enabled.rawValue] as? Bool == true
    }
}

private let key = "MICROSOFT"
extension Config {
    public var microsoft: MicrosoftConfig {
        MicrosoftConfig(dictionary: self[key] as? [String: AnyObject] ?? [:])
    }
}

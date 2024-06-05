//
//  IAPConfig.swift
//  Core
//
//  Created by Saeed Bashir on 4/29/24.
//

import Foundation

public class IAPConfig: NSObject {

    enum Keys: String, RawStringExtractable {
        case enabled = "enabled"
        case disabledVersions = "ios_disabled_versions"
        case restoreEnabled = "restore_enabled"
    }

    public var enabled: Bool = false
    private var disabledVersions: [String] = []
    public var restoreEnabled: Bool = false
    
    init(dictionary: [String: Any]) {
        enabled = dictionary[Keys.enabled] as? Bool ?? false
        disabledVersions = dictionary[Keys.disabledVersions] as? [String] ?? []
        restoreEnabled = dictionary[Keys.restoreEnabled] as? Bool ?? false
        
        if let info = Bundle.main.infoDictionary,
           let currentVersion = info["CFBundleShortVersionString"] as? String,
           disabledVersions.contains(currentVersion) {
            enabled = false
        }
    }
}

private let Key = "iap_config"

extension ServerConfig {
    public var iapConfig: IAPConfig {
        return IAPConfig(dictionary: config[Key] as? [String: AnyObject] ?? [:])
    }
}

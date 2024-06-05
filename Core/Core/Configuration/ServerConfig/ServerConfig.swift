//
//  ServerConfig.swift
//  Core
//
//  Created by Saeed Bashir on 4/29/24.
//

import Foundation

private enum Keys: String, RawStringExtractable {
    case valuePropEnabled = "value_prop_enabled"
}

public protocol ServerConfigProtocol {
    var valuePropEnabled: Bool { get }
    var iapConfig: IAPConfig { get }
    func initialize(serverConfig: String)
}

public class ServerConfig: ServerConfigProtocol {
    var config: [String: Any] = [:]
    
    public init () {}
    
    public func initialize(serverConfig: String) {
        guard let configData = serverConfig.data(using: .utf8),
              let config = try? JSONSerialization.jsonObject(with: configData, options: []) as? [String: Any]
        else { return }
        
        self.config = config
    }
    
    public var valuePropEnabled: Bool {
        return config[Keys.valuePropEnabled] as? Bool ?? false
    }
}

// Mark - For testing and SwiftUI preview
#if DEBUG
public class ServerConfigProtocolMock: ServerConfigProtocol {
    
    let configString = "{\"iap_config\":{\"enabled\":true,\"experiment_enabled\":false,\"android_product_prefix\":\"mobile.android.usd\",\"allowed_users\":[\"all_users\"]},\"value_prop_enabled\":true,\"feedback_form_url\":\"https://bit.ly/edx-apps-feedback\",\"course_dates_calendar_sync\":{\"ios\":{\"enabled\":true,\"self_paced_enabled\":true,\"instructor_paced_enabled\":true,\"deep_links_enabled\":true},\"android\":{\"enabled\":true,\"self_paced_enabled\":true,\"instructor_paced_enabled\":true,\"deep_links_enabled\":true}}}"
    
    var config: [String: Any] = [:]
    
    public var valuePropEnabled: Bool
    
    public var iapConfig: IAPConfig
    
    public func initialize(serverConfig: String) {
        
    }
    
    public init() {
        valuePropEnabled = false
        iapConfig = IAPConfig(dictionary: ["enabled": true, "restore_enabled": true])
        initialize(serverConfig: configString)
    }
}
#endif
